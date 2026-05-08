# BF2 Xbox — Lua `print()` → File Logging Patch

Enables Lua `print()` output to `D:\BFront2.log` on a softmodded / TSOP-flashed
Xbox.

**Current status:** Successfully implemented and tested. Output file is created
in the game directory and captures all Lua `print` statements.

---

## Background

The Xbox build strips the PC logging infrastructure (`PblLog`, `BFront2.log`)
entirely. Lua `print()` exists in the binary but calls no output sink — it is
silent on retail hardware. The full analysis is in `BF2_Xbox_Logging.md`.

To restore logging, a new Lua C function (`xb_print_log`) is injected into
the binary and the `luaL_Reg` "print" entry redirected to it.

---

## Injection site selection

### Adopted Approach — ScriptCB_ function takeover

The injection overwrites the body of `ScriptCB_CancelSessionList` (VA `0x000488F0`),
which is a GameSpy session-list stub. The function is confirmed at this VA by
decoding the `luaL_Reg` table entry at file offset `0x004943B0`: the name VA
`0x0047EEF4` maps to file offset `0x0046ECB4` (`"ScriptCB_CancelSessionList"`)
using the `.rdata` section delta of `0x10240`. This provides 242 contiguous bytes
within `.text`, with no section header modifications required.

On an offline softmodded console this function is never called — it is only
reached when cancelling an online session list query.

---

## Technical Details

### File Pathing
On a modded Xbox running from the HDD, **`D:\` is a virtual mount for the
directory containing the `.xbe`.** This directory is writable. Writing to `D:\`
is preferred over `E:\` as it requires no extra mounting logic and keeps the
log next to the executable.

### Calling Conventions

| Symbol | VA | Convention | Args | Notes |
|---|---|---|---|---|
| `CreateFile` wrapper | `0x0031D15A` | stdcall | 7 | `ret 0x1C` |
| `write_wrapper` | `0x0031D3D2` | stdcall | 5 | `ret 0x14`. Requires valid `pBytesWritten` ptr. |
| `lua_gettop` | `0x0035F3D0` | cdecl | 1 | Standard stack cleanup. |
| `lua_tolstring` | `0x0035F8A0` | cdecl | 3 | Takes `(L, idx, len_ptr)`. Pass `NULL` for `len_ptr`. |

### Critical Fixes
1. **`lua_tolstring` Arguments:** The function at `0x0035F8A0` is actually
   `lua_tolstring`, which expects three arguments. Passing only two caused
   stack corruption.
2. **`write_wrapper` Safety:** Passing `NULL` for the 4th argument
   (`pBytesWritten`) can cause a hang. Providing a pointer to a local stack
   variable (`lea eax, [ebp-12]`) resolved the stability issues.

---

## Final Algorithm (xb_print_log)

```cpp
int xb_print_log(lua_State *L) {
    int n = lua_gettop(L);
    if (g_log_handle == 0) {
        g_log_handle = CreateFile("D:\\BFront2.log", ...);
    }
    
    for (int i = 1; i <= n; i++) {
        const char* s = lua_tolstring(L, i, NULL);
        if (s) {
            DWORD len = *(DWORD*)(s - 4); // Lua 5.0 TString length
            write_wrapper(g_log_handle, s, len, &bytes_written, NULL);
        }
    }
    write_wrapper(g_log_handle, "\r\n", 2, &bytes_written, NULL);
    return 0;
}
```

---

## luaL_Reg Redirect

The `luaL_Reg` table for the base library is located in the data section. The
"print" entry's function pointer is at file offset `0x00459804`.

| Location | Original | Patched |
|---|---|---|
| File `0x00459804` | `0x00363130` | `0x000488F0` |

---

## Files

| File | Description |
|---|---|
| `patch_xbe_print_log_bf2.py` | Implementation script |
| `BF2_Xbox_Logging.md` | Full logging internals analysis |
