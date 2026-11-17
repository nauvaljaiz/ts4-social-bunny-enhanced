package gamedata.Gameplay.Kingdom
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class FavorStaticData extends OlympusObject
   {
      
      protected static var sFavorData:FavorStaticData;
      
      public var unknown_name:LocKey = new LocKey();
      
      public var unknown_icon:ResourceKey = new ResourceKey();
      
      public var noble_career_track:String;
      
      public var favor_statistic:String;
      
      public function FavorStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : FavorStaticData
      {
         if(!sFavorData)
         {
            sFavorData = new FavorStaticData(CommunicationManager.CallGameService("GetFavorTuning"));
         }
         return sFavorData;
      }
   }
}

