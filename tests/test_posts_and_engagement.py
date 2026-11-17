# -*- coding: utf-8 -*-
"""Tests for posts, comments, duplicate-safe reactions, contextual text, and engagement analytics."""

import os
import sys
import tempfile
import unittest

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))

from sbv.core.models import PostType
from sbv.services.social_bunny_service import SocialBunnyVerifiedService


class TestPostsAndEngagement(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="sbv_test_post_")
        self.sbv = SocialBunnyVerifiedService(data_dir=self.tmp)
        self.sbv.set_clock_override(20000)
        self.sbv.accounts.ensure_account(10, display_name="Nina Caliente")
        self.sbv.accounts.ensure_account(11, display_name="Don Lothario")
        self.sbv.accounts.ensure_account(12, display_name="Dina Caliente")

    def test_post_like_comment_repost_save_delete(self):
        post = self.sbv.create_post(10, "Sunset walk in Oasis Springs! #Vibes", post_type=PostType.PHOTO)
        pid = post["post_id"]

        # Duplicate-safe idempotent likes + toggle
        r1 = self.sbv.like_post(11, pid, is_toggle=False)
        r2 = self.sbv.like_post(11, pid, is_toggle=False)
        self.assertTrue(r1["liked"])
        self.assertFalse(r2["liked"])
        self.assertEqual(len(self.sbv.posts.get_post(pid)["likes"]), 1)

        # Toggle unlike
        r3 = self.sbv.like_post(11, pid, is_toggle=True)
        self.assertFalse(r3["liked"])
        self.assertEqual(len(self.sbv.posts.get_post(pid)["likes"]), 0)

        # Comment & reply & delete
        c1 = self.sbv.add_comment(12, pid, "Love that lighting!")
        self.assertTrue(c1["ok"])
        cid = c1["comment"]["comment_id"]
        c2 = self.sbv.add_comment(10, pid, "Thanks sis!", parent_comment_id=cid)
        self.assertTrue(c2["ok"])
        self.assertEqual(len(self.sbv.posts.get_post(pid)["comments"]), 2)

        # Unauthorized delete fails; owner delete succeeds
        self.assertFalse(self.sbv.posts.delete_comment(pid, cid, 11))
        self.assertTrue(self.sbv.posts.delete_comment(pid, cid, 12))
        self.assertEqual(len(self.sbv.posts.get_post(pid)["comments"]), 1)

        # Repost & save
        self.assertTrue(self.sbv.posts.toggle_repost(pid, 11)["reposted"])
        self.assertTrue(self.sbv.posts.toggle_save(pid, 11)["saved"])

    def test_engagement_formula_and_zero_reach_safety(self):
        self.assertEqual(self.sbv.engagement.calculate_engagement_rate(5, 2, 1, 0), 0.0)
        self.assertEqual(self.sbv.engagement.calculate_engagement_rate(5, 3, 2, 20), 50.0)

        p = self.sbv.create_post(10, "First post #Test", post_type=PostType.TEXT)
        self.sbv.like_post(11, p["post_id"])
        self.sbv.add_comment(12, p["post_id"], "Nice!")
        dash = self.sbv.analytics.build_dashboard(10, self.sbv.accounts.get_account(10), period_key="7d", now_ticks=20000)
        self.assertEqual(dash["summary"]["likes"], 1)
        self.assertEqual(dash["summary"]["comments"], 1)
        self.assertGreater(dash["summary"]["engagement_rate"], 0.0)

    def test_contextual_content_avoids_immediate_repeats(self):
        seen = []
        for _ in range(4):
            txt, _ = self.sbv.posts.generate_contextual_content(10, mood="happy", traits=["creative"], career="Painter")
            seen.append(txt)
        self.assertGreater(len(set(seen)), 1)


if __name__ == "__main__":
    unittest.main()
