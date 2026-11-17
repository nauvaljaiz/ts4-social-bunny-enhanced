package olympus.motion
{
   import olympus.math.Geometry;
   
   public final class Easing
   {
      
      public function Easing()
      {
         super();
      }
      
      public static function easeLinear(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * param1 / param4 + param2;
      }
      
      public static function easeInCubic(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 * param1 + param2;
      }
      
      public static function easeOutCubic(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * ((param1 = param1 / param4 - 1) * param1 * param1 + 1) + param2;
      }
      
      public static function easeInOutCubic(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 * param1 + param2;
         }
         return param3 / 2 * ((param1 = param1 - 2) * param1 * param1 + 2) + param2;
      }
      
      public static function easeInQuart(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 * param1 * param1 + param2;
      }
      
      public static function easeOutQuart(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * ((param1 = param1 / param4 - 1) * param1 * param1 * param1 - 1) + param2;
      }
      
      public static function easeInOutQuart(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 * param1 * param1 + param2;
         }
         return -param3 / 2 * ((param1 = param1 - 2) * param1 * param1 * param1 - 2) + param2;
      }
      
      public static function easeInQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 + param2;
      }
      
      public static function easeOutQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public static function easeInOutQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 + param2;
         }
         return -param3 / 2 * (--param1 * (param1 - 2) - 1) + param2;
      }
      
      public static function easeInQuint(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 * param1 * param1 * param1 + param2;
      }
      
      public static function easeOutQuint(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * ((param1 = param1 / param4 - 1) * param1 * param1 * param1 * param1 + 1) + param2;
      }
      
      public static function easeInOutQuint(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 * param1 * param1 * param1 + param2;
         }
         return param3 / 2 * ((param1 = param1 - 2) * param1 * param1 * param1 * param1 + 2) + param2;
      }
      
      public static function easeInSine(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * Math.cos(param1 / param4 * Geometry.HALF_PI) + param3 + param2;
      }
      
      public static function easeOutSine(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * Math.sin(param1 / param4 * Geometry.HALF_PI) + param2;
      }
      
      public static function easeInOutSine(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 / 2 * (Math.cos(Math.PI * param1 / param4) - 1) + param2;
      }
      
      public static function easeInExpo(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 == 0 ? param2 : param3 * Math.pow(2,10 * (param1 / param4 - 1)) + param2;
      }
      
      public static function easeOutExpo(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 == param4 ? param2 + param3 : param3 * (-Math.pow(2,-10 * param1 / param4) + 1) + param2;
      }
      
      public static function easeInOutExpo(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 == 0)
         {
            return param2;
         }
         if(param1 == param4)
         {
            return param2 + param3;
         }
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * Math.pow(2,10 * (param1 - 1)) + param2;
         }
         return param3 / 2 * (-Math.pow(2,-10 * --param1) + 2) + param2;
      }
      
      public static function easeInElastic(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = undefined, param6:Number = undefined) : Number
      {
         var _loc7_:Number = NaN;
         if(param1 == 0)
         {
            return param2;
         }
         param1 = param1 / param4;
         if(param1 == 1)
         {
            return param2 + param3;
         }
         if(!param6)
         {
            param6 = param4 * 0.3;
         }
         if(!param5 || param5 < Math.abs(param3))
         {
            param5 = param3;
            _loc7_ = param6 / 4;
         }
         else
         {
            _loc7_ = param6 / Geometry.TWO_PI * Math.asin(param3 / param5);
         }
         return -(param5 * Math.pow(2,10 * (param1 = param1 - 1)) * Math.sin((param1 * param4 - _loc7_) * Geometry.TWO_PI / param6)) + param2;
      }
      
      public static function easeOutElastic(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = undefined, param6:Number = undefined) : Number
      {
         var _loc7_:Number = NaN;
         if(param1 == 0)
         {
            return param2;
         }
         param1 = param1 / param4;
         if(param1 == 1)
         {
            return param2 + param3;
         }
         if(!param6)
         {
            param6 = param4 * 0.3;
         }
         if(!param5 || param5 < Math.abs(param3))
         {
            param5 = param3;
            _loc7_ = param6 / 4;
         }
         else
         {
            _loc7_ = param6 / Geometry.TWO_PI * Math.asin(param3 / param5);
         }
         return param5 * Math.pow(2,-10 * param1) * Math.sin((param1 * param4 - _loc7_) * Geometry.TWO_PI / param6) + param3 + param2;
      }
      
      public static function easeInOutElastic(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = undefined, param6:Number = undefined) : Number
      {
         var _loc7_:Number = NaN;
         if(param1 == 0)
         {
            return param2;
         }
         param1 = param1 / (param4 / 2);
         if(param1 == 2)
         {
            return param2 + param3;
         }
         if(!param6)
         {
            param6 = param4 * (0.3 * 1.5);
         }
         if(!param5 || param5 < Math.abs(param3))
         {
            param5 = param3;
            _loc7_ = param6 / 4;
         }
         else
         {
            _loc7_ = param6 / Geometry.TWO_PI * Math.asin(param3 / param5);
         }
         if(param1 < 1)
         {
            return -0.5 * (param5 * Math.pow(2,10 * (param1 = param1 - 1)) * Math.sin((param1 * param4 - _loc7_) * Geometry.TWO_PI / param6)) + param2;
         }
         return param5 * Math.pow(2,-10 * (param1 = param1 - 1)) * Math.sin((param1 * param4 - _loc7_) * Geometry.TWO_PI / param6) * 0.5 + param3 + param2;
      }
      
      public static function easeInCircular(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (Math.sqrt(1 - (param1 = param1 / param4) * param1) - 1) + param2;
      }
      
      public static function easeOutCircular(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * Math.sqrt(1 - (param1 = param1 / param4 - 1) * param1) + param2;
      }
      
      public static function easeInOutCircular(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return -param3 / 2 * (Math.sqrt(1 - param1 * param1) - 1) + param2;
         }
         return param3 / 2 * (Math.sqrt(1 - (param1 = param1 - 2) * param1) + 1) + param2;
      }
      
      public static function easeInBack(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
      {
         return param3 * (param1 = param1 / param4) * param1 * ((param5 + 1) * param1 - param5) + param2;
      }
      
      public static function easeOutBack(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
      {
         return param3 * ((param1 = param1 / param4 - 1) * param1 * ((param5 + 1) * param1 + param5) + 1) + param2;
      }
      
      public static function easeInOutBack(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
      {
         param1 = param1 / (param4 / 2);
         if(param1 < 1)
         {
            return param3 / 2 * (param1 * param1 * (((param5 = param5 * 1.525) + 1) * param1 - param5)) + param2;
         }
         return param3 / 2 * ((param1 = param1 - 2) * param1 * (((param5 = param5 * 1.525) + 1) * param1 + param5) + 2) + param2;
      }
      
      public static function easeInBounce(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 - easeOutBounce(param4 - param1,0,param3,param4) + param2;
      }
      
      public static function easeOutBounce(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 = param1 / param4;
         if(param1 < 1 / 2.75)
         {
            return param3 * (7.5625 * param1 * param1) + param2;
         }
         if(param1 < 2 / 2.75)
         {
            return param3 * (7.5625 * (param1 = param1 - 1.5 / 2.75) * param1 + 0.75) + param2;
         }
         if(param1 < 2.5 / 2.75)
         {
            return param3 * (7.5625 * (param1 = param1 - 2.25 / 2.75) * param1 + 0.9375) + param2;
         }
         return param3 * (7.5625 * (param1 = param1 - 2.625 / 2.75) * param1 + 0.984375) + param2;
      }
      
      public static function easeInOutBounce(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 < param4 / 2)
         {
            return easeInBounce(param1 * 2,0,param3,param4) * 0.5 + param2;
         }
         return easeOutBounce(param1 * 2 - param4,0,param3,param4) * 0.5 + param3 * 0.5 + param2;
      }
   }
}

