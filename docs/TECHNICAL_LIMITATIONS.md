# Technical Limitations & Engineering Constraints

## 1. Scaleform GFX

- *The Sims 4* uses Autodesk Scaleform GFx 4.x; there is no browser/HTML UI layer.
- Native `SocialMedia.gfx` depends on runtime libraries imported via `ImportAssets2`: `ComponentLibrary.swf`, `gfxfontlib.swf`, `HUDLibrary.swf`, and `GUIComponentLibrary.swf`.
- Recompiling the entire UI from scratch would be brittle and would violate the additive requirement. The build instead edits the original GFX tag stream with FFDec.
- **FFDec `-importScript` compiles each changed script independently and cannot resolve a new class defined in a separate new file.** Therefore the Verified content is implemented inside the existing `SocialMediaPanel.as` and uses existing native classes (`SocialMediaFeedTabPanel`, `PostButton_Tag`, `FriendsTabTextButton`). Only one native ActionScript file is changed.
- No new `SymbolClass` entries or display-list symbols are necessary. The Verified tab is an additional instance of existing native symbols, created at runtime.

## 2. Scaleform State Transport

- `DistributorOps_pb2.SendUIMessage` only carries a message name, so it is not suitable for structured subscription state.
- Verified state travels through the native `ShowSocialMediaPanel` / `SocialMediaDialog.feed_items` channel as packets with a valid `post_type = 0` and a reserved `post_id` range (`9000000 + index`), so the C++ client cannot reject them as an unknown post type.
- `post_text` is a raw `LocalizedString` built directly with the base-game `{0.String}` hash (`0x2039BFC9`) and a `RAW_TEXT` token. Do not use a hash-0 LocKey: the GFX `LocKey.toString()` returns an empty string when `hash == 0`.
- JSON is chunked below 3,000 characters; chunks are keyed by reserved post ID so ordering survives any native list sorting.
- ActionScript has no native `JSON` class in this Scaleform build, so the Verified code includes a small recursive JSON parser.
- ActionScript also falls back to reading the RAW_TEXT token directly if `LocKey.toString()` returns empty or the unresolved `{0.String}` template.

## 3. Inbound Commands

- The verified UI calls `CommunicationManager.PostServerCommand("sbv.verified", ...)`.
- The Python side registers `@sims4.commands.Command("sbv.verified", command_type=CommandType.Live)`.
- Args are URL-encoded by the GFX; the command URL-decodes them. Empty args use the established `%.` sentinel.
- No arbitrary ActionScript-to-Python method calls are assumed.

## 4. Time and Billing

- Billing uses `services.time_service().sim_now.absolute_ticks()` and `date_and_time.sim_ticks_per_day()`.
- The game alarm API schedules an hourly subscription tick. Zone load also runs a catch-up pass.
- If the game is closed, time does not advance for billing; the next load processes the current state once.
- A renewal that becomes due while the player is away charges one current period, not every missed period.

## 5. Persistence

- Native `SocialMediaService` protobuf data cannot store custom subscription fields.
- Subscription data is stored per save slot as JSON under `Mods/SocialBunnyVerified_Data/`.
- Files use atomic replacement and a `.bak` copy.
- Expiration and suspension never delete records or payment history.
- The data directory is a mod-owned folder; it is not an original game file.

## 6. Currency

- Only Simoleons are used.
- The household `Funds` API is queried with `can_afford` and charged with `try_remove(..., require_full_amount=True)`.
- There is no external payment URL, real-money transaction, or network service.

## 7. Testing Limits

- Automated tests cover the Python domain, persistence, configuration, state packet encoding, GFX compilation tokens, and package TGI validation.
- The live game UI must still be exercised with the in-game checklist in `docs/TEST_REPORT.md`; Scaleform runtime behavior depends on the installed game version.
