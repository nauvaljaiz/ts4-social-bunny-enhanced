package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class StoryProgressionRuleData extends OlympusObject
   {
      
      public var ruleId:String;
      
      public var ruleName:LocKey = new LocKey();
      
      public var ruleDescription:LocKey = new LocKey();
      
      public var ruleIcon:ResourceKey = new ResourceKey();
      
      public function StoryProgressionRuleData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.ruleName = FixupLocKey(this.ruleName);
         this.ruleDescription = FixupLocKey(this.ruleDescription);
      }
   }
}

