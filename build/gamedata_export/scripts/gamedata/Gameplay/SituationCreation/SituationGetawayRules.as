package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   
   public class SituationGetawayRules extends OlympusObject
   {
      
      public var options:Array = [SituationGetawayRuleOption];
      
      public function SituationGetawayRules(param1:Object = null)
      {
         super(param1);
         FixupArray(this.options);
      }
   }
}

