package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
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
   import widgets.shared.controls.Console.LegendIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public class SocialMediaPanel extends GUIComponent implements IInputFocusable
   {
      
      public static const PANEL_MODE_FEED:int = 0;
      
      public static const PANEL_MODE_FRIENDS:int = 1;
      
      public static const PANEL_MODE_MESSAGES:int = 2;
      
      protected static const PANEL_HEIGHT:Number = 316;
      
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
      
      protected var mSocialMediaDialogData:SocialMediaDialog;
      
      protected var mPanelTabGroup:SelectableGroup;
      
      protected var mTabPanelMap:Object;
      
      protected var mCurrentPanel:SocialMediaTabPanelBase;
      
      protected var mbInPanelTabSelected:Boolean = false;
      
      protected var mInShow:Boolean;
      
      protected var mTabbingAdapter:BidirectionalGroupAdapter;
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      protected var mbIsClosing:Boolean = false;
      
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
         this.InitGamepad();
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
         var _loc2_:IconComponent = this.mcSimPortrait.mcSimIcon as IconComponent;
         ImageUtils.LoadSimThumbnail(_loc2_,this.mSocialMediaDialogData.sim_id,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         TextUtils.ResizeTextToFit(this.mcSimName.txtSimName,Keys.GENERIC_SIM_NAME_WITH_PREFIX.toString({"simId":this.mSocialMediaDialogData.sim_id}));
         this.mcFollowers.txtFollowers.htmlText = KeysGP.SOCIAL_MEDIA_FOLLOWERS.toString(this.mSocialMediaDialogData.followers_count);
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
         var _loc3_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
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
         if(this.mSocialMediaDialogData.feed_items.length > 0 && _loc3_.FriendsCount > 0)
         {
            this.SetPanel(PANEL_MODE_FEED);
         }
         this.UpdateBadges();
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
      
      public function OnMainHide(param1:Object = null) : void
      {
         this.mbIsClosing = true;
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         this.TeardownPanels();
      }
      
      public function UpdateData(param1:SocialMediaDialog) : void
      {
         if(this.mbIsClosing)
         {
            return;
         }
         this.mSocialMediaDialogData = param1 as SocialMediaDialog;
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         if(this.mcFeedPanel)
         {
            this.UpdateFriendsIds();
            this.mcFeedPanel.OnShow(this.mSocialMediaDialogData.feed_items);
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
         if(this.mSocialMediaDialogData.feed_items.length < 1 && _loc2_.FriendsCount < 1)
         {
            this.btnFeedTabButton.visible = false;
            this.btnFriendsTabButton.visible = false;
            this.btnMessagesTabButton.visible = false;
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabLeft,false);
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabRight,false);
         }
         else
         {
            if(Boolean(SystemUtils.UsingController) && !this.btnFeedTabButton.visible && this.mCurrentPanel != null)
            {
               NavManager.Instance.FocusForward(this.mCurrentPanel.GetTargetInputAdapter());
               _loc3_ = new EnterParams(NavDirection.FORWARD);
               this.EnterTabbingAdapter(_loc3_);
            }
            this.btnFeedTabButton.visible = true;
            this.btnFriendsTabButton.visible = true;
            this.btnMessagesTabButton.visible = true;
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabLeft,true);
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabRight,true);
         }
         if(!this.mbInPanelTabSelected && this.mSocialMediaDialogData.feed_items.length < 1 && _loc2_.FriendsCount > 0)
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
         for each(_loc2_ in this.mSocialMediaDialogData.feed_items)
         {
            _loc2_.friendsIds = _loc1_.FriendsList;
         }
      }
      
      protected function TeardownPanels() : void
      {
         this.CloseReactionPopUps();
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
         this.mCurrentPanel.visible = true;
         if(this.btnFriendsTabButton.name == _loc3_.name)
         {
            (this.mCurrentPanel as SocialMediaFriendsTabPanel).OwnerSimId = this.mSocialMediaDialogData.sim_id;
         }
         this.mCurrentPanel.OnTabShow(this.btnMessagesTabButton.name == _loc3_.name ? this.mSocialMediaDialogData.messages_items : this.mSocialMediaDialogData.feed_items);
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
               _loc3_.OnShow(this.btnMessagesTabButton.name == param1 ? this.mSocialMediaDialogData.messages_items : this.mSocialMediaDialogData.feed_items);
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

