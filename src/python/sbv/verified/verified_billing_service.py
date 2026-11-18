# -*- coding: utf-8 -*-
"""Simoleon billing, renewals, grace periods, and payment history."""

STATUS_LABELS = {
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


def _money_reason():
    try:
        from protocolbuffers import Consts_pb2

        for name in (
            "TELEMETRY_MONEY_BILLS",
            "TELEMETRY_MONEY_SHOPPING",
            "TELEMETRY_MONEY_OTHER",
            "TELEMETRY_MONEY_CHEAT",
        ):
            if hasattr(Consts_pb2, name):
                return getattr(Consts_pb2, name)
    except Exception:
        pass
    return 0


class VerifiedBillingService(object):
    def __init__(self, adapter, notifications, plan):
        self._adapter = adapter
        self._notifications = notifications
        self._plan = plan

    @property
    def price(self):
        return int(self._plan.get("price", 250))

    @property
    def interval_ticks(self):
        return self._adapter.ticks_from_days(self._plan.get("billing_interval_days", 7))

    @property
    def grace_ticks(self):
        return self._adapter.ticks_from_days(self._plan.get("grace_period_days", 2))

    @property
    def retry_ticks(self):
        return max(1, self._adapter.ticks_from_hours(self._plan.get("retry_interval_hours", 12)))

    @property
    def reminder_ticks(self):
        return self._adapter.ticks_from_hours(self._plan.get("renewal_reminder_hours", 24))

    def now(self):
        return self._adapter.get_now_ticks()

    def format_money(self, amount):
        return "\u00a7{}".format(int(round(float(amount))))

    def can_afford(self, sim_id):
        funds = self._adapter.get_funds(sim_id)
        if funds is None:
            return False
        if isinstance(funds, dict):
            money = int(funds.get("money", 0))
            return money >= self.price
        try:
            return bool(funds.can_afford(self.price))
        except Exception:
            try:
                return int(getattr(funds, "money", 0)) >= self.price
            except Exception:
                return False

    def charge(self, sim_id, amount):
        """Attempt a full Simoleon debit. Never partially deduct funds."""
        amount = int(amount)
        if amount <= 0:
            return {"ok": False, "code": "invalid_amount", "message": "Invalid subscription price."}

        funds = self._adapter.get_funds(sim_id)
        if funds is None:
            return {"ok": False, "code": "household_missing", "message": "Household funds could not be found."}

        if isinstance(funds, dict):
            money = int(funds.get("money", 0))
            if money < amount:
                return {
                    "ok": False,
                    "code": "insufficient_funds",
                    "message": "Insufficient household funds. Need {}.".format(self.format_money(amount)),
                }
            funds["money"] = money - amount
            return {"ok": True, "code": "paid", "message": "Payment completed."}

        try:
            if not funds.can_afford(amount):
                return {
                    "ok": False,
                    "code": "insufficient_funds",
                    "message": "Insufficient household funds. Need {}.".format(self.format_money(amount)),
                }
        except Exception:
            pass

        # Real TS4 _Funds.try_remove returns a bool (True/False), whereas
        # _Funds.try_remove_amount returns the deducted int (or None). Handle both.
        if hasattr(funds, "try_remove_amount"):
            try:
                removed_amount = funds.try_remove_amount(amount, _money_reason(), None, True)
            except Exception:
                removed_amount = None
            if removed_amount is None or int(removed_amount) < amount:
                return {
                    "ok": False,
                    "code": "payment_failed",
                    "message": "The full subscription amount could not be deducted.",
                }
            return {"ok": True, "code": "paid", "message": "Payment completed."}

        try:
            removed = funds.try_remove(amount, _money_reason(), None, True)
        except Exception:
            removed = None
        if isinstance(removed, bool):
            if not removed:
                return {
                    "ok": False,
                    "code": "payment_failed",
                    "message": "The household could not complete the Simoleon payment.",
                }
            return {"ok": True, "code": "paid", "message": "Payment completed."}
        if removed is None:
            return {
                "ok": False,
                "code": "payment_failed",
                "message": "The household could not complete the Simoleon payment.",
            }
        try:
            if int(removed) < amount:
                return {
                    "ok": False,
                    "code": "payment_failed",
                    "message": "The full subscription amount could not be deducted.",
                }
        except Exception:
            pass
        return {"ok": True, "code": "paid", "message": "Payment completed."}

    # --- Record helpers ----------------------------------------------

    def append_payment(self, record, now_ticks, amount, succeeded, note=""):
        history = record.setdefault("payment_history", [])
        history.insert(
            0,
            {
                "tick": int(now_ticks),
                "date_label": self._adapter.format_sim_time(now_ticks),
                "amount": int(amount),
                "amount_label": self.format_money(amount),
                "status": "succeeded" if succeeded else "failed",
                "status_label": "Paid" if succeeded else "Failed",
                "note": str(note or ""),
            },
        )
        del history[40:]

    def apply_new_period(self, record, now_ticks):
        record["status"] = "active"
        record["start_date"] = int(record.get("start_date", 0) or now_ticks)
        record["current_period_start"] = int(now_ticks)
        record["current_period_end"] = int(now_ticks + self.interval_ticks)
        record["next_billing_at"] = int(record["current_period_end"])
        record["last_successful_payment"] = int(now_ticks)
        record["payment_amount"] = self.price
        record["auto_renew"] = True
        record["cancellation_timestamp"] = 0
        record["expiration_timestamp"] = 0
        record["grace_period_end"] = 0
        record["last_failure_at"] = 0
        record["last_failure_reason"] = ""
        record["retry_count"] = 0
        record["last_manual_retry_at"] = 0
        record["reminder_sent_for"] = 0
        record["suspension_reason"] = ""

    def activate(self, record, now_ticks):
        self.apply_new_period(record, now_ticks)
        self.append_payment(record, now_ticks, self.price, True, "Subscription activated")
        self._notifications.push(
            record["sim_id"],
            "subscription_activated",
            "Social Bunny Verified is active. Your blue verification badge and subscriber benefits are now live.",
            now_ticks,
        )

    def start_payment_pending(self, record):
        record["status"] = "payment_pending"

    def succeed_renewal(self, record, now_ticks, reason="renewal"):
        self.apply_new_period(record, now_ticks)
        self.append_payment(record, now_ticks, self.price, True, reason)
        self._notifications.push(
            record["sim_id"],
            "renewal",
            "Social Bunny Verified renewed for {} {}.".format(
                self.format_money(self.price),
                self._plan.get("billing_interval_label", "per Sim week"),
            ),
            now_ticks,
        )

    def fail_payment(self, record, now_ticks, reason, code="payment_failed"):
        self.append_payment(record, now_ticks, self.price, False, reason)
        record["last_failure_at"] = int(now_ticks)
        record["last_failure_reason"] = str(reason)
        record["retry_count"] = int(record.get("retry_count", 0)) + 1

        status = str(record.get("status", ""))
        grace_end = int(record.get("grace_period_end", 0) or 0)

        if status == "suspended":
            record["suspension_reason"] = "payment"
            record["next_billing_at"] = int(now_ticks + self.retry_ticks)
            self._notifications.push(
                record["sim_id"],
                "payment_failed",
                "The subscription payment could not be completed. The subscription remains suspended.",
                now_ticks,
            )
            return

        if grace_end <= 0:
            record["status"] = "payment_failed"
            record["grace_period_end"] = int(now_ticks + self.grace_ticks)
            record["next_billing_at"] = int(now_ticks + self.retry_ticks)
            self._notifications.push(
                record["sim_id"],
                "payment_failed",
                "The renewal payment failed. Retry before the grace period ends to keep your benefits.",
                now_ticks,
            )
            return

        if now_ticks >= grace_end:
            self.suspend(record, now_ticks, "Grace period ended without a successful payment.")
            return

        record["status"] = "grace_period"
        record["next_billing_at"] = int(min(now_ticks + self.retry_ticks, grace_end))
        self._notifications.push(
            record["sim_id"],
            "grace_period",
            "The renewal payment is still outstanding. Benefits remain active during the grace period.",
            now_ticks,
        )

    def attempt_renewal(self, record, now_ticks, reason="Automatic renewal"):
        self.start_payment_pending(record)
        result = self.charge(record["sim_id"], self.price)
        if result.get("ok"):
            self.succeed_renewal(record, now_ticks, reason)
        else:
            self.fail_payment(record, now_ticks, result.get("message", reason), result.get("code", "payment_failed"))
        return result

    def suspend(self, record, now_ticks, reason=""):
        record["status"] = "suspended"
        record["suspension_reason"] = "payment"
        record["auto_renew"] = True
        record["grace_period_end"] = 0
        record["next_billing_at"] = int(now_ticks + self.retry_ticks)
        self._notifications.push(
            record["sim_id"],
            "suspended",
            "Social Bunny Verified is suspended because the renewal payment failed. Retry the payment to restore benefits.",
            now_ticks,
        )

    def expire(self, record, now_ticks, reason=""):
        record["status"] = "expired"
        record["auto_renew"] = False
        record["expiration_timestamp"] = int(now_ticks)
        record["next_billing_at"] = 0
        self._notifications.push(
            record["sim_id"],
            "expired",
            "Social Bunny Verified has expired. Subscription data and payment history are preserved.",
            now_ticks,
        )

    def cancel(self, record, now_ticks):
        record["status"] = "cancelled"
        record["auto_renew"] = False
        record["cancellation_timestamp"] = int(now_ticks)
        end = int(record.get("current_period_end", 0) or now_ticks)
        record["expiration_timestamp"] = max(int(now_ticks), end)
        record["next_billing_at"] = 0
        self._notifications.push(
            record["sim_id"],
            "cancelled",
            "Social Bunny Verified was cancelled. Benefits remain until the end of the paid period.",
            now_ticks,
        )

    def benefits_active(self, record, now_ticks):
        if not isinstance(record, dict):
            return False
        status = str(record.get("status", "not_subscribed"))
        if status == "active":
            return True
        if status == "payment_pending":
            return False
        if status in ("payment_failed", "grace_period"):
            if int(record.get("last_successful_payment", 0) or 0) <= 0:
                return False
            grace_end = int(record.get("grace_period_end", 0) or 0)
            return grace_end <= 0 or int(now_ticks) < grace_end
        if status == "cancelled":
            end = int(record.get("expiration_timestamp", 0) or record.get("current_period_end", 0) or 0)
            return int(now_ticks) < end
        return False

    def process_due(self, record, now_ticks):
        """Advance one subscription to its correct current state."""
        status = str(record.get("status", "not_subscribed"))
        changed = False

        if status == "payment_pending":
            return False

        if status == "active":
            next_billing = int(record.get("next_billing_at", 0) or 0)
            if next_billing > 0 and now_ticks >= next_billing:
                if bool(record.get("auto_renew", True)):
                    self.attempt_renewal(record, now_ticks, "Automatic renewal")
                else:
                    self.expire(record, now_ticks, "Auto-renew was disabled")
                return True
            if bool(record.get("auto_renew", True)) and next_billing > 0:
                reminder_at = next_billing - self.reminder_ticks
                if now_ticks >= reminder_at and int(record.get("reminder_sent_for", 0) or 0) != next_billing:
                    record["reminder_sent_for"] = next_billing
                    self._notifications.push(
                        record["sim_id"],
                        "renewal_reminder",
                        "Your Social Bunny Verified renewal is coming up on {}.".format(
                            self._adapter.format_sim_time(next_billing)
                        ),
                        now_ticks,
                    )
                    changed = True
            return changed

        if status in ("payment_failed", "grace_period"):
            grace_end = int(record.get("grace_period_end", 0) or 0)
            if grace_end > 0 and now_ticks >= grace_end:
                self.suspend(record, now_ticks, "Grace period ended")
                return True
            last_manual_retry = int(record.get("last_manual_retry_at", 0) or 0)
            if last_manual_retry > 0 and now_ticks < last_manual_retry + self.retry_ticks:
                return False
            next_billing = int(record.get("next_billing_at", 0) or 0)
            if next_billing > 0 and now_ticks >= next_billing:
                self.attempt_renewal(record, now_ticks, "Grace-period retry")
                return True
            return False

        if status == "cancelled":
            end = int(record.get("expiration_timestamp", 0) or record.get("current_period_end", 0) or 0)
            if end > 0 and now_ticks >= end:
                self.expire(record, now_ticks, "Cancelled subscription period ended")
                return True
            return False

        return False

    # --- Presentation helpers ---------------------------------------

    def status_label(self, status):
        return STATUS_LABELS.get(str(status), "Not Subscribed")

    def format_interval_label(self):
        days = int(self._plan.get("billing_interval_days", 7))
        if days == 7:
            return "per Sim week"
        if days == 1:
            return "per Sim day"
        return "every {} Sim days".format(days)

    def relative_label(self, tick, now_ticks):
        if not tick:
            return ""
        return "{} ({})".format(
            self._adapter.format_sim_time(tick),
            self._adapter.format_relative_days(tick, now_ticks),
        )
