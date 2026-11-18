# -*- coding: utf-8 -*-
"""Native Social Bunny Scaleform bridge for the Verified subscription tab.

Python -> GFX uses the native ShowSocialMediaPanel op and appends chunked JSON
state packets (post_type 100). GFX -> Python uses the verified
CommunicationManager.PostServerCommand command ``sbv.verified``.
"""

import json
import os
import time
import traceback
import urllib.parse

# Use a valid native post type (DEFAULT=0) so the C++ client never drops the
# packet as an unknown enum. State packets are identified by their reserved
# generation-based post_id range and are filtered out of the native feed in ActionScript.
STATE_PACKET_TYPE = 0
STATE_PACKET_ID_BASE = 9000000
STATE_PACKET_ID_STRIDE = 100
STATE_PACKET_MAX_GENERATION = (
    (2147483647 - STATE_PACKET_ID_BASE - (STATE_PACKET_ID_STRIDE - 1))
    // STATE_PACKET_ID_STRIDE
)
CHUNK_SIZE = 3000
_last_state_packet_generation = -1


class _GameTicks(int):
    def absolute_ticks(self):
        return int(self)


class _StatePacketPost(object):
    """Duck-typed SocialMediaPost-compatible state carrier."""

    def __init__(self, post_id, author_sim_id, target_sim_id, post_type, ticks, post_text):
        self.post_id = int(post_id)
        self.author_sim_id = int(author_sim_id)
        self.target_sim_id = int(target_sim_id)
        self.post_type = int(post_type)
        self.post_time = _GameTicks(int(ticks))
        self.post_text = post_text
        self.reactions = []


RAW_TEXT_STBL_HASH = 0x2039BFC9


def _raw_localized_string(text):
    """Build a LocalizedString that GFX LocKey.toString() can actually render.

    LocalizationHelperTuning.get_raw_text() is not reliable here: depending on
    tuning initialization it can produce a LocKey with hash 0, and the GFX
    LocKey implementation returns an empty string when hash == 0. Constructing
    the native {0.String} + RAW_TEXT token explicitly avoids that failure.
    """
    try:
        from protocolbuffers import Localization_pb2

        message = Localization_pb2.LocalizedString()
        message.hash = RAW_TEXT_STBL_HASH
        token = message.tokens.add()
        token.type = Localization_pb2.LocalizedStringToken.RAW_TEXT
        token.raw_text = str(text)
        return message
    except Exception:
        pass
    try:
        from sims4.localization import LocalizationHelperTuning

        return LocalizationHelperTuning.get_raw_text(str(text))
    except Exception:
        raise


def _decode_arg(raw):
    if raw is None or raw == "" or raw == "%.":
        return ""
    try:
        return urllib.parse.unquote(str(raw))
    except Exception:
        return str(raw)


def _sim_id_int(sim_id):
    text = str(sim_id)
    if text.isdigit():
        return int(text)
    try:
        return int(float(text))
    except Exception:
        return 0


def encode_snapshot_to_packets(sim_id, snapshot, now_ticks):
    global _last_state_packet_generation
    raw_json = json.dumps(snapshot, ensure_ascii=False, separators=(",", ":"))
    chunks = [raw_json[index : index + CHUNK_SIZE] for index in range(0, len(raw_json), CHUNK_SIZE)] or ["{}"]
    total = len(chunks)
    if _last_state_packet_generation < 0:
        generation = int(time.time() * 1000) % (STATE_PACKET_MAX_GENERATION + 1)
    else:
        generation = _last_state_packet_generation + 1
        if generation > STATE_PACKET_MAX_GENERATION:
            generation = 0
    _last_state_packet_generation = generation
    packets = []
    for index, chunk in enumerate(chunks):
        packets.append(
            _StatePacketPost(
                post_id=STATE_PACKET_ID_BASE + generation * STATE_PACKET_ID_STRIDE + index,
                author_sim_id=_sim_id_int(sim_id),
                target_sim_id=total,
                post_type=STATE_PACKET_TYPE,
                ticks=int(now_ticks),
                post_text=_raw_localized_string(chunk),
            )
        )
    return packets


class VerifiedUIBridge(object):
    def __init__(self, manager):
        self.manager = manager
        self._installed = False
        self._original_show_dialog = None
        self._last_error = ""

    @property
    def last_error(self):
        return self._last_error

    def log(self, message):
        try:
            path = os.path.join(self.manager.persistence.data_dir, "verified_runtime.log")
            with open(path, "a", encoding="utf-8") as handle:
                handle.write(str(message) + "\n")
        except Exception:
            pass

    def install(self):
        if self._installed:
            return
        self._install_show_dialog_hook()
        self._install_commands()
        self._installed = True
        self.log("Verified UI bridge installed.")

    def _install_show_dialog_hook(self):
        try:
            from social_media.social_media_service import SocialMediaService

            self._original_show_dialog = SocialMediaService.show_social_media_dialog

            def _verified_show_social_media_dialog(service, sim_id, is_update=False):
                try:
                    self.manager.ensure_loaded()
                    self.manager.process_due_all()

                    native_feed = list(service.get_posts_for_sim(sim_id) or [])
                    native_feed = self.manager.prioritize_feed(native_feed, sim_id)
                    messages = list(service.get_dms_for_sim(sim_id) or [])
                    followers_count = int(service.get_current_followers_count(sim_id) or 0)
                    has_new_posts = service.get_sim_has_new_posts(sim_id)
                    has_new_messages = service.get_sim_has_new_messages(sim_id)
                    can_make_context_post = service._get_sim_can_make_context_post(sim_id)
                    can_add_new_contacts = service.get_sim_can_add_new_contacts(sim_id)

                    snapshot = self.manager.build_snapshot(sim_id)
                    packets = encode_snapshot_to_packets(
                        sim_id, snapshot, self.manager.adapter.get_now_ticks()
                    )
                    state_chars = len(
                        json.dumps(snapshot, ensure_ascii=False, separators=(",", ":"))
                    )
                    first_chunk_chars = 0
                    if packets:
                        try:
                            first_chunk_chars = len(packets[0].post_text.tokens[0].raw_text)
                        except Exception:
                            first_chunk_chars = -1
                    self.log(
                        "show sim={} update={} native_feed={} packets={} state_chars={} first_chunk={}".format(
                            sim_id,
                            is_update,
                            len(native_feed),
                            len(packets),
                            state_chars,
                            first_chunk_chars,
                        )
                    )

                    from distributor.ops import ShowSocialMediaPanel
                    from distributor.system import Distributor

                    op = ShowSocialMediaPanel(
                        sim_id,
                        followers_count,
                        packets + native_feed,
                        messages,
                        is_update=is_update,
                        has_new_posts=has_new_posts,
                        has_new_messages=has_new_messages,
                        can_make_context_post=can_make_context_post,
                        can_add_new_contacts=can_add_new_contacts,
                    )
                    Distributor.instance().add_op_with_no_owner(op)
                except Exception:
                    self._last_error = traceback.format_exc()
                    self.log("show_social_media_dialog fallback:\n" + self._last_error)
                    if self._original_show_dialog is not None:
                        return self._original_show_dialog(service, sim_id, is_update=is_update)
                return None

            SocialMediaService.show_social_media_dialog = _verified_show_social_media_dialog
        except Exception:
            self._last_error = traceback.format_exc()
            self.log("install show dialog hook error:\n" + self._last_error)

    def _install_commands(self):
        try:
            import sims4.commands

            @sims4.commands.Command("sbv.verified", command_type=sims4.commands.CommandType.Live)
            def _cmd_verified(sim_id: str, action: str, arg1: str = "%.", arg2: str = "%.", _connection=None):
                try:
                    decoded_action = _decode_arg(action)
                    result = self.manager.handle_action(
                        sim_id,
                        decoded_action,
                        _decode_arg(arg1),
                        _decode_arg(arg2),
                    )
                    self.log(
                        "action sim={} action={} result={}".format(
                            sim_id, decoded_action, result
                        )
                    )
                    self.push_update(sim_id, is_update=True)
                    if result is not None:
                        sims4.commands.output(
                            "SocialBunnyVerified: {} ({})".format(
                                result.get("message", "OK"),
                                result.get("code", "ok"),
                            ),
                            _connection,
                        )
                except Exception:
                    self._last_error = traceback.format_exc()
                    self.log("sbv.verified error:\n" + self._last_error)
                    try:
                        self.push_update(sim_id, is_update=True)
                    except Exception:
                        pass

            @sims4.commands.Command("sbv.verified_status", command_type=sims4.commands.CommandType.Live)
            def _cmd_verified_status(_connection=None):
                try:
                    summary = self.manager.debug_summary()
                    sims4.commands.output("SocialBunnyVerified: {}".format(summary), _connection)
                except Exception:
                    sims4.commands.output("SocialBunnyVerified: status unavailable", _connection)

            @sims4.commands.Command("sbv.verified_tick", command_type=sims4.commands.CommandType.Live)
            def _cmd_verified_tick(_connection=None):
                try:
                    changed = self.manager.process_due_all()
                    sims4.commands.output(
                        "SocialBunnyVerified: processed hourly systems and billing ({} change(s))".format(changed),
                        _connection,
                    )
                except Exception:
                    sims4.commands.output("SocialBunnyVerified: billing tick failed", _connection)

            @sims4.commands.Command("sbv.verified_reload", command_type=sims4.commands.CommandType.Live)
            def _cmd_verified_reload(_connection=None):
                try:
                    from .verified_config import clear_config_cache, load_verified_config
                    clear_config_cache()
                    reloaded = load_verified_config(self.manager.persistence.data_dir)
                    self.manager.config.update(reloaded)
                    self.manager.reload()
                    sims4.commands.output(
                        "SocialBunnyVerified: reloaded slot {}".format(self.manager.loaded_slot_id),
                        _connection,
                    )
                except Exception:
                    sims4.commands.output("SocialBunnyVerified: reload failed", _connection)

            @sims4.commands.Command("sbv.verified_debug_event", command_type=sims4.commands.CommandType.Live)
            def _cmd_verified_debug_event(event: str = "cancel", _connection=None):
                try:
                    event = _decode_arg(event).lower()
                    sim_id = self.manager.adapter.get_active_sim_id()
                    if sim_id is None:
                        raise RuntimeError("No active Sim")
                    sid = str(sim_id)
                    self.manager.ensure_loaded()
                    record = self.manager.get_record(sid)
                    if record is None:
                        record = self.manager._ensure_record(sid, self.manager.adapter.get_now_ticks())
                    now = int(self.manager.adapter.get_now_ticks())
                    if event == "leak":
                        self.manager.dm_engine.apply_leak(record, 0.15, now)
                    elif event == "ratio":
                        self.manager.comment_engine.evaluate_ratio(record, 100, 50, True, now)
                    else:
                        self.manager.audience_engine.trigger(record, "debug")
                    self.manager.save()
                    sims4.commands.output("SocialBunnyVerified: debug event {}".format(event), _connection)
                except Exception as exc:
                    sims4.commands.output("SocialBunnyVerified: debug event failed {}".format(exc), _connection)
        except Exception:
            self._last_error = traceback.format_exc()
            self.log("install commands error:\n" + self._last_error)

    def push_update(self, sim_id, is_update=True):
        try:
            import services
            service = None
            try:
                service = services.get_social_media_service()
            except Exception:
                service = None
            if service is None:
                try:
                    from social_media.social_media_service import SocialMediaService
                    service = SocialMediaService.instance()
                except Exception:
                    service = None
            if service is not None:
                service.show_social_media_dialog(_sim_id_int(sim_id), is_update=is_update)
        except Exception:
            self._last_error = traceback.format_exc()
            self.log("push update error:\n" + self._last_error)
