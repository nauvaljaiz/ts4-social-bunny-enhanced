package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public class BrowserJavascriptCall extends OlympusObject
   {
      
      public static const METHOD_CLICK:String = "onClick";
      
      public static const METHOD_LOAD_SUCCESS:String = "spotlight_notify_ready";
      
      public static const METHOD_LOAD_FAILURE:String = "spotlight_notify_failure";
      
      public static const METHOD_FACEBOOK_STATUS_LOGGED_IN:String = "facebook_loggedin";
      
      public static const METHOD_FACEBOOK_STATUS_LOGGED_OUT:String = "facebook_loggedout";
      
      public static const METHOD_AUDIO_CLICK:String = "audio_click";
      
      public var browserId:uint;
      
      public var jsArgs:Object;
      
      public var methodName:String;
      
      public function BrowserJavascriptCall(param1:Object = null)
      {
         super(param1);
      }
   }
}

