package olympus.input
{
   import flash.geom.Point;
   
   public class GamepadAnalogSticks
   {
      
      protected static var sLeftX:Number;
      
      protected static var sLeftY:Number;
      
      protected static var sRightX:Number;
      
      protected static var sRightY:Number;
      
      public static const DEFAULT_DEADZONE:Number = 0.15;
      
      public function GamepadAnalogSticks()
      {
         super();
      }
      
      public static function SetValues(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         sLeftX = param1;
         sLeftY = param2;
         sRightX = param3;
         sRightY = param4;
      }
      
      public static function GetLeftX() : Number
      {
         return sLeftX;
      }
      
      public static function GetLeftY() : Number
      {
         return sLeftY;
      }
      
      public static function GetRightX() : Number
      {
         return sRightX;
      }
      
      public static function GetRightY() : Number
      {
         return sRightY;
      }
      
      public static function GetLeftStickValuesWithDeadzone(param1:Number = 0.15) : Point
      {
         return new Point(ApplyDeadzoneToValue(GetLeftX(),param1),ApplyDeadzoneToValue(GetLeftY(),param1));
      }
      
      public static function GetRightStickValuesWithDeadzone(param1:Number = 0.15) : Point
      {
         return new Point(ApplyDeadzoneToValue(GetRightX(),param1),ApplyDeadzoneToValue(GetRightY(),param1));
      }
      
      public static function ApplyDeadzoneToValue(param1:Number, param2:Number = 0.15) : Number
      {
         var _loc3_:Number = Math.abs(param1);
         if(_loc3_ < param2)
         {
            return 0;
         }
         var _loc4_:Number = param1 < 0 ? -1 : 1;
         return _loc4_ * (_loc3_ - param2) / (1 - param2);
      }
   }
}

