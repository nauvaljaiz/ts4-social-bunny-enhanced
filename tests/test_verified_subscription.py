# -*- coding: utf-8 -*-
"""Unit and integration tests for the additive Verified subscription system."""

import json
import os
import sys
import tempfile
import types
import unittest
from unittest import mock

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

    def add(self, amount, reason, sim, count_as_earnings=False):
        self.money += int(amount)


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
        self.followers = {}
        self.fame = {}
        self.friendships = {}
        self.reactions_triggered = []

        self.adapter = VerifiedGameAdapter(
            sim_provider=self._sim_provider,
            now_provider=lambda: self.now,
            slot_provider=lambda: self.slot_id,
            funds_provider=lambda sim_id: self.funds,
            followers_provider=self._followers_provider,
            fame_provider=self._fame_provider,
            reaction_provider=self._reaction_provider,
            friendship_provider=self._friendship_provider,
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
        self.assertEqual(result["snapshot"]["subscription"]["status"], "active")
        self.assertTrue(result["snapshot"]["subscription"]["benefits_active"])

        self.advance_days(7)
        self.funds.money = 0
        self.manager.handle_action(101, "refresh")
        self.advance_days(3)
        self.manager.handle_action(101, "refresh")
        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "suspended")
        self.assertFalse(self.billing.benefits_active(record, self.now))
        self.assertTrue(any(item["status"] == "failed" for item in record["payment_history"]))

    def test_automatic_retries_stop_when_grace_period_ends(self):
        self.assertTrue(self.subscribe()["ok"])
        self.funds.money = 0
        self.advance_days(7)
        self.manager.handle_action(101, "refresh")

        for _ in range(3):
            self.now += self.billing.retry_ticks
            self.manager.handle_action(101, "refresh")

        record = self.manager.get_record(101)
        self.assertEqual(record["status"], "grace_period")
        self.assertEqual(
            sum(1 for payment in record["payment_history"] if payment["status"] == "failed"),
            4,
        )

        self.now += self.billing.retry_ticks
        self.manager.handle_action(101, "refresh")
        self.assertEqual(record["status"], "suspended")
        self.assertEqual(
            sum(1 for payment in record["payment_history"] if payment["status"] == "failed"),
            4,
        )

    def test_retry_payment_does_not_override_credibility_suspension(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record.update(
            {
                "status": "suspended",
                "suspension_reason": "payment",
                "credibility_score": 3,
                "brand_safety_score": 12,
                "active_strikes": 19,
                "reapplication_cooldown_until": self.now + self.adapter.ticks_from_hours(72),
            }
        )

        result = self.manager.handle_action(101, "retry_payment")
        self.assertTrue(result["ok"], msg=result)
        self.assertEqual(result["code"], "payment_succeeded_reputation_suspended")
        self.assertEqual(record["status"], "suspended")
        self.assertEqual(record["suspension_reason"], "credibility")
        self.assertEqual(self.funds.money, 500)

        record["suspension_reason"] = ""
        record["next_billing_at"] = self.now - 1
        snapshot = self.manager.build_snapshot(101)
        self.assertFalse(snapshot["permissions"]["can_retry_payment"])
        self.assertEqual(snapshot["subscription"]["suspension_reason"], "credibility")
        self.assertIn("3/100", snapshot["subscription"]["status_detail"])
        self.assertEqual(self.funds.money, 500)

        duplicate = self.manager.handle_action(101, "retry_payment")
        self.assertFalse(duplicate["ok"])
        self.assertEqual(duplicate["code"], "reputation_suspension")
        self.assertEqual(self.funds.money, 500)

    def test_manual_retry_is_single_attempt_and_has_cooldown(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record.update(
            {
                "status": "payment_failed",
                "grace_period_end": self.now + self.adapter.ticks_from_days(2),
                "next_billing_at": self.now,
            }
        )
        failed_payment = {
            "ok": False,
            "code": "payment_failed",
            "message": "The household could not complete the Simoleon payment.",
        }

        with mock.patch.object(self.billing, "charge", return_value=failed_payment) as charge:
            result = self.manager.handle_action(101, "retry_payment")
            self.assertFalse(result["ok"])
            self.assertEqual(charge.call_count, 1)

            repeated = self.manager.handle_action(101, "retry_payment")
            self.assertFalse(repeated["ok"])
            self.assertEqual(repeated["code"], "retry_cooldown")
            self.assertEqual(charge.call_count, 1)

        snapshot = self.manager.build_snapshot(101)
        self.assertFalse(snapshot["permissions"]["can_retry_payment"])
        self.assertIn("prevent duplicate charges", snapshot["subscription"]["status_detail"])
        self.assertEqual(record["last_manual_retry_at"], self.now)

    def test_stale_payment_pending_record_is_not_charged_again(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record["status"] = "payment_pending"
        record["next_billing_at"] = self.now - 1

        with mock.patch.object(self.billing, "charge") as charge:
            self.assertFalse(self.billing.process_due(record, self.now))
            charge.assert_not_called()
        self.assertEqual(record["status"], "payment_pending")

        snapshot = self.manager.build_snapshot(101)
        self.assertFalse(snapshot["permissions"]["can_retry_payment"])
        self.assertFalse(snapshot["subscription"]["benefits_active"])
        self.assertIn("avoid a duplicate payment", snapshot["subscription"]["status_detail"])

    def test_credibility_suspension_recovers_after_cooldown_and_clean_posts(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record.update(
            {
                "status": "suspended",
                "suspension_reason": "credibility",
                "credibility_score": 23,
                "reapplication_cooldown_until": self.now,
                "post_times_6h": [],
            }
        )

        post = self.manager.on_verified_post_attempt(101)
        self.assertTrue(post["allowed"])
        self.assertTrue(post["verified"])
        self.assertEqual(record["status"], "active")
        self.assertGreaterEqual(record["credibility_score"], 25)

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

    def test_reload_and_slot_switch_preserve_unsaved_verified_state(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record["last_failure_reason"] = "preserve across zone load"
        self.manager._touch()

        self.manager.reload()
        self.assertEqual(self.manager.get_record(101)["last_failure_reason"], "preserve across zone load")

        record = self.manager.get_record(101)
        record["last_failure_reason"] = "preserve across save-slot switch"
        self.manager._touch()
        self.slot_id = 4
        self.manager.ensure_loaded()
        self.assertIsNone(self.manager.get_record(101))

        slot_three = VerifiedPersistence(self.tmp)
        saved = slot_three.load_slot(3)
        self.assertEqual(
            saved["subscriptions"]["101"]["last_failure_reason"],
            "preserve across save-slot switch",
        )

    def test_native_follower_recount_only_changes_verified_sims(self):
        from sbv.verified.verified_game_hooks import _install_verified_perk_hooks

        class FakePostType(object):
            DEFAULT = 0
            PUBLIC_POST = 4

        class FakeSocialMediaService(object):
            def calculate_social_media_followers(self, author_sim_id):
                return "native-result"

            def get_current_followers_count(self, sim_id):
                return self.manager.adapter.get_followers(sim_id)

            def __init__(self, manager):
                self.manager = manager

        social_media_module = types.ModuleType("social_media")
        social_media_module.SocialMediaPostType = FakePostType
        service_module = types.ModuleType("social_media.social_media_service")
        service_module.SocialMediaService = FakeSocialMediaService
        with mock.patch.dict(
            sys.modules,
            {
                "social_media": social_media_module,
                "social_media.social_media_service": service_module,
            },
        ):
            _install_verified_perk_hooks(self.manager)
            native_service = FakeSocialMediaService(self.manager)
            self.assertEqual(native_service.calculate_social_media_followers(102), "native-result")

        self.assertEqual(self.followers.get("102", 0), 0)

    def test_feed_priority_and_contact_priority_are_real(self):
        self.assertTrue(self.subscribe()["ok"])

        class NativePost(object):
            def __init__(self, author):
                self.author_sim_id = author

        posts = [NativePost(102), NativePost(101), NativePost(102)]
        prioritized = self.manager.prioritize_feed(posts, 102)
        # The native panel reverses its input. Viewer-owned/tagged posts and
        # verified posts are moved to the end so they appear at the top.
        self.assertEqual(prioritized[-1].author_sim_id, 102)
        self.assertEqual(prioritized[0].author_sim_id, 101)

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

    def test_hourly_systems_are_idempotent_between_ticks(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        record["social_battery"] = 50.0
        self.manager.process_due_all()
        self.manager.process_due_all()
        self.assertEqual(record["social_battery"], 50.0)

        self.now += self.adapter.ticks_from_hours(1)
        self.manager.process_due_all()
        self.assertEqual(record["social_battery"], 55.0)
        self.manager.process_due_all()
        self.assertEqual(record["social_battery"], 55.0)

    def test_creator_payout_has_daily_cap(self):
        self.assertTrue(self.subscribe()["ok"])
        record = self.manager.get_record(101)
        self.assertEqual(self.manager._accrue_creator_payout(record, 400, self.now), 250)
        self.assertEqual(self.manager._accrue_creator_payout(record, 100, self.now), 0)
        self.assertEqual(record["pending_payout"], 250)

    def test_verified_post_spam_is_blocked_without_resetting_inactivity_clock(self):
        self.assertTrue(self.subscribe()["ok"])
        first = self.manager.on_verified_post_attempt(101)
        second = self.manager.on_verified_post_attempt(101)
        last_real_post = self.manager.get_record(101)["last_post_at"]
        blocked = self.manager.on_verified_post_attempt(101)
        self.assertTrue(first["allowed"])
        self.assertTrue(second["allowed"])
        self.assertFalse(blocked["allowed"])
        self.assertEqual(self.manager.get_record(101)["last_post_at"], last_real_post)

    def test_state_packet_roundtrip(self):
        self.assertTrue(self.subscribe()["ok"])
        snapshot = self.manager.build_snapshot(101)
        packets = encode_snapshot_to_packets(101, snapshot, self.now)
        self.assertGreaterEqual(len(packets), 1)
        self.assertTrue(all(packet.post_type == 0 for packet in packets))
        self.assertLessEqual(packets[-1].post_id, 2147483647)
        joined = "".join(packet.post_text.tokens[0].raw_text for packet in packets)
        parsed = json.loads(joined)
        self.assertEqual(parsed["account"]["sim_id"], "101")
        self.assertEqual(parsed["subscription"]["status"], "active")
        self.assertEqual(parsed["plan"]["price_label"], "\u00a7250")
        self.assertEqual(parsed["pr_studio"]["tier_label"], "Blue")

    def test_price_is_configurable(self):
        config_file = os.path.join(self.tmp, "verified_config.json")
        with open(config_file, "w", encoding="utf-8") as handle:
            json.dump({"plan": {"price": 999, "billing_interval_days": 3}}, handle)
        clear_config_cache()
        configured = load_verified_config(self.tmp)
        self.assertEqual(configured["plan"]["price"], 999)
        self.assertEqual(configured["plan"]["billing_interval_days"], 3)
        clear_config_cache()

    def test_bool_try_remove_and_try_remove_amount_match_ts4(self):
        class BoolOnlyFunds(object):
            def __init__(self, money):
                self.money = int(money)

            def can_afford(self, amount):
                return self.money >= int(amount)

            def try_remove(self, amount, reason, sim, require_full_amount):
                amount = int(amount)
                if self.money < amount:
                    return False
                self.money -= amount
                return True

        class FullTS4Funds(BoolOnlyFunds):
            def try_remove_amount(self, amount, reason, sim, require_full_amount):
                amount = int(amount)
                if self.money < amount:
                    return None
                self.money -= amount
                return amount

        for cls in (BoolOnlyFunds, FullTS4Funds):
            funds_obj = cls(500)
            self.adapter._funds_provider = lambda _sid, obj=funds_obj: obj
            res = self.billing.charge(101, 250)
            self.assertTrue(res["ok"], res)
            self.assertEqual(funds_obj.money, 250)
            # Insufficient after debit
            funds_obj.money = 100
            fail_res = self.billing.charge(101, 250)
            self.assertFalse(fail_res["ok"])
            self.assertEqual(funds_obj.money, 100)

    def _followers_provider(self, op, sim_id, delta):
        sid = str(sim_id)
        if op == "get":
            return self.followers.get(sid, 0)
        self.followers[sid] = max(0, int(self.followers.get(sid, 0)) + int(delta))
        return self.followers[sid]

    def _fame_provider(self, sim_id, amount):
        sid = str(sim_id)
        self.fame[sid] = self.fame.get(sid, 0.0) + float(amount)
        return True

    def _reaction_provider(self, sim_id, max_reactions):
        self.reactions_triggered.append((str(sim_id), int(max_reactions)))
        return int(max_reactions)

    def _friendship_provider(self, sim_a, sim_b, amount):
        key = (str(sim_a), str(sim_b))
        self.friendships[key] = self.friendships.get(key, 0.0) + float(amount)
        return True

    def test_verified_gameplay_perks_followers_payout_boost_and_fame(self):
        # Unverified Sim gets no perks
        self.assertIsNone(self.manager.on_verified_post_created(101))
        self.assertFalse(self.manager.boost_post(101)["ok"])

        # Subscribe triggers welcome spotlight (+75 followers + Fame)
        self.assertTrue(self.subscribe(101)["ok"])
        self.assertEqual(self.followers["101"], 75)
        self.assertGreater(self.fame["101"], 0)

        # Post created & NPC reactions grant followers, Fame, and ad revenue
        post_perk = self.manager.on_verified_post_created(101)
        self.assertIsNotNone(post_perk)
        self.assertEqual(post_perk["followers_added"], 0)
        self.assertEqual(post_perk["payout_earned"], 0)
        self.assertEqual(self.manager.get_record(101)["pending_payout"], 0)
        react_perk = self.manager.on_verified_post_reaction(101, {"polarity": "positive"})
        self.assertEqual(react_perk["followers_added"], 3)
        self.assertEqual(react_perk["payout_earned"], 2)

        # Boost Reach starts a non-instant 4-hour Spotlight Campaign, then enforces 24h cooldown
        before_boost_followers = self.followers["101"]
        boost1 = self.manager.handle_action(101, "boost_post")
        self.assertTrue(boost1["ok"])
        self.assertTrue(boost1["boost_active"])
        self.assertEqual(boost1["followers_added"], 0)
        self.assertEqual(self.followers["101"], before_boost_followers)

        snap_start = self.manager.build_snapshot(101)
        self.assertTrue(snap_start["perks"]["boost_active"])
        self.assertEqual(snap_start["perks"]["boost_progress"], 0)
        self.assertFalse(snap_start["permissions"]["can_boost_post"])

        boost_dup = self.manager.handle_action(101, "boost_post")
        self.assertFalse(boost_dup["ok"])
        self.assertEqual(boost_dup["code"], "boost_in_progress")

        # Advance 1h -> 25%, 2h -> 50%, 4h -> 100% completed + 24h cooldown starts
        self.now += self.adapter.ticks_from_hours(1)
        snap_1h = self.manager.build_snapshot(101)
        self.assertTrue(snap_1h["perks"]["boost_active"])
        self.assertEqual(snap_1h["perks"]["boost_progress"], 25)
        self.assertGreater(snap_1h["perks"]["boost_followers_gained"], 0)

        self.now += self.adapter.ticks_from_hours(1)
        snap_2h = self.manager.build_snapshot(101)
        self.assertTrue(snap_2h["perks"]["boost_active"])
        self.assertEqual(snap_2h["perks"]["boost_progress"], 50)
        self.assertGreater(snap_2h["perks"]["boost_followers_gained"], snap_1h["perks"]["boost_followers_gained"])

        self.now += self.adapter.ticks_from_hours(2)
        snap_done = self.manager.build_snapshot(101)
        self.assertFalse(snap_done["perks"]["boost_active"])
        self.assertEqual(snap_done["perks"]["boost_count"], 1)
        self.assertFalse(snap_done["perks"]["boost_ready"])
        self.assertGreater(self.followers["101"], before_boost_followers)

        boost_cd = self.manager.handle_action(101, "boost_post")
        self.assertFalse(boost_cd["ok"])
        self.assertEqual(boost_cd["code"], "boost_cooldown")

        # Advance 20h (only 20h of 24h cooldown elapsed) -> still cooling down
        self.now += self.adapter.ticks_from_hours(20)
        self.assertEqual(self.manager.handle_action(101, "boost_post")["code"], "boost_cooldown")

        # Advance another 5h (25h total cooldown) -> campaign can start again
        self.now += self.adapter.ticks_from_hours(5)
        self.assertTrue(self.manager.handle_action(101, "boost_post")["ok"])

        # Snapshot exposes perks and claim_payout deposits Simoleons to household funds
        snap = self.manager.build_snapshot(101)
        pending = snap["perks"]["pending_payout"]
        self.assertGreater(pending, 0)
        self.assertTrue(snap["permissions"]["can_claim_payout"])
        money_before = self.funds.money
        claim = self.manager.handle_action(101, "claim_payout")
        self.assertTrue(claim["ok"])
        self.assertEqual(self.funds.money, money_before + pending)
        self.assertEqual(self.manager.build_snapshot(101)["perks"]["pending_payout"], 0)

        # Algorithm follower recount boosts positive gain by 2.5x and prevents loss
        self.assertGreater(self.manager.on_verified_follower_recount(101, 20), 0)
        self.assertEqual(self.manager.on_verified_follower_recount(101, -5), 0)
        self.now += self.adapter.ticks_per_day()
        self.assertGreaterEqual(self.manager.on_verified_follower_recount(101, -5), 25)

        # Adding a contact grants friendship clout bonus
        self.assertTrue(self.manager.on_verified_friend_added(101, 102))
        self.assertEqual(self.friendships[("101", "102")], 1.5)


if __name__ == "__main__":
    unittest.main()
