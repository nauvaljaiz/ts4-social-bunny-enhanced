# -*- coding: utf-8 -*-
"""Alarm-driven batched NPC simulation for Social Bunny Verified."""

import random
from typing import Any, Dict, List


class NPCSocialService(object):
    """
    Runs lightweight batched NPC activity without per-tick world scans.

    Each simulation batch processes at most `BATCH_SIZE` NPCs, respecting per-NPC
    activity cooldowns and driving posts, follows, likes, comments, verification
    applications, brand offers, and occasional controversies.
    """

    BATCH_SIZE = 8
    NPC_POST_COOLDOWN_TICKS = 8 * 60     # 8 Sim hours
    NPC_INTERACT_COOLDOWN_TICKS = 4 * 60  # 4 Sim hours
    MAX_SEEDED_NPCS = 24

    def __init__(self, social_bunny_service: Any) -> None:
        self._sbv = social_bunny_service
        self._alarm_handle = None
        self._last_post_tick: Dict[str, int] = {}
        self._last_interact_tick: Dict[str, int] = {}
        self._cursor: int = 0

    def start_alarm(self) -> None:
        """Schedule repeating in-game alarm (~4 Sim hours) when running inside TS4."""
        self.stop_alarm()
        try:
            import alarms
            import date_and_time
            span = date_and_time.create_time_span(hours=4)
            self._alarm_handle = alarms.add_alarm(
                self,
                span,
                self._on_alarm,
                repeating=True,
                use_sleep_time=False,
            )
        except Exception:
            self._alarm_handle = None

    def stop_alarm(self) -> None:
        if self._alarm_handle is not None:
            try:
                self._alarm_handle.cancel()
            except Exception:
                pass
            self._alarm_handle = None

    def _on_alarm(self, _handle: Any) -> None:
        try:
            self.run_batch(max_npcs=self.BATCH_SIZE)
        except Exception:
            pass

    def seed_world_npcs(self, sim_records: List[Dict[str, Any]], now_ticks: int = 0) -> int:
        """Lazily register up to MAX_SEEDED_NPCS notable townies/celebrities."""
        created = 0
        for rec in sim_records:
            if created >= self.MAX_SEEDED_NPCS:
                break
            sid = str(rec["sim_id"])
            if self._sbv.accounts.has_account(sid):
                continue
            acc = self._sbv.accounts.ensure_account(
                sim_id=sid,
                display_name=rec.get("name", "Townie {}".format(sid)),
                now_ticks=now_ticks,
                is_npc=True,
                traits=rec.get("traits", []),
                career=rec.get("career", ""),
                fame_level=rec.get("fame_level", 0),
                category=rec.get("category"),
            )
            if not acc.get("bio"):
                acc["bio"] = self._generate_npc_bio(acc)
            # Notable Sims or stars start with authentic baseline posts/verification
            if int(acc.get("fame_level", 0)) >= 3 and len(self._sbv.posts.get_posts_by_author(sid)) == 0:
                self._sbv.create_post(
                    sid,
                    "Back on set in Del Sol Valley! Grateful for all the love. #StarLife",
                    post_type="achievement",
                )
                self._sbv.accounts.get_account(sid)["verification_tier"] = "blue_verified"
            created += 1
        return created

    def _generate_npc_bio(self, acc: Dict[str, Any]) -> str:
        career = acc.get("career") or "Willow Creek resident"
        traits = acc.get("traits") or []
        if traits:
            return "{} | {} | Living my best Sim life.".format(career, traits[0])[:150]
        return "{} | Sharing daily moments on Social Bunny.".format(career)[:150]

    def run_batch(self, max_npcs: int = 8) -> Dict[str, int]:
        """Execute one bounded simulation batch across active NPC accounts."""
        now_ticks = self._sbv.get_now_ticks()
        npcs = [a for a in self._sbv.accounts.all_accounts() if a.get("is_npc") and a.get("status") != "suspended"]
        if not npcs:
            return {"processed": 0, "posts": 0, "reactions": 0, "follows": 0}

        count = min(max_npcs, len(npcs))
        stats = {"processed": 0, "posts": 0, "reactions": 0, "follows": 0, "verifications": 0}
        all_accounts = self._sbv.accounts.all_accounts()
        recent_posts = self._sbv.posts.get_all_posts()[:25]

        for _ in range(count):
            idx = self._cursor % len(npcs)
            self._cursor += 1
            npc = npcs[idx]
            sid = str(npc["sim_id"])
            stats["processed"] += 1

            self._sbv.moderation.refresh_timed_penalties(npc, now_ticks)

            # 1. Contextual NPC posting with cooldown
            last_p = self._last_post_tick.get(sid, -99999)
            post_chance = 0.35 + min(0.35, int(npc.get("fame_level", 0)) * 0.08)
            if (now_ticks - last_p) >= self.NPC_POST_COOLDOWN_TICKS and random.random() < post_chance:
                is_controversy = random.random() < (0.08 if npc.get("reputation", 55) < 45 else 0.03)
                ptype = "controversial" if is_controversy else "text"
                text, resolved_type = self._sbv.posts.generate_contextual_content(
                    sid,
                    traits=npc.get("traits", []),
                    career=npc.get("career", ""),
                    post_type=ptype,
                )
                post = self._sbv.create_post(sid, text, post_type=resolved_type)
                self._last_post_tick[sid] = now_ticks
                stats["posts"] += 1
                if is_controversy and post:
                    self._sbv.reputation.trigger_controversy_chain(
                        npc, post, all_accounts, self._sbv.posts, self._sbv.followers, now_ticks
                    )

            # 2. NPC likes, comments, and follows
            last_i = self._last_interact_tick.get(sid, -99999)
            if (now_ticks - last_i) >= self.NPC_INTERACT_COOLDOWN_TICKS:
                self._last_interact_tick[sid] = now_ticks
                if recent_posts:
                    target_post = random.choice(recent_posts)
                    author_id = target_post["author_sim_id"]
                    if author_id != sid and not self._sbv.followers.is_blocked(author_id, sid):
                        if random.random() < 0.65:
                            if self._sbv.like_post(sid, target_post["post_id"], is_toggle=False).get("liked"):
                                stats["reactions"] += 1
                        if random.random() < 0.25:
                            comment_pool = [
                                "Love this!",
                                "Iconic energy right here.",
                                "Totally relatable!",
                                "So proud of you!",
                                "Wait, tell us more!",
                            ]
                            self._sbv.add_comment(sid, target_post["post_id"], random.choice(comment_pool))
                            stats["reactions"] += 1

                # Occasional follow of suggested/popular Sim
                if len(all_accounts) > 1 and random.random() < 0.30:
                    target_acc = random.choice(all_accounts)
                    tid = str(target_acc["sim_id"])
                    if tid != sid and not self._sbv.followers.is_following(sid, tid):
                        res = self._sbv.follow_account(sid, tid)
                        if res.get("ok"):
                            stats["follows"] += 1

            # 3. NPC verification progression
            if npc.get("verification_tier", "none") == "none" and random.random() < 0.15:
                elig = self._sbv.get_verification_eligibility(sid)
                if elig.get("eligible"):
                    self._sbv.submit_verification_application(sid, "blue_verified", "Notable community creator.")
                    self._sbv.process_pending_verification(sid, auto_review=True)
                    stats["verifications"] += 1

        # Also process any matured player/NPC pending verification applications
        for app in list(self._sbv.verification.get_pending_applications()):
            delay_ticks = int(self._sbv.verification.config.get("review_delay_hours", 6)) * 60
            if (now_ticks - int(app.get("submission_timestamp", 0))) >= delay_ticks:
                self._sbv.process_pending_verification(app["sim_id"], auto_review=True)
                stats["verifications"] += 1

        self._sbv.persistence.mark_dirty()
        return stats
