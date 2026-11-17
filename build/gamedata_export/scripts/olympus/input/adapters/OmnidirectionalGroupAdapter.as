package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.input.IInputFocusable;
   import olympus.input.constants.InputAdapterTunables;
   import olympus.interfaces.IBoundsOverride;
   import olympus.math.Geometry;
   import olympus.utils.DisplayObjectUtils;
   
   public class OmnidirectionalGroupAdapter extends InputAdapter
   {
      
      protected static const MAX_ARC_LENGTH:Number = InputAdapterTunables.OMNIDIRECTIONAL_SEARCH_MAX_ARC_LENGTH;
      
      protected static const MAX_ARC_LENGTH_WIDE:Number = InputAdapterTunables.OMNIDIRECTIONAL_SEARCH_MAX_ARC_LENGTH_WIDE;
      
      protected static const INDIRECT_OBJECT_MIN_WEIGHT:Number = 10;
      
      protected static const INDIRECT_OBJECT_MAX_WEIGHT:Number = 20;
      
      protected var mGetElementBounds:Function = null;
      
      protected var mElements:Vector.<DisplayObject>;
      
      protected var mbOrthogonalOnly:Boolean = false;
      
      protected var mbUseDefaultConfirm:Boolean = true;
      
      protected var mHighlightedIndex:int = -1;
      
      protected var mMaxArcLength:Number = 0.7853981633974483;
      
      public function OmnidirectionalGroupAdapter()
      {
         super();
         this.mGetElementBounds = DefaultGetElementBounds;
      }
      
      public static function DefaultGetElementBounds(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         var _loc3_:Rectangle = null;
         var _loc4_:IBoundsOverride = param1 as IBoundsOverride;
         if(_loc4_)
         {
            _loc3_ = _loc4_.GetBoundsOverride(param2);
         }
         else
         {
            _loc3_ = param1.getBounds(param2);
         }
         return _loc3_;
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddDirectionalInputs();
         AddConfirmAction();
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         super.OnEntered(param1);
         var _loc2_:int = this.mHighlightedIndex;
         if(_loc2_ == -1)
         {
            _loc2_ = 0;
         }
         this.SetHighlightedIndex(_loc2_,true);
         return GetStackFocusable(param1);
      }
      
      public function SetOrthogonalOnly(param1:Boolean) : void
      {
         this.mbOrthogonalOnly = param1;
      }
      
      public function SetUseDefaultConfirm(param1:Boolean) : void
      {
         this.mbUseDefaultConfirm = param1;
      }
      
      public function UseWideAngle() : void
      {
         this.mMaxArcLength = MAX_ARC_LENGTH_WIDE;
      }
      
      public function SetMaxArcLength(param1:Number) : void
      {
         this.mMaxArcLength = param1;
      }
      
      public function GetMaxArcLength() : Number
      {
         return this.mMaxArcLength;
      }
      
      public function set GetElementBounds(param1:Function) : void
      {
         this.mGetElementBounds = param1;
      }
      
      public function get GetElementBounds() : Function
      {
         return this.mGetElementBounds;
      }
      
      public function SetElements(param1:Vector.<DisplayObject>) : void
      {
         this.mElements = param1;
      }
      
      public function AddElement(param1:DisplayObject) : void
      {
         if(!this.mElements)
         {
            this.mElements = new Vector.<DisplayObject>();
         }
         this.mElements.push(param1);
      }
      
      public function GetElementAt(param1:int) : DisplayObject
      {
         return this.mElements[param1];
      }
      
      public function GetLength() : int
      {
         if(!this.mElements)
         {
            this.mElements = new Vector.<DisplayObject>();
         }
         return this.mElements.length;
      }
      
      override public function GetHighlightedObject() : DisplayObject
      {
         if(this.mHighlightedIndex < 0 || this.mHighlightedIndex >= this.GetLength())
         {
            return null;
         }
         return this.GetElementAt(this.mHighlightedIndex);
      }
      
      public function SetHighlightedIndex(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = this.GetHighlightedObject();
         this.mHighlightedIndex = param1;
         var _loc4_:DisplayObject = this.GetHighlightedObject();
         ChangeHighlight(_loc3_,_loc4_,param2);
      }
      
      override protected function Confirm() : DisplayObject
      {
         return ConfirmSelectedObject(this.GetHighlightedObject());
      }
      
      override public function HighlightDirectionAnalog(param1:Number, param2:Number) : void
      {
         var _loc5_:Rectangle = null;
         var _loc7_:Point = null;
         var _loc9_:uint = 0;
         var _loc10_:Point = null;
         if(DisableNavigation)
         {
            return;
         }
         super.HighlightDirectionAnalog(param1,param2);
         if(this.mbOrthogonalOnly)
         {
            _loc9_ = Geometry.VectorToDirection(param1,param2);
            _loc10_ = Geometry.DirectionToVector(_loc9_);
            param1 = _loc10_.x;
            param2 = _loc10_.y;
         }
         var _loc3_:DisplayObject = this.GetHighlightedObject();
         if(!_loc3_)
         {
            this.SetHighlightedIndex(0);
            return;
         }
         var _loc4_:DisplayObject = _loc3_.stage;
         _loc5_ = this.mGetElementBounds(_loc3_,_loc4_);
         var _loc6_:Point = new Point(_loc5_.x + _loc5_.width / 2,_loc5_.y + _loc5_.height / 2);
         var _loc8_:uint = Geometry.VectorToDirection(param1 * _loc5_.width,param2 * _loc5_.height);
         switch(_loc8_)
         {
            case NavDirection.LEFT:
               _loc6_ = new Point(_loc5_.left,_loc6_.y);
               _loc7_ = new Point(0,_loc5_.height / 2);
               break;
            case NavDirection.RIGHT:
               _loc6_ = new Point(_loc5_.right,_loc6_.y);
               _loc7_ = new Point(0,_loc5_.height / 2);
               break;
            case NavDirection.UP:
               _loc6_ = new Point(_loc6_.x,_loc5_.top);
               _loc7_ = new Point(_loc5_.width / 2,0);
               break;
            case NavDirection.DOWN:
               _loc6_ = new Point(_loc6_.x,_loc5_.bottom);
               _loc7_ = new Point(_loc5_.width / 2,0);
         }
         this.HighlightDirectionAnalogFromPoint(_loc6_,param1,param2,_loc4_,_loc7_);
      }
      
      public function HighlightDirectionAnalogFromPoint(param1:Point, param2:Number, param3:Number, param4:DisplayObject, param5:Point) : void
      {
         var _loc17_:DisplayObject = null;
         var _loc18_:Rectangle = null;
         var _loc19_:Point = null;
         var _loc20_:Point = null;
         var _loc21_:Point = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc6_:int = this.GetLength();
         var _loc7_:DisplayObject = this.GetHighlightedObject();
         var _loc8_:Number = Math.atan2(param3,param2);
         var _loc9_:int = -1;
         var _loc10_:Number = Number.MAX_VALUE;
         var _loc11_:int = -1;
         var _loc12_:Number = Number.MAX_VALUE;
         var _loc13_:int = -1;
         var _loc14_:Number = Number.MAX_VALUE;
         var _loc15_:int = 0;
         while(_loc15_ < _loc6_)
         {
            _loc17_ = this.GetElementAt(_loc15_);
            if(!(!_loc17_ || _loc17_ == _loc7_ || !_loc17_.stage || !DisplayObjectUtils.IsVisibleInHeirarchy(_loc17_)))
            {
               _loc18_ = this.mGetElementBounds(_loc17_,param4);
               _loc19_ = new Point(_loc18_.x + _loc18_.width / 2,_loc18_.y + _loc18_.height / 2);
               if(param1.x > _loc18_.left && param1.x < _loc18_.right && param1.y > _loc18_.top && param1.y < _loc18_.bottom)
               {
                  _loc26_ = Geometry.GetLengthSquared(param1.x - _loc19_.x,param1.y - _loc19_.y);
                  if(_loc26_ < _loc10_)
                  {
                     _loc10_ = _loc26_;
                     _loc9_ = _loc15_;
                  }
               }
               if(_loc9_ == -1)
               {
                  if(param1.x < _loc19_.x == param1.y < _loc19_.y)
                  {
                     _loc20_ = new Point(_loc18_.right + param5.x,_loc18_.top - param5.y);
                     _loc21_ = new Point(_loc18_.left - param5.x,_loc18_.bottom + param5.y);
                  }
                  else
                  {
                     _loc20_ = new Point(_loc18_.left - param5.x,_loc18_.top - param5.y);
                     _loc21_ = new Point(_loc18_.right + param5.x,_loc18_.bottom + param5.y);
                  }
                  _loc22_ = Math.atan2(_loc20_.y - param1.y,_loc20_.x - param1.x);
                  _loc23_ = Math.atan2(_loc21_.y - param1.y,_loc21_.x - param1.x);
                  _loc24_ = Geometry.GetArcLength(_loc8_,_loc22_);
                  _loc25_ = Geometry.GetArcLength(_loc8_,_loc23_);
                  if(_loc24_ + _loc25_ <= Geometry.GetArcLength(_loc22_,_loc23_) + 0.01)
                  {
                     _loc27_ = Geometry.GetLengthSquared(param1.x - _loc19_.x,param1.y - _loc19_.y);
                     if(_loc27_ < _loc12_)
                     {
                        _loc12_ = _loc27_;
                        _loc11_ = _loc15_;
                     }
                  }
                  else
                  {
                     _loc28_ = Math.min(_loc24_,_loc25_);
                     if(_loc28_ < this.mMaxArcLength)
                     {
                        _loc29_ = INDIRECT_OBJECT_MIN_WEIGHT + (INDIRECT_OBJECT_MAX_WEIGHT - INDIRECT_OBJECT_MIN_WEIGHT) * _loc24_ / this.mMaxArcLength;
                        _loc30_ = INDIRECT_OBJECT_MIN_WEIGHT + (INDIRECT_OBJECT_MAX_WEIGHT - INDIRECT_OBJECT_MIN_WEIGHT) * _loc25_ / this.mMaxArcLength;
                        _loc31_ = Geometry.GetLengthSquared(param1.x - _loc20_.x,param1.y - _loc20_.y) * _loc29_;
                        _loc32_ = Geometry.GetLengthSquared(param1.x - _loc21_.x,param1.y - _loc21_.y) * _loc30_;
                        if(_loc31_ < _loc32_ && _loc31_ < _loc14_)
                        {
                           _loc14_ = _loc31_;
                           _loc13_ = _loc15_;
                        }
                        else if(_loc31_ > _loc32_ && _loc32_ < _loc14_)
                        {
                           _loc14_ = _loc32_;
                           _loc13_ = _loc15_;
                        }
                     }
                  }
               }
            }
            _loc15_++;
         }
         var _loc16_:int = -1;
         if(_loc9_ != -1)
         {
            _loc16_ = _loc9_;
         }
         else
         {
            if(_loc11_ == -1 && _loc13_ == -1)
            {
               this.PerformEdgeBehavior(param1,param2,param3,param4,param5);
               return;
            }
            if(_loc11_ == -1)
            {
               _loc16_ = _loc13_;
            }
            else if(_loc13_ == -1)
            {
               _loc16_ = _loc11_;
            }
            else
            {
               _loc16_ = _loc12_ < _loc14_ ? _loc11_ : _loc13_;
            }
         }
         if(_loc16_ != -1)
         {
            this.SetHighlightedIndex(_loc16_);
         }
      }
      
      protected function PerformEdgeBehavior(param1:Point, param2:Number, param3:Number, param4:DisplayObject, param5:Point) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         switch(mEdgeBehavior)
         {
            case EDGE_LEAVE:
               _loc6_ = Geometry.VectorToDirection(param2,param3);
               FireLeaveEvent(_loc6_,param1);
               break;
            case EDGE_LOOP:
               mEdgeBehavior = EDGE_STOP;
               this.SetHighlightedIndex(-1);
               _loc6_ = Geometry.VectorToDirection(param2,param3);
               _loc7_ = this.GetMaximumBoundInDirection((_loc6_ + 2) % 4,param4);
               switch(_loc6_)
               {
                  case NavDirection.RIGHT:
                     this.HighlightDirectionAnalogFromPoint(new Point(_loc7_,param1.y),1,0,param4,param5);
                     break;
                  case NavDirection.DOWN:
                     this.HighlightDirectionAnalogFromPoint(new Point(param1.x,_loc7_),0,1,param4,param5);
                     break;
                  case NavDirection.LEFT:
                     this.HighlightDirectionAnalogFromPoint(new Point(_loc7_,param1.y),-1,0,param4,param5);
                     break;
                  case NavDirection.UP:
                     this.HighlightDirectionAnalogFromPoint(new Point(param1.x,_loc7_),0,-1,param4,param5);
               }
               mEdgeBehavior = EDGE_LOOP;
         }
      }
      
      protected function GetMaximumBoundInDirection(param1:uint, param2:DisplayObject) : Number
      {
         var _loc4_:Number = NaN;
         var _loc8_:DisplayObject = null;
         var _loc9_:Rectangle = null;
         var _loc10_:IBoundsOverride = null;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc3_:Boolean = true;
         var _loc5_:Boolean = param1 == NavDirection.UP || param1 == NavDirection.LEFT;
         var _loc6_:int = this.GetLength();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = this.GetElementAt(_loc7_);
            _loc10_ = _loc8_ as IBoundsOverride;
            if(_loc10_)
            {
               _loc9_ = _loc10_.GetBoundsOverride(param2);
            }
            else
            {
               _loc9_ = _loc8_.getBounds(param2);
            }
            switch(param1)
            {
               case NavDirection.RIGHT:
                  _loc11_ = _loc9_.right;
                  break;
               case NavDirection.DOWN:
                  _loc11_ = _loc9_.bottom;
                  break;
               case NavDirection.LEFT:
                  _loc11_ = _loc9_.left;
                  break;
               case NavDirection.UP:
                  _loc11_ = _loc9_.top;
            }
            if(_loc3_)
            {
               _loc3_ = false;
               _loc4_ = _loc11_;
            }
            else
            {
               _loc12_ = _loc11_ < _loc4_;
               if(_loc12_ == _loc5_)
               {
                  _loc4_ = _loc11_;
               }
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      override public function GetVisibleObjects() : Vector.<DisplayObject>
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
         for each(_loc2_ in this.mElements)
         {
            if(DisplayObjectUtils.IsVisibleInHeirarchy(_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      override public function SetHighlightedObject(param1:DisplayObject, param2:Boolean = false) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.mElements.length)
         {
            _loc4_ = this.mElements[_loc3_];
            if(_loc4_ == param1)
            {
               this.SetHighlightedIndex(_loc3_,param2);
            }
            _loc3_++;
         }
      }
   }
}

