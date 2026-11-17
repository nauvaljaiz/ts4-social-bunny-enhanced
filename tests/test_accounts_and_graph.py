# -*- coding: utf-8 -*-
"""Tests for account identity, categories, privacy, and sparse social graph."""

import os
import sys
import tempfile
import unittest

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))

from sbv.core.models import AccountCategory, AccountPrivacy, VerificationTier
from sbv.services.social_bunny_service import SocialBunnyVerifiedService


class TestAccountsAndGraph(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="sbv_test_acc_")
        self.sbv = SocialBunnyVerifiedService(data_dir=self.tmp)
        self.sbv.set_clock_override(10000)

    def test_deterministic_unique_usernames_and_rename(self):
        a1 = self.sbv.accounts.ensure_account(101, display_name="Bella Goth", now_ticks=1000)
        a2 = self.sbv.accounts.ensure_account(102, display_name="Bella Goth", now_ticks=1000)
        self.assertEqual(a1["username"], "bella.goth")
        self.assertEqual(a2["username"], "bella.goth2")

        # Duplicate rename rejected
        bad = self.sbv.accounts.change_username(102, "@bella.goth")
        self.assertFalse(bad["ok"])

        # Valid rename accepted
        good = self.sbv.accounts.change_username(102, "real_bella_g")
        self.assertTrue(good["ok"])
        self.assertEqual(self.sbv.accounts.get_account(102)["username"], "real_bella_g")

    def test_categories_and_private_account_requests(self):
        self.sbv.accounts.ensure_account(1, display_name="Alex Sim")
        self.sbv.accounts.ensure_account(2, display_name="Bob Sim")

        self.assertTrue(self.sbv.accounts.set_category(1, AccountCategory.CREATOR)["ok"])
        # Creator category gives Creator badge, NOT Blue Verified
        acc1 = self.sbv.accounts.get_account(1)
        self.assertEqual(self.sbv.accounts.get_effective_badge(acc1), VerificationTier.CREATOR)
        self.assertFalse(self.sbv.accounts.is_verified_blue_or_official(acc1))

        # Private account follow request flow
        self.sbv.accounts.set_privacy(1, AccountPrivacy.PRIVATE)
        res = self.sbv.follow_account(2, 1)
        self.assertEqual(res["status"], "requested")
        self.assertFalse(self.sbv.profiles.can_view_private_content(1, 2, self.sbv.followers))

        self.assertTrue(self.sbv.respond_follow_request(1, 2, approve=True))
        self.assertTrue(self.sbv.followers.is_following(2, 1))
        self.assertTrue(self.sbv.profiles.can_view_private_content(1, 2, self.sbv.followers))

    def test_block_restrict_mute_and_mutuals(self):
        for sid, nm in ((1, "Sim A"), (2, "Sim B"), (3, "Sim C")):
            self.sbv.accounts.ensure_account(sid, display_name=nm)
        self.sbv.follow_account(3, 1)
        self.sbv.follow_account(3, 2)
        self.assertEqual(self.sbv.followers.get_mutual_followers(1, 2), ["3"])

        self.sbv.follow_account(1, 2)
        self.assertTrue(self.sbv.followers.block(2, 1))
        self.assertFalse(self.sbv.followers.is_following(1, 2))
        res = self.sbv.follow_account(1, 2)
        self.assertFalse(res["ok"])

        self.assertTrue(self.sbv.followers.toggle_mute(1, 3))
        self.assertTrue(self.sbv.followers.is_muted(1, 3))
        self.assertTrue(self.sbv.followers.toggle_restrict(1, 3))
        self.assertTrue(self.sbv.followers.is_restricted(1, 3))


if __name__ == "__main__":
    unittest.main()
