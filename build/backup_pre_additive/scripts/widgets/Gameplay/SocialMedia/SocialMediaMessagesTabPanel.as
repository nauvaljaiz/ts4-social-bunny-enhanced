package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.controls.IconComponent;
   import olympus.data.ArrayDataFeed;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.TextButton;
   import olympus.input.IInputAdapter;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import olympus.utils.ImageUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol228")]
   public class SocialMediaMessagesTabPanel extends SocialMediaTabPanelBase
   {
      
      public var btnNewDirectMessage:TextButton;
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcEmptyStateBackground:MovieClip;
      
      protected var mFeedData:ArrayDataFeed;
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      public function SocialMediaMessagesTabPanel()
      {
         super();
      }
      
      override public function Initialize() : void
      {
         this.btnNewDirectMessage.htmlText = KeysGP.SOCIAL_MEDIA_DIRECT_MESSAGE_BUTTON_LABEL.toString();
         this.btnNewDirectMessage.addEventListener(PushButtonEvent.CLICK,this.OnNewDirectMessageClick,false,0,true);
         this.btnNewDirectMessage.AudioExt.ElementName = "NewDirectMessageButton";
         this.mFeedData = new ArrayDataFeed();
         var _loc1_:GridLayout = new GridLayout(false,true,1);
         mcList.mSlider.AlwaysVisible = false;
         mcList.InitializeScrollList(this.mFeedData,SocialMediaMessageCellView,SocialMediaTunables.DM_LIST_CELL_PADDING,SocialMediaTunables.DM_SCROLLBAR_PADDING,_loc1_);
         this.txtEmptyStateTitle.htmlText = KeysGP.SOCIAL_MEDIA_MESSAGES_EMPTY_STATE_TITLE.toString();
         this.txtEmptyStateTitle.visible = false;
         this.mcEmptyStateBackground.visible = false;
         this.txtEmptyStateDescription.htmlText = KeysGP.SOCIAL_MEDIA_MESSAGES_EMPTY_STATE_DESCRIPTION.toString();
         this.txtEmptyStateDescription.visible = false;
         super.Initialize();
      }
      
      override public function OnShow(param1:Array) : void
      {
         this.mFeedData.RemoveAllItems();
         this.mFeedData.AddItemsFromIterable(param1);
         this.RefreshLayout();
      }
      
      override public function OnTabShow(param1:Array) : void
      {
         this.mFeedData.RemoveAllItems();
         this.mFeedData.AddItemsFromIterable(param1);
         this.RefreshLayout();
      }
      
      override public function OnTabHide() : void
      {
         this.CloseReactionPopUps();
      }
      
      protected function RefreshLayout() : void
      {
         if(this.mFeedData.length < 1)
         {
            this.txtEmptyStateTitle.visible = true;
            this.txtEmptyStateDescription.visible = true;
            this.mcEmptyStateBackground.visible = true;
         }
         else
         {
            this.txtEmptyStateTitle.visible = false;
            this.txtEmptyStateDescription.visible = false;
            this.mcEmptyStateBackground.visible = false;
            mcBackground.height = SocialMediaTunables.DM_TAB_PANEL_HEIGHT;
            this.btnNewDirectMessage.y = mcBackground.height - SocialMediaTunables.DM_TAB_PANEL_MARGINS.mBot - this.btnNewDirectMessage.height;
            mcList.height = this.btnNewDirectMessage.y - SocialMediaTunables.FRIENDS_TAB_PANEL_PADDING - SocialMediaTunables.DM_TAB_PANEL_MARGINS.mTop;
            mcList.width = mcBackground.width - SocialMediaTunables.DM_TAB_PANEL_MARGINS.Horizontal;
            mcList.mSlider.SetCurrentValue(mcList.mSlider.MaxValue,false);
         }
      }
      
      protected function OnNewDirectMessageClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_direct_message_picker_interaction,GameplayStateData.ActiveSimId,GameplayStateData.ActiveSimId);
      }
      
      override protected function InitializeGamepadInput() : void
      {
         super.InitializeGamepadInput();
         this.mMainAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnNewDirectMessage],true);
         this.mMainAdapter.SetDefaultHighlight(this.btnNewDirectMessage);
         this.mMainAdapter.OnLeaveCall(this.HandleMainLeave);
      }
      
      override public function IsFocused() : Boolean
      {
         return Boolean(super.IsFocused()) || NavManager.Instance.CurrentFocusable == this.mMainAdapter;
      }
      
      override protected function HandleListLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.DOWN)
         {
            NavManager.Instance.FocusPan(this.mMainAdapter,param1.CreateEnterParams());
         }
         else if(Boolean(mLeaveCallback))
         {
            mLeaveCallback(param1);
         }
      }
      
      protected function HandleMainLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.UP && this.mFeedData.length > 0)
         {
            NavManager.Instance.FocusPan(mListAdapter,param1.CreateEnterParams());
         }
         else if(Boolean(mLeaveCallback))
         {
            mLeaveCallback(param1);
         }
      }
      
      override public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         super.OnInputEventCall(param1,param2);
         if(param1 != InputAdapterEvent.LEAVE)
         {
            this.mMainAdapter.OnInputEventCall(param1,param2);
         }
         return this;
      }
      
      override public function Exit() : void
      {
         super.Exit();
         this.mMainAdapter.Exit();
      }
      
      override public function GetTargetInputAdapter() : IInputAdapter
      {
         if(this.mFeedData.length > 0)
         {
            return mListAdapter;
         }
         return this.mMainAdapter;
      }
      
      public function CloseReactionPopUps() : void
      {
         var _loc2_:IView = null;
         var _loc3_:SocialMediaMessageCellView = null;
         if(!mcList || !mcList.mGridLayout)
         {
            return;
         }
         var _loc1_:Vector.<IView> = mcList.mGridLayout.GetAllCells();
         if(!_loc1_)
         {
            return;
         }
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = _loc2_ as SocialMediaMessageCellView;
            if(_loc3_)
            {
               _loc3_.RemoveReactionPopUp();
            }
         }
      }

      // === SOCIAL BUNNY VERIFIED NOTIFICATIONS SCREEN ===
      public static function RenderSBVNotifications(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var y:Number = 8;
         var cardW:Number = 512;
         var notifsObj:Object = state && state.notifications ? state.notifications : new Object();

         var hTitle:TextField = SocialMediaTunables.CreateLabel("Notifications & Requests",14,SocialMediaTunables.COL_TEXT_PRIMARY,true,300,22);
         hTitle.x = 8;
         hTitle.y = y;
         canvas.addChild(hTitle);

         var markBtn:Sprite = SocialMediaTunables.CreateButton(
            "Mark All Read",
            106,
            24,
            SocialMediaTunables.COL_SURFACE,
            SocialMediaTunables.COL_BRAND_DARK,
            OnMessagesBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"mark_notifications_read"}
         );
         markBtn.x = cardW - 98;
         markBtn.y = y;
         canvas.addChild(markBtn);
         y += 32;

         var reqs:Array = notifsObj.follow_requests ? (notifsObj.follow_requests as Array) : new Array();
         if(reqs.length > 0)
         {
            var rHead:TextField = SocialMediaTunables.CreateLabel("FOLLOW REQUESTS (" + reqs.length + ")",10,SocialMediaTunables.COL_TEXT_MUTED,true,cardW,16);
            rHead.x = 8;
            rHead.y = y;
            canvas.addChild(rHead);
            y += 18;
            var rIdx:int = 0;
            while(rIdx < reqs.length)
            {
               y = RenderFollowRequestRow(canvas,reqs[rIdx],simId,y,cardW);
               rIdx++;
            }
            y += 6;
         }

         var items:Array = notifsObj.items ? (notifsObj.items as Array) : new Array();
         if(items.length == 0)
         {
            var emptyCard:Sprite = SocialMediaTunables.CreateCard(cardW,70,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            emptyCard.x = 8;
            emptyCard.y = y;
            canvas.addChild(emptyCard);
            var e1:TextField = SocialMediaTunables.CreateLabel("You're all caught up! No notifications yet.",12,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 24,20,false,"center");
            e1.x = 12;
            e1.y = 24;
            emptyCard.addChild(e1);
            return y + 82;
         }

         var nIdx:int = 0;
         while(nIdx < items.length)
         {
            y = RenderNotificationRow(canvas,items[nIdx],simId,y,cardW);
            nIdx++;
         }
         return y + 8;
      }

      private static function RenderFollowRequestRow(canvas:Sprite, req:Object, simId:String, startY:Number, cardW:Number) : Number
      {
         var reqId:String = String(req.sim_id);
         var card:Sprite = SocialMediaTunables.CreateCard(cardW,50,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);

         var nameTf:TextField = SocialMediaTunables.CreateLabel(String(req.display_name) + " (@" + String(req.username) + ")",11,SocialMediaTunables.COL_TEXT_PRIMARY,true,290,18);
         nameTf.x = 12;
         nameTf.y = 15;
         card.addChild(nameTf);

         var appBtn:Sprite = SocialMediaTunables.CreateButton(
            "Approve",
            74,
            24,
            SocialMediaTunables.COL_BRAND_BLUE,
            0xFFFFFF,
            OnMessagesBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"approve_request","arg1":reqId}
         );
         appBtn.x = cardW - 160;
         appBtn.y = 13;
         card.addChild(appBtn);

         var rejBtn:Sprite = SocialMediaTunables.CreateButton(
            "Reject",
            70,
            24,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_TEXT_SECONDARY,
            OnMessagesBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"reject_request","arg1":reqId}
         );
         rejBtn.x = cardW - 80;
         rejBtn.y = 13;
         card.addChild(rejBtn);

         return startY + 56;
      }

      private static function RenderNotificationRow(canvas:Sprite, n:Object, simId:String, startY:Number, cardW:Number) : Number
      {
         var unread:Boolean = !Boolean(n.read);
         var bg:uint = unread ? 0xEFF6FF : SocialMediaTunables.COL_SURFACE;
         var card:Sprite = SocialMediaTunables.CreateCard(cardW,48,bg,SocialMediaTunables.COL_BORDER,8);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);

         var av:IconComponent = new IconComponent();
         av.x = 10;
         av.y = 10;
         av.mouseEnabled = false;
         av.mouseChildren = false;
         card.addChild(av);
         av.ResetImageSize(28,28);
         ImageUtils.LoadSimThumbnail(av,String(n.actor_sim_id),ImageUtils.SIM_THUMBNAIL_TYPE_BUST);

         var msgTf:TextField = SocialMediaTunables.CreateLabel(String(n.message || ""),11,SocialMediaTunables.COL_TEXT_PRIMARY,unread,cardW - 110,30,true);
         msgTf.x = 46;
         msgTf.y = 9;
         card.addChild(msgTf);

         var ageTf:TextField = SocialMediaTunables.CreateLabel(SocialMediaTunables.FormatAge(int(n.age_min)),10,SocialMediaTunables.COL_TEXT_MUTED,false,48,16,false,"right");
         ageTf.x = cardW - 58;
         ageTf.y = 14;
         card.addChild(ageTf);

         return startY + 54;
      }

      // === SOCIAL BUNNY VERIFIED PROFESSIONAL ANALYTICS & BRAND COLLABORATIONS ===
      public static function RenderSBVDashboard(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var y:Number = 8;
         var cardW:Number = 512;
         var dash:Object = state && state.dashboard ? state.dashboard : new Object();
         var summary:Object = dash.summary ? dash.summary : new Object();
         var curPeriod:String = String(dash.period || "30d");

         var titleTf:TextField = SocialMediaTunables.CreateLabel("Professional Dashboard",14,SocialMediaTunables.COL_TEXT_PRIMARY,true,220,22);
         titleTf.x = 8;
         titleTf.y = y;
         canvas.addChild(titleTf);

         var periods:Array = [
            {"id":"7d","label":"7D"},
            {"id":"30d","label":"30D"},
            {"id":"90d","label":"90D"},
            {"id":"lifetime","label":"All"}
         ];
         var px:Number = 284;
         var pIdx:int = 0;
         while(pIdx < periods.length)
         {
            var pObj:Object = periods[pIdx];
            var pBtn:Sprite = MakePeriodButton(simId,pObj.id,pObj.label,curPeriod == pObj.id);
            pBtn.x = px;
            pBtn.y = y;
            canvas.addChild(pBtn);
            px += 58;
            pIdx++;
         }
         y += 32;

         // 4 KPI Cards (2x2 grid)
         var kpiW:Number = 250;
         var kpiH:Number = 58;
         var kpis:Array = [
            {"title":"Followers","val":String(int(summary.followers)),"sub":"Growth: " + (int(summary.growth) >= 0 ? "+" : "") + String(int(summary.growth))},
            {"title":"Reach & Impressions","val":String(int(summary.reach)) + " Reach","sub":String(int(summary.impressions)) + " total impressions"},
            {"title":"Engagement Rate","val":String(summary.engagement_rate || 0) + "%","sub":String(int(summary.likes)) + " likes · " + String(int(summary.comments)) + " comments"},
            {"title":"Profile Visits","val":String(int(summary.profile_visits)),"sub":"Avg " + String(summary.avg_engagement_per_post || 0) + " eng / post"}
         ];
         var kIdx:int = 0;
         while(kIdx < kpis.length)
         {
            var kObj:Object = kpis[kIdx];
            var kx:Number = 8 + (kIdx % 2) * (kpiW + 12);
            var ky:Number = y + int(kIdx / 2) * (kpiH + 8);
            var kc:Sprite = SocialMediaTunables.CreateCard(kpiW,kpiH,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            kc.x = kx;
            kc.y = ky;
            canvas.addChild(kc);
            var kt:TextField = SocialMediaTunables.CreateLabel(kObj.title,10,SocialMediaTunables.COL_TEXT_MUTED,true,kpiW - 20,14);
            kt.x = 10;
            kt.y = 6;
            kc.addChild(kt);
            var kv:TextField = SocialMediaTunables.CreateLabel(kObj.val,15,SocialMediaTunables.COL_TEXT_PRIMARY,true,kpiW - 20,20);
            kv.x = 10;
            kv.y = 20;
            kc.addChild(kv);
            var ks:TextField = SocialMediaTunables.CreateLabel(kObj.sub,10,SocialMediaTunables.COL_TEXT_SECONDARY,false,kpiW - 20,14);
            ks.x = 10;
            ks.y = 40;
            kc.addChild(ks);
            kIdx++;
         }
         y += (kpiH + 8) * 2 + 4;

         // Real Data Charts
         var charts:Object = dash.charts ? dash.charts : new Object();
         var chart1:Sprite = new Sprite();
         chart1.x = 8;
         chart1.y = y;
         SocialMediaTunables.DrawBarChart(chart1,"Followers Growth",charts.labels as Array,charts.followers as Array,250,145,SocialMediaTunables.COL_BRAND_BLUE);
         canvas.addChild(chart1);

         var chart2:Sprite = new Sprite();
         chart2.x = 270;
         chart2.y = y;
         SocialMediaTunables.DrawBarChart(chart2,"Engagement & Reach",charts.labels as Array,charts.engagement as Array,250,145,SocialMediaTunables.COL_GREEN);
         canvas.addChild(chart2);
         y += 155;

         // Top Performing Posts
         var topPosts:Array = dash.top_posts ? (dash.top_posts as Array) : new Array();
         if(topPosts.length > 0)
         {
            var tpCard:Sprite = SocialMediaTunables.CreateCard(cardW,30 + topPosts.length * 24,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            tpCard.x = 8;
            tpCard.y = y;
            canvas.addChild(tpCard);
            var tpTitle:TextField = SocialMediaTunables.CreateLabel("Top-Performing Posts",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 20,18);
            tpTitle.x = 10;
            tpTitle.y = 6;
            tpCard.addChild(tpTitle);
            var tpi:int = 0;
            while(tpi < topPosts.length)
            {
               var tp:Object = topPosts[tpi];
               var rowTf:TextField = SocialMediaTunables.CreateLabel(
                  (tpi + 1) + ". " + String(tp.snippet) + "  —  " + String(int(tp.likes)) + " likes · " + String(int(tp.comments)) + " replies (" + String(tp.eng_rate) + "% ER)",
                  10,
                  SocialMediaTunables.COL_TEXT_SECONDARY,
                  false,
                  cardW - 20,
                  18
               );
               rowTf.x = 10;
               rowTf.y = 26 + tpi * 22;
               tpCard.addChild(rowTf);
               tpi++;
            }
            y += 38 + topPosts.length * 24;
         }

         // Brand Collaborations Inbox
         var brHead:TextField = SocialMediaTunables.CreateLabel("Brand Collaborations",13,SocialMediaTunables.COL_TEXT_PRIMARY,true,240,20);
         brHead.x = 8;
         brHead.y = y;
         canvas.addChild(brHead);

         var reqBrandBtn:Sprite = SocialMediaTunables.CreateButton(
            "Seek Sponsorship",
            134,
            24,
            SocialMediaTunables.COL_CREATOR_PURPLE,
            0xFFFFFF,
            OnMessagesBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"request_brand_offer"}
         );
         reqBrandBtn.x = cardW - 126;
         reqBrandBtn.y = y;
         canvas.addChild(reqBrandBtn);
         y += 30;

         var offers:Array = state && state.brand_offers ? (state.brand_offers as Array) : new Array();
         if(offers.length == 0)
         {
            var noBr:TextField = SocialMediaTunables.CreateLabel("Switch to Creator/Business or grow followers to receive brand offers.",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW,22);
            noBr.x = 10;
            noBr.y = y;
            canvas.addChild(noBr);
            return y + 32;
         }
         var oIdx:int = 0;
         while(oIdx < offers.length)
         {
            y = RenderBrandOfferCard(canvas,offers[oIdx],simId,y,cardW);
            oIdx++;
         }
         return y + 8;
      }

      private static function MakePeriodButton(simId:String, periodId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label,
            52,
            24,
            active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE,
            active ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnMessagesBtnClick,
            10,
            active ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_period","arg1":periodId}
         );
      }

      private static function RenderBrandOfferCard(canvas:Sprite, offer:Object, simId:String, startY:Number, cardW:Number) : Number
      {
         var oid:String = String(offer.offer_id);
         var st:String = String(offer.status || "offered");
         var card:Sprite = SocialMediaTunables.CreateCard(cardW,68,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);

         var t1:TextField = SocialMediaTunables.CreateLabel(String(offer.brand_name) + "  ·  §" + String(int(offer.payout)) + "  [" + st.toUpperCase() + "]",12,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 20,18);
         t1.x = 10;
         t1.y = 8;
         card.addChild(t1);

         var t2:TextField = SocialMediaTunables.CreateLabel(String(offer.campaign_brief || ""),10,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW - 20,16);
         t2.x = 10;
         t2.y = 26;
         card.addChild(t2);

         if(st == "offered")
         {
            var accB:Sprite = SocialMediaTunables.CreateButton(
               "Accept",
               70,
               22,
               SocialMediaTunables.COL_GREEN,
               0xFFFFFF,
               OnMessagesBtnClick,
               10,
               0,
               {"kind":"cmd","simId":simId,"cmd":"brand_action","arg1":oid,"arg2":"accept"}
            );
            accB.x = 10;
            accB.y = 42;
            card.addChild(accB);

            if(!offer.negotiated)
            {
               var negB:Sprite = SocialMediaTunables.CreateButton(
                  "Negotiate",
                  82,
                  22,
                  SocialMediaTunables.COL_SURFACE_ALT,
                  SocialMediaTunables.COL_BRAND_DARK,
                  OnMessagesBtnClick,
                  10,
                  SocialMediaTunables.COL_BORDER,
                  {"kind":"cmd","simId":simId,"cmd":"brand_action","arg1":oid,"arg2":"negotiate"}
               );
               negB.x = 86;
               negB.y = 42;
               card.addChild(negB);
            }

            var rejB:Sprite = SocialMediaTunables.CreateButton(
               "Decline",
               70,
               22,
               SocialMediaTunables.COL_SURFACE_ALT,
               SocialMediaTunables.COL_DANGER,
               OnMessagesBtnClick,
               10,
               SocialMediaTunables.COL_BORDER,
               {"kind":"cmd","simId":simId,"cmd":"brand_action","arg1":oid,"arg2":"reject"}
            );
            rejB.x = 174;
            rejB.y = 42;
            card.addChild(rejB);
         }
         else if(st == "accepted")
         {
            var pubB:Sprite = SocialMediaTunables.CreateButton(
               "Publish Sponsored Post & Collect §" + String(int(offer.payout)),
               240,
               22,
               SocialMediaTunables.COL_BRAND_BLUE,
               0xFFFFFF,
               OnMessagesBtnClick,
               10,
               0,
               {"kind":"cmd","simId":simId,"cmd":"brand_action","arg1":oid,"arg2":"complete"}
            );
            pubB.x = 10;
            pubB.y = 42;
            card.addChild(pubB);
         }
         return startY + 74;
      }

      protected static function OnMessagesBtnClick(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(!btn || !btn["sbv"])
         {
            return;
         }
         var d:Object = btn["sbv"];
         SocialMediaTunables.SendAction(String(d.simId),String(d.cmd),String(d.arg1 || ""),String(d.arg2 || ""));
      }
   }
}
