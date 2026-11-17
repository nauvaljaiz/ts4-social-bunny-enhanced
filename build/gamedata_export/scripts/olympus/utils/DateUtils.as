package olympus.utils
{
   public class DateUtils
   {
      
      public function DateUtils()
      {
         super();
      }
      
      public static function DateDST() : Date
      {
         var _loc1_:Date = new Date();
         _loc1_.setUTCFullYear(1970,0,1);
         _loc1_.setUTCHours(0,0,0,0);
         return _loc1_;
      }
      
      public static function DateToLocalizationDayOfWeekToken(param1:Date) : Object
      {
         return DayToLocalizationDayOfWeekToken(param1.getDay());
      }
      
      public static function DayToLocalizationDayOfWeekToken(param1:int) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_["date"] = (param1 + 6) % 7 + 1;
         return _loc2_;
      }
      
      public static function DateToLocalizationToken(param1:Date) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_["fullYear"] = param1.fullYear;
         _loc2_["month"] = param1.month + 1;
         _loc2_["date"] = param1.date;
         _loc2_["hours"] = param1.hours;
         _loc2_["minutes"] = param1.minutes;
         return _loc2_;
      }
      
      public static function DateTimeObjectToDate(param1:Object, param2:Date) : void
      {
         if(param1["utc"])
         {
            param2.setUTCFullYear(param1.fullYear,param1.month,param1.date);
            param2.setUTCHours(param1.hours,param1.minutes,param1.seconds,param1.milliseconds);
         }
         else
         {
            param2.setFullYear(param1.fullYear,param1.month,param1.date);
            param2.setHours(param1.hours,param1.minutes,param1.seconds,param1.milliseconds);
         }
      }
      
      public static function GetTimeRemaining(param1:Date, param2:Date = null) : Object
      {
         var _loc3_:Date = null;
         if(param2 != null)
         {
            _loc3_ = param2;
         }
         else
         {
            _loc3_ = new Date();
         }
         return GetTimeRemainingUntilDate(param1,_loc3_);
      }
      
      public static function GetTimeRemainingUntilDate(param1:Date, param2:Date) : Object
      {
         var _loc3_:Number = param1.getTime();
         var _loc4_:Number = param2.getTime();
         if(_loc3_ < _loc4_)
         {
            return {
               "days":0,
               "hours":0,
               "minutes":0,
               "seconds":0
            };
         }
         var _loc5_:Number = _loc3_ - _loc4_;
         _loc5_ = _loc5_ / 1000;
         var _loc6_:int = _loc5_ / (3600 * 24);
         _loc5_ %= 3600 * 24;
         var _loc7_:int = _loc5_ / 3600;
         _loc5_ %= 3600;
         var _loc8_:int = _loc5_ / 60;
         var _loc9_:int = _loc5_ %= 60;
         return {
            "days":_loc6_,
            "hours":_loc7_,
            "minutes":_loc8_,
            "seconds":_loc9_
         };
      }
      
      public function GetSecondsRemaining(param1:Date) : int
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = param1.getTime();
         var _loc4_:Number = _loc2_.getTime();
         if(_loc3_ < _loc4_)
         {
            return 0;
         }
         var _loc5_:Number = _loc3_ - _loc4_;
         return _loc5_ / 1000;
      }
   }
}

