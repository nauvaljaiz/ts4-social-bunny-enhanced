package olympus.input.helpers
{
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   
   public class VirtualKeyboardHelper
   {
      
      protected static var sCallback:Function;
      
      public static const KEYBOARD_TYPE_DEFAULT:String = "Default";
      
      public static const KEYBOARD_TYPE_PASSWORD:String = "Password";
      
      public static const KEYBOARD_TYPE_SMTP:String = "SMTP";
      
      public static const KEYBOARD_TYPE_URL:String = "Url";
      
      public static const KEYBOARD_TYPE_NUMBERS:String = "Numbers";
      
      public static const KEYBOARD_TYPE_ALPHANUMERIC:String = "Alphanumeric";
      
      public static const STATUS_COMPLETE:int = 0;
      
      public static const STATUS_CANCELED:int = 1;
      
      public function VirtualKeyboardHelper()
      {
         super();
      }
      
      public static function Open(param1:String, param2:Function, param3:String = "", param4:String = "", param5:Number = 0) : void
      {
         if(!SystemUtils.IsConsole)
         {
            return;
         }
         sCallback = param2;
         CommunicationManager.AddMessageListenerByName("VirtualKeyboardOutput",OnReceiveOutput,"VirtualKeyboardHelper");
         var _loc6_:Object = {
            "keyboardType":param1,
            "defaultString":param3,
            "description":param4,
            "maxLength":param5
         };
         CommunicationManager.CallGameService("OpenVirtualKeyboard",_loc6_);
      }
      
      protected static function OnReceiveOutput(param1:Object = null) : void
      {
         CommunicationManager.RemoveMessageListenerByName("VirtualKeyboardOutput",OnReceiveOutput,"VirtualKeyboardHelper");
         if(Boolean(sCallback) && param1.text != null)
         {
            sCallback(param1.status as int,param1.text as String);
         }
         sCallback = null;
      }
   }
}

