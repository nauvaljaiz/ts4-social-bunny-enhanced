package gamedata.Gameplay.SimCamera
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimCameraFilterData extends OlympusObject
   {
      
      public var filter:uint;
      
      public var tooltipLocKey:LocKey = new LocKey();
      
      public var frameLabel:String;
      
      public function SimCameraFilterData(param1:Object = null)
      {
         super(param1);
      }
   }
}

