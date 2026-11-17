# -*- coding: utf-8 -*-
"""Unit and integration tests for the additive Verified subscription system."""

import json
import os
import sys
import tempfile
import unittest

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(PROJECT_ROOT, "src", "python"))

GENERATED_ZIP = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4\Game\Bin\Python\generated.zip"
CORE_ZIP = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4\Data\Simulation\Gameplay\core.zip"
if os.path.isfile(GENERATED_ZIP) and GENERATED_ZIP not in sys.path:
    sys.path.insert(0, GENERATED_ZIP)
if os.path.isfile(CORE_ZIP) and CORE_ZIP not in sys.path:
    sys.path.insert(0, CORE_ZIP)

from sbv.verified.verified_account_service import VerifiedAccountService
from sbv.verified.verified_billing_service import VerifiedBillingService
from sbv.verified.verified_config import clear_config_cache, load_verified_config
from sbv.verified.verified_eligibility_service import VerifiedEligibilityService
from sbv.verified.verified_game_adapter import VerifiedGameAdapter
from sbv.verified.verified_notification_service import VerifiedNotificationService
from sbv.verified.verified_persistence import VerifiedPersistence
from sbv.verified.verified_subscription_manager import VerifiedSubscriptionManager
from sbv.verified.verified_ui_bridge import encode_snapshot_to_packets


class FakeFunds(object):
    def __init__(self, money):
        self.money = int(money)

    def can_afford(self, amount):
        return self.money >= int(amount)

    def try_remove(self, amount, reason, sim, require_full_amount):
        amount = int(amount)
        if self.money < amount:
            return None
        self.money -= amount
        return amount


class FakeSim(object):
    def __init__(self, sim_id, name, is_npc=False):
        self.sim_id = int(sim_id)
        self.first_name = name
        self.last_name = "Tester"
        self.is_npc = bool(is_npc)
        self.household = None


class FakeCandidate(object):
    def __init__(self, sim_info):
        self.sim_info = sim_info


TICKS_PER_DAY = 25 * 60 * 60 * 24


class VerifiedSubscriptionTestBase(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix="sbv_verified_test_")
        clear_config_cache()
        self.now = 1000
        self.funds = FakeFunds(1000)
        self.sims = {101: FakeSim(101, "Alex"), 102: FakeSim(102, "Blair"), 103: FakeSim(103, "Casey", True)}
        self.slot_id = 3

        self.adapter = VerifiedGameAdapter(
            sim_provider=self._sim_provider,
            now_provider=lambda: self.now,
            slot_provider=lambda: self.slot_id,
            funds_provider=lambda sim_id: self.funds,
        )
        self.config = load_verified_config(self.tmp)
        self.persistence = VerifiedPersistence(self.tmp)
        self.accounts = VerifiedAccountService(self.adapter, self.persistence)
        self.notifications = VerifiedNotificationService(self.adapter, self.persistence)
        self.billing = VerifiedBillingService(self.adapter, self.notifications, self.config["plan"])
        self.manager = VerifiedSubscriptionManager(
            config=self.config,
            persistence=self.persistence,
            adapter=self.adapter,
            accounts=self.accounts,
            notifications=self.notifications,
            billing=self.billing,
            eligibility=VerifiedEligibilityService(self.adapter),
        )
        self.manager.ensure_loaded(force_slot_id=self.slot_id)

    def _sim_provider(self, sim_id):
        return self.sims.get(int(sim_id))

    def subscribe(self, sim_id=101):
        return self.manager.handle_action(sim_id, "subscribe")

    def advance_days(self, days):
        self.now += int(days) * TICKS_PER_DAY


class TestVerifiedSubscription(VerifiedSubscriptionTestBase):
    def test_subscribe_charges_exactly_once_and_prevents_duplicates(self):
        snapshot = self.manager.build_snapshot(101)
        self.assertEqual(snapshot["subscription"]["status"], "eligible")
        self.assertEqual(snapshot["plan"]["price"], 250)
        self.assertTrue(snapshot["permissions"]["can_subscribe"])
        self.assertEqual(self.funds.money, 1000)

        result = self.subscribe()
        self.assertTrue(result["ok"], msg=result)
        self.assertEqual(self.funds.money, 750)

        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "active")
        self.assertEqual(record["payment_amount"], 250)
        self.assertEqual(len(record["payment_history"]), 1)
        self.assertEqual(record["payment_history"][0]["status"], "succeeded")

        duplicate = self.subscribe()
        self.assertFalse(duplicate["ok"])
        self.assertEqual(duplicate["code"], "already_subscribed")
        self.assertEqual(self.funds.money, 750)

        snapshot = self.manager.build_snapshot(101)
        self.assertEqual(snapshot["subscription"]["status"], "active")
        self.assertTrue(snapshot["subscription"]["benefits_active"])
        self.assertTrue(snapshot["permissions"]["can_cancel"])
        self.assertTrue(snapshot["permissions"]["can_toggle_auto_renew"])

    def test_insufficient_funds_never_deducts_and_never_activates(self):
        self.funds.money = 10
        snapshot = self.manager.build_snapshot(101)
        self.assertEqual(snapshot["subscription"]["status"], "not_subscribed")
        self.assertFalse(snapshot["eligibility"]["eligible"])
        self.assertEqual(snapshot["eligibility"]["code"], "insufficient_funds")
        self.assertFalse(snapshot["permissions"]["can_subscribe"])

        result = self.subscribe()
        self.assertFalse(result["ok"])
        self.assertEqual(result["code"], "insufficient_funds")
        self.assertEqual(self.funds.money, 10)
        self.assertIsNone(self.manager.get_record(101))

    def test_renewal_success_failure_grace_and_suspension(self):
        self.assertTrue(self.subscribe()["ok"])
        self.funds.money = 1000

        self.advance_days(7)
        self.assertTrue(self.manager.handle_action(101, "refresh")["ok"])
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "active")
        self.assertEqual(self.funds.money, 750)
        self.assertEqual(record["payment_history"][0]["status"], "succeeded")

        self.advance_days(7)
        self.funds.money = 0
        self.manager.handle_action(101, "refresh")
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "payment_failed")
        self.assertTrue(self.billing.benefits_active(record, self.now))
        self.assertGreater(record["grace_period_end"], self.now)

        snapshot = self.manager.build_snapshot(101)
        self.assertEqual(snapshot["subscription"]["status"], "payment_failed")
        self.assertFalse(snapshot["permissions"]["can_retry_payment"])

        self.funds.money = 1000
        snapshot = self.manager.build_snapshot(101)
        self.assertTrue(snapshot["permissions"]["can_retry_payment"])
        result = self.manager.handle_action(101, "retry_payment")
        self.assertTrue(result["ok"], msg=result)
        self.assertEqual(self.manager.get_record(101)["status"], "active")
        self.assertEqual(self.funds.money, 750)

        self.advance_days(7)
        self.funds.money = 0
        self.manager.handle_action(101, "refresh")
        self.advance_days(3)
        self.manager.handle_action(101, "refresh")
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "suspended")
        self.assertFalse(self.billing.benefits_active(record, self.now))
        self.assertTrue(any(item["status"] == "failed" for item in record["payment_history"]))

    def test_cancellation_retains_benefits_then_expires_without_deleting_data(self):
        self.assertTrue(self.subscribe()["ok"])
        self.advance_days(1)
        result = self.manager.handle_action(101, "cancel")
        self.assertTrue(result["ok"])
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "cancelled")
        self.assertTrue(self.billing.benefits_active(record, self.now))
        self.assertEqual(self.funds.money, 750)

        self.advance_days(7)
        self.manager.handle_action(101, "refresh")
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "expired")
        self.assertFalse(self.billing.benefits_active(record, self.now))
        self.assertEqual(len(record["payment_history"]), 1)
        self.assertEqual(record["subscription_id"], self.manager.get_record(101)["subscription_id"])

        self.funds.money = 1000
        result = self.subscribe()
        self.assertTrue(result["ok"], msg=result)
        self.assertEqual(self.manager.get_record(101)["status"], "active")
        self.assertEqual(self.funds.money, 750)

    def test_auto_renew_toggle_reactivation_and_cancellation(self):
        self.assertTrue(self.subscribe()["ok"])
        self.assertTrue(self.manager.handle_action(101, "set_auto_renew", "0")["ok"])
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "active")
        self.assertFalse(record["auto_renew"])
        self.assertTrue(self.billing.benefits_active(record, self.now))

        self.assertTrue(self.manager.handle_action(101, "set_auto_renew", "1")["ok"])
        self.assertTrue(self.manager.get_record(101)["auto_renew"])

        self.advance_days(1)
        self.assertTrue(self.manager.handle_action(101, "cancel")["ok"])
        self.assertEqual(self.manager.get_record(101)["status"], "cancelled")
        funds_before = self.funds.money
        self.assertTrue(self.manager.handle_action(101, "reactivate")["ok"])
        self.assertEqual(self.manager.get_record(101)["status"], "active")
        self.assertEqual(self.funds.money, funds_before)

    def test_persistence_slot_isolation_reload_and_migration(self):
        self.assertTrue(self.subscribe()["ok"])
        self.manager.save()
        self.assertTrue(os.path.isfile(self.persistence.get_slot_file_path(3)))

        other_persistence = VerifiedPersistence(self.tmp)
        other_accounts = VerifiedAccountService(self.adapter, other_persistence)
        other_notifications = VerifiedNotificationService(self.adapter, other_persistence)
        other_billing = VerifiedBillingService(self.adapter, other_notifications, self.config["plan"])
        other = VerifiedSubscriptionManager(
            self.config,
            other_persistence,
            self.adapter,
            other_accounts,
            other_notifications,
            other_billing,
            VerifiedEligibilityService(self.adapter),
        )
        other.ensure_loaded(force_slot_id=4)
        self.assertIsNone(other.get_record(101))

        reloaded = VerifiedSubscriptionManager(
            self.config,
            VerifiedPersistence(self.tmp),
            self.adapter,
            VerifiedAccountService(self.adapter, VerifiedPersistence(self.tmp)),
            VerifiedNotificationService(self.adapter, VerifiedPersistence(self.tmp)),
            VerifiedBillingService(self.adapter, self.notifications, self.config["plan"]),
            VerifiedEligibilityService(self.adapter),
        )
        reloaded.ensure_loaded(force_slot_id=3)
        record = reloaded.get_record(101)
        self.assertIsNotNone(record)
        self.assertEqual(record["status"], "active")

        legacy = {
            "schema_version": 1,
            "subscriptions": [
                {
                    "sim_id": "101",
                    "status": "active",
                    "plan_id": "social_bunny_verified",
                    "payment_history": [],
                }
            ],
        }
        migrated = VerifiedPersistence(self.tmp).migrate_payload(legacy)
        self.assertEqual(migrated["schema_version"], 2)
        self.assertIsInstance(migrated["subscriptions"], dict)
        self.assertEqual(migrated["subscriptions"]["101"]["sim_id"], "101")

    def test_feed_priority_and_contact_priority_are_real(self):
        self.assertTrue(self.subscribe()["ok"])

        class NativePost(object):
            def __init__(self, author):
                self.author_sim_id = author

        posts = [NativePost(102), NativePost(101), NativePost(102)]
        prioritized = self.manager.prioritize_feed(posts, 102)
        # The native panel reverses its input, so verified posts are moved to
        # the end of the Python list to appear first in the visible feed.
        self.assertEqual(prioritized[-1].author_sim_id, 101)
        self.assertEqual([post.author_sim_id for post in prioritized[:-1]], [102, 102])

        candidates = [FakeCandidate(self.sims[102]), FakeCandidate(self.sims[101])]
        prioritized_candidates = self.manager.prioritize_contacts(candidates)
        self.assertEqual(prioritized_candidates[0].sim_info.sim_id, 101)

    def test_all_status_labels_are_supported(self):
        expected = {
            "not_subscribed": "Not Subscribed",
            "eligible": "Eligible",
            "active": "Active",
            "payment_pending": "Payment Pending",
            "payment_failed": "Payment Failed",
            "grace_period": "Grace Period",
            "cancelled": "Cancelled",
            "expired": "Expired",
            "suspended": "Suspended",
        }
        for status, label in expected.items():
            self.assertEqual(self.billing.status_label(status), label)

    def test_payment_pending_state_is_representable(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record["status"] = "payment_pending"
        snapshot = self.manager.build_snapshot(101)
        self.assertEqual(snapshot["subscription"]["status_label"], "Payment Pending")

    def test_state_packet_roundtrip(self):
        self.assertTrue(self.subscribe()["ok"])
        snapshot = self.manager.build_snapshot(101)
        packets = encode_snapshot_to_packets(101, snapshot, self.now)
        self.assertGreaterEqual(len(packets), 1)
        self.assertTrue(all(packet.post_type == 0 for packet in packets))
        self.assertEqual(packets[0].post_id, 9000000)
        joined = "".join(packet.post_text.tokens[0].raw_text for packet in packets)
        parsed = json.loads(joined)
        self.assertEqual(parsed["account"]["sim_id"], "101")
        self.assertEqual(parsed["subscription"]["status"], "active")
        self.assertEqual(parsed["plan"]["price_label"], "\u00a7250")

    def test_price_is_configurable(self):
        config_file = os.path.join(self.tmp, "verified_config.json")
        with open(config_file, "w", encoding="utf-8") as handle:
            json.dump({"plan": {"price": 999, "billing_interval_days": 3}}, handle)
        clear_config_cache()
        configured = load_verified_config(self.tmp)
        self.assertEqual(configured["plan"]["price"], 999)
        self.assertEqual(configured["plan"]["billing_interval_days"], 3)
        clear_config_cache()


if __name__ == "__main__":
    unittest.main()
