package gamedata.shared.CustomSchedule
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.SimPB;
   
   public class CustomSchedule extends OlympusObject
   {
      
      public static const ERROR_STATE_COUNT:* = 1 << 0;
      
      public static const ERROR_STATE_DUPLICATE_SIM:* = 1 << 1;
      
      public static const ERROR_STATE_MISSING_HH_SIM:* = 1 << 2;
      
      public static const ERROR_STATE_INVALID_SCHEDLE:* = 1 << 3;
      
      public var name:String;
      
      public var assignment_presets:Array = [ScheduleAssignment];
      
      public var time_slots:Array = [ScheduleTimeSlot];
      
      public var rules:Array = [GetawaySelectedRule];
      
      public var is_immutable:Boolean;
      
      public var premade_name:LocKey = new LocKey();
      
      public var use_current_track_values:Boolean;
      
      public function CustomSchedule(param1:Object = null)
      {
         super(param1);
         FixupArray(this.assignment_presets);
         FixupArray(this.time_slots);
         FixupArray(this.rules);
         this.FixupTimeSlotAssignments();
         this.FixupRuleAssignmentNames();
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(Boolean(this.premade_name) && this.premade_name.IsValid())
         {
            this.name = this.premade_name.toString();
         }
         if(this.time_slots.length > 0 && !this.is_immutable)
         {
            this.time_slots[0].mbExpanded = true;
         }
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["name"] = this.name;
         _loc1_["assignment_presets"] = ArrayToObject(this.assignment_presets);
         _loc1_["time_slots"] = ArrayToObject(this.time_slots);
         if(this.rules)
         {
            _loc1_["rules"] = ArrayToObject(this.rules);
         }
         if(Boolean(this.premade_name) && Boolean(this.premade_name.IsValid()) && this.premade_name.toString() == this.name)
         {
            _loc1_["premade_name"] = this.premade_name.ToObject();
         }
         _loc1_["is_immutable"] = this.is_immutable;
         _loc1_["use_current_track_values"] = this.use_current_track_values;
         return _loc1_;
      }
      
      protected function FixupTimeSlotAssignments() : void
      {
         var _loc2_:ScheduleAssignment = null;
         var _loc3_:ScheduleTimeSlot = null;
         var _loc4_:ScheduleTimeSlotAssignment = null;
         var _loc1_:Object = new Object();
         for each(_loc2_ in this.assignment_presets)
         {
            _loc1_[_loc2_.id] = _loc2_;
         }
         for each(_loc3_ in this.time_slots)
         {
            for each(_loc4_ in _loc3_.assignments)
            {
               _loc4_.SetAssignment(_loc1_[_loc4_.assignment_id]);
            }
            if(_loc3_.assignments.length == 0)
            {
               _loc3_.assignments.push(new ScheduleTimeSlotAssignment());
            }
            if(_loc3_.assignments.length == 1)
            {
               _loc3_.assignments[0].mbLastAssignment = true;
            }
         }
      }
      
      protected function FixupRuleAssignmentNames() : void
      {
         var _loc1_:GetawaySelectedRule = null;
         var _loc2_:GetawaySelectedRuleGroup = null;
         var _loc3_:int = 0;
         for each(_loc1_ in this.rules)
         {
            for each(_loc2_ in _loc1_.groups)
            {
               if(_loc2_.assignment_names.length == 0 && _loc2_.assignment_ids.length != 0)
               {
                  for each(_loc3_ in _loc2_.assignment_ids)
                  {
                     _loc2_.assignment_names.push(this.assignment_presets[_loc3_].name);
                  }
               }
               _loc2_.assignment_ids = [];
            }
         }
      }
      
      public function GetSimInformation() : Object
      {
         var _loc6_:ScheduleTimeSlot = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc1_:Object = {};
         var _loc2_:Object = {};
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         for each(_loc6_ in this.time_slots)
         {
            for(_loc7_ in _loc6_.mTimeSlotSims)
            {
               if(!_loc2_[_loc7_])
               {
                  _loc2_[_loc7_] = true;
                  _loc8_ = _loc4_;
                  if(_loc6_.mTimeSlotSims[_loc7_])
                  {
                     _loc8_ = _loc3_;
                  }
                  _loc8_.push(_loc7_);
               }
            }
         }
         return {
            "householdSimIds":_loc3_,
            "npcSimIds":_loc4_
         };
      }
      
      public function GetUncachedSimInformation() : Object
      {
         var _loc6_:SimPB = null;
         var _loc7_:ScheduleTimeSlot = null;
         var _loc8_:ScheduleTimeSlotAssignment = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc1_:Object = {};
         var _loc2_:Object = {};
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         for each(_loc6_ in GameplayStateData.SelectableSims)
         {
            _loc1_[_loc6_.id] = true;
         }
         for each(_loc7_ in this.time_slots)
         {
            for each(_loc8_ in _loc7_.assignments)
            {
               for each(_loc9_ in _loc8_.sim_ids)
               {
                  _loc10_ = _loc4_;
                  if(_loc1_[_loc9_])
                  {
                     _loc10_ = _loc3_;
                  }
                  if(!_loc2_[_loc9_])
                  {
                     _loc2_[_loc9_] = true;
                     _loc10_.push(_loc9_);
                  }
               }
            }
         }
         return {
            "householdSimIds":_loc3_,
            "npcSimIds":_loc4_
         };
      }
   }
}

