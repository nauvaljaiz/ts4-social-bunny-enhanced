package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class GetawaySelectedRuleGroup extends OlympusObject
   {
      
      public var group_id:uint;
      
      public var assignment_names:Array = [String];
      
      public var assignment_ids:Array = [int];
      
      public function GetawaySelectedRuleGroup(param1:Object = null)
      {
         super(param1);
         FixupArray(this.assignment_names);
         FixupArray(this.assignment_ids);
      }
      
      public function ToObject() : Object
      {
         return {
            "group_id":this.group_id,
            "assignment_names":this.assignment_names
         };
      }
   }
}

