package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AgeVariantData extends OlympusObject
   {
      
      public var female_string:LocKey = new LocKey();
      
      public var male_string:LocKey = new LocKey();
      
      public function AgeVariantData(param1:Object = null)
      {
         super(param1);
      }
   }
}

