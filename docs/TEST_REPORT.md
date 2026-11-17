# Test Report — Social Bunny Verified

## 1. Automated Results

Environment:

- The Sims 4 installed at `C:\Program Files (x86)\Steam\steamapps\common\The Sims 4`
- Embedded runtime: Python 3.7
- GFX toolchain: FFDec 26.5.0 / Java 17

Executed:

```powershell
python tools\build_packages.py
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\run_all_tests.py
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\import_all_modules.py
& "C:\Users\nauval jaiz\Documents\the-sims-mods\simstagram\tools\python37\python.exe" tests\smoke_runtime.py
```

Results:

- GFX compiled successfully: 90,439 bytes.
- UI package contains exactly one resource: `62ECC59A:00000000:8ABB350F01880C64`.
- `.ts4script` contains 38 Python 3.7 bytecode modules, magic `3394`.
- 25 unit/integration tests passed, 0 failed.
- Simulated TS4 runtime smoke test passed:
  - all 38 packaged modules imported cleanly through the game-style module importer;
  - `sbv.bootstrap` imported from the packaged `.ts4script`;
  - 4 commands registered;
  - the native `show_social_media_dialog` wrapper emitted a `ShowSocialMediaPanel` op with a Verified state packet;
  - `sbv.verified subscribe` deducted exactly §250 and persisted status `active`.

Coverage added for this feature:

- exact §250 debit and no duplicate subscription;
- insufficient funds with no deduction and no activation;
- successful renewal and payment history;
- renewal failure, grace period, suspension, and benefit pause;
- cancellation with retained benefits, then expiration with preserved data;
- reactivation without a second charge while inside the paid period;
- auto-renew on/off;
- save-slot isolation, reload, `.bak` recovery, and schema migration;
- all nine status labels;
- `Payment Pending` state representation;
- feed priority and native contact priority;
- chunked state packet encode/decode;
- configurable price and interval;
- GFX token validation and package TGI;
- vanilla ActionScript files remain byte-identical to decompiled originals.

## 2. GFX / Resource Verification

- Original GFX located in `Data\Client\UI.package` at the expected TGI.
- The compiled GFX retains `GFX\x0e` header, all four original `ImportAssets2` libraries, the original display list, and the original `SymbolClass` bindings.
- Tokens verified inside the compiled GFX:
  - `btnVerifiedTabButton`
  - `sbv.verified`
  - `Social Bunny Verified`
  - `Confirm Social Bunny Verified`
  - `SocialMediaPanel`
  - `SocialMediaFeedTabPanel`

## 3. In-Game Functional Checklist

The following must be confirmed in a live game session (Scaleform behavior cannot be fully simulated outside the game):

- [ ] Feed opens and behaves as vanilla.
- [ ] Friends opens and behaves as vanilla.
- [ ] Message opens and behaves as vanilla.
- [ ] Original tab hover/selection/controller states still work.
- [ ] A fourth **Verified** tab appears after Message without overlapping.
- [ ] Verified opens inside the Social Bunny panel.
- [ ] Returning to Feed, Friends, and Message works repeatedly with no duplicate panels.
- [ ] Verified opens again after closing and reopening Social Bunny.
- [ ] Subscribe shows the confirmation modal and does not deduct before Confirm.
- [ ] Confirming deducts exactly §250 and activates the subscription.
- [ ] The blue badge appears beside the Sim's Social Bunny name.
- [ ] Cancelling retains benefits until the paid period ends.
- [ ] Disabling auto-renew leaves benefits active until the period ends.
- [ ] Reopening the tab shows the persisted status and payment history.
- [ ] Saving, loading, and household switching preserve the subscription.
- [ ] `sbv.verified_status` reports the loaded save slot.
- [ ] `sbv.verified_tick` processes a billing check.

## 4. Known Limitations

- In-game functional testing is a manual step; automated testing covers the backend, package, and GFX token validation only.
- If another mod overrides the same `SocialMedia` GFX instance, one will win according to load order.
- Billing catch-up charges the current period once after a long absence rather than back-billing every missed period.
