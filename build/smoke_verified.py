import sys, tempfile, os
sys.path.insert(0, 'src/python')
from sbv.verified.verified_config import load_verified_config
from sbv.verified.verified_persistence import VerifiedPersistence
from sbv.verified.verified_game_adapter import VerifiedGameAdapter
from sbv.verified.verified_account_service import VerifiedAccountService
from sbv.verified.verified_notification_service import VerifiedNotificationService
from sbv.verified.verified_billing_service import VerifiedBillingService
from sbv.verified.verified_subscription_manager import VerifiedSubscriptionManager

class Funds:
    def __init__(self, money): self.money=money
    def can_afford(self, amount): return self.money >= amount
    def try_remove(self, amount, reason, sim, require_full):
        if self.money < amount: return None
        self.money -= amount
        return amount

class Sim:
    def __init__(self, sid, name): self.sim_id=sid; self.first_name=name; self.last_name='Tester'; self.is_npc=False; self.household=None

money = {'value': 1000}
funds = Funds(money['value'])
def funds_provider(sim_id): return funds
sims = {1: Sim(1,'Alex')}
def sim_provider(sid): return sims.get(int(sid))
now = {'v': 1000}
def now_provider(): return now['v']

tmp = tempfile.mkdtemp()
adapter = VerifiedGameAdapter(sim_provider=sim_provider, now_provider=now_provider, slot_provider=lambda: 7, funds_provider=funds_provider)
config = load_verified_config(tmp)
persistence = VerifiedPersistence(tmp)
inst = VerifiedAccountService(adapter, persistence)
notif = VerifiedNotificationService(adapter, persistence)
billing = VerifiedBillingService(adapter, notif, config['plan'])
manager = VerifiedSubscriptionManager(config, persistence, adapter, inst, notif, billing)
manager.ensure_loaded()
snap = manager.build_snapshot(1)
print('initial', snap['subscription']['status'], snap['permissions'], snap['plan']['price_label'])
res = manager.handle_action(1, 'subscribe')
print('subscribe', res, 'funds', funds.money, 'status', manager.get_record(1)['status'])
snap = manager.build_snapshot(1)
print('after', snap['subscription']['status'], snap['subscription']['next_billing_label'], snap['subscription']['payment_history'])
now['v'] += config['plan']['billing_interval_days'] * 25*60*60*24
funds.money = 1000
res = manager.handle_action(1, 'refresh')
print('renew', res, 'funds', funds.money, 'status', manager.get_record(1)['status'])
now['v'] += config['plan']['billing_interval_days'] * 25*60*60*24
funds.money = 0
res = manager.handle_action(1, 'refresh')
print('fail', res, 'status', manager.get_record(1)['status'], 'grace', manager.get_record(1)['grace_period_end'])
print('snap', manager.build_snapshot(1)['subscription']['status'], manager.build_snapshot(1)['permissions'])
res = manager.handle_action(1, 'cancel')
print('cancel', res, manager.get_record(1)['status'])
print('files', os.listdir(tmp))
