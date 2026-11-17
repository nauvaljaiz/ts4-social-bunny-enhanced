# -*- coding: utf-8 -*-
"""
Phase 1 Reverse Engineering Audit Script.

Directly inspects the installed The Sims 4 game files (never modifying them):
1. Scans UI.package, ClientDeltaBuild*, and EP12 packages for Scaleform GFX resources.
2. Identifies Social Bunny (SocialMedia) GFX and traces ImportAssets2 / external dependencies.
3. Extracts untouched original GFX resources into src/gfx/original/.
4. Lists all social_media Python modules and protobuf classes in Gameplay zips.
5. Scans EP12 simulation & string packages for social_media tuning and strings.
"""

import os
import re
import struct
import sys
import zipfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dbpf import (
    RES_TYPE_GFX,
    RES_TYPE_STBL,
    read_dbpf_index,
    read_dbpf_resource,
)

GAME_ROOT = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4"
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ORIG_GFX_DIR = os.path.join(PROJECT_ROOT, "src", "gfx", "original")


def parse_gfx_strings(gfx_bytes: bytes):
    """Quick scan of ASCII strings inside a GFX/SWF binary for diagnostics."""
    # GFX header: b'GFX' + version(1) + file_len(4) + ...
    # Note: Scaleform GFX files are uncompressed (magic 'GFX') or zlib ('CFX')
    if gfx_bytes[:3] == b"CFX":
        import zlib
        data = gfx_bytes[:8] + zlib.decompress(gfx_bytes[8:])
    else:
        data = gfx_bytes
    ascii_tokens = re.findall(rb"[A-Za-z0-9_./:-]{4,}", data)
    return [t.decode("ascii", errors="ignore") for t in ascii_tokens]


def scan_gfx_packages():
    os.makedirs(ORIG_GFX_DIR, exist_ok=True)
    candidates = [
        os.path.join(GAME_ROOT, "Data", "Client", "UI.package"),
        os.path.join(GAME_ROOT, "EP12", "ClientFullBuild0.package"),
        os.path.join(GAME_ROOT, "Delta", "EP12", "ClientDeltaBuild0.package"),
    ]
    for i in range(9):
        p = os.path.join(GAME_ROOT, "Data", "Client", f"ClientDeltaBuild{i}.package")
        if os.path.isfile(p):
            candidates.append(p)

    print("=== 1. SCANNING GFX RESOURCES (0x62ECC59A) ===")
    gfx_catalog = []
    for pkg in candidates:
        if not os.path.isfile(pkg):
            continue
        entries = read_dbpf_index(pkg)
        gfx_entries = [e for e in entries if e.res_type == RES_TYPE_GFX]
        print(f"Package: {os.path.relpath(pkg, GAME_ROOT)} -> {len(entries)} total, {len(gfx_entries)} GFX")
        for e in gfx_entries:
            data = read_dbpf_resource(pkg, e)
            tokens = parse_gfx_strings(data)
            joined = " ".join(tokens)
            # Check for SocialMedia / Phone / Picker / Shared imports
            hits = []
            for kw in ("SocialMedia", "SocialBunny", "Phone", "Notification", "Picker", "Dialog", "Widget"):
                if kw.lower() in joined.lower():
                    hits.append(kw)
            # Extract likely movie name (first .gfx or widgets. path)
            gfx_refs = [t for t in tokens if ".gfx" in t.lower() or t.startswith("widgets.")]
            first_refs = []
            seen = set()
            for r in gfx_refs:
                if r not in seen:
                    seen.add(r)
                    first_refs.append(r)
                if len(first_refs) >= 6:
                    break
            if hits or "Social" in joined:
                print(
                    f"  [{e.key_str}] size={len(data)} magic={data[:3]!r} ver={data[3]} "
                    f"hits={hits} sample_refs={first_refs}"
                )
            gfx_catalog.append((pkg, e, data, tokens, hits))

            # Save SocialMedia and Phone GFX originals untouched
            if any(k in joined for k in ("SocialMedia", "PhoneMain", "PhoneApp")) or e.instance in (
                0x8ABB350F01880C64,
            ):
                safe_name = f"GFX_{e.res_type:08X}_{e.res_group:08X}_{e.instance:016X}.gfx"
                out_path = os.path.join(ORIG_GFX_DIR, safe_name)
                # Prefer later delta if any
                with open(out_path, "wb") as out_f:
                    out_f.write(data)
                print(f"    -> Extracted original GFX to {os.path.relpath(out_path, PROJECT_ROOT)}")
    return gfx_catalog


def scan_python_zips():
    print("\n=== 2. SCANNING GAME PYTHON ZIPS ===")
    zips = [
        os.path.join(GAME_ROOT, "Data", "Simulation", "Gameplay", "base.zip"),
        os.path.join(GAME_ROOT, "Data", "Simulation", "Gameplay", "core.zip"),
        os.path.join(GAME_ROOT, "Data", "Simulation", "Gameplay", "simulation.zip"),
        os.path.join(GAME_ROOT, "Game", "Bin", "Python", "generated.zip"),
    ]
    for zp in zips:
        if not os.path.isfile(zp):
            continue
        with zipfile.ZipFile(zp, "r") as zf:
            matches = [
                n for n in zf.namelist()
                if any(k in n.lower() for k in ("social_media", "socialmedia", "social_bunny", "phone"))
            ]
            print(f"Zip: {os.path.relpath(zp, GAME_ROOT)} -> {len(matches)} matching modules")
            for m in sorted(matches):
                print(f"  {m}")


def scan_ep12_tuning_and_strings():
    print("\n=== 3. SCANNING EP12 TUNING & STRINGS ===")
    pkgs = [
        os.path.join(GAME_ROOT, "EP12", "SimulationFullBuild0.package"),
        os.path.join(GAME_ROOT, "Delta", "EP12", "SimulationDeltaBuild0.package"),
    ]
    for pkg in pkgs:
        if not os.path.isfile(pkg):
            continue
        entries = read_dbpf_index(pkg)
        type_counts = {}
        social_hits = []
        for e in entries:
            type_counts[e.res_type] = type_counts.get(e.res_type, 0) + 1
            if e.res_type in (0x03B33DDF, 0xE882D22F, 0x6017E896, 0x0C772E27, 0x7DF2169C, 0x339BC5BD, 0x03E9D964):
                data = read_dbpf_resource(pkg, e)
                if b"social_media" in data.lower() or b"socialbunny" in data.lower() or b"social_bunny" in data.lower():
                    m = re.search(rb'n="([^"]+)"', data)
                    name = m.group(1).decode("utf-8", errors="replace") if m else "<unnamed>"
                    social_hits.append((e.key_str, name, len(data)))
        print(f"Package: {os.path.relpath(pkg, GAME_ROOT)} -> {len(entries)} entries")
        print(f"  Social media XML hits: {len(social_hits)}")
        for k, name, sz in sorted(social_hits, key=lambda x: x[1])[:60]:
            print(f"    {k} | {name} ({sz} bytes)")


if __name__ == "__main__":
    scan_gfx_packages()
    scan_python_zips()
    scan_ep12_tuning_and_strings()
