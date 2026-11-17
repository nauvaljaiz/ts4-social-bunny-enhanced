# -*- coding: utf-8 -*-
"""
Verified Scaleform <-> Python communication bridge for Social Bunny Verified.

Outbound (Python -> SocialMedia.gfx):
  Hooks SocialMediaService.show_social_media_dialog so every open/update of the
  native Social Bunny panel preserves all native posts/DMs (post_type 0..4) and
  appends chunked JSON state packets (post_type >= 100) using LocalizedString
  raw_text tokens (0x2039BFC9).

Inbound (SocialMedia.gfx -> Python):
  Registers @sims4.commands.Command('sbv.action', command_type=CommandType.Live)
  called via CommunicationManager.PostServerCommand("sbv.action", sim_id, action, ...).
"""

import json
import os
import traceback
import urllib.parse
from typing import Any, Dict, List

from ..core.models import (
    PACKET_TYPE_CORE_STATE,
    RAW_TEXT_STBL_HASH,
)
from ..services.social_bunny_service import get_sbv_service

CHUNK_SIZE = 3200


class _GameTicks(int):
    """Integer timestamp compatible with both uint64 protobuf fields and DateAndTime.absolute_ticks()."""

    def absolute_ticks(self) -> int:
        return int(self)


class _StatePacketPost(object):
    """Duck-typed SocialMediaPost-compatible carrier for ShowSocialMediaPanel."""

    def __init__(
        self,
        post_id: int,
        author_sim_id: int,
        target_sim_id: int,
        post_type: int,
        ticks: int,
        post_text: Any,
    ) -> None:
        self.post_id = int(post_id)
        self.author_sim_id = int(author_sim_id)
        self.target_sim_id = int(target_sim_id)
        self.post_type = int(post_type)
        self.post_time = _GameTicks(ticks)
        self.post_text = post_text
        self.reactions = []


def log_runtime(message: str) -> None:
    """Append a concise diagnostic line to SocialBunnyVerified_Data/sbv_runtime.log."""
    try:
        sbv = get_sbv_service()
        log_path = os.path.join(sbv.persistence._data_dir, "sbv_runtime.log")
        with open(log_path, "a", encoding="utf-8") as f:
            f.write(str(message) + "\n")
    except Exception:
        pass


def make_raw_localized_string(text: str) -> Any:
    """Create a Localization_pb2.LocalizedString holding raw UTF-8 text."""
    try:
        from sims4.localization import LocalizationHelperTuning
        return LocalizationHelperTuning.get_raw_text(str(text))
    except Exception:
        pass
    from protocolbuffers import Localization_pb2
    msg = Localization_pb2.LocalizedString()
    msg.hash = RAW_TEXT_STBL_HASH
    tok = msg.tokens.add()
    tok.type = Localization_pb2.LocalizedStringToken.RAW_TEXT
    tok.raw_text = str(text)
    return msg


def encode_snapshot_to_packets(sim_id: int, snapshot: Dict[str, Any], now_ticks: int = 0) -> List[_StatePacketPost]:
    """Serialize UI snapshot JSON into chunked _StatePacketPost objects (post_type=100)."""
    raw_json = json.dumps(snapshot, ensure_ascii=False, separators=(",", ":"))
    chunks = [raw_json[i : i + CHUNK_SIZE] for i in range(0, len(raw_json), CHUNK_SIZE)] or ["{}"]
    total = len(chunks)
    # Use sim_now when inside TS4 so DateAndTime matches native posts
    post_time_val = int(now_ticks) * 1000
    try:
        import services
        ts = services.time_service()
        if ts is not None and ts.sim_now is not None:
            post_time_val = int(ts.sim_now)
    except Exception:
        pass

    packets: List[_StatePacketPost] = []
    for idx, chunk in enumerate(chunks):
        loc_str = make_raw_localized_string(chunk)
        packets.append(
            _StatePacketPost(
                post_id=9000000 + idx,
                author_sim_id=int(sim_id) if str(sim_id).isdigit() else 0,
                target_sim_id=total,
                post_type=PACKET_TYPE_CORE_STATE,
                ticks=post_time_val,
                post_text=loc_str,
            )
        )
    return packets


class UIBridgeSessionState(object):
    """Per-Sim UI view state (active tab, feed filter, profile target, search query)."""

    def __init__(self) -> None:
        self._state: Dict[str, Dict[str, str]] = {}

    def get(self, sim_id: Any) -> Dict[str, str]:
        return self._state.setdefault(
            str(sim_id),
            {
                "active_tab": "home",
                "feed_filter": "for_you",
                "period": "30d",
                "profile_sim_id": str(sim_id),
                "search_query": "",
            },
        )


_UI_SESSION = UIBridgeSessionState()
_ORIGINAL_SHOW_DIALOG = None
_INSTALLED = False
_WORLD_NPCS_SEEDED = False


def reset_world_seed_flag() -> None:
    global _WORLD_NPCS_SEEDED
    _WORLD_NPCS_SEEDED = False


def get_ui_session() -> UIBridgeSessionState:
    return _UI_SESSION


def _seed_world_npcs_if_needed() -> None:
    global _WORLD_NPCS_SEEDED
    if _WORLD_NPCS_SEEDED:
        return
    _WORLD_NPCS_SEEDED = True
    sbv = get_sbv_service()
    try:
        import services
        mgr = services.sim_info_manager()
        if mgr is None:
            return
        fame_stat = None
        try:
            from fame.fame_tuning import FameTunables
            fame_stat = getattr(
                FameTunables,
                "FAME_RANKED_STATISTIC",
                getattr(FameTunables, "FAME_RANK_STATISTIC", None),
            )
        except Exception:
            fame_stat = None

        records = []
        for si in mgr.get_all():
            if not getattr(si, "is_npc", False):
                continue
            if getattr(si, "is_baby", False) or getattr(si, "is_toddler", False):
                continue
            full_name = "{} {}".format(getattr(si, "first_name", ""), getattr(si, "last_name", "")).strip()
            if not full_name:
                continue
            fame_level = 0
            if fame_stat is not None:
                try:
                    stat = si.get_statistic(fame_stat, add=False)
                    if stat is not None:
                        fame_level = int(stat.get_user_value())
                except Exception:
                    pass
            records.append({
                "sim_id": si.sim_id,
                "name": full_name,
                "fame_level": fame_level,
            })
            if len(records) >= 24:
                break
        if records:
            sbv.npc_service.seed_world_npcs(records, now_ticks=sbv.get_now_ticks())
    except Exception:
        log_runtime("seed_world_npcs error:\n" + traceback.format_exc())


def _sync_native_posts_for_sim(native_posts: List[Any], sim_id: int) -> None:
    """Import native Social Bunny posts into SBV PostManager once (by native_post_id)."""
    sbv = get_sbv_service()
    existing_native = {
        p.get("native_post_id")
        for p in sbv.posts.get_all_posts(include_removed=True)
        if p.get("native_post_id")
    }
    for np_item in native_posts:
        npid = str(getattr(np_item, "post_id", ""))
        if not npid or npid in existing_native:
            continue
        author_id = getattr(np_item, "author_sim_id", sim_id)
        ptype_val = int(getattr(np_item, "post_type", 0))
        if ptype_val in (2, 3):
            continue
        sbv.ensure_sim_account(author_id)
        sbv.posts.create_post(
            author_sim_id=author_id,
            content="Shared an update on Social Bunny! #SocialBunny",
            post_type="text",
            now_ticks=sbv.get_now_ticks(),
            native_post_id=npid,
        )
        existing_native.add(npid)


def push_ui_update(sim_id: Any, is_update: bool = True) -> None:
    """Refresh the open Social Bunny panel for sim_id with latest SBV state."""
    try:
        import services
        sm = services.get_social_media_service()
        if sm is not None:
            sm.show_social_media_dialog(int(sim_id), is_update=is_update)
    except Exception:
        log_runtime("push_ui_update error:\n" + traceback.format_exc())


def _decode_arg(raw: str) -> str:
    if not raw or raw == "%.":
        return ""
    return urllib.parse.unquote(raw)


def handle_sbv_action(sim_id_str: str, action: str, arg1: str = "", arg2: str = "", arg3: str = "") -> Dict[str, Any]:
    """Process an action invoked from SocialMedia.gfx and return result dict."""
    sbv = get_sbv_service()
    sbv.ensure_loaded()
    sim_id = str(sim_id_str).strip()
    sess = _UI_SESSION.get(sim_id)
    a1 = _decode_arg(arg1 or "")
    a2 = _decode_arg(arg2 or "")
    a3 = _decode_arg(arg3 or "")

    res: Dict[str, Any] = {"ok": True, "action": action}

    if action == "poc_ping":
        sbv.ensure_sim_account(sim_id)
        res["msg"] = "pong"
    elif action == "set_tab":
        sess["active_tab"] = a1 or "home"
        if a1 == "notifications":
            sbv.notifications.mark_all_read(sim_id)
        if a1 == "profile" and a2:
            sess["profile_sim_id"] = a2
            sbv.profiles.record_profile_visit(a2, sim_id)
    elif action == "open_profile":
        target_id = a1 or sim_id
        sess["active_tab"] = "profile"
        sess["profile_sim_id"] = target_id
        sbv.profiles.record_profile_visit(target_id, sim_id)
    elif action == "set_filter":
        sess["feed_filter"] = a1 or "for_you"
        sess["active_tab"] = "home"
    elif action == "set_period":
        sess["period"] = a1 or "30d"
        sess["active_tab"] = "dashboard"
    elif action == "search":
        sess["search_query"] = a1
        sess["active_tab"] = "explore"
    elif action == "refresh_explore":
        sbv._explore_offset[sim_id] = sbv._explore_offset.get(sim_id, 0) + 3
        sess["active_tab"] = "explore"
    elif action == "create_post":
        ptype = a2 or "text"
        post = sbv.create_post(sim_id, a1, post_type=ptype)
        res["ok"] = post is not None
        if post:
            res["post_id"] = post["post_id"]
    elif action == "like_post":
        res = sbv.like_post(sim_id, a1, is_toggle=True)
    elif action == "repost":
        res = sbv.posts.toggle_repost(a1, sim_id)
    elif action == "save_post":
        res = sbv.posts.toggle_save(a1, sim_id)
    elif action == "comment":
        res = sbv.add_comment(sim_id, a1, a2, parent_comment_id=a3)
    elif action == "delete_post":
        res["ok"] = sbv.posts.delete_post(a1, sim_id)
    elif action == "delete_comment":
        res["ok"] = sbv.posts.delete_comment(a1, a2, sim_id)
    elif action == "follow":
        res = sbv.follow_account(sim_id, a1)
    elif action == "unfollow":
        res["ok"] = sbv.unfollow_account(sim_id, a1)
    elif action == "approve_request":
        res["ok"] = sbv.respond_follow_request(sim_id, a1, approve=True)
    elif action == "reject_request":
        res["ok"] = sbv.respond_follow_request(sim_id, a1, approve=False)
    elif action == "remove_follower":
        res["ok"] = sbv.followers.remove_follower(sim_id, a1)
    elif action == "block":
        res["ok"] = sbv.followers.block(sim_id, a1)
    elif action == "unblock":
        res["ok"] = sbv.followers.unblock(sim_id, a1)
    elif action == "restrict":
        res["restricted"] = sbv.followers.toggle_restrict(sim_id, a1)
    elif action == "mute":
        res["muted"] = sbv.followers.toggle_mute(sim_id, a1)
    elif action == "update_bio":
        res = sbv.profiles.update_bio(sim_id, a1)
    elif action == "change_username":
        res = sbv.accounts.change_username(sim_id, a1)
    elif action == "set_category":
        res = sbv.accounts.set_category(sim_id, a1)
    elif action == "set_privacy":
        res = sbv.accounts.set_privacy(sim_id, a1)
    elif action == "set_notify_prefs":
        val = a2 in ("1", "true", "True")
        if a1 == "likes":
            sbv.accounts.update_notification_prefs(sim_id, notify_likes=val)
        elif a1 == "comments":
            sbv.accounts.update_notification_prefs(sim_id, notify_comments=val)
        elif a1 == "follows":
            sbv.accounts.update_notification_prefs(sim_id, notify_follows=val)
    elif action == "apply_verification":
        res = sbv.submit_verification_application(sim_id, requested_tier=a1 or "blue_verified", supporting_note=a2)
        if res.get("ok") and a3 == "instant":
            res = sbv.process_pending_verification(sim_id, auto_review=True)
    elif action == "review_verification":
        res = sbv.process_pending_verification(sim_id, auto_review=True)
    elif action == "appeal_verification":
        res = sbv.appeal_verification(sim_id, a1)
    elif action == "report":
        res = sbv.report_content(sim_id, a1, reason=a2 or "spam", target_type="post", target_id=a3)
    elif action == "request_brand_offer":
        offer = sbv.generate_brand_offer_if_eligible(sim_id)
        res["ok"] = offer is not None
    elif action == "brand_action":
        res = sbv.respond_brand_offer(sim_id, a1, a2)
    elif action == "mark_notifications_read":
        sbv.notifications.mark_all_read(sim_id)
    elif action == "npc_step":
        res["stats"] = sbv.npc_service.run_batch(max_npcs=4)

    sbv.persistence.mark_dirty()
    if action not in ("set_tab", "set_filter", "set_period", "search", "refresh_explore") and sbv._loaded_slot_id is not None:
        sbv.save()
    return res


def install_ui_bridge() -> None:
    """Wrap SocialMediaService.show_social_media_dialog and register live commands."""
    global _ORIGINAL_SHOW_DIALOG, _INSTALLED
    if _INSTALLED:
        return

    try:
        from distributor.ops import ShowSocialMediaPanel
        from distributor.system import Distributor
        from social_media.social_media_service import SocialMediaService

        _ORIGINAL_SHOW_DIALOG = SocialMediaService.show_social_media_dialog

        def _sbv_show_social_media_dialog(self, sim_id, is_update=False):
            try:
                sbv = get_sbv_service()
                sbv.ensure_loaded()
                _seed_world_npcs_if_needed()
                sbv.ensure_sim_account(sim_id)

                feed_items = list(self.get_posts_for_sim(sim_id))
                _sync_native_posts_for_sim(feed_items, sim_id)
                native_followers = int(self.get_current_followers_count(sim_id))
                sbv_followers = int(sbv.followers.get_follower_count(sim_id))
                followers_count = max(native_followers, sbv_followers)

                messages_items = self.get_dms_for_sim(sim_id)
                has_new_posts = self.get_sim_has_new_posts(sim_id)
                has_new_messages = self.get_sim_has_new_messages(sim_id)
                can_make_context_post = self._get_sim_can_make_context_post(sim_id)
                can_add_new_contacts = self.get_sim_can_add_new_contacts(sim_id)

                sess = _UI_SESSION.get(sim_id)
                if not is_update:
                    sess["active_tab"] = "home"
                    sess["profile_sim_id"] = str(sim_id)
                snapshot = sbv.build_ui_snapshot(
                    viewer_sim_id=sim_id,
                    feed_filter=sess.get("feed_filter", "for_you"),
                    period_key=sess.get("period", "30d"),
                    profile_sim_id=sess.get("profile_sim_id", str(sim_id)),
                    search_query=sess.get("search_query", ""),
                    active_tab=sess.get("active_tab", "home"),
                )
                packets = encode_snapshot_to_packets(sim_id, snapshot, now_ticks=sbv.get_now_ticks())
                combined_feed = feed_items + packets

                op = ShowSocialMediaPanel(
                    sim_id,
                    followers_count,
                    combined_feed,
                    messages_items,
                    is_update=is_update,
                    has_new_posts=has_new_posts,
                    has_new_messages=has_new_messages,
                    can_make_context_post=can_make_context_post,
                    can_add_new_contacts=can_add_new_contacts,
                )
                Distributor.instance().add_op_with_no_owner(op)
            except Exception:
                log_runtime("show_social_media_dialog fallback:\n" + traceback.format_exc())
                if _ORIGINAL_SHOW_DIALOG is not None:
                    _ORIGINAL_SHOW_DIALOG(self, sim_id, is_update=is_update)

        SocialMediaService.show_social_media_dialog = _sbv_show_social_media_dialog
        log_runtime("UI bridge installed cleanly.")
    except Exception:
        log_runtime("install_ui_bridge error:\n" + traceback.format_exc())

    try:
        import sims4.commands

        @sims4.commands.Command("sbv.action", command_type=sims4.commands.CommandType.Live)
        def _cmd_sbv_action(sim_id: str, action: str, arg1: str = "", arg2: str = "", arg3: str = "", _connection=None):
            try:
                handle_sbv_action(sim_id, action, arg1, arg2, arg3)
                push_ui_update(sim_id, is_update=True)
            except Exception:
                log_runtime("sbv.action error:\n" + traceback.format_exc())

        @sims4.commands.Command("sbv.status", command_type=sims4.commands.CommandType.Live)
        def _cmd_sbv_status(_connection=None):
            sbv = get_sbv_service()
            sbv.ensure_loaded()
            sims4.commands.output(
                "SocialBunnyVerified: accounts={}, posts={}".format(
                    len(sbv.accounts.all_accounts()),
                    len(sbv.posts.get_all_posts()),
                ),
                _connection,
            )

        @sims4.commands.Command("sbv.npc_tick", command_type=sims4.commands.CommandType.Live)
        def _cmd_sbv_npc_tick(_connection=None):
            sbv = get_sbv_service()
            sbv.ensure_loaded()
            stats = sbv.npc_service.run_batch(max_npcs=8)
            sims4.commands.output("SBV NPC batch: {}".format(stats), _connection)

        @sims4.commands.Command("sbv.verify_active", command_type=sims4.commands.CommandType.Live)
        def _cmd_sbv_verify_active(_connection=None):
            import services
            si = services.active_sim_info()
            if si is None:
                return
            sbv = get_sbv_service()
            acc = sbv.ensure_sim_account(si.sim_id)
            acc["verification_tier"] = "blue_verified"
            acc["badge_suspended"] = False
            sbv.save()
            push_ui_update(si.sim_id, is_update=True)
            sims4.commands.output("Verified @{}".format(acc["username"]), _connection)
    except Exception:
        log_runtime("register commands error:\n" + traceback.format_exc())

    _INSTALLED = True
