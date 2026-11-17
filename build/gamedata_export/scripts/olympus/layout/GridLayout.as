package olympus.layout
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.Ticker;
   import olympus.core.widget.Margin;
   import olympus.events.DataFeedEvent;
   import olympus.events.GridEvent;
   import olympus.events.TickerEvent;
   import olympus.extensions.AudioExtension;
   import olympus.gui.events.GUIEvent;
   import olympus.interfaces.IDataFeed;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IGridLayout;
   import olympus.interfaces.IView;
   import olympus.motion.TweenParams;
   import olympus.views.GridView;
   
   public class GridLayout implements IGridLayout
   {
      
      protected static const DATA_DEFAULT:String = "DataDefault";
      
      protected var mGridData:IDataFeed;
      
      protected var mGridView:GridView;
      
      protected var mCellIndexToDataIndexMap:Vector.<int> = new Vector.<int>();
      
      protected var mCellType:Class;
      
      protected var mCellMargin:Margin;
      
      protected var mCellBounds:Rectangle;
      
      protected var mCellEvents:Array;
      
      protected var mCellAudioName:String;
      
      protected var mCells:Vector.<IView> = new Vector.<IView>();
      
      protected var mbAutoFill:Boolean;
      
      protected var mbHorizontal:Boolean;
      
      protected var mNumLines:int;
      
      protected var mLastLineRemainingSize:Number;
      
      protected var mAddedCellsToProcess:Array = new Array();
      
      protected var mPreviousLayoutBounds:Rectangle = null;
      
      protected var mbUseRedrawListener:Boolean;
      
      protected var mbCellPosLeftToRight:Boolean;
      
      protected var mbCellPosTopToBottom:Boolean;
      
      protected var mGroupMargin:Number = 0;
      
      protected var mGroupIndexCallback:Function = null;
      
      protected var mAnimateInDelay:int;
      
      protected var mAnimateInParams:TweenParams;
      
      protected var mAnimateInGrowthPoint:Point;
      
      protected var mAnimateOutDelay:int;
      
      protected var mAnimateOutParams:TweenParams;
      
      protected var mAnimateOutGrowthPoint:Point;
      
      protected var mAnimatingInClips:Array = new Array();
      
      protected var mAnimatingOutClips:Array = new Array();
      
      public function GridLayout(param1:Boolean = true, param2:Boolean = true, param3:int = 4, param4:Boolean = true, param5:Boolean = true)
      {
         super();
         this.mbAutoFill = param1;
         this.mbHorizontal = param2;
         this.mNumLines = param3;
         this.mbCellPosLeftToRight = param4;
         this.mbCellPosTopToBottom = param5;
      }
      
      public function SetCellViewAnimateInParams(param1:TweenParams, param2:int = 0, param3:Point = null) : void
      {
         this.mAnimateInParams = param1;
         this.mAnimateInDelay = param2;
         this.mAnimateOutGrowthPoint = param3;
      }
      
      public function SetCellViewAnimateOutParams(param1:TweenParams, param2:int = 0, param3:Point = null) : void
      {
         this.mAnimateOutParams = param1;
         this.mAnimateOutDelay = param2;
         this.mAnimateOutGrowthPoint = param3;
      }
      
      public function set NumLines(param1:int) : void
      {
         this.mNumLines = param1;
      }
      
      public function get Horizontal() : Boolean
      {
         return this.mbHorizontal;
      }
      
      public function get GetCellView() : Class
      {
         return this.mCellType;
      }
      
      public function SetCellView(param1:Class, param2:Margin = null, param3:Boolean = false) : void
      {
         var _loc4_:Object = new param1();
         if(!(_loc4_ is IView))
         {
            throw new Error("Trying to set a cell that isn\'t an IView! Ensure that the Cell class implements an IView or extends a Class that does!");
         }
         var _loc5_:DisplayObject = _loc4_ as DisplayObject;
         if(!_loc5_)
         {
            throw new Error("Trying to set a cell that cannot be added to the display hierarchy! Check to make sure the Cell class extends a Display Object!");
         }
         this.mCellType = param1;
         this.mCellMargin = param2 || new Margin(0);
         this.mbUseRedrawListener = param3;
      }
      
      public function RegisterCellEventListener(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Array = this.mCellEvents;
         if(!_loc3_)
         {
            _loc3_ = new Array();
         }
         if(_loc3_.indexOf(param1) < 0)
         {
            _loc3_.push(param1);
            if(param2)
            {
               this.AddEventListenerToAllCells(param1);
            }
         }
         this.mCellEvents = _loc3_;
      }
      
      public function UnregisterCellEventListener(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Array = this.mCellEvents;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ > -1)
         {
            if(param2)
            {
               this.RemoveEventListenerFromAllCells(param1);
            }
            _loc3_.splice(_loc4_,1);
         }
      }
      
      public function SetCellViewAudioElementName(param1:String) : void
      {
         var _loc2_:IExtendable = null;
         var _loc3_:Vector.<IView> = null;
         var _loc5_:int = 0;
         this.mCellAudioName = param1;
         _loc3_ = this.mCells;
         var _loc4_:int = int(_loc3_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_] is IExtendable)
            {
               _loc2_ = _loc3_[_loc5_] as IExtendable;
               (_loc2_.GetExtension(AudioExtension) as AudioExtension).ElementName = param1;
            }
            _loc5_++;
         }
      }
      
      public function GetDataFeed() : IDataFeed
      {
         return this.mGridData;
      }
      
      public function SetDataFeed(param1:IDataFeed) : void
      {
         var _loc2_:Array = null;
         var _loc3_:IView = null;
         var _loc6_:Object = null;
         if(this.mGridData == param1)
         {
            return;
         }
         if(this.mGridData)
         {
            this.mGridData.Destroy();
            this.RemoveDataFeed();
         }
         this.mGridData = param1;
         param1.addEventListener(DataFeedEvent.UPDATE,this.OnFeedUpdate,false,0,true);
         param1.addEventListener(DataFeedEvent.ADD,this.OnFeedAdd,false,0,true);
         param1.addEventListener(DataFeedEvent.ADD_TO_FRONT,this.OnFeedAddToFront,false,0,true);
         param1.addEventListener(DataFeedEvent.REMOVE,this.OnFeedRemove,false,0,true);
         param1.addEventListener(DataFeedEvent.REMOVE_ALL,this.OnFeedRemoveAll,false,0,true);
         param1.addEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false,0,true);
         _loc2_ = param1.IterateWith(this.CreateCell);
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc3_ = _loc6_.ret;
            this.mCellIndexToDataIndexMap[_loc5_] = _loc6_.id;
            this.mAddedCellsToProcess.push(_loc3_ as DisplayObject);
            this.mCells.push(this.mGridView.addChild(_loc3_ as DisplayObject));
            _loc3_.Draw(this.mGridData.RequestItemAt(_loc6_.id),{"isUpdate":false});
            _loc5_++;
         }
         this.PositionCells();
      }
      
      public function RemoveDataFeed() : void
      {
         if(this.mGridData != null)
         {
            this.mGridData.removeEventListener(DataFeedEvent.UPDATE,this.OnFeedUpdate,false);
            this.mGridData.removeEventListener(DataFeedEvent.ADD,this.OnFeedAdd,false);
            this.mGridData.removeEventListener(DataFeedEvent.ADD_TO_FRONT,this.OnFeedAddToFront,false);
            this.mGridData.removeEventListener(DataFeedEvent.REMOVE,this.OnFeedRemove,false);
            this.mGridData.removeEventListener(DataFeedEvent.REMOVE_ALL,this.OnFeedRemoveAll,false);
            this.mGridData.removeEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false);
            this.mGridData = null;
         }
         this.OnFeedRemoveAll(null);
      }
      
      public function SetGridView(param1:IView) : void
      {
         this.mGridView = param1 as GridView;
         if(this.mbHorizontal)
         {
            this.mLastLineRemainingSize = this.mGridView.x + this.mGridView.width;
         }
         else
         {
            this.mLastLineRemainingSize = this.mGridView.y + this.mGridView.height;
         }
      }
      
      public function RemoveGridView() : void
      {
         this.mGridView = null;
      }
      
      public function CreateCell(param1:Object = null) : IView
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(this.mCellType == null)
         {
            throw new Error("Trying to create cell of an undefined class type! Did you set the view-class before this call?");
         }
         var _loc2_:Class = this.mCellType;
         var _loc3_:IView = new _loc2_();
         if(this.mCellBounds)
         {
            if(this.mCellBounds.width)
            {
               (_loc3_ as DisplayObject).width = this.mCellBounds.width;
            }
            if(this.mCellBounds.height)
            {
               (_loc3_ as DisplayObject).height = this.mCellBounds.height;
            }
         }
         if(this.mCellEvents)
         {
            _loc4_ = this.mCellEvents;
            for each(_loc5_ in _loc4_)
            {
               (_loc3_ as DisplayObject).addEventListener(_loc5_,this.OnCellEventDispatched,false,0,true);
            }
         }
         if(this.mbUseRedrawListener)
         {
            (_loc3_ as DisplayObject).addEventListener(GUIEvent.REDRAW,this.OnRedrawRequest,false,0,true);
         }
         if(Boolean(this.mCellAudioName) && _loc3_ is IExtendable)
         {
            ((_loc3_ as IExtendable).GetExtension(AudioExtension) as AudioExtension).ElementName = this.mCellAudioName;
         }
         return _loc3_;
      }
      
      public function PositionCells() : void
      {
         var _loc10_:Boolean = false;
         var _loc14_:DisplayObject = null;
         var _loc16_:int = 0;
         var _loc20_:String = null;
         var _loc21_:Margin = null;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc24_:int = 0;
         var _loc25_:Rectangle = null;
         var _loc26_:Rectangle = null;
         if(this.mAnimatingOutClips.length != 0)
         {
            this.RemoveAllAnimatingOutClips();
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = this.mbAutoFill;
         var _loc5_:Number = this.mGridView.width;
         var _loc6_:Number = this.mGridView.height;
         var _loc7_:int = this.mNumLines - 1;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         _loc10_ = this.mbCellPosLeftToRight;
         var _loc11_:Boolean = this.mbCellPosTopToBottom;
         var _loc12_:Number = _loc10_ ? 1 : -1;
         var _loc13_:Number = _loc11_ ? 1 : -1;
         var _loc15_:int = int(this.mCells.length);
         var _loc17_:uint = 0;
         var _loc18_:int = 0;
         _loc16_ = 0;
         while(_loc16_ < _loc15_)
         {
            _loc14_ = this.mCells[_loc16_] as DisplayObject;
            _loc20_ = (_loc14_ as Object).constructor;
            _loc21_ = this.mCellMargin;
            if(Boolean(this.mGroupIndexCallback) && _loc3_ == 0)
            {
               _loc22_ = this.mGroupIndexCallback(_loc16_);
               if(_loc16_ > 0 && _loc22_ != _loc18_)
               {
                  _loc1_ += !this.mbHorizontal ? _loc12_ * this.mGroupMargin : 0;
                  _loc2_ += this.mbHorizontal ? _loc13_ * this.mGroupMargin : 0;
               }
               _loc18_ = _loc22_;
            }
            _loc14_.x = _loc1_ + (_loc10_ ? _loc21_.mLeft : -(_loc14_.width + _loc21_.mRight));
            _loc14_.y = _loc2_ + (_loc11_ ? _loc21_.mTop : -(_loc14_.height + _loc21_.mBot));
            if(_loc4_)
            {
               if(this.mbHorizontal)
               {
                  _loc1_ += _loc12_ * (_loc21_.Horizontal + _loc14_.width);
                  if(Math.abs(_loc1_) > _loc5_ && _loc8_ != 0)
                  {
                     this.mNumLines = _loc17_;
                     _loc17_ = 0;
                     _loc1_ = _loc12_ * (_loc21_.Horizontal + _loc14_.width);
                     _loc2_ += _loc13_ * (_loc21_.Vertical + _loc8_);
                     _loc14_.x = _loc10_ ? _loc21_.mLeft : -(_loc14_.width + _loc21_.mRight);
                     _loc14_.y = _loc2_ + (_loc11_ ? _loc21_.mTop : -(_loc14_.height + _loc21_.mBot));
                  }
               }
               else
               {
                  _loc2_ += _loc13_ * (_loc21_.Vertical + _loc14_.height);
                  if(Math.abs(_loc2_) > _loc6_)
                  {
                     this.mNumLines = _loc17_;
                     _loc17_ = 0;
                     _loc2_ = _loc13_ * (_loc21_.Vertical + _loc14_.height);
                     _loc1_ += _loc12_ * (_loc21_.Horizontal + _loc9_);
                     _loc14_.y = _loc11_ ? _loc21_.mTop : -(_loc14_.height + _loc21_.mBot);
                     _loc14_.x = _loc1_ + (_loc10_ ? _loc21_.mLeft : -(_loc14_.width + _loc21_.mRight));
                  }
               }
               _loc8_ = _loc14_.height;
               _loc9_ = _loc14_.width;
            }
            else if(this.mbHorizontal)
            {
               _loc1_ = _loc14_.x + (_loc10_ ? _loc14_.width + _loc21_.mRight : -_loc21_.mLeft);
               if(++_loc3_ > _loc7_ && _loc7_ >= 0)
               {
                  _loc1_ = 0;
                  _loc3_ = 0;
                  _loc2_ = _loc14_.y + (_loc11_ ? _loc14_.height + _loc21_.mBot : -_loc21_.mTop);
               }
            }
            else
            {
               _loc2_ = _loc14_.y + (_loc11_ ? _loc14_.height + _loc21_.mBot : -_loc21_.mTop);
               if(++_loc3_ > _loc7_ && _loc7_ >= 0)
               {
                  _loc2_ = 0;
                  _loc3_ = 0;
                  _loc1_ = _loc14_.x + (_loc10_ ? _loc14_.width + _loc21_.mRight : -_loc21_.mLeft);
               }
            }
            _loc17_++;
            _loc16_++;
         }
         if(_loc4_ && _loc17_ > this.mNumLines)
         {
            this.mNumLines = _loc17_;
         }
         if(this.mbHorizontal)
         {
            this.mLastLineRemainingSize = _loc5_ - _loc1_;
         }
         else
         {
            this.mLastLineRemainingSize = _loc6_ - _loc2_;
         }
         var _loc19_:Rectangle = this.GetLayoutBounds();
         if(!this.mPreviousLayoutBounds || _loc19_.height > this.mPreviousLayoutBounds.height || _loc19_.width > this.mPreviousLayoutBounds.width)
         {
            this.mPreviousLayoutBounds = _loc19_;
            _loc23_ = new Array();
            _loc24_ = int(this.mAddedCellsToProcess.length);
            _loc16_ = 0;
            while(_loc16_ < _loc24_)
            {
               _loc14_ = this.mAddedCellsToProcess[_loc16_] as DisplayObject;
               _loc25_ = _loc14_.getBounds(this.mGridView);
               _loc26_ = new Rectangle(_loc25_.x,_loc25_.y,_loc25_.width + this.mCellMargin.Horizontal,_loc25_.height + this.mCellMargin.Vertical);
               _loc23_.push(_loc26_);
               _loc16_++;
            }
            this.mAddedCellsToProcess.length = 0;
            this.mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE,null,_loc23_));
         }
         else if(!this.mPreviousLayoutBounds || _loc19_.height < this.mPreviousLayoutBounds.height || _loc19_.width < this.mPreviousLayoutBounds.width)
         {
            this.mPreviousLayoutBounds = _loc19_;
            this.mGridView.dispatchEvent(new GridEvent(GridEvent.RESIZE));
         }
      }
      
      public function GetVisibleCells(param1:Rectangle, param2:DisplayObject) : Vector.<IView>
      {
         var _loc5_:DisplayObject = null;
         var _loc3_:Vector.<IView> = this.mCells;
         var _loc4_:Vector.<IView> = new Vector.<IView>();
         for each(_loc5_ in this.mCells)
         {
            if(_loc5_.visible && param1.intersects(_loc5_.getBounds(param2)))
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      public function GetAllCells() : Vector.<IView>
      {
         return this.mCells;
      }
      
      public function GetAllDisplayObjectCells() : Vector.<DisplayObject>
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         for each(_loc2_ in this.mCells)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function get FirstCell() : IView
      {
         if(this.mCells.length > 0)
         {
            return this.mCells[0];
         }
         return null;
      }
      
      public function get LastCell() : IView
      {
         if(this.mCells.length > 0)
         {
            return this.mCells[this.mCells.length - 1];
         }
         return null;
      }
      
      public function GetPreviousCell(param1:IView) : IView
      {
         var _loc3_:IView = null;
         var _loc2_:IView = null;
         for each(_loc3_ in this.mCells)
         {
            if(_loc3_ == param1)
            {
               return _loc2_;
            }
            _loc2_ = _loc3_;
         }
         return _loc2_;
      }
      
      public function GetNextCell(param1:IView) : IView
      {
         var _loc3_:IView = null;
         var _loc2_:IView = null;
         for each(_loc3_ in this.mCells)
         {
            if(_loc2_ == param1 || !param1)
            {
               return _loc3_;
            }
            _loc2_ = _loc3_;
         }
         return null;
      }
      
      public function CellsToFitInLastLine() : int
      {
         var _loc1_:Margin = this.mCellMargin;
         var _loc2_:Rectangle = this.GetCellBounds();
         var _loc3_:Number = this.mbHorizontal ? _loc2_.width : _loc2_.height;
         var _loc4_:Number = this.mbHorizontal ? _loc1_.Horizontal : _loc1_.Vertical;
         var _loc5_:Number = _loc3_ + _loc4_;
         if(_loc5_ == 0)
         {
            return 0;
         }
         return int(this.mLastLineRemainingSize / _loc5_);
      }
      
      public function GetLayoutBounds() : Rectangle
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Rectangle = new Rectangle();
         for each(_loc2_ in this.mCells)
         {
            _loc1_ = _loc2_.getBounds(this.mGridView).union(_loc1_);
         }
         if(this.mCellMargin)
         {
            _loc1_.width += this.mCellMargin.Horizontal;
            _loc1_.height += this.mCellMargin.Vertical;
            _loc1_.x -= this.mCellMargin.mLeft;
            _loc1_.y -= this.mCellMargin.mTop;
         }
         return _loc1_;
      }
      
      public function GetCellBounds() : Rectangle
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         if(this.mCellBounds)
         {
            _loc2_ = this.mCellBounds.clone();
            if(Boolean(_loc2_.width) && Boolean(_loc2_.height))
            {
               return _loc2_;
            }
            if(this.mCellType)
            {
               _loc1_ = new this.mCellType();
               _loc3_ = _loc1_.getBounds(_loc1_);
               if(!_loc2_.width)
               {
                  _loc2_.width = _loc3_.width;
               }
               if(!_loc2_.height)
               {
                  _loc2_.height = _loc3_.height;
               }
               return _loc2_;
            }
         }
         else if(this.mCellType)
         {
            _loc1_ = new this.mCellType();
            return _loc1_.getBounds(_loc1_);
         }
         return null;
      }
      
      public function SetCellBounds(param1:Rectangle) : void
      {
         var _loc3_:DisplayObject = null;
         this.mCellBounds = param1;
         if(!param1)
         {
            return;
         }
         var _loc2_:Vector.<IView> = this.mCells;
         if(param1.width)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.width = param1.width;
            }
         }
         if(param1.height)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.height = param1.height;
            }
         }
         this.PositionCells();
      }
      
      public function GetCellPadding() : Margin
      {
         return this.mCellMargin;
      }
      
      public function SetCellPadding(param1:Margin) : void
      {
         this.mCellMargin = param1;
         this.PositionCells();
      }
      
      public function SetGroupPadding(param1:Number, param2:Function = null) : void
      {
         if(this.mbAutoFill)
         {
            return;
         }
         this.mGroupMargin = param1;
         this.mGroupIndexCallback = param2;
         this.PositionCells();
      }
      
      public function GetGroupPadding() : Number
      {
         if(!this.mbAutoFill && Boolean(this.mGroupIndexCallback))
         {
            return this.mGroupMargin;
         }
         return 0;
      }
      
      protected function OnFeedUpdate(param1:DataFeedEvent) : void
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
            _loc8_ = this.mCellIndexToDataIndexMap.indexOf(_loc7_);
            if(_loc8_ != -1)
            {
               _loc9_ = _loc5_ > 0 ? _loc4_[_loc6_] : new Object();
               _loc9_["isUpdate"] = true;
               _loc10_ = this.mCells[_loc8_];
               _loc10_.Draw(this.mGridData.RequestItemAt(_loc7_),_loc9_);
            }
            _loc6_++;
         }
      }
      
      protected function OnFeedAdd(param1:DataFeedEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc9_:IView = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:Object = null;
         _loc2_ = param1.mIndicesArray;
         _loc3_ = param1.mUserDataArray;
         var _loc4_:int = int(_loc3_.length);
         var _loc7_:int = int(_loc2_.length);
         var _loc8_:Array = new Array();
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_)
         {
            _loc6_ = this.mGridData.RequestItemAt(_loc2_[_loc10_]);
            _loc9_ = this.CreateCell(_loc6_);
            _loc11_ = _loc9_ as DisplayObject;
            this.mGridView.addChild(_loc11_);
            _loc12_ = _loc4_ > 0 ? _loc3_[_loc10_] : new Object();
            _loc12_["isUpdate"] = false;
            _loc9_.Draw(_loc6_,_loc12_);
            if(this.mAnimateInParams)
            {
               _loc8_.push(_loc9_);
            }
            _loc5_ = int(param1.mIndicesArray[_loc10_]);
            this.mCellIndexToDataIndexMap.push(_loc5_);
            this.mAddedCellsToProcess.push(_loc11_);
            this.mCells.push(_loc9_);
            _loc10_++;
         }
         this.PositionCells();
         this.mGridView.dispatchEvent(new GridEvent(GridEvent.CELLS_DRAWN));
         this.mAnimatingInClips = _loc8_;
         if(this.mAnimateInParams)
         {
            Ticker.Add(this.mGridView,1,this.OnNextTick);
         }
      }
      
      protected function OnFeedAddToFront(param1:DataFeedEvent) : void
      {
         var _loc2_:Array = null;
         var _loc12_:int = 0;
         _loc2_ = param1.mUserDataArray;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = int(param1.mIndicesArray.length);
         if(_loc4_ != 1)
         {
            throw new Error("Error - GridLayout:OnFeedAddToFront doesn\'t support adding more or less than 1 item. event.mIndicesArray.length = " + _loc4_);
         }
         var _loc5_:int = int(param1.mIndicesArray[0]);
         var _loc6_:int = int(this.mCellIndexToDataIndexMap.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc12_ = this.mCellIndexToDataIndexMap[_loc7_];
            if(_loc12_ >= _loc5_)
            {
               this.mCellIndexToDataIndexMap[_loc7_] += _loc4_;
            }
            _loc7_++;
         }
         var _loc8_:Object = this.mGridData.RequestItemAt(param1.mIndicesArray[0]);
         var _loc9_:IView = this.CreateCell(_loc8_);
         var _loc10_:DisplayObject = _loc9_ as DisplayObject;
         this.mGridView.addChild(_loc10_);
         var _loc11_:Object = _loc3_ > 0 ? _loc2_[0] : new Object();
         _loc11_["isUpdate"] = false;
         _loc9_.Draw(_loc8_,_loc11_);
         this.mCellIndexToDataIndexMap.unshift(_loc5_);
         this.mAddedCellsToProcess.push(_loc10_);
         this.mCells.unshift(_loc9_);
         this.PositionCells();
         this.mGridView.dispatchEvent(new GridEvent(GridEvent.CELLS_DRAWN));
         this.mAnimatingInClips = [_loc10_];
         if(this.mAnimateInParams)
         {
            Ticker.Add(this.mGridView,1,this.OnNextTick);
         }
      }
      
      protected function OnFeedRemove(param1:DataFeedEvent) : void
      {
         if(!this.mAnimateOutParams)
         {
            this.RemoveCells(param1.mIndicesArray,false);
         }
         else
         {
            this.RemoveCells(param1.mIndicesArray,true);
         }
      }
      
      protected function RemoveCells(param1:Array, param2:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:int = -1;
         var _loc4_:int = int(param1.length);
         if(_loc4_ > 0)
         {
            _loc3_ = int(param1[0]);
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = this.mCellIndexToDataIndexMap.indexOf(param1[_loc5_]);
            if(_loc7_ != -1)
            {
               _loc8_ = this.mCells[_loc7_] as DisplayObject;
               if(this.mGridView.contains(_loc8_))
               {
                  this.mCellIndexToDataIndexMap.splice(_loc7_,1);
                  this.mCells.splice(this.mCells.indexOf(_loc8_),1);
                  _loc9_ = this.mAddedCellsToProcess.indexOf(_loc8_);
                  if(_loc9_ != -1)
                  {
                     this.mAddedCellsToProcess.splice(_loc9_,1);
                  }
                  if(param2)
                  {
                     for each(_loc10_ in this.mCellEvents)
                     {
                        _loc8_.removeEventListener(_loc10_,this.OnCellEventDispatched);
                     }
                     _loc11_ = (_loc8_ as IView).AnimateOut(this.mAnimateOutDelay,this.mAnimateOutParams,this.mAnimateOutGrowthPoint);
                     Ticker.Add(_loc8_,_loc11_,this.OnAnimateOutComplete);
                     this.mAnimatingOutClips.push(_loc8_);
                  }
                  else
                  {
                     this.mGridView.removeChild(_loc8_);
                  }
               }
            }
            _loc5_++;
         }
         var _loc6_:int = int(this.mCellIndexToDataIndexMap.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc12_ = this.mCellIndexToDataIndexMap[_loc5_];
            if(_loc12_ > _loc3_)
            {
               this.mCellIndexToDataIndexMap[_loc5_] -= _loc4_;
            }
            _loc5_++;
         }
         this.mPreviousLayoutBounds = null;
         if(this.mAnimatingOutClips.length == 0)
         {
            this.PositionCells();
         }
      }
      
      protected function OnAnimateOutComplete(param1:TickerEvent) : void
      {
         this.RemoveAllAnimatingOutClips();
         this.PositionCells();
      }
      
      protected function RemoveAllAnimatingOutClips() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.mAnimatingOutClips)
         {
            if(Ticker.Has(_loc1_))
            {
               Ticker.Remove(_loc1_);
            }
            this.mGridView.removeChild(_loc1_);
         }
         this.mAnimatingOutClips.length = 0;
      }
      
      protected function OnFeedRemoveAll(param1:DataFeedEvent) : void
      {
         var _loc2_:IView = null;
         for each(_loc2_ in this.mCells)
         {
            if(this.mGridView.contains(_loc2_ as DisplayObject))
            {
               this.mGridView.removeChild(_loc2_ as DisplayObject);
            }
         }
         this.mCells.length = 0;
         this.mCellIndexToDataIndexMap.length = 0;
         this.mAddedCellsToProcess.length = 0;
         this.mPreviousLayoutBounds = null;
         this.PositionCells();
      }
      
      protected function OnFeedSortFilter(param1:DataFeedEvent) : void
      {
         var _loc3_:Vector.<IView> = null;
         var _loc10_:Array = null;
         var _loc12_:IView = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:DisplayObject = null;
         var _loc17_:IView = null;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         if(param1.mDataArray.length != this.mGridData.length)
         {
            throw new Error("OnFeedSortFilter - the data was changed during a sort and filter - not allowed!");
         }
         var _loc2_:int = int(param1.mIndicesArray.length);
         _loc3_ = this.mCells;
         var _loc4_:int;
         var _loc5_:* = _loc4_ = int(_loc3_.length);
         var _loc6_:Boolean = false;
         var _loc7_:Vector.<int> = new Vector.<int>(_loc2_);
         var _loc8_:GridView = this.mGridView;
         var _loc9_:Array = new Array();
         _loc10_ = param1.mUserDataArray;
         var _loc11_:int = int(_loc10_.length);
         var _loc13_:int = 0;
         while(_loc13_ < _loc2_)
         {
            if(_loc13_ >= _loc5_)
            {
               _loc12_ = this.CreateCell();
               _loc16_ = _loc12_ as DisplayObject;
               _loc8_.addChild(_loc16_);
               _loc14_ = int(_loc3_.length);
               this.mAddedCellsToProcess.push(_loc12_);
               _loc3_.push(_loc12_);
               _loc5_++;
               _loc6_ = true;
            }
            else
            {
               _loc12_ = _loc3_[_loc13_];
               _loc14_ = _loc13_;
            }
            _loc15_ = int(param1.mIndicesArray[_loc13_]);
            _loc7_[_loc14_] = _loc15_;
            _loc9_.push(_loc12_);
            _loc13_++;
         }
         while(_loc13_ < _loc5_)
         {
            _loc17_ = _loc3_[_loc13_];
            _loc8_.removeChild(_loc17_ as DisplayObject);
            _loc3_.splice(_loc13_,1);
            _loc6_ = true;
            _loc5_--;
         }
         this.mCellIndexToDataIndexMap = _loc7_;
         this.mCells = _loc3_;
         for each(_loc12_ in _loc9_)
         {
            _loc18_ = _loc7_[_loc3_.indexOf(_loc12_)];
            _loc19_ = _loc11_ > 0 ? _loc10_[_loc9_.indexOf(_loc12_)] : new Object();
            _loc19_["isUpdate"] = false;
            _loc12_.Draw(this.mGridData.RequestItemAt(_loc18_),_loc19_);
         }
         this.PositionCells();
         this.mGridView.dispatchEvent(new GridEvent(GridEvent.CELLS_DRAWN));
         if(_loc6_)
         {
            _loc8_.dispatchEvent(new GridEvent(GridEvent.RESIZE));
         }
      }
      
      protected function OnCellEventDispatched(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         _loc2_ = param1.currentTarget as DisplayObject;
         var _loc3_:GridEvent = new GridEvent(GridEvent.CELL_EVENT.concat(param1.type));
         _loc3_.mCellEvent = param1;
         _loc3_.mRect = _loc2_.getBounds(this.mGridView);
         var _loc4_:int = this.mCellIndexToDataIndexMap[this.mCells.indexOf(_loc2_)];
         _loc3_.mData = this.GetDataAtIndex(_loc4_);
         _loc3_.mDataIndex = _loc4_;
         _loc3_.mCellIndex = this.mCellIndexToDataIndexMap.indexOf(_loc4_);
         this.mGridView.dispatchEvent(_loc3_);
      }
      
      protected function AddEventListenerToAllCells(param1:String = "") : void
      {
         var _loc2_:DisplayObject = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc3_:Vector.<IView> = this.mCells;
         if(param1)
         {
            for each(_loc2_ in _loc3_)
            {
               _loc2_.addEventListener(param1,this.OnCellEventDispatched,false,0,true);
            }
         }
         else
         {
            _loc4_ = this.mCellEvents;
            if(!_loc4_)
            {
               return;
            }
            for each(_loc5_ in _loc4_)
            {
               for each(_loc2_ in _loc3_)
               {
                  _loc2_.addEventListener(_loc5_,this.OnCellEventDispatched,false,0,true);
               }
            }
         }
      }
      
      protected function RemoveEventListenerFromAllCells(param1:String = "") : void
      {
         var _loc2_:DisplayObject = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc3_:Vector.<IView> = this.mCells;
         if(param1)
         {
            for each(_loc2_ in _loc3_)
            {
               _loc2_.removeEventListener(param1,this.OnCellEventDispatched);
            }
         }
         else
         {
            _loc4_ = this.mCellEvents;
            if(!_loc4_)
            {
               return;
            }
            for each(_loc5_ in _loc4_)
            {
               for each(_loc2_ in _loc3_)
               {
                  _loc2_.removeEventListener(_loc5_,this.OnCellEventDispatched);
               }
            }
            this.mCellEvents = null;
         }
      }
      
      protected function OnRedrawRequest(param1:GUIEvent) : void
      {
         var _loc2_:IView = null;
         var _loc4_:int = 0;
         _loc2_ = param1.currentTarget as IView;
         var _loc3_:int = this.mCells.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return;
         }
         _loc4_ = this.mCellIndexToDataIndexMap[_loc3_];
         var _loc5_:Object = this.GetDataAtIndex(_loc4_);
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:Object = {
            "isRedraw":true,
            "isUpdate":false
         };
         _loc2_.Draw(_loc5_,_loc6_);
      }
      
      protected function OnNextTick() : void
      {
         var _loc2_:IView = null;
         var _loc3_:Number = NaN;
         if(Ticker.Has(this))
         {
            Ticker.Remove(this);
         }
         if(!this.mAnimateInParams)
         {
            return;
         }
         var _loc1_:Array = this.mAnimatingInClips;
         for each(_loc2_ in _loc1_)
         {
            _loc2_.AnimateIn(this.mAnimateInDelay,this.mAnimateInParams,this.mAnimateInGrowthPoint);
         }
         _loc3_ = this.mAnimateInDelay + this.mAnimateInParams.totalDuration;
         Ticker.Add(this,_loc3_,this.PositionCells);
         this.mAnimatingInClips.length = 0;
      }
      
      public function GetGridIndexOfCell(param1:DisplayObject) : int
      {
         return this.mCells.indexOf(param1);
      }
      
      public function GetCellIndexToDataIndex(param1:int) : int
      {
         return this.mCellIndexToDataIndexMap[param1];
      }
      
      public function GridCoordToIndex(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.max(this.mNumLines,1);
         if(this.mbHorizontal)
         {
            if(!this.mbCellPosLeftToRight)
            {
               param1 = _loc3_ - param1 - 1;
            }
            if(!this.mbCellPosTopToBottom)
            {
               param2 = Math.ceil(this.mCells.length / _loc3_) - param2 - 1;
            }
            param2 *= _loc3_;
         }
         else
         {
            if(!this.mbCellPosLeftToRight)
            {
               param1 = Math.ceil(this.mCells.length / _loc3_) - param1 - 1;
            }
            if(!this.mbCellPosTopToBottom)
            {
               param2 = _loc3_ - param2 - 1;
            }
            param1 *= _loc3_;
         }
         return param1 + param2;
      }
      
      public function GetGridDimensions() : Array
      {
         if(this.mNumLines == 0)
         {
            return this.mbHorizontal ? [this.mCellIndexToDataIndexMap.length,1] : [1,this.mCellIndexToDataIndexMap.length];
         }
         if(this.mbHorizontal)
         {
            return [this.mNumLines,Math.ceil(this.mCellIndexToDataIndexMap.length / this.mNumLines)];
         }
         return [Math.ceil(this.mCellIndexToDataIndexMap.length / this.mNumLines),this.mNumLines];
      }
      
      public function IndexToGridCoord(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = this.mNumLines;
         if(_loc2_ == 0)
         {
            return this.mbHorizontal ? [param1,0] : [0,param1];
         }
         if(this.mbHorizontal)
         {
            _loc3_ = param1 % _loc2_;
            _loc4_ = Math.floor(param1 / _loc2_);
            if(!this.mbCellPosLeftToRight)
            {
               _loc3_ = _loc2_ - _loc3_ - 1;
            }
            if(!this.mbCellPosTopToBottom)
            {
               _loc4_ = Math.ceil(this.mCells.length / _loc2_) - _loc4_ - 1;
            }
         }
         else
         {
            _loc3_ = Math.floor(param1 / _loc2_);
            _loc4_ = param1 % _loc2_;
            if(!this.mbCellPosLeftToRight)
            {
               _loc3_ = Math.ceil(this.mCells.length / _loc2_) - _loc3_ - 1;
            }
            if(!this.mbCellPosTopToBottom)
            {
               _loc4_ = _loc2_ - _loc4_ - 1;
            }
         }
         return [_loc3_,_loc4_];
      }
      
      public function GetNumItems() : int
      {
         return this.mCells.length;
      }
      
      public function GetViewAtIndex(param1:int) : IView
      {
         if(!this.mCells || param1 < 0 || param1 >= this.mCells.length)
         {
            return null;
         }
         return this.mCells[param1];
      }
      
      public function GetDataAtIndex(param1:int) : Object
      {
         if(!this.mGridData || param1 < 0 || param1 >= this.mGridData.length)
         {
            return null;
         }
         return this.mGridData.RequestItemAt(param1);
      }
      
      public function GetPositionOfIndex(param1:int) : Number
      {
         var _loc2_:Rectangle = this.GetCellBounds();
         var _loc3_:Margin = this.mCellMargin;
         var _loc4_:int = this.CountGroupsToIndex(param1);
         if(this.mbHorizontal)
         {
            return int(param1 / this.mNumLines) * (_loc2_.height + _loc3_.Vertical) + _loc4_ * this.mGroupMargin;
         }
         return int(param1 / this.mNumLines) * (_loc2_.width + _loc3_.Horizontal) + _loc4_ * this.mGroupMargin;
      }
      
      public function CountGroupsToIndex(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.mGroupIndexCallback))
         {
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ <= param1)
            {
               _loc5_ = this.mGroupIndexCallback(_loc4_);
               if(_loc4_ > 0 && _loc5_ != _loc3_)
               {
                  _loc2_++;
               }
               _loc3_ = _loc5_;
               _loc4_ += this.mNumLines;
            }
         }
         return _loc2_;
      }
   }
}

