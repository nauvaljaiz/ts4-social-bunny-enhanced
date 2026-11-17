package gamedata.Gameplay.CheatSheet
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class CheatSheetStaticData extends OlympusObject
   {
      
      protected static var sCheatSheetData:CheatSheetStaticData = null;
      
      public var control_elements:Array;
      
      public function CheatSheetStaticData(param1:Array = null)
      {
         super(param1);
         this.control_elements = param1;
      }
      
      public static function GetStaticData() : CheatSheetStaticData
      {
         var _loc1_:Array = null;
         if(!sCheatSheetData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetCheatSheetTuning") as Array;
            sCheatSheetData = new CheatSheetStaticData(_loc1_);
         }
         return sCheatSheetData;
      }
   }
}

