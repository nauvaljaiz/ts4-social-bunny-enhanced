package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class VenueStaticData extends OlympusObject
   {
      
      protected static var sData:VenueStaticData;
      
      public var new_venue_dialog_special_cases:Array;
      
      public function VenueStaticData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.new_venue_dialog_special_cases);
      }
      
      public static function GetStaticData() : VenueStaticData
      {
         var _loc1_:* = undefined;
         if(!sData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetVenueModuleTuning");
            sData = new VenueStaticData(_loc1_);
         }
         return sData;
      }
   }
}

