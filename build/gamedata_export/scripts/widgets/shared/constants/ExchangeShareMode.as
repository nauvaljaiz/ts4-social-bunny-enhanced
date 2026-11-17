package widgets.shared.constants
{
   import olympus.core.ConnectionManager;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public final class ExchangeShareMode
   {
      
      public static const HOMEPAGE:int = 0;
      
      public static const COMMUNITY:int = 1;
      
      public static const LIBRARY:int = 2;
      
      public static const MY_PROFILE:int = 3;
      
      public static const CG:int = 4;
      
      public function ExchangeShareMode()
      {
         super();
      }
      
      public static function RequiresConnection(param1:int) : Boolean
      {
         return param1 == COMMUNITY || param1 == MY_PROFILE || param1 == CG;
      }
      
      public static function GetContextualizedMode(param1:Object = null) : int
      {
         var _loc2_:int = param1 as int;
         if(param1 == null)
         {
            _loc2_ = COMMUNITY;
         }
         if(ConnectionManager.IsOnlineAccessDisabled)
         {
            _loc2_ = LIBRARY;
         }
         else if(!ConnectionManager.IsUGCOnline && RequiresConnection(_loc2_))
         {
            if(SharedExchangeUtils.IsHomepagePanelAvailable())
            {
               _loc2_ = HOMEPAGE;
            }
            else
            {
               _loc2_ = LIBRARY;
            }
         }
         return _loc2_;
      }
   }
}

