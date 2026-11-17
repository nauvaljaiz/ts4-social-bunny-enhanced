package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationGetawayRuleOptionGroup extends OlympusObject
   {
      
      public var category_id:uint;
      
      public var category_display_name:LocKey = new LocKey();
      
      public var is_multi_select:Boolean;
      
      public var disallowed_ages:Array = [uint];
      
      public var disallowed_species:Array = [uint];
      
      public function SituationGetawayRuleOptionGroup(param1:Object = null)
      {
         super(param1);
         FixupArray(this.disallowed_ages);
         FixupArray(this.disallowed_species);
      }
   }
}

