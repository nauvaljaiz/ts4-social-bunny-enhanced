package olympus.math
{
   public final class Interpolation
   {
      
      public function Interpolation()
      {
         super();
      }
      
      public static function Lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param2 + param1 * (param3 - param2);
      }
      
      public static function InvLerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param1 - param2) / (param3 - param2);
      }
   }
}

