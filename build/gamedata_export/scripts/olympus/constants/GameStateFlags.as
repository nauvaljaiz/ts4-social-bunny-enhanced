package olympus.constants
{
   public final class GameStateFlags
   {
      
      public static const LOTSELECT_GAME_LOAD:uint = 1;
      
      public static const LOTSELECT_TUTORIAL:uint = 2;
      
      public static const LOTSELECT_EDIT_WORLD:uint = 3;
      
      public static const LOTSELECT_FROM_INGAME_MOVE:uint = 4;
      
      public static const LOTSELECT_FROM_INGAME_TRANSFER:uint = 5;
      
      public static const LOTSELECT_FROM_CAS_EDIT_HH:uint = 6;
      
      public static const LOTSELECT_FROM_CAS_ADD_HH:uint = 7;
      
      public static const LOTSELECT_FROM_CAS_MOVE_HH:uint = 8;
      
      public static const PLAYAREA_START_IN_BUILD:uint = 9;
      
      public static const PLAYAREA_FREE_BUILD:uint = 10;
      
      public static const BUILD_LOT_THUMBNAIL:uint = 11;
      
      public static const LOTSELECT_FROM_INGAME_TRAVEL:uint = 12;
      
      public static const LOTSELECT_FROM_MANAGEWORLDS_BUILD_EDIT:uint = 13;
      
      public static const BUILD_LOT_THUMBNAIL_POST_BUILD:uint = 14;
      
      public static const LOTSELECT_FROM_MAINMENU_EDIT:uint = 15;
      
      public static const LOTSELECT_FROM_INGAME_TRAVEL_NO_PICKER:uint = 16;
      
      public static const BUILD_LOT_MODIFIED:uint = 17;
      
      public static const LOTSELECT_FROM_INGAME_VACATION:uint = 18;
      
      public static const LOTSELECT_FOR_PURCHASE_VENUE:uint = 19;
      
      public static const RESUME_INTO_NBHD_FROM_BUILD:uint = 20;
      
      public static const RESUME_INTO_NBHD_AFTER_BUILD_OP:uint = 21;
      
      public static const LOTSELECT_EDIT_NBHD:uint = 22;
      
      public static const LOTEXIT_FROM_BUILD_MODE:uint = 23;
      
      public static const LOTSELECT_FROM_INGAME_EVICT:uint = 24;
      
      public static const LOTSELECT_FROM_MAINMENU_EDIT_PREMADE:uint = 25;
      
      public static const LOTSELECT_FROM_REINCARNATION:uint = 26;
      
      protected static var mbIsBetweenStates:Boolean = false;
      
      public function GameStateFlags()
      {
         super();
      }
      
      public static function get IsBetweenStates() : Boolean
      {
         return mbIsBetweenStates;
      }
      
      public static function set IsBetweenStates(param1:Boolean) : void
      {
         mbIsBetweenStates = param1;
      }
   }
}

