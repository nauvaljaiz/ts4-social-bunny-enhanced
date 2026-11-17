package gamedata.Gameplay.Luck.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class LuckLevelData extends OlympusObject
   {
      
      public var description:LocKey = new LocKey();
      
      public var background:ResourceKey = new ResourceKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function LuckLevelData(param1:Object = null)
      {
         super(param1);
      }
   }
}

