import os, sys, tempfile, types, zipfile
PROJECT_ROOT=os.getcwd(); ZIP=os.path.join(PROJECT_ROOT,'dist','SocialBunnyVerified.ts4script')
DATA_HOME=tempfile.mkdtemp(prefix='sbv_import_all_'); os.environ['USERPROFILE']=DATA_HOME; os.environ['HOME']=DATA_HOME
os.makedirs(os.path.join(DATA_HOME,'Documents','Electronic Arts','The Sims 4','Mods'),exist_ok=True)
COMMANDS={}
def _command(name, command_type=None):
    def deco(f): COMMANDS[name]=f; return f
    return deco
class CT: Live='Live'
class L:
    @staticmethod
    def get_raw_text(t):
        class X:
            def __init__(self,s): self.text=s
            def __str__(self): return self.text
        return X(t)
sims4=types.ModuleType('sims4'); sims4.__path__=[]
commands=types.ModuleType('sims4.commands'); commands.Command=_command; commands.CommandType=CT; commands.output=lambda *a,**k:None
localization=types.ModuleType('sims4.localization'); localization.LocalizationHelperTuning=L
sims4.commands=commands; sims4.localization=localization
sys.modules['sims4']=sims4; sys.modules['sims4.commands']=commands; sys.modules['sims4.localization']=localization
sys.path.insert(0,ZIP)
zf=zipfile.ZipFile(ZIP)
fail=[]
for name in zf.namelist():
    if not name.endswith('.pyc'): continue
    fqn=name[:-4].replace('/','.')
    if fqn.endswith('.__init__'): fqn=fqn[:-9]
    try:
        __import__(fqn)
    except Exception as e:
        fail.append((fqn,repr(e)))
print('imported modules:', len(zf.namelist()))
print('failures:', fail)
print('commands:', sorted(COMMANDS))
