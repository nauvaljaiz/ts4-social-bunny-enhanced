# -*- coding: utf-8 -*-
"""
Reproducible build pipeline for Social Bunny Verified.

Builds:
  1. src/gfx/compiled/SocialMedia_0x8ABB350F01880C64.gfx (via FFDec -importScript)
  2. dist/SocialBunnyVerified_UI.package (GFX override + DDS/PNG badge assets)
  3. dist/SocialBunnyVerified_Core.package (STBL tables + additive XML tuning)
  4. dist/SocialBunnyVerified.ts4script (Python 3.7 compiled bytecode archive)
"""

import os
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "tools"))

from dbpf import (
    RES_TYPE_GFX,
    create_dbpf_package,
    read_dbpf_index,
    read_dbpf_resource,
)

SOCIAL_MEDIA_GFX_INSTANCE = 0x8ABB350F01880C64
GCL_GFX_INSTANCE = 0x0CE54D7C2E5B859C
UI_PACKAGE_CANDIDATES = [
    r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4\Data\Client\UI.package",
    r"C:\Program Files\EA Games\The Sims 4\Data\Client\UI.package",
    r"C:\Program Files\Origin Games\The Sims 4\Data\Client\UI.package",
]

JAVA_EXE_CANDIDATES = [
    r"C:\Program Files\Microsoft\jdk-17.0.21.21-hotspot\bin\java.exe",
    shutil.which("java"),
]

FFDEC_JAR_CANDIDATES = [
    os.path.join(PROJECT_ROOT, "tools", "ffdec", "ffdec-cli.jar"),
    r"C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\ffdec\ffdec-cli.jar",
]

PYTHON37_CANDIDATES = [
    os.path.join(PROJECT_ROOT, "tools", "python37", "python.exe"),
    r"C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe",
]


def _find_tool(candidates):
    for p in candidates:
        if p and os.path.isfile(p):
            return p
    return None


def _get_gcl_abc_element(java_exe: str, ffdec_jar: str) -> ET.Element:
    """Return cached GUIComponentLibrary DoABC2Tag element for external superclass scope resolution."""
    cache_path = os.path.join(PROJECT_ROOT, "build", "cache", "gcl_doabc2.xml")
    if os.path.isfile(cache_path):
        return ET.parse(cache_path).getroot()

    ui_pkg = _find_tool(UI_PACKAGE_CANDIDATES)
    if not ui_pkg:
        raise RuntimeError("Missing The Sims 4 Data/Client/UI.package for GUIComponentLibrary extraction.")

    entries = [
        e for e in read_dbpf_index(ui_pkg)
        if e.res_type == RES_TYPE_GFX and e.instance == GCL_GFX_INSTANCE
    ]
    if not entries:
        raise RuntimeError(f"GUIComponentLibrary (0x{GCL_GFX_INSTANCE:016X}) not found in {ui_pkg}.")

    tmp_dir = tempfile.mkdtemp(prefix="sbv_gcl_")
    try:
        gcl_gfx = os.path.join(tmp_dir, "gcl.gfx")
        gcl_xml = os.path.join(tmp_dir, "gcl.xml")
        with open(gcl_gfx, "wb") as f:
            f.write(read_dbpf_resource(ui_pkg, entries[0]))
        proc = subprocess.run([java_exe, "-jar", ffdec_jar, "-swf2xml", gcl_gfx, gcl_xml], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"Failed converting GUIComponentLibrary to XML:\n{proc.stderr}\n{proc.stdout}")

        tags = ET.parse(gcl_xml).getroot().find("tags")
        abc_tags = [t for t in tags if t.attrib.get("type") == "DoABC2Tag"] if tags is not None else []
        if not abc_tags:
            raise RuntimeError("GUIComponentLibrary XML missing DoABC2Tag.")
        abc_tag = abc_tags[0]
        abc_tag.attrib["name"] = "gcl_lib"

        os.makedirs(os.path.dirname(cache_path), exist_ok=True)
        ET.ElementTree(abc_tag).write(cache_path, encoding="utf-8", xml_declaration=True)
        return abc_tag
    finally:
        shutil.rmtree(tmp_dir, ignore_errors=True)


def _extract_class_scope_map(abc_elem: ET.Element) -> dict:
    """Map class short name -> (cinit_init, cinit_max, iinit_init, iinit_max)."""
    consts = abc_elem.find("constants")
    strs = [el.text or "" for el in consts.find("constant_string")]
    mns = list(consts.find("constant_multiname"))
    bodies = {int(b.attrib["method_info"]): b for b in abc_elem.find("bodies")}
    out = {}
    for idx, inst in enumerate(abc_elem.find("instance_info")):
        mn = mns[int(inst.attrib["name_index"])]
        if "name_index" not in mn.attrib:
            continue
        cls_name = strs[int(mn.attrib["name_index"])]
        cls_el = abc_elem.find("class_info")[idx]
        cb = bodies.get(int(cls_el.attrib["cinit_index"]))
        ib = bodies.get(int(inst.attrib["iinit_index"]))
        if cb is not None and ib is not None:
            out[cls_name] = (
                int(cb.attrib["init_scope_depth"]),
                int(cb.attrib["max_scope_depth"]),
                int(ib.attrib["init_scope_depth"]),
                int(ib.attrib["max_scope_depth"]),
            )
    return out


def _align_cinit_scopes(abc_elem: ET.Element, orig_scopes: dict) -> None:
    """Ensure compiled cinit scope depths match EA's original values exactly."""
    consts = abc_elem.find("constants")
    strs = [el.text or "" for el in consts.find("constant_string")]
    mns = list(consts.find("constant_multiname"))
    bodies = {int(b.attrib["method_info"]): b for b in abc_elem.find("bodies")}
    for idx, inst in enumerate(abc_elem.find("instance_info")):
        mn = mns[int(inst.attrib["name_index"])]
        if "name_index" not in mn.attrib:
            continue
        cls_name = strs[int(mn.attrib["name_index"])]
        if cls_name not in orig_scopes:
            continue
        orig_c_init, _, orig_i_init, _ = orig_scopes[cls_name]
        cls_el = abc_elem.find("class_info")[idx]
        cb = bodies.get(int(cls_el.attrib["cinit_index"]))
        ib = bodies.get(int(inst.attrib["iinit_index"]))
        if cb is None or ib is None:
            continue
        cur_c_init = int(cb.attrib["init_scope_depth"])
        cur_c_max = int(cb.attrib["max_scope_depth"])
        cur_i_init = int(ib.attrib["init_scope_depth"])
        if cur_i_init == orig_i_init and cur_c_init != orig_c_init and orig_c_init < cur_i_init:
            delta = max(1, cur_c_max - cur_c_init)
            cb.attrib["init_scope_depth"] = str(orig_c_init)
            cb.attrib["max_scope_depth"] = str(orig_c_init + delta)


def compile_gfx() -> str:
    base_gfx = os.path.join(PROJECT_ROOT, "src", "gfx", "original", "SocialMedia_0x8ABB350F01880C64.gfx")
    out_gfx = os.path.join(PROJECT_ROOT, "src", "gfx", "compiled", "SocialMedia_0x8ABB350F01880C64.gfx")
    scripts_dir = os.path.join(PROJECT_ROOT, "src", "gfx", "scripts")
    decompiled_dir = os.path.join(PROJECT_ROOT, "src", "gfx", "decompiled", "SocialMedia", "scripts")
    os.makedirs(os.path.dirname(out_gfx), exist_ok=True)

    java_exe = _find_tool(JAVA_EXE_CANDIDATES)
    ffdec_jar = _find_tool(FFDEC_JAR_CANDIDATES)
    if not java_exe or not ffdec_jar:
        raise RuntimeError("Missing Java 17 or FFDec CLI jar for GFX compilation.")

    # Only import modified .as files so untouched EA classes remain byte-for-byte intact
    staging = tempfile.mkdtemp(prefix="sbv_as3_")
    try:
        imported = 0
        for root, _, files in os.walk(scripts_dir):
            for fname in files:
                if not fname.endswith(".as"):
                    continue
                src_p = os.path.join(root, fname)
                rel_p = os.path.relpath(src_p, scripts_dir)
                orig_p = os.path.join(decompiled_dir, rel_p)
                if not os.path.isfile(orig_p) or open(src_p, "rb").read() != open(orig_p, "rb").read():
                    dst_p = os.path.join(staging, rel_p)
                    os.makedirs(os.path.dirname(dst_p), exist_ok=True)
                    shutil.copy2(src_p, dst_p)
                    imported += 1

        if imported == 0:
            shutil.copy2(base_gfx, out_gfx)
            return out_gfx

        # Provide GUIComponentLibrary DoABC2 during compilation so Scaleform/AVM2
        # inheritance scope depths (11/12/13) and StaticProtectedNs resolve properly.
        gcl_abc_tag = _get_gcl_abc_element(java_exe, ffdec_jar)
        sm_xml_path = os.path.join(staging, "_orig_sm.xml")
        proc = subprocess.run([java_exe, "-jar", ffdec_jar, "-swf2xml", base_gfx, sm_xml_path], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"FFDec swf2xml failed:\n{proc.stderr}\n{proc.stdout}")

        sm_tree = ET.parse(sm_xml_path)
        sm_tags = sm_tree.getroot().find("tags")
        orig_abc_tags = [t for t in sm_tags if t.attrib.get("type") == "DoABC2Tag"]
        if not orig_abc_tags:
            raise RuntimeError("Original SocialMedia GFX missing DoABC2Tag.")
        orig_scopes = _extract_class_scope_map(orig_abc_tags[0].find("abc"))

        wrap_tree = ET.parse(sm_xml_path)
        wrap_tags = wrap_tree.getroot().find("tags")
        for idx, tag in enumerate(list(wrap_tags)):
            if tag.attrib.get("type") == "DoABC2Tag":
                wrap_tags.insert(idx, gcl_abc_tag)
                break
        wrap_xml_path = os.path.join(staging, "_wrap.xml")
        wrap_gfx_path = os.path.join(staging, "_wrap.gfx")
        wrap_tree.write(wrap_xml_path, encoding="utf-8", xml_declaration=True)
        proc = subprocess.run([java_exe, "-jar", ffdec_jar, "-xml2swf", wrap_xml_path, wrap_gfx_path], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"FFDec xml2swf wrapper failed:\n{proc.stderr}\n{proc.stdout}")

        out_wrap_gfx = os.path.join(staging, "_out_wrap.gfx")
        src_staging = os.path.join(staging, "_scripts")
        # Move staged scripts out of root staging so _wrap files aren't touched
        for item in os.listdir(staging):
            if not item.startswith("_"):
                shutil.move(os.path.join(staging, item), os.path.join(src_staging, item))

        cmd = [java_exe, "-jar", ffdec_jar, "-onerror", "abort", "-importScript", wrap_gfx_path, out_wrap_gfx, src_staging]
        proc = subprocess.run(cmd, cwd=PROJECT_ROOT, capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"FFDec GFX compilation failed:\n{proc.stderr}\n{proc.stdout}")

        out_wrap_xml = os.path.join(staging, "_out_wrap.xml")
        proc = subprocess.run([java_exe, "-jar", ffdec_jar, "-swf2xml", out_wrap_gfx, out_wrap_xml], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"FFDec output swf2xml failed:\n{proc.stderr}\n{proc.stdout}")

        compiled_abcs = [t for t in ET.parse(out_wrap_xml).getroot().find("tags") if t.attrib.get("type") == "DoABC2Tag"]
        if len(compiled_abcs) < 2:
            raise RuntimeError("Compiled wrapper GFX missing target DoABC2Tag.")
        compiled_sm_tag = compiled_abcs[-1]
        _align_cinit_scopes(compiled_sm_tag.find("abc"), orig_scopes)

        for idx, tag in enumerate(list(sm_tags)):
            if tag.attrib.get("type") == "DoABC2Tag":
                sm_tags.remove(tag)
                sm_tags.insert(idx, compiled_sm_tag)
                break
        final_xml_path = os.path.join(staging, "_final.xml")
        sm_tree.write(final_xml_path, encoding="utf-8", xml_declaration=True)
        proc = subprocess.run([java_exe, "-jar", ffdec_jar, "-xml2swf", final_xml_path, out_gfx], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"FFDec final xml2swf failed:\n{proc.stderr}\n{proc.stdout}")
        return out_gfx
    finally:
        shutil.rmtree(staging, ignore_errors=True)


def build_ui_package(gfx_path: str, dist_dir: str) -> str:
    with open(gfx_path, "rb") as f:
        gfx_bytes = f.read()
    if gfx_bytes[:3] not in (b"GFX", b"CFX"):
        raise ValueError("Compiled SocialMedia GFX has invalid header.")
    if b"sbv.verified" not in gfx_bytes or b"btnVerifiedTabButton" not in gfx_bytes:
        raise ValueError("Compiled SocialMedia GFX is missing the Verified tab extension.")

    resources = [
        {
            "type": RES_TYPE_GFX,
            "group": 0x00000000,
            "instance": SOCIAL_MEDIA_GFX_INSTANCE,
            "data": gfx_bytes,
        }
    ]

    out_pkg = os.path.join(dist_dir, "SocialBunnyVerified_UI.package")
    with open(out_pkg, "wb") as f:
        f.write(create_dbpf_package(resources))
    return out_pkg


def build_ts4script(dist_dir: str) -> str:
    py37 = _find_tool(PYTHON37_CANDIDATES)
    if not py37:
        raise RuntimeError("Python 3.7 executable not found for .ts4script compilation.")

    py_root = os.path.join(PROJECT_ROOT, "src", "python")
    sbv_dir = os.path.join(py_root, "sbv")
    out_script = os.path.join(dist_dir, "SocialBunnyVerified.ts4script")

    staging = tempfile.mkdtemp(prefix="sbv_pyc_")
    try:
        staging_sbv = os.path.join(staging, "sbv")
        shutil.copytree(sbv_dir, staging_sbv, ignore=shutil.ignore_patterns("__pycache__", "save_data", "*.pyc"))

        # Compile every .py in staging_sbv with Python 3.7 legacy (-b) so .pyc sits beside .py, then remove .py
        proc = subprocess.run([py37, "-m", "compileall", "-b", "-q", staging_sbv], capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"Python 3.7 compileall failed:\n{proc.stderr}\n{proc.stdout}")

        pyc_count = 0
        with zipfile.ZipFile(out_script, "w", compression=zipfile.ZIP_STORED) as zf:
            for root, _, files in os.walk(staging_sbv):
                for fname in sorted(files):
                    if fname.endswith(".pyc"):
                        full_p = os.path.join(root, fname)
                        rel_p = os.path.relpath(full_p, staging).replace("\\", "/")
                        zf.write(full_p, arcname=rel_p)
                        pyc_count += 1
        if pyc_count == 0:
            raise RuntimeError("No .pyc files compiled into .ts4script!")
        return out_script
    finally:
        shutil.rmtree(staging, ignore_errors=True)


def validate_artifacts(ui_pkg: str, script_path: str) -> None:
    ui_entries = read_dbpf_index(ui_pkg)
    assert len(ui_entries) == 1, "UI package must contain only the targeted GFX override."
    gfx_matches = [e for e in ui_entries if e.res_type == RES_TYPE_GFX and e.instance == SOCIAL_MEDIA_GFX_INSTANCE]
    assert len(gfx_matches) == 1, "Missing SocialMedia GFX override in UI package!"
    gfx_data = read_dbpf_resource(ui_pkg, gfx_matches[0])
    assert gfx_data[:3] == b"GFX", "Decompressed GFX header invalid!"
    assert b"btnVerifiedTabButton" in gfx_data, "Verified tab ActionScript was not compiled into the GFX!"
    assert b"sbv.verified" in gfx_data, "Verified command channel was not compiled into the GFX!"

    with zipfile.ZipFile(script_path, "r") as zf:
        names = zf.namelist()
        assert "sbv/bootstrap.pyc" in names, "Missing sbv/bootstrap.pyc in .ts4script!"
        for required in (
            "sbv/verified/verified_subscription_manager.pyc",
            "sbv/verified/verified_billing_service.pyc",
            "sbv/verified/verified_persistence.pyc",
            "sbv/verified/verified_ui_bridge.pyc",
        ):
            assert required in names, f"Missing {required} in .ts4script!"
        # Verify Python 3.7 bytecode magic 3394 (0x42 0x0D 0x0D 0x0A)
        magic = zf.read("sbv/bootstrap.pyc")[:4]
        assert magic == b"\x42\x0d\x0d\x0a", f"Unexpected .pyc magic: {magic!r}"

    print(f"[VALIDATED] {os.path.basename(ui_pkg)}: {len(ui_entries)} resource (GFX={len(gfx_data)} bytes)")
    print(f"[VALIDATED] {os.path.basename(script_path)}: {len(names)} .pyc modules (magic=3394)")


def deploy_to_mods(dist_dir: str) -> None:
    mods_dir = os.path.expanduser(r"~\Documents\Electronic Arts\The Sims 4\Mods")
    if not os.path.isdir(mods_dir):
        print(f"  [WARN] Sims 4 Mods folder not found at {mods_dir}")
        return
    for fname in ("SocialBunnyVerified_UI.package", "SocialBunnyVerified.ts4script"):
        src = os.path.join(dist_dir, fname)
        dst = os.path.join(mods_dir, fname)
        if os.path.isfile(src):
            shutil.copy2(src, dst)
            print(f"  [DEPLOYED] {fname} -> {mods_dir}")


def main() -> int:
    dist_dir = os.path.join(PROJECT_ROOT, "dist")
    os.makedirs(dist_dir, exist_ok=True)
    print("=== Building Social Bunny Verified ===")
    gfx_path = compile_gfx()
    print(f"  [OK] Compiled GFX: {os.path.relpath(gfx_path, PROJECT_ROOT)}")
    ui_pkg = build_ui_package(gfx_path, dist_dir)
    print(f"  [OK] Built UI Package: {os.path.relpath(ui_pkg, PROJECT_ROOT)}")
    script_path = build_ts4script(dist_dir)
    print(f"  [OK] Built Script Archive: {os.path.relpath(script_path, PROJECT_ROOT)}")
    validate_artifacts(ui_pkg, script_path)
    if "--deploy" in sys.argv:
        deploy_to_mods(dist_dir)
    return 0


if __name__ == "__main__":
    sys.exit(main())
