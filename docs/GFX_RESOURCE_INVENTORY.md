# GFX & UI Resource Inventory — Social Bunny Verified

> Audited from the installed *The Sims 4* game at `C:\Program Files (x86)\Steam\steamapps\common\The Sims 4`.

## 1. Primary Scaleform Resource

| Resource | Type | Group | Instance | Source | Role | Modification |
|---|---|---|---|---|---|---|
| `socialmedia` / `SocialMedia` | `0x62ECC59A` | `0x00000000` | `0x8ABB350F01880C64` | `Data\Client\UI.package` | Root Social Bunny app widget; original 68,984 bytes, GFX v14 | **Targeted additive override.** Original display list and all native classes preserved; only `SocialMediaPanel.as` changes. |

The extracted original is preserved at:

`src/gfx/original/SocialMedia_0x8ABB350F01880C64.gfx`

## 2. Native Display Hierarchy

- `SocialMedia` (root `Sprite`)
  - `SocialMediaMain` (`WidgetBase`, symbol 260)
    - `mcSocialMediaPanel` (`SocialMediaPanel`, symbol 100)
      - `mcBackground`
      - `btnFeedTabButton` (`FeedTabTextButton`, symbol 78)
      - `btnFriendsTabButton` (`FriendsTabTextButton`, symbol 80)
      - `btnMessagesTabButton` (`MessagesTabTextButton`, symbol 79)
      - `btnNewPost`, `btnNewEventPost`, `btnClose`
      - `mcFeedPanel` (`SocialMediaFeedTabPanel`, symbol 59)
      - `mcFriendsPanel` (`SocialMediaFriendsTabPanel`, symbol 102)
      - `mcMessagesPanel` (`SocialMediaMessagesTabPanel`, symbol 228)

### Additive Verified entities

| Entity | Type | Created by |
|---|---|---|
| `btnVerifiedTabButton` | Native `FriendsTabTextButton` instance | `SocialMediaPanel.ConfigUI()` |
| `mcVerifiedPanel` | Native `SocialMediaFeedTabPanel` instance | `SocialMediaPanel.CreateTabPanel()` |
| Verified canvas / mask / scrollbar / overlay | `Sprite` children of the native content panel | `SocialMediaPanel.InitVerifiedChrome()` |
| Blue verified badge | Vector-drawn `Sprite` | `SocialMediaPanel.CreateVerifiedBadge()` |

The Verified tab uses the native content-panel MovieClip as its backdrop, hides the native ScrollList and empty-state children, and draws the subscription interface above it.

## 3. Original Native Classes Preserved

`SocialMediaMain`, `SocialMediaFeedTabPanel`, `SocialMediaFriendsTabPanel`, `SocialMediaMessagesTabPanel`, `SocialMediaFeedCellView`, `SocialMediaFriendCellView`, `SocialMediaMessageCellView`, `SocialMediaMessageDMCellView`, `SocialMediaReactionPopUp`, `SocialMediaEmojiCellView`, `SocialMediaReactionCellView`, `SocialMediaTabPanelBase`, `FeedTabTextButton`, `FriendsTabTextButton`, `MessagesTabTextButton`, `PostButton_Tag`, `PostButton_Event`, `Button_AddFriend`, `Button_RemoveFriend`, `Button_Chat`, `Button_Reaction`, `IconResource22x22`, `SocialMediaTunables`, and related relationship components.

Only `SocialMediaPanel` is changed. The other ActionScript files in `src/gfx/scripts/` are byte-identical to `src/gfx/decompiled/SocialMedia/scripts/`.

## 4. Native Python / Communication Resources

| Resource | Location | Use |
|---|---|---|
| `social_media/social_media_service.pyc` | `Data\Simulation\Gameplay\simulation.zip` | Native feed, DMs, followers, and `show_social_media_dialog` |
| `distributor.ops.ShowSocialMediaPanel` | Game Python | Verified UI state transport |
| `CommunicationManager.PostServerCommand` | Scaleform | Verified UI → Python action channel |
| `services.time_service().sim_now` / `date_and_time` | Game Python | Billing timestamps and intervals |
| `alarms.add_alarm` | Game Python | Hourly billing tick |
| Household `Funds.try_remove` | Game Python | Simoleon subscription charges |
