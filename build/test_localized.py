import sys, types
base = r"C:\Program Files (x86)\Steam\steamapps\common\The Sims 4"
sys.path.append(base + r"\Game\Bin\Python\generated.zip")
sys.path.append(base + r"\Data\Simulation\Gameplay\core.zip")
# stub game-only _trace module
for name in ("_trace",):
    if name not in sys.modules:
        mod = types.ModuleType(name)
        mod.__getattr__ = lambda attr: (lambda *a, **k: None)
        sys.modules[name] = mod
try:
    from protocolbuffers import Localization_pb2
    msg = Localization_pb2.LocalizedString()
    msg.hash = 0x2039BFC9
    tok = msg.tokens.add()
    tok.type = Localization_pb2.LocalizedStringToken.RAW_TEXT
    tok.raw_text = '{"hello":"world"}'
    print("OK", msg.hash, hex(tok.type), tok.raw_text)
    print(msg)
except Exception:
    import traceback; traceback.print_exc()
