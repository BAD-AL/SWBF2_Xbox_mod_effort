#!/usr/bin/env python3
"""
patch_xbe_print_log_bf1.py
==========================
Patch default.xbe (Star Wars Battlefront 1, Xbox) to route Lua
print() output to <GameFolder>\\BFront1.log.

Strategy
--------
1. Overwrite ScriptCB_DoFriendAction (VA 0x3ADD0, 899 bytes available)
   with xb_print_log.  This function is an Xbox Live friends stub — it is
   never called on a softmodded offline console.  It sits inside .text with
   no section extension required.
2. Redirect the luaL_Reg "print" function pointer from the original print()
   (VA 0x1EF020, at file offset 0x32E524) to xb_print_log (VA 0x3ADD0).

The injected function
---------------------
  int xb_print_log(lua_State *L)

  Uses one .data global (zero-initialised):
    0x34F700  g_log_handle  HANDLE  (0 = not opened yet, -1 = failed)

  Algorithm:
    1. n = lua_gettop(L)
    2. If g_log_handle == 0: open D:\\BFront1.log via CreateFile
       (CREATE_ALWAYS, GENERIC_READ|GENERIC_WRITE).  Failure stores -1.
    3. If handle is valid: for i = 1..n, read the Lua stack directly
       (L->Cbase at L+0x10; TObject at Cbase+(i-1)*8; char* = *(TObject+4)+0x14).
       Only LUA_TSTRING args (ttype=3) are written; others are skipped.
       Length computed via inline strlen.  NtWriteFile used directly.
    4. Write "\\r\\n" to terminate the line.
    5. Return 0 (Lua convention: no return values).

Lua version differences (4.0 vs 5.0 / BF1 vs BF2)
----------------------------------------------------
  * lua_tostring takes TWO arguments (L, index) — no len_ptr parameter.
    BF2 used lua_tolstring(L, index, NULL) which required a third push.
  * TString layout: header is 20 bytes; char* = TString + 0x14.
    [char* - 4] is the nexthash chain pointer (often NULL), NOT the length
    field (unlike BF2's Lua 5.0 TString).  Length is computed via inline
    strlen — safe for all printable game strings (no embedded NULs).
  * LUA_TSTRING type tag = 3 (confirmed from binary).

Calling conventions observed in the binary
-------------------------------------------
    Symbol                VA          Conv     Args  Notes
    ──────────────────────────────────────────────────────────────────────
    CreateFile wrapper    0x001AB4B0  stdcall  7     ret 0x1C
    write_wrapper         0x001AB7FA  stdcall  5     ret 0x14
                            (handle, buffer, length, pBytesWritten, segArray)
                            segArray=NULL → plain NtWriteFile, ByteOffset=NULL
                            pBytesWritten must be non-NULL (provide local ptr)
    lua_gettop            0x001EA420  cdecl    1
    lua_tostring          0x001EA770  cdecl    2     (L, index) → char*/NULL

    NtWriteFile kernel slot: VA 0x00303B00  (ordinal 236, for reference)

    luaL_Reg "print" entry: file offset 0x32E520
      name_va  → 0x0033E0E0  ("print")
      func_va  → 0x001EF020  (original) → patched to 0x0003ADD0

Injection site: ScriptCB_DoFriendAction
----------------------------------------
    VA   0x0003ADD0   (file offset 0x0002ADD0)
    Size 899 bytes available; injected code ≈ 201 bytes.
    Confirmed via luaL_Reg decode: used only by Xbox Live friend-list code,
    never reached on a softmodded offline console.

Global for file handle
-----------------------
    VA 0x0034F700 — in the writable .data section (flags 0x07, WRITABLE bit 0
    set).  Verified: zero in the XBE file, not among the 260 .data addresses
    referenced by code, surrounded by 12+ bytes of zeros.

    Why not the injection block (.text)?  .text flags are 0x36 (EXECUTABLE,
    NOT WRITABLE — bit 0 = 0).  Storing the handle there faults on the first
    write, creating the file but writing nothing.

    Why not 0x0035F7C0 (original choice)?  It is element [0][0] of a second
    4x4 float matrix immediately after the identity matrix at 0x35F780 and has
    13 code references including a rep-stosd that initialises the block.
    Storing a HANDLE there corrupted the renderer → black screen.

"""
import struct, shutil, sys, os

OUT_XBE  = "bf1.debug.xbe"
BACKUP   = "default.xbe.bak"
_default = "default.xbe"
_pos_args = [a for a in sys.argv[1:] if not a.startswith('--')]
IN_XBE   = _pos_args[0] if _pos_args else (BACKUP if os.path.exists(BACKUP) else _default)

# ---------------------------------------------------------------------------
# XBE parsing + address auto-detection
# ---------------------------------------------------------------------------
# Supports any BF1 Xbox build (base game, DLC, region variants).
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
    Scan an XBE binary and return all addresses needed by the patcher.

    Detected fields
    ---------------
    GETTOP_VA         lua_gettop       — full 13-byte body (address-independent)
    CF_WRAPPER        CreateFile wrap  — 12-byte prologue signature
    NT_WRITE_FILE     NtWriteFile slot — first FF 15 target inside write_wrapper
    INJECT_VA         injection site   — ScriptCB_DoFriendAction via luaL_Reg
    INJECT_FOFF       file offset of INJECT_VA
    INJECT_SPACE      bytes available at injection site
    LREG_FPTR_FOFF    file offset of "print" func ptr in luaL_Reg
    ORIGINAL_PRINT_VA VA of the Lua print() being replaced
    G_HANDLE_VA       safe writable .data slot (8 bytes, zero-filled, unreferenced)
    """
    v2f = lambda va: _va_to_foff(va, base_addr, sections)
    in_s = lambda va: _in_any_section(va, sections)

    # ── 1. lua_gettop: full 13-byte body, entirely address-independent ───────
    #   mov ecx,[esp+4]; mov eax,[ecx]; sub eax,[ecx+10h]; sar eax,3; ret
    GT_SIG = bytes.fromhex('8b4c24048b012b4110c1f803c3')
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

    # ── 3. NT_WRITE_FILE: find write_wrapper (27-byte unique prologue), ──────
    #       then extract its first FF 15 target (NtWriteFile thunk VA).
    #   The 27-byte signature distinguishes write_wrapper from a near-identical
    #   sibling function — they share the first 26 bytes but differ at byte 26
    #   (jz +5Ch for write_wrapper vs jz +68h for the sibling).
    WW_SIG = bytes.fromhex('558bec83ec10535657'    # push ebp/mov/sub/push*3
                            '8b7d1433db3bfb'         # mov edi,[ebp+14h]; xor ebx,ebx; cmp edi,ebx
                            '7402891f'               # jz +2; mov [edi],ebx
                            '8b75183bf3745c')        # mov esi,[ebp+18h]; cmp esi,ebx; jz +5Ch
    idx = data.find(WW_SIG)
    if idx < 0:
        raise ValueError("write_wrapper: signature not found")
    ntw_va = None
    for j in range(150 - 5):
        if data[idx + j] == 0xFF and data[idx + j + 1] == 0x15:
            va = struct.unpack_from('<I', data, idx + j + 2)[0]
            if in_s(va):
                ntw_va = va
                break
    if ntw_va is None:
        raise ValueError("NT_WRITE_FILE: FF 15 call not found in write_wrapper")

    # ── 4. ScriptCB_DoFriendAction → injection site ──────────────────────────
    FRIEND_STR = b'ScriptCB_DoFriendAction\x00'
    friend_str_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        i2 = chunk.find(FRIEND_STR)
        if i2 >= 0:
            friend_str_va = s['va'] + i2
            break
    if friend_str_va is None:
        raise ValueError("ScriptCB_DoFriendAction: string not found")

    pat = struct.pack('<I', friend_str_va)
    inject_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        for j in range(0, len(chunk) - 7, 4):
            if chunk[j:j+4] == pat:
                func_va = struct.unpack_from('<I', chunk, j + 4)[0]
                if in_s(func_va) and func_va != friend_str_va:
                    inject_va = func_va
                    break
        if inject_va:
            break
    if inject_va is None:
        raise ValueError("ScriptCB_DoFriendAction: luaL_Reg entry not found")

    func_foff = v2f(inject_va)
    inject_space = 256  # safe minimum fallback
    if func_foff is not None:
        for k in range(8192):
            if func_foff + k + 1 >= len(data): break
            if data[func_foff + k] == 0xC3 and data[func_foff + k + 1] == 0xCC:
                inject_space = k + 1
                break

    # ── 5. "print" luaL_Reg → LREG_FPTR_FOFF + ORIGINAL_PRINT_VA ───────────
    # Search for null-terminated "print\0" not part of a longer word
    print_str_va = None
    for s in sections:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        pos = 0
        while True:
            i3 = chunk.find(b'print\x00', pos)
            if i3 < 0:
                break
            if i3 == 0 or chunk[i3 - 1] == 0:   # preceded by \0 or at section start
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

    # ── 6. G_HANDLE_VA: writable .data slot, zero-filled, unreferenced ───────
    # Build a set of all 4-byte aligned values in non-writable (code) sections.
    # Any candidate VA that doesn't appear in this set is unlikely to be a
    # hardcoded address in compiled code.
    code_vals = set()
    for s in sections:
        if s['flags'] & 0x01:
            continue   # skip writable
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        for j in range(0, len(chunk) - 3, 4):
            code_vals.add(struct.unpack_from('<I', chunk, j)[0])

    # Prefer the section named ".data"; fall back to the first writable section
    # that contains a large-enough zero block.
    writable = [s for s in sections if s['flags'] & 0x01]
    ordered  = sorted(writable, key=lambda s: (s['name'] != '.data', s['va']))
    g_handle_va = None
    for s in ordered:
        chunk = data[s['raw_off'] : s['raw_off'] + s['raw_size']]
        # Skip the first 0x100 bytes (likely initialised globals at section start).
        for j in range(0x100, len(chunk) - 15, 4):
            if any(chunk[j : j + 16]):
                continue   # need 16 consecutive zero bytes (covers HANDLE + counter + guard)
            va = s['va'] + j
            if va not in code_vals and (va + 4) not in code_vals:
                g_handle_va = va
                break
        if g_handle_va:
            break
    if g_handle_va is None:
        raise ValueError("G_HANDLE_VA: no safe zero-filled slot found in writable .data")

    return dict(
        GETTOP_VA         = gettop_va,
        CF_WRAPPER        = cf_wrapper,
        NT_WRITE_FILE     = ntw_va,
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

LOG_PATH = b"D:\\BFront1.log\x00"  # 15 bytes — D:\ maps to the XBE's directory
CRLF     = b"\r\n"                  #  2 bytes
TAB      = b"\t"                    #  1 byte  — separator between print() args

# Game-specific addresses — set by detect_addresses() before assemble() is called.
INJECT_VA      = None
INJECT_FOFF    = None
G_HANDLE_VA    = None
G_COUNTER_VA   = None
CF_WRAPPER     = None
NT_WRITE_FILE  = None
GETTOP_VA      = None
LREG_FPTR_FOFF = None

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def rel32(from_va, to_va):
    """rel32 displacement for an E8 call at from_va targeting to_va."""
    return (to_va - (from_va + 5)) & 0xFFFFFFFF

def pack32(v):
    return struct.pack("<I", v & 0xFFFFFFFF)

def packs32(v):
    return struct.pack("<i", v)

# ---------------------------------------------------------------------------
# Assemble xb_print_log
# ---------------------------------------------------------------------------
# Memory layout within the injected region (VAs relative to INJECT_VA):
#
#   0x000  xb_print_log function body
#   0x???  string literal: "D:\BFront1.log\0"  (15 bytes)
#   0x???  string literal: "\r\n"              (2 bytes)
#
# Key difference from BF2: lua_tostring takes 2 args (L, index), not 3.
# The extra "push 0" (len_ptr) from the BF2 patch is absent here, and the
# caller cleanup changes from "add esp, 12" to "add esp, 8".

def assemble():
    code   = bytearray()
    labels = {}

    def here():        return len(code)
    def emit(b):       code.extend(b)
    def patch_i8(pos, val):   code[pos] = val & 0xFF
    def patch_i32(pos, val):  code[pos:pos+4] = struct.pack("<i", val)

    # --- Prologue ---
    emit(b'\x55')                    # push ebp
    emit(b'\x8b\xec')               # mov  ebp, esp
    emit(b'\x83\xec\x10')           # sub  esp, 16  ; [ebp-4]=str,[ebp-8]=len,[ebp-12..ebp-5]=iosb
    emit(b'\x53')                    # push ebx
    emit(b'\x56')                    # push esi
    emit(b'\x57')                    # push edi
    emit(b'\x8b\x75\x08')           # mov  esi, [ebp+8]  ; esi = L

    # ebx = lua_gettop(L)  [cdecl: caller pushes, caller cleans]
    emit(b'\x56')                    # push esi
    cf_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call lua_gettop
    emit(b'\x83\xc4\x04')           # add  esp, 4
    emit(b'\x8b\xd8')               # mov  ebx, eax    ; ebx = n

    # edi = 1 (loop index)
    emit(b'\xbf\x01\x00\x00\x00')  # mov  edi, 1

    # --- loop_top ---
    labels['loop_top'] = here()

    emit(b'\x3b\xfb')               # cmp  edi, ebx
    jg_pos = here(); emit(b'\x0f\x8f\x00\x00\x00\x00')  # jg write_newline [FWD, near]

    # Direct Lua 4.0 stack access (avoids lua_tostring call entirely).
    # Confirmed from lua_tostring disassembly (VA 0x1EA770):
    #   L->Cbase = [L+0x10]  (offset 16 in lua_State)
    #   TObject  = 8 bytes   (ttype:4 at +0, value:4 at +4)
    #   LUA_TSTRING = 3
    #   char*    = *(TObject+4) + 0x14   (TString header = 20 bytes)
    # Non-string args (numbers, tables) are silently skipped — safe for
    # game Lua scripts.  Bypasses luaO_tostring → luaS_new → GC path
    # which could interact with the journal and trigger write_wrapper.
    emit(b'\x8b\x56\x10')           # mov  edx, [esi+0x10]     ; edx = L->Cbase
    emit(b'\x8d\x4c\xfa\xf8')      # lea  ecx, [edx+edi*8-8]  ; ecx = &TObject[i-1]
    emit(b'\x83\x39\x03')           # cmp  dword ptr [ecx], 3  ; ttype == LUA_TSTRING?
    jne_pos = here(); emit(b'\x0f\x85\x00\x00\x00\x00')  # jne next_arg [FWD, near — distance > 127]
    emit(b'\x8b\x41\x04')           # mov  eax, [ecx+4]        ; eax = TString*
    emit(b'\x83\xc0\x14')           # add  eax, 0x14           ; eax = char* (skip header)

    # len = strlen(eax)  [inline; avoids TString header layout dependency]
    # Lua 4.0 TString char*-4 appears to be the nexthash chain pointer (often
    # NULL), not the length field — so we cannot use [char*-4] as in BF2.
    # Lua strings are null-terminated and game strings contain no embedded
    # nulls, so strlen gives the correct result.
    #
    #   ecx = 0
    # .lp: cmp byte [eax+ecx], 0
    #       je  .done
    #       inc ecx
    #       jmp .lp
    # .done:                         ; ecx = length
    emit(b'\x33\xc9')               # xor  ecx, ecx
    emit(b'\x80\x3c\x08\x00')       # cmp  byte [eax+ecx], 0
    emit(b'\x74\x03')               # je   +3 (done)
    emit(b'\x41')                    # inc  ecx
    emit(b'\xeb\xf7')               # jmp  -9 (lp)
    emit(b'\x89\x4d\xf8')           # mov  [ebp-8], ecx  ; save len
    emit(b'\x89\x45\xfc')           # mov  [ebp-4], eax  ; save str ptr

    # edx = g_log_handle
    emit(b'\x8b\x15' + pack32(G_HANDLE_VA))  # mov edx, [G_HANDLE_VA]
    emit(b'\x85\xd2')               # test edx, edx
    jnz_pos = here(); emit(b'\x75\x00')  # jnz handle_ready [FWD]

    # Open log file (first call only; g_log_handle == 0)
    # CreateFile(path, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL)
    emit(b'\x6a\x00')               # push 0   (hTemplate)
    emit(b'\x6a\x00')               # push 0   (FlagsAndAttribs)
    emit(b'\x6a\x02')               # push 2   (CREATE_ALWAYS)
    emit(b'\x6a\x00')               # push 0   (SecurityAttribs)
    emit(b'\x6a\x00')               # push 0   (ShareMode)
    emit(b'\x68\x00\x00\x00\x40')  # push 0x40000000  (GENERIC_WRITE)
    logpath_push_pos = here()
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push log_path_va [PATCH]
    cf2_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call CF_WRAPPER (stdcall 7)
    emit(b'\xa3' + pack32(G_HANDLE_VA))   # mov  [G_HANDLE_VA], eax
    emit(b'\x8b\xd0')               # mov  edx, eax
    emit(b'\x83\xfa\xff')           # cmp  edx, -1
    jfail1 = here(); emit(b'\x74\x00')   # je next_arg [FWD]

    # --- handle_ready ---
    labels['handle_ready'] = here()
    patch_i8(jnz_pos + 1, labels['handle_ready'] - (jnz_pos + 2))

    emit(b'\x83\xfa\xff')           # cmp  edx, -1
    jfail2 = here(); emit(b'\x74\x00')   # je next_arg [FWD]

    # NtWriteFile(handle, NULL, NULL, NULL, &iosb, str, len, NULL)  [stdcall 8 args]
    # &iosb = [ebp-12]: IO_STATUS_BLOCK {Status=[ebp-12], Information=[ebp-8]}... wait,
    # iosb is 8 bytes at [ebp-12]..[ebp-5]: Status at [ebp-12], Information at [ebp-8].
    # Reuse [ebp-8] (len) only AFTER it's already been pushed onto the NtWriteFile arg stack.
    emit(b'\x6a\x00')               # push 0        (ByteOffset = NULL → sequential write)
    emit(b'\xff\x75\xf8')           # push [ebp-8]  (Length = len)
    emit(b'\xff\x75\xfc')           # push [ebp-4]  (Buffer = str)
    emit(b'\x8d\x45\xf4')           # lea  eax, [ebp-12] (&iosb)
    emit(b'\x50')                    # push eax      (IoStatusBlock)
    emit(b'\x6a\x00')               # push 0        (ApcContext)
    emit(b'\x6a\x00')               # push 0        (ApcRoutine)
    emit(b'\x6a\x00')               # push 0        (Event)
    emit(b'\x52')                    # push edx      (FileHandle)
    emit(b'\xff\x15' + pack32(NT_WRITE_FILE))  # call dword ptr [NtWriteFile]

    # --- write \t separator if more args follow (matches Lua print() behaviour) ---
    emit(b'\x3b\xfb')               # cmp  edi, ebx
    jge_tab = here(); emit(b'\x7d\x00')  # jge next_arg [FWD]  ; last arg — skip tab
    emit(b'\x8b\x15' + pack32(G_HANDLE_VA))  # mov edx, [G_HANDLE_VA]  ; reload (NtWriteFile clobbers edx)
    emit(b'\x6a\x00')               # push 0   (ByteOffset = NULL)
    emit(b'\x6a\x01')               # push 1   (Length)
    tab_va_pos = here()
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push tab_va [PATCH]
    emit(b'\x8d\x45\xf4')           # lea  eax, [ebp-12] (&iosb)
    emit(b'\x50')                    # push eax
    emit(b'\x6a\x00')               # push 0   (ApcContext)
    emit(b'\x6a\x00')               # push 0   (ApcRoutine)
    emit(b'\x6a\x00')               # push 0   (Event)
    emit(b'\x52')                    # push edx (FileHandle)
    emit(b'\xff\x15' + pack32(NT_WRITE_FILE))  # call dword ptr [NtWriteFile]

    # --- next_arg ---
    labels['next_arg'] = here()
    patch_i8(jge_tab  + 1, labels['next_arg'] - (jge_tab  + 2))
    patch_i32(jne_pos + 2, labels['next_arg'] - (jne_pos + 6))
    patch_i8(jfail1   + 1, labels['next_arg'] - (jfail1   + 2))
    patch_i8(jfail2   + 1, labels['next_arg'] - (jfail2   + 2))

    emit(b'\x47')                    # inc  edi
    loop_back = here(); emit(b'\xe9\x00\x00\x00\x00')  # jmp loop_top [near]
    patch_i32(loop_back + 1, labels['loop_top'] - (loop_back + 5))

    # --- write_newline ---
    labels['write_newline'] = here()
    patch_i32(jg_pos + 2, labels['write_newline'] - (jg_pos + 6))

    emit(b'\x8b\x15' + pack32(G_HANDLE_VA))  # mov edx, [G_HANDLE_VA]
    emit(b'\x85\xd2')               # test edx, edx
    jz2 = here(); emit(b'\x74\x00')       # jz done [FWD]
    emit(b'\x83\xfa\xff')           # cmp  edx, -1
    je2 = here(); emit(b'\x74\x00')       # je done [FWD]

    # NtWriteFile(handle, NULL, NULL, NULL, &iosb, crlf, 2, NULL)
    emit(b'\x6a\x00')               # push 0   (ByteOffset = NULL)
    emit(b'\x6a\x02')               # push 2   (Length)
    crlf_va_pos = here()
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push crlf_va (Buffer) [PATCH]
    emit(b'\x8d\x45\xf4')           # lea  eax, [ebp-12] (&iosb)
    emit(b'\x50')                    # push eax (IoStatusBlock)
    emit(b'\x6a\x00')               # push 0   (ApcContext)
    emit(b'\x6a\x00')               # push 0   (ApcRoutine)
    emit(b'\x6a\x00')               # push 0   (Event)
    emit(b'\x52')                    # push edx (FileHandle)
    emit(b'\xff\x15' + pack32(NT_WRITE_FILE))  # call dword ptr [NtWriteFile]

    # --- done ---
    labels['done'] = here()
    patch_i8(jz2 + 1, labels['done'] - (jz2 + 2))
    patch_i8(je2 + 1, labels['done'] - (je2 + 2))

    emit(b'\x5f')                    # pop  edi
    emit(b'\x5e')                    # pop  esi
    emit(b'\x5b')                    # pop  ebx
    emit(b'\x33\xc0')               # xor  eax, eax   ; return 0
    emit(b'\xc9')                    # leave
    emit(b'\xc3')                    # ret

    func_len = len(code)

    # --- Append string literals ---
    logpath_offset = func_len
    code.extend(LOG_PATH)
    crlf_offset = func_len + len(LOG_PATH)
    code.extend(CRLF)
    tab_offset  = func_len + len(LOG_PATH) + len(CRLF)
    code.extend(TAB)

    # --- Patch string VAs ---
    log_path_va = INJECT_VA + logpath_offset
    crlf_va     = INJECT_VA + crlf_offset
    tab_va      = INJECT_VA + tab_offset
    code[logpath_push_pos+1 : logpath_push_pos+5] = pack32(log_path_va)
    code[crlf_va_pos+1      : crlf_va_pos+5     ] = pack32(crlf_va)
    code[tab_va_pos+1       : tab_va_pos+5       ] = pack32(tab_va)

    # --- Patch call rel32s ---
    def callpatch(pos, target):
        code[pos+1:pos+5] = packs32(target - (INJECT_VA + pos + 5))

    callpatch(cf_pos,  GETTOP_VA)
    callpatch(cf2_pos, CF_WRAPPER)
    # NtWriteFile calls use FF 15 [absolute] — no rel32 patching needed
    # lua_tostring (TOSTR_VA) is no longer called — stack accessed directly

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
G_COUNTER_VA   = addrs['G_HANDLE_VA'] + 4   # counter slot immediately after handle
CF_WRAPPER     = addrs['CF_WRAPPER']
NT_WRITE_FILE  = addrs['NT_WRITE_FILE']
GETTOP_VA      = addrs['GETTOP_VA']
LREG_FPTR_FOFF = addrs['LREG_FPTR_FOFF']

print(f"Detected addresses:")
print(f"  lua_gettop      VA 0x{GETTOP_VA:08X}")
print(f"  CF_WRAPPER      VA 0x{CF_WRAPPER:08X}")
print(f"  NT_WRITE_FILE      0x{NT_WRITE_FILE:08X}")
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
    print(f"\nBackup created: {BACKUP}")
else:
    print(f"\nBackup exists: {BACKUP}")

# 2. Inject function body (overwrites ScriptCB_DoFriendAction)
data[INJECT_FOFF : INJECT_FOFF + len(code)] = code
print(f"Injected {len(code)} bytes at file:0x{INJECT_FOFF:08X} (VA:0x{INJECT_VA:08X})")

# 3. Redirect luaL_Reg "print" entry
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
print("print() output will be written to <GameFolder>:\\BFront1.log on a modded Xbox HDD.")
