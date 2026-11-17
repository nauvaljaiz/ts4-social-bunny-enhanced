package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class WeatherUpdate extends OlympusObject
   {
      
      public static const EXTREME_WARNING_NONE:int = 0;
      
      public static const EXTREME_WARNING_HOT:int = 1;
      
      public static const EXTREME_WARNING_COLD:int = 2;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_large:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var warning:int;
      
      public function WeatherUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

