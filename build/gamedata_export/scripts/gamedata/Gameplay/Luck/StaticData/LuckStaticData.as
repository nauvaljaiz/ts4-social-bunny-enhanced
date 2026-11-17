package gamedata.Gameplay.Luck.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class LuckStaticData extends OlympusObject
   {
      
      protected static var sLuckStaticData:LuckStaticData;
      
      public var levels:Array = [LuckLevelData];
      
      public var sim_info_tray_icon:ResourceKey = new ResourceKey();
      
      public var sim_info_tray_hover_icon:ResourceKey = new ResourceKey();
      
      public function LuckStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : LuckStaticData
      {
         if(!sLuckStaticData)
         {
            sLuckStaticData = new LuckStaticData(CommunicationManager.CallGameService("GetLuckData"));
         }
         return sLuckStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.levels);
      }
   }
}

