# -*- coding: utf-8 -*-
"""Eligibility rules for the paid Social Bunny Verified subscription."""

ACTIVE_BENEFIT_STATUSES = ("active", "payment_pending")


class VerifiedEligibilityService(object):
    def __init__(self, adapter):
        self._adapter = adapter

    def evaluate(self, sim_id, record, now_ticks, plan):
        reason = ""
        code = "eligible"
        eligible = True

        if not self._adapter.is_player_sim(sim_id):
            return {
                "eligible": False,
                "code": "not_player_sim",
                "reason": "Only player-controlled Sims can subscribe to Social Bunny Verified.",
            }

        if not self._adapter.is_household_available(sim_id):
            return {
                "eligible": False,
                "code": "household_missing",
                "reason": "This Sim's household could not be found, so a subscription cannot be started.",
            }

        status = str(record.get("status", "not_subscribed")) if isinstance(record, dict) else "not_subscribed"
        if status in ACTIVE_BENEFIT_STATUSES:
            return {
                "eligible": False,
                "code": "already_subscribed",
                "reason": "This Sim already has an active Social Bunny Verified subscription.",
            }
        if status == "payment_failed":
            return {
                "eligible": False,
                "code": "payment_failed",
                "reason": "A renewal payment failed. Retry the payment before starting a new subscription.",
            }
        if status == "grace_period":
            return {
                "eligible": False,
                "code": "grace_period",
                "reason": "This subscription is in its grace period. Retry the payment to keep benefits.",
            }
        if status == "cancelled" and int(record.get("current_period_end", 0) or 0) > int(now_ticks):
            return {
                "eligible": False,
                "code": "cancelled_active_period",
                "reason": "This subscription is cancelled but its paid benefits remain until the end of the period.",
            }
        if status == "suspended":
            return {
                "eligible": False,
                "code": "suspended",
                "reason": "This subscription is suspended. Retry the outstanding payment to restore benefits.",
            }

        price = int(plan.get("price", 250))
        money = self._adapter.get_money(sim_id)
        if money < price:
            return {
                "eligible": False,
                "code": "insufficient_funds",
                "reason": "Household funds are below the {} Simoleon subscription price.".format(price),
            }

        return {
            "eligible": bool(eligible),
            "code": code,
            "reason": reason,
        }
