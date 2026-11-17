package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import gamedata.Gameplay.SimInfoHUD.DataFeeds.RelationshipDataFeed;
   import gamedata.Gameplay.shared.definitions.RelationshipFilterTypes;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.events.DataFeedEvent;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.TextButton;
   import olympus.input.IInputAdapter;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import olympus.objects.RelationshipByIdInfo;
   import olympus.objects.RelationshipDeleteById;
   import olympus.objects.RelationshipInfo;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol102")]
   public class SocialMediaFriendsTabPanel extends SocialMediaTabPanelBase
   {
      
      public static const FRIENDS_UPDATED:String = "friends_updated";
      
      public var btnAddToContactList:TextButton;
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcEmptyStateBackground:MovieClip;
      
      public var mbCanAddNewContacts:Boolean;
      
      protected var mFriendsCount:int = 0;
      
      protected var mFriendsList:Array = new Array();
      
      protected var mData:RelationshipDataFeed = new RelationshipDataFeed();
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      protected var mSimId:String;
      
      public function SocialMediaFriendsTabPanel(param1:String)
      {
         super();
         this.mSimId = param1;
      }
      
      public function get FriendsCount() : int
      {
         return this.mFriendsCount;
      }
      
      public function get FriendsList() : Array
      {
         return this.mFriendsList;
      }
      
      public function set OwnerSimId(param1:String) : void
      {
         this.mSimId = param1;
         this.LoadFriends();
         this.RefreshLayout();
      }
      
      override public function Initialize() : void
      {
         this.btnAddToContactList.htmlText = KeysGP.SOCIAL_MEDIA_NEW_FRIEND_BUTTON_LABEL.toString();
         this.btnAddToContactList.addEventListener(PushButtonEvent.CLICK,this.OnAddToContactListClick,false,0,true);
         var _loc1_:GridLayout = new GridLayout(false,true,1);
         mcList.mSlider.AlwaysVisible = false;
         mcList.InitializeScrollList(this.mData,SocialMediaFriendCellView,SocialMediaTunables.FRIENDS_LIST_CELL_PADDING,SocialMediaTunables.FRIENDS_SCROLLBAR_PADDING,_loc1_);
         this.txtEmptyStateTitle.htmlText = KeysGP.SOCIAL_MEDIA_EMPTY_STATE_TITLE.toString();
         this.txtEmptyStateTitle.visible = false;
         this.txtEmptyStateDescription.htmlText = KeysGP.SOCIAL_MEDIA_EMPTY_STATE_DESCRIPTION.toString();
         this.txtEmptyStateDescription.visible = false;
         this.mcEmptyStateBackground.visible = false;
         this.mData.addEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false,0,true);
         CommunicationManager.AddMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationshipData,this,RelationshipByIdInfo);
         CommunicationManager.AddMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationshipData,this,RelationshipDeleteById);
         CommunicationManager.AddMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationship,this,RelationshipByIdInfo);
         CommunicationManager.AddMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationship,this,RelationshipDeleteById);
         CommunicationManager.AddMessageListener("NoMoreContactsToAdd",this.HandleNoMoreContactsToAdd,this);
         CommunicationManager.AddMessageListener("MoreContactsToAdd",this.HandleMoreContactsToAdd,this);
         super.Initialize();
      }
      
      public function Dispose() : void
      {
         this.btnAddToContactList.removeEventListener(PushButtonEvent.CLICK,this.OnAddToContactListClick);
         CommunicationManager.RemoveMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationshipData,this);
         CommunicationManager.RemoveMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationshipData,this);
         CommunicationManager.RemoveMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationship,this);
         CommunicationManager.RemoveMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationship,this);
         CommunicationManager.RemoveMessageListener("NoMoreContactsToAdd",this.HandleNoMoreContactsToAdd,this);
         CommunicationManager.RemoveMessageListener("MoreContactsToAdd",this.HandleMoreContactsToAdd,this);
         mcList.RemoveDataFeed();
         this.mData.removeEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false);
         this.mData.Destroy();
         this.mFriendsCount = 0;
         this.mFriendsList = new Array();
         this.mSimId = null;
      }
      
      override public function OnShow(param1:Array) : void
      {
         super.OnShow(param1);
      }
      
      protected function HandleUpdateSimRelationship(param1:RelationshipByIdInfo) : void
      {
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
         this.RefreshLayout();
         dispatchEvent(new Event(FRIENDS_UPDATED));
      }
      
      protected function HandleNoMoreContactsToAdd() : void
      {
         this.mbCanAddNewContacts = false;
         this.RefreshLayout();
      }
      
      protected function HandleMoreContactsToAdd() : void
      {
         this.mbCanAddNewContacts = true;
         this.RefreshLayout();
      }
      
      protected function LoadFriends() : void
      {
         this.mData.HandleSimActivated(this.mSimId);
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
      }
      
      protected function HandleDeleteSimRelationshipData(param1:RelationshipDeleteById) : void
      {
         this.mData.HandleSimDeleteRelationship(param1);
      }
      
      protected function HandleUpdateSimRelationshipData(param1:RelationshipByIdInfo) : void
      {
         this.mData.HandleUpdateSimRelationship(param1);
      }
      
      protected function HandleDeleteSimRelationship(param1:RelationshipDeleteById) : void
      {
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
         this.RefreshLayout();
         dispatchEvent(new Event(FRIENDS_UPDATED));
      }
      
      protected function RefreshLayout() : void
      {
         if(this.mFriendsCount < 1)
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
            mcBackground.height = SocialMediaTunables.FRIENDS_TAB_PANEL_HEIGHT;
            this.btnAddToContactList.y = mcBackground.height - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.mBot - this.btnAddToContactList.height;
            mcList.height = this.btnAddToContactList.y - SocialMediaTunables.FRIENDS_TAB_PANEL_PADDING - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.mTop;
            mcList.width = mcBackground.width - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.Horizontal;
         }
         if(!this.mbCanAddNewContacts)
         {
            this.btnAddToContactList.enabled = false;
            this.btnAddToContactList.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_FRIEND_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnAddToContactList.TooltipExt.SetText(null);
            this.btnAddToContactList.enabled = true;
         }
      }
      
      protected function OnFeedSortFilter(param1:DataFeedEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:RelationshipInfo = null;
         this.mFriendsCount = param1.mIndicesArray.length;
         this.mFriendsList = new Array();
         for each(_loc2_ in param1.mIndicesArray)
         {
            _loc3_ = param1.mDataArray[_loc2_];
            this.mFriendsList.push(_loc3_.targetId);
         }
      }
      
      protected function OnAddToContactListClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_friend_picker_interaction,this.mSimId,this.mSimId);
      }
      
      override protected function InitializeGamepadInput() : void
      {
         super.InitializeGamepadInput();
         var _loc1_:* = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.DELETE)).AllowWhileModalOpen(true).SetValidCheck(null).CallFunction(this.RemoveFriend);
         mListAdapter.AddInputAction(_loc1_);
         this.mMainAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnAddToContactList],true);
         this.mMainAdapter.SetDefaultHighlight(this.btnAddToContactList);
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
         if(param1.GetDirection() == NavDirection.UP && this.mFriendsCount > 0 && Boolean(mListAdapter))
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
         if(this.mFriendsCount > 0)
         {
            return mListAdapter;
         }
         return this.mMainAdapter;
      }
      
      protected function RemoveFriend() : void
      {
         var _loc3_:SocialMediaFriendCellView = null;
         var _loc1_:Vector.<IView> = mcList.mGridLayout.GetAllCells();
         var _loc2_:int = int(mListAdapter.GetHighlightedIndex());
         if(_loc1_.length > _loc2_)
         {
            _loc3_ = _loc1_[_loc2_] as SocialMediaFriendCellView;
            if(_loc3_)
            {
               _loc3_.RemoveFriend();
            }
         }
      }
   }
}

