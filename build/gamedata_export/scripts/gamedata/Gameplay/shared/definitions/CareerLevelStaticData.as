package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CareerLevelStaticData extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var simoleons_per_hour:int;
      
      public var potential_simoleons_weekly:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var performance:PerformanceStaticData = new PerformanceStaticData();
      
      public var work_schedule:Array = [ScheduleEntryStaticData];
      
      public var aspiration:AspirationCareerStaticData = new AspirationCareerStaticData();
      
      public var ideal_mood:String;
      
      public var agents_available:Array;
      
      public function CareerLevelStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.work_schedule);
      }
      
      public function GetScheduleEntry(param1:int) : ScheduleEntryStaticData
      {
         var _loc4_:ScheduleEntryStaticData = null;
         var _loc2_:int = int(this.work_schedule.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.work_schedule[_loc3_];
            if(_loc4_.days.IsDayAvailable(param1))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

