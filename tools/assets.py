# -*- coding: utf-8 -*-
"""
Pure-Python image & STBL asset helpers for Social Bunny Verified.

- Reads RGBA PNG files (using zlib/struct, zero external dependencies).
- Resizes RGBA images cleanly (bilinear filter).
- Generates crisp anti-aliased UI icons (Verified, Official, Creator, Legacy,
  Home, Explore, Notifications, Profile, Dashboard, Settings, Heart, Comment,
  Repost, Bookmark, Search, Shield, Lock).
- Encodes 32-bit BGRA DDS (0x00B2D882), RGBA PNG (0x2F7D0004), and STBL (0x220557DA).
"""

import math
import struct
import zlib
from typing import Dict, List, Tuple


TS4_LOCALES = [
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,
    0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x11, 0x12, 0x13, 0x15,
]


def _paeth(a: int, b: int, c: int) -> int:
    p = a + b - c
    pa = abs(p - a)
    pb = abs(p - b)
    pc = abs(p - c)
    if pa <= pb and pa <= pc:
        return a
    if pb <= pc:
        return b
    return c


def load_png_rgba(path: str) -> Tuple[int, int, List[List[Tuple[int, int, int, int]]]]:
    """Decode an 8-bit PNG (RGB or RGBA) into rows of (r, g, b, a) tuples."""
    with open(path, "rb") as f:
        data = f.read()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"Not a PNG file: {path}")

    pos = 8
    width = height = bit_depth = color_type = 0
    idat_chunks = []
    while pos < len(data):
        length = struct.unpack_from(">I", data, pos)[0]
        ctype = data[pos + 4 : pos + 8]
        cdata = data[pos + 8 : pos + 8 + length]
        pos += 12 + length
        if ctype == b"IHDR":
            width, height, bit_depth, color_type, _, _, _ = struct.unpack(">IIBBBBB", cdata)
            if bit_depth != 8 or color_type not in (2, 6):
                raise ValueError(f"Unsupported PNG format bit={bit_depth} color={color_type}")
        elif ctype == b"IDAT":
            idat_chunks.append(cdata)
        elif ctype == b"IEND":
            break

    raw = zlib.decompress(b"".join(idat_chunks))
    bpp = 4 if color_type == 6 else 3
    stride = width * bpp
    rows_bytes = []
    idx = 0
    prev_row = bytes(stride)

    for _ in range(height):
        ftype = raw[idx]
        idx += 1
        scan = bytearray(raw[idx : idx + stride])
        idx += stride

        if ftype == 1:  # Sub
            for i in range(bpp, stride):
                scan[i] = (scan[i] + scan[i - bpp]) & 0xFF
        elif ftype == 2:  # Up
            for i in range(stride):
                scan[i] = (scan[i] + prev_row[i]) & 0xFF
        elif ftype == 3:  # Average
            for i in range(stride):
                left = scan[i - bpp] if i >= bpp else 0
                scan[i] = (scan[i] + ((left + prev_row[i]) >> 1)) & 0xFF
        elif ftype == 4:  # Paeth
            for i in range(stride):
                left = scan[i - bpp] if i >= bpp else 0
                up = prev_row[i]
                up_left = prev_row[i - bpp] if i >= bpp else 0
                scan[i] = (scan[i] + _paeth(left, up, up_left)) & 0xFF

        prev_row = bytes(scan)
        row_rgba = []
        if bpp == 4:
            for x in range(0, stride, 4):
                row_rgba.append((scan[x], scan[x + 1], scan[x + 2], scan[x + 3]))
        else:
            for x in range(0, stride, 3):
                row_rgba.append((scan[x], scan[x + 1], scan[x + 2], 255))
        rows_bytes.append(row_rgba)
    return width, height, rows_bytes


def resize_rgba(
    rows: List[List[Tuple[int, int, int, int]]],
    target_w: int,
    target_h: int,
) -> List[List[Tuple[int, int, int, int]]]:
    """Bilinear resize of RGBA pixel grid."""
    src_h = len(rows)
    src_w = len(rows[0]) if src_h else 0
    if src_w == target_w and src_h == target_h:
        return rows
    out = []
    for y in range(target_h):
        sy = (y + 0.5) * src_h / target_h - 0.5
        y0 = max(0, min(src_h - 1, int(math.floor(sy))))
        y1 = max(0, min(src_h - 1, y0 + 1))
        wy = max(0.0, min(1.0, sy - y0))
        row = []
        for x in range(target_w):
            sx = (x + 0.5) * src_w / target_w - 0.5
            x0 = max(0, min(src_w - 1, int(math.floor(sx))))
            x1 = max(0, min(src_w - 1, x0 + 1))
            wx = max(0.0, min(1.0, sx - x0))
            p00 = rows[y0][x0]
            p10 = rows[y0][x1]
            p01 = rows[y1][x0]
            p11 = rows[y1][x1]
            rgba = []
            for ch in range(4):
                v = (
                    p00[ch] * (1.0 - wx) * (1.0 - wy)
                    + p10[ch] * wx * (1.0 - wy)
                    + p01[ch] * (1.0 - wx) * wy
                    + p11[ch] * wx * wy
                )
                rgba.append(int(max(0, min(255, round(v)))))
            row.append(tuple(rgba))
        out.append(row)
    return out


def encode_png_rgba(rows: List[List[Tuple[int, int, int, int]]]) -> bytes:
    """Encode RGBA pixel grid into valid 8-bit RGBA PNG bytes."""
    height = len(rows)
    width = len(rows[0]) if height else 0

    def _chunk(tag: bytes, payload: bytes) -> bytes:
        crc = zlib.crc32(tag + payload) & 0xFFFFFFFF
        return struct.pack(">I", len(payload)) + tag + payload + struct.pack(">I", crc)

    raw = bytearray()
    for row in rows:
        raw.append(0)  # Filter None
        for r, g, b, a in row:
            raw.extend((r, g, b, a))

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + _chunk(b"IHDR", ihdr)
        + _chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + _chunk(b"IEND", b"")
    )


def encode_dds_bgra(rows: List[List[Tuple[int, int, int, int]]]) -> bytes:
    """Encode RGBA pixel grid into uncompressed 32-bit BGRA DDS (Type 0x00B2D882)."""
    height = len(rows)
    width = len(rows[0]) if height else 0
    pitch = width * 4

    header = bytearray(128)
    header[0:4] = b"DDS "
    struct.pack_into("<I", header, 4, 124)       # dwSize
    struct.pack_into("<I", header, 8, 0x0002100F)  # CAPS | HEIGHT | WIDTH | PIXELFORMAT | PITCH
    struct.pack_into("<I", header, 12, height)
    struct.pack_into("<I", header, 16, width)
    struct.pack_into("<I", header, 20, pitch)
    struct.pack_into("<I", header, 76, 32)       # ddspf.dwSize
    struct.pack_into("<I", header, 80, 0x41)     # DDPF_RGB | DDPF_ALPHAPIXELS
    struct.pack_into("<I", header, 88, 32)       # dwRGBBitCount
    struct.pack_into("<I", header, 92, 0x00FF0000)   # R
    struct.pack_into("<I", header, 96, 0x0000FF00)   # G
    struct.pack_into("<I", header, 100, 0x000000FF)  # B
    struct.pack_into("<I", header, 104, 0xFF000000)  # A
    struct.pack_into("<I", header, 108, 0x1000)      # DDSCAPS_TEXTURE

    pixels = bytearray(width * height * 4)
    idx = 0
    for row in rows:
        for r, g, b, a in row:
            pixels[idx] = b
            pixels[idx + 1] = g
            pixels[idx + 2] = r
            pixels[idx + 3] = a
            idx += 4
    return bytes(header) + bytes(pixels)


def _blend(bg: Tuple[int, int, int, int], fg: Tuple[int, int, int, int]) -> Tuple[int, int, int, int]:
    fr, fg_, fb, fa = fg
    br, bg_, bb, ba = bg
    af = fa / 255.0
    ab = ba / 255.0
    oa = af + ab * (1.0 - af)
    if oa <= 1e-6:
        return (0, 0, 0, 0)
    return (
        int(max(0, min(255, round((fr * af + br * ab * (1.0 - af)) / oa)))),
        int(max(0, min(255, round((fg_ * af + bg_ * ab * (1.0 - af)) / oa)))),
        int(max(0, min(255, round((fb * af + bb * ab * (1.0 - af)) / oa)))),
        int(max(0, min(255, round(oa * 255.0)))),
    )


def _sd_segment(px: float, py: float, ax: float, ay: float, bx: float, by: float) -> float:
    vx, vy = bx - ax, by - ay
    wx, wy = px - ax, py - ay
    c1 = vx * wx + vy * wy
    if c1 <= 0.0:
        return math.hypot(px - ax, py - ay)
    c2 = vx * vx + vy * vy
    if c2 <= c1:
        return math.hypot(px - bx, py - by)
    t = c1 / c2
    return math.hypot(px - (ax + t * vx), py - (ay + t * vy))


def render_badge_rgba(kind: str, size: int = 64) -> List[List[Tuple[int, int, int, int]]]:
    """
    Render crisp anti-aliased seal badge icons:
    - 'official': Gold/amber scalloped seal with white check
    - 'creator': Purple/indigo creator star/sparkle seal
    - 'legacy': Silver/slate legacy seal with check
    """
    palette = {
        "official": (235, 168, 28),
        "creator": (139, 92, 246),
        "legacy": (100, 116, 139),
        "verified": (29, 155, 240),
    }
    r_col, g_col, b_col = palette.get(kind, (29, 155, 240))
    cx = (size - 1) / 2.0
    cy = (size - 1) / 2.0
    base_r = size * 0.38
    amp = size * 0.055
    lobes = 10

    rows = []
    for y in range(size):
        row = []
        for x in range(size):
            dx = x - cx
            dy = y - cy
            ang = math.atan2(dy, dx)
            dist = math.hypot(dx, dy)
            seal_r = base_r + amp * math.cos(lobes * ang)
            sd_seal = dist - seal_r

            px = (x - cx) / size
            py = (y - cy) / size
            if kind == "creator":
                # 4-point sparkle star inside badge
                d1 = _sd_segment(px, py, 0.0, -0.20, 0.0, 0.20) - 0.045
                d2 = _sd_segment(px, py, -0.20, 0.0, 0.20, 0.0) - 0.045
                sd_mark = min(d1, d2) * size
            else:
                # Checkmark
                d1 = _sd_segment(px, py, -0.17, 0.02, -0.04, 0.15) - 0.055
                d2 = _sd_segment(px, py, -0.04, 0.15, 0.20, -0.13) - 0.055
                sd_mark = min(d1, d2) * size

            col = (0, 0, 0, 0)
            a_seal = max(0.0, min(1.0, 0.8 - sd_seal))
            if a_seal > 0.0:
                col = _blend(col, (r_col, g_col, b_col, int(round(a_seal * 255))))
            a_mark = max(0.0, min(1.0, 0.8 - sd_mark))
            if a_mark > 0.0 and sd_seal < 0.5:
                col = _blend(col, (255, 255, 255, int(round(a_mark * 255))))
            row.append(col)
        rows.append(row)
    return rows


def create_stbl_binary(strings_dict: Dict[int, str]) -> bytes:
    """Create a Sims 4 STBL v5 binary table."""
    entries_bytes = bytearray()
    total_str_len = 0
    for key, text in sorted(strings_dict.items(), key=lambda x: x[0]):
        text_bytes = str(text).encode("utf-8")
        total_str_len += len(text_bytes) + 1
        entries_bytes.extend(struct.pack("<IBH", key & 0xFFFFFFFF, 0, len(text_bytes)))
        entries_bytes.extend(text_bytes)

    header = bytearray()
    header.extend(b"STBL")
    header.extend(struct.pack("<H", 5))
    header.extend(b"\x00")
    header.extend(struct.pack("<Q", len(strings_dict)))
    header.extend(b"\x00\x00")
    header.extend(struct.pack("<I", total_str_len))
    return bytes(header + entries_bytes)
