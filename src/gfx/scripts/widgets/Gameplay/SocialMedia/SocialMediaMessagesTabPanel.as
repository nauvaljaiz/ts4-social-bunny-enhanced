package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
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
   }
}

