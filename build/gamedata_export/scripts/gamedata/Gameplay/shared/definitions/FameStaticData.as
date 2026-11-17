package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class FameStaticData extends OlympusObject
   {
      
      protected static var sFameData:FameStaticData;
      
      public var shunned_rel_bit:String;
      
      public var fame_statistic:String;
      
      public var reputation_statistic:String;
      
      public function FameStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : FameStaticData
      {
         if(!sFameData)
         {
            sFameData = new FameStaticData(CommunicationManager.CallGameService("GetFameTuning"));
         }
         return sFameData;
      }
   }
}

