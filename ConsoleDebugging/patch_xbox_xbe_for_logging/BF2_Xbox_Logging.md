# BF2 Xbox (default.xbe) — Logging Internals

Static analysis of `default.xbe` (XBE base `0x00010000`, 18 sections).
Debug build path from certificate: `e:\Battlefront2\XBOX_Final\...\Battlefront2F.exe`

---

## Short answer

The Xbox build has **no built-in logging mechanism** that works on retail hardware.
However, a **successful Lua `print()` redirection patch** has been implemented,
allowing output to be written to `D:\BFront2.log` on modded consoles.

---

## What exists (and why it doesn't work by default)

### 1. No PblLog / no BFront2.log

The PC build's ring-buffer file logger (`PblLog`, three sinks, `BFront2.log`) was
completely removed from the Xbox build. None of the relevant strings (`BFront2`,
`PblLog`, `log_open`, etc.) appear in the binary.

### 2. Lua `print()` — VA `0x00363130`

The function registered in the Lua library table is a standard Lua 5.0 C
implementation. It:

1. Calls `lua_gettop` to count arguments.
2. Retrieves the `tostring` global.
3. Converts each argument to a string via the Lua stack.
4. Returns `0` (no Lua return values).

By default, there is no file write, no `DbgPrint` call, and no output sink
anywhere in the success path. **`print()` is silent on stock Xbox hardware.**

### 3. `DbgPrint` — devkit only

`DbgPrint` is imported as Xbox kernel ordinal 8. Its thunk stub is at VA `0x0035E2EE`
and is called from exactly **one place**: a D3D debug wrapper at VA `0x00431B67`.
It is not reachable from any Lua path. On retail hardware, `DbgPrint` is a kernel
stub that does nothing (the debug monitor is not present).

### 4. The journal system — `D:\` behavior

The game contains a QA game-state recorder activated via the Lua callback
`ScriptCB_EnableJournal()` (function VA `0x00046800`).

- **On Retail DVD:** `D:` is the DVD drive and is read-only. Writes fail.
- **On Modded HDD:** `D:` is typically a virtual mount for the game directory.
  This directory is **writable**, and the journal system functions correctly
  (writing `enbljrnl.dat`, etc.) without patching if run from the HDD.

The journal records **game events and AI state**, not Lua `print()` output.

### 5. `T:\` paths — save data only

Strings like `T:\$C\%08X%08X` and `T:\$U\` exist in `.rdata` and are used by
the save-game system (XMountMUA / XMountUtilityDrive). They have no connection
to logging.

---

## What the Xbox build **does** import (file I/O is present)

The kernel import table includes:

| Import | Use |
|---|---|
| `NtCreateFile` | General file open/create |
| `NtWriteFile` | File write |
| `NtReadFile` | File read |
| `NtClose` | Handle close |
| `XMountUtilityDrive` | Mount `T:` (memory unit) |
| `XMountMUA` / `XMountMUAEx` | Mount named memory unit |

The infrastructure for file I/O to `T:` or `E:` exists at the kernel level;
it is just never used for logging in the stock build.

---

## Enabling logging — Implemented Strategy

The successful implementation uses **Option C**, redirected to the game's
working directory on the HDD.

| Mechanism | Status | Retail usable? |
|---|---|---|
| PblLog / BFront2.log | Absent | No |
| Lua `print()` | Redirected to `D:\BFront2.log` | **Yes (Patched)** |
| `DbgPrint` | Devkit-only | No |
| Journal (`D:\journal_*.dat`) | Functional on HDD | Yes |
| Journal → `E:\` (patch) | Redundant for HDD | Yes |
| Journal → `T:\` (patch) | Needs XMount call too | Unmodded possible |
| `print()` → file (patch) | **Implemented (see Patch.md)** | **Yes** |

