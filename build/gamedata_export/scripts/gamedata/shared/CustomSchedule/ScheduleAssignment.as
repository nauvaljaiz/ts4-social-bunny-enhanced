package gamedata.shared.CustomSchedule
{
   import gamedata.Gameplay.Clubs.ClubCriteria;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ScheduleAssignment extends OlympusObject
   {
      
      public var name:String;
      
      public var sim_count:uint;
      
      public var sim_criteria:Array = [ClubCriteria];
      
      public var assignment_behaviors:Array = [ResourceKey];
      
      public var assignment_outfit:ScheduleAssignmentOutfit = new ScheduleAssignmentOutfit();
      
      public var sim_ids:Array = [String];
      
      public var is_new:Boolean;
      
      public var is_immutable:Boolean;
      
      public var id:uint;
      
      public var premade_name:LocKey = new LocKey();
      
      public function ScheduleAssignment(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1["assignment_outfit"])
         {
            this.assignment_outfit = null;
         }
         if(Boolean(this.premade_name) && this.premade_name.IsValid())
         {
            this.name = this.premade_name.toString();
         }
         FixupArray(this.sim_criteria);
         FixupArray(this.assignment_behaviors);
         FixupArray(this.sim_ids);
      }
      
      public function ToObject(param1:Boolean = true) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_["name"] = this.name;
         _loc2_["sim_count"] = this.sim_count;
         _loc2_["sim_criteria"] = ArrayToObject(this.sim_criteria);
         _loc2_["assignment_behaviors"] = ArrayToObject(this.assignment_behaviors);
         if(this.assignment_outfit)
         {
            _loc2_["assignment_outfit"] = this.assignment_outfit.ToObject();
         }
         if(param1)
         {
            _loc2_["sim_ids"] = this.sim_ids;
         }
         if(Boolean(this.premade_name) && Boolean(this.premade_name.IsValid()) && this.premade_name.toString() == this.name)
         {
            _loc2_["premade_name"] = this.premade_name.ToObject();
         }
         _loc2_["is_new"] = this.is_new;
         _loc2_["is_immutable"] = this.is_immutable;
         _loc2_["id"] = this.id;
         return _loc2_;
      }
      
      public function CopyFrom(param1:Object) : void
      {
         this.name = param1.name;
         this.sim_count = param1.sim_count;
         this.sim_criteria = param1.sim_criteria;
         this.assignment_behaviors = param1.assignment_behaviors;
         this.assignment_outfit = param1.assignment_outfit;
         this.sim_ids = param1.sim_ids;
         this.is_new = true;
         this.is_immutable = false;
         this.id = param1.id;
      }
      
      public function AreChanges(param1:ScheduleAssignment) : Boolean
      {
         var _loc3_:uint = 0;
         if(this.name != param1.name)
         {
            return true;
         }
         if(this.sim_count != param1.sim_count)
         {
            return true;
         }
         var _loc2_:uint = this.sim_ids.length;
         if(_loc2_ != param1.sim_ids.length)
         {
            return true;
         }
         this.sim_ids.sort();
         param1.sim_ids.sort();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.sim_ids[_loc3_] != param1.sim_ids[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         _loc2_ = this.sim_criteria.length;
         if(_loc2_ != param1.sim_criteria.length)
         {
            return true;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(!this.sim_criteria[_loc3_].Equals(param1.sim_criteria[_loc3_]))
            {
               return true;
            }
            _loc3_++;
         }
         _loc2_ = this.assignment_behaviors.length;
         if(_loc2_ != param1.assignment_behaviors.length)
         {
            return true;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(!this.assignment_behaviors[_loc3_].IsEqual(param1.assignment_behaviors[_loc3_]))
            {
               return true;
            }
            _loc3_++;
         }
         if(!this.assignment_outfit)
         {
            return this.assignment_outfit != param1.assignment_outfit;
         }
         if(!this.assignment_outfit)
         {
            return true;
         }
         return !this.assignment_outfit.Equals(param1.assignment_outfit);
      }
   }
}

