package widgets.BuildBuy.Magalog.controls
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.shared.ResourceKey;
   import olympus.core.widget.Margin;
   import olympus.events.DataFeedEvent;
   import olympus.events.GenericEvent;
   import olympus.extensions.TutorialTipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gui.lists.ScrollList;
   import olympus.gui.sliders.Slider;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.GridInputAdapter;
   import olympus.input.adapters.InputAdapterFactory;
   import olympus.input.helpers.SliderHelper;
   import olympus.layout.SelectableRecyclingGridLayout;
   import olympus.utils.DropShadowUtils;
   import olympus.utils.SystemUtils;
   import widgets.BuildBuy.Magalog.constants.BuildBuyMagalogTunables;
   import widgets.BuildBuy.data.CatalogDataFeed;
   import widgets.BuildBuy.gamepad.BuildBuySharedActions;
   import widgets.shared.constants.TutorialTipUIElement;
   
   public class MagalogPanel extends MovieClip implements IInputAdapter
   {
      
      public var mcRoomList:ScrollList;
      
      public var mcListBackground:Sprite;
      
      public var txtResults:TextField;
      
      protected var mRoomFeed:CatalogDataFeed;
      
      protected var mRoomGridLayout:SelectableRecyclingGridLayout;
      
      protected var mPadding:Margin;
      
      protected var mCellViewWidth:Number = 0;
      
      protected var bScrollListInitialized:Boolean = false;
      
      protected var mTutorialTipExtension:TutorialTipExtension;
      
      protected var mInputAdapter:GridInputAdapter;
      
      public function MagalogPanel()
      {
         super();
      }
      
      public function InitializeScrollList(param1:CatalogDataFeed, param2:Class, param3:Margin, param4:Number = -1) : void
      {
         this.mRoomFeed = param1;
         param1.addEventListener(DataFeedEvent.ADD,this.OnDataFeedUpdate,false,0,true);
         param1.addEventListener(DataFeedEvent.UPDATE,this.OnDataFeedUpdate,false,0,true);
         this.mRoomGridLayout = new SelectableRecyclingGridLayout(false,true,4);
         this.mPadding = param3;
         this.mCellViewWidth = param4;
         this.mcRoomList.InitializeScrollList(param1,param2,param3,BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN,this.mRoomGridLayout);
         var _loc5_:TutorialTipExtension = this.mcRoomList.GetExtension(TutorialTipExtension) as TutorialTipExtension;
         _loc5_.ControlEnum = TutorialTipUIElement.BB_MAGALOG_ITEM;
         _loc5_.AddSatisfactionEvent(GenericEvent.CHANGE);
         this.mTutorialTipExtension = _loc5_;
         this.txtResults.visible = false;
         this.txtResults.y = Math.floor(this.mcListBackground.y + (this.mcListBackground.height - this.txtResults.height) * 0.5);
         this.bScrollListInitialized = true;
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
      }
      
      public function Resize(param1:Number, param2:Number) : void
      {
         var _loc3_:ScrollList = this.mcRoomList;
         this.mcListBackground.width = param1 - BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN.Horizontal;
         _loc3_.width = param1;
         this.mcListBackground.height = param2;
         this.txtResults.x = this.mcListBackground.x + BuildBuyMagalogTunables.LIST_RESULTS_TEXT_OFFSET_X;
         this.txtResults.y = Math.floor(this.mcListBackground.y + (this.mcListBackground.height - this.txtResults.height) * 0.5);
         _loc3_.height = param2 - DropShadowUtils.MARGIN_PANEL_SECOND_LAYER_ROUNDED * 2;
         this.AdjustRoomListColumns();
         _loc3_.mSlider.SetCurrentValue(0,false);
         if(_loc3_.mGridLayout)
         {
            _loc3_.mGridLayout.PositionCells();
         }
      }
      
      public function ReinitializeCellView(param1:Class, param2:Margin, param3:Number = -1) : void
      {
         this.mPadding = param2;
         this.mCellViewWidth = param3;
         this.mRoomFeed.ResetAllViews();
         this.AdjustRoomListColumns();
         this.mcRoomList.InitializeScrollList(this.mRoomFeed,param1,param2,BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN,this.mRoomGridLayout);
      }
      
      public function SetListItemListener(param1:String, param2:Function) : void
      {
         this.mcRoomList.SetListItemListener(param1,param2);
      }
      
      public function ReplaceItemAt(param1:int, param2:Object) : void
      {
         this.mRoomFeed.ReplaceItemAt(param1,param2);
      }
      
      public function HighlightProductByKey(param1:ResourceKey) : CatalogProduct
      {
         var _loc3_:CatalogDataFeed = null;
         var _loc6_:CatalogProduct = null;
         var _loc2_:SelectableRecyclingGridLayout = this.mRoomGridLayout;
         _loc3_ = this.mRoomFeed;
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_.RequestItemAt(_loc5_) as CatalogProduct;
            if((Boolean(_loc6_)) && param1.IsEqual(_loc6_.resourceKey))
            {
               this.DeselectCurrentProduct();
               _loc3_.SetSelectionState(_loc5_,true);
               this.ScrollToIndex(_loc5_);
               if(SystemUtils.UsingController)
               {
                  this.mInputAdapter.SetHighlightedIndex(_loc5_);
               }
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function HighlightProduct(param1:Object) : Object
      {
         var _loc2_:SelectableRecyclingGridLayout = this.mRoomGridLayout;
         var _loc3_:CatalogDataFeed = this.mRoomFeed;
         var _loc4_:int = this.mRoomFeed.IndexOf(param1);
         if(_loc4_ >= 0)
         {
            this.DeselectCurrentProduct();
            this.mRoomFeed.SetSelectionState(_loc4_,true);
            this.ScrollToIndex(_loc4_);
            return param1;
         }
         return null;
      }
      
      public function DeselectCurrentProduct() : void
      {
         this.mRoomFeed.DeselectAll();
      }
      
      public function GetItemIndex(param1:CatalogProduct) : int
      {
         return this.mRoomFeed.IndexOf(param1);
      }
      
      public function scrollTo(param1:Number) : void
      {
         this.mcRoomList.mSlider.SetCurrentValue(param1,false,true);
      }
      
      public function ScrollToIndex(param1:int) : void
      {
         var _loc2_:Number = this.mRoomGridLayout.GetPositionOfIndex(param1);
         this.mcRoomList.mSlider.SetCurrentValue(_loc2_,false,true);
      }
      
      public function TriggerTutorialMessage() : void
      {
         this.mcRoomList.dispatchEvent(new Event(GenericEvent.CHANGE));
      }
      
      public function PurchaseAvailabilityUpdate() : void
      {
         if(this.mRoomFeed)
         {
            this.mRoomFeed.MarkRangeDirty(0,this.mRoomFeed.length - 1);
         }
      }
      
      public function MarkVisibility(param1:Boolean) : void
      {
         var _loc2_:Boolean = param1 && this.mRoomFeed.length > 0;
         this.mTutorialTipExtension.MarkVisibility(_loc2_);
      }
      
      protected function OnDataFeedUpdate(param1:DataFeedEvent) : void
      {
         this.MarkVisibility(visible);
         this.txtResults.visible = this.mRoomFeed.length == 0;
      }
      
      protected function AdjustRoomListColumns() : void
      {
         var _loc1_:ScrollList = null;
         var _loc3_:DropShadowUtils = null;
         if(!this.bScrollListInitialized)
         {
            return;
         }
         _loc1_ = this.mcRoomList;
         var _loc2_:Slider = _loc1_.mSlider;
         this.mRoomGridLayout.NumLines = Math.floor((_loc1_.width - BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN.Horizontal - DropShadowUtils.MARGIN_PANEL_SECOND_LAYER_ROUNDED * 2) / (this.mCellViewWidth + this.mPadding.Horizontal * 2));
         this.mRoomGridLayout.PositionCells();
      }
      
      protected function InitGamepad() : void
      {
         this.visible = false;
         this.mInputAdapter = InputAdapterFactory.FromGridLayout(this.mRoomGridLayout);
         this.mInputAdapter.AutoscrollSlider(this.mcRoomList.mSlider);
         this.mInputAdapter.AddInputAction(BuildBuySharedActions.jumpToFilter);
         this.mInputAdapter.AddInputAction(BuildBuySharedActions.jumpToSearch);
         var _loc1_:SliderHelper = this.mInputAdapter.GetSliderHelper();
         if(_loc1_)
         {
            _loc1_.UseRStickScroll();
            _loc1_.SetCenterHighlight(true);
         }
      }
      
      public function RefreshHighlight() : void
      {
         this.mInputAdapter.ResetHighlight();
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return this.mInputAdapter.Enter(param1);
      }
      
      public function Exit() : void
      {
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         return this.mInputAdapter.OnInputEventCall(param1,param2);
      }
      
      public function GamepadHighlightFirstItem() : void
      {
         this.mcRoomList.mSlider.SetCurrentValue(0,false);
         this.mInputAdapter.SetHighlightedIndex(0,true);
      }
   }
}

