package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class GetawaySelectedRule extends OlympusObject
   {
      
      public var rule_guid64:String;
      
      public var groups:Array = [GetawaySelectedRuleGroup];
      
      public var use_current_track_values:Boolean;
      
      public function GetawaySelectedRule(param1:Object = null)
      {
         super(param1);
         FixupArray(this.groups);
      }
      
      public function ToObject() : Object
      {
         return {
            "rule_guid64":this.rule_guid64,
            "groups":ArrayToObject(this.groups),
            "use_current_track_values":this.use_current_track_values
         };
      }
   }
}

