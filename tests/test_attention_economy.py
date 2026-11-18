# -*- coding: utf-8 -*-

import os
import sys
import unittest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "src", "python"))

from sbv.verified.audience_engine import AudienceEngine
from sbv.verified.comment_warfare import CommentWarfareEngine
from sbv.verified.credibility_engine import CredibilityEngine
from sbv.verified.dm_interceptor import DMInterceptorEngine
from sbv.verified.tiers_and_contracts import TiersAndContractsEngine


class AttentionEconomyTests(unittest.TestCase):
    def test_tier_unlock_and_contract(self):
        engine = TiersAndContractsEngine({})
        record = {"active_strikes": 0}
        self.assertEqual(engine.calculate_tier_unlock(300, 4, 0, 5, 50), "creator_blue")
        self.assertEqual(engine.calculate_tier_unlock(2500, 4, 2, 5, 75), "partner_gold")
        contract = engine.generate_contract({"tier": "partner_gold", "contracts": [], "active_strikes": 0}, 100)
        self.assertIsNotNone(contract)
        self.assertEqual(contract["required_posts"], 3)

    def test_dynamic_rpm_and_spam(self):
        engine = CredibilityEngine({})
        record = {"credibility_score": 65, "brand_safety_score": 80}
        self.assertEqual(engine.calculate_dynamic_rpm(record, 5, 1), 6)
        engine.record_post(record, 100)
        engine.record_post(record, 200)
        engine.record_post(record, 300)
        self.assertEqual(record["credibility_score"], 61)

    def test_dm_diminishing_returns_and_battery(self):
        engine = DMInterceptorEngine({})
        record = {"social_battery": 100.0, "dm_pair_history": {}, "credibility_score": 65}
        first = engine.send_dm(record, "1", "2", True, 100, 0.9)
        second = engine.send_dm(record, "1", "2", True, 200, 0.9)
        third = engine.send_dm(record, "1", "2", True, 300, 0.9)
        self.assertEqual(first["friendship_delta"], 2.0)
        self.assertEqual(second["friendship_delta"], 0.5)
        self.assertEqual(third["friendship_delta"], -5.0)
        self.assertEqual(engine.add_friend_bonus(["Loner"]), 0.0)

    def test_audience_normalization_and_niche_drift(self):
        engine = AudienceEngine({})
        record = {"audience_segments": {"core_loyalists": 50, "casual_browsers": 30, "drama_vultures": 10, "anti_fans": 10}}
        engine.record_post(record, "Friendly")
        engine.record_post(record, "Funny")
        engine.record_post(record, "Mean")
        engine.normalize(record)
        self.assertAlmostEqual(sum(record["audience_segments"].values()), 100.0, places=1)

    def test_ratio_and_cancel_states(self):
        engine = CommentWarfareEngine({})
        record = {"followers": 1000, "credibility_score": 65, "brand_safety_score": 80}
        result = engine.evaluate_ratio(record, 100, 50, True, 100)
        self.assertTrue(result["ratioed"])
        self.assertGreater(record["followers"], 0)
        self.assertLess(record["followers"], 1000)
        self.assertIn(record["cancelation_state"], ("CONTROVERSY_WATCH", "CANCEL_WAVE"))


if __name__ == "__main__":
    unittest.main()
