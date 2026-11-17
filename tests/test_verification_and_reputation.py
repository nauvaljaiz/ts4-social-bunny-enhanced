# -*- coding: utf-8 -*-
"""Tests for verification scoring, workflow, controversy cascades, moderation, and brand deals."""

import os
import sys
import tempfile
import unittest

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))

from sbv.core.models import (
    AccountCategory,
    AccountStatus,
    ApplicationStatus,
    ModerationAction,
    PostType,
    VerificationTier,
)
from sbv.services.social_bunny_service import SocialBunnyVerifiedService


class TestVerificationAndReputation(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="sbv_test_ver_")
        self.sbv = SocialBunnyVerifiedService(data_dir=self.tmp)
        self.sbv.set_clock_override(50000)

    def test_verification_eligibility_rejection_cooldown_and_approval(self):
        # Fresh low-activity Sim should NOT be eligible
        acc = self.sbv.accounts.ensure_account(200, display_name="Rookie Sim", now_ticks=50000)
        elig_low = self.sbv.get_verification_eligibility(200)
        self.assertFalse(elig_low["eligible"])
        self.assertEqual(elig_low["status"], ApplicationStatus.NOT_ELIGIBLE)

        # Submit -> rejected -> cooldown active
        sub = self.sbv.submit_verification_application(200, VerificationTier.BLUE_VERIFIED, "Please verify me")
        self.assertTrue(sub["ok"])
        rev = self.sbv.process_pending_verification(200, auto_review=True)
        self.assertFalse(rev["approved"])
        self.assertEqual(rev["application"]["decision"], ApplicationStatus.REJECTED)
        sub_again = self.sbv.submit_verification_application(200, VerificationTier.BLUE_VERIFIED, "Retry")
        self.assertFalse(sub_again["ok"])

        # Famous creator with bio, followers, posts, and engagement BECOMES eligible and passes after cooldown
        star = self.sbv.accounts.ensure_account(
            201, display_name="Judith Ward", now_ticks=50000, fame_level=5, career="Actor", category=AccountCategory.PUBLIC_FIGURE
        )
        self.sbv.profiles.update_bio(201, "Starlight Accolade winner & film legend.")
        for fid in range(300, 325):
            self.sbv.accounts.ensure_account(fid, display_name="Fan {}".format(fid), now_ticks=50000)
            self.sbv.follow_account(fid, 201)
        for idx in range(4):
            p = self.sbv.create_post(201, "On set today! #Film{}".format(idx), post_type=PostType.ACHIEVEMENT)
            for fid in range(300, 310):
                self.sbv.like_post(fid, p["post_id"], is_toggle=False)

        elig_star = self.sbv.get_verification_eligibility(201)
        self.assertTrue(elig_star["eligible"], msg="Reasons: {}".format(elig_star["reasons"]))
        self.assertTrue(self.sbv.submit_verification_application(201, VerificationTier.BLUE_VERIFIED, "Public figure")["ok"])
        rev_star = self.sbv.process_pending_verification(201, auto_review=True)
        self.assertTrue(rev_star["approved"])
        self.assertEqual(star["verification_tier"], VerificationTier.BLUE_VERIFIED)

    def test_controversy_cascade_and_brand_deal_impact(self):
        acc = self.sbv.accounts.ensure_account(400, display_name="Influencer Sim", fame_level=3, category=AccountCategory.CREATOR)
        acc["verification_tier"] = VerificationTier.BLUE_VERIFIED
        for sid in range(401, 412):
            self.sbv.accounts.ensure_account(sid, display_name="Follower {}".format(sid), is_npc=True)
            self.sbv.follow_account(sid, 400)

        offer = self.sbv.generate_brand_offer_if_eligible(400)
        self.assertIsNotNone(offer)
        self.assertTrue(self.sbv.respond_brand_offer(400, offer["offer_id"], "accept")["ok"])

        rep_before = acc["reputation"]
        post = self.sbv.create_post(400, "Controversial take! #Drama", post_type=PostType.CONTROVERSIAL)
        self.assertLess(acc["reputation"], rep_before)
        self.assertGreater(len(post["comments"]), 0)
        # Brand sponsorship cancelled due to controversy
        offers_after = self.sbv.get_brand_offers(400)
        self.assertEqual(offers_after[0]["status"], "cancelled")

    def test_progressive_moderation_escalation(self):
        target = self.sbv.accounts.ensure_account(500, display_name="Troll Sim")
        target["verification_tier"] = VerificationTier.BLUE_VERIFIED
        p = self.sbv.create_post(500, "Rude post")

        for idx, rep_id in enumerate((501, 502, 503, 504, 505)):
            self.sbv.accounts.ensure_account(rep_id, display_name="Rep {}".format(rep_id))
            self.sbv.report_content(rep_id, 500, reason="harassment" if idx < 2 else "spam", target_type="post", target_id=p["post_id"])

        # After 2 harassment reports post should be removed, and after 5 total reports verification revoked
        self.assertTrue(self.sbv.posts.get_post(p["post_id"])["removed_by_mod"])
        self.assertEqual(target["verification_tier"], VerificationTier.NONE)
        self.assertGreaterEqual(len(self.sbv.moderation.get_account_history(500)), 2)


if __name__ == "__main__":
    unittest.main()
