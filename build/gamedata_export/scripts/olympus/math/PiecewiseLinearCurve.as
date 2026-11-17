package olympus.math
{
   public class PiecewiseLinearCurve
   {
      
      protected var mDataPoints:Array;
      
      public function PiecewiseLinearCurve(param1:Array = null)
      {
         super();
         this.mDataPoints = new Array();
         if(param1)
         {
            this.AddPoints(param1);
         }
      }
      
      public function AddPoints(param1:Array) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Array = this.mDataPoints;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1[_loc4_]);
            _loc4_++;
         }
         _loc3_.sortOn("x",Array.NUMERIC);
      }
      
      public function AddPoint(param1:Object) : void
      {
         this.mDataPoints.push(param1);
         this.mDataPoints.sortOn("x",Array.NUMERIC);
      }
      
      public function RemoveAllPoints() : void
      {
         this.mDataPoints = new Array();
      }
      
      public function GetNumPoints() : Number
      {
         return this.mDataPoints.length;
      }
      
      public function GetValue(param1:Number) : Number
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:int = int(this.mDataPoints.length);
         if(_loc2_ == 0)
         {
            return 0;
         }
         if(_loc2_ == 1)
         {
            return this.mDataPoints[0].y;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 1;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.mDataPoints[_loc3_];
            _loc6_ = this.mDataPoints[_loc4_];
            if(_loc5_.x <= param1 && _loc6_.x > param1)
            {
               _loc7_ = Number(_loc5_.y);
               _loc8_ = Number(_loc6_.y);
               _loc9_ = _loc6_.x == _loc5_.x ? 1 : _loc6_.x - _loc5_.x;
               _loc10_ = (param1 - _loc5_.x) / _loc9_;
               return _loc10_ * (_loc6_.y - _loc5_.y) + _loc5_.y;
            }
            _loc3_++;
            _loc4_++;
         }
         return this.mDataPoints[_loc2_ - 1].y;
      }
   }
}

