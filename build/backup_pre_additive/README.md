# Social Bunny Verified — The Sims 4 Native UI & Social Platform Overhaul

**Social Bunny Verified** transforms *The Sims 4* native Social Bunny app (`SocialMedia.gfx`, `62ECC59A:00000000:8ABB350F01880C64`) into a full-featured, Instagram-inspired social media ecosystem while preserving the native phone/computer/tablet entry point and existing Social Bunny features.

## Key Features

- **Native Scaleform GFX Overhaul (`SocialBunnyVerified_UI.package`):**
  - Overrides `SocialMedia` (`0x8ABB350F01880C64`) with a 6-tab navigation bar (`Home`, `Explore`, `Alerts`, `Profile`, `Pro`, `Settings / DMs`).
  - Renders Verified (`#1D9BF0`), Official (`#EBA81C`), Creator (`#8B5CF6`), and Legacy (`#64748B`) badges across headers, feeds, comments, profiles, search results, notifications, and native friend/feed cells.
  - Real AS3 `Graphics` charts on the Professional Dashboard + interactive Comment & Report modal dialogs + native DMs/Contacts/Feed switcher.
- **Persistent Accounts & Social Graph (`SocialBunnyVerified.ts4script`):**
  - Deterministic unique `@username` handles, 5 account categories (`Personal`, `Creator`, `Business`, `Public Figure`, `Official Organization`), `Public` / `Private` accounts, follow requests, mutuals, block/restrict/mute.
- **Authentic Verification Ecosystem:**
  - Multi-factor configurable scoring (`Authenticity`, `Notability`, `Activity`, `Engagement Quality`, `Reputation`, `Profile Quality`) with category thresholds, application workflow, cooldowns, appeals, badge suspension, and revocation.
- **Posts, Engagement Analytics, Discovery, Brand Collaborations & Moderation:**
  - Likes, comments, replies, reposts, saves, deletions, contextual dynamic content, `7d`/`30d`/`90d`/`All` analytics, Explore discovery & trending hashtags, Brand sponsorship offers with Simoleon payouts, reputation & controversy cascades, rule-based reporting/moderation, and alarm-batched NPC automation.
- **Save-Slot Isolated Persistence:**
  - Automatic per-slot JSON persistence with `.bak` recovery and deleted-Sim cleanup.

## Project Layout

- `src/python/sbv/` — Modular Python 3.7 backend (`core/`, `services/`, `ui_bridge/`, `events/`, `interactions/`, `tuning/`, `bootstrap.py`)
- `src/gfx/` — Immutable original GFX (`original/`), FFDec decompiled assets (`decompiled/`), editable AS3 (`scripts/`), badge PNG/DDS assets (`assets/`), compiled GFX (`compiled/`)
- `src/tuning/` — Additive Buff & Loot XML tuning
- `tools/` — DBPF reader/writer (`dbpf.py`), asset encoder (`assets.py`), game audit (`audit_game_resources.py`), and reproducible builder (`build_packages.py`)
- `tests/` — Python 3.7 automated unit, integration, and performance tests (`run_all_tests.py`)
- `docs/` — Reverse engineering inventory, architecture, override plan, limitations, and test report
- `dist/` — Installable deliverables (`SocialBunnyVerified_UI.package`, `SocialBunnyVerified_Core.package`, `SocialBunnyVerified.ts4script`)

## Build & Test

```powershell
python tools\build_packages.py
# Or build and deploy directly to Documents\Electronic Arts\The Sims 4\Mods:
python tools\build_packages.py --deploy
```

Run the Python 3.7 test suite:

```powershell
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\run_all_tests.py
```
