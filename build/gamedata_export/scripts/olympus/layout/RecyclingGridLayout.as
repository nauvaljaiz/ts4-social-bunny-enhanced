package olympus.layout
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.widget.Margin;
   import olympus.events.DataFeedEvent;
   import olympus.events.GridEvent;
   import olympus.interfaces.IDataFeed;
   import olympus.interfaces.IView;
   
   public class RecyclingGridLayout extends GridLayout
   {
      
      protected var mPrevRectangleUpdate:Rectangle;
      
      protected var mCellsY:Vector.<Number>;
      
      protected var mSortedIndexToDataIndex:Array;
      
      protected var mbSuppressUpdates:Boolean = false;
      
      protected var mCellViewSizeFallback:Point = null;
      
      public function RecyclingGridLayout(param1:Boolean = true, param2:Boolean = true, param3:int = 4)
      {
         super(param1,param2,param3);
         this.mPrevRectangleUpdate = new Rectangle();
      }
      
      public function set CellViewSizeFallback(param1:Point) : void
      {
         this.mCellViewSizeFallback = param1;
      }
      
      public function CalculateCellViewWidth(param1:DisplayObject) : Number
      {
         return param1 != null && param1.width != 0 ? param1.width : (this.mCellViewSizeFallback != null ? this.mCellViewSizeFallback.x : 0);
      }
      
      public function CalculateCellViewHeight(param1:DisplayObject) : Number
      {
         return param1 != null && param1.height != 0 ? param1.height : (this.mCellViewSizeFallback != null ? this.mCellViewSizeFallback.y : 0);
      }
      
      public function set SuppressUpdates(param1:Boolean) : void
      {
         this.mbSuppressUpdates = param1;
      }
      
      override public function SetCellView(param1:Class, param2:Margin = null, param3:Boolean = false) : void
      {
         var _loc4_:* = 0;
         if(param1 != mCellType)
         {
            _loc4_ = int(mCells.length);
            while(_loc4_ > 0)
            {
               mGridView.removeChild(mCells.pop() as DisplayObject);
               _loc4_--;
            }
            this.mCellsY = null;
         }
         super.SetCellView(param1,param2,param3);
         if(mGridData)
         {
            this.PositionCells();
         }
      }
      
      override public function SetDataFeed(param1:IDataFeed) : void
      {
         mGridData = param1;
         param1.addEventListener(DataFeedEvent.UPDATE,this.OnFeedUpdate,false,0,true);
         param1.addEventListener(DataFeedEvent.ADD,this.OnFeedAdd,false,0,true);
         param1.addEventListener(DataFeedEvent.ADD_TO_FRONT,this.OnFeedAddToFront,false,0,true);
         param1.addEventListener(DataFeedEvent.REMOVE,this.OnFeedRemove,false,0,true);
         param1.addEventListener(DataFeedEvent.REMOVE_ALL,this.OnFeedRemoveAll,false,0,true);
         param1.addEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false,0,true);
         this.PositionCells();
      }
      
      protected function OnGridResized(param1:GridEvent = null) : void
      {
         if(mGridData)
         {
            this.PositionCells();
         }
      }
      
      override protected function OnFeedUpdate(param1:DataFeedEvent) : void
      {
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:IView = null;
         var _loc2_:int = int(param1.mIndicesArray.length);
         var _loc3_:int = int(param1.mDataArray.length);
         if(_loc2_ != _loc3_)
         {
            throw new Error("OnFeedUpdate - event.mIndicesArray.length != event.mDataArray.length");
         }
         _loc4_ = param1.mUserDataArray;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc7_ = int(param1.mIndicesArray[_loc6_]);
            _loc8_ = mCellIndexToDataIndexMap.indexOf(this.GetSortedIndexOfDataIndex(_loc7_));
            if(_loc8_ != -1)
            {
               _loc9_ = _loc5_ > 0 ? _loc4_[_loc6_] : new Object();
               _loc9_["isUpdate"] = true;
               _loc10_ = mCells[_loc8_];
               _loc10_.Draw(mGridData.RequestItemAt(_loc7_),_loc9_);
            }
            _loc6_++;
         }
      }
      
      override protected function OnFeedSortFilter(param1:DataFeedEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Vector.<IView> = null;
         var _loc5_:int = 0;
         var _loc7_:Object = null;
         var _loc11_:int = 0;
         this.mSortedIndexToDataIndex = param1.mIndicesArray;
         _loc3_ = mCells;
         var _loc4_:Vector.<int> = mCellIndexToDataIndexMap;
         var _loc6_:int = int(_loc3_.length);
         var _loc8_:int = mNumLines;
         var _loc9_:Number = this.CalculateCellViewHeight(_loc3_[0] as DisplayObject) + mCellMargin.Vertical;
         var _loc10_:int = Math.floor(-this.mPrevRectangleUpdate.y / _loc9_) * _loc8_;
         if(_loc10_ == 0 && this.mCellsY[0] <= -(_loc9_ - mCellMargin.mTop))
         {
            _loc10_ -= _loc8_;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc11_ = _loc10_ + _loc5_;
            _loc2_ = _loc3_[_loc5_] as DisplayObject;
            _loc4_[_loc5_] = _loc11_;
            _loc7_ = this.GetDataAtIndex(_loc11_);
            if(_loc7_)
            {
               _loc2_.visible = true;
               (_loc2_ as IView).Draw(_loc7_);
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc5_++;
         }
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,[]));
      }
      
      override protected function OnFeedRemove(param1:DataFeedEvent) : void
      {
         var _loc5_:IView = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Object = null;
         var _loc9_:int = 0;
         var _loc12_:Rectangle = null;
         var _loc2_:int = this.GetSortedIndexOfDataIndex(param1.mIndicesArray[0]);
         if(_loc2_ == -1)
         {
            return;
         }
         this.RemoveSortedData(param1);
         var _loc3_:Vector.<IView> = mCells;
         var _loc4_:Vector.<int> = mCellIndexToDataIndexMap;
         _loc6_ = mCells[0] as DisplayObject;
         var _loc8_:Number = this.CalculateCellViewHeight(_loc6_) + mCellMargin.Vertical;
         var _loc10_:int = int(_loc4_.length);
         var _loc11_:Boolean = false;
         if(_loc2_ < _loc4_[0])
         {
            _loc11_ = true;
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               --_loc4_[_loc9_];
               _loc5_ = _loc3_[_loc9_];
               _loc7_ = this.GetDataAtIndex(_loc4_[_loc9_]);
               if(_loc7_)
               {
                  _loc5_.Draw(_loc7_);
                  (_loc5_ as DisplayObject).visible = true;
               }
               else
               {
                  (_loc5_ as DisplayObject).visible = false;
               }
               _loc9_++;
            }
         }
         else if(_loc2_ <= _loc4_[_loc10_ - 1])
         {
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               _loc5_ = _loc3_[_loc9_];
               _loc7_ = this.GetDataAtIndex(_loc4_[_loc9_]);
               if(_loc7_)
               {
                  _loc5_.Draw(_loc7_);
                  (_loc5_ as DisplayObject).visible = true;
               }
               else
               {
                  (_loc5_ as DisplayObject).visible = false;
               }
               _loc9_++;
            }
         }
         if(_loc11_)
         {
            this.mPrevRectangleUpdate.y += _loc8_;
            _loc12_ = new Rectangle(0,-1,0,-_loc8_);
         }
         else
         {
            _loc12_ = new Rectangle();
         }
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,[_loc12_]));
      }
      
      override protected function OnFeedRemoveAll(param1:DataFeedEvent) : void
      {
         var _loc2_:DisplayObject = null;
         this.mSortedIndexToDataIndex = null;
         for each(_loc2_ in mCells)
         {
            _loc2_.visible = false;
         }
         mAddedCellsToProcess = new Array();
         mCellIndexToDataIndexMap.length = 0;
         this.mCellsY.length = 0;
         mPreviousLayoutBounds = null;
         this.mPrevRectangleUpdate.y = 0;
         this.PositionCells();
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,[]));
      }
      
      override protected function OnFeedAddToFront(param1:DataFeedEvent) : void
      {
         var _loc3_:Array = null;
         var _loc8_:int = 0;
         var _loc10_:DisplayObject = null;
         var _loc11_:Number = NaN;
         var _loc13_:Object = null;
         if(mNumLines > 1)
         {
            throw new Error("Cannot add a feed to the front of a RecyclingGridLayout if " + "it has more than one line");
         }
         this.AddSortedDataToFront(param1);
         var _loc2_:Array = param1.mIndicesArray;
         _loc3_ = param1.mUserDataArray;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Vector.<int> = mCellIndexToDataIndexMap;
         var _loc6_:Vector.<IView> = mCells;
         var _loc7_:IView = _loc6_[0];
         _loc8_ = 0;
         var _loc9_:int = int(_loc5_.length);
         while(_loc8_ < _loc9_)
         {
            if(_loc5_[_loc8_] == -1)
            {
               _loc13_ = _loc4_ > 0 ? _loc3_[0] : new Object();
               _loc13_["isUpdate"] = false;
               (_loc6_[_loc8_] as DisplayObject).visible = true;
               _loc6_[_loc8_].Draw(this.GetDataAtIndex(0),_loc13_);
            }
            ++_loc5_[_loc8_];
            _loc8_++;
         }
         _loc10_ = _loc7_ as DisplayObject;
         _loc11_ = this.CalculateCellViewHeight(_loc10_);
         var _loc12_:Rectangle = new Rectangle(_loc10_.x,0 - _loc11_ - mCellMargin.Vertical,this.CalculateCellViewWidth(_loc10_) + mCellMargin.Horizontal,_loc11_ + mCellMargin.Vertical);
         this.mPrevRectangleUpdate.y = this.mPrevRectangleUpdate.y - _loc11_ - mCellMargin.Vertical;
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,[_loc12_]));
      }
      
      override protected function OnFeedAdd(param1:DataFeedEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc11_:IView = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         this.AddSortedData(param1);
         var _loc2_:Array = param1.mDataArray;
         _loc3_ = param1.mIndicesArray;
         _loc4_ = param1.mUserDataArray;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:Vector.<IView> = mCells;
         var _loc7_:int = 0;
         var _loc8_:int = int(_loc3_.length);
         var _loc9_:int = 0;
         var _loc10_:int = int(_loc6_.length);
         while(_loc9_ < _loc10_)
         {
            _loc11_ = _loc6_[_loc9_];
            _loc12_ = int(_loc3_[_loc7_]);
            if(this.GetDataIndexOfSortedIndex(mCellIndexToDataIndexMap[_loc9_]) == _loc12_)
            {
               _loc13_ = _loc5_ > 0 ? _loc4_[_loc9_] : new Object();
               _loc13_["isUpdate"] = false;
               (_loc11_ as DisplayObject).visible = true;
               _loc11_.Draw(mGridData.RequestItemAt(_loc12_),_loc13_);
               if(++_loc7_ >= _loc8_)
               {
                  break;
               }
            }
            _loc9_++;
         }
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,[]));
      }
      
      override public function SetGridView(param1:IView) : void
      {
         super.SetGridView(param1);
         mGridView.addEventListener(GridEvent.UPDATE_LAYOUT,this.CycleCells);
         mGridView.addEventListener(GridEvent.UPDATE_SIZE,this.OnGridResized);
      }
      
      override public function RemoveGridView() : void
      {
         if(mGridView != null)
         {
            mGridView.removeEventListener(GridEvent.UPDATE_LAYOUT,this.CycleCells);
            mGridView.removeEventListener(GridEvent.UPDATE_SIZE,this.OnGridResized);
         }
         super.RemoveGridView();
      }
      
      override public function GetLayoutBounds() : Rectangle
      {
         if(mCells.length == 0 || !this.mSortedIndexToDataIndex && !mGridData)
         {
            return new Rectangle();
         }
         var _loc1_:DisplayObject = mCells[0] as DisplayObject;
         var _loc2_:int = this.mSortedIndexToDataIndex ? int(this.mSortedIndexToDataIndex.length) : mGridData.length;
         var _loc3_:Number = Math.ceil(_loc2_ / mNumLines) * (this.CalculateCellViewHeight(_loc1_) + mCellMargin.Vertical);
         return new Rectangle(0,0,0,Math.ceil(_loc3_));
      }
      
      protected function CycleCells(param1:GridEvent) : Boolean
      {
         var _loc4_:Rectangle = null;
         var _loc6_:DisplayObject = null;
         var _loc10_:DisplayObject = null;
         var _loc12_:int = 0;
         var _loc14_:Object = null;
         var _loc19_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:int = 0;
         if(this.mbSuppressUpdates == true)
         {
            return false;
         }
         if(mCells.length == 0)
         {
            return false;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         _loc4_ = param1.mRect;
         var _loc5_:Number = _loc4_.y - this.mPrevRectangleUpdate.y;
         this.mPrevRectangleUpdate.y = _loc4_.y;
         var _loc7_:Vector.<IView> = mCells;
         var _loc8_:Vector.<Number> = this.mCellsY;
         var _loc9_:Vector.<int> = mCellIndexToDataIndexMap;
         _loc10_ = _loc7_[0] as DisplayObject;
         var _loc11_:Number = this.CalculateCellViewHeight(_loc10_) + mCellMargin.Vertical;
         var _loc13_:int = int(_loc7_.length);
         var _loc15_:int = 0;
         var _loc16_:Number = 0;
         var _loc17_:int = mNumLines;
         if(Math.abs(_loc5_) > _loc11_ * (_loc13_ / _loc17_ - 1))
         {
            _loc19_ = Math.floor(-_loc4_.y / _loc11_) * _loc17_;
            _loc20_ = _loc4_.y % _loc11_ + mCellMargin.mTop;
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc21_ = _loc19_ + _loc12_;
               _loc6_ = _loc7_[_loc12_] as DisplayObject;
               _loc8_[_loc12_] = _loc20_;
               _loc6_.y = _loc20_;
               _loc9_[_loc12_] = _loc21_;
               _loc14_ = this.GetDataAtIndex(_loc21_);
               if(_loc14_)
               {
                  _loc6_.visible = true;
                  (_loc6_ as IView).Draw(_loc14_);
               }
               else
               {
                  _loc6_.visible = false;
               }
               if(++_loc15_ >= _loc17_)
               {
                  _loc20_ += _loc11_;
                  _loc15_ = 0;
               }
               _loc12_++;
            }
            return true;
         }
         var _loc18_:Boolean = false;
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc6_ = _loc7_[_loc12_] as DisplayObject;
            _loc16_ = _loc8_[_loc12_] + _loc5_;
            _loc8_[_loc12_] = _loc16_;
            _loc6_.y = _loc16_;
            if(_loc5_ < 0 && _loc16_ + _loc11_ <= 0)
            {
               _loc2_.push(_loc6_);
               _loc18_ = true;
            }
            else if(_loc5_ > 0 && _loc16_ > mGridView.height)
            {
               _loc3_.unshift(_loc6_);
               _loc18_ = true;
            }
            _loc12_++;
         }
         this.ExitCells(_loc2_,true);
         this.ExitCells(_loc3_,false);
         return _loc18_;
      }
      
      public function ResetAndPositionCells() : void
      {
         if(this.mbSuppressUpdates)
         {
            return;
         }
         if(this.mPrevRectangleUpdate)
         {
            this.mPrevRectangleUpdate.y = 0;
         }
         this.SetupCells();
         if(mCells.length > 0)
         {
            this.PositionCellsInternal(true);
            this.InitializeCellData(true);
         }
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,new Array()));
      }
      
      override public function PositionCells() : void
      {
         var _loc2_:DisplayObject = null;
         if(this.mbSuppressUpdates)
         {
            return;
         }
         this.SetupCells();
         if(mCells.length == 0)
         {
            mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,new Array()));
            return;
         }
         this.PositionCellsInternal();
         this.InitializeCellData();
         var _loc1_:Array = new Array();
         _loc2_ = mCells[0] as DisplayObject;
         var _loc3_:Number = this.CalculateCellViewHeight(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < mCells.length)
         {
            if(this.mCellsY[_loc4_] + _loc3_ <= 0)
            {
               _loc1_.push(mCells[_loc4_]);
            }
            _loc4_++;
         }
         this.ExitCells(_loc1_,true);
         mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,new Array()));
      }
      
      protected function PositionCellsInternal(param1:Boolean = false) : void
      {
         var _loc2_:DisplayObject = null;
         _loc2_ = mCells[0] as DisplayObject;
         var _loc3_:Number = this.CalculateCellViewHeight(_loc2_);
         var _loc4_:Number = this.CalculateCellViewWidth(_loc2_);
         var _loc5_:Number = this.mCellsY[0] == 0 || param1 ? mCellMargin.mTop : this.mCellsY[0];
         var _loc6_:Number = mCellMargin.mLeft;
         var _loc7_:int = 0;
         var _loc8_:int = mNumLines;
         var _loc9_:int = 0;
         while(_loc9_ < mCells.length)
         {
            _loc2_ = mCells[_loc9_] as DisplayObject;
            this.mCellsY[_loc9_] = _loc5_;
            _loc2_.y = _loc5_;
            _loc2_.x = _loc6_;
            if(++_loc7_ >= _loc8_)
            {
               _loc5_ += _loc3_ + mCellMargin.Vertical;
               _loc6_ = mCellMargin.mLeft;
               _loc7_ = 0;
            }
            else
            {
               _loc6_ += _loc4_ + mCellMargin.Horizontal;
            }
            _loc9_++;
         }
      }
      
      public function Clear() : void
      {
         super.OnFeedRemoveAll(null);
      }
      
      protected function InitializeCellData(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc6_:IView = null;
         var _loc3_:int = param1 ? 0 : mCellIndexToDataIndexMap[0];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < mCells.length)
         {
            _loc6_ = mCells[_loc5_];
            _loc4_ = _loc5_ + _loc3_;
            mCellIndexToDataIndexMap[_loc5_] = _loc4_;
            _loc2_ = this.GetDataAtIndex(_loc4_);
            if(_loc2_)
            {
               (_loc6_ as DisplayObject).visible = true;
               _loc6_.Draw(_loc2_);
            }
            else
            {
               (_loc6_ as DisplayObject).visible = false;
            }
            _loc5_++;
         }
      }
      
      protected function SetupCells() : void
      {
         var _loc2_:IView = null;
         var _loc1_:int = this.DetermineCellCount();
         if(Boolean(this.mCellsY) && Boolean(mCellIndexToDataIndexMap))
         {
            this.mCellsY.length = _loc1_;
            mCellIndexToDataIndexMap.length = _loc1_;
         }
         else
         {
            this.mCellsY = new Vector.<Number>(_loc1_);
            mCellIndexToDataIndexMap = new Vector.<int>(_loc1_);
         }
         if(_loc1_ > mCells.length)
         {
            while(_loc1_ > mCells.length)
            {
               _loc2_ = CreateCell();
               mCells.push(_loc2_);
               mGridView.addChild(_loc2_ as DisplayObject);
            }
         }
         else
         {
            while(mCells.length > _loc1_)
            {
               mGridView.removeChild(mCells.pop() as DisplayObject);
            }
         }
      }
      
      protected function DetermineCellCount() : int
      {
         var _loc2_:Number = NaN;
         var _loc1_:DisplayObject = null;
         if(this.mCellViewSizeFallback == null)
         {
            _loc1_ = CreateCell() as DisplayObject;
         }
         _loc2_ = this.CalculateCellViewHeight(_loc1_) + mCellMargin.Vertical;
         var _loc3_:Number = this.CalculateCellViewWidth(_loc1_) + mCellMargin.Horizontal;
         var _loc4_:int = Math.ceil(mGridView.height / _loc2_);
         var _loc5_:int = mbAutoFill ? int(Math.floor(mGridView.width / _loc3_)) : mNumLines;
         mNumLines = _loc5_;
         return (_loc4_ + 1) * mNumLines;
      }
      
      protected function ExitCells(param1:Array, param2:Boolean) : void
      {
         var _loc3_:Vector.<IView> = null;
         var _loc7_:DisplayObject = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc16_:DisplayObject = null;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         _loc3_ = mCells;
         var _loc4_:Vector.<Number> = this.mCellsY;
         var _loc5_:Vector.<int> = mCellIndexToDataIndexMap;
         var _loc6_:int = _loc3_.length - 1;
         if(param2)
         {
            _loc7_ = _loc3_[_loc6_] as DisplayObject;
         }
         else
         {
            _loc7_ = _loc3_[0] as DisplayObject;
         }
         var _loc8_:Number = this.CalculateCellViewHeight(_loc7_) + mCellMargin.Vertical;
         var _loc13_:int = 0;
         var _loc14_:Number = 0;
         var _loc15_:int = mNumLines;
         for each(_loc16_ in param1)
         {
            _loc9_ = _loc3_.indexOf(_loc16_);
            _loc3_.splice(_loc9_,1);
            _loc4_.splice(_loc9_,1);
            if(param2)
            {
               _loc14_ = _loc7_.y + _loc8_;
               _loc3_.push(_loc16_);
               _loc4_.push(_loc14_);
            }
            else
            {
               _loc14_ = _loc7_.y - _loc8_;
               _loc3_.unshift(_loc16_);
               _loc4_.unshift(_loc14_);
            }
            _loc16_.y = _loc14_;
            _loc11_ = 0;
            _loc12_ = int(_loc5_.length);
            while(_loc11_ < _loc12_)
            {
               _loc5_[_loc11_] += param2 ? 1 : -1;
               _loc11_++;
            }
            _loc10_ = this.GetDataAtIndex(_loc5_[param2 ? _loc6_ : 0]);
            if(_loc10_)
            {
               _loc16_.visible = true;
               (_loc16_ as IView).Draw(_loc10_);
            }
            else
            {
               _loc16_.visible = false;
            }
            if(++_loc13_ >= _loc15_)
            {
               _loc7_ = _loc16_;
               _loc13_ = 0;
            }
         }
      }
      
      override public function GetGridDimensions() : Array
      {
         var _loc1_:int = this.mSortedIndexToDataIndex ? int(this.mSortedIndexToDataIndex.length) : mGridData.length;
         if(mNumLines == 0)
         {
            return mbHorizontal ? [_loc1_,1] : [1,_loc1_];
         }
         if(mbHorizontal)
         {
            return [mNumLines,Math.ceil(_loc1_ / mNumLines)];
         }
         return [Math.ceil(_loc1_ / mNumLines),mNumLines];
      }
      
      override public function GetNumItems() : int
      {
         return this.mSortedIndexToDataIndex ? int(this.mSortedIndexToDataIndex.length) : mGridData.length;
      }
      
      override public function GetViewAtIndex(param1:int) : IView
      {
         if(!mGridData || param1 < 0 || param1 >= mGridData.length)
         {
            return null;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < mCellIndexToDataIndexMap.length)
         {
            if(mCellIndexToDataIndexMap[_loc2_] == param1)
            {
               return mCells[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function GetDataAtIndex(param1:int) : Object
      {
         if(this.mSortedIndexToDataIndex)
         {
            if(param1 < 0 || param1 >= this.mSortedIndexToDataIndex.length)
            {
               return null;
            }
            return mGridData.RequestItemAt(this.mSortedIndexToDataIndex[param1]);
         }
         return super.GetDataAtIndex(param1);
      }
      
      override public function GetGridIndexOfCell(param1:DisplayObject) : int
      {
         return GetCellIndexToDataIndex(mCells.indexOf(param1));
      }
      
      public function GetFilteredDataIndices() : Array
      {
         return this.mSortedIndexToDataIndex;
      }
      
      protected function AddSortedData(param1:DataFeedEvent) : void
      {
         var _loc2_:int = 0;
         if(!this.mSortedIndexToDataIndex)
         {
            return;
         }
         for each(_loc2_ in param1.mIndicesArray)
         {
            this.mSortedIndexToDataIndex.push(_loc2_);
         }
      }
      
      protected function AddSortedDataToFront(param1:DataFeedEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this.mSortedIndexToDataIndex)
         {
            return;
         }
         for each(_loc3_ in param1.mIndicesArray)
         {
            this.mSortedIndexToDataIndex.unshift(_loc3_);
         }
         _loc5_ = _loc4_ = int(param1.mIndicesArray.length);
         while(_loc5_ < this.mSortedIndexToDataIndex.length)
         {
            this.mSortedIndexToDataIndex[_loc5_] += _loc4_;
            _loc5_++;
         }
      }
      
      protected function RemoveSortedData(param1:DataFeedEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this.mSortedIndexToDataIndex)
         {
            return;
         }
         var _loc3_:Array = this.mSortedIndexToDataIndex;
         for each(_loc4_ in param1.mIndicesArray)
         {
            _loc2_ = _loc3_.indexOf(_loc4_);
            if(_loc2_ != -1)
            {
               _loc3_.splice(_loc2_,1);
            }
         }
         _loc5_ = int(param1.mIndicesArray.length);
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(_loc3_[_loc6_] > _loc4_)
            {
               _loc3_[_loc6_] -= _loc5_;
            }
            _loc6_++;
         }
      }
      
      protected function GetDataIndexOfSortedIndex(param1:int) : int
      {
         if(this.mSortedIndexToDataIndex)
         {
            if(param1 >= 0 || param1 < this.mSortedIndexToDataIndex.length)
            {
               return this.mSortedIndexToDataIndex[param1];
            }
            return -1;
         }
         return param1;
      }
      
      protected function GetSortedIndexOfDataIndex(param1:int) : int
      {
         if(this.mSortedIndexToDataIndex)
         {
            return this.mSortedIndexToDataIndex.indexOf(param1);
         }
         return param1;
      }
   }
}

