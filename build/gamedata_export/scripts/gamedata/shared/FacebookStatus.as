package gamedata.shared
{
   import olympus.io.CommunicationManager;
   
   public class FacebookStatus
   {
      
      public function FacebookStatus()
      {
         super();
      }
      
      public static function get FacebookEnabled() : Boolean
      {
         return false;
      }
      
      public static function get FacebookAvailable() : Boolean
      {
         if(FacebookUrls)
         {
            return true;
         }
         return false;
      }
      
      public static function get FacebookUrls() : Object
      {
         return CommunicationManager.CallGameService("GetFacebookUrls");
      }
   }
}

