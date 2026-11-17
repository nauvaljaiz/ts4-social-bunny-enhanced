import os, sys, tempfile, types
PROJECT_ROOT=os.path.dirname(os.path.dirname(os.path.abspath('build/smoke_runtime.py')))
ZIP_PATH=os.path.join(os.getcwd(),'dist','SocialBunnyVerified.ts4script')
DATA_HOME=tempfile.mkdtemp(prefix='sbv_runtime_home2_'); os.environ['USERPROFILE']=DATA_HOME; os.environ['HOME']=DATA_HOME
os.makedirs(os.path.join(DATA_HOME,'Documents','Electronic Arts','The Sims 4','Mods'),exist_ok=True)
COMMANDS={}
def _command(name, command_type=None):
    def deco(func): COMMANDS[name]=func; return func
    return deco
class CT: Live='Live'
sims4=types.ModuleType('sims4'); sims4.__path__=[]
commands=types.ModuleType('sims4.commands'); commands.Command=_command; commands.CommandType=CT; commands.output=lambda *a,**k:None
sys.modules['sims4']=sims4; sys.modules['sims4.commands']=commands
sys.path.insert(0,ZIP_PATH)
import sbv.bootstrap
b=sbv.bootstrap.get_verified_bridge()
print('last_error:', repr(b.last_error))
print('commands', COMMANDS)
for root,dirs,files in os.walk(DATA_HOME):
    for f in files:
        print(os.path.join(root,f))
