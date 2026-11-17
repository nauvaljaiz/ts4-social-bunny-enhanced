package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class ScheduleEntry extends OlympusObject
   {
      
      public static const SCHEDULEDAY_SUNDAY:int = 0;
      
      public static const SCHEDULEDAY_MONDAY:int = 1;
      
      public static const SCHEDULEDAY_TUESDAY:int = 2;
      
      public static const SCHEDULEDAY_WEDNESDAY:int = 3;
      
      public static const SCHEDULEDAY_THURSDAY:int = 4;
      
      public static const SCHEDULEDAY_FRIDAY:int = 5;
      
      public static const SCHEDULEDAY_SATURDAY:int = 6;
      
      public static const SCHEDULESHIFT_ALL_DAY:int = 0;
      
      public static const SCHEDULESHIFT_MORNING:int = 1;
      
      public static const SCHEDULESHIFT_EVENING:int = 2;
      
      public static const SCHEDULESHIFT_MULTI_DAY:int = 3;
      
      public static const SCHEDULESHIFT_TWENTY_FOUR_HOURS:int = 4;
      
      public var days:Array = [int];
      
      public var start_hour:uint;
      
      public var start_minute:uint;
      
      public var duration:Number;
      
      public var schedule_shift_type:int = 0;
      
      public var multi_day_start_day:int;
      
      public var multi_day_end_day:int;
      
      public function ScheduleEntry(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.days);
      }
   }
}

