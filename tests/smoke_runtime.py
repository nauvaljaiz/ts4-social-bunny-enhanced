# -*- coding: utf-8 -*-
"""Simulated TS4 runtime smoke test for the packaged .ts4script.

This does not launch the game. It injects minimal fake game modules so the
bootstrap, bridge, command registration, and state-packet flow can be exercised
under Python 3.7.
"""

import json
import os
import sys
import tempfile
import types
import zipfile

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZIP_PATH = os.path.join(PROJECT_ROOT, "dist", "SocialBunnyVerified.ts4script")
DATA_HOME = tempfile.mkdtemp(prefix="sbv_runtime_home_")
os.environ["USERPROFILE"] = DATA_HOME
os.environ["HOME"] = DATA_HOME
os.makedirs(os.path.join(DATA_HOME, "Documents", "Electronic Arts", "The Sims 4", "Mods"), exist_ok=True)


class FakeFunds(object):
    money = 1000

    def can_afford(self, amount):
        return self.money >= amount

    def try_remove(self, amount, reason, sim, require_full_amount):
        if self.money < amount:
            return None
        self.money -= amount
        return amount


class FakeHousehold(object):
    funds = FakeFunds()


class FakeSimInfo(object):
    sim_id = 101
    first_name = "Alex"
    last_name = "Tester"
    is_npc = False
    household = FakeHousehold()


class FakeNow(object):
    def absolute_ticks(self):
        return 1000000


class FakeTimeService(object):
    sim_now = FakeNow()


class FakeSimInfoManager(object):
    def get(self, sim_id):
        return FakeSimInfo() if int(sim_id) == 101 else None

    def get_all(self):
        return [FakeSimInfo()]


class FakeSlotProto(object):
    slot_id = 7


class FakePersistenceService(object):
    def get_save_slot_proto_buff(self):
        return FakeSlotProto()


class FakeLoc(object):
    def __init__(self, text):
        self.text = text

    def __str__(self):
        return self.text


class FakeLocalizationHelperTuning(object):
    @staticmethod
    def get_raw_text(text):
        return FakeLoc(text)


class FakeSocialMediaService(object):
    def __init__(self):
        self.posts = []
        self.messages = []
        self.followers = 12

    def show_social_media_dialog(self, sim_id, is_update=False):
        return {"sim_id": sim_id, "is_update": is_update}

    def get_posts_for_sim(self, sim_id):
        return list(self.posts)

    def get_dms_for_sim(self, sim_id):
        return list(self.messages)

    def get_current_followers_count(self, sim_id):
        return self.followers

    def get_sim_has_new_posts(self, sim_id):
        return False

    def get_sim_has_new_messages(self, sim_id):
        return False

    def _get_sim_can_make_context_post(self, sim_id):
        return True

    def get_sim_can_add_new_contacts(self, sim_id):
        return True


class FakeShowSocialMediaPanel(object):
    last_op = None

    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs
        FakeShowSocialMediaPanel.last_op = self


class FakeDistributor(object):
    added = []

    @classmethod
    def instance(cls):
        return cls()

    def add_op_with_no_owner(self, op):
        self.added.append(op)


COMMANDS = {}


def _command(name, command_type=None):
    def decorator(func):
        COMMANDS[name] = func
        return func

    return decorator


class _CommandType(object):
    Live = "Live"


def _install_fake_modules():
    services = types.ModuleType("services")
    service = FakeSocialMediaService()
    services.get_social_media_service = lambda: service
    services.time_service = lambda: FakeTimeService()
    services.sim_info_manager = lambda: FakeSimInfoManager()
    services.get_persistence_service = lambda: FakePersistenceService()
    services.active_sim_info = lambda: FakeSimInfo()
    sys.modules["services"] = services

    sims4 = types.ModuleType("sims4")
    sims4.__path__ = []
    commands = types.ModuleType("sims4.commands")
    commands.Command = _command
    commands.CommandType = _CommandType
    commands.output = lambda message, connection=None: None
    sims4.commands = commands
    sys.modules["sims4"] = sims4
    sys.modules["sims4.commands"] = commands

    localization = types.ModuleType("sims4.localization")
    localization.LocalizationHelperTuning = FakeLocalizationHelperTuning
    sys.modules["sims4.localization"] = localization

    social_media = types.ModuleType("social_media")
    social_media.__path__ = []
    sms = types.ModuleType("social_media.social_media_service")
    sms.SocialMediaService = FakeSocialMediaService
    sys.modules["social_media"] = social_media
    sys.modules["social_media.social_media_service"] = sms

    distributor = types.ModuleType("distributor")
    distributor.__path__ = []
    ops = types.ModuleType("distributor.ops")
    ops.ShowSocialMediaPanel = FakeShowSocialMediaPanel
    system = types.ModuleType("distributor.system")
    system.Distributor = FakeDistributor
    sys.modules["distributor"] = distributor
    sys.modules["distributor.ops"] = ops
    sys.modules["distributor.system"] = system

    return service


def main():
    service = _install_fake_modules()
    sys.path.insert(0, ZIP_PATH)
    import sbv.bootstrap  # executes initialize_mod()

    print("bootstrap imported")
    print("commands:", sorted(COMMANDS.keys()))
    print("patched:", FakeSocialMediaService.show_social_media_dialog.__module__)

    service.show_social_media_dialog(101, is_update=False)
    op = FakeShowSocialMediaPanel.last_op
    assert op is not None, "ShowSocialMediaPanel was not created"
    print("op args:", len(op.args), "kwargs:", sorted(op.kwargs.keys()))
    feed = op.args[2]
    assert feed, "feed is empty"
    state_packets = [item for item in feed if int(getattr(item, "post_id", 0)) >= 9000000]
    assert state_packets, "state packet missing"
    payload = "".join(packet.post_text.text for packet in state_packets)
    state = json.loads(payload)
    print("state kind:", state.get("kind"), "status:", state.get("subscription", {}).get("status"))
    assert state.get("kind") == "social_bunny_verified"
    assert state.get("subscription", {}).get("status") == "eligible"

    cmd = COMMANDS["sbv.verified"]
    cmd("101", "subscribe", "%.", "%.", _connection=None)
    record = sbv.bootstrap.get_verified_manager().get_record(101)
    print("subscribed status:", record["status"], "funds:", FakeHousehold.funds.money)
    assert record["status"] == "active"
    assert FakeHousehold.funds.money == 750

    print("runtime smoke test OK")


if __name__ == "__main__":
    main()
