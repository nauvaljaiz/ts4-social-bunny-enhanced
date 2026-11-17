package gamedata.Gameplay.Kingdom
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class KingdomStaticData extends OlympusObject
   {
      
      protected static var sKingdomData:KingdomStaticData;
      
      public var noble_career:String;
      
      public function KingdomStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : KingdomStaticData
      {
         if(!sKingdomData)
         {
            sKingdomData = new KingdomStaticData(CommunicationManager.CallGameService("GetKingdomTuning"));
         }
         return sKingdomData;
      }
   }
}

