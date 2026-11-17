# -*- coding: utf-8 -*-
"""
DBPF 2.1 package reader and writer for The Sims 4.

Supports reading standard EA DBPF 2.1 packages (with constant Type/Group/InstHi
index flags and zlib/uncompressed resource payloads) as well as creating clean
DBPF 2.1 override packages.
"""

import struct
import zlib
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple


DBPF_MAGIC = b"DBPF"

# Common Sims 4 Resource Type IDs
RES_TYPE_TUNING = 0x03B33DDF
RES_TYPE_PIE_CATEGORY = 0x03E9D964
RES_TYPE_SIMDATA = 0x545AC67A
RES_TYPE_STBL = 0x220557DA
RES_TYPE_DDS = 0x00B2D882
RES_TYPE_PNG = 0x2F7D0004
RES_TYPE_GFX = 0x62ECC59A
RES_TYPE_INTERACTION = 0xE882D22F
RES_TYPE_BUFF = 0x6017E896
RES_TYPE_LOOT = 0x0C772E27
RES_TYPE_STATISTIC = 0x339BC5BD
RES_TYPE_SNIPPET = 0x7DF2169C
RES_TYPE_LAYOUT = 0x025C95B6  # EA UI Layout / Atlas / Misc


@dataclass
class DBPFEntry:
    """Single resource entry inside a DBPF 2.1 archive."""

    res_type: int
    res_group: int
    instance: int
    offset: int
    comp_size: int
    decomp_size: int
    comp_type: int
    committed: int
    source_path: str = ""

    @property
    def key_tuple(self) -> Tuple[int, int, int]:
        return (self.res_type, self.res_group, self.instance)

    @property
    def key_str(self) -> str:
        return f"{self.res_type:08X}:{self.res_group:08X}:{self.instance:016X}"


def read_dbpf_index(package_path: str) -> List[DBPFEntry]:
    """Read the resource index table from a Sims 4 DBPF 2.1 package."""
    entries: List[DBPFEntry] = []
    with open(package_path, "rb") as f:
        header = f.read(96)
        if len(header) < 96 or header[:4] != DBPF_MAGIC:
            raise ValueError(f"Not a valid DBPF file: {package_path}")

        major, minor = struct.unpack_from("<II", header, 4)
        if major != 2:
            raise ValueError(f"Unsupported DBPF major version {major} in {package_path}")

        entry_count = struct.unpack_from("<I", header, 36)[0]
        index_pos_32 = struct.unpack_from("<I", header, 40)[0]
        index_size = struct.unpack_from("<I", header, 44)[0]
        index_pos_64 = struct.unpack_from("<Q", header, 64)[0]
        index_offset = index_pos_64 if index_pos_64 != 0 else index_pos_32

        if entry_count == 0 or index_size == 0:
            return entries

        f.seek(index_offset)
        index_buf = f.read(index_size)
        if len(index_buf) < 4:
            return entries

        flags = struct.unpack_from("<I", index_buf, 0)[0]
        cursor = 4

        const_type = None
        const_group = None
        const_inst_hi = None

        if flags & 0x01:
            const_type = struct.unpack_from("<I", index_buf, cursor)[0]
            cursor += 4
        if flags & 0x02:
            const_group = struct.unpack_from("<I", index_buf, cursor)[0]
            cursor += 4
        if flags & 0x04:
            const_inst_hi = struct.unpack_from("<I", index_buf, cursor)[0]
            cursor += 4

        for _ in range(entry_count):
            if const_type is None:
                res_type = struct.unpack_from("<I", index_buf, cursor)[0]
                cursor += 4
            else:
                res_type = const_type

            if const_group is None:
                res_group = struct.unpack_from("<I", index_buf, cursor)[0]
                cursor += 4
            else:
                res_group = const_group

            if const_inst_hi is None:
                inst_hi = struct.unpack_from("<I", index_buf, cursor)[0]
                cursor += 4
            else:
                inst_hi = const_inst_hi

            inst_lo, offset, comp_field, decomp_size = struct.unpack_from("<IIII", index_buf, cursor)
            cursor += 16

            has_compression = bool(comp_field & 0x80000000)
            comp_size = comp_field & 0x7FFFFFFF

            if has_compression:
                comp_type, committed = struct.unpack_from("<HH", index_buf, cursor)
                cursor += 4
            else:
                comp_type, committed = 0, 1

            instance = (inst_hi << 32) | inst_lo
            entries.append(
                DBPFEntry(
                    res_type=res_type,
                    res_group=res_group,
                    instance=instance,
                    offset=offset,
                    comp_size=comp_size,
                    decomp_size=decomp_size,
                    comp_type=comp_type,
                    committed=committed,
                    source_path=package_path,
                )
            )
    return entries


def read_dbpf_resource(package_path: str, entry: DBPFEntry) -> bytes:
    """Extract and decompress a single resource from a DBPF 2.1 archive."""
    with open(package_path, "rb") as f:
        f.seek(entry.offset)
        raw = f.read(entry.comp_size)

    if entry.comp_type == 0x0000:
        return raw
    if entry.comp_type == 0x5A42:
        return zlib.decompress(raw)
    if entry.comp_type == 0xFFFF:
        return _decompress_refpack(raw)
    raise NotImplementedError(f"Unsupported DBPF compression type 0x{entry.comp_type:04X} for {entry.key_str}")


def _decompress_refpack(data: bytes) -> bytes:
    """Decompress EA RefPack / QFS stream if encountered in older packages."""
    if len(data) < 5:
        return data
    pos = 0
    flags = data[pos]
    pos += 1
    if data[pos] != 0xFB:
        raise ValueError("Invalid RefPack header")
    pos += 1
    size_bytes = 4 if (flags & 0x80) else 3
    if flags & 0x01:
        pos += size_bytes  # compressed size
    uncomp_size = 0
    for _ in range(size_bytes):
        uncomp_size = (uncomp_size << 8) | data[pos]
        pos += 1

    out = bytearray()
    while pos < len(data):
        ctrl = data[pos]
        pos += 1
        if ctrl < 0x80:
            b1 = data[pos]
            pos += 1
            num_plain = ctrl & 0x03
            num_copy = ((ctrl >> 2) & 0x07) + 3
            offset = ((ctrl & 0x60) << 3) + b1 + 1
        elif ctrl < 0xC0:
            b1 = data[pos]
            b2 = data[pos + 1]
            pos += 2
            num_plain = (b1 >> 6) & 0x03
            num_copy = (ctrl & 0x3F) + 4
            offset = ((b1 & 0x3F) << 8) + b2 + 1
        elif ctrl < 0xE0:
            b1 = data[pos]
            b2 = data[pos + 1]
            b3 = data[pos + 2]
            pos += 3
            num_plain = ctrl & 0x03
            num_copy = ((ctrl & 0x0C) << 6) + b3 + 5
            offset = ((ctrl & 0x10) << 12) + (b1 << 8) + b2 + 1
        elif ctrl < 0xFC:
            num_plain = ((ctrl & 0x1F) + 1) * 4
            num_copy = 0
            offset = 0
        else:
            num_plain = ctrl & 0x03
            if num_plain:
                out.extend(data[pos : pos + num_plain])
                pos += num_plain
            break

        if num_plain:
            out.extend(data[pos : pos + num_plain])
            pos += num_plain
        for _ in range(num_copy):
            out.append(out[-offset])
    return bytes(out)


def create_dbpf_package(resources: List[Dict]) -> bytes:
    """Build a valid Sims 4 DBPF 2.1 package from a list of {type, group, instance, data}."""
    header_size = 96
    data_bytes = bytearray()
    index_entries = []
    current_offset = header_size

    for res in resources:
        raw_data = res["data"]
        compressed = zlib.compress(raw_data)
        data_bytes.extend(compressed)
        index_entries.append(
            {
                "type": res["type"],
                "group": res["group"],
                "instance": res["instance"],
                "pos": current_offset,
                "comp_size": len(compressed),
                "decomp_size": len(raw_data),
            }
        )
        current_offset += len(compressed)

    index_offset = current_offset
    index_bytes = bytearray()
    index_bytes.extend(struct.pack("<I", 0))

    for entry in index_entries:
        inst_hi = (entry["instance"] >> 32) & 0xFFFFFFFF
        inst_lo = entry["instance"] & 0xFFFFFFFF
        comp_size_field = entry["comp_size"] | 0x80000000
        index_bytes.extend(
            struct.pack(
                "<IIIIIIIHH",
                entry["type"],
                entry["group"],
                inst_hi,
                inst_lo,
                entry["pos"],
                comp_size_field,
                entry["decomp_size"],
                0x5A42,
                1,
            )
        )

    index_size = len(index_bytes)

    header = bytearray()
    header.extend(b"DBPF")
    header.extend(struct.pack("<II", 2, 1))
    header.extend(struct.pack("<II", 0, 0))
    header.extend(struct.pack("<I", 0))
    header.extend(struct.pack("<II", 0, 0))
    header.extend(struct.pack("<I", 0))
    header.extend(struct.pack("<III", len(resources), index_offset & 0xFFFFFFFF, index_size))
    header.extend(b"\x00" * 12)
    header.extend(struct.pack("<I", 3))
    header.extend(struct.pack("<Q", index_offset))
    header.extend(b"\x00" * 24)
    assert len(header) == 96
    return bytes(header + data_bytes + index_bytes)
