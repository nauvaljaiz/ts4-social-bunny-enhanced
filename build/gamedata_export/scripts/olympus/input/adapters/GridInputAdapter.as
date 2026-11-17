package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.interfaces.IGridLayout;
   import olympus.interfaces.IView;
   
   public class GridInputAdapter extends InputAdapter
   {
      
      protected const DPAD_LEAVE_EDGE_NUMBER_OF_ROWS_TO_SKIP_DEFAULT:int = 2;
      
      protected var mLayout:IGridLayout;
      
      protected var mHighlightX:int = -1;
      
      protected var mHighlightY:int = -1;
      
      protected var mbUseDefaultConfirm:Boolean = true;
      
      protected var mbDPadLeaveEdgeSkipsRows:Boolean = false;
      
      protected var mDPadLeaveEdgeNumberOfRowsToSkip:int = 2;
      
      protected var mbInApplyDirectionalInput:Boolean = false;
      
      protected var mbSnapToPositionAfterDirectionalInput:Boolean = false;
      
      protected var mCellHeight:Number = -1;
      
      public function GridInputAdapter(param1:IGridLayout)
      {
         super();
         this.SetGridLayout(param1);
      }
      
      public function SetGridLayout(param1:IGridLayout) : GridInputAdapter
      {
         this.mLayout = param1;
         return this;
      }
      
      public function SetUseDefaultConfirm(param1:Boolean) : void
      {
         this.mbUseDefaultConfirm = param1;
      }
      
      public function SetUseDPadLeaveEdgeRowSkipBehavior(param1:Boolean) : void
      {
         this.mbDPadLeaveEdgeSkipsRows = param1;
      }
      
      public function SetDPadLeaveEdgeNumberOfRowsToSkip(param1:int) : void
      {
         this.mDPadLeaveEdgeNumberOfRowsToSkip = param1;
      }
      
      public function SetSnapToPositionAfterDirectionalInput(param1:Boolean, param2:Number) : void
      {
         this.mbSnapToPositionAfterDirectionalInput = param1;
         this.mCellHeight = param2;
         if(this.mbSnapToPositionAfterDirectionalInput && Boolean(mSliderHelper))
         {
            mSliderHelper.PreventScrollToDisplayObject = true;
         }
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddDirectionalInputs();
         AddConfirmAction();
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         var _loc2_:Array = null;
         super.OnEntered(param1);
         if(this.mHighlightX < 0 || this.mHighlightY < 0)
         {
            this.SetControllerHighlight(0,0,true);
         }
         else
         {
            _loc2_ = this.mLayout.GetGridDimensions();
            if(this.mHighlightX >= _loc2_[0])
            {
               this.mHighlightX = _loc2_[0] - 1;
            }
            if(this.mHighlightY >= _loc2_[1])
            {
               this.mHighlightY = _loc2_[1] - 1;
            }
            this.SetControllerHighlight(this.mHighlightX,this.mHighlightY,true);
         }
         return GetStackFocusable(param1);
      }
      
      override public function GetHighlightedObject() : DisplayObject
      {
         return this.mLayout.GetViewAtIndex(this.GetHighlightedIndex()) as DisplayObject;
      }
      
      public function GetHighlightedIndex() : int
      {
         return this.mLayout.GridCoordToIndex(this.mHighlightX,this.mHighlightY);
      }
      
      override public function ApplyDirectionalInput(param1:uint) : void
      {
         this.mbInApplyDirectionalInput = true;
         super.ApplyDirectionalInput(param1);
         this.mbInApplyDirectionalInput = false;
      }
      
      protected function GetCoordAfterEdgeBehavior(param1:uint, param2:int, param3:int) : int
      {
         switch(mEdgeBehavior)
         {
            default:
            case InputAdapter.EDGE_LEAVE:
               FireLeaveEvent(param1,GetCurrentHighlightPoint());
               return -1;
            case InputAdapter.EDGE_STOP:
               return param2;
            case InputAdapter.EDGE_LOOP:
               return param3;
         }
      }
      
      public function SetHighlightedIndex(param1:int, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:Array = this.mLayout.IndexToGridCoord(param1);
         this.SetControllerHighlight(_loc4_[0],_loc4_[1],param2,param3);
      }
      
      protected function SetControllerHighlight(param1:int, param2:int, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         if(this.mLayout == null)
         {
            return;
         }
         var _loc5_:Array = this.mLayout.GetGridDimensions();
         var _loc6_:int = this.mLayout.GetNumItems();
         var _loc7_:int = this.mLayout.GridCoordToIndex(param1,param2);
         var _loc8_:int = this.mLayout.GridCoordToIndex(this.mHighlightX,this.mHighlightY);
         if(param1 < 0)
         {
            if(this.mbDPadLeaveEdgeSkipsRows && this.mbInApplyDirectionalInput)
            {
               param1 = _loc5_[0] - 1;
               if(param2 > 0 && param2 < this.mDPadLeaveEdgeNumberOfRowsToSkip)
               {
                  param2 = 0;
               }
               else
               {
                  param2 -= this.mDPadLeaveEdgeNumberOfRowsToSkip;
               }
               if(param2 < 0)
               {
                  param2 = _loc5_[1] - 1;
               }
               this.SetControllerHighlight(param1,param2,param3,param4);
               return;
            }
            param1 = this.GetCoordAfterEdgeBehavior(NavDirection.LEFT,0,_loc5_[0] - 1);
            if(param1 == -1)
            {
               return;
            }
         }
         else if(param2 < 0)
         {
            param2 = this.GetCoordAfterEdgeBehavior(NavDirection.UP,0,_loc5_[1] - 1);
            if(param2 == -1)
            {
               return;
            }
         }
         if(this.mbDPadLeaveEdgeSkipsRows && this.mbInApplyDirectionalInput && (param1 >= _loc5_[0] || _loc7_ >= _loc6_ && _loc8_ == _loc6_ - 1))
         {
            param1 = 0;
            if(param2 != _loc5_[1] - 1 && param2 + this.mDPadLeaveEdgeNumberOfRowsToSkip >= _loc5_[1])
            {
               param2 = _loc5_[1] - 1;
            }
            else
            {
               param2 += this.mDPadLeaveEdgeNumberOfRowsToSkip;
            }
            if(param2 >= _loc5_[1])
            {
               param2 = 0;
            }
            this.SetControllerHighlight(param1,param2,param3,param4);
            return;
         }
         if(param1 >= _loc5_[0])
         {
            param1 = this.GetCoordAfterEdgeBehavior(NavDirection.RIGHT,_loc5_[0] - 1,0);
            if(param1 == -1)
            {
               return;
            }
         }
         else if(param2 >= _loc5_[1])
         {
            param2 = this.GetCoordAfterEdgeBehavior(NavDirection.DOWN,_loc5_[1] - 1,0);
            if(param2 == -1)
            {
               return;
            }
         }
         else if(_loc7_ >= _loc6_ && _loc8_ == _loc6_ - 1)
         {
            _loc11_ = this.mLayout.IndexToGridCoord(_loc6_);
            if(this.mHighlightY == _loc11_[1])
            {
               if(_loc11_[0] == this.mHighlightX + 1)
               {
                  param1 = this.GetCoordAfterEdgeBehavior(NavDirection.RIGHT,this.mHighlightX,0);
               }
               else if(_loc11_[0] == this.mHighlightX - 1)
               {
                  param1 = this.GetCoordAfterEdgeBehavior(NavDirection.LEFT,this.mHighlightX,_loc5_[0] - 1);
               }
               else
               {
                  param1 = -1;
               }
            }
            else if(this.mHighlightX == _loc11_[0])
            {
               if(_loc11_[1] == this.mHighlightY + 1)
               {
                  param2 = this.GetCoordAfterEdgeBehavior(NavDirection.DOWN,this.mHighlightY,0);
               }
               else if(_loc11_[0] == this.mHighlightX - 1)
               {
                  param2 = this.GetCoordAfterEdgeBehavior(NavDirection.UP,this.mHighlightY,_loc5_[1] - 1);
               }
               else
               {
                  param2 = -1;
               }
            }
            if(param1 == -1 || param2 == -1)
            {
               return;
            }
         }
         _loc7_ = this.mLayout.GridCoordToIndex(param1,param2);
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         else if(_loc7_ >= _loc6_)
         {
            _loc12_ = this.mLayout.IndexToGridCoord(_loc6_ - 1);
            param1 = int(_loc12_[0]);
            param2 = int(_loc12_[1]);
            _loc7_ = this.mLayout.GridCoordToIndex(param1,param2);
         }
         var _loc9_:DisplayObject = this.GetHighlightedObject();
         if(mSliderHelper)
         {
            _loc13_ = false;
            _loc14_ = false;
            if(this.mLayout.Horizontal)
            {
               _loc13_ = this.mHighlightY == 0 && param2 == _loc5_[1] - 1;
               _loc14_ = this.mHighlightY == _loc5_[1] - 1 && param2 == 0;
            }
            else
            {
               _loc13_ = this.mHighlightX == 0 && param1 == _loc5_[0] - 1;
               _loc14_ = this.mHighlightX == _loc5_[0] - 1 && param1 == 0;
            }
         }
         if(mSliderHelper)
         {
            if(param2 + 1 >= _loc5_[1])
            {
               mSliderHelper.ScrollToBottom();
            }
         }
         this.mHighlightX = param1;
         this.mHighlightY = param2;
         if(Boolean(mSliderHelper) && (mEdgeBehavior == InputAdapter.EDGE_LOOP || this.mbDPadLeaveEdgeSkipsRows && this.mbInApplyDirectionalInput))
         {
            if(_loc13_)
            {
               mSliderHelper.ScrollToBottom();
            }
            else if(_loc14_)
            {
               mSliderHelper.ScrollToTop();
            }
         }
         var _loc10_:DisplayObject = this.GetHighlightedObject();
         if(Boolean(mSliderHelper && _loc10_ == null) && Boolean(this.mbDPadLeaveEdgeSkipsRows) && this.mbInApplyDirectionalInput)
         {
            mSliderHelper.ScrollToPosition(this.mLayout.GetPositionOfIndex(this.GetHighlightedIndex()));
            _loc10_ = this.GetHighlightedObject();
         }
         if(param4)
         {
            ChangeHighlight(_loc9_,_loc10_,param3);
         }
         if(this.mbSnapToPositionAfterDirectionalInput && this.mCellHeight > 0 && Boolean(mSliderHelper))
         {
            mSliderHelper.ScrollToPosition(this.mCellHeight * Math.min(param2,_loc5_[1]));
         }
      }
      
      override protected function HighlightDirection(param1:int, param2:int) : void
      {
         this.SetControllerHighlight(this.mHighlightX + param1,this.mHighlightY + param2);
      }
      
      override protected function Confirm() : DisplayObject
      {
         if(this.mbUseDefaultConfirm && this.mLayout != null)
         {
            return ConfirmSelectedObject(this.GetHighlightedObject());
         }
         return null;
      }
      
      override public function GetVisibleObjects() : Vector.<DisplayObject>
      {
         var _loc4_:DisplayObject = null;
         if(!this.mLayout)
         {
            return null;
         }
         var _loc1_:Vector.<IView> = this.mLayout.GetAllCells();
         var _loc2_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_] as DisplayObject;
            if((Boolean(_loc4_)) && _loc4_.visible)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function SetHighlightedObject(param1:DisplayObject, param2:Boolean = false) : void
      {
         var _loc3_:int = this.mLayout.GetGridIndexOfCell(param1);
         if(_loc3_ >= 0)
         {
            this.SetHighlightedIndex(_loc3_,param2);
         }
      }
      
      public function HighlightDirectionAndConfirm(param1:int, param2:int) : void
      {
         this.HighlightDirection(param1,param2);
         ConfirmHighlight();
      }
      
      public function Count() : int
      {
         return this.mLayout.GetNumItems();
      }
      
      public function ResetHighlightPosition() : void
      {
         var _loc1_:DisplayObject = NavManager.Instance.CurrentElement;
         if(this.mLayout.GetAllCells().indexOf(_loc1_) >= 0)
         {
            this.SetControllerHighlight(0,0,true);
         }
         else
         {
            this.mHighlightX = 0;
            this.mHighlightY = 0;
         }
      }
      
      public function ScrollAdapterToTop() : void
      {
         if(mSliderHelper)
         {
            mSliderHelper.ScrollToTop();
         }
      }
      
      public function ScrollAdapterToBottom() : void
      {
         if(mSliderHelper)
         {
            mSliderHelper.ScrollToBottom();
         }
      }
   }
}

