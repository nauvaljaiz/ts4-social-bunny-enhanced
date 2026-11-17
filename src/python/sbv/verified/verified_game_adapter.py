# -*- coding: utf-8 -*-
"""Thin, defensive adapter around the real Sims 4 time, Sim, and funds APIs."""

import math
import random

FALLBACK_TICKS_PER_DAY = 25 * 60 * 60 * 24  # 25 real ms per Sim second


class VerifiedGameAdapter(object):
    """Keeps gameplay API calls isolated from the subscription domain logic."""

    def __init__(
        self,
        sim_provider=None,
        now_provider=None,
        slot_provider=None,
        funds_provider=None,
        followers_provider=None,
        fame_provider=None,
        reaction_provider=None,
        friendship_provider=None,
    ):
        self._sim_provider = sim_provider
        self._now_provider = now_provider
        self._slot_provider = slot_provider
        self._funds_provider = funds_provider
        self._followers_provider = followers_provider
        self._fame_provider = fame_provider
        self._reaction_provider = reaction_provider
        self._friendship_provider = friendship_provider

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

    # --- Perks & Social Media gameplay helpers ------------------------

    def get_followers(self, sim_id):
        if self._followers_provider is not None:
            try:
                return int(self._followers_provider("get", sim_id, 0))
            except Exception:
                return 0
        try:
            import services

            service = services.get_social_media_service()
            if service is not None:
                sid = int(sim_id) if str(sim_id).isdigit() else sim_id
                return int(service.get_current_followers_count(sid) or 0)
        except Exception:
            pass
        return 0

    def add_followers(self, sim_id, delta):
        delta = int(round(float(delta)))
        if delta == 0:
            return self.get_followers(sim_id)
        if self._followers_provider is not None:
            try:
                return int(self._followers_provider("add", sim_id, delta))
            except Exception:
                return 0
        try:
            from social_media.social_media_tuning import SocialMediaTunables

            sim_info = self.get_sim(sim_id)
            stat = getattr(SocialMediaTunables, "FOLLOWERS_TRACKING_COMMODITY", None)
            if sim_info is None or stat is None:
                return 0
            tracker = sim_info.get_tracker(stat)
            if tracker is None:
                return 0
            current = int(tracker.get_value(stat) or 0) if tracker.has_statistic(stat) else 0
            new_val = max(0, current + delta)
            tracker.set_value(stat, new_val, add=True)
            return int(new_val)
        except Exception:
            return 0

    def deposit_household_funds(self, sim_id, amount):
        amount = int(amount)
        if amount <= 0:
            return False
        funds = self.get_funds(sim_id)
        if funds is None:
            return False
        if isinstance(funds, dict):
            funds["money"] = int(funds.get("money", 0)) + amount
            return True
        try:
            reason = 0
            try:
                from protocolbuffers import Consts_pb2

                for name in (
                    "TELEMETRY_MONEY_ROYALTY",
                    "TELEMETRY_MONEY_CAREER",
                    "TELEMETRY_MONEY_OTHER",
                    "TELEMETRY_MONEY_CHEAT",
                ):
                    if hasattr(Consts_pb2, name):
                        reason = getattr(Consts_pb2, name)
                        break
            except Exception:
                pass
            sim_info = self.get_sim(sim_id)
            if isinstance(sim_info, dict):
                sim_info = None
            funds.add(amount, reason, sim_info, count_as_earnings=True)
            return True
        except Exception:
            return False

    def grant_fame(self, sim_id, amount):
        amount = float(amount)
        if amount <= 0:
            return False
        if self._fame_provider is not None:
            try:
                return bool(self._fame_provider(sim_id, amount))
            except Exception:
                return False
        try:
            from fame.fame_tuning import FameTunables

            stat = getattr(FameTunables, "FAME_RANKED_STATISTIC", None)
            sim_info = self.get_sim(sim_id)
            if stat is None or sim_info is None:
                return False
            tracker = sim_info.get_tracker(stat)
            if tracker is None:
                return False
            tracker.add_value(stat, amount)
            return True
        except Exception:
            return False

    def add_friendship(self, sim_id_a, sim_id_b, amount):
        amount = float(amount)
        if amount == 0:
            return False
        if self._friendship_provider is not None:
            try:
                return bool(self._friendship_provider(sim_id_a, sim_id_b, amount))
            except Exception:
                return False
        try:
            sim_info = self.get_sim(sim_id_a)
            tracker = getattr(sim_info, "relationship_tracker", None) if sim_info is not None else None
            target_id = int(sim_id_b) if str(sim_id_b).isdigit() else sim_id_b
            if tracker is None or not target_id:
                return False
            tracker.add_relationship_score(target_id, amount)
            return True
        except Exception:
            return False

    def simulate_npc_reactions(self, sim_id, max_reactions=2):
        max_reactions = max(0, int(max_reactions))
        if max_reactions <= 0:
            return 0
        if self._reaction_provider is not None:
            try:
                return int(self._reaction_provider(sim_id, max_reactions))
            except Exception:
                return 0
        try:
            import services
            from social_media import SocialMediaNarrative, SocialMediaPolarity, SocialMediaPostType
            from social_media.social_media_post import SocialMediaPostReaction
            from social_media.social_media_tuning import SocialMediaTunables

            service = services.get_social_media_service()
            if service is None:
                return 0
            sid = int(sim_id) if str(sim_id).isdigit() else 0
            posts = list(service.get_posts_for_sim(sid) or [])
            own_posts = [
                p
                for p in posts
                if int(getattr(p, "author_sim_id", 0)) == sid
                and getattr(p, "post_type", None)
                in (SocialMediaPostType.DEFAULT, SocialMediaPostType.PUBLIC_POST)
            ]
            if not own_posts:
                return 0
            recent_posts = list(reversed(own_posts[-3:]))

            sim_info = self.get_sim(sid)
            friend_ids = []
            if sim_info is not None and hasattr(sim_info, "get_social_media_friends"):
                try:
                    friend_ids = [
                        int(getattr(f, "sim_id", f))
                        for f in (sim_info.get_social_media_friends() or [])
                    ]
                except Exception:
                    friend_ids = []
            # Mix in broader NPC audience so reactions come from varied Sims too
            npc_pool = []
            for cand in self.all_sim_infos():
                cid = int(getattr(cand, "sim_id", 0) or 0)
                if cid and cid != sid and bool(getattr(cand, "is_npc", False)):
                    npc_pool.append(cid)
                    if len(npc_pool) >= 20:
                        break
            combined_ids = list(dict.fromkeys(friend_ids + npc_pool))
            random.shuffle(combined_ids)

            # Build the true set of UI-supported reaction (narrative, polarity) pairs
            # from SocialMediaTunables.SOCIAL_MEDIA_POST_REACTIONS, with weighted fallback.
            reaction_pool = []
            try:
                for entry in (getattr(SocialMediaTunables, "SOCIAL_MEDIA_POST_REACTIONS", None) or ()):
                    nar = getattr(entry, "narrative", None)
                    pol = getattr(entry, "polarity", None)
                    if nar is not None and pol is not None:
                        reaction_pool.append((nar, pol))
            except Exception:
                reaction_pool = []
            if not reaction_pool:
                reaction_pool = [
                    (SocialMediaNarrative.FRIENDLY, SocialMediaPolarity.POSITIVE),
                    (SocialMediaNarrative.FRIENDLY, SocialMediaPolarity.POSITIVE),
                    (SocialMediaNarrative.FRIENDLY, SocialMediaPolarity.NEGATIVE),
                    (SocialMediaNarrative.FRIENDLY, SocialMediaPolarity.NEGATIVE),
                    (SocialMediaNarrative.FLIRTY, SocialMediaPolarity.POSITIVE),
                    (SocialMediaNarrative.FLIRTY, SocialMediaPolarity.NEGATIVE),
                    (SocialMediaNarrative.MEAN, SocialMediaPolarity.POSITIVE),
                    (SocialMediaNarrative.MEAN, SocialMediaPolarity.NEGATIVE),
                ]
            cap = int(getattr(SocialMediaTunables, "REACTIONS_PER_POST_NUMBER_CAP", 99) or 99)

            added = 0
            used_combos = []
            for fid in combined_ids:
                if added >= max_reactions:
                    break
                if fid == sid:
                    continue
                random.shuffle(recent_posts)
                for target_post in recent_posts:
                    try:
                        if target_post.total_reactions() >= cap:
                            continue
                        if target_post.sim_has_reacted(fid):
                            continue
                        # Prefer a reaction emoji not yet picked in this wave
                        fresh = [pair for pair in reaction_pool if pair not in used_combos]
                        nar, pol = random.choice(fresh or reaction_pool)
                        used_combos.append((nar, pol))
                        reaction = SocialMediaPostReaction(nar, pol, 1)
                        service.add_reaction_to_post(fid, sid, target_post, reaction)
                        added += 1
                        break
                    except Exception:
                        continue
            return added
        except Exception:
            return 0
