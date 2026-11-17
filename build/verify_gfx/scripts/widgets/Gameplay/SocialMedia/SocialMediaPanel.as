package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gamedata.Gameplay.SocialMedia.SocialMediaDialog;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.controllers.SelectableGroup;
   import olympus.controls.GUIComponent;
   import olympus.controls.IconComponent;
   import olympus.events.GenericEvent;
   import olympus.events.PushButtonEvent;
   import olympus.events.SelectableGroupEvent;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.extensions.MouseKeyboardVisibilityExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.Button;
   import olympus.gui.buttons.TextButton;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.utils.ImageUtils;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   import widgets.shared.controls.Console.LegendIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public class SocialMediaPanel extends GUIComponent implements IInputFocusable
   {
      
      public static const PANEL_MODE_FEED:int = 0;
      
      public static const PANEL_MODE_FRIENDS:int = 1;
      
      public static const PANEL_MODE_MESSAGES:int = 2;
      
      protected static const PANEL_HEIGHT:Number = 316;
      
      protected static const SBV_VIEW_WIDTH:Number = 543;
      
      protected static const SBV_VIEW_HEIGHT:Number = 360;
      
      public var mcBackground:MovieClip;
      
      public var mcSimPortrait:MovieClip;
      
      public var mcSimName:MovieClip;
      
      public var mcFollowers:MovieClip;
      
      public var btnFeedTabButton:TextButton;
      
      public var btnFriendsTabButton:TextButton;
      
      public var btnMessagesTabButton:TextButton;
      
      public var btnClose:Button;
      
      public var mcFeedPanel:SocialMediaTabPanelBase;
      
      public var mcFriendsPanel:SocialMediaTabPanelBase;
      
      public var mcMessagesPanel:SocialMediaTabPanelBase;
      
      public var btnNewPost:TextButton;
      
      public var btnNewEventPost:TextButton;
      
      public var mcControllerTabLeft:LegendIcon;
      
      public var mcControllerTabRight:LegendIcon;
      
      protected var mcPostsBadge:MovieClip;
      
      protected var mcMessagesBadge:MovieClip;
      
      protected var mcVerifiedBadge:Sprite;
      
      protected var mSocialMediaDialogData:SocialMediaDialog;
      
      protected var mPanelTabGroup:SelectableGroup;
      
      protected var mTabPanelMap:Object;
      
      protected var mCurrentPanel:SocialMediaTabPanelBase;
      
      protected var mbInPanelTabSelected:Boolean = false;
      
      protected var mInShow:Boolean;
      
      protected var mTabbingAdapter:BidirectionalGroupAdapter;
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      protected var mbIsClosing:Boolean = false;
      
      protected var mSBVState:Object;
      
      protected var mNativeFeedItems:Array = new Array();
      
      protected var mbNativeMode:Boolean = false;
      
      protected var mSBVActiveTab:String = "home";
      
      protected var mSBVNavBar:Sprite;
      
      protected var mSBVViewport:Sprite;
      
      protected var mSBVMask:Sprite;
      
      protected var mSBVCanvas:Sprite;
      
      protected var mSBVScrollBar:Sprite;
      
      protected var mSBVScrollY:Number = 0;
      
      protected var mSBVContentH:Number = 0;
      
      protected var mSBVModal:Sprite;
      
      public function SocialMediaPanel()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.btnClose.addEventListener(PushButtonEvent.CLICK,this.OnCloseClick,false,0,true);
         MouseKeyboardVisibilityExtension.Add(this.btnClose);
         this.btnNewPost.htmlText = KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON.toString();
         this.btnNewPost.addEventListener(PushButtonEvent.CLICK,this.OnNewPostClick,false,0,true);
         this.btnNewEventPost.htmlText = KeysGP.SOCIAL_MEDIA_NEW_POST_BUTTON.toString();
         this.btnNewEventPost.addEventListener(PushButtonEvent.CLICK,this.OnNewEventPostClick,false,0,true);
         InputModeVisibilityExtension.ShowForController(this.mcControllerTabLeft);
         InputModeVisibilityExtension.ShowForController(this.mcControllerTabRight);
         this.mcControllerTabLeft.ActionCode = ActionCodes.TAB_LEFT;
         this.mcControllerTabRight.ActionCode = ActionCodes.TAB_RIGHT;
         this.mTabPanelMap = new Object();
         var _loc1_:SelectableGroup = new SelectableGroup();
         this.btnFeedTabButton.htmlText = KeysGP.SOCIAL_MEDIA_FEED_TAB_LABEL.toString();
         _loc1_.Add(this.btnFeedTabButton,true);
         this.btnFriendsTabButton.htmlText = KeysGP.SOCIAL_MEDIA_FRIENDS_TAB_LABEL.toString();
         _loc1_.Add(this.btnFriendsTabButton,true);
         this.btnMessagesTabButton.htmlText = KeysGP.SOCIAL_MEDIA_MESSAGES_TAB_LABEL.toString();
         _loc1_.Add(this.btnMessagesTabButton,true);
         _loc1_.addEventListener(SelectableGroupEvent.SELECTION_CHANGED,this.OnPanelTabSelected,false,0,true);
         this.mPanelTabGroup = _loc1_;
         this.mcPostsBadge = this.btnFeedTabButton["mcPostsBadge"];
         this.mcPostsBadge.visible = false;
         this.mcMessagesBadge = this.btnMessagesTabButton["mcMessagesBadge"];
         this.mcMessagesBadge.visible = false;
         this.mcVerifiedBadge = SocialMediaTunables.CreateBadgeSprite(20,true);
         this.addChild(this.mcVerifiedBadge);
         this.InitSBVContainers();
         this.InitGamepad();
      }
      
      protected function InitSBVContainers() : void
      {
         this.mSBVNavBar = new Sprite();
         this.mSBVNavBar.x = 0;
         this.mSBVNavBar.y = 144;
         this.addChild(this.mSBVNavBar);
         this.mSBVViewport = new Sprite();
         this.mSBVViewport.x = 0;
         this.mSBVViewport.y = this.mcBackground.height;
         this.mSBVViewport.mouseEnabled = true;
         this.mSBVViewport.graphics.beginFill(SocialMediaTunables.COL_BG_CANVAS,1);
         this.mSBVViewport.graphics.drawRect(0,0,SBV_VIEW_WIDTH,SBV_VIEW_HEIGHT);
         this.mSBVViewport.graphics.endFill();
         this.mSBVViewport.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnSBVMouseWheel,false,0,true);
         this.addChild(this.mSBVViewport);
         this.mSBVMask = new Sprite();
         this.mSBVMask.mouseEnabled = false;
         this.mSBVMask.graphics.beginFill(16777215,1);
         this.mSBVMask.graphics.drawRect(0,0,SBV_VIEW_WIDTH,SBV_VIEW_HEIGHT);
         this.mSBVMask.graphics.endFill();
         this.mSBVViewport.addChild(this.mSBVMask);
         this.mSBVCanvas = new Sprite();
         this.mSBVCanvas.mask = this.mSBVMask;
         this.mSBVViewport.addChild(this.mSBVCanvas);
         this.mSBVScrollBar = new Sprite();
         this.mSBVScrollBar.mouseEnabled = false;
         this.mSBVScrollBar.x = SBV_VIEW_WIDTH - 8;
         this.mSBVScrollBar.y = this.mcBackground.height + 4;
         this.addChild(this.mSBVScrollBar);
         this.mSBVModal = new Sprite();
         this.mSBVModal.visible = false;
         this.addChild(this.mSBVModal);
      }
      
      protected function OnSBVMouseWheel(param1:MouseEvent) : void
      {
         if(this.mbNativeMode)
         {
            return;
         }
         var maxScroll:Number = Math.max(0,this.mSBVContentH - SBV_VIEW_HEIGHT);
         this.mSBVScrollY = Math.max(0,Math.min(maxScroll,this.mSBVScrollY - param1.delta * 26));
         this.mSBVCanvas.y = -this.mSBVScrollY;
         this.DrawSBVScrollThumb();
      }
      
      protected function DrawSBVScrollThumb() : void
      {
         this.mSBVScrollBar.graphics.clear();
         if(this.mbNativeMode || this.mSBVContentH <= SBV_VIEW_HEIGHT)
         {
            return;
         }
         var trackH:Number = SBV_VIEW_HEIGHT - 8;
         this.mSBVScrollBar.graphics.beginFill(SocialMediaTunables.COL_BORDER,0.5);
         this.mSBVScrollBar.graphics.drawRoundRect(0,0,5,trackH,3,3);
         this.mSBVScrollBar.graphics.endFill();
         var thumbH:Number = Math.max(28,SBV_VIEW_HEIGHT / this.mSBVContentH * trackH);
         var maxScroll:Number = Math.max(1,this.mSBVContentH - SBV_VIEW_HEIGHT);
         var thumbY:Number = this.mSBVScrollY / maxScroll * (trackH - thumbH);
         this.mSBVScrollBar.graphics.beginFill(SocialMediaTunables.COL_TEXT_MUTED,0.85);
         this.mSBVScrollBar.graphics.drawRoundRect(0,thumbY,5,thumbH,3,3);
         this.mSBVScrollBar.graphics.endFill();
      }
      
      protected function HandleSetModalVisible(param1:Object) : void
      {
         var _loc2_:int = CommunicationManager.CallUIService("NumberOfModals") as int;
         var _loc3_:Boolean = CommunicationManager.CallUIService("IsWidgetTopModal","SocialMedia") as Boolean;
         var _loc4_:Boolean = _loc2_ == 0 || _loc3_ && _loc2_ == 1;
         if(_loc4_ != visible)
         {
            visible = _loc4_;
            CommunicationManager.CallUIService("SetWidgetModality",{
               "widgetName":"SocialMedia",
               "bOn":_loc4_
            });
         }
      }
      
      public function Initialize() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.mTabPanelMap;
         for each(_loc2_ in _loc1_)
         {
            (_loc2_.panel as SocialMediaTabPanelBase).Initialize();
         }
      }
      
      public function OnMainShow(param1:Object = null) : void
      {
         var extracted:Object;
         var _loc2_:IconComponent;
         var _loc3_:SocialMediaFriendsTabPanel;
         var _loc4_:EnterParams = null;
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         CommunicationManager.AddMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         this.mSocialMediaDialogData = new SocialMediaDialog(param1);
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         this.mbIsClosing = false;
         this.mInShow = true;
         this.mbNativeMode = false;
         this.mSBVScrollY = 0;
         extracted = null;
         try
         {
            extracted = SocialMediaTunables.ExtractSBVState(this.mSocialMediaDialogData.feed_items);
            this.mNativeFeedItems = extracted.nativeItems as Array;
            this.mSBVState = extracted.sbvState;
            if(this.mSBVState && this.mSBVState.active_tab)
            {
               this.mSBVActiveTab = String(this.mSBVState.active_tab);
            }
         }
         catch(err:Error)
         {
            this.mNativeFeedItems = this.mSocialMediaDialogData.feed_items ? this.mSocialMediaDialogData.feed_items : new Array();
            this.mSBVState = null;
            this.mbNativeMode = true;
         }
         _loc2_ = this.mcSimPortrait.mcSimIcon as IconComponent;
         ImageUtils.LoadSimThumbnail(_loc2_,this.mSocialMediaDialogData.sim_id,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         this.UpdateHeaderIdentity();
         this.btnNewEventPost.enabled = this.mSocialMediaDialogData.can_make_context_post;
         if(!this.btnNewEventPost.enabled)
         {
            this.btnNewEventPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_POST_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewEventPost.TooltipExt.Clear();
         }
         this.SetPanel(PANEL_MODE_FRIENDS);
         _loc3_ = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc3_ == null)
         {
            this.mInShow = false;
            return;
         }
         _loc3_.removeEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout);
         _loc3_.addEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout,false,0,true);
         this.btnNewPost.enabled = _loc3_.FriendsCount > 0;
         if(!this.btnNewPost.enabled)
         {
            this.btnNewPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewPost.TooltipExt.Clear();
         }
         this.RefreshLayout();
         if(this.mNativeFeedItems.length > 0 && _loc3_.FriendsCount > 0)
         {
            this.SetPanel(PANEL_MODE_FEED);
         }
         this.UpdateBadges();
         this.RefreshSBVView();
         if(SystemUtils.UsingController)
         {
            if(this.btnFeedTabButton.visible)
            {
               _loc4_ = new EnterParams(NavDirection.FORWARD,null,{"skipConfirm":true});
               this.EnterTabbingAdapter(_loc4_);
            }
         }
         this.mInShow = false;
      }
      
      protected function UpdateHeaderIdentity() : void
      {
         var simId:String = this.mSocialMediaDialogData ? this.mSocialMediaDialogData.sim_id : "";
         TextUtils.ResizeTextToFit(this.mcSimName.txtSimName,Keys.GENERIC_SIM_NAME_WITH_PREFIX.toString({"simId":simId}));
         var viewer:Object = this.mSBVState && this.mSBVState.viewer ? this.mSBVState.viewer : null;
         var badgeKind:String = viewer ? String(viewer.badge || "none") : "none";
         var tipStr:String = viewer ? (String(viewer.category_label || "Personal")) + " · " + (String(viewer.standing || "Neutral")) : "";
         if(this.mcVerifiedBadge)
         {
            SocialMediaTunables.UpdateBadgeSprite(this.mcVerifiedBadge,badgeKind,tipStr);
            this.mcVerifiedBadge.x = this.mcSimName.x + this.mcSimName.txtSimName.textWidth * 0.5 + 10;
            this.mcVerifiedBadge.y = this.mcSimName.y + 4;
         }
         if(viewer)
         {
            this.mcFollowers.txtFollowers.htmlText = "@" + String(viewer.username) + "  ·  " + String(int(viewer.followers)) + " Followers  ·  Rep " + String(int(viewer.reputation));
         }
         else
         {
            this.mcFollowers.txtFollowers.htmlText = KeysGP.SOCIAL_MEDIA_FOLLOWERS.toString(this.mSocialMediaDialogData.followers_count);
         }
      }
      
      public function OnMainHide(param1:Object = null) : void
      {
         this.mbIsClosing = true;
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         this.TeardownPanels();
      }
      
      public function UpdateData(param1:SocialMediaDialog) : void
      {
         var extracted:Object;
         if(this.mbIsClosing)
         {
            return;
         }
         this.mSocialMediaDialogData = param1 as SocialMediaDialog;
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         extracted = null;
         try
         {
            extracted = SocialMediaTunables.ExtractSBVState(this.mSocialMediaDialogData.feed_items);
            this.mNativeFeedItems = extracted.nativeItems as Array;
            this.mSBVState = extracted.sbvState;
            if(this.mSBVState && this.mSBVState.active_tab)
            {
               this.mSBVActiveTab = String(this.mSBVState.active_tab);
            }
         }
         catch(err:Error)
         {
            this.mNativeFeedItems = this.mSocialMediaDialogData.feed_items ? this.mSocialMediaDialogData.feed_items : new Array();
            this.mSBVState = null;
            this.mbNativeMode = true;
         }
         this.UpdateHeaderIdentity();
         if(this.mcFeedPanel)
         {
            this.UpdateFriendsIds();
            this.mcFeedPanel.OnShow(this.mNativeFeedItems);
         }
         if(this.mcMessagesPanel)
         {
            this.mcMessagesPanel.OnShow(this.mSocialMediaDialogData.messages_items);
         }
         this.btnNewEventPost.enabled = this.mSocialMediaDialogData.can_make_context_post;
         if(!this.btnNewEventPost.enabled)
         {
            this.btnNewEventPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_POST_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewEventPost.TooltipExt.Clear();
         }
         this.RefreshLayout();
         this.RefreshSBVView();
      }
      
      public function SwitchToNativeTab(mode:int) : void
      {
         this.mbNativeMode = true;
         this.mSBVViewport.visible = false;
         this.mSBVScrollBar.visible = false;
         this.SetPanel(mode);
         this.RenderSBVNavBar();
      }
      
      public function RefreshSBVView() : void
      {
         var simId:String;
         var tab:String;
         var endY:Number;
         var maxScroll:Number;
         if(this.mbIsClosing || !this.mSocialMediaDialogData)
         {
            return;
         }
         try
         {
            this.RenderSBVNavBar();
            if(this.mbNativeMode || this.mSBVState == null)
            {
               this.mSBVViewport.visible = false;
               this.mSBVScrollBar.visible = false;
               if(this.mCurrentPanel)
               {
                  this.mCurrentPanel.visible = true;
               }
               return;
            }
            this.mSBVViewport.visible = true;
            this.mSBVScrollBar.visible = true;
            if(this.mCurrentPanel)
            {
               this.mCurrentPanel.visible = false;
            }
            while(this.mSBVCanvas.numChildren > 0)
            {
               this.mSBVCanvas.removeChildAt(0);
            }
            simId = this.mSocialMediaDialogData.sim_id;
            tab = this.mSBVActiveTab;
            endY = 100;
            if(tab == "explore")
            {
               endY = SocialMediaFriendsTabPanel.RenderSBVExplore(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else if(tab == "notifications")
            {
               endY = SocialMediaMessagesTabPanel.RenderSBVNotifications(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else if(tab == "profile")
            {
               endY = SocialMediaFriendsTabPanel.RenderSBVProfile(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else if(tab == "dashboard")
            {
               endY = SocialMediaMessagesTabPanel.RenderSBVDashboard(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else if(tab == "verify")
            {
               endY = SocialMediaReactionPopUp.RenderSBVVerification(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else if(tab == "settings")
            {
               endY = SocialMediaReactionPopUp.RenderSBVSettings(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            else
            {
               endY = SocialMediaFeedTabPanel.RenderSBVHome(this,this.mSBVCanvas,this.mSBVState,simId);
            }
            this.mSBVContentH = Math.max(SBV_VIEW_HEIGHT,endY + 12);
            maxScroll = Math.max(0,this.mSBVContentH - SBV_VIEW_HEIGHT);
            if(this.mSBVScrollY > maxScroll)
            {
               this.mSBVScrollY = maxScroll;
            }
            this.mSBVCanvas.y = -this.mSBVScrollY;
            this.DrawSBVScrollThumb();
         }
         catch(err:Error)
         {
            this.mbNativeMode = true;
            this.mSBVViewport.visible = false;
            this.mSBVScrollBar.visible = false;
            if(this.mCurrentPanel)
            {
               this.mCurrentPanel.visible = true;
            }
         }
      }
      
      protected function RenderSBVNavBar() : void
      {
         while(this.mSBVNavBar.numChildren > 0)
         {
            this.mSBVNavBar.removeChildAt(0);
         }
         var simId:String = this.mSocialMediaDialogData ? this.mSocialMediaDialogData.sim_id : "";
         var unread:int = 0;
         if(this.mSBVState && this.mSBVState.notifications)
         {
            unread = int(this.mSBVState.notifications.unread);
         }
         var tabs:Array = [{
            "id":"home",
            "label":"Home"
         },{
            "id":"explore",
            "label":"Explore"
         },{
            "id":"notifications",
            "label":(unread > 0 ? "Alerts (" + unread + ")" : "Alerts")
         },{
            "id":"profile",
            "label":"Profile"
         },{
            "id":"dashboard",
            "label":"Pro"
         },{
            "id":"settings",
            "label":"Settings / DMs"
         }];
         var tabW:Number = 84;
         var xPos:Number = 12;
         var i:int = 0;
         while(i < tabs.length)
         {
            var tObj:Object = tabs[i];
            var isAct:Boolean = !this.mbNativeMode && (this.mSBVActiveTab == tObj.id || tObj.id == "settings" && this.mSBVActiveTab == "verify");
            var btn:Sprite = this.MakeNavTabButton(simId,tObj.id,tObj.label,tabW,isAct);
            btn.x = xPos;
            btn.y = 2;
            this.mSBVNavBar.addChild(btn);
            xPos += tabW + 3;
            i++;
         }
      }
      
      private function MakeNavTabButton(simId:String, tabId:String, label:String, w:Number, active:Boolean) : Sprite
      {
         var panelRef:SocialMediaPanel = this;
         return SocialMediaTunables.CreateButton(label,w,26,active ? SocialMediaTunables.COL_BRAND_BLUE : SocialMediaTunables.COL_SURFACE,active ? 16777215 : SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            panelRef.mbNativeMode = false;
            panelRef.mSBVScrollY = 0;
            panelRef.mSBVActiveTab = tabId;
            if(tabId == "profile")
            {
               SocialMediaTunables.SendAction(simId,"open_profile",simId);
            }
            else
            {
               SocialMediaTunables.SendAction(simId,"set_tab",tabId);
            }
         },10,active ? 0 : SocialMediaTunables.COL_BORDER);
      }
      
      public function OpenCommentModal(post:Object) : void
      {
         var simId:String;
         var postId:String;
         var card:Sprite;
         var titleTf:TextField;
         var closeM:Sprite;
         var bodyTf:TextField;
         var comments:Array;
         var cy:Number;
         var ci:int;
         var cObj:Object;
         var cid:String;
         var cTf:TextField;
         var dBtn:Sprite;
         var cInp:Sprite;
         var sendBtn:Sprite;
         if(!this.mSocialMediaDialogData)
         {
            return;
         }
         simId = this.mSocialMediaDialogData.sim_id;
         postId = String(post.post_id);
         this.ClearSBVModal();
         this.mSBVModal.visible = true;
         this.mSBVModal.graphics.clear();
         this.mSBVModal.graphics.beginFill(0,0.45);
         this.mSBVModal.graphics.drawRect(0,0,SBV_VIEW_WIDTH,this.mcBackground.height + SBV_VIEW_HEIGHT);
         this.mSBVModal.graphics.endFill();
         card = SocialMediaTunables.CreateCard(460,340,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,12);
         card.x = 41;
         card.y = 120;
         this.mSBVModal.addChild(card);
         titleTf = SocialMediaTunables.CreateLabel("Comments on @" + String(post.author_username),13,SocialMediaTunables.COL_TEXT_PRIMARY,true,360,20);
         titleTf.x = 14;
         titleTf.y = 12;
         card.addChild(titleTf);
         closeM = SocialMediaTunables.CreateButton("Close",60,22,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            ClearSBVModal();
         },10,SocialMediaTunables.COL_BORDER);
         closeM.x = 386;
         closeM.y = 12;
         card.addChild(closeM);
         bodyTf = SocialMediaTunables.CreateLabel(String(post.content || ""),11,SocialMediaTunables.COL_TEXT_SECONDARY,false,432,36,true);
         bodyTf.x = 14;
         bodyTf.y = 38;
         card.addChild(bodyTf);
         comments = post.comments ? post.comments as Array : new Array();
         cy = 82;
         ci = Math.max(0,comments.length - 5);
         while(ci < comments.length)
         {
            cObj = comments[ci];
            cid = String(cObj.comment_id);
            cTf = SocialMediaTunables.CreateLabel("@" + String(cObj.author_username) + ": " + String(cObj.text),11,SocialMediaTunables.COL_TEXT_PRIMARY,false,360,30,true);
            cTf.x = 14;
            cTf.y = cy;
            card.addChild(cTf);
            if(String(cObj.author_sim_id) == simId || String(post.author_sim_id) == simId)
            {
               dBtn = MakeDeleteCommentButton(simId,postId,cid);
               dBtn.x = 388;
               dBtn.y = cy;
               card.addChild(dBtn);
            }
            cy += 34;
            ci++;
         }
         cInp = SocialMediaTunables.CreateInputBox("",338,34,false,200);
         cInp.x = 14;
         cInp.y = 290;
         card.addChild(cInp);
         sendBtn = SocialMediaTunables.CreateButton("Reply",86,34,SocialMediaTunables.COL_BRAND_BLUE,16777215,function(e:MouseEvent):void
         {
            var tf:TextField = cInp["tf"] as TextField;
            var txt:String = tf ? tf.text : "";
            if(txt != "" && txt != null)
            {
               SocialMediaTunables.SendAction(simId,"comment",postId,txt);
               ClearSBVModal();
            }
         },11);
         sendBtn.x = 360;
         sendBtn.y = 290;
         card.addChild(sendBtn);
      }
      
      private function MakeDeleteCommentButton(simId:String, postId:String, commentId:String) : Sprite
      {
         return SocialMediaTunables.CreateButton("Del",50,20,16704226,SocialMediaTunables.COL_DANGER,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"delete_comment",postId,commentId);
            ClearSBVModal();
         },9);
      }
      
      public function OpenReportModal(targetSimId:String, postId:String) : void
      {
         var simId:String;
         var card:Sprite;
         var titleTf:TextField;
         var closeM:Sprite;
         var reasons:Array;
         var ry:Number;
         var ri:int;
         var rObj:Object;
         var rBtn:Sprite;
         if(!this.mSocialMediaDialogData)
         {
            return;
         }
         simId = this.mSocialMediaDialogData.sim_id;
         this.ClearSBVModal();
         this.mSBVModal.visible = true;
         this.mSBVModal.graphics.clear();
         this.mSBVModal.graphics.beginFill(0,0.45);
         this.mSBVModal.graphics.drawRect(0,0,SBV_VIEW_WIDTH,this.mcBackground.height + SBV_VIEW_HEIGHT);
         this.mSBVModal.graphics.endFill();
         card = SocialMediaTunables.CreateCard(360,210,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,12);
         card.x = 91;
         card.y = 170;
         this.mSBVModal.addChild(card);
         titleTf = SocialMediaTunables.CreateLabel("Report Post / Account",13,SocialMediaTunables.COL_TEXT_PRIMARY,true,260,20);
         titleTf.x = 14;
         titleTf.y = 12;
         card.addChild(titleTf);
         closeM = SocialMediaTunables.CreateButton("Cancel",60,22,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            ClearSBVModal();
         },10,SocialMediaTunables.COL_BORDER);
         closeM.x = 286;
         closeM.y = 12;
         card.addChild(closeM);
         reasons = [{
            "id":"harassment",
            "label":"Harassment"
         },{
            "id":"misinformation",
            "label":"Misinformation"
         },{
            "id":"spam",
            "label":"Spam"
         },{
            "id":"hate_speech",
            "label":"Community Violation"
         }];
         ry = 48;
         ri = 0;
         while(ri < reasons.length)
         {
            rObj = reasons[ri];
            rBtn = MakeReportReasonButton(simId,targetSimId,postId,rObj.id,rObj.label);
            rBtn.x = 14;
            rBtn.y = ry;
            card.addChild(rBtn);
            ry += 36;
            ri++;
         }
      }
      
      private function MakeReportReasonButton(simId:String, targetId:String, postId:String, reasonId:String, label:String) : Sprite
      {
         return SocialMediaTunables.CreateButton(label,332,28,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"report",targetId,reasonId,postId);
            ClearSBVModal();
         },11,SocialMediaTunables.COL_BORDER);
      }
      
      protected function ClearSBVModal() : void
      {
         this.mSBVModal.visible = false;
         this.mSBVModal.graphics.clear();
         while(this.mSBVModal.numChildren > 0)
         {
            this.mSBVModal.removeChildAt(0);
         }
      }
      
      protected function UpdateBadges() : void
      {
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         this.mcPostsBadge.visible = Boolean(this.mSocialMediaDialogData.has_new_posts) && Boolean(this.btnFeedTabButton.visible);
         this.mcMessagesBadge.visible = Boolean(this.mSocialMediaDialogData.has_new_messages) && Boolean(this.btnMessagesTabButton.visible);
      }
      
      protected function RefreshLayout(param1:Event = null) : void
      {
         var _loc3_:EnterParams = null;
         if(this.mbIsClosing || this.mSocialMediaDialogData == null)
         {
            return;
         }
         var _loc2_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc2_ == null)
         {
            return;
         }
         this.btnFeedTabButton.visible = false;
         this.btnFriendsTabButton.visible = false;
         this.btnMessagesTabButton.visible = false;
         InputModeVisibilityExtension.SetVisible(this.mcControllerTabLeft,false);
         InputModeVisibilityExtension.SetVisible(this.mcControllerTabRight,false);
         if(!this.mbInPanelTabSelected && this.mNativeFeedItems.length < 1 && _loc2_.FriendsCount > 0)
         {
            this.SetPanel(PANEL_MODE_FEED);
         }
         this.UpdateFriendsIds();
         this.btnNewPost.enabled = _loc2_.FriendsCount > 0;
         if(!this.btnNewPost.enabled)
         {
            this.btnNewPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewPost.TooltipExt.Clear();
         }
         this.UpdateBadges();
      }
      
      protected function UpdateFriendsIds() : void
      {
         var _loc2_:SocialMediaFeedItem = null;
         if(this.mbIsClosing || this.mSocialMediaDialogData == null)
         {
            return;
         }
         var _loc1_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc1_ == null)
         {
            return;
         }
         for each(_loc2_ in this.mNativeFeedItems)
         {
            _loc2_.friendsIds = _loc1_.FriendsList;
         }
      }
      
      protected function TeardownPanels() : void
      {
         this.CloseReactionPopUps();
         this.ClearSBVModal();
         var _loc1_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc1_)
         {
            _loc1_.removeEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout);
            _loc1_.Dispose();
         }
         if(Boolean(this.mcFeedPanel) && this.mcFeedPanel.parent == this)
         {
            this.removeChild(this.mcFeedPanel);
         }
         this.mcFeedPanel = null;
         if(Boolean(this.mcFriendsPanel) && this.mcFriendsPanel.parent == this)
         {
            this.removeChild(this.mcFriendsPanel);
         }
         this.mcFriendsPanel = null;
         if(Boolean(this.mcMessagesPanel) && this.mcMessagesPanel.parent == this)
         {
            this.removeChild(this.mcMessagesPanel);
         }
         this.mcMessagesPanel = null;
         this.mbInPanelTabSelected = false;
         this.mInShow = false;
         this.mCurrentPanel = null;
         this.mPanelTabGroup.ClearSelection();
         this.mTabPanelMap = new Object();
      }
      
      protected function SeenNewPosts() : void
      {
         if(!this.mSocialMediaDialogData.has_new_posts)
         {
            return;
         }
         CommunicationManager.PostServerCommand("social_media.social_media_mark_posts_seen",this.mSocialMediaDialogData.sim_id);
         this.mSocialMediaDialogData.has_new_posts = false;
         this.UpdateBadges();
      }
      
      protected function SeenNewMessages() : void
      {
         if(!this.mSocialMediaDialogData.has_new_messages)
         {
            return;
         }
         CommunicationManager.PostServerCommand("social_media.social_media_mark_messages_seen",this.mSocialMediaDialogData.sim_id);
         this.mSocialMediaDialogData.has_new_messages = false;
         this.UpdateBadges();
      }
      
      protected function OnCloseClick(param1:PushButtonEvent) : void
      {
         this.Close();
      }
      
      protected function Close() : void
      {
         if(this.mbIsClosing)
         {
            return;
         }
         this.mbIsClosing = true;
         var _loc1_:SocialMediaTabPanelBase = this.mCurrentPanel;
         this.TeardownPanels();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mTabbingAdapter.Exit();
         }
         if(Boolean(SystemUtils.UsingController) && (NavManager.Instance.CurrentFocusable == this.mTabbingAdapter || NavManager.Instance.CurrentFocusable == this.mMainAdapter || _loc1_ != null && _loc1_.IsFocused()))
         {
            NavManager.Instance.FocusBack();
         }
         dispatchEvent(new GenericEvent(GenericEvent.CLOSE));
      }
      
      protected function OnPanelTabSelected(param1:SelectableGroupEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:SocialMediaTabPanelBase = null;
         if(this.mbIsClosing)
         {
            return;
         }
         this.mbInPanelTabSelected = true;
         var _loc2_:Button = param1.deselectedComponent as Button;
         if(_loc2_)
         {
            _loc5_ = this.mTabPanelMap[_loc2_.name];
            if(_loc5_)
            {
               _loc6_ = _loc5_["panel"] as SocialMediaTabPanelBase;
               _loc6_.visible = false;
               _loc6_.OnTabHide();
            }
            if(_loc2_ == this.btnFeedTabButton)
            {
               this.SeenNewPosts();
            }
            if(_loc2_ == this.btnMessagesTabButton)
            {
               this.SeenNewMessages();
            }
         }
         var _loc3_:Button = param1.selectedComponent as Button;
         var _loc4_:Object = this.FindOrCreateTabPanel(_loc3_.name);
         this.mCurrentPanel = _loc4_["panel"] as SocialMediaTabPanelBase;
         this.mCurrentPanel.visible = this.mbNativeMode;
         if(this.btnFriendsTabButton.name == _loc3_.name)
         {
            (this.mCurrentPanel as SocialMediaFriendsTabPanel).OwnerSimId = this.mSocialMediaDialogData.sim_id;
         }
         this.mCurrentPanel.OnTabShow(this.btnMessagesTabButton.name == _loc3_.name ? this.mSocialMediaDialogData.messages_items : this.mNativeFeedItems);
         if(Boolean(SystemUtils.UsingConsoleInputMode) && !this.mInShow)
         {
            NavManager.Instance.FocusPan(this.mCurrentPanel.GetTargetInputAdapter());
         }
         this.mbInPanelTabSelected = false;
      }
      
      protected function FindOrCreateTabPanel(param1:String) : Object
      {
         var _loc3_:SocialMediaTabPanelBase = null;
         var _loc2_:Object = this.mTabPanelMap[param1];
         if(!_loc2_)
         {
            _loc2_ = this.CreateTabPanel(this.GetModeFromButtonName(param1));
            if(_loc2_)
            {
               _loc3_ = _loc2_.panel as SocialMediaTabPanelBase;
               _loc3_.y = this.mcBackground.height;
               _loc3_.Initialize();
               _loc3_.ResizePanel(this.mcBackground.width,PANEL_HEIGHT);
               _loc3_.OnShow(this.btnMessagesTabButton.name == param1 ? this.mSocialMediaDialogData.messages_items : this.mNativeFeedItems);
               if(SystemUtils.UsingConsoleInputMode)
               {
                  _loc3_.OnInputEventCall(InputAdapterEvent.LEAVE,this.HandlePanelLeave);
                  _loc3_.OnInputEventCall(InputAdapterEvent.BACK,this.Close);
               }
            }
         }
         return _loc2_;
      }
      
      protected function CreateTabPanel(param1:int) : Object
      {
         var _loc2_:int = this.getChildIndex(this.mcBackground) + 1;
         switch(param1)
         {
            case PANEL_MODE_FEED:
               this.mcFeedPanel = new SocialMediaFeedTabPanel();
               this.addChildAt(this.mcFeedPanel,_loc2_);
               this.mTabPanelMap[this.btnFeedTabButton.name] = {
                  "panel":this.mcFeedPanel,
                  "mode":PANEL_MODE_FEED
               };
               return this.mTabPanelMap[this.btnFeedTabButton.name];
            case PANEL_MODE_FRIENDS:
               this.mcFriendsPanel = new SocialMediaFriendsTabPanel(this.mSocialMediaDialogData.sim_id);
               (this.mcFriendsPanel as SocialMediaFriendsTabPanel).mbCanAddNewContacts = this.mSocialMediaDialogData.can_add_contacts;
               this.addChildAt(this.mcFriendsPanel,_loc2_);
               this.mTabPanelMap[this.btnFriendsTabButton.name] = {
                  "panel":this.mcFriendsPanel,
                  "mode":PANEL_MODE_FRIENDS
               };
               return this.mTabPanelMap[this.btnFriendsTabButton.name];
            case PANEL_MODE_MESSAGES:
               this.mcMessagesPanel = new SocialMediaMessagesTabPanel();
               this.addChildAt(this.mcMessagesPanel,_loc2_);
               this.mTabPanelMap[this.btnMessagesTabButton.name] = {
                  "panel":this.mcMessagesPanel,
                  "mode":PANEL_MODE_MESSAGES
               };
               return this.mTabPanelMap[this.btnMessagesTabButton.name];
            default:
               return null;
         }
      }
      
      protected function GetModeFromButtonName(param1:String) : int
      {
         switch(param1)
         {
            case this.btnFeedTabButton.name:
               return PANEL_MODE_FEED;
            case this.btnFriendsTabButton.name:
               return PANEL_MODE_FRIENDS;
            case this.btnMessagesTabButton.name:
               return PANEL_MODE_MESSAGES;
            default:
               return -1;
         }
      }
      
      protected function SetPanel(param1:int) : void
      {
         var _loc2_:Button = null;
         switch(param1)
         {
            case PANEL_MODE_FRIENDS:
               _loc2_ = this.btnFriendsTabButton;
               break;
            case PANEL_MODE_MESSAGES:
               _loc2_ = this.btnMessagesTabButton;
               break;
            case PANEL_MODE_FEED:
            default:
               _loc2_ = this.btnFeedTabButton;
         }
         _loc2_.dispatchEvent(new PushButtonEvent(PushButtonEvent.CLICK));
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mTabbingAdapter.SetHighlightedObject(_loc2_);
         }
      }
      
      protected function OnNewPostClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_post_picker_interaction,this.mSocialMediaDialogData.sim_id,this.mSocialMediaDialogData.sim_id);
      }
      
      protected function OnNewEventPostClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_event_post_picker_interaction,this.mSocialMediaDialogData.sim_id,this.mSocialMediaDialogData.sim_id);
      }
      
      protected function InitGamepad() : void
      {
         if(!SystemUtils.UsingConsoleInputMode)
         {
            return;
         }
         this.mMainAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnNewEventPost,this.btnNewPost],true);
         this.mMainAdapter.OnBackCall(this.Close);
         this.mMainAdapter.SetHighlightClosestOnEnter(true);
         this.mMainAdapter.OnLeaveCall(this.HandleMainLeave);
         this.mTabbingAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnFeedTabButton,this.btnFriendsTabButton,this.btnMessagesTabButton]);
         this.mTabbingAdapter.SetTabbingSelectionMode(true);
      }
      
      protected function HandleMainLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.DOWN && this.mCurrentPanel != null)
         {
            NavManager.Instance.FocusPan(this.mCurrentPanel.GetTargetInputAdapter(),param1.CreateEnterParams());
         }
      }
      
      protected function HandlePanelLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.UP)
         {
            NavManager.Instance.FocusPan(this.mMainAdapter,param1.CreateEnterParams());
         }
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         if(this.mCurrentPanel == null)
         {
            return this;
         }
         return this.mCurrentPanel.Enter(param1);
      }
      
      public function Exit() : void
      {
         if(this.mMainAdapter != null)
         {
            this.mMainAdapter.Exit();
         }
         if(this.mCurrentPanel != null)
         {
            this.mCurrentPanel.Exit();
         }
      }
      
      protected function EnterTabbingAdapter(param1:EnterParams = null) : void
      {
         this.mTabbingAdapter.Enter(param1);
         var _loc2_:InputAction = this.mTabbingAdapter.GetFirstInputAction(ActionCodes.TAB_LEFT);
         _loc2_.SetValidCheck(this.TabbingValidCheck);
         var _loc3_:InputAction = this.mTabbingAdapter.GetFirstInputAction(ActionCodes.TAB_RIGHT);
         _loc3_.SetValidCheck(this.TabbingValidCheck);
      }
      
      protected function TabbingValidCheck() : Boolean
      {
         if(this.mCurrentPanel == null || NavManager.Instance.CurrentFocusable != this.mCurrentPanel.GetTargetInputAdapter())
         {
            return false;
         }
         if(Boolean(this.btnFeedTabButton) && Boolean(this.btnFeedTabButton.visible))
         {
            return true;
         }
         if(Boolean(this.btnFriendsTabButton) && Boolean(this.btnFriendsTabButton.visible))
         {
            return true;
         }
         if(Boolean(this.btnMessagesTabButton) && Boolean(this.btnMessagesTabButton.visible))
         {
            return true;
         }
         return false;
      }
      
      public function CloseReactionPopUps() : void
      {
         if(this.mcFeedPanel is SocialMediaFeedTabPanel)
         {
            SocialMediaFeedTabPanel(this.mcFeedPanel).CloseReactionPopUps();
         }
         if(this.mcMessagesPanel is SocialMediaMessagesTabPanel)
         {
            SocialMediaMessagesTabPanel(this.mcMessagesPanel).CloseReactionPopUps();
         }
      }
   }
}

