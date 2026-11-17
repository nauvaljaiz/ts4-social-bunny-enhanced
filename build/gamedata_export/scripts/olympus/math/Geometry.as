package olympus.math
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.gamepad.NavDirection;
   import olympus.utils.Clamp;
   
   public final class Geometry
   {
      
      public static const TWO_PI:Number = Math.PI * 2;
      
      public static const HALF_PI:Number = Math.PI * 0.5;
      
      public static const QUARTER_PI:Number = Math.PI * 0.25;
      
      public static const THREE_QUARTERS_PI:Number = Math.PI * 0.75;
      
      public static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
      
      public static const RADIANS_TO_DEGREES:Number = 180 / Math.PI;
      
      public function Geometry()
      {
         super();
      }
      
      public static function CartesianPointOnCircle(param1:Number, param2:Number = 1) : Point
      {
         return new Point(Math.cos(param1) * param2,-Math.sin(param1) * param2);
      }
      
      public static function ToRadians(param1:Number) : Number
      {
         return param1 * DEGREES_TO_RADIANS;
      }
      
      public static function ToDegrees(param1:Number) : Number
      {
         return param1 * RADIANS_TO_DEGREES;
      }
      
      public static function ConstrainPointToRect(param1:Point, param2:Rectangle) : Point
      {
         return new Point(Clamp.Num(param1.x,param2.left,param2.right),Clamp.Num(param1.y,param2.top,param2.bottom));
      }
      
      public static function ComputeIsoscelesVertexAngle(param1:Number, param2:Number) : Number
      {
         return Math.asin(param2 / 2 / param1) * 2;
      }
      
      public static function DistanceSq(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param4 - param2;
         return _loc5_ * _loc5_ + _loc6_ * _loc6_;
      }
      
      public static function GetLengthSquared(param1:Number, param2:Number) : Number
      {
         return param1 * param1 + param2 * param2;
      }
      
      public static function GetArcLength(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.abs(param1 - param2) % TWO_PI;
         return _loc3_ > Math.PI ? TWO_PI - _loc3_ : _loc3_;
      }
      
      public static function VectorToDirection(param1:Number, param2:Number) : uint
      {
         return (Math.atan2(param2,param1) + Math.PI * 2.25) % TWO_PI * (2 / Math.PI);
      }
      
      public static function DirectionToAngle(param1:uint) : Number
      {
         return param1 * HALF_PI;
      }
      
      public static function DirectionToVector(param1:uint) : Point
      {
         switch(param1)
         {
            case NavDirection.RIGHT:
               return new Point(1,0);
            case NavDirection.DOWN:
               return new Point(0,1);
            case NavDirection.LEFT:
               return new Point(-1,0);
            case NavDirection.UP:
               return new Point(0,-1);
            default:
               return new Point(0,0);
         }
      }
      
      public static function UnionRectangleInPlace(param1:Rectangle, param2:Rectangle) : void
      {
         if(!param2.isEmpty())
         {
            param1.left = Math.min(param1.left,param2.left);
            param1.right = Math.max(param1.right,param2.right);
            param1.top = Math.min(param1.top,param2.top);
            param1.bottom = Math.max(param1.bottom,param2.bottom);
         }
      }
   }
}

