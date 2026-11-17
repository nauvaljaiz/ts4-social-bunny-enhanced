package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PerformanceStaticData extends OlympusObject
   {
      
      public var stat_name:LocKey = new LocKey();
      
      public var min_value:int;
      
      public var max_value:int;
      
      public function PerformanceStaticData(param1:Object = null)
      {
         super(param1);
      }
   }
}

