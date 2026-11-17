# -*- coding: utf-8 -*-
"""Tests for the native Verified bridge packets and packaged override."""

import json
import os
import sys
import unittest
import zipfile

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "tools"))

GENERATED_ZIP = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4\Game\Bin\Python\generated.zip"
CORE_ZIP = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4\Data\Simulation\Gameplay\core.zip"
if os.path.isfile(GENERATED_ZIP) and GENERATED_ZIP not in sys.path:
    sys.path.insert(0, GENERATED_ZIP)
if os.path.isfile(CORE_ZIP) and CORE_ZIP not in sys.path:
    sys.path.insert(0, CORE_ZIP)

from dbpf import RES_TYPE_GFX, read_dbpf_index, read_dbpf_resource
from sbv.verified.verified_ui_bridge import (
    RAW_TEXT_STBL_HASH,
    _decode_arg,
    _raw_localized_string,
    encode_snapshot_to_packets,
)


class TestVerifiedUIBridgeAndPackages(unittest.TestCase):
    def test_arg_decoding_and_chunked_state_packets(self):
        self.assertEqual(_decode_arg("%."), "")
        self.assertEqual(_decode_arg(""), "")
        self.assertEqual(_decode_arg("Hello%20Sim"), "Hello Sim")

        # The GFX LocKey.toString() returns "" when hash == 0, so raw state text
        # must use the base-game {0.String} hash and a RAW_TEXT token.
        from protocolbuffers import Localization_pb2

        raw = _raw_localized_string('{"kind":"social_bunny_verified"}')
        self.assertEqual(raw.hash, RAW_TEXT_STBL_HASH)
        self.assertEqual(raw.tokens[0].type, Localization_pb2.LocalizedStringToken.RAW_TEXT)
        self.assertEqual(raw.tokens[0].raw_text, '{"kind":"social_bunny_verified"}')

        snapshot = {
            "version": 2,
            "account": {"sim_id": "101", "username": "alex.tester"},
            "plan": {"price_label": "\u00a7250", "billing_interval_label": "per Sim week"},
            "subscription": {"status": "active", "status_label": "Active"},
            "benefits": [{"title": "Blue verification badge", "description": "Official blue check."}],
        }
        packets = encode_snapshot_to_packets(101, snapshot, 12345)
        self.assertGreaterEqual(len(packets), 1)
        self.assertTrue(all(packet.post_type == 0 for packet in packets))
        self.assertEqual(packets[0].post_id, 9000000)
        joined = "".join(packet.post_text.tokens[0].raw_text for packet in packets)
        parsed = json.loads(joined)
        self.assertEqual(parsed["subscription"]["status"], "active")
        self.assertEqual(parsed["plan"]["price_label"], "\u00a7250")

    def test_dist_ui_package_overrides_only_the_intended_gfx(self):
        ui_pkg = os.path.join(PROJECT_ROOT, "dist", "SocialBunnyVerified_UI.package")
        ts4_script = os.path.join(PROJECT_ROOT, "dist", "SocialBunnyVerified.ts4script")
        self.assertTrue(os.path.isfile(ui_pkg), "Build the UI package before running this test.")
        self.assertTrue(os.path.isfile(ts4_script), "Build the script archive before running this test.")

        entries = read_dbpf_index(ui_pkg)
        self.assertEqual(len(entries), 1, "The UI package must be a targeted single-resource override.")
        gfx_entries = [entry for entry in entries if entry.res_type == RES_TYPE_GFX]
        self.assertEqual(len(gfx_entries), 1)
        self.assertEqual(gfx_entries[0].res_group, 0)
        self.assertEqual(gfx_entries[0].instance, 0x8ABB350F01880C64)

        gfx_data = read_dbpf_resource(ui_pkg, gfx_entries[0])
        self.assertEqual(gfx_data[:4], b"GFX\x0e")
        for token in (
            b"btnVerifiedTabButton",
            b"sbv.verified",
            b"Social Bunny Verified",
            b"Confirm Social Bunny Verified",
            b"SocialMediaPanel",
            b"SocialMediaFeedTabPanel",
        ):
            self.assertIn(token, gfx_data)

        with zipfile.ZipFile(ts4_script, "r") as archive:
            names = archive.namelist()
            self.assertIn("sbv/bootstrap.pyc", names)
            self.assertIn("sbv/verified/verified_subscription_manager.pyc", names)
            self.assertIn("sbv/verified/verified_billing_service.pyc", names)
            self.assertIn("sbv/verified/verified_persistence.pyc", names)
            self.assertEqual(archive.read("sbv/bootstrap.pyc")[:4], b"\x42\x0d\x0d\x0a")

    def test_all_vanilla_scripts_except_panel_are_unchanged(self):
        original = os.path.join(PROJECT_ROOT, "src", "gfx", "decompiled", "SocialMedia", "scripts")
        current = os.path.join(PROJECT_ROOT, "src", "gfx", "scripts")
        compared = 0
        for root, _dirs, files in os.walk(original):
            for filename in files:
                if not filename.endswith(".as"):
                    continue
                original_path = os.path.join(root, filename)
                relative = os.path.relpath(original_path, original).replace("\\", "/")
                if relative in (
                    "widgets/Gameplay/SocialMedia/SocialMediaPanel.as",
                    "widgets/Gameplay/SocialMedia/SocialMediaReactionCellView.as",
                    "widgets/Gameplay/SocialMedia/SocialMediaFeedCellView.as",
                ):
                    continue
                current_path = os.path.join(current, relative)
                with open(original_path, "rb") as handle:
                    expected = handle.read()
                with open(current_path, "rb") as handle:
                    actual = handle.read()
                self.assertEqual(actual, expected, msg="Vanilla script changed: {}".format(relative))
                compared += 1
        self.assertGreaterEqual(compared, 28)


if __name__ == "__main__":
    unittest.main()
