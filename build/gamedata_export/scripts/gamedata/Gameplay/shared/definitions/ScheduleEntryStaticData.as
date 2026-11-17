package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class ScheduleEntryStaticData extends OlympusObject
   {
      
      public var days:AvailableDaysStaticData = new AvailableDaysStaticData();
      
      public var duration:Number = 0;
      
      public var randomStart:Boolean;
      
      public var hour:int;
      
      public var minute:int;
      
      public var schedule_shift_type:int;
      
      public var multi_day_start_day:int;
      
      public var multi_day_end_day:int;
      
      public function ScheduleEntryStaticData(param1:Object = null)
      {
         super(param1);
      }
   }
}

