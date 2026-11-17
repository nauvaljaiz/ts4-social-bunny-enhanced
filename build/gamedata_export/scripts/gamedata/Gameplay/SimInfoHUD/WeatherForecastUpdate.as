package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class WeatherForecastUpdate extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_large:ResourceKey = new ResourceKey();
      
      public var icon_mascot:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public var name:LocKey = new LocKey();
      
      public function WeatherForecastUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

