package olympus.gui.lists
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.controllers.SliderScrollerController;
   import olympus.controls.GUIComponent;
   import olympus.core.widget.Margin;
   import olympus.events.DataFeedEvent;
   import olympus.events.GridEvent;
   import olympus.events.ScrollerEvent;
   import olympus.extensions.MouseWheelExtension;
   import olympus.gui.sliders.Slider;
   import olympus.interfaces.IAnimation;
   import olympus.interfaces.IDataFeed;
   import olympus.interfaces.IGridLayout;
   import olympus.interfaces.IView;
   import olympus.layout.GridLayout;
   import olympus.motion.TweenParams;
   import olympus.views.GridView;
   import olympus.views.ScrollerView;
   
   public class ScrollList extends GUIComponent
   {
      
      public var mScrollerView:ScrollerView;
      
      public var mSlider:Slider;
      
      public var mcBackground:MovieClip;
      
      protected var mSliderScrollerController:SliderScrollerController;
      
      protected var mGridView:GridView;
      
      public var mGridLayout:IGridLayout;
      
      protected var mScrollerViewMargin:Margin = new Margin(0);
      
      protected var mScrollerAmount:Number = 10;
      
      protected var mbBubbleScrollEvent:Boolean = true;
      
      protected var mbVisibilityAwareInititialized:Boolean = false;
      
      protected var mCurrentlyVisibleCells:Vector.<IView>;
      
      public function ScrollList()
      {
         super();
      }
      
      public function InitializeScrollList(param1:IDataFeed, param2:Class, param3:Margin = null, param4:Margin = null, param5:IGridLayout = null, param6:Boolean = false) : void
      {
         if(param3 == null)
         {
            param3 = new Margin(0);
         }
         if(param4 == null)
         {
            param4 = new Margin(0);
         }
         if(param5 == null)
         {
            param5 = new GridLayout();
         }
         this.ConfigList();
         this.SetGridLayout(param5);
         this.SetListItemView(param2,param3,param6);
         this.mScrollerViewMargin = param4;
         this.UpdateHorizontalAttributes();
         this.UpdateVerticalAttributes();
         this.SetDataFeed(param1);
      }
      
      public function Reset() : void
      {
         if(this.mGridLayout != null)
         {
            this.mGridLayout.RemoveGridView();
         }
      }
      
      public function SetGridLayout(param1:IGridLayout) : void
      {
         this.mGridLayout = param1;
         this.mGridLayout.SetGridView(this.mGridView);
         this.mCurrentlyVisibleCells = null;
      }
      
      public function SetListItemView(param1:Class, param2:Margin = null, param3:Boolean = false) : void
      {
         this.mGridLayout.SetCellView(param1,param2,param3);
         var _loc4_:Number = this.mGridLayout.GetCellBounds().height;
         this.mScrollerAmount = Math.max(this.mScrollerAmount,_loc4_ * 0.75);
      }
      
      public function SetListItemListener(param1:String, param2:Function) : void
      {
         this.mGridLayout.RegisterCellEventListener(param1);
         this.mGridView.addEventListener(GridEvent.CELL_EVENT.concat(param1),param2);
      }
      
      public function UnsetListItemListener(param1:String, param2:Function) : void
      {
         this.mGridLayout.UnregisterCellEventListener(param1);
         this.mGridView.removeEventListener(GridEvent.CELL_EVENT.concat(param1),param2);
      }
      
      public function SetCellViewAudioElementName(param1:String) : void
      {
         this.mGridLayout.SetCellViewAudioElementName(param1);
      }
      
      public function SetDataFeed(param1:IDataFeed) : void
      {
         this.mGridLayout.SetDataFeed(param1);
         param1.addEventListener(DataFeedEvent.REMOVE_ALL,this.OnDataFeedRemoveAll,false,0,true);
         param1.addEventListener(DataFeedEvent.SORT_FILTER,this.OnDataFeedSortFilter,false,0,true);
      }
      
      public function RemoveDataFeed() : void
      {
         var _loc1_:IDataFeed = null;
         if(this.mGridLayout)
         {
            _loc1_ = this.mGridLayout.GetDataFeed();
            if(_loc1_ != null)
            {
               _loc1_.removeEventListener(DataFeedEvent.REMOVE_ALL,this.OnDataFeedRemoveAll,false);
               _loc1_.removeEventListener(DataFeedEvent.SORT_FILTER,this.OnDataFeedSortFilter,false);
            }
            this.mGridLayout.RemoveDataFeed();
            this.mCurrentlyVisibleCells = null;
         }
      }
      
      public function ComputeLayoutBounds() : Rectangle
      {
         var _loc1_:Rectangle = this.GetContentLayoutBoundsRect();
         _loc1_.offset(-this.mScrollerViewMargin.mLeft,-this.mScrollerViewMargin.mTop);
         _loc1_.inflate(this.mScrollerViewMargin.Horizontal,this.mScrollerViewMargin.Vertical);
         return _loc1_;
      }
      
      public function GetGridView() : GridView
      {
         return this.mGridView;
      }
      
      override public function get width() : Number
      {
         return this.mcBackground.width;
      }
      
      override public function set width(param1:Number) : void
      {
         this.mcBackground.width = param1;
         this.UpdateHorizontalAttributes();
      }
      
      override public function get height() : Number
      {
         return this.mcBackground.height;
      }
      
      override public function set height(param1:Number) : void
      {
         this.mcBackground.height = param1;
         this.UpdateVerticalAttributes();
         this.RecalculateRangeOnResize();
      }
      
      public function get length() : int
      {
         var _loc1_:IDataFeed = null;
         if(this.mGridLayout)
         {
            _loc1_ = this.mGridLayout.GetDataFeed();
            if(_loc1_)
            {
               return _loc1_.length;
            }
         }
         return 0;
      }
      
      public function get Controller() : SliderScrollerController
      {
         return this.mSliderScrollerController;
      }
      
      public function get ScrollerViewMargin() : Margin
      {
         return this.mScrollerViewMargin;
      }
      
      public function set ScrollerAmount(param1:Number) : void
      {
         this.mScrollerAmount = param1;
      }
      
      public function set BubbleScrollEvent(param1:Boolean) : void
      {
         this.mbBubbleScrollEvent = param1;
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.ConfigList();
      }
      
      protected function ConfigList() : void
      {
         if(this.mGridView)
         {
            return;
         }
         this.mScrollerView.ApplyMask(true);
         this.mSliderScrollerController = new SliderScrollerController(this.mSlider);
         this.mScrollerView.SetController(this.mSliderScrollerController);
         var _loc1_:MouseWheelExtension = AddExtension(MouseWheelExtension) as MouseWheelExtension;
         _loc1_.SetCaptureZone(this);
         _loc1_.SetCallback(this.OnMouseWheelCapture);
         var _loc2_:IScrollListView = this.mScrollerView.mScrollableContent as IScrollListView;
         if(_loc2_)
         {
            this.mGridView = _loc2_.GetGridViewObject();
         }
         this.mGridView.addEventListener(GridEvent.RESIZE,this.OnGridViewResize,false,0,true);
         if(scaleX != 1 || scaleY != 1)
         {
            this.width *= scaleX;
            this.height *= scaleY;
            scaleX = 1;
            scaleY = 1;
         }
         this.mScrollerView.Initialize();
      }
      
      protected function OnGridViewResize(param1:GridEvent = null) : void
      {
         this.RecalculateRangeOnResize(param1);
      }
      
      protected function OnDataFeedRemoveAll(param1:DataFeedEvent) : void
      {
         this.mSlider.SetCurrentValue(0,false);
      }
      
      protected function OnDataFeedSortFilter(param1:DataFeedEvent) : void
      {
         if(param1.mbResetPosition)
         {
            this.mSlider.SetCurrentValue(0,false);
         }
      }
      
      protected function OnMouseWheelCapture(param1:MouseEvent) : void
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Point = null;
         var _loc2_:Number = this.mSlider.Value;
         var _loc3_:Number = param1.delta < 0 ? this.mScrollerAmount : -this.mScrollerAmount;
         if(!this.mbBubbleScrollEvent)
         {
            _loc4_ = this.parent as DisplayObjectContainer;
            while(Boolean(_loc4_) && !(_loc4_ is Stage))
            {
               if(_loc4_ is ScrollList)
               {
                  if(_loc3_ > 0)
                  {
                     _loc5_ = _loc4_.globalToLocal(this.localToGlobal(new Point(0,this.height)));
                     if(_loc5_.y > _loc4_.height)
                     {
                        return;
                     }
                  }
                  else
                  {
                     _loc5_ = _loc4_.globalToLocal(this.localToGlobal(new Point(0,0)));
                     if(_loc5_.y < 0)
                     {
                        return;
                     }
                  }
               }
               _loc4_ = _loc4_.parent;
            }
         }
         this.mSlider.SetCurrentValue(_loc3_,false,false);
         if(!this.mbBubbleScrollEvent && this.mSlider.Value != _loc2_)
         {
            param1.stopPropagation();
         }
      }
      
      protected function GetContentLayoutBoundsRect() : Rectangle
      {
         var _loc1_:Rectangle = this.mGridLayout.GetLayoutBounds();
         var _loc2_:IScrollListView = this.mScrollerView.mScrollableContent as IScrollListView;
         if(_loc2_)
         {
            _loc1_ = _loc2_.ModifyLayoutBounds(_loc1_);
         }
         return _loc1_;
      }
      
      public function GetContentLayoutBoundsHeight() : int
      {
         return this.mGridLayout.GetLayoutBounds().height;
      }
      
      protected function RecalculateRangeOnResize(param1:GridEvent = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         if(this.mGridLayout == null)
         {
            return;
         }
         var _loc2_:Rectangle = this.GetContentLayoutBoundsRect();
         var _loc3_:Rectangle = this.mScrollerView.GetScrollingRegion();
         var _loc4_:Number = 0;
         var _loc5_:Number = Math.max(0,Math.round(_loc2_.height - _loc3_.height));
         this.mSlider.SetThumbSize(_loc2_.height == 0 ? 1 : _loc3_.height / _loc2_.height);
         this.mSlider.SetValueRange(_loc4_,_loc5_);
         if(!param1 || this.mSlider.Value == 0 || !param1.mRectArray)
         {
            this.mSlider.SetCurrentValue(this.mSlider.Value,false,true);
         }
         else
         {
            _loc6_ = 0;
            _loc7_ = int(param1.mRectArray.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = param1.mRectArray[_loc8_];
               _loc10_ = -this.mGridView.y;
               if(_loc9_.top < _loc10_)
               {
                  _loc6_ += _loc9_.height;
               }
               _loc8_++;
            }
            this.mSlider.SetCurrentValue(this.mSlider.Value + _loc6_,false,true);
         }
      }
      
      protected function UpdateHorizontalAttributes() : void
      {
         var _loc1_:Margin = this.mScrollerViewMargin;
         var _loc2_:Number = this.width;
         this.mScrollerView.x = _loc1_.mLeft;
         this.mScrollerView.width = _loc2_ - _loc1_.Horizontal;
         this.mGridView.width = _loc2_ - _loc1_.Horizontal;
         this.mSlider.x = _loc2_ - _loc1_.mRight + _loc1_.mRight * 0.5 - this.mSlider.width * 0.5;
      }
      
      protected function UpdateVerticalAttributes() : void
      {
         var _loc1_:Margin = this.mScrollerViewMargin;
         var _loc2_:Number = this.height;
         this.mScrollerView.y = _loc1_.mTop;
         this.mSlider.y = _loc1_.mTop;
         this.mScrollerView.height = this.mSlider.height = _loc2_ - _loc1_.Vertical;
         this.mGridView.height = _loc2_ - _loc1_.Vertical;
      }
      
      override public function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         var _loc8_:IAnimation = null;
         var _loc4_:int = param2.delay;
         var _loc5_:Vector.<IView> = this.mGridLayout.GetVisibleCells(this.mScrollerView.mcMask.getBounds(this),this);
         var _loc6_:int = Math.min(_loc5_.length,this.mGridLayout.GetDataFeed().length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_] as IAnimation;
            if(_loc8_)
            {
               _loc8_.AnimateIn(param1 + _loc4_ * _loc7_,param2,param3);
            }
            _loc7_++;
         }
         return _loc4_ * _loc7_;
      }
      
      public function SetCellScrollVisibilityAware(param1:Boolean) : void
      {
         if(this.mbVisibilityAwareInititialized == param1)
         {
            return;
         }
         this.mbVisibilityAwareInititialized = param1;
         if(param1)
         {
            this.Controller.addEventListener(ScrollerEvent.SCROLL,this.OnScrollerViewScroll);
         }
         else
         {
            this.Controller.removeEventListener(ScrollerEvent.SCROLL,this.OnScrollerViewScroll);
            this.mCurrentlyVisibleCells = null;
         }
      }
      
      protected function OnScrollerViewScroll(param1:ScrollerEvent) : void
      {
         this.UpdateCellScrollVisibility(true);
      }
      
      public function UpdateCellScrollVisibility(param1:Boolean = false) : void
      {
         var _loc6_:IView = null;
         var _loc7_:Vector.<IView> = null;
         var _loc11_:int = 0;
         var _loc12_:IScrollVisibilityAwareCell = null;
         if(!this.mbVisibilityAwareInititialized)
         {
            return;
         }
         var _loc2_:Vector.<IView> = this.mCurrentlyVisibleCells;
         var _loc3_:Vector.<IView> = this.mGridLayout.GetVisibleCells(this.mScrollerView.mcMask.getBounds(this),this);
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Vector.<IView> = new Vector.<IView>();
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_ != null && (_loc2_ == null || _loc2_.indexOf(_loc6_) < 0))
            {
               _loc5_.push(_loc6_);
            }
         }
         _loc7_ = new Vector.<IView>();
         if(_loc2_ != null)
         {
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_ != null && _loc3_.indexOf(_loc6_) < 0)
               {
                  _loc7_.push(_loc6_);
               }
            }
         }
         this.mCurrentlyVisibleCells = _loc4_ > 0 ? _loc3_ : null;
         var _loc8_:int = int(_loc5_.length);
         var _loc9_:int = int(_loc7_.length);
         if(_loc8_ == 0 && _loc9_ == 0)
         {
            return;
         }
         var _loc10_:ScrollListEvent = new ScrollListEvent(ScrollListEvent.VISIBILITY_UPDATED);
         _loc10_.mVisibleCells = _loc3_;
         _loc10_.mShownCells = _loc5_;
         _loc10_.mHiddenCells = _loc7_;
         _loc10_.mbListScrolled = param1;
         _loc11_ = 0;
         while(_loc11_ < _loc9_)
         {
            _loc12_ = _loc7_[_loc11_] as IScrollVisibilityAwareCell;
            if(_loc12_)
            {
               _loc12_.SetScrollVisibility(false);
            }
            _loc11_++;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc8_)
         {
            _loc12_ = _loc5_[_loc11_] as IScrollVisibilityAwareCell;
            if(_loc12_)
            {
               _loc12_.SetScrollVisibility(true);
            }
            _loc11_++;
         }
         dispatchEvent(_loc10_);
      }
      
      public function ScrollToDisplayObject(param1:DisplayObject, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc5_:Rectangle = param1.getBounds(this.mSlider.stage);
         var _loc6_:Rectangle = this.mSlider.getBounds(this.mSlider.stage);
         if(param4)
         {
            this.mSlider.SetCurrentValue(_loc5_.top - _loc6_.top - _loc6_.height / 2 + _loc5_.height / 2,param3,false);
         }
         else
         {
            _loc7_ = this.ScrollerViewMargin.mBot;
            _loc8_ = this.ScrollerViewMargin.mTop;
            if(_loc5_.height > _loc6_.height)
            {
               if(param2)
               {
                  this.mSlider.SetCurrentValue(_loc5_.bottom - _loc6_.bottom + _loc7_,param3,false);
               }
               else
               {
                  this.mSlider.SetCurrentValue(_loc5_.top - _loc6_.top - _loc8_,param3,false);
               }
            }
            else if(_loc5_.bottom + _loc7_ > _loc6_.bottom)
            {
               this.mSlider.SetCurrentValue(_loc5_.bottom - _loc6_.bottom + _loc7_,param3,false);
            }
            else if(_loc5_.top - _loc8_ < _loc6_.top)
            {
               this.mSlider.SetCurrentValue(_loc5_.top - _loc6_.top - _loc8_,param3,false);
            }
         }
      }
   }
}

