package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SupplyQualityTuning extends OlympusObject
   {
      
      public var quality_enum:uint;
      
      public var quality_name:LocKey = new LocKey();
      
      public function SupplyQualityTuning(param1:Object = null)
      {
         super(param1);
      }
   }
}

