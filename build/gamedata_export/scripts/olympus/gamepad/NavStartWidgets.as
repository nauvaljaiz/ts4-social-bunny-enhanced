package olympus.gamepad
{
   import flash.utils.Dictionary;
   import gamedata.CAS.shared.CASConfiguration;
   import olympus.constants.GameStates;
   
   public final class NavStartWidgets
   {
      
      public static const DEFAULT_START_WIDGET_NAMES:Dictionary = new Dictionary();
      
      DEFAULT_START_WIDGET_NAMES[GameStates.BUILD] = "BuildBuyNavigation";
      DEFAULT_START_WIDGET_NAMES[GameStates.CAS] = "CASNavigation";
      DEFAULT_START_WIDGET_NAMES[GameStates.PLAY] = "SimInfoTray";
      DEFAULT_START_WIDGET_NAMES[GameStates.LOT_SELECT] = "GameEntryWorldSelection";
      DEFAULT_START_WIDGET_NAMES[GameStates.TRAVEL] = "GameEntryWorldSelection";
      DEFAULT_START_WIDGET_NAMES[GameStates.MAIN_MENU] = "GameEntryLauncher";
      DEFAULT_START_WIDGET_NAMES[GameStates.FIRST_LAUNCH] = "ScreenMargins";
      DEFAULT_START_WIDGET_NAMES[GameStates.LEGAL_AGREEMENTS] = "LegalAgreements";
      
      public function NavStartWidgets()
      {
         super();
      }
      
      public static function GetStartWidgetName(param1:uint) : String
      {
         var _loc2_:String = "";
         if(param1 == GameStates.CAS)
         {
            if(CASConfiguration.IsFashionMode)
            {
               return "CASFashionShoppingCart";
            }
         }
         var _loc3_:String = DEFAULT_START_WIDGET_NAMES[param1];
         if(_loc3_)
         {
            _loc2_ = _loc3_;
         }
         return _loc2_;
      }
   }
}

