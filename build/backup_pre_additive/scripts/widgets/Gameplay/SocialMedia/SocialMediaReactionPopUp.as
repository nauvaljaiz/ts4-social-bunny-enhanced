package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import olympus.controls.GUIComponent;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.GridEvent;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.gui.grids.SelectionGrid;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.GridInputAdapter;
   import olympus.layout.GridLayout;
   import olympus.motion.Animation;
   import olympus.motion.Tween;
   import olympus.utils.SystemUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol264")]
   public class SocialMediaReactionPopUp extends GUIComponent implements IInputFocusable
   {
      
      public static const SOCIAL_MEDIA_REACTION_SELECTED:String = "social_media_reaction_selected";
      
      public static const SOCIAL_MEDIA_REACTION_CANCELLED:String = "social_media_reaction_cancelled";
      
      public var mcBackground:MovieClip;
      
      public var mSelectionGrid:SelectionGrid;
      
      public var mcArrow:MovieClip;
      
      protected var mListAdapter:GridInputAdapter;
      
      protected var mFadeTween:Tween;
      
      protected var mDataFeed:SelectableArrayDataFeed = new SelectableArrayDataFeed();
      
      protected var mbGridInitialized:Boolean = false;

      private static var sSelectedTier:String = "blue_verified";
      
      public function SocialMediaReactionPopUp()
      {
         super();
      }
      
      public function Show(param1:Number) : void
      {
         if(this.mFadeTween != null && Boolean(this.mFadeTween.IsActive()))
         {
            this.mFadeTween.Stop();
         }
         alpha = 0;
         visible = false;
         Tween.StopAllTweens(this);
         var _loc2_:Tween = Tween.QuickAnimation(Animation.FADE_IN,param1,this);
         _loc2_.Start();
      }
      
      public function Hide(param1:Number) : void
      {
         Tween.StopAllTweens(this);
         this.mFadeTween = Tween.QuickAnimation(Animation.FADE_OUT,param1,this);
         this.mFadeTween.Start();
      }
      
      public function ShowSelectionGrid() : void
      {
         this.mSelectionGrid.visible = true;
         if(!this.mbGridInitialized)
         {
            this.InitializeSelectionGrid();
         }
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusForward(this.mListAdapter);
            this.HighlightSelectedItem();
         }
      }
      
      protected function InitializeSelectionGrid() : void
      {
         var _loc1_:GridLayout = new GridLayout(false,true,6);
         var _loc2_:SelectionGrid = this.mSelectionGrid;
         _loc2_.InitializeSelectionGrid(this.mDataFeed,SocialMediaEmojiCellView,true,null,_loc1_,false,false);
         _loc2_.SetSelectionGridListener(PushButtonEvent.CLICK);
         _loc2_.addEventListener(GridEvent.SELECTION_UPDATE,this.OnClickVariation,false,0,true);
         this.mbGridInitialized = true;
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitializeGamepadInput();
         }
      }
      
      public function SetData(param1:Array) : void
      {
         this.mDataFeed.RemoveAllItems();
         this.mDataFeed.AddItemsFromIterable(param1);
         if(this.mbGridInitialized)
         {
            this.mSelectionGrid.SetDataFeed(this.mDataFeed);
         }
      }
      
      protected function OnClickVariation(param1:GridEvent) : void
      {
         var _loc2_:SocialMediaReaction = param1.mData as SocialMediaReaction;
         dispatchEvent(new SocialMediaReactionEvent(SOCIAL_MEDIA_REACTION_SELECTED,true,false,_loc2_));
      }
      
      public function Remove() : void
      {
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusBack();
         }
      }
      
      protected function InitializeGamepadInput() : void
      {
         this.mListAdapter = new GridInputAdapter(this.mSelectionGrid.mGridLayout as GridLayout);
         this.mListAdapter.OnBackCall(this.BackHandler);
      }
      
      protected function BackHandler() : void
      {
         dispatchEvent(new SocialMediaReactionEvent(SOCIAL_MEDIA_REACTION_CANCELLED,true,false));
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.mListAdapter.Enter();
         return this;
      }
      
      public function Exit() : void
      {
         this.mListAdapter.Exit();
      }
      
      public function HighlightSelectedItem() : void
      {
         var _loc1_:Array = this.mDataFeed.GetSelectedIndices();
         if(_loc1_.length > 0)
         {
            this.mListAdapter.SetHighlightedIndex(_loc1_[0]);
         }
      }

      // === VERIFICATION PORTAL SCREEN ===
      public static function RenderSBVVerification(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var y:Number = 8;
         var cardW:Number = 512;
         var ver:Object = state && state.verification ? state.verification : new Object();
         var elig:Object = ver.eligibility ? ver.eligibility : new Object();
         var app:Object = ver.application;
         var viewer:Object = state && state.viewer ? state.viewer : new Object();

         // Header Overview Card
         var ov:Sprite = SocialMediaTunables.CreateCard(cardW,110,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         ov.x = 8;
         ov.y = y;
         canvas.addChild(ov);

         var badgePrev:Sprite = SocialMediaTunables.CreateBadgeSprite(28);
         SocialMediaTunables.UpdateBadgeSprite(badgePrev,sSelectedTier == "official" ? "official" : (sSelectedTier == "legacy" ? "legacy" : "blue_verified"));
         badgePrev.x = 14;
         badgePrev.y = 14;
         ov.addChild(badgePrev);

         var h1:TextField = SocialMediaTunables.CreateLabel("Social Bunny Verification",15,SocialMediaTunables.COL_TEXT_PRIMARY,true,320,22);
         h1.x = 50;
         h1.y = 10;
         ov.addChild(h1);

         var statusStr:String = String(elig.status || "not_eligible").toUpperCase();
         var h2:TextField = SocialMediaTunables.CreateLabel(
            "Status: " + statusStr + "   ·   Score: " + String(elig.score || 0) + " / " + String(elig.threshold || 70),
            11,
            elig.eligible || statusStr == "VERIFIED" ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_BRAND_DARK,
            true,
            420,
            18
         );
         h2.x = 50;
         h2.y = 32;
         ov.addChild(h2);

         var expl:TextField = SocialMediaTunables.CreateLabel(
            "Verified badges confirm authentic public figures, notable creators, and official brands based on notability, engagement quality, reputation, and profile completeness.",
            10,
            SocialMediaTunables.COL_TEXT_SECONDARY,
            false,
            cardW - 28,
            34,
            true
         );
         expl.x = 14;
         expl.y = 56;
         ov.addChild(expl);
         y += 118;

         // 6-Factor Eligibility Breakdown Card
         var br:Object = elig.breakdown ? elig.breakdown : new Object();
         var brCard:Sprite = SocialMediaTunables.CreateCard(cardW,142,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         brCard.x = 8;
         brCard.y = y;
         canvas.addChild(brCard);

         var brTitle:TextField = SocialMediaTunables.CreateLabel("Eligibility Breakdown",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 20,18);
         brTitle.x = 10;
         brTitle.y = 8;
         brCard.addChild(brTitle);

         var factors:Array = [
            {"label":"Authenticity (20%)","val":Number(br.authenticity || 0)},
            {"label":"Notability (25%)","val":Number(br.notability || 0)},
            {"label":"Activity (15%)","val":Number(br.activity || 0)},
            {"label":"Engagement (15%)","val":Number(br.engagement_quality || 0)},
            {"label":"Reputation (15%)","val":Number(br.reputation || 0)},
            {"label":"Profile (10%)","val":Number(br.profile_quality || 0)}
         ];
         var fi:int = 0;
         while(fi < factors.length)
         {
            var fObj:Object = factors[fi];
            var colX:Number = 12 + (fi % 2) * 250;
            var rowY:Number = 32 + int(fi / 2) * 34;
            var fLbl:TextField = SocialMediaTunables.CreateLabel(fObj.label + " — " + String(int(fObj.val)) + "%",10,SocialMediaTunables.COL_TEXT_SECONDARY,false,235,15);
            fLbl.x = colX;
            fLbl.y = rowY;
            brCard.addChild(fLbl);

            brCard.graphics.beginFill(SocialMediaTunables.COL_SURFACE_ALT,1.0);
            brCard.graphics.drawRoundRect(colX,rowY + 16,232,7,3,3);
            brCard.graphics.endFill();
            var fillW:Number = Math.max(4,Math.min(232,(fObj.val / 100.0) * 232));
            brCard.graphics.beginFill(fObj.val >= 65 ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_BRAND_BLUE,1.0);
            brCard.graphics.drawRoundRect(colX,rowY + 16,fillW,7,3,3);
            brCard.graphics.endFill();
            fi++;
         }
         y += 150;

         // Application Form / Status Card
         var formCard:Sprite = SocialMediaTunables.CreateCard(cardW,176,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         formCard.x = 8;
         formCard.y = y;
         canvas.addChild(formCard);

         if(statusStr == "VERIFIED")
         {
            var v1:TextField = SocialMediaTunables.CreateLabel("Your account is Verified (" + String(viewer.verification_tier || "blue_verified") + ")",13,SocialMediaTunables.COL_GREEN,true,cardW - 24,20);
            v1.x = 12;
            v1.y = 14;
            formCard.addChild(v1);
            var v2:TextField = SocialMediaTunables.CreateLabel("Maintain positive reputation and community standing to retain your verification badge across saves.",11,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW - 24,36,true);
            v2.x = 12;
            v2.y = 40;
            formCard.addChild(v2);
         }
         else if(app != null && (app.decision == "pending" || app.decision == "under_review"))
         {
            var p1:TextField = SocialMediaTunables.CreateLabel("Application Under Review (" + String(app.application_id) + ")",13,SocialMediaTunables.COL_BRAND_DARK,true,cardW - 24,20);
            p1.x = 12;
            p1.y = 14;
            formCard.addChild(p1);
            var p2:TextField = SocialMediaTunables.CreateLabel("Requested: " + String(app.requested_category) + "  ·  Submitted Score: " + String(app.score_at_submission),11,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW - 24,20);
            p2.x = 12;
            p2.y = 38;
            formCard.addChild(p2);
            var revBtn:Sprite = SocialMediaTunables.CreateButton(
               "Run Review Now",
               140,
               26,
               SocialMediaTunables.COL_BRAND_BLUE,
               0xFFFFFF,
               OnPortalBtnClick,
               11,
               0,
               {"kind":"cmd","simId":simId,"cmd":"review_verification"}
            );
            revBtn.x = 12;
            revBtn.y = 70;
            formCard.addChild(revBtn);
         }
         else
         {
            var fTitle:TextField = SocialMediaTunables.CreateLabel("Request Verification",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 24,18);
            fTitle.x = 12;
            fTitle.y = 10;
            formCard.addChild(fTitle);

            var tiers:Array = [
               {"id":"blue_verified","label":"Blue Verified"},
               {"id":"official","label":"Official"},
               {"id":"legacy","label":"Legacy"}
            ];
            var tx:Number = 12;
            var ti:int = 0;
            while(ti < tiers.length)
            {
               var tObj:Object = tiers[ti];
               var tBtn:Sprite = MakeTierButton(panel,tObj.id,tObj.label,sSelectedTier == tObj.id);
               tBtn.x = tx;
               tBtn.y = 32;
               formCard.addChild(tBtn);
               tx += 116;
               ti++;
            }

            var noteBox:Sprite = SocialMediaTunables.CreateInputBox("Notable creator in Willow Creek",cardW - 24,36,false,160);
            noteBox.x = 12;
            noteBox.y = 64;
            formCard.addChild(noteBox);

            var reasons:Array = elig.reasons ? (elig.reasons as Array) : new Array();
            if(reasons.length > 0)
            {
               var rTxt:TextField = SocialMediaTunables.CreateLabel("Requirement note: " + String(reasons[0]),10,SocialMediaTunables.COL_WARN,false,cardW - 24,28,true);
               rTxt.x = 12;
               rTxt.y = 104;
               formCard.addChild(rTxt);
            }
            if(app != null && app.decision == "rejected")
            {
               var rejTxt:TextField = SocialMediaTunables.CreateLabel("Last decision: Rejected — " + String(app.rejection_reason),10,SocialMediaTunables.COL_DANGER,false,cardW - 24,18);
               rejTxt.x = 12;
               rejTxt.y = 124;
               formCard.addChild(rejTxt);
               if(!app.appealed)
               {
                  var appBtn:Sprite = SocialMediaTunables.CreateButton(
                     "Appeal Decision",
                     130,
                     24,
                     SocialMediaTunables.COL_WARN,
                     0xFFFFFF,
                     OnPortalBtnClick,
                     10,
                     0,
                     {"kind":"appeal","simId":simId,"inp":noteBox}
                  );
                  appBtn.x = 180;
                  appBtn.y = 144;
                  formCard.addChild(appBtn);
               }
            }

            var subBtn:Sprite = SocialMediaTunables.CreateButton(
               "Submit & Review",
               156,
               26,
               SocialMediaTunables.COL_BRAND_BLUE,
               0xFFFFFF,
               OnPortalBtnClick,
               11,
               0,
               {"kind":"apply","simId":simId,"inp":noteBox}
            );
            subBtn.x = 12;
            subBtn.y = 142;
            formCard.addChild(subBtn);
         }

         return y + 186;
      }

      private static function MakeTierButton(panel:SocialMediaPanel, tierId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label,
            108,
            24,
            active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE_ALT,
            active ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnPortalBtnClick,
            10,
            active ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"tier","panel":panel,"tierId":tierId}
         );
      }

      // === ACCOUNT SETTINGS, PRIVACY, MODERATION & NATIVE SHORTCUTS ===
      public static function RenderSBVSettings(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var y:Number = 8;
         var cardW:Number = 512;
         var viewer:Object = state && state.viewer ? state.viewer : new Object();
         var prefs:Object = state && state.viewer_prefs ? state.viewer_prefs : new Object();
         var mod:Object = state && state.moderation ? state.moderation : new Object();

         // Quick Navigation Strip (Verification / Native DMs / Native Contacts / Native Feed)
         var qCard:Sprite = SocialMediaTunables.CreateCard(cardW,44,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         qCard.x = 8;
         qCard.y = y;
         canvas.addChild(qCard);

         var qVer:Sprite = SocialMediaTunables.CreateButton(
            "Verification",
            114,
            26,
            SocialMediaTunables.COL_BRAND_BLUE,
            0xFFFFFF,
            OnPortalBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"set_tab","arg1":"verify"}
         );
         qVer.x = 10;
         qVer.y = 9;
         qCard.addChild(qVer);

         var qDM:Sprite = SocialMediaTunables.CreateButton(
            "Native DMs",
            114,
            26,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_TEXT_PRIMARY,
            OnPortalBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"native","panel":panel,"mode":SocialMediaPanel.PANEL_MODE_MESSAGES}
         );
         qDM.x = 132;
         qDM.y = 9;
         qCard.addChild(qDM);

         var qCon:Sprite = SocialMediaTunables.CreateButton(
            "Native Contacts",
            122,
            26,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_TEXT_PRIMARY,
            OnPortalBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"native","panel":panel,"mode":SocialMediaPanel.PANEL_MODE_FRIENDS}
         );
         qCon.x = 254;
         qCon.y = 9;
         qCard.addChild(qCon);

         var qNpc:Sprite = SocialMediaTunables.CreateButton(
            "Simulate NPCs",
            118,
            26,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_BRAND_DARK,
            OnPortalBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"npc_step"}
         );
         qNpc.x = 384;
         qNpc.y = 9;
         qCard.addChild(qNpc);
         y += 52;

         // Edit Username & Bio
         var profCard:Sprite = SocialMediaTunables.CreateCard(cardW,148,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         profCard.x = 8;
         profCard.y = y;
         canvas.addChild(profCard);

         var pHead:TextField = SocialMediaTunables.CreateLabel("Edit Profile & Handle",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,300,18);
         pHead.x = 12;
         pHead.y = 8;
         profCard.addChild(pHead);

         var userBox:Sprite = SocialMediaTunables.CreateInputBox(String(viewer.username || ""),310,26,false,24);
         userBox.x = 12;
         userBox.y = 32;
         profCard.addChild(userBox);

         var saveUserBtn:Sprite = SocialMediaTunables.CreateButton(
            "Save @Handle",
            160,
            26,
            SocialMediaTunables.COL_BRAND_DARK,
            0xFFFFFF,
            OnPortalBtnClick,
            10,
            0,
            {"kind":"input_cmd","simId":simId,"cmd":"change_username","inp":userBox}
         );
         saveUserBtn.x = 332;
         saveUserBtn.y = 32;
         profCard.addChild(saveUserBtn);

         var bioBox:Sprite = SocialMediaTunables.CreateInputBox(String(viewer.bio || ""),310,64,true,160);
         bioBox.x = 12;
         bioBox.y = 68;
         profCard.addChild(bioBox);

         var saveBioBtn:Sprite = SocialMediaTunables.CreateButton(
            "Save Bio",
            160,
            26,
            SocialMediaTunables.COL_BRAND_BLUE,
            0xFFFFFF,
            OnPortalBtnClick,
            10,
            0,
            {"kind":"input_cmd","simId":simId,"cmd":"update_bio","inp":bioBox}
         );
         saveBioBtn.x = 332;
         saveBioBtn.y = 86;
         profCard.addChild(saveBioBtn);
         y += 156;

         // Account Category & Privacy Card
         var catCard:Sprite = SocialMediaTunables.CreateCard(cardW,108,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         catCard.x = 8;
         catCard.y = y;
         canvas.addChild(catCard);

         var cHead:TextField = SocialMediaTunables.CreateLabel("Account Category & Privacy",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,300,18);
         cHead.x = 12;
         cHead.y = 8;
         catCard.addChild(cHead);

         var cats:Array = [
            {"id":"personal","label":"Personal"},
            {"id":"creator","label":"Creator"},
            {"id":"business","label":"Business"},
            {"id":"public_figure","label":"Public Fig."},
            {"id":"official_org","label":"Official"}
         ];
         var cx:Number = 12;
         var ci:int = 0;
         while(ci < cats.length)
         {
            var cObj:Object = cats[ci];
            var cBtn:Sprite = MakeCategoryButton(simId,cObj.id,cObj.label,viewer.category == cObj.id);
            cBtn.x = cx;
            cBtn.y = 32;
            catCard.addChild(cBtn);
            cx += 98;
            ci++;
         }

         var isPriv:Boolean = (viewer.privacy == "private");
         var pubBtn:Sprite = SocialMediaTunables.CreateButton(
            "Public Account",
            140,
            26,
            !isPriv ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_SURFACE_ALT,
            !isPriv ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnPortalBtnClick,
            10,
            !isPriv ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_privacy","arg1":"public"}
         );
         pubBtn.x = 12;
         pubBtn.y = 68;
         catCard.addChild(pubBtn);

         var privBtn:Sprite = SocialMediaTunables.CreateButton(
            "Private Account",
            140,
            26,
            isPriv ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE_ALT,
            isPriv ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnPortalBtnClick,
            10,
            isPriv ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_privacy","arg1":"private"}
         );
         privBtn.x = 162;
         privBtn.y = 68;
         catCard.addChild(privBtn);
         y += 116;

         // Notification Preferences & Account Standing
         var prefCard:Sprite = SocialMediaTunables.CreateCard(cardW,110,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         prefCard.x = 8;
         prefCard.y = y;
         canvas.addChild(prefCard);

         var nHead:TextField = SocialMediaTunables.CreateLabel("Notifications & Account Standing (" + String(viewer.status || "active").toUpperCase() + ")",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 24,18);
         nHead.x = 12;
         nHead.y = 8;
         prefCard.addChild(nHead);

         var nLikes:Sprite = MakePrefToggle(simId,"likes","Likes",Boolean(prefs.notify_likes));
         nLikes.x = 12;
         nLikes.y = 34;
         prefCard.addChild(nLikes);

         var nCmts:Sprite = MakePrefToggle(simId,"comments","Comments",Boolean(prefs.notify_comments));
         nCmts.x = 152;
         nCmts.y = 34;
         prefCard.addChild(nCmts);

         var nFol:Sprite = MakePrefToggle(simId,"follows","Follows",Boolean(prefs.notify_follows));
         nFol.x = 302;
         nFol.y = 34;
         prefCard.addChild(nFol);

         var modHist:Array = mod.history ? (mod.history as Array) : new Array();
         var blockedArr:Array = mod.blocked ? (mod.blocked as Array) : new Array();
         var standTf:TextField = SocialMediaTunables.CreateLabel(
            "Reputation: " + String(int(viewer.reputation)) + "/100 (" + String(viewer.standing) + ")  ·  Blocked: " + blockedArr.length + "  ·  Mod Actions: " + modHist.length,
            10,
            SocialMediaTunables.COL_TEXT_SECONDARY,
            false,
            cardW - 24,
            24
         );
         standTf.x = 12;
         standTf.y = 72;
         prefCard.addChild(standTf);
         y += 120;

         return y;
      }

      private static function MakeCategoryButton(simId:String, catId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label,
            92,
            24,
            active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE_ALT,
            active ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnPortalBtnClick,
            10,
            active ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_category","arg1":catId}
         );
      }

      private static function MakePrefToggle(simId:String, prefKey:String, label:String, enabled:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label + (enabled ? ": ON" : ": OFF"),
            130,
            24,
            enabled ? 0xDCFCE7 : SocialMediaTunables.COL_SURFACE_ALT,
            enabled ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_TEXT_MUTED,
            OnPortalBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_notify_prefs","arg1":prefKey,"arg2":enabled ? "0" : "1"}
         );
      }

      protected static function OnPortalBtnClick(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(!btn || !btn["sbv"])
         {
            return;
         }
         var d:Object = btn["sbv"];
         var k:String = String(d.kind || "");
         var inp:Sprite = d.inp as Sprite;
         var tf:TextField = inp ? (inp["tf"] as TextField) : null;
         if(k == "appeal")
         {
            SocialMediaTunables.SendAction(String(d.simId),"appeal_verification",tf ? tf.text : "Please reconsider");
         }
         else if(k == "apply")
         {
            SocialMediaTunables.SendAction(String(d.simId),"apply_verification",sSelectedTier,tf ? tf.text : "","instant");
         }
         else if(k == "tier")
         {
            sSelectedTier = String(d.tierId);
            (d.panel as SocialMediaPanel).RefreshSBVView();
         }
         else if(k == "native")
         {
            (d.panel as SocialMediaPanel).SwitchToNativeTab(int(d.mode));
         }
         else if(k == "input_cmd")
         {
            SocialMediaTunables.SendAction(String(d.simId),String(d.cmd),tf ? tf.text : "");
         }
         else if(k == "cmd")
         {
            SocialMediaTunables.SendAction(String(d.simId),String(d.cmd),String(d.arg1 || ""),String(d.arg2 || ""));
         }
      }
   }
}
