import sys, tempfile
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
        self.money -= amount; return amount
class Sim:
    def __init__(self, sid): self.sim_id=sid; self.first_name='Poor'; self.last_name='Sim'; self.is_npc=False; self.household=None
funds=Funds(10)
sims={2:Sim(2)}
def sp(sid): return sims.get(int(sid))
def fp(sid): return funds
now={'v':1000}
tmp=tempfile.mkdtemp()
adapter=VerifiedGameAdapter(sim_provider=sp,now_provider=lambda: now['v'],slot_provider=lambda: 9,funds_provider=fp)
config=load_verified_config(tmp)
p=VerifiedPersistence(tmp)
a=VerifiedAccountService(adapter,p); n=VerifiedNotificationService(adapter,p); b=VerifiedBillingService(adapter,n,config['plan'])
m=VerifiedSubscriptionManager(config,p,adapter,a,n,b); m.ensure_loaded()
res=m.handle_action(2,'subscribe')
print('poor subscribe', res, 'funds', funds.money, 'record', m.get_record(2)['status'], 'benefits', b.benefits_active(m.get_record(2), now['v']))
print('snap', m.build_snapshot(2)['subscription']['status'], m.build_snapshot(2)['permissions'])
# reload persistence
m2=VerifiedSubscriptionManager(config,VerifiedPersistence(tmp),adapter,a,n,b); m2.ensure_loaded(force_slot_id=9)
print('reload record', m2.get_record(2)['status'])
