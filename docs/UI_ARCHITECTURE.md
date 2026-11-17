# UI Architecture — Additive Verified Tab

## 1. Native Navigation

The original Social Bunny navigation has three `TextButton` children positioned side-by-side inside `SocialMediaPanel`. Each is 135 px wide. The panel is 543 px wide, so the original three tabs were centered at x = 69, 204, and 339.

The additive implementation:

1. Instantiates a fourth native `FriendsTabTextButton`.
2. Sets its name to `btnVerifiedTabButton`, label `Verified`, and adds it to the existing `SelectableGroup`.
3. Recenters the group as four 135 px tabs: x = 1.5, 136.5, 271.5, 406.5.
4. Adds `PANEL_MODE_VERIFIED = 3` to the existing tab map and factory.
5. Leaves all existing tab components, skins, fonts, frame states, and relative ordering unchanged.

The tab is created at runtime from the native button class, so it behaves exactly like the original three tabs (hover, down, disabled, selection state, controller tabbing).

## 2. Verified Content

`CreateTabPanel(PANEL_MODE_VERIFIED)` creates a second native `SocialMediaFeedTabPanel` instance (`mcVerifiedPanel`). It is not a rebuilt panel: it is the same native symbol used by the Feed tab, repurposed as the Verified backdrop.

`InitVerifiedChrome()` then hides the native feed ScrollList and empty-state children and adds:

- `mVerifiedMask` — clip rectangle matching the native content panel.
- `mVerifiedCanvas` — scrollable content surface.
- `mVerifiedScrollbar` — mouse-wheel scroll indicator.
- `mVerifiedOverlay` — explicit purchase-confirmation modal.

The screen is drawn with native font classes (`$TextFont`, `$HeadlineFont`) and native `PostButton_Tag` buttons. The verified badge is vector-drawn, so no texture atlas override is needed.

## 3. Native Feed Preservation

The native `SocialMediaDialog.feed_items` array is split before use:

- Feed items **outside** the reserved `post_id` range `9000000–9000099` → passed unchanged to the native Feed panel.
- Feed items **inside** that range → Verified state JSON chunks, reassembled by post ID and parsed by a small ActionScript JSON parser. The packet uses valid `post_type = 0`, so the client never rejects an unknown enum.
- The raw JSON is carried by a `{0.String}` LocalizedString (`0x2039BFC9`) with a RAW_TEXT token; GFX also falls back to reading the token directly if localization lookup returns empty.

`SocialMediaPanel` stores the native subset in `mNativeFeedItems`; all Feed, Friends, Message, and friends-ID updates use that native subset. Raw state packets are never rendered as posts.

## 4. UI → Python Flow

Every Verified control follows this path:

```
Native PostButton_Tag click
  → SocialMediaPanel.OnVerifiedButtonClick()
  → CommunicationManager.PostServerCommand("sbv.verified", simId, action, arg1, arg2)
  → Python @sims4.commands.Command("sbv.verified")
  → VerifiedSubscriptionManager.handle_action()
  → billing / persistence
  → show_social_media_dialog(..., is_update=True)
  → native ShowSocialMediaPanel op + state packet
  → SocialMediaMain.HandleUpdateSocialMedia()
  → SocialMediaPanel.UpdateData()
  → verified screen refresh
```

Supported actions:

- `subscribe` (only after the UI confirmation overlay)
- `cancel`
- `reactivate`
- `retry_payment`
- `set_auto_renew` (`1` / `0`)
- `refresh`

The backend returns a `last_result` object in the next state packet. Errors are displayed in the screen banner; the UI never reports success when the operation failed.

## 5. Verified Screen Layout

The screen uses the native content-panel background and follows the Social Bunny palette:

1. Hero card: title, tagline, blue badge preview, price/interval, current status pill.
2. Result banner (success or failure).
3. Status card: status label, detail, next billing / grace end, auto-renew.
4. Benefits card: six benefits in two columns.
5. Manage card: Subscribe / Reactivate / Retry Payment / Cancel / Auto-Renew / Refresh, as permitted by state.
6. Payment history card with start date.
7. Account activity card showing subscription notifications.

The confirmation modal explicitly states the Simoleon price, interval, automatic renewal, and that no real-world payment occurs.
