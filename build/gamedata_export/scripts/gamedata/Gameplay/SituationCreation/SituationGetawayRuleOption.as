package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationGetawayRuleOption extends OlympusObject
   {
      
      public var rule_guid64:String;
      
      public var display_name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var is_track_based_challenge:Boolean;
      
      public var groups:Array = [SituationGetawayRuleOptionGroup];
      
      public function SituationGetawayRuleOption(param1:Object = null)
      {
         super(param1);
         this.display_name = FixupLocKey(this.display_name);
         this.description = FixupLocKey(this.description);
         FixupArray(this.groups);
      }
   }
}

