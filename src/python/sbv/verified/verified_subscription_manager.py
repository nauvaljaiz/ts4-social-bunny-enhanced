# -*- coding: utf-8 -*-
"""Persistent Social Bunny Verified subscription orchestration."""

from .verified_billing_service import VerifiedBillingService
from .verified_eligibility_service import VerifiedEligibilityService


class VerifiedSubscriptionManager(object):
    def __init__(
        self,
        config,
        persistence,
        adapter,
        accounts,
        notifications,
        billing=None,
        eligibility=None,
    ):
        self.config = config
        self.plan = config["plan"]
        self.persistence = persistence
        self.adapter = adapter
        self.accounts = accounts
        self.notifications = notifications
        self.billing = billing or VerifiedBillingService(adapter, notifications, self.plan)
        self.eligibility = eligibility or VerifiedEligibilityService(adapter)
        self._payload = None
        self._loaded_slot_id = None
        self._alarm_handle = None

    # --- Lifecycle ---------------------------------------------------

    def ensure_loaded(self, force_slot_id=None, force=False):
        slot_id = int(force_slot_id) if force_slot_id is not None else int(self.adapter.get_slot_id())
        if self._payload is not None and self._loaded_slot_id == slot_id and not force:
            return
        self._payload = self.persistence.load_slot(slot_id)
        self._loaded_slot_id = slot_id
        self.accounts.bind(self._payload)
        self.notifications.bind(self._payload)

    def reload(self):
        self._payload = None
        self._loaded_slot_id = None
        self.ensure_loaded(force=True)

    def save(self):
        if self._payload is None:
            return False
        return self.persistence.save_slot(self._payload, self._loaded_slot_id if self._loaded_slot_id is not None else 0)

    def reset_in_memory(self):
        self._payload = None
        self._loaded_slot_id = None
        self.accounts.bind(None)
        self.notifications.bind(None)

    @property
    def payload(self):
        return self._payload

    @property
    def loaded_slot_id(self):
        return self._loaded_slot_id

    def _touch(self):
        self.persistence.mark_dirty()

    def _meta(self):
        if self._payload is None:
            return {"next_sequence": 1}
        return self._payload.setdefault("meta", {"next_sequence": 1})

    def _next_sequence(self):
        meta = self._meta()
        try:
            value = int(meta.get("next_sequence", 1))
        except Exception:
            value = 1
        meta["next_sequence"] = value + 1
        return value

    def _subscriptions(self):
        if self._payload is None:
            return {}
        return self._payload.setdefault("subscriptions", {})

    def get_record(self, sim_id):
        return self._subscriptions().get(str(sim_id))

    def _ensure_record(self, sim_id, now_ticks):
        sid = str(sim_id)
        record = self.get_record(sid)
        if record is not None:
            return record
        account = self.accounts.ensure_account(sid, now_ticks)
        record = {
            "subscription_id": "sbsub_{:08d}".format(self._next_sequence()),
            "sim_id": sid,
            "account_id": account["account_id"],
            "plan_id": self.plan.get("plan_id", "social_bunny_verified"),
            "plan_name": self.plan.get("name", "Social Bunny Verified"),
            "status": "not_subscribed",
            "start_date": 0,
            "current_period_start": 0,
            "current_period_end": 0,
            "next_billing_at": 0,
            "last_successful_payment": 0,
            "payment_amount": 0,
            "auto_renew": False,
            "cancellation_timestamp": 0,
            "expiration_timestamp": 0,
            "grace_period_end": 0,
            "last_failure_at": 0,
            "last_failure_reason": "",
            "retry_count": 0,
            "reminder_sent_for": 0,
            "payment_history": [],
        }
        self._subscriptions()[sid] = record
        self._touch()
        return record

    # --- Queries -----------------------------------------------------

    def is_verified(self, sim_id, now_ticks=None):
        record = self.get_record(sim_id)
        if record is None:
            return False
        now = int(now_ticks if now_ticks is not None else self.adapter.get_now_ticks())
        return self.billing.benefits_active(record, now)

    def get_verified_sim_ids(self):
        now = int(self.adapter.get_now_ticks())
        out = []
        for sid, record in self._subscriptions().items():
            if isinstance(record, dict) and self.billing.benefits_active(record, now):
                out.append(str(sid))
        return out

    def prioritize_feed(self, items, viewer_sim_id=None):
        if not items:
            return items
        verified = set(self.get_verified_sim_ids())
        if not verified:
            return items
        limit = max(0, int(self.config.get("benefits", {}).get("feed_priority_limit", 25)))
        if limit <= 0:
            return items
        verified_indices = [
            index
            for index, item in enumerate(items)
            if str(getattr(item, "author_sim_id", "")) in verified
        ]
        selected = set(verified_indices[-limit:])
        priority = [item for index, item in enumerate(items) if index in selected]
        rest = [item for index, item in enumerate(items) if index not in selected]
        # SocialMediaFeedTabPanel reverses its input before populating the list.
        # Returning [unverified..., verified...] therefore places verified posts
        # at the top of the visible feed while preserving chronology in each group.
        return rest + priority

    def prioritize_contacts(self, candidates):
        if not candidates:
            return candidates
        if not bool(self.config.get("benefits", {}).get("contact_priority_enabled", True)):
            return candidates
        verified = set(self.get_verified_sim_ids())
        if not verified:
            return candidates
        priority = []
        rest = []
        for candidate in candidates:
            sim_info = getattr(candidate, "sim_info", None)
            sim_id = str(getattr(sim_info, "sim_id", ""))
            if sim_id in verified:
                priority.append(candidate)
            else:
                rest.append(candidate)
        return priority + rest

    # --- Snapshot ----------------------------------------------------

    def build_snapshot(self, sim_id):
        self.ensure_loaded()
        now = int(self.adapter.get_now_ticks())
        sid = str(sim_id)
        account = self.accounts.ensure_account(sid, now)
        record = self.get_record(sid)

        if record is not None:
            changed = self.billing.process_due(record, now)
            if changed:
                self._touch()
                self.save()
        record = self.get_record(sid)

        eligibility = self.eligibility.evaluate(sid, record, now, self.plan)
        can_afford = self.billing.can_afford(sid)

        if record is None:
            status = "eligible" if eligibility.get("eligible") else "not_subscribed"
            benefits_active = False
        else:
            status = str(record.get("status", "not_subscribed"))
            benefits_active = self.billing.benefits_active(record, now)

        subscription = self._serialize_subscription(sid, record, status, now, eligibility, can_afford)
        permissions = self._build_permissions(status, record, eligibility, can_afford, now)

        benefits = []
        for item in self.plan.get("benefits", []):
            benefits.append(
                {
                    "title": item.get("title", "Verified benefit"),
                    "description": item.get("description", ""),
                    "active": bool(benefits_active),
                }
            )

        notification_items = []
        for item in self.notifications.get_for_sim(sid, 4):
            notification_items.append(
                {
                    "message": item.get("message", ""),
                    "date_label": item.get("date_label", ""),
                    "kind": item.get("kind", ""),
                }
            )

        last_payment = 0
        if record is not None:
            last_payment = int(record.get("last_successful_payment", 0) or 0)

        last_result = self.notifications.get_last_result(sid)
        if last_result is not None:
            try:
                age = now - int(last_result.get("tick", 0))
            except Exception:
                age = 0
            if age > self.adapter.ticks_from_hours(1):
                last_result = None

        return {
            "version": 2,
            "kind": "social_bunny_verified",
            "now": now,
            "account": {
                "sim_id": sid,
                "account_id": account["account_id"],
                "username": account["username"],
                "display_name": account["display_name"],
            },
            "plan": {
                "plan_id": self.plan.get("plan_id", "social_bunny_verified"),
                "name": self.plan.get("name", "Social Bunny Verified"),
                "tagline": self.plan.get("tagline", ""),
                "price": int(self.plan.get("price", 250)),
                "price_label": self.billing.format_money(self.plan.get("price", 250)),
                "billing_interval_days": int(self.plan.get("billing_interval_days", 7)),
                "billing_interval_label": self.billing.format_interval_label(),
                "benefits": benefits,
            },
            "eligibility": eligibility,
            "subscription": subscription,
            "permissions": permissions,
            "benefits": benefits,
            "notifications": notification_items,
            "last_result": last_result,
            "last_successful_payment_label": (
                self.adapter.format_sim_time(last_payment) if last_payment else ""
            ),
        }

    def _serialize_subscription(self, sid, record, status, now, eligibility, can_afford):
        label = self.billing.status_label(status)
        detail = self._status_detail(status, record, now, eligibility, can_afford)
        if record is None:
            next_billing = ""
            auto_renew = False
            history = []
            start_label = ""
            period_end_label = ""
            grace_end_label = ""
            payment_amount_label = ""
            subscription_id = ""
        else:
            history = list(record.get("payment_history", []))[:8]
            auto_renew = bool(record.get("auto_renew", False))
            subscription_id = record.get("subscription_id", "")
            start = int(record.get("start_date", 0) or 0)
            start_label = self.adapter.format_sim_time(start) if start else ""
            period_end = int(record.get("current_period_end", 0) or 0)
            period_end_label = self.billing.relative_label(period_end, now)
            grace_end = int(record.get("grace_period_end", 0) or 0)
            grace_end_label = self.billing.relative_label(grace_end, now)
            payment_amount = int(record.get("payment_amount", 0) or 0)
            payment_amount_label = self.billing.format_money(payment_amount) if payment_amount else ""

            if status == "cancelled":
                next_billing = period_end_label
            elif status in ("payment_failed", "grace_period"):
                next_billing = grace_end_label
            elif status in ("expired", "suspended", "not_subscribed"):
                next_billing = ""
            else:
                next_billing = self.billing.relative_label(
                    int(record.get("next_billing_at", 0) or 0), now
                )

        if status == "active":
            auto_label = "Auto-renew: On" if auto_renew else "Auto-renew: Off"
        elif status == "cancelled":
            auto_label = "Auto-renew: Off"
        elif record is None:
            auto_label = "Not subscribed"
        else:
            auto_label = "Auto-renew: On" if auto_renew else "Auto-renew: Off"

        return {
            "subscription_id": subscription_id,
            "status": status,
            "status_label": label,
            "status_detail": detail,
            "benefits_active": bool(record is not None and self.billing.benefits_active(record, now)),
            "auto_renew": auto_renew,
            "auto_renew_label": auto_label,
            "start_label": start_label,
            "next_billing_label": next_billing,
            "period_end_label": period_end_label,
            "grace_end_label": grace_end_label,
            "payment_amount_label": payment_amount_label,
            "payment_history": history,
            "can_afford": bool(can_afford),
        }

    def _build_permissions(self, status, record, eligibility, can_afford, now):
        period_end = int(record.get("current_period_end", 0) or 0) if record else 0
        return {
            "can_subscribe": bool(
                can_afford
                and eligibility.get("eligible")
                and (record is None or status in ("expired", "not_subscribed"))
            ),
            "can_cancel": status in ("active", "payment_pending", "payment_failed", "grace_period"),
            "can_reactivate": bool(status == "cancelled" and now < period_end),
            "can_retry_payment": bool(
                can_afford and status in ("payment_failed", "grace_period", "suspended")
            ),
            "can_toggle_auto_renew": status == "active",
        }

    def _status_detail(self, status, record, now, eligibility, can_afford=True):
        funds_hint = " Add Simoleons to household funds, then use Refresh."
        if status == "active":
            if record is not None and not record.get("auto_renew", False):
                return "Benefits are active, but automatic renewal is off. The subscription expires at the end of this period."
            return "Your subscription is active and all Verified benefits are available."
        if status == "payment_pending":
            return "A Simoleon payment is currently being processed."
        if status == "payment_failed":
            if record is not None and int(record.get("last_successful_payment", 0) or 0) <= 0:
                message = "The subscription payment failed. No Simoleons were deducted."
                return message + (funds_hint if not can_afford else " Use Retry Payment.")
            grace_end = int(record.get("grace_period_end", 0) or 0) if record else 0
            if not can_afford:
                return "The renewal payment failed. Household funds are below the subscription price." + funds_hint
            return "The renewal payment failed. Retry before {} to keep benefits.".format(
                self.adapter.format_sim_time(grace_end)
            )
        if status == "grace_period":
            grace_end = int(record.get("grace_period_end", 0) or 0) if record else 0
            if not can_afford:
                return "Benefits remain active during grace, but household funds are below the subscription price." + funds_hint
            return "Benefits remain active during the grace period. Retry before {}.".format(
                self.adapter.format_sim_time(grace_end)
            )
        if status == "cancelled":
            end = int(record.get("expiration_timestamp", 0) or record.get("current_period_end", 0) or 0) if record else 0
            return "Cancelled. Benefits remain available until {}.".format(self.adapter.format_sim_time(end))
        if status == "expired":
            return "This subscription has expired. Account data and payment history are preserved."
        if status == "suspended":
            if not can_afford:
                return "Benefits are suspended. Household funds are below the subscription price." + funds_hint
            return "Benefits are suspended. Retry the outstanding payment to restore the blue badge."
        if status == "eligible":
            return "This Sim is eligible for Social Bunny Verified."
        return str(eligibility.get("reason", "Subscribe to unlock Verified benefits."))

    # --- Actions -----------------------------------------------------

    def handle_action(self, sim_id, action, arg1="", arg2=""):
        self.ensure_loaded()
        now = self.adapter.get_now_ticks()
        record = self.get_record(sim_id)
        if record is not None and self.billing.process_due(record, now):
            self.save()
        action = str(action or "").strip().lower()
        if action == "subscribe":
            result = self.subscribe(sim_id)
        elif action == "cancel":
            result = self.cancel(sim_id)
        elif action == "reactivate":
            result = self.reactivate(sim_id)
        elif action == "retry_payment":
            result = self.retry_payment(sim_id)
        elif action == "set_auto_renew":
            result = self.set_auto_renew(sim_id, str(arg1).lower() in ("1", "true", "on", "yes"))
        elif action == "refresh":
            result = self.refresh(sim_id)
        else:
            result = {"ok": False, "code": "unknown_action", "message": "Unknown Verified action."}
            self.notifications.set_last_result(
                sim_id, False, result["message"], result["code"], "error", self.adapter.get_now_ticks()
            )
        self.save()
        return result

    def refresh(self, sim_id):
        record = self.get_record(sim_id)
        now = self.adapter.get_now_ticks()
        if record is not None:
            self.billing.process_due(record, now)
            self.save()
        return {"ok": True, "code": "refreshed", "message": ""}

    def subscribe(self, sim_id):
        sid = str(sim_id)
        now = self.adapter.get_now_ticks()
        record = self.get_record(sid)
        eligibility = self.eligibility.evaluate(sid, record, now, self.plan)
        if record is not None and record.get("status") in ("active", "payment_pending"):
            return self._fail(sid, "already_subscribed", "You already have an active subscription.", now)
        if record is not None and record.get("status") in ("payment_failed", "grace_period"):
            return self._fail(
                sid,
                "payment_failed",
                "A renewal payment is outstanding. Use Retry Payment instead.",
                now,
            )
        if record is not None and record.get("status") == "cancelled" and int(record.get("current_period_end", 0) or 0) > now:
            return self._fail(
                sid,
                "cancelled_active_period",
                "Your paid benefits are still active. Reactivate to keep them after the period ends.",
                now,
            )
        if record is not None and record.get("status") == "suspended":
            return self._fail(
                sid,
                "suspended",
                "This subscription is suspended. Retry the outstanding payment to restore benefits.",
                now,
            )
        if not eligibility.get("eligible"):
            return self._fail(sid, eligibility.get("code", "not_eligible"), eligibility.get("reason", "Not eligible."), now)
        if not self.billing.can_afford(sid):
            return self._fail(
                sid,
                "insufficient_funds",
                "Household funds are below {}.".format(self.billing.format_money(self.billing.price)),
                now,
            )

        if record is None:
            record = self._ensure_record(sid, now)
        record["status"] = "payment_pending"
        self._touch()

        payment = self.billing.charge(sid, self.billing.price)
        if not payment.get("ok"):
            record["status"] = "payment_failed"
            record["auto_renew"] = False
            record["grace_period_end"] = 0
            record["next_billing_at"] = 0
            self.billing.append_payment(record, now, self.billing.price, False, payment.get("message", ""))
            self._notifications_push(
                sid,
                "payment_failed",
                "The subscription payment failed. No Simoleons were deducted. Use Retry Payment.",
                now,
            )
            return self._fail(sid, payment.get("code", "payment_failed"), payment.get("message", "Payment failed."), now)

        self.billing.activate(record, now)
        self.notifications.mark_all_read(sid)
        self.notifications.set_last_result(
            sid,
            True,
            "Social Bunny Verified activated. {} was paid from household funds.".format(
                self.billing.format_money(self.billing.price)
            ),
            "subscribed",
            "success",
            now,
        )
        return {"ok": True, "code": "subscribed", "message": "Subscription activated."}

    def cancel(self, sim_id):
        sid = str(sim_id)
        now = self.adapter.get_now_ticks()
        record = self.get_record(sid)
        if record is None:
            return self._fail(sid, "not_subscribed", "No subscription exists for this Sim.", now)
        if record.get("status") == "cancelled":
            return self._fail(sid, "already_cancelled", "This subscription is already cancelled.", now)
        if record.get("status") not in ("active", "payment_pending", "payment_failed", "grace_period"):
            return self._fail(sid, "not_cancellable", "This subscription cannot be cancelled right now.", now)
        self.billing.cancel(record, now)
        self.notifications.set_last_result(
            sid,
            True,
            "Subscription cancelled. Benefits remain until the end of the paid period.",
            "cancelled",
            "success",
            now,
        )
        return {"ok": True, "code": "cancelled", "message": "Subscription cancelled."}

    def set_auto_renew(self, sim_id, enabled):
        sid = str(sim_id)
        now = self.adapter.get_now_ticks()
        record = self.get_record(sid)
        if record is None:
            return self._fail(sid, "not_subscribed", "No subscription exists for this Sim.", now)

        status = str(record.get("status", "not_subscribed"))
        if enabled:
            if status == "cancelled" and int(record.get("current_period_end", 0) or 0) > now:
                record["status"] = "active"
                record["auto_renew"] = True
                record["cancellation_timestamp"] = 0
                record["expiration_timestamp"] = 0
                record["next_billing_at"] = int(record.get("current_period_end", 0) or 0)
                self._notifications_push(sid, "reactivated", "Automatic renewal restored.", now)
                self.notifications.set_last_result(
                    sid, True, "Automatic renewal restored. Benefits continue.", "auto_renew_on", "success", now
                )
                return {"ok": True, "code": "auto_renew_on", "message": "Auto-renew restored."}
            if status in ("expired", "suspended"):
                return self.reactivate(sid)
            if status in ("active", "payment_failed", "grace_period", "payment_pending"):
                record["auto_renew"] = True
                self._notifications_push(sid, "auto_renew", "Automatic renewal enabled.", now)
                self.notifications.set_last_result(
                    sid, True, "Automatic renewal enabled.", "auto_renew_on", "success", now
                )
                return {"ok": True, "code": "auto_renew_on", "message": "Auto-renew enabled."}
            return self._fail(sid, "not_eligible", "Automatic renewal cannot be enabled in this state.", now)

        if status in ("active", "payment_pending", "payment_failed", "grace_period"):
            record["auto_renew"] = False
            self._notifications_push(
                sid,
                "auto_renew",
                "Automatic renewal disabled. Benefits remain until the end of the paid period.",
                now,
            )
            self.notifications.set_last_result(
                sid, True, "Automatic renewal disabled. Benefits remain until the period ends.", "auto_renew_off", "success", now
            )
            return {"ok": True, "code": "auto_renew_off", "message": "Auto-renew disabled."}
        return self._fail(sid, "not_eligible", "Automatic renewal is already off.", now)

    def reactivate(self, sim_id):
        sid = str(sim_id)
        now = self.adapter.get_now_ticks()
        record = self.get_record(sid)
        if record is None:
            return self._fail(sid, "not_subscribed", "No subscription exists for this Sim.", now)

        status = str(record.get("status", "not_subscribed"))
        if status == "cancelled" and int(record.get("current_period_end", 0) or 0) > now:
            record["status"] = "active"
            record["auto_renew"] = True
            record["cancellation_timestamp"] = 0
            record["expiration_timestamp"] = 0
            record["next_billing_at"] = int(record.get("current_period_end", 0) or 0)
            self._notifications_push(sid, "reactivated", "Subscription reactivated. Automatic renewal is on.", now)
            self.notifications.set_last_result(
                sid, True, "Subscription reactivated without an extra charge.", "reactivated", "success", now
            )
            return {"ok": True, "code": "reactivated", "message": "Subscription reactivated."}
        if status == "active" and not record.get("auto_renew", False):
            record["auto_renew"] = True
            self._notifications_push(sid, "auto_renew", "Automatic renewal restored.", now)
            self.notifications.set_last_result(
                sid, True, "Automatic renewal restored.", "reactivated", "success", now
            )
            return {"ok": True, "code": "reactivated", "message": "Subscription reactivated."}
        if status == "expired":
            return self.subscribe(sid)
        if status == "suspended":
            return self.retry_payment(sid)
        return self._fail(sid, "not_reactivatable", "This subscription cannot be reactivated right now.", now)

    def retry_payment(self, sim_id):
        sid = str(sim_id)
        now = self.adapter.get_now_ticks()
        record = self.get_record(sid)
        if record is None:
            return self._fail(sid, "not_subscribed", "No subscription exists for this Sim.", now)
        status = str(record.get("status", "not_subscribed"))
        if status not in ("payment_failed", "grace_period", "suspended"):
            return self._fail(sid, "no_payment_due", "There is no failed payment to retry.", now)
        if not self.billing.can_afford(sid):
            return self._fail(
                sid,
                "insufficient_funds",
                "Household funds are below {}.".format(self.billing.format_money(self.billing.price)),
                now,
            )

        was_suspended = status == "suspended"
        never_activated = int(record.get("last_successful_payment", 0) or 0) <= 0
        record["status"] = "payment_pending"
        payment = self.billing.charge(sid, self.billing.price)
        if not payment.get("ok"):
            if was_suspended:
                self.billing.append_payment(record, now, self.billing.price, False, payment.get("message", ""))
                record["status"] = "suspended"
                record["grace_period_end"] = 0
                record["next_billing_at"] = int(now + self.billing.retry_ticks)
            elif never_activated:
                self.billing.append_payment(record, now, self.billing.price, False, payment.get("message", ""))
                record["status"] = "payment_failed"
                record["auto_renew"] = False
                record["grace_period_end"] = 0
                record["next_billing_at"] = 0
            else:
                self.billing.fail_payment(
                    record, now, payment.get("message", "Payment failed."), payment.get("code", "payment_failed")
                )
            return self._fail(sid, payment.get("code", "payment_failed"), payment.get("message", "Payment failed."), now)

        self.billing.apply_new_period(record, now)
        self.billing.append_payment(record, now, self.billing.price, True, "Manual retry")
        self._notifications_push(
            sid,
            "payment_succeeded",
            "Payment received. Social Bunny Verified benefits have been restored.",
            now,
        )
        self.notifications.set_last_result(
            sid,
            True,
            "Payment received. Verified benefits restored.",
            "payment_succeeded",
            "success",
            now,
        )
        return {"ok": True, "code": "payment_succeeded", "message": "Payment completed."}

    def _fail(self, sim_id, code, message, now):
        self.notifications.set_last_result(sim_id, False, message, code, "error", now)
        return {"ok": False, "code": code, "message": message}

    def _notifications_push(self, sim_id, kind, message, now):
        return self.notifications.push(sim_id, kind, message, now)

    # --- Billing tick ------------------------------------------------

    def process_due_all(self):
        if self._payload is None:
            return 0
        now = int(self.adapter.get_now_ticks())
        changed = 0
        for sid, record in list(self._subscriptions().items()):
            if not isinstance(record, dict):
                continue
            try:
                if self.billing.process_due(record, now):
                    changed += 1
            except Exception:
                continue
        if changed:
            self._touch()
            self.save()
        return changed

    def tick(self):
        return self.process_due_all()

    def start_billing_alarm(self):
        if self._alarm_handle is not None:
            return
        try:
            import alarms
            import date_and_time

            self._alarm_handle = alarms.add_alarm(
                self,
                date_and_time.create_time_span(hours=1),
                self._on_billing_alarm,
                repeating=True,
                use_sleep_time=False,
            )
        except Exception:
            self._alarm_handle = None

    def stop_billing_alarm(self):
        if self._alarm_handle is not None:
            try:
                self._alarm_handle.cancel()
            except Exception:
                pass
            self._alarm_handle = None

    def _on_billing_alarm(self, _handle=None):
        try:
            self.ensure_loaded()
            self.process_due_all()
        except Exception:
            pass

    # --- Debug -------------------------------------------------------

    def debug_summary(self):
        self.ensure_loaded()
        return {
            "slot_id": self._loaded_slot_id,
            "subscriptions": len(self._subscriptions()),
            "verified": len(self.get_verified_sim_ids()),
            "price": self.billing.price,
            "interval_days": int(self.plan.get("billing_interval_days", 7)),
        }
