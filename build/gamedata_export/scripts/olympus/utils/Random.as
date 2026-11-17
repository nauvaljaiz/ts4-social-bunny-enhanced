package olympus.utils
{
   public class Random
   {
      
      private static const randPrecision:int = 100000000000000000000;
      
      public function Random()
      {
         super();
      }
      
      public static function Int(param1:Number, param2:Number) : int
      {
         return Math.round(GetRandom(param1,param2));
      }
      
      public static function Num(param1:Number, param2:Number, param3:int = -1) : Number
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc4_:Number = GetRandom(param1,param2);
         if(param3 < 0)
         {
            return _loc4_;
         }
         _loc5_ = _loc4_.toString();
         if(param3 < _loc5_.length)
         {
            _loc6_ = _loc5_.indexOf(".",0);
            _loc5_ = _loc5_.substring(0,_loc6_ + param3 + 1);
         }
         return Number(_loc5_);
      }
      
      private static function GetRandom(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.round(Math.random() * randPrecision);
         _loc3_ /= randPrecision;
         return (param2 - param1) * _loc3_ + param1;
      }
   }
}

