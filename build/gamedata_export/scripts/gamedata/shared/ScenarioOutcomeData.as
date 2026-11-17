package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ScenarioOutcomeData extends OlympusObject
   {
      
      public var scenario_name:LocKey = new LocKey();
      
      public var outcome_title:LocKey = new LocKey();
      
      public var outcome_description:LocKey = new LocKey();
      
      public var next_steps_description:LocKey = new LocKey();
      
      public var reward_tooltip:LocKey = new LocKey();
      
      public var bonus_tooltip:LocKey = new LocKey();
      
      public var outcome_icon:ResourceKey = new ResourceKey();
      
      public var reward_icon:ResourceKey = new ResourceKey();
      
      public var bonus_icon:ResourceKey = new ResourceKey();
      
      public var household_id:String = null;
      
      public function ScenarioOutcomeData(param1:Object = null)
      {
         super(param1);
      }
   }
}

