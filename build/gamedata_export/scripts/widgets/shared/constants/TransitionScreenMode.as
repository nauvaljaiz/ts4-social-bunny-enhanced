package widgets.shared.constants
{
   public final class TransitionScreenMode
   {
      
      public static const NONE:int = 0;
      
      public static const BUILD_TO_LIVE:int = 1;
      
      public static const START_UP:int = 2;
      
      public static const BUILD_TO_BUILD:int = 3;
      
      public static const BUILD_TO_NHD_MAP:int = 4;
      
      public static const BB_SUBVENUE_TO_SUBVENUE:int = 5;
      
      public static const MAIN_MENU_TO_CAS:int = 20;
      
      public static const MAIN_MENU_TO_NHD_MAP:int = 21;
      
      public static const MAIN_MENU_TO_LIVE:int = 22;
      
      public static const MAIN_MENU_HOT_LOADING:int = 23;
      
      public static const CAS_TO_MAIN_MENU:int = 30;
      
      public static const CAS_TO_NHD_MAP:int = 31;
      
      public static const CAS_TO_LIVE:int = 32;
      
      public static const REINCARNATION_CAS_TO_LIVE:int = 33;
      
      public static const WORLD_MAP_TO_NHD_MAP:int = 40;
      
      public static const NHD_MAP_TO_WORLD_MAP:int = 41;
      
      public static const NHD_MAP_TO_MAIN_MENU:int = 42;
      
      public static const NHD_MAP_TO_CAS:int = 43;
      
      public static const NHD_MAP_TO_BUILD:int = 44;
      
      public static const NHD_MAP_TO_LIVE_PLAY:int = 45;
      
      public static const NHD_MAP_TO_LIVE_TRAVEL:int = 46;
      
      public static const NHD_MAP_TO_LIVE_PURCHASE:int = 47;
      
      public static const NHD_MAP_TO_BUILD_TO_MAP:int = 48;
      
      public static const LIVE_TO_LIVE:int = 50;
      
      public static const LIVE_TO_MAIN_MENU:int = 51;
      
      public static const LIVE_TO_CAS:int = 52;
      
      public static const LIVE_TO_WORLD_MAP_EDIT:int = 53;
      
      public static const LIVE_TO_NHD_MAP_EDIT:int = 54;
      
      public static const LIVE_TO_NHD_MAP_TRAVEL:int = 55;
      
      public static const LIVE_TO_NHD_MAP_MOVE:int = 56;
      
      public static const LIVE_TO_NHD_MAP_TRANSFER:int = 57;
      
      public static const LIVE_TO_NHD_TO_LIVE:int = 58;
      
      public static const LIVE_TO_NHD_MAP_REINCARNATE:int = 60;
      
      public function TransitionScreenMode()
      {
         super();
      }
      
      public static function IsToLive(param1:int) : Boolean
      {
         return param1 == BUILD_TO_LIVE || param1 == MAIN_MENU_TO_LIVE || param1 == CAS_TO_LIVE || param1 == LIVE_TO_LIVE || param1 == NHD_MAP_TO_LIVE_PLAY || param1 == NHD_MAP_TO_LIVE_TRAVEL || param1 == NHD_MAP_TO_LIVE_PURCHASE || param1 == LIVE_TO_NHD_TO_LIVE || param1 == REINCARNATION_CAS_TO_LIVE;
      }
      
      public static function IsFromLive(param1:int) : Boolean
      {
         return param1 == LIVE_TO_LIVE || param1 == LIVE_TO_MAIN_MENU || param1 == LIVE_TO_CAS || param1 == LIVE_TO_NHD_MAP_TRAVEL || param1 == LIVE_TO_NHD_MAP_MOVE || param1 == LIVE_TO_NHD_MAP_TRANSFER || param1 == LIVE_TO_WORLD_MAP_EDIT || param1 == LIVE_TO_NHD_MAP_EDIT || param1 == LIVE_TO_NHD_TO_LIVE || param1 == LIVE_TO_NHD_MAP_REINCARNATE;
      }
      
      public static function HasTransitionMusic(param1:int) : Boolean
      {
         return param1 != BUILD_TO_LIVE;
      }
   }
}

