package widgets.shared.utils
{
   public class UMUtils
   {
      
      public function UMUtils()
      {
         super();
      }
      
      public static function GetTimeRemaining(param1:Date, param2:Date = null) : Object
      {
         var _loc3_:Date = new Date();
         var _loc4_:Number = param1.getTime();
         var _loc5_:Number = param2 == null ? _loc3_.getTime() : param2.getTime();
         if(_loc4_ < _loc5_)
         {
            return {
               "days":0,
               "hours":0,
               "minutes":0,
               "seconds":0
            };
         }
         var _loc6_:Number = _loc4_ - _loc5_;
         _loc6_ = _loc6_ / 1000;
         var _loc7_:int = _loc6_ / (3600 * 24);
         _loc6_ %= 3600 * 24;
         var _loc8_:int = _loc6_ / 3600;
         _loc6_ %= 3600;
         var _loc9_:int = _loc6_ / 60;
         var _loc10_:int = _loc6_ %= 60;
         return {
            "days":_loc7_,
            "hours":_loc8_,
            "minutes":_loc9_,
            "seconds":_loc10_
         };
      }
   }
}

