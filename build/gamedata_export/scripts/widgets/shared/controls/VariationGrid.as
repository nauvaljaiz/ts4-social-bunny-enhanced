package widgets.shared.controls
{
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import olympus.constants.Alignment;
   import olympus.controls.GUIComponent;
   import olympus.core.widget.Margin;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.GridEvent;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.AudioExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.gui.grids.SelectionGrid;
   import olympus.gui.lists.ScrollList;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.DynamicOmnidirectionalAdapter;
   import olympus.input.adapters.InputAdapter;
   import olympus.layout.GridLayout;
   import olympus.utils.LibraryUtils;
   import olympus.utils.SystemUtils;
   import olympus.views.GridView;
   import widgets.CAS.events.CASCatalogEvent;
   import widgets.shared.constants.GlobalTunables;
   import widgets.shared.data.ColorSwatchData;
   import widgets.shared.events.ColorSwatchEvent;
   
   public class VariationGrid extends GUIComponent implements IInputAdapter
   {
      
      public var mcScrollList:ScrollList;
      
      public var mcBackground:MovieClip;
      
      public var mSelectionGrid:SelectionGrid = new SelectionGrid();
      
      public var mPrimaryExpandDirection:String = "right";
      
      public var mSecondaryExpandDirection:String = null;
      
      public var mbSwatchPlacementLeftToRight:Boolean = true;
      
      public var mColorStackPadding:Number = -18;
      
      public var mNumThumbnailsInRow:int = 5;
      
      public var mMaxStackSize:int = 23;
      
      public var mThumbnailMargin:Margin = new Margin(0);
      
      public var mThumbnailGridMargin:Margin = new Margin(0);
      
      public var mbMultiSelect:Boolean = false;
      
      public var mbPreventDeselect:Boolean = false;
      
      public var mbUseCASCatalogEvents:* = false;
      
      protected var mDefaultProdId:String = null;
      
      protected var mDataArgs:Object = null;
      
      protected var mDataFeed:SelectableArrayDataFeed;
      
      protected var mbGridInitialized:Boolean = false;
      
      protected var mInputAdapter:DynamicOmnidirectionalAdapter;
      
      public function VariationGrid()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
      }
      
      public function get Grid() : SelectionGrid
      {
         return this.mSelectionGrid;
      }
      
      public function SetDataFeed(param1:SelectableArrayDataFeed, param2:String = null, param3:Object = null) : void
      {
         var _loc4_:int = 0;
         if(this.mSecondaryExpandDirection == null && this.mMaxStackSize != 0)
         {
            if(param1.length > this.mMaxStackSize)
            {
               param1 = param1.Clone();
               while(param1.length > this.mMaxStackSize)
               {
                  param1.RemoveItemAt(param1.length - 1);
               }
            }
         }
         this.mDefaultProdId = param2;
         this.mDataArgs = param3;
         this.mDataFeed = param1;
         if(this.mbGridInitialized)
         {
            _loc4_ = this.GetDefaultVariationIndex();
            this.mSelectionGrid.SetDataFeed(param1);
            this.mSelectionGrid.SetSelection(_loc4_,true,false);
         }
      }
      
      public function SetDefaultColorData(param1:ColorSwatchData) : void
      {
      }
      
      public function HasDataFeed() : Boolean
      {
         return this.mDataFeed != null;
      }
      
      public function GetDataLength() : int
      {
         return this.mDataFeed ? this.mDataFeed.length : 0;
      }
      
      public function GetSelectedIndices() : Array
      {
         return this.mDataFeed.GetSelectedIndices();
      }
      
      public function SelectProductById(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:int = this.mDataFeed.GetItemIndexByFieldName("dataID",param1);
         if(_loc3_ == -1)
         {
            return;
         }
         this.mSelectionGrid.SetSelection(_loc3_,true,param2);
      }
      
      public function ShowGrid() : void
      {
         this.ShowSelectionGrid();
      }
      
      public function HideGrid() : void
      {
         this.mSelectionGrid.visible = false;
      }
      
      protected function InitializeSelectionGrid() : void
      {
         var _loc3_:GridLayout = null;
         var _loc4_:Margin = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc1_:SelectionGrid = this.mSelectionGrid;
         var _loc2_:ScrollList = this.mcScrollList;
         _loc2_.mSlider.AlwaysVisible = false;
         if(this.mSecondaryExpandDirection == null)
         {
            this.mcBackground.visible = false;
            switch(this.mPrimaryExpandDirection)
            {
               case Alignment.TOP:
                  _loc1_.x = _loc2_.x = 0;
                  _loc1_.y = _loc2_.y = this.mColorStackPadding;
                  _loc1_.rotation = _loc2_.rotation = -90;
                  break;
               case Alignment.BOTTOM:
                  _loc1_.x = _loc2_.x = 0;
                  _loc1_.y = _loc2_.y = this.mcBackground.height - this.mColorStackPadding;
                  _loc1_.rotation = _loc2_.rotation = -90;
                  break;
               case Alignment.LEFT:
                  _loc1_.x = _loc2_.x = this.mColorStackPadding;
                  _loc1_.y = _loc2_.y = 0;
                  _loc1_.rotation = _loc2_.rotation = 180;
                  break;
               case Alignment.RIGHT:
                  _loc1_.x = _loc2_.x = this.mcBackground.width - this.mColorStackPadding;
                  _loc1_.y = _loc2_.y = 0;
                  _loc1_.rotation = _loc2_.rotation = 0;
            }
            _loc3_ = new GridLayout(false,true,this.mMaxStackSize);
            _loc4_ = new Margin(0);
            _loc2_.InitializeScrollList(this.mDataFeed,LibraryUtils.GetLibraryClass(LibraryUtils.VARIATION_STACK_CELL_VIEW),_loc4_,null,_loc3_);
            _loc1_.mcGridView = _loc2_.mScrollerView.mScrollableContent as GridView;
            _loc1_.mcGridView.height = _loc2_.height;
            _loc1_.InitializeSelectionGrid(this.mDataFeed,LibraryUtils.GetLibraryClass(LibraryUtils.VARIATION_STACK_CELL_VIEW),true,_loc4_,_loc3_,this.mbMultiSelect,this.mbPreventDeselect);
            (GetExtension(AudioExtension) as AudioExtension).ElementName = "VariationButton";
         }
         else
         {
            _loc5_ = this.mSecondaryExpandDirection == Alignment.RIGHT;
            _loc3_ = new GridLayout(false,_loc5_,this.mNumThumbnailsInRow,this.mbSwatchPlacementLeftToRight);
            _loc2_.InitializeScrollList(this.mDataFeed,LibraryUtils.GetLibraryClass(LibraryUtils.VARIATION_THUMBNAIL_CELL_VIEW),this.mThumbnailMargin,GlobalTunables.VARIATION_GRID_SCROLLER_VIEW_MARGIN,_loc3_);
            _loc1_.mcGridView = _loc2_.mScrollerView.mScrollableContent as GridView;
            _loc1_.mcGridView.height = _loc2_.height;
            _loc1_.InitializeSelectionGrid(this.mDataFeed,LibraryUtils.GetLibraryClass(LibraryUtils.VARIATION_THUMBNAIL_CELL_VIEW),true,this.mThumbnailMargin,_loc3_,this.mbMultiSelect,this.mbPreventDeselect);
            _loc6_ = this.GetDefaultVariationIndex();
            if(this.mDataFeed.CheckGoodIndex(_loc6_) && !this.mDataFeed.RequestItemAt(_loc6_).IsLocked())
            {
               _loc1_.SetSelection(_loc6_);
            }
            _loc1_.SetSelectionGridListener(PushButtonEvent.CLICK);
            _loc1_.addEventListener(GridEvent.SELECTION_UPDATE,this.OnClickVariation,false,0,true);
            _loc1_.SetGridListener(PushButtonEvent.ROLL_OVER,this.OnCellRollOver);
            _loc1_.SetGridListener(PushButtonEvent.ROLL_OUT,this.OnCellRollOut);
         }
         this.mbGridInitialized = true;
      }
      
      public function ShowSelectionGrid() : void
      {
         var _loc2_:ScrollList = null;
         this.mSelectionGrid.visible = true;
         if(!this.mbGridInitialized)
         {
            this.InitializeSelectionGrid();
         }
         var _loc1_:MovieClip = this.mcBackground;
         _loc2_ = this.mcScrollList;
         var _loc3_:Rectangle = _loc2_.ComputeLayoutBounds();
         _loc2_.width = _loc3_.width;
         _loc2_.height = _loc3_.height;
         this.SetScrollListMaskSize();
         if(this.mSecondaryExpandDirection != null)
         {
            _loc1_.x = _loc3_.x - this.mThumbnailGridMargin.mLeft;
            _loc1_.y = _loc3_.y - this.mThumbnailGridMargin.mTop;
            _loc1_.width = _loc3_.width + this.mThumbnailGridMargin.Horizontal;
            _loc1_.height = _loc3_.height + this.mThumbnailGridMargin.Vertical;
         }
      }
      
      protected function GetDefaultVariationIndex() : int
      {
         if(this.mDefaultProdId)
         {
            return this.mDataFeed.GetItemIndexByFieldName("dataID",this.mDefaultProdId);
         }
         return 0;
      }
      
      protected function SetScrollListMaskSize() : void
      {
         var _loc1_:ScrollList = this.mcScrollList;
         _loc1_.mScrollerView.mcMask.width = _loc1_.width + GlobalTunables.VARIATION_GRID_MASK_MARGIN * 2;
         _loc1_.mScrollerView.mcMask.height = _loc1_.height + GlobalTunables.VARIATION_GRID_MASK_MARGIN;
         _loc1_.mScrollerView.mcMask.x = -GlobalTunables.VARIATION_GRID_MASK_MARGIN;
         _loc1_.mScrollerView.mcMask.y = -GlobalTunables.VARIATION_GRID_MASK_MARGIN;
         if(!_loc1_.mSlider.visible)
         {
            _loc1_.mScrollerView.mcMask.height += GlobalTunables.VARIATION_GRID_MASK_MARGIN;
         }
         _loc1_.mScrollerView.ApplyMask(true);
      }
      
      protected function OnClickVariation(param1:GridEvent) : void
      {
         var _loc2_:ColorSwatchData = param1.mData as ColorSwatchData;
         if(this.mbUseCASCatalogEvents)
         {
            dispatchEvent(new CASCatalogEvent(CASCatalogEvent.VARIATION_SELECTED,true,false,null,_loc2_.dataID,0));
         }
         else
         {
            dispatchEvent(new ColorSwatchEvent(ColorSwatchEvent.VARIATION_SELECTED,true,false,_loc2_,0));
         }
      }
      
      protected function OnCellRollOver(param1:GridEvent) : void
      {
         var _loc2_:ColorSwatchData = param1.mData as ColorSwatchData;
         if(Boolean(_loc2_) && !_loc2_.IsLocked())
         {
            if(this.mbUseCASCatalogEvents)
            {
               dispatchEvent(new CASCatalogEvent(CASCatalogEvent.VARIATION_ROLL_OVER,true,false,null,_loc2_.dataID,0));
            }
            else
            {
               dispatchEvent(new ColorSwatchEvent(ColorSwatchEvent.VARIATION_ROLL_OVER,true,false,_loc2_,0));
            }
         }
      }
      
      protected function OnCellRollOut(param1:GridEvent) : void
      {
         var _loc2_:ColorSwatchData = param1.mData as ColorSwatchData;
         if(Boolean(_loc2_) && !_loc2_.IsLocked())
         {
            if(this.mbUseCASCatalogEvents)
            {
               dispatchEvent(new CASCatalogEvent(CASCatalogEvent.VARIATION_ROLL_OUT,true,false,null,_loc2_.dataID,0));
            }
            else
            {
               dispatchEvent(new ColorSwatchEvent(ColorSwatchEvent.VARIATION_ROLL_OUT,true,false,_loc2_,0));
            }
         }
      }
      
      protected function InitGamepad() : void
      {
         this.mInputAdapter = new DynamicOmnidirectionalAdapter(this);
         this.mInputAdapter.OnBackCall(NavManager.Instance.FocusBack);
         this.mInputAdapter.AutoscrollSlider(this.mcScrollList.mSlider);
         this.mInputAdapter.SetEdgeBehavior(InputAdapter.EDGE_STOP);
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.mInputAdapter.Enter(param1);
         return this;
      }
      
      public function Exit() : void
      {
         this.mInputAdapter.Exit();
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         this.mInputAdapter.OnInputEventCall(param1,param2);
         return this;
      }
   }
}

