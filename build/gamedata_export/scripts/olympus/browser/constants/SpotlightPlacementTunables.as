package olympus.browser.constants
{
   import olympus.io.CommunicationManager;
   
   public class SpotlightPlacementTunables
   {
      
      public static const SPOTLIGHT_OFFLINE_VAR:String = "_sims4.offline";
      
      public static const SPOTLIGHT_DISABLE_TELEMETRY_VAR:String = "_sims4.disable_telemetry";
      
      public static const GALLERY:int = 1;
      
      public static const GALLERY_OFFLINE:int = 2;
      
      public static const CAS_DEMO:int = 3;
      
      public static const LAUNCHER:int = 4;
      
      public static const LAUNCHER_OFFLINE:int = 5;
      
      public static const SPOTLIGHT_HEIGHT:Number = 190;
      
      public static const SPOTLIGHT_WIDTH:Number = 570;
      
      public static const SPOTLIGHT_ASPECT_RATIO:Number = SPOTLIGHT_HEIGHT / SPOTLIGHT_WIDTH;
      
      public static const SPOTLIGHT_REPORT_TYPE_VIEW:int = 0;
      
      public static const SPOTLIGHT_REPORT_TYPE_CLICK:int = 1;
      
      public static const SPOTLIGHT_REPORT_TYPE_CONVERSION:int = 2;
      
      public function SpotlightPlacementTunables()
      {
         super();
      }
      
      public static function ReturnUrl(param1:int) : String
      {
         var _loc2_:Object = CommunicationManager.CallGameService("GetSpotlightUrls");
         if(!_loc2_)
         {
            return null;
         }
         switch(param1)
         {
            case GALLERY:
            case GALLERY_OFFLINE:
               return _loc2_["spotlight4_gallery"];
            case LAUNCHER:
            case LAUNCHER_OFFLINE:
               return _loc2_["spotlight4_launcher"];
            default:
               return null;
         }
      }
   }
}

