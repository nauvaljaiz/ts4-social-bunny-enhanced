package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class GhostPowersStaticData extends OlympusObject
   {
      
      protected static var sGhostPowersData:GhostPowersStaticData = null;
      
      public var statistic:String;
      
      public var mana_commodity:String;
      
      public var good_ultimate_statistic:String;
      
      public var evil_ultimate_statistic:String;
      
      public var good_ultimate_max_value:int;
      
      public var evil_ultimate_max_value:int;
      
      public var good_ultimate_icon:ResourceKey = new ResourceKey();
      
      public var evil_ultimate_icon:ResourceKey = new ResourceKey();
      
      public function GhostPowersStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : GhostPowersStaticData
      {
         if(!sGhostPowersData)
         {
            sGhostPowersData = new GhostPowersStaticData(CommunicationManager.CallGameService("GetGhostPowersTuning"));
         }
         return sGhostPowersData;
      }
   }
}

