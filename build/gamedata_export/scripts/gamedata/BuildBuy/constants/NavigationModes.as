package gamedata.BuildBuy.constants
{
   public final class NavigationModes
   {
      
      public static const NONE:int = 0;
      
      public static const BUY:int = 1;
      
      public static const BUILD:int = 2;
      
      public static const MAGALOG:int = 3;
      
      public static const FUNCTION:int = 5;
      
      public static const INVENTORY:int = 7;
      
      public static const OPEN_SEARCH:int = 9;
      
      public static const count:int = 10;
      
      public function NavigationModes()
      {
         super();
      }
      
      public static function GetAudioString(param1:int) : String
      {
         switch(param1)
         {
            case BUY:
               return "buy";
            case BUILD:
               return "build";
            case FUNCTION:
               return "function";
            default:
               return null;
         }
      }
   }
}

