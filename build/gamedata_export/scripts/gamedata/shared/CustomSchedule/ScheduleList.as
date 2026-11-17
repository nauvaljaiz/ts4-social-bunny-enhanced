package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class ScheduleList extends OlympusObject
   {
      
      public var schedules:Array = [ScheduleListData];
      
      public function ScheduleList(param1:Object = null)
      {
         super(param1);
         FixupArray(this.schedules);
      }
   }
}

