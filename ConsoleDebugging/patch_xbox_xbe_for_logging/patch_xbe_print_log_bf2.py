#!/usr/bin/env python3
"""
patch_xbe_print_log_bf2.py
==========================
Patch a BF2 Xbox XBE to route Lua print() output to D:\\BFront2.log.

Strategy
--------
1. Overwrite ScriptCB_CancelSessionList (dead GameSpy/online stub) with
   xb_print_log.  That function is never reached on a modded offline console.
   It is solidly inside .text — no section extension needed.
2. Redirect the luaL_Reg "print" function pointer from the original print()
   to xb_print_log.

The injected function
---------------------
  int xb_print_log(lua_State *L)

  Uses one BSS global (zero-initialised):
    g_log_handle  HANDLE  (0 = not opened yet, -1 = failed)

  Algorithm:
    1. n = lua_gettop(L)
    2. If g_log_handle == 0: open D:\\BFront2.log via CreateFile (CREATE_ALWAYS,
       GENERIC_WRITE).  Failure stores -1 so we won't retry.
    3. If handle is valid: for i = 1..n, get string with lua_tolstring.
       Length comes from the TString header 4 bytes before the char* data.
       Write string via the game's internal write wrapper.
    4. Write "\\r\\n" to terminate the line.
    5. Return 0 (Lua convention: no return values).

Calling conventions observed in the binary
-------------------------------------------
    CreateFile wrapper  stdcall 7 args  (ret 0x1c)
    write wrapper       stdcall 5 args  (ret 0x14)
                          (handle, buffer, length, pBytesWritten, segArray)
                          segArray=NULL → plain NtWriteFile, ByteOffset=NULL
                          (sequential write; kernel tracks file position)
    lua_gettop          cdecl 1 arg    (Lua 5.0)
    lua_tolstring       cdecl 3 args   (L, index, len_ptr)

Companion scripts
-----------------
    xbe_scriptcb_analyze.py       generic ScriptCB_ function scanner
    BF2_Xbox_PrintLog_Patch.md    full analysis notes
"""
import struct, shutil, sys, os

OUT_XBE   = "bf2.debug.xbe"
BACKUP    = "default.xbe.bak"
_pos_args = [a for a in sys.argv[1:] if not a.startswith('--')]
IN_XBE    = _pos_args[0] if _pos_args else (BACKUP if os.path.exists(BACKUP) else "default.xbe")

# ---------------------------------------------------------------------------
# XBE parsing + address auto-detection
# ---------------------------------------------------------------------------
# Supports any BF2 Xbox build (base game, DLC, region variants).
# All game-specific VAs are detected from the binary at runtime.

_SECTION_HDR_SIZE = 56

def _parse_xbe(data):
    """Return (base_addr, sections) from XBE header bytes."""
    if data[:4] != b'XBEH':
        raise ValueError(f"Not an XBE file (magic={data[:4]!r})")
    base_addr    = struct.unpack_from('<I', data, 0x104)[0]
    num_sections = struct.unpack_from('<I', data, 0x11C)[0]
    hdrs_va      = struct.unpack_from('<I', data, 0x120)[0]
    hdrs_off     = hdrs_va - base_addr
    sections = []
    for i in range(num_sections):
        o = hdrs_off + i * _SECTION_HDR_SIZE
        flags    = struct.unpack_from('<I', data, o + 0x00)[0]
        va       = struct.unpack_from('<I', data, o + 0x04)[0]
        vsize    = struct.unpack_from('<I', data, o + 0x08)[0]
        raw_off  = struct.unpack_from('<I', data, o + 0x0C)[0]
        raw_size = struct.unpack_from('<I', data, o + 0x10)[0]
        name_va  = struct.unpack_from('<I', data, o + 0x14)[0]
        name_off = name_va - base_addr
        null = data.find(b'\x00', name_off)
        name = data[name_off:null].decode('ascii', errors='replace') if null > name_off else ''
        sections.append(dict(name=name, flags=flags,
                             va=va, vsize=vsize,
                             raw_off=raw_off, raw_size=raw_size))
    return base_addr, sections


def _va_to_foff(va, base_addr, sections):
    for s in sections:
        if s['va'] <= va < s['va'] + s['vsize']:
            return s['raw_off'] + (va - s['va'])
    return None


def _in_any_section(va, sections):
    return any(s['va'] <= va < s['va'] + s['vsize'] for s in sections)


def detect_addresses(data, base_addr, sections):
    """
    Scan a BF2 XBE binary and return all addresses needed by the patcher.

    Detected fields
    ---------------
    GETTOP_VA         lua_gettop (Lua 5.0)  — 14-byte body, address-independent
    CF_WRAPPER        CreateFile wrapper    — 12-byte prologue signature
    WRITE_WRAPPER     write wrapper         — 27-byte prologue signature
    TOSTR_VA          lua_tolstring         — 30-byte prefix (before first rel32)
    INJECT_VA         injection site        — ScriptCB_CancelSessionList via luaL_Reg
    INJECT_FOFF       file offset of INJECT_VA
    INJECT_SPACE      bytes available at injection site
    LREG_FPTR_FOFF    file offset of "print" func ptr in luaL_Reg
    ORIGINAL_PRINT_VA VA of the Lua print() being replaced
    G_HANDLE_VA       zero-init writable slot (BSS preferred, else file-backed zeros)
    """
    v2f = lambda va: _va_to_foff(va, base_addr, sections)
    in_s = lambda va: _in_any_section(va, sections)

    # ── 1. lua_gettop (Lua 5.0): 14-byte body, entirely address-independent ──
    #   mov ecx,[esp+4]; mov eax,[ecx+8]; sub eax,[ecx+0Ch]; sar eax,3; ret
    GT_SIG = bytes.fromhex('8b4c24048b41082b410cc1f803c3')
    idx = data.find(GT_SIG)
    if idx < 0:
        raise ValueError("lua_gettop: signature not found")
    gettop_va = base_addr + idx

    # ── 2. CF_WRAPPER: 12-byte prologue (no embedded addresses) ─────────────
    #   push ebp; mov ebp,esp; sub esp,20h; mov eax,[ebp+18h]; dec eax; push ebx; push esi
    CF_SIG = bytes.fromhex('558bec83ec208b4518485356')
    idx = data.find(CF_SIG)
    if idx < 0:
        raise ValueError("CF_WRAPPER: signature not found")
    cf_wrapper = base_addr + idx

    # ── 3. WRITE_WRAPPER: 27-byte unique prologue ────────────────────────────
    #   Disambiguates from a near-identical sibling via byte 26 (jz +5Ch).
    WW_SIG = bytes.fromhex('558bec83ec10535657'    # push ebp/mov/sub/push*3
                            '8b7d1433db3bfb'         # mov edi,[ebp+14h]; xor ebx,ebx; cmp edi,ebx
                            '7402891f'               # jz +2; mov [edi],ebx
                            '8b75183bf3745c')        # mov esi,[ebp+18h]; cmp esi,ebx; jz +5Ch
    idx = data.find(WW_SIG)
    if idx < 0:
        raise ValueError("write_wrapper: signature not found")
    write_wrapper = base_addr + idx

    # ── 4. TOSTR_VA: lua_tolstring — 30-byte address-independent prefix ──────
    #   First rel32 call appears at byte 30; everything before is register-only.
    TS_SIG = bytes.fromhex('8b54240885d256578b7c240c7e0e'
                            '8b470c8d74d0f83b7708730feb098bc7')
    idx = data.find(TS_SIG)
    if idx < 0:
        raise ValueError("lua_tolstring: signature not found")
    tostr_va = base_addr + idx

    # ── 5. ScriptCB_CancelSessionList → injection site ───────────────────────
    CANCEL_STR = b'ScriptCB_CancelSessionList\x00'
    cancel_str_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        i2 = chunk.find(CANCEL_STR)
        if i2 >= 0:
            cancel_str_va = s['va'] + i2
            break
    if cancel_str_va is None:
        raise ValueError("ScriptCB_CancelSessionList: string not found")

    pat = struct.pack('<I', cancel_str_va)
    inject_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        for j in range(0, len(chunk) - 7, 4):
            if chunk[j:j+4] == pat:
                func_va = struct.unpack_from('<I', chunk, j + 4)[0]
                if in_s(func_va) and func_va != cancel_str_va:
                    inject_va = func_va
                    break
        if inject_va:
            break
    if inject_va is None:
        raise ValueError("ScriptCB_CancelSessionList: luaL_Reg entry not found")

    func_foff = v2f(inject_va)
    inject_space = 256  # safe minimum fallback
    if func_foff is not None:
        for k in range(8192):
            if func_foff + k + 1 >= len(data): break
            if data[func_foff + k] == 0xC3 and data[func_foff + k + 1] == 0xCC:
                inject_space = k + 1
                break

    # ── 6. "print" luaL_Reg → LREG_FPTR_FOFF + ORIGINAL_PRINT_VA ───────────
    print_str_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        pos = 0
        while True:
            i3 = chunk.find(b'print\x00', pos)
            if i3 < 0:
                break
            if i3 == 0 or chunk[i3 - 1] == 0:
                print_str_va = s['va'] + i3
                break
            pos = i3 + 1
        if print_str_va:
            break
    if print_str_va is None:
        raise ValueError('"print": string not found')

    pat2 = struct.pack('<I', print_str_va)
    lreg_fptr_foff = None
    orig_print_va  = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        for j in range(0, len(chunk) - 7, 4):
            if chunk[j:j+4] == pat2:
                func_va = struct.unpack_from('<I', chunk, j + 4)[0]
                if in_s(func_va) and func_va != print_str_va:
                    lreg_fptr_foff = s['raw_off'] + j + 4
                    orig_print_va  = func_va
                    break
        if lreg_fptr_foff:
            break
    if lreg_fptr_foff is None:
        raise ValueError('"print": luaL_Reg entry not found')

    # ── 7. G_HANDLE_VA: unreferenced zero-init slot ──────────────────────────
    # Build a set of all 4-byte values embedded in non-writable (code) sections.
    code_vals = set()
    for s in sections:
        if s['flags'] & 0x01:
            continue  # skip writable
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        for j in range(0, len(chunk) - 3, 4):
            code_vals.add(struct.unpack_from('<I', chunk, j)[0])

    writable = [s for s in sections if s['flags'] & 0x01]
    ordered  = sorted(writable, key=lambda s: (s['name'] != '.data', s['va']))

    g_handle_va = None
    # Prefer BSS (virtual-only extension of writable section) — guaranteed zero at boot.
    for s in ordered:
        if s['vsize'] <= s['raw_size']:
            continue  # no BSS extension
        bss_start = s['va'] + s['raw_size']
        bss_end   = s['va'] + s['vsize']
        # Skip the first 0x100 bytes of BSS (may be adjacent to initialised globals).
        scan_start = (bss_start + 0x100 + 7) & ~7
        for va in range(scan_start, min(bss_end - 8, scan_start + 0x10000), 8):
            if va not in code_vals and (va + 4) not in code_vals:
                g_handle_va = va
                break
        if g_handle_va:
            break

    # Fall back: file-backed zero block in writable section.
    if g_handle_va is None:
        for s in ordered:
            chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
            for j in range(0x100, len(chunk) - 15, 4):
                if any(chunk[j : j + 16]):
                    continue
                va = s['va'] + j
                if va not in code_vals and (va + 4) not in code_vals:
                    g_handle_va = va
                    break
            if g_handle_va:
                break

    if g_handle_va is None:
        raise ValueError("G_HANDLE_VA: no safe zero-init slot found")

    return dict(
        GETTOP_VA         = gettop_va,
        CF_WRAPPER        = cf_wrapper,
        WRITE_WRAPPER     = write_wrapper,
        TOSTR_VA          = tostr_va,
        INJECT_VA         = inject_va,
        INJECT_FOFF       = v2f(inject_va),
        INJECT_SPACE      = inject_space,
        LREG_FPTR_FOFF    = lreg_fptr_foff,
        ORIGINAL_PRINT_VA = orig_print_va,
        G_HANDLE_VA       = g_handle_va,
    )


# ---------------------------------------------------------------------------
# Data constants (patch content — independent of target XBE)
# ---------------------------------------------------------------------------

LOG_PATH  = b"D:\\BFront2.log\x00"   # 15 bytes
CRLF      = b"\r\n"                   #  2 bytes

# Game-specific addresses — set by detect_addresses() before assemble() is called.
INJECT_VA      = None
INJECT_FOFF    = None
G_HANDLE_VA    = None
CF_WRAPPER     = None
WRITE_WRAPPER  = None
GETTOP_VA      = None
TOSTR_VA       = None
LREG_FPTR_FOFF = None

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def rel32(from_va, to_va):
    """Compute rel32 so that E8 rel32 at from_va calls to_va."""
    return (to_va - (from_va + 5)) & 0xFFFFFFFF

def pack32(v):
    return struct.pack("<I", v & 0xFFFFFFFF)

def packs32(v):
    return struct.pack("<i", v)

# ---------------------------------------------------------------------------
# Build machine code
# ---------------------------------------------------------------------------
# Layout within the injected region (all VAs relative to INJECT_VA):
#
#   0x000  xb_print_log function body
#   0x???  string literal: "D:\BFront2.log\0"  (15 bytes)
#   0x???  string literal: "\r\n"              (2 bytes)

def assemble():
    code = bytearray()
    labels = {}

    def here():
        return len(code)

    def emit(b):
        code.extend(b)

    def patch_i8(pos, val):
        code[pos] = val & 0xFF

    def patch_i32(pos, val):
        code[pos:pos+4] = struct.pack("<i", val)

    # --- Function prologue ---
    emit(b'\x55')                   # push ebp
    emit(b'\x8b\xec')              # mov  ebp, esp
    emit(b'\x83\xec\x0c')          # sub  esp, 12  ([ebp-4]=str, [ebp-8]=len, [ebp-12]=BW)
    emit(b'\x53')                   # push ebx
    emit(b'\x56')                   # push esi
    emit(b'\x57')                   # push edi
    emit(b'\x8b\x75\x08')          # mov  esi, [ebp+8]  ; esi = L

    # ebx = lua_gettop(L)
    emit(b'\x56')                   # push esi
    cf_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call lua_gettop
    emit(b'\x83\xc4\x04')          # add  esp, 4
    emit(b'\x8b\xd8')              # mov  ebx, eax      ; ebx = n

    # edi = 1
    emit(b'\xbf\x01\x00\x00\x00') # mov  edi, 1

    # --- loop_top ---
    labels['loop_top'] = here()

    emit(b'\x3b\xfb')              # cmp  edi, ebx
    jg_pos = here(); emit(b'\x0f\x8f\x00\x00\x00\x00')  # jg write_newline [FWD, near]

    # s = lua_tolstring(L, i, NULL)
    emit(b'\x6a\x00')               # push 0 (len pointer = NULL)
    emit(b'\x57')                   # push edi
    emit(b'\x56')                   # push esi
    cs_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call TOSTR_VA
    emit(b'\x83\xc4\x0c')          # add  esp, 12 (3 args)
    emit(b'\x85\xc0')              # test eax, eax
    jz_pos = here(); emit(b'\x74\x00')  # jz next_arg [FWD]

    # len = *(eax-4)  (Lua 5.0 TString: length field 4 bytes before char* data)
    emit(b'\x8b\x48\xfc')          # mov  ecx, [eax-4]
    emit(b'\x89\x4d\xf8')          # mov  [ebp-8], ecx  ; save len
    emit(b'\x89\x45\xfc')          # mov  [ebp-4], eax  ; save str ptr

    # edx = g_log_handle
    emit(b'\x8b\x15' + pack32(G_HANDLE_VA))  # mov edx, [G_HANDLE_VA]
    emit(b'\x85\xd2')              # test edx, edx
    jnz_pos = here(); emit(b'\x75\x00')  # jnz handle_ready [FWD]

    # Open file (g_log_handle == 0, first call only)
    # CreateFile(path, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL)
    emit(b'\x6a\x00')              # push 0  (hTemplate)
    emit(b'\x6a\x00')              # push 0  (FlagsAndAttribs)
    emit(b'\x6a\x02')              # push 2  (CREATE_ALWAYS)
    emit(b'\x6a\x00')              # push 0  (SecurityAttribs)
    emit(b'\x6a\x00')              # push 0  (ShareMode)
    emit(b'\x68\x00\x00\x00\x40') # push 0x40000000  (GENERIC_WRITE)
    logpath_push_pos = here()
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push log_path_va [PATCH]
    cf2_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call CF_WRAPPER (stdcall 7)
    emit(b'\xa3' + pack32(G_HANDLE_VA))  # mov [G_HANDLE_VA], eax
    emit(b'\x8b\xd0')              # mov  edx, eax
    emit(b'\x83\xfa\xff')          # cmp  edx, -1
    jfail1 = here(); emit(b'\x74\x00')  # je next_arg [FWD]

    # --- handle_ready ---
    labels['handle_ready'] = here()
    patch_i8(jnz_pos + 1, labels['handle_ready'] - (jnz_pos + 2))

    emit(b'\x83\xfa\xff')          # cmp  edx, -1
    jfail2 = here(); emit(b'\x74\x00')  # je next_arg [FWD]

    # write_wrapper(handle, str, len, &BW, NULL)
    emit(b'\x6a\x00')              # push 0  (segArray = NULL)
    emit(b'\x8d\x45\xf4')          # lea  eax, [ebp-12]
    emit(b'\x50')                   # push eax (pBytesWritten)
    emit(b'\xff\x75\xf8')          # push dword ptr [ebp-8] (len)
    emit(b'\xff\x75\xfc')          # push dword ptr [ebp-4] (str)
    emit(b'\x52')                   # push edx (handle)
    cw_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call WRITE_WRAPPER

    # --- next_arg ---
    labels['next_arg'] = here()
    patch_i8(jz_pos  + 1, labels['next_arg'] - (jz_pos  + 2))
    patch_i8(jfail1  + 1, labels['next_arg'] - (jfail1  + 2))
    patch_i8(jfail2  + 1, labels['next_arg'] - (jfail2  + 2))

    emit(b'\x47')                   # inc  edi
    loop_back = here(); emit(b'\xe9\x00\x00\x00\x00')  # jmp loop_top [near]
    patch_i32(loop_back + 1, labels['loop_top'] - (loop_back + 5))

    # --- write_newline ---
    labels['write_newline'] = here()
    patch_i32(jg_pos + 2, labels['write_newline'] - (jg_pos + 6))

    emit(b'\x8b\x15' + pack32(G_HANDLE_VA))  # mov edx, [G_HANDLE_VA]
    emit(b'\x85\xd2')              # test edx, edx
    jz2 = here(); emit(b'\x74\x00')  # jz done [FWD]
    emit(b'\x83\xfa\xff')          # cmp  edx, -1
    je2 = here(); emit(b'\x74\x00')  # je done [FWD]

    # write_wrapper(handle, crlf, 2, &BW, NULL)
    emit(b'\x6a\x00')              # push 0 (segArray)
    emit(b'\x8d\x45\xf4')          # lea eax, [ebp-12]
    emit(b'\x50')                   # push eax (pBytesWritten)
    emit(b'\x6a\x02')              # push 2 (length)
    crlf_va_pos = here()
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push crlf_va [PATCH]
    emit(b'\x52')                   # push edx (handle)
    cw2_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call WRITE_WRAPPER

    # --- done ---
    labels['done'] = here()
    patch_i8(jz2 + 1, labels['done'] - (jz2 + 2))
    patch_i8(je2 + 1, labels['done'] - (je2 + 2))

    emit(b'\x5f')                   # pop  edi
    emit(b'\x5e')                   # pop  esi
    emit(b'\x5b')                   # pop  ebx
    emit(b'\x33\xc0')              # xor  eax, eax      ; return 0
    emit(b'\xc9')                   # leave
    emit(b'\xc3')                   # ret

    func_len = len(code)

    # --- Append string literals ---
    logpath_offset = func_len
    code.extend(LOG_PATH)
    crlf_offset = func_len + len(LOG_PATH)
    code.extend(CRLF)

    # --- Patch string VAs ---
    log_path_va = INJECT_VA + logpath_offset
    crlf_va     = INJECT_VA + crlf_offset
    code[logpath_push_pos+1 : logpath_push_pos+5] = pack32(log_path_va)
    code[crlf_va_pos+1      : crlf_va_pos+5     ] = pack32(crlf_va)

    # --- Patch call rel32s ---
    def callpatch(pos, target):
        code[pos+1:pos+5] = packs32(target - (INJECT_VA + pos + 5))

    callpatch(cf_pos,  GETTOP_VA)
    callpatch(cs_pos,  TOSTR_VA)
    callpatch(cf2_pos, CF_WRAPPER)
    callpatch(cw_pos,  WRITE_WRAPPER)
    callpatch(cw2_pos, WRITE_WRAPPER)

    return bytes(code)


# ---------------------------------------------------------------------------
# Load XBE, detect addresses, assemble and patch
# ---------------------------------------------------------------------------

with open(IN_XBE, "rb") as f:
    data = bytearray(f.read())

_base_addr, _sections = _parse_xbe(data)
addrs = detect_addresses(data, _base_addr, _sections)

# Publish to module globals so assemble() can reference them.
INJECT_VA      = addrs['INJECT_VA']
INJECT_FOFF    = addrs['INJECT_FOFF']
G_HANDLE_VA    = addrs['G_HANDLE_VA']
CF_WRAPPER     = addrs['CF_WRAPPER']
WRITE_WRAPPER  = addrs['WRITE_WRAPPER']
GETTOP_VA      = addrs['GETTOP_VA']
TOSTR_VA       = addrs['TOSTR_VA']
LREG_FPTR_FOFF = addrs['LREG_FPTR_FOFF']

print(f"Detected addresses:")
print(f"  lua_gettop      VA 0x{GETTOP_VA:08X}")
print(f"  lua_tolstring   VA 0x{TOSTR_VA:08X}")
print(f"  CF_WRAPPER      VA 0x{CF_WRAPPER:08X}")
print(f"  WRITE_WRAPPER   VA 0x{WRITE_WRAPPER:08X}")
print(f"  Inject site     VA 0x{INJECT_VA:08X}  foff 0x{INJECT_FOFF:08X}  space {addrs['INJECT_SPACE']}B")
print(f"  G_HANDLE_VA     VA 0x{G_HANDLE_VA:08X}")
print(f"  print lreg foff    0x{LREG_FPTR_FOFF:08X}  orig VA 0x{addrs['ORIGINAL_PRINT_VA']:08X}")

code = assemble()
print(f"\nInjected function size: {len(code)} bytes  (space available: {addrs['INJECT_SPACE']})")
assert len(code) <= addrs['INJECT_SPACE'], \
    f"Code too large for injection slot ({len(code)} > {addrs['INJECT_SPACE']})!"

# 1. Backup
if not os.path.exists(BACKUP):
    shutil.copy2(IN_XBE, BACKUP)
    print(f"\nBackup: {BACKUP}")
else:
    print(f"\nBackup exists: {BACKUP}")

# 2. Inject function code (overwrites ScriptCB_CancelSessionList dead stub)
data[INJECT_FOFF : INJECT_FOFF + len(code)] = code
print(f"Injected {len(code)} bytes at file:0x{INJECT_FOFF:08X} (VA:0x{INJECT_VA:08X})")

# 3. Verify and patch the luaL_Reg print entry
old_fptr = struct.unpack_from("<I", data, LREG_FPTR_FOFF)[0]
assert old_fptr == addrs['ORIGINAL_PRINT_VA'], \
    f"Expected print fptr 0x{addrs['ORIGINAL_PRINT_VA']:08X}, got 0x{old_fptr:08X}"
struct.pack_into("<I", data, LREG_FPTR_FOFF, INJECT_VA)
print(f"Patched luaL_Reg print fptr: 0x{old_fptr:08X} -> 0x{INJECT_VA:08X}")

# ---------------------------------------------------------------------------
# Write output
# ---------------------------------------------------------------------------
with open(OUT_XBE, "wb") as f:
    f.write(data)
print(f"\nPatched XBE written: {OUT_XBE}")
print("print() output will be written to D:\\BFront2.log on a modded Xbox.")
