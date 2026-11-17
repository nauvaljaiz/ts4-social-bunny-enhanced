package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class ScheduleTimeSlotAssignment extends OlympusObject
   {
      
      public var assignment_id:uint;
      
      public var assignment_overrides:ScheduleAssignment = new ScheduleAssignment();
      
      public var has_behavior_override:Boolean;
      
      public var has_sim_overrides:Boolean;
      
      public var has_outfit_override:Boolean;
      
      public var has_count_override:Boolean;
      
      protected var mAssignment:ScheduleAssignment;
      
      public var mbLastAssignment:Boolean;
      
      public function ScheduleTimeSlotAssignment(param1:Object = null)
      {
         super(param1);
         if(!param1 || !param1["assignment_overrides"])
         {
            this.assignment_overrides = null;
         }
         if(!param1 || !("assignment_id" in param1))
         {
            this.assignment_id = uint.MAX_VALUE;
         }
      }
      
      public function ToObject(param1:Boolean = false) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_["assignment_id"] = this.assignment_id;
         if(Boolean(this.assignment_overrides) && (this.has_behavior_override || this.has_sim_overrides || this.has_outfit_override || this.has_count_override || param1))
         {
            _loc2_["assignment_overrides"] = this.assignment_overrides.ToObject(this.has_sim_overrides);
         }
         _loc2_["has_behavior_override"] = this.has_behavior_override;
         _loc2_["has_sim_overrides"] = this.has_sim_overrides;
         _loc2_["has_outfit_override"] = this.has_outfit_override;
         _loc2_["has_count_override"] = this.has_sim_overrides;
         return _loc2_;
      }
      
      public function get name() : String
      {
         if(!this.mAssignment)
         {
            return "";
         }
         return this.mAssignment.name;
      }
      
      public function SetAssignment(param1:ScheduleAssignment) : void
      {
         this.mAssignment = param1;
         if(param1)
         {
            this.assignment_id = param1.id;
            if(this.has_count_override && !this.has_sim_overrides)
            {
               this.assignment_overrides.sim_ids.concat(param1.sim_ids);
               this.has_sim_overrides = true;
            }
         }
         else
         {
            this.assignment_id = uint.MAX_VALUE;
            this.has_behavior_override = false;
            this.has_sim_overrides = false;
            this.has_outfit_override = false;
            this.has_count_override = false;
            this.assignment_overrides = null;
         }
      }
      
      public function GetAssignment() : ScheduleAssignment
      {
         return this.mAssignment;
      }
      
      public function get id() : uint
      {
         return this.assignment_id;
      }
      
      protected function get overrides() : ScheduleAssignment
      {
         if(!this.mAssignment)
         {
            return null;
         }
         if(!this.assignment_overrides)
         {
            this.assignment_overrides = new ScheduleAssignment(this.mAssignment.ToObject());
         }
         return this.assignment_overrides;
      }
      
      public function get sim_count() : uint
      {
         if(!this.mAssignment)
         {
            return 0;
         }
         if(this.has_sim_overrides)
         {
            return this.overrides.sim_count;
         }
         return this.mAssignment.sim_count;
      }
      
      public function set sim_count(param1:uint) : void
      {
         this.overrides.sim_count = param1;
         this.has_sim_overrides = true;
      }
      
      public function get sim_criteria() : Array
      {
         if(!this.mAssignment)
         {
            return new Array();
         }
         return this.mAssignment.sim_criteria.concat();
      }
      
      public function get assignment_behaviors() : Array
      {
         if(!this.mAssignment)
         {
            return new Array();
         }
         if(this.has_behavior_override)
         {
            return this.overrides.assignment_behaviors;
         }
         return this.mAssignment.assignment_behaviors.concat();
      }
      
      public function set assignment_behaviors(param1:Array) : void
      {
         this.overrides.assignment_behaviors = param1;
         this.has_behavior_override = true;
      }
      
      public function get assignment_outfit() : ScheduleAssignmentOutfit
      {
         if(!this.mAssignment)
         {
            return new ScheduleAssignmentOutfit(null);
         }
         if(this.has_outfit_override)
         {
            return this.overrides.assignment_outfit;
         }
         return new ScheduleAssignmentOutfit(this.mAssignment.assignment_outfit ? this.mAssignment.assignment_outfit.ToObject() : null);
      }
      
      public function set assignment_outfit(param1:ScheduleAssignmentOutfit) : void
      {
         this.overrides.assignment_outfit = param1;
         this.has_outfit_override = true;
      }
      
      public function get sim_ids() : Array
      {
         if(!this.mAssignment)
         {
            return null;
         }
         if(this.has_sim_overrides)
         {
            return this.overrides.sim_ids;
         }
         return this.mAssignment.sim_ids.concat();
      }
      
      public function set sim_ids(param1:Array) : void
      {
         this.overrides.sim_ids = param1;
         this.has_sim_overrides = true;
      }
      
      public function CopyFrom(param1:ScheduleTimeSlotAssignment) : void
      {
         this.assignment_id = param1.assignment_id;
         this.assignment_overrides = param1.assignment_overrides;
         this.has_behavior_override = param1.has_behavior_override;
         this.has_sim_overrides = param1.has_sim_overrides;
         this.has_outfit_override = param1.has_outfit_override;
         this.has_count_override = param1.has_count_override;
         this.mAssignment = param1.GetAssignment();
      }
   }
}

