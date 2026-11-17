package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.math.TimeSpan;
   
   public class GameClockTime extends OlympusObject
   {
      
      public static var sGetGameClockFunction:Function;
      
      public static const NUM_SECONDS_PER_MINUTE:Number = 60;
      
      public static const NUM_MINUTES_PER_HOUR:Number = 60;
      
      public static const NUM_HOURS_PER_DAY:Number = 24;
      
      public static const NUM_DAYS_PER_WEEK:Number = 7;
      
      public static const NUM_DAYS_PER_MONTH:Number = 28;
      
      public static const NUM_DAYS_PER_YEAR:Number = 336;
      
      protected static const NUM_WEEKS_PER_MONTH:Number = NUM_DAYS_PER_MONTH / NUM_DAYS_PER_WEEK;
      
      protected static const NUM_MONTHS_PER_YEAR:Number = NUM_DAYS_PER_YEAR / NUM_DAYS_PER_MONTH;
      
      public static function sGetCurrentTicksFunction():String
      {
         return GameClockTime.GetFullGameClockTime().ToTicks();
      }
      public var hour:uint;
      
      public var minute:uint;
      
      public var second:uint;
      
      public var dayOfWeek:uint;
      
      public var week:uint;
      
      public var month:uint;
      
      public var year:uint;
      
      public var sunrise:Number = 0;
      
      public var sunset:Number = 0;
      
      public var ratio:Number = 0;
      
      public var gameSpeed:Number = 0;
      
      public var clockSpeed:int;
      
      public var superSpeed:Boolean = false;
      
      public function GameClockTime(param1:Object = null)
      {
         super(param1);
      }
      
      public static function DateTimeToSeconds(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromDateTime":{
               "hour":param1,
               "minute":param2,
               "second":param3,
               "dayOfWeek":param4,
               "week":param5,
               "month":param6,
               "year":param7
            },
            "toSeconds":true
         }).seconds as String;
      }
      
      public static function DateTimeToTicks(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromDateTime":{
               "hour":param1,
               "minute":param2,
               "second":param3,
               "dayOfWeek":param4,
               "week":param5,
               "month":param6,
               "year":param7
            },
            "toTicks":true
         }).ticks as String;
      }
      
      public static function TicksToDateTime(param1:String) : GameClockTime
      {
         return new GameClockTime(CommunicationManager.CallGameService("ConvertGameTime",{
            "fromTicks":param1,
            "toDateTime":true
         }).dateTime);
      }
      
      public static function SecondsToDateTime(param1:String) : GameClockTime
      {
         return new GameClockTime(CommunicationManager.CallGameService("ConvertGameTime",{
            "fromSeconds":param1,
            "toDateTime":true
         }).dateTime);
      }
      
      public static function TicksToSeconds(param1:String) : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromTicks":param1,
            "toSeconds":true
         }).seconds as String;
      }
      
      public static function SecondsToTicks(param1:String) : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromSeconds":param1,
            "toTicks":true
         }).ticks as String;
      }
      
      public static function GetFullGameClockTime() : GameClockTime
      {
         return new GameClockTime(sGetGameClockFunction({}));
      }
      
      public static function GetCurrentTicks() : String
      {
         return sGetCurrentTicksFunction();
      }
      
      public static function ConvertToHours(param1:GameClockTime) : Number
      {
         return (param1.month * NUM_DAYS_PER_MONTH + param1.week * NUM_DAYS_PER_WEEK + param1.dayOfWeek) * NUM_HOURS_PER_DAY + param1.hour;
      }
      
      public static function ConvertToMinutes(param1:GameClockTime) : Number
      {
         return param1.hour * NUM_MINUTES_PER_HOUR + param1.minute;
      }
      
      public function AddTime(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0) : *
      {
         this.second += param1;
         this.minute += param2;
         this.hour += param3;
         this.dayOfWeek += param4;
         this.week += param5;
         this.month += param6;
         this.year += param7;
         if(this.second >= NUM_SECONDS_PER_MINUTE)
         {
            this.second -= NUM_SECONDS_PER_MINUTE;
            this.minute += 1;
         }
         if(this.minute >= NUM_MINUTES_PER_HOUR)
         {
            this.minute -= NUM_MINUTES_PER_HOUR;
            this.hour += 1;
         }
         if(this.hour >= NUM_HOURS_PER_DAY)
         {
            this.hour -= NUM_HOURS_PER_DAY;
            this.dayOfWeek += 1;
         }
         if(this.dayOfWeek >= NUM_DAYS_PER_WEEK)
         {
            this.dayOfWeek -= NUM_DAYS_PER_WEEK;
            this.week += 1;
         }
         if(this.week >= NUM_WEEKS_PER_MONTH)
         {
            this.week -= NUM_WEEKS_PER_MONTH;
            this.month += 1;
         }
         if(this.month >= NUM_MONTHS_PER_YEAR)
         {
            this.month -= NUM_MONTHS_PER_YEAR;
            this.year += 1;
         }
      }
      
      public function IsToday() : Boolean
      {
         var _loc1_:GameClockTime = GetFullGameClockTime();
         return _loc1_.year == this.year && _loc1_.month == this.month && _loc1_.week == this.week && _loc1_.dayOfWeek == this.dayOfWeek;
      }
      
      public function ToSeconds() : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromDateTime":{
               "hour":this.hour,
               "minute":this.minute,
               "second":this.second,
               "dayOfWeek":this.dayOfWeek,
               "week":this.week,
               "month":this.month,
               "year":this.year
            },
            "toSeconds":true
         }).seconds as String;
      }
      
      public function ToTicks() : String
      {
         return CommunicationManager.CallGameService("ConvertGameTime",{
            "fromDateTime":{
               "hour":this.hour,
               "minute":this.minute,
               "second":this.second,
               "dayOfWeek":this.dayOfWeek,
               "week":this.week,
               "month":this.month,
               "year":this.year
            },
            "toTicks":true
         }).ticks as String;
      }
      
      public function ToAS3Date() : Date
      {
         return new Date(this.year,this.month,this.dayOfWeek + 1 + this.week * NUM_DAYS_PER_WEEK,this.hour,this.minute,this.second);
      }
      
      public function ToAS3DateForDayOfWeek() : Date
      {
         return new Date(this.year,this.month,(this.dayOfWeek + 6) % 7 + 1,this.hour,this.minute,this.second);
      }
      
      public function ToTimeSpan() : TimeSpan
      {
         return new TimeSpan(0,this.second,this.minute,this.hour,this.dayOfWeek + this.week * NUM_DAYS_PER_WEEK,this.month,this.year);
      }
   }
}

