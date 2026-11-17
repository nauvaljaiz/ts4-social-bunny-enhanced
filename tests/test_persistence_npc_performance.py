# -*- coding: utf-8 -*-
"""Tests for save-slot persistence, corruption recovery, NPC batches, and large-world performance."""

import os
import sys
import tempfile
import time
import unittest

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))

from sbv.services.social_bunny_service import SocialBunnyVerifiedService


class TestPersistenceNPCAndPerformance(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="sbv_test_pers_")
        self.sbv = SocialBunnyVerifiedService(data_dir=self.tmp)
        self.sbv.set_clock_override(80000)

    def test_save_reload_and_backup_recovery(self):
        self.sbv.ensure_loaded(force_slot_id=7)
        acc = self.sbv.accounts.ensure_account(900, display_name="Save Tester", now_ticks=80000)
        acc["verification_tier"] = "blue_verified"
        self.sbv.profiles.update_bio(900, "Survives reload!")
        self.sbv.create_post(900, "Persistent post #Saved")
        self.assertTrue(self.sbv.save(slot_id=7))
        # Save twice to populate .bak
        self.sbv.profiles.update_bio(900, "Survives reload v2!")
        self.assertTrue(self.sbv.save(slot_id=7))

        # Corrupt primary file and verify automatic .bak fallback recovery
        slot_path = self.sbv.persistence.get_slot_file_path(7)
        with open(slot_path, "w", encoding="utf-8") as f:
            f.write("{CORRUPTED_JSON")

        reloaded = SocialBunnyVerifiedService(data_dir=self.tmp)
        reloaded.ensure_loaded(force_slot_id=7)
        r_acc = reloaded.accounts.get_account(900)
        self.assertIsNotNone(r_acc)
        self.assertEqual(r_acc["verification_tier"], "blue_verified")
        self.assertEqual(len(reloaded.posts.get_posts_by_author(900)), 1)

    def test_npc_batch_and_large_population_performance(self):
        t0 = time.time()
        records = [{"sim_id": 1000 + i, "name": "Townie {}".format(i), "fame_level": i % 5} for i in range(200)]
        for r in records:
            self.sbv.accounts.ensure_account(r["sim_id"], display_name=r["name"], is_npc=True, fame_level=r["fame_level"])
        # Heavy follower graph (1000 edges) and 250 posts
        for i in range(200):
            src = 1000 + i
            for step in range(1, 6):
                dst = 1000 + ((i + step * 7) % 200)
                self.sbv.followers.follow(src, dst)
            self.sbv.create_post(src, "Large world post {} #Perf".format(i))

        stats = self.sbv.npc_service.run_batch(max_npcs=8)
        self.assertEqual(stats["processed"], 8)

        t_snap_start = time.time()
        snap = self.sbv.build_ui_snapshot(1000)
        snap_elapsed = time.time() - t_snap_start
        total_elapsed = time.time() - t0

        self.assertIn("feed", snap)
        self.assertLess(snap_elapsed, 1.0, "Snapshot generation too slow: {:.3f}s".format(snap_elapsed))
        self.assertLess(total_elapsed, 3.0)


if __name__ == "__main__":
    unittest.main()
