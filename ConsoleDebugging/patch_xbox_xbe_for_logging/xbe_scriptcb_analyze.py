#!/usr/bin/env python3
"""
xbe_scriptcb_analyze.py  <path-to.xbe>

Scans an Xbox XBE binary for all ScriptCB_ Lua C functions registered via
luaL_Reg and prints a Markdown table to stdout:

  Function | Max Args | Ret Vals | VA | Size

All section mappings are derived from the XBE header — no hardcoded offsets.
Redirect stdout to a file for a persistent report.

Heuristics
----------
Max Args  : highest Lua stack index explicitly pushed as an immediate byte
            (6A NN, 1 <= NN <= 12) anywhere in the function body.  Functions
            that use lua_gettop() for variadic args may show 0.
Ret Vals  : value held in eax at each C3 (ret) instruction.  Recognised
            patterns: 33 C0 -> 0, 33 C0 40 -> 1, B8 NN 00 00 00 -> NN.
            Multiple observed paths shown as 0/1 etc.  ? = unrecognised.
"""

import struct
import sys
import os

# ---------------------------------------------------------------------------
# XBE header parsing
# ---------------------------------------------------------------------------

SECTION_HDR_SIZE = 56  # bytes

def parse_xbe(data):
    """Return (base_addr, sections).  Raises ValueError on bad magic."""
    if data[:4] != b'XBEH':
        raise ValueError(f"Not an XBE file (magic={data[:4]!r})")

    base_addr       = struct.unpack_from('<I', data, 0x104)[0]
    num_sections    = struct.unpack_from('<I', data, 0x11C)[0]
    sec_hdrs_va     = struct.unpack_from('<I', data, 0x120)[0]
    sec_hdrs_foff   = sec_hdrs_va - base_addr

    sections = []
    for i in range(num_sections):
        off = sec_hdrs_foff + i * SECTION_HDR_SIZE
        flags    = struct.unpack_from('<I', data, off + 0x00)[0]
        va       = struct.unpack_from('<I', data, off + 0x04)[0]
        vsize    = struct.unpack_from('<I', data, off + 0x08)[0]
        raw_off  = struct.unpack_from('<I', data, off + 0x0C)[0]
        raw_size = struct.unpack_from('<I', data, off + 0x10)[0]
        name_va  = struct.unpack_from('<I', data, off + 0x14)[0]

        name_foff = name_va - base_addr
        null = data.find(b'\x00', name_foff)
        name = data[name_foff:null].decode('ascii', errors='replace') if null > name_foff else ''

        sections.append(dict(
            name=name, flags=flags,
            va=va, vsize=vsize,
            raw_off=raw_off, raw_size=raw_size,
        ))

    return base_addr, sections


def va_to_foff(va, sections):
    for s in sections:
        if s['va'] <= va < s['va'] + s['vsize']:
            return s['raw_off'] + (va - s['va'])
    return None


# ---------------------------------------------------------------------------
# Step 1: find all "ScriptCB_" strings in any section
# ---------------------------------------------------------------------------

NEEDLE = b'ScriptCB_'

def find_scriptcb_strings(data, sections):
    """Return {string_va: name_str} for every ScriptCB_ C-string found."""
    found = {}
    for sec in sections:
        chunk = data[sec['raw_off'] : sec['raw_off'] + sec['raw_size']]
        pos = 0
        while True:
            idx = chunk.find(NEEDLE, pos)
            if idx < 0:
                break
            null = chunk.find(b'\x00', idx)
            if null < 0:
                break
            name = chunk[idx:null].decode('ascii', errors='replace')
            va = sec['va'] + idx
            found[va] = name
            pos = idx + 1
    return found


# ---------------------------------------------------------------------------
# Step 2: find luaL_Reg {name_va, func_va} pairs in data sections
# ---------------------------------------------------------------------------

def find_lreg_entries(data, sections, str_va_set):
    """
    Scan ALL sections for 4-byte aligned (name_va, func_va) pairs where
    name_va is a known ScriptCB_ string VA and func_va falls inside any
    section but is NOT itself a known string VA.  Returns {name_va: func_va}.

    Note: XBE section flags are not reliable for distinguishing code from
    data (many XBEs mark all sections executable).  We rely on the str_va_set
    check and a simple sanity check on func_va instead.
    """
    # Build a set of all valid VAs (any byte within any section).
    # For speed, just track (va_start, va_end) ranges.
    all_ranges = [(s['va'], s['va'] + s['vsize']) for s in sections]

    def in_any_section(va):
        for lo, hi in all_ranges:
            if lo <= va < hi:
                return True
        return False

    result = {}
    for sec in sections:
        chunk = data[sec['raw_off'] : sec['raw_off'] + sec['raw_size']]
        for i in range(0, len(chunk) - 7, 4):
            name_va = struct.unpack_from('<I', chunk, i)[0]
            if name_va not in str_va_set:
                continue
            func_va = struct.unpack_from('<I', chunk, i + 4)[0]
            if func_va not in str_va_set and in_any_section(func_va) and name_va not in result:
                result[name_va] = func_va
    return result


# ---------------------------------------------------------------------------
# Step 3: measure function size (first C3 followed by CC padding)
# ---------------------------------------------------------------------------

MAX_SCAN = 8192

def measure_func_size(data, func_va, sections):
    """
    Scan forward from func_va for C3 CC (ret + int3 pad) or C2 xx 00 CC
    (retn N + int3 pad).  Returns byte count up to and including the ret,
    or None if not found within MAX_SCAN bytes.
    """
    foff = va_to_foff(func_va, sections)
    if foff is None:
        return None

    limit = min(MAX_SCAN, len(data) - foff - 1)
    i = 0
    while i < limit:
        b = data[foff + i]
        if b == 0xC3 and data[foff + i + 1] == 0xCC:
            return i + 1
        if b == 0xC2 and i + 3 < limit and data[foff + i + 3] == 0xCC:
            return i + 3
        i += 1
    return None


# ---------------------------------------------------------------------------
# Step 4: infer max Lua arg index from push-immediate bytes
# ---------------------------------------------------------------------------

def infer_max_args(data, func_va, func_size, sections):
    """
    Scan for 6A NN (push imm8) where 1 <= NN <= 12 and return the max NN.
    Returns 0 if none found.
    """
    if not func_size:
        return 0
    foff = va_to_foff(func_va, sections)
    if foff is None:
        return 0

    max_idx = 0
    for i in range(func_size - 1):
        if data[foff + i] == 0x6A:
            nn = data[foff + i + 1]
            if nn > 0x7F:
                nn -= 256        # sign-extend
            if 1 <= nn <= 12:
                max_idx = max(max_idx, nn)
    return max_idx


# ---------------------------------------------------------------------------
# Step 5: infer return value count from eax pattern before each C3
# ---------------------------------------------------------------------------

def infer_ret_vals(data, func_va, func_size, sections):
    """
    For each C3 (ret) in the function body examine the preceding bytes:
      33 C0 40 C3  -> xor eax,eax; inc eax -> 1
      33 C0 C3     -> xor eax,eax          -> 0
      B8 NN .. C3  -> mov eax, NN          -> NN  (0<=NN<=15)
      anything else                        -> ?
    Returns a sorted, deduplicated list of strings, e.g. ['0','1'] or ['?'].
    """
    if not func_size:
        return ['?']
    foff = va_to_foff(func_va, sections)
    if foff is None:
        return ['?']

    vals = set()
    for i in range(func_size):
        if data[foff + i] != 0xC3:
            continue
        # 33 C0 40 C3
        if i >= 3 and data[foff+i-3] == 0x33 and data[foff+i-2] == 0xC0 and data[foff+i-1] == 0x40:
            vals.add(1)
        # 33 C0 C3
        elif i >= 2 and data[foff+i-2] == 0x33 and data[foff+i-1] == 0xC0:
            vals.add(0)
        # B8 NN 00 00 00 C3
        elif i >= 5 and data[foff+i-5] == 0xB8:
            nn = struct.unpack_from('<I', data, foff+i-4)[0]
            vals.add(nn if 0 <= nn <= 15 else '?')
        else:
            vals.add('?')

    if not vals:
        return ['?']

    int_vals = sorted(v for v in vals if isinstance(v, int))
    has_unk  = any(not isinstance(v, int) for v in vals)
    result   = [str(v) for v in int_vals]
    if has_unk:
        result.append('?')
    return result or ['?']


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <path-to.xbe>", file=sys.stderr)
        sys.exit(1)

    xbe_path = sys.argv[1]
    with open(xbe_path, 'rb') as f:
        data = bytearray(f.read())

    base_addr, sections = parse_xbe(data)

    str_map = find_scriptcb_strings(data, sections)
    lreg    = find_lreg_entries(data, sections, set(str_map))

    results = []
    for name_va, func_va in lreg.items():
        name     = str_map[name_va]
        size     = measure_func_size(data, func_va, sections)
        max_args = infer_max_args(data, func_va, size, sections)
        ret_vals = '/'.join(infer_ret_vals(data, func_va, size, sections))
        results.append((func_va, name, max_args, ret_vals, size))

    results.sort()   # by VA

    # --- header ---
    print(f"# XBE ScriptCB_ Function Analysis")
    print(f"# Source      : {os.path.basename(xbe_path)}")
    print(f"# Base address: 0x{base_addr:08X}")
    print(f"# Sections    : {len(sections)}")
    print(f"# Functions   : {len(results)}")
    print()
    print("> **Note:** Max Args and Ret Vals are heuristically inferred from compiled")
    print("> machine code, not source declarations.  Max Args = highest Lua stack index")
    print("> pushed as an immediate (6A NN).  Functions using lua_gettop() for variadic")
    print("> args may show 0.  Ret Vals = eax value at each ret instruction; multiple")
    print("> return paths shown as 0/1 etc.; ? = pattern not recognised.")
    print()

    col_w  = max((len(r[1]) for r in results), default=40)
    header = f"| {'Function':<{col_w}} | Max Args | Ret Vals |           VA |   Size |"
    sep    = f"| {'-'*col_w} |----------|----------|--------------|--------|"
    print(header)
    print(sep)
    for func_va, name, max_args, ret_vals, size in results:
        size_s = f"{size}B" if size is not None else "?"
        print(f"| {name:<{col_w}} | {max_args:>8} | {ret_vals:>8} | 0x{func_va:08X} | {size_s:>6} |")


if __name__ == '__main__':
    main()
