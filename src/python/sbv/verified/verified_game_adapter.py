# -*- coding: utf-8 -*-
"""Thin, defensive adapter around the real Sims 4 time, Sim, and funds APIs."""

import math

FALLBACK_TICKS_PER_DAY = 25 * 60 * 60 * 24  # 25 real ms per Sim second


class VerifiedGameAdapter(object):
    """Keeps gameplay API calls isolated from the subscription domain logic."""

    def __init__(self, sim_provider=None, now_provider=None, slot_provider=None, funds_provider=None):
        self._sim_provider = sim_provider
        self._now_provider = now_provider
        self._slot_provider = slot_provider
        self._funds_provider = funds_provider

    # --- Time ---------------------------------------------------------

    def get_now_ticks(self):
        if self._now_provider is not None:
            try:
                return int(self._now_provider())
            except Exception:
                return 0
        try:
            import services

            time_service = services.time_service()
            if time_service is not None and time_service.sim_now is not None:
                return int(time_service.sim_now.absolute_ticks())
        except Exception:
            pass
        return 0

    def ticks_per_day(self):
        try:
            import date_and_time

            return int(date_and_time.sim_ticks_per_day())
        except Exception:
            return FALLBACK_TICKS_PER_DAY

    def ticks_from_days(self, days):
        return int(days) * self.ticks_per_day()

    def ticks_from_hours(self, hours):
        return int(int(hours) * self.ticks_per_day() / 24)

    def format_sim_time(self, ticks):
        try:
            from date_and_time import DateAndTime

            return DateAndTime(int(ticks)).debug_readable_time()
        except Exception:
            day = int(ticks // max(1, self.ticks_per_day()))
            return "Day {}".format(day)

    def format_sim_date(self, ticks):
        try:
            from date_and_time import DateAndTime

            dt = DateAndTime(int(ticks))
            return "Day {} ({})".format(int(dt.absolute_days()), dt.debug_readable_time())
        except Exception:
            return "Day {}".format(int(ticks // max(1, self.ticks_per_day())))

    def format_relative_days(self, target_ticks, now_ticks):
        try:
            days = int(math.ceil(float(target_ticks - now_ticks) / float(max(1, self.ticks_per_day()))))
        except Exception:
            days = 0
        if days <= 0:
            return "today"
        if days == 1:
            return "in 1 Sim day"
        return "in {} Sim days".format(days)

    # --- Save slot ----------------------------------------------------

    def get_slot_id(self):
        if self._slot_provider is not None:
            try:
                return int(self._slot_provider())
            except Exception:
                return 0
        try:
            import services

            persistence = services.get_persistence_service()
            if persistence is not None:
                proto = persistence.get_save_slot_proto_buff()
                if proto is not None and hasattr(proto, "slot_id"):
                    return int(proto.slot_id)
        except Exception:
            pass
        return 0

    # --- Sims ---------------------------------------------------------

    def get_sim(self, sim_id):
        if self._sim_provider is not None:
            try:
                return self._sim_provider(sim_id)
            except Exception:
                return None
        try:
            import services

            manager = services.sim_info_manager()
            if manager is not None:
                return manager.get(int(sim_id))
        except Exception:
            pass
        return None

    def get_display_name(self, sim_id):
        sim = self.get_sim(sim_id)
        if sim is None:
            return "Sim {}".format(sim_id)
        if isinstance(sim, dict):
            name = sim.get("display_name")
            if name:
                return str(name)
            first = str(sim.get("first_name", "") or "")
            last = str(sim.get("last_name", "") or "")
            full = (first + " " + last).strip()
            return full or "Sim {}".format(sim_id)
        first = str(getattr(sim, "first_name", "") or "")
        last = str(getattr(sim, "last_name", "") or "")
        full = (first + " " + last).strip()
        return full or "Sim {}".format(sim_id)

    def is_player_sim(self, sim_id):
        sim = self.get_sim(sim_id)
        if sim is None:
            return False
        if isinstance(sim, dict):
            return not bool(sim.get("is_npc", False))
        return not bool(getattr(sim, "is_npc", False))

    def get_household(self, sim_id):
        sim = self.get_sim(sim_id)
        if sim is None:
            return None
        if isinstance(sim, dict):
            return sim.get("household")
        return getattr(sim, "household", None)

    def get_funds(self, sim_id):
        if self._funds_provider is not None:
            try:
                return self._funds_provider(sim_id)
            except Exception:
                return None
        household = self.get_household(sim_id)
        if household is None:
            return None
        return getattr(household, "funds", None)

    def get_money(self, sim_id):
        funds = self.get_funds(sim_id)
        if funds is None:
            return 0
        if isinstance(funds, dict):
            return int(funds.get("money", 0))
        try:
            return int(getattr(funds, "money", 0))
        except Exception:
            return 0

    def is_household_available(self, sim_id):
        return self.get_funds(sim_id) is not None

    def get_active_sim_id(self):
        try:
            import services

            sim = services.active_sim_info()
            if sim is not None:
                return int(sim.sim_id)
        except Exception:
            pass
        return None

    def find_sim_info_by_id(self, sim_id):
        return self.get_sim(sim_id)

    def all_sim_infos(self):
        try:
            import services

            manager = services.sim_info_manager()
            if manager is not None:
                return list(manager.get_all())
        except Exception:
            pass
        return []
