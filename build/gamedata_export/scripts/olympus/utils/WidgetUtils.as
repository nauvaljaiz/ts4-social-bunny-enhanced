package olympus.utils
{
   import flash.display.DisplayObject;
   import olympus.core.interfaces.IBase;
   import olympus.io.CommunicationManager;
   
   public class WidgetUtils
   {
      
      public function WidgetUtils()
      {
         super();
      }
      
      public static function GetBase(param1:DisplayObject) : IBase
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:DisplayObject = param1;
         while(!(_loc2_ is IBase) && _loc2_ != param1.stage)
         {
            _loc2_ = _loc2_.parent;
         }
         if(_loc2_ == param1.stage)
         {
            return null;
         }
         return _loc2_ as IBase;
      }
      
      public static function GetBaseName(param1:DisplayObject) : String
      {
         var _loc2_:IBase = GetBase(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.BaseName))
         {
            return _loc2_.BaseName;
         }
         return "UNKNOWN";
      }
      
      public static function HideExchangeWidgets() : void
      {
         CommunicationManager.SendUIMessage("HideExchangeDetail",null);
         CommunicationManager.SendUIMessage("HideExchangeShare",null);
         CommunicationManager.SendUIMessage("HideExchangePlayerProfile",null);
         CommunicationManager.SendUIMessage("HideExchangePackDetail",null);
         CommunicationManager.SendUIMessage("HideFacebookDisplay",null);
         CommunicationManager.SendUIMessage("HideExchangeSubscriptions",null);
      }
   }
}

