# -*- coding: utf-8 -*-
"""Central orchestration service for Social Bunny Verified."""

import random
from typing import Any, Callable, Dict, List, Optional

from ..core.account_manager import AccountManager
from ..core.discovery_manager import DiscoveryManager
from ..core.engagement_manager import EngagementManager
from ..core.follower_manager import FollowerManager
from ..core.models import (
    AccountCategory,
    AccountPrivacy,
    AccountStatus,
    ApplicationStatus,
    BrandOfferStatus,
    NotificationType,
    PostType,
    VerificationTier,
)
from ..core.moderation_manager import ModerationManager
from ..core.notification_manager import NotificationManager
from ..core.post_manager import PostManager
from ..core.profile_manager import ProfileManager
from ..core.reputation_manager import ReputationManager
from ..core.verification_manager import VerificationManager
from .analytics_service import AnalyticsService
from .npc_social_service import NPCSocialService
from .persistence_service import PersistenceService

BRAND_CATALOG = [
    {"brand": "Llamacorn Coffee Roasters", "tagline": "Morning fuel for busy Sims", "base_pay": 450},
    {"brand": "Plumbob Tech Labs", "tagline": "Next-gen smart gadgets", "base_pay": 850},
    {"brand": "Starlight Studio Apparel", "tagline": "Red-carpet ready looks", "base_pay": 1200},
    {"brand": "Del Sol Fitness Co.", "tagline": "Train like an icon", "base_pay": 650},
    {"brand": "Britechester Books", "tagline": "Knowledge meets style", "base_pay": 500},
]


class SocialBunnyVerifiedService(object):
    """Singleton facade uniting all Social Bunny Verified managers and services."""

    def __init__(self, data_dir: Optional[str] = None) -> None:
        self.persistence = PersistenceService(data_dir=data_dir)
        self.accounts = AccountManager()
        self.profiles = ProfileManager(self.accounts)
        self.followers = FollowerManager()
        self.posts = PostManager()
        self.engagement = EngagementManager()
        self.verification = VerificationManager()
        self.reputation = ReputationManager()
        self.moderation = ModerationManager()
        self.notifications = NotificationManager()
        self.discovery = DiscoveryManager()
        self.analytics = AnalyticsService(self.engagement, self.posts, self.followers)
        self.npc_service = NPCSocialService(self)

        # Brand collaboration inbox {sim_id: [offer_dict]}
        self._brand_offers: Dict[str, List[Dict[str, Any]]] = {}
        self._next_offer_seq: int = 1
        self._loaded_slot_id: Optional[int] = None
        self._clock_override: Optional[int] = None
        self._explore_offset: Dict[str, int] = {}

        # Optional game environment callbacks (overridden in live runtime or mock tests)
        self.get_sim_metadata_fn: Optional[Callable[[int], Dict[str, Any]]] = None
        self.add_household_funds_fn: Optional[Callable[[int, int], bool]] = None
        self.get_relationship_score_fn: Optional[Callable[[str, str], float]] = None

    def get_now_ticks(self) -> int:
        if self._clock_override is not None:
            return int(self._clock_override)
        try:
            import services
            ts = services.time_service()
            if ts is not None and ts.sim_now is not None:
                return int(ts.sim_now.absolute_ticks() // 1000)
        except Exception:
            pass
        return 1000

    def set_clock_override(self, ticks: Optional[int]) -> None:
        self._clock_override = ticks

    def ensure_loaded(self, force_slot_id: Optional[int] = None) -> None:
        slot_id = int(force_slot_id) if force_slot_id is not None else self.persistence.get_active_slot_id()
        if self._loaded_slot_id == slot_id:
            return
        import os
        slot_file = self.persistence.get_slot_file_path(slot_id)
        if self._loaded_slot_id is None and force_slot_id is None and not os.path.isfile(slot_file) and self.accounts.all_accounts():
            self._loaded_slot_id = slot_id
            return
        payload = self.persistence.load_slot(slot_id)
        self.accounts.load_dict(payload.get("accounts", {}))
        self.followers.load_dict(payload.get("social_graph", {}))
        self.posts.load_dict(payload.get("posts_data", {}))
        self.engagement.load_dict(payload.get("engagement", {}))
        self.verification.load_dict(payload.get("verification", {}))
        self.reputation.load_dict(payload.get("reputation", {}))
        self.moderation.load_dict(payload.get("moderation", {}))
        self.notifications.load_dict(payload.get("notifications", {}))
        brands = payload.get("brands", {})
        self._next_offer_seq = int(brands.get("next_offer_seq", 1))
        self._brand_offers = {}
        for sid, offers in brands.get("offers", {}).items():
            if isinstance(offers, list):
                self._brand_offers[str(sid)] = [dict(o) for o in offers if isinstance(o, dict)][-20:]
        self._loaded_slot_id = slot_id

    def save(self, slot_id: Optional[int] = None) -> bool:
        sid = int(slot_id) if slot_id is not None else (
            self._loaded_slot_id if self._loaded_slot_id is not None else self.persistence.get_active_slot_id()
        )
        payload = {
            "accounts": self.accounts.to_dict(),
            "social_graph": self.followers.to_dict(),
            "posts_data": self.posts.to_dict(),
            "engagement": self.engagement.to_dict(),
            "verification": self.verification.to_dict(),
            "reputation": self.reputation.to_dict(),
            "moderation": self.moderation.to_dict(),
            "notifications": self.notifications.to_dict(),
            "brands": {
                "next_offer_seq": self._next_offer_seq,
                "offers": {k: list(v) for k, v in self._brand_offers.items() if v},
            },
        }
        return self.persistence.save_slot(payload, slot_id=sid)

    def reset_in_memory(self) -> None:
        self._loaded_slot_id = None
        empty = self.persistence.empty_payload()
        self.accounts.load_dict(empty["accounts"])
        self.followers.load_dict(empty["social_graph"])
        self.posts.load_dict(empty["posts_data"])
        self.engagement.load_dict(empty["engagement"])
        self.verification.load_dict(empty["verification"])
        self.reputation.load_dict(empty["reputation"])
        self.moderation.load_dict(empty["moderation"])
        self.notifications.load_dict(empty["notifications"])
        self._brand_offers = {}
        self._next_offer_seq = 1

    # --- Sim Metadata Resolution ---
    def ensure_sim_account(self, sim_id: Any) -> Dict[str, Any]:
        self.ensure_loaded()
        meta = self._resolve_sim_metadata(sim_id)
        acc = self.accounts.ensure_account(
            sim_id=sim_id,
            display_name=meta.get("name", ""),
            now_ticks=self.get_now_ticks(),
            is_npc=meta.get("is_npc"),
            traits=meta.get("traits"),
            career=meta.get("career", ""),
            fame_level=meta.get("fame_level"),
        )
        return acc

    def _resolve_sim_metadata(self, sim_id: Any) -> Dict[str, Any]:
        if self.get_sim_metadata_fn is not None:
            try:
                if str(sim_id).isdigit():
                    return self.get_sim_metadata_fn(int(sim_id)) or {}
            except Exception:
                pass
        try:
            import services
            mgr = services.sim_info_manager()
            if mgr is not None and str(sim_id).isdigit():
                si = mgr.get(int(sim_id))
                if si is not None:
                    full_name = "{} {}".format(getattr(si, "first_name", ""), getattr(si, "last_name", "")).strip()
                    traits = []
                    tt = getattr(si, "trait_tracker", None)
                    if tt is not None:
                        for tr in getattr(tt, "equipped_traits", ()):
                            traits.append(str(getattr(tr, "__name__", tr)))
                    career_name = ""
                    ct = getattr(si, "career_tracker", None)
                    if ct is not None:
                        for c in getattr(ct, "careers", {}).values():
                            career_name = str(getattr(c, "__name__", type(c).__name__))
                            break
                    fame_level = 0
                    try:
                        from fame.fame_tuning import FameTunables
                        fame_stat_type = getattr(
                            FameTunables,
                            "FAME_RANKED_STATISTIC",
                            getattr(FameTunables, "FAME_RANK_STATISTIC", None),
                        )
                        if fame_stat_type is not None:
                            stat = si.get_statistic(fame_stat_type, add=False)
                            if stat is not None:
                                fame_level = int(stat.get_user_value())
                    except Exception:
                        pass
                    return {
                        "name": full_name,
                        "is_npc": bool(getattr(si, "is_npc", False)),
                        "traits": traits[:6],
                        "career": career_name,
                        "fame_level": fame_level,
                    }
        except Exception:
            pass
        return {}

    def _credit_household_simoleons(self, sim_id: Any, amount: int) -> bool:
        if amount <= 0:
            return False
        if self.add_household_funds_fn is not None and str(sim_id).isdigit():
            return bool(self.add_household_funds_fn(int(sim_id), int(amount)))
        try:
            import services
            from protocolbuffers import Consts_pb2
            mgr = services.sim_info_manager()
            if mgr is not None and str(sim_id).isdigit():
                si = mgr.get(int(sim_id))
                if si is not None and getattr(si, "household", None) is not None:
                    si.household.funds.add(int(amount), Consts_pb2.TELEMETRY_MONEY_CHEAT, None)
                    return True
        except Exception:
            pass
        return False

    # --- Actions ---
    def create_post(
        self,
        author_sim_id: Any,
        content: str,
        post_type: str = PostType.TEXT,
        mood_context: str = "",
        game_event: str = "",
        is_sponsored: bool = False,
        brand_name: str = "",
        native_post_id: str = "",
    ) -> Optional[Dict[str, Any]]:
        acc = self.ensure_sim_account(author_sim_id)
        now = self.get_now_ticks()
        self.moderation.refresh_timed_penalties(acc, now)
        if acc.get("status") in (AccountStatus.SUSPENDED, AccountStatus.RESTRICTED):
            return None

        visibility = "followers" if acc.get("privacy") == AccountPrivacy.PRIVATE else "public"
        controversy = 1 if post_type == PostType.CONTROVERSIAL else 0
        post = self.posts.create_post(
            author_sim_id=author_sim_id,
            content=content,
            post_type=post_type,
            now_ticks=now,
            mood_context=mood_context,
            game_event=game_event,
            visibility=visibility,
            is_sponsored=is_sponsored,
            brand_name=brand_name,
            native_post_id=native_post_id,
            controversy_level=controversy,
        )
        # Positive activity reputation nudge
        if post_type in (PostType.ACHIEVEMENT, PostType.MILESTONE):
            self.reputation.adjust_reputation(acc, 1.5, "Shared milestone post", now)
        elif post_type == PostType.CONTROVERSIAL:
            self.reputation.trigger_controversy_chain(
                acc, post, self.accounts.all_accounts(), self.posts, self.followers, now
            )
            self.notifications.push(
                author_sim_id, NotificationType.CONTROVERSY, author_sim_id,
                "Your latest post sparked intense debate across Social Bunny.", now, post["post_id"]
            )
            self._impact_brands_on_controversy(author_sim_id, now)

        self._refresh_daily_snapshot(author_sim_id)
        self.persistence.mark_dirty()
        return post

    def like_post(self, actor_sim_id: Any, post_id: str, is_toggle: bool = True) -> Dict[str, Any]:
        self.ensure_sim_account(actor_sim_id)
        if is_toggle:
            res = self.posts.toggle_like(post_id, actor_sim_id)
        else:
            ok = self.posts.add_like(post_id, actor_sim_id)
            p = self.posts.get_post(post_id)
            res = {"ok": bool(p), "liked": ok, "likes_count": len(p["likes"]) if p else 0, "post": p}

        if res.get("ok") and res.get("liked") and res.get("post"):
            author_id = res["post"]["author_sim_id"]
            if str(author_id) != str(actor_sim_id):
                author = self.ensure_sim_account(author_id)
                actor = self.accounts.get_account(actor_sim_id)
                self.reputation.adjust_reputation(author, 0.2, "Received post like", self.get_now_ticks())
                if author.get("notify_likes", True):
                    self.notifications.push(
                        author_id,
                        NotificationType.LIKE,
                        actor_sim_id,
                        "@{} liked your post.".format(actor["username"] if actor else actor_sim_id),
                        self.get_now_ticks(),
                        post_id,
                    )
            self._refresh_daily_snapshot(author_id)
            self.persistence.mark_dirty()
        return res

    def add_comment(
        self,
        actor_sim_id: Any,
        post_id: str,
        text: str,
        parent_comment_id: str = "",
    ) -> Dict[str, Any]:
        actor = self.ensure_sim_account(actor_sim_id)
        now = self.get_now_ticks()
        self.moderation.refresh_timed_penalties(actor, now)
        if actor.get("status") in (AccountStatus.SUSPENDED, AccountStatus.RESTRICTED):
            return {"ok": False, "error": "Account cannot comment while restricted or suspended."}

        res = self.posts.add_comment(post_id, actor_sim_id, text, now_ticks=now, parent_comment_id=parent_comment_id)
        if res.get("ok") and res.get("post"):
            author_id = res["post"]["author_sim_id"]
            if str(author_id) != str(actor_sim_id):
                author = self.ensure_sim_account(author_id)
                if not self.followers.is_restricted(author_id, actor_sim_id):
                    self.reputation.adjust_reputation(author, 0.4, "Received comment engagement", now)
                    if author.get("notify_comments", True):
                        self.notifications.push(
                            author_id,
                            NotificationType.REPLY if parent_comment_id else NotificationType.COMMENT,
                            actor_sim_id,
                            "@{} commented: {}".format(actor["username"], text[:60]),
                            now,
                            post_id,
                        )
            self._refresh_daily_snapshot(author_id)
            self.persistence.mark_dirty()
        return res

    def follow_account(self, follower_sim_id: Any, target_sim_id: Any) -> Dict[str, Any]:
        f_acc = self.ensure_sim_account(follower_sim_id)
        t_acc = self.ensure_sim_account(target_sim_id)
        now = self.get_now_ticks()
        res = self.followers.follow(follower_sim_id, target_sim_id, t_acc.get("privacy", AccountPrivacy.PUBLIC))
        if res.get("ok"):
            if res["status"] == "following" and t_acc.get("notify_follows", True):
                self.notifications.push(
                    target_sim_id,
                    NotificationType.FOLLOW,
                    follower_sim_id,
                    "@{} started following you.".format(f_acc["username"]),
                    now,
                    str(follower_sim_id),
                )
                self._refresh_daily_snapshot(target_sim_id)
            elif res["status"] == "requested":
                self.notifications.push(
                    target_sim_id,
                    NotificationType.FOLLOW_REQUEST,
                    follower_sim_id,
                    "@{} requested to follow you.".format(f_acc["username"]),
                    now,
                    str(follower_sim_id),
                )
            self.persistence.mark_dirty()
        return res

    def unfollow_account(self, follower_sim_id: Any, target_sim_id: Any) -> bool:
        self.ensure_loaded()
        ok = self.followers.unfollow(follower_sim_id, target_sim_id)
        if ok:
            self._refresh_daily_snapshot(target_sim_id)
            self.persistence.mark_dirty()
        return ok

    def respond_follow_request(self, owner_sim_id: Any, requester_sim_id: Any, approve: bool) -> bool:
        owner = self.ensure_sim_account(owner_sim_id)
        now = self.get_now_ticks()
        if approve:
            ok = self.followers.approve_request(owner_sim_id, requester_sim_id)
            if ok:
                self.notifications.push(
                    requester_sim_id,
                    NotificationType.FOLLOW_ACCEPTED,
                    owner_sim_id,
                    "@{} approved your follow request.".format(owner["username"]),
                    now,
                    str(owner_sim_id),
                )
                self._refresh_daily_snapshot(owner_sim_id)
                self.persistence.mark_dirty()
            return ok
        ok = self.followers.reject_request(owner_sim_id, requester_sim_id)
        if ok:
            self.persistence.mark_dirty()
        return ok

    # --- Verification ---
    def get_verification_eligibility(self, sim_id: Any) -> Dict[str, Any]:
        acc = self.ensure_sim_account(sim_id)
        posts = self.posts.get_posts_by_author(sim_id)
        f_count = self.followers.get_follower_count(sim_id)
        fg_count = self.followers.get_following_count(sim_id)
        summary = self.engagement.summarize_account(sim_id, acc, posts, f_count, fg_count, self.get_now_ticks())
        completeness = self.profiles.compute_profile_completeness(sim_id, len(posts))
        return self.verification.evaluate_eligibility(acc, f_count, posts, summary, completeness, self.get_now_ticks())

    def submit_verification_application(
        self,
        sim_id: Any,
        requested_tier: str = VerificationTier.BLUE_VERIFIED,
        supporting_note: str = "",
    ) -> Dict[str, Any]:
        acc = self.ensure_sim_account(sim_id)
        elig = self.get_verification_eligibility(sim_id)
        res = self.verification.submit_application(acc, requested_tier, supporting_note, elig, self.get_now_ticks())
        if res.get("ok"):
            self.notifications.push(
                sim_id,
                NotificationType.VERIFICATION,
                sim_id,
                "Verification application submitted ({}). Review in progress.".format(
                    VerificationTier.LABELS.get(requested_tier, requested_tier)
                ),
                self.get_now_ticks(),
                res["application"]["application_id"],
            )
            self.persistence.mark_dirty()
        return res

    def process_pending_verification(
        self,
        sim_id: Any,
        auto_review: bool = True,
        manual_decision: Optional[bool] = None,
        custom_reason: str = "",
    ) -> Dict[str, Any]:
        acc = self.ensure_sim_account(sim_id)
        elig = self.get_verification_eligibility(sim_id)
        reviewer = "Automated Eligibility Board" if auto_review and manual_decision is None else "Manual Review"
        res = self.verification.review_application(
            acc,
            elig,
            now_ticks=self.get_now_ticks(),
            manual_decision=manual_decision,
            reviewer=reviewer,
            custom_reason=custom_reason,
        )
        if res.get("ok"):
            approved = res["approved"]
            msg = (
                "Congratulations! Your Social Bunny account is now Verified."
                if approved
                else "Verification request declined: {}".format(res["application"].get("rejection_reason", ""))
            )
            self.notifications.push(
                sim_id,
                NotificationType.VERIFICATION,
                sim_id,
                msg,
                self.get_now_ticks(),
                res["application"]["application_id"],
            )
            self.persistence.mark_dirty()
        return res

    def appeal_verification(self, sim_id: Any, appeal_note: str) -> Dict[str, Any]:
        acc = self.ensure_sim_account(sim_id)
        elig = self.get_verification_eligibility(sim_id)
        res = self.verification.appeal_rejection(acc, appeal_note, elig, self.get_now_ticks())
        if res.get("ok"):
            self.notifications.push(
                sim_id,
                NotificationType.VERIFICATION,
                sim_id,
                "Your verification appeal has been reviewed." if res.get("approved") else "Your verification appeal is under review.",
                self.get_now_ticks(),
            )
            self.persistence.mark_dirty()
        return res

    # --- Brand Collaborations ---
    def generate_brand_offer_if_eligible(self, sim_id: Any) -> Optional[Dict[str, Any]]:
        acc = self.ensure_sim_account(sim_id)
        is_pro = acc.get("category") in (AccountCategory.CREATOR, AccountCategory.PUBLIC_FIGURE, AccountCategory.BUSINESS)
        is_verified = self.accounts.is_verified_blue_or_official(acc)
        f_count = self.followers.get_follower_count(sim_id)
        if not (is_pro or is_verified or f_count >= 5):
            return None
        if float(acc.get("reputation", 50.0)) < 40.0:
            return None

        offers = self._brand_offers.setdefault(str(sim_id), [])
        active_offers = [o for o in offers if o.get("status") in (BrandOfferStatus.OFFERED, BrandOfferStatus.ACCEPTED)]
        if len(active_offers) >= 3:
            return None

        brand = random.choice(BRAND_CATALOG)
        mult = 1.0 + (0.5 if is_verified else 0.0) + min(1.5, f_count * 0.05)
        payout = int(round(brand["base_pay"] * mult))
        oid = "brand_{}".format(self._next_offer_seq)
        self._next_offer_seq += 1
        offer = {
            "offer_id": oid,
            "brand_name": brand["brand"],
            "campaign_brief": brand["tagline"],
            "payout": payout,
            "negotiated": False,
            "status": BrandOfferStatus.OFFERED,
            "created_tick": self.get_now_ticks(),
        }
        offers.insert(0, offer)
        self.notifications.push(
            sim_id,
            NotificationType.BRAND_OFFER,
            sim_id,
            "{} offered you a §{} sponsorship!".format(brand["brand"], payout),
            self.get_now_ticks(),
            oid,
        )
        self.persistence.mark_dirty()
        return offer

    def respond_brand_offer(self, sim_id: Any, offer_id: str, action: str) -> Dict[str, Any]:
        self.ensure_sim_account(sim_id)
        offers = self._brand_offers.get(str(sim_id), [])
        offer = next((o for o in offers if o.get("offer_id") == offer_id), None)
        if offer is None:
            return {"ok": False, "error": "Brand offer not found."}
        if action == "negotiate" and offer["status"] == BrandOfferStatus.OFFERED and not offer.get("negotiated"):
            offer["negotiated"] = True
            acc = self.accounts.get_account(sim_id)
            if float(acc.get("reputation", 50.0)) >= 55.0:
                offer["payout"] = int(round(offer["payout"] * 1.25))
                return {"ok": True, "offer": offer, "message": "Negotiated +25% payout!"}
            return {"ok": True, "offer": offer, "message": "Brand held firm on original rate."}
        if action == "accept" and offer["status"] == BrandOfferStatus.OFFERED:
            offer["status"] = BrandOfferStatus.ACCEPTED
            self.persistence.mark_dirty()
            return {"ok": True, "offer": offer}
        if action == "reject" and offer["status"] == BrandOfferStatus.OFFERED:
            offer["status"] = BrandOfferStatus.REJECTED
            self.persistence.mark_dirty()
            return {"ok": True, "offer": offer}
        if action == "complete" and offer["status"] == BrandOfferStatus.ACCEPTED:
            offer["status"] = BrandOfferStatus.COMPLETED
            self.create_post(
                sim_id,
                "Partnered with {}: {}! #Sponsored #Ad".format(offer["brand_name"], offer["campaign_brief"]),
                post_type=PostType.SPONSORED,
                is_sponsored=True,
                brand_name=offer["brand_name"],
            )
            self._credit_household_simoleons(sim_id, int(offer["payout"]))
            self.persistence.mark_dirty()
            return {"ok": True, "offer": offer, "paid": int(offer["payout"])}
        return {"ok": False, "error": "Invalid offer transition."}

    def _impact_brands_on_controversy(self, sim_id: Any, now_ticks: int) -> None:
        offers = self._brand_offers.get(str(sim_id), [])
        for o in offers:
            if o.get("status") in (BrandOfferStatus.OFFERED, BrandOfferStatus.ACCEPTED):
                o["status"] = BrandOfferStatus.CANCELLED
                self.notifications.push(
                    sim_id,
                    NotificationType.BRAND_OFFER,
                    sim_id,
                    "{} cancelled your sponsorship due to recent controversy.".format(o["brand_name"]),
                    now_ticks,
                    o["offer_id"],
                )

    def get_brand_offers(self, sim_id: Any) -> List[Dict[str, Any]]:
        return list(self._brand_offers.get(str(sim_id), ()))

    # --- Reporting & Moderation ---
    def report_content(
        self,
        reporter_sim_id: Any,
        target_sim_id: Any,
        reason: str,
        target_type: str = "post",
        target_id: str = "",
    ) -> Dict[str, Any]:
        self.ensure_sim_account(reporter_sim_id)
        target_acc = self.ensure_sim_account(target_sim_id)
        now = self.get_now_ticks()
        res = self.moderation.file_report(
            reporter_sim_id=reporter_sim_id,
            target_sim_id=target_sim_id,
            reason=reason,
            target_type=target_type,
            target_id=target_id,
            now_ticks=now,
            target_account=target_acc,
            post_manager=self.posts,
            verification_manager=self.verification,
            reputation_manager=self.reputation,
        )
        if res.get("ok") and res.get("action") != "none":
            self.notifications.push(
                target_sim_id,
                NotificationType.MODERATION,
                reporter_sim_id,
                res.get("details", "Moderation action applied."),
                now,
                res["report"]["report_id"],
            )
            self.persistence.mark_dirty()
        return res

    def _refresh_daily_snapshot(self, sim_id: Any) -> None:
        acc = self.accounts.get_account(sim_id)
        if acc is None:
            return
        now = self.get_now_ticks()
        sim_day = max(1, int(now // (24 * 60)))
        self.engagement.record_daily_snapshot(
            sim_id=sim_id,
            sim_day=sim_day,
            followers=self.followers.get_follower_count(sim_id),
            posts=self.posts.get_posts_by_author(sim_id),
        )

    # --- UI Snapshot Serialization ---
    def build_ui_snapshot(
        self,
        viewer_sim_id: Any,
        feed_filter: str = "for_you",
        period_key: str = "30d",
        profile_sim_id: Optional[str] = None,
        search_query: str = "",
        active_tab: str = "home",
    ) -> Dict[str, Any]:
        """Build complete JSON state snapshot consumed by SocialMedia.gfx."""
        self.ensure_loaded()
        v_key = str(viewer_sim_id)
        viewer_acc = self.ensure_sim_account(v_key)
        now = self.get_now_ticks()
        self.moderation.refresh_timed_penalties(viewer_acc, now)

        target_profile_id = str(profile_sim_id) if profile_sim_id else v_key
        profile_acc = self.ensure_sim_account(target_profile_id)

        # Visible feed posts according to filter
        all_posts = self.posts.get_all_posts()
        following_set = set(self.followers.get_following(v_key))
        feed_posts = []
        for p in all_posts:
            aid = p["author_sim_id"]
            if self.followers.is_blocked(v_key, aid) or self.followers.is_blocked(aid, v_key):
                continue
            if self.followers.is_muted(v_key, aid):
                continue
            if not self.profiles.can_view_private_content(aid, v_key, self.followers):
                continue
            a_acc = self.ensure_sim_account(aid)
            if a_acc.get("status") == AccountStatus.SUSPENDED:
                continue
            if feed_filter == "following" and aid != v_key and aid not in following_set:
                continue
            if feed_filter == "verified" and not self.accounts.is_verified_blue_or_official(a_acc):
                continue
            feed_posts.append(p)

        if feed_filter == "trending":
            feed_posts = self.discovery.get_trending_posts(
                v_key, feed_posts, self.followers, self.accounts, self.profiles, limit=25
            )
        else:
            feed_posts = feed_posts[:30]

        def _serialize_account_brief(acc: Dict[str, Any]) -> Dict[str, Any]:
            sid = str(acc["sim_id"])
            return {
                "sim_id": sid,
                "username": acc["username"],
                "display_name": acc["display_name"],
                "bio": acc.get("bio", ""),
                "category": acc.get("category", AccountCategory.PERSONAL),
                "category_label": AccountCategory.LABELS.get(acc.get("category", "personal"), "Personal"),
                "privacy": acc.get("privacy", AccountPrivacy.PUBLIC),
                "badge": self.accounts.get_effective_badge(acc),
                "verification_tier": acc.get("verification_tier", VerificationTier.NONE),
                "reputation": round(float(acc.get("reputation", 55.0)), 1),
                "standing": self.reputation.get_standing_label(float(acc.get("reputation", 55.0))),
                "status": acc.get("status", AccountStatus.ACTIVE),
                "followers": self.followers.get_follower_count(sid),
                "following": self.followers.get_following_count(sid),
                "posts_count": len(self.posts.get_posts_by_author(sid)),
                "is_following": self.followers.is_following(v_key, sid),
                "is_requested": self.followers.has_pending_request(v_key, sid),
                "is_blocked": self.followers.is_blocked(v_key, sid),
                "is_restricted": self.followers.is_restricted(v_key, sid),
                "is_muted": self.followers.is_muted(v_key, sid),
            }

        def _serialize_post(p: Dict[str, Any]) -> Dict[str, Any]:
            aid = p["author_sim_id"]
            a_acc = self.ensure_sim_account(aid)
            comments_out = []
            for c in p.get("comments", [])[-15:]:
                c_acc = self.ensure_sim_account(c["author_sim_id"])
                comments_out.append({
                    "comment_id": c["comment_id"],
                    "author_sim_id": c["author_sim_id"],
                    "author_name": c_acc["display_name"],
                    "author_username": c_acc["username"],
                    "author_badge": self.accounts.get_effective_badge(c_acc),
                    "text": c["text"],
                    "parent_comment_id": c.get("parent_comment_id", ""),
                    "age_min": max(0, now - int(c.get("created_tick", now))),
                })
            return {
                "post_id": p["post_id"],
                "author_sim_id": aid,
                "author_name": a_acc["display_name"],
                "author_username": a_acc["username"],
                "author_badge": self.accounts.get_effective_badge(a_acc),
                "author_category": a_acc.get("category", "personal"),
                "content": p["content"],
                "post_type": p["post_type"],
                "age_min": max(0, now - int(p.get("created_tick", now))),
                "likes": len(p.get("likes", ())),
                "liked_by_me": v_key in p.get("likes", ()),
                "comments_count": len(p.get("comments", ())),
                "comments": comments_out,
                "reposts": len(p.get("reposts", ())),
                "reposted_by_me": v_key in p.get("reposts", ()),
                "saved_by_me": v_key in p.get("saves", ()),
                "impressions": int(p.get("impressions", 1)),
                "reach": len(p.get("reach", ())),
                "is_sponsored": bool(p.get("is_sponsored", False)),
                "brand_name": p.get("brand_name", ""),
                "controversy_level": int(p.get("controversy_level", 0)),
            }

        # Search & Explore
        all_accs = self.accounts.all_accounts()
        search_results = []
        q = (search_query or "").strip().lower()
        if q:
            for acc in all_accs:
                if acc["sim_id"] == v_key and len(all_accs) > 1:
                    continue
                if q in acc["username"].lower() or q in acc["display_name"].lower() or q in acc.get("bio", "").lower():
                    search_results.append(_serialize_account_brief(acc))
            search_results = search_results[:20]

        suggested = self.discovery.recommend_accounts(
            v_key,
            all_accs,
            self.followers,
            self.posts,
            relationship_score_fn=self.get_relationship_score_fn,
            limit=10,
            rotate_offset=self._explore_offset.get(v_key, 0),
        )

        # Viewed profile posts & privacy guard
        can_view_profile = self.profiles.can_view_private_content(target_profile_id, v_key, self.followers)
        profile_posts = []
        if can_view_profile:
            profile_posts = [_serialize_post(p) for p in self.posts.get_posts_by_author(target_profile_id)[:20]]

        # Verification + Dashboard for viewer
        elig = self.get_verification_eligibility(v_key)
        latest_app = self.verification.get_latest_application(v_key)
        dashboard = self.analytics.build_dashboard(v_key, viewer_acc, period_key=period_key, now_ticks=now)
        notifs = []
        for n in self.notifications.get_for_sim(v_key)[:25]:
            actor_acc = self.ensure_sim_account(n["actor_sim_id"])
            notifs.append({
                "id": n["id"],
                "type": n["type"],
                "actor_sim_id": n["actor_sim_id"],
                "actor_username": actor_acc["username"],
                "actor_badge": self.accounts.get_effective_badge(actor_acc),
                "message": n["message"],
                "read": bool(n.get("read", False)),
                "age_min": max(0, now - int(n.get("tick", now))),
            })

        pending_reqs = [
            _serialize_account_brief(self.ensure_sim_account(rid))
            for rid in self.followers.get_pending_requests(v_key)
        ]

        # Build badge map only for Sims referenced in this snapshot (keeps payload compact & fast)
        badges_map = {}
        ref_ids = {v_key, target_profile_id}
        for p in feed_posts:
            ref_ids.add(str(p["author_sim_id"]))
        for a in suggested:
            ref_ids.add(str(a["sim_id"]))
        for rsid in ref_ids:
            acc_r = self.accounts.get_account(rsid)
            if acc_r is not None:
                badges_map[rsid] = {
                    "badge": self.accounts.get_effective_badge(acc_r),
                    "username": acc_r["username"],
                    "display_name": acc_r["display_name"],
                }

        # Scope heavy lists to active tab while keeping small core summaries always present
        include_feed = active_tab == "home"
        include_explore = active_tab == "explore"
        include_notifs = active_tab == "notifications"
        include_profile = active_tab == "profile"
        include_dash = active_tab == "dashboard"
        include_verify = active_tab == "verify"
        include_settings = active_tab == "settings"

        return {
            "version": 1,
            "active_tab": active_tab,
            "feed_filter": feed_filter,
            "now_ticks": now,
            "viewer": _serialize_account_brief(viewer_acc),
            "viewer_prefs": {
                "notify_likes": bool(viewer_acc.get("notify_likes", True)),
                "notify_comments": bool(viewer_acc.get("notify_comments", True)),
                "notify_follows": bool(viewer_acc.get("notify_follows", True)),
            } if include_settings else {},
            "profile": {
                "account": _serialize_account_brief(profile_acc),
                "can_view": can_view_profile,
                "is_own": target_profile_id == v_key,
                "posts": profile_posts if include_profile else [],
                "followers_list": [_serialize_account_brief(self.ensure_sim_account(fid)) for fid in self.followers.get_followers(target_profile_id)[:20]] if include_profile else [],
                "following_list": [_serialize_account_brief(self.ensure_sim_account(fid)) for fid in self.followers.get_following(target_profile_id)[:20]] if include_profile else [],
            },
            "feed": [_serialize_post(p) for p in feed_posts[:18]] if include_feed else [],
            "explore": {
                "suggested": [_serialize_account_brief(a) for a in suggested] if include_explore else [],
                "search_results": search_results if include_explore else [],
                "search_query": search_query,
                "trending_hashtags": self.discovery.get_trending_hashtags(all_posts, limit=8) if include_explore else [],
                "trending_posts": [
                    _serialize_post(p)
                    for p in self.discovery.get_trending_posts(v_key, all_posts, self.followers, self.accounts, self.profiles, limit=6)
                ] if include_explore else [],
            },
            "notifications": {
                "unread": self.notifications.get_unread_count(v_key),
                "items": notifs if include_notifs else [],
                "follow_requests": pending_reqs if include_notifs else [],
            },
            "verification": {
                "eligibility": elig if include_verify else {},
                "application": latest_app if include_verify else None,
                "history": self.verification.get_history(v_key)[-6:] if include_verify else [],
            },
            "dashboard": dashboard if include_dash else {},
            "brand_offers": self.get_brand_offers(v_key) if include_dash else [],
            "moderation": {
                "history": self.moderation.get_account_history(v_key) if include_settings else [],
                "blocked": [_serialize_account_brief(self.ensure_sim_account(bid)) for bid in self.followers.get_blocked(v_key)] if include_settings else [],
                "restricted": [_serialize_account_brief(self.ensure_sim_account(rid)) for rid in self.followers.get_restricted(v_key)] if include_settings else [],
            },
            "badges_map": badges_map,
        }


_SERVICE_INSTANCE: Optional[SocialBunnyVerifiedService] = None


def get_sbv_service() -> SocialBunnyVerifiedService:
    global _SERVICE_INSTANCE
    if _SERVICE_INSTANCE is None:
        _SERVICE_INSTANCE = SocialBunnyVerifiedService()
    return _SERVICE_INSTANCE
