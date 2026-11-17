package gamedata.shared.CustomSchedule
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class ScheduleTimeSlot extends OlympusObject
   {
      
      public var start_time:uint;
      
      public var default_behavior:ResourceKey = new ResourceKey();
      
      public var shuffled_behavior:ResourceKey = new ResourceKey();
      
      public var assignments:Array = [ScheduleTimeSlotAssignment];
      
      public var mbExpanded:Boolean = false;
      
      public var mErrorState:uint = 0;
      
      public var mTimeSlotSims:Object = {};
      
      public function ScheduleTimeSlot(param1:Object = null)
      {
         super(param1);
         FixupArray(this.assignments);
         if(!param1 || !param1["default_behavior"])
         {
            this.default_behavior = null;
         }
         if(!param1 || !param1["shuffled_behavior"])
         {
            this.shuffled_behavior = null;
         }
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["start_time"] = this.start_time;
         if(this.default_behavior)
         {
            _loc1_["default_behavior"] = this.default_behavior;
         }
         if(this.shuffled_behavior)
         {
            _loc1_["shuffled_behavior"] = this.shuffled_behavior;
         }
         if(this.assignments.length != 1 || this.assignments[0].assignment_id != uint.MAX_VALUE)
         {
            _loc1_["assignments"] = ArrayToObject(this.assignments);
         }
         return _loc1_;
      }
      
      public function get TimeslotBehavior() : ResourceKey
      {
         if(this.shuffled_behavior)
         {
            return this.shuffled_behavior;
         }
         return this.default_behavior;
      }
   }
}

