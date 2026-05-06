#!/usr/bin/env python3
"""
Patch default_patched.xbe to route Lua print() output to E:\\BFront2.log.

Strategy
--------
1. Overwrite ScriptCB_CancelSessionList (VA 0x488F0, 224 bytes available) with
   xb_print_log.  That function is a GameSpy/online stub, dead on a modded
   offline console.  It is solidly inside .text — no section extension needed.
2. Redirect the luaL_Reg "print" function pointer from the original print()
   (VA 0x363130) to xb_print_log (VA 0x488F0).

The injected function
---------------------
  int xb_print_log(lua_State *L)

  Uses one BSS global (zero-initialised):
    0x500000  g_log_handle  HANDLE  (0 = not opened yet, -1 = failed)

  Algorithm:
    1. n = lua_gettop(L)
    2. If g_log_handle == 0: open E:\\BFront2.log via CreateFile (CREATE_ALWAYS,
       GENERIC_WRITE).  Failure stores -1 so we won't retry.
    3. If handle is valid: for i = 1..n, get string with lua_tostring_ptr
       (VA 0x35f8a0).  Length comes from the TString header 4 bytes before
       the char* data.  Write string via the game's internal write wrapper
       (VA 0x31d3d2).
    4. Write "\\r\\n" to terminate the line.
    5. Return 0 (Lua convention: no return values).

Calling conventions observed in the binary
-------------------------------------------
    CreateFile wrapper  0x31d15a  stdcall 7 args  (ret 0x1c)
    write wrapper       0x31d3d2  stdcall 5 args  (ret 0x14)
                          (handle, buffer, length, pBytesWritten, segArray)
                          segArray=NULL → plain NtWriteFile, ByteOffset=NULL
                          (sequential write; kernel tracks file position)
                          This is the same path used by the journal system.
    lua_gettop          0x35f3d0  cdecl 1 arg
    lua_tostring_ptr    0x35f8a0  cdecl 2 args
"""
import struct, shutil, sys, os

OUT_XBE  = "bf2.debug.xbe"
BACKUP   = "default.xbe.bak"
# Read from original backup to ensure we aren't layering patches
IN_XBE   = BACKUP if os.path.exists(BACKUP) else "default.xbe"

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

INJECT_VA   = 0x000488F0   # ScriptCB_CancelSessionList — dead online stub
INJECT_FOFF = 0x000388F0   # corresponding file offset (VA - base_addr 0x10000)

G_HANDLE_VA   = 0x00500000   # global: HANDLE (in BSS, zero-init; 0=not opened, -1=failed)

CF_WRAPPER    = 0x0031D15A   # CreateFile wrapper (stdcall 7 args)
WRITE_WRAPPER = 0x0031D3D2   # write wrapper      (stdcall 5 args: handle,buf,len,pBW,seg)
GETTOP_VA     = 0x0035F3D0   # lua_gettop         (cdecl 1 arg)
TOSTR_VA      = 0x0035F8A0   # lua_tostring_ptr    (cdecl 2 args)

LREG_FPTR_FOFF = 0x00459804  # file offset of print func ptr in luaL_Reg

# ---------------------------------------------------------------------------
# Helper: rel32 from instruction following a E8 call
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
#   0x???  string literal: "E:\BFront2.log\0"  (15 bytes)
#   0x???  string literal: "\r\n"              (2 bytes)

LOG_PATH  = b"D:\\BFront2.log\x00"   # 15 bytes
CRLF      = b"\r\n"                   # 2 bytes

# We'll build the code in a list of (label, bytes) and resolve labels later.
# For simplicity we compute the code size with placeholder offsets, then fix.
# Since all branches are short (<128 bytes), we can use 1-pass assembly by
# laying out the code sequentially and computing forward-ref offsets manually.

# After the function we append the string literals.
# LOG_PATH starts at: INJECT_VA + len(function_body)
# CRLF     starts at: INJECT_VA + len(function_body) + len(LOG_PATH)

# --- Assemble the function body first (with FWD refs as 0, then patch) ---

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

    # s = lua_tostring(L, i)
    emit(b'\x6a\x00')               # push 0 (len pointer = NULL)
    emit(b'\x57')                   # push edi
    emit(b'\x56')                   # push esi
    cs_pos = here(); emit(b'\xe8' + b'\x00\x00\x00\x00')  # call tostr
    emit(b'\x83\xc4\x0c')          # add  esp, 12 (3 args)
    emit(b'\x85\xc0')              # test eax, eax
    jz_pos = here(); emit(b'\x74\x00')  # jz next_arg [FWD]

    # len = *(eax-4); save str and len for use after CreateFile clobbers regs
    emit(b'\x8b\x48\xfc')          # mov  ecx, [eax-4]
    emit(b'\x89\x4d\xf8')          # mov  [ebp-8], ecx
    emit(b'\x89\x45\xfc')          # mov  [ebp-4], eax

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
    emit(b'\x68' + b'\x00\x00\x00\x00')  # push crlf_va
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

code = assemble()
print(f"Injected function size: {len(code)} bytes  (space available: 224)")
assert len(code) <= 224, "Code too large for ScriptCB_CancelSessionList slot!"

# --- Verify code fits and check we're not overwriting anything ---
print(f"Injection VA:   0x{INJECT_VA:08X}")
print(f"Injection foff: 0x{INJECT_FOFF:08X}")

# ---------------------------------------------------------------------------
# Apply all patches to the XBE
# ---------------------------------------------------------------------------

with open(IN_XBE, "rb") as f:
    data = bytearray(f.read())

# 1. Backup (only when reading from OUT_XBE, not from the backup itself)
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
assert old_fptr == 0x363130, f"Expected print fptr 0x363130, got 0x{old_fptr:08X}"
struct.pack_into("<I", data, LREG_FPTR_FOFF, INJECT_VA)
print(f"Patched luaL_Reg print fptr: 0x{old_fptr:08X} -> 0x{INJECT_VA:08X}")

# ---------------------------------------------------------------------------
# Write output
# ---------------------------------------------------------------------------
with open(OUT_XBE, "wb") as f:
    f.write(data)
print(f"\nPatched XBE written: {OUT_XBE}")
print("print() output will be written to D:\\BFront2.log on a modded Xbox.")
