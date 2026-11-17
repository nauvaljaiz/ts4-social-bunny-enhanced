package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AdvertisingTuning extends OlympusObject
   {
      
      public var advertising_enum:uint;
      
      public var advertising_name:LocKey = new LocKey();
      
      public function AdvertisingTuning(param1:Object = null)
      {
         super(param1);
      }
   }
}

