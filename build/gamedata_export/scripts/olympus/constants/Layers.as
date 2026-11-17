package olympus.constants
{
   public final class Layers
   {
      
      public static const ALWAYS_ON_TOP_TRANSITION:int = 0;
      
      public static const ALWAYS_ON_TOP_NO_INPUT:int = 1;
      
      public static const ALWAYS_ON_TOP_TOOLTIP:int = 2;
      
      public static const ALWAYS_ON_TOP_POPUP:int = 3;
      
      public static const ALWAYS_ON_TOP:int = 4;
      
      public static const WIDGETS_POPUP:int = 5;
      
      public static const WIDGETS:int = 6;
      
      public static const SCREEN_MARGINS_BACKGROUND:int = 7;
      
      public static const WORLD_ELEMENTS:int = 8;
      
      public static const count:int = 9;
      
      public function Layers()
      {
         super();
      }
      
      public static function ConvertToString(param1:int) : String
      {
         switch(param1)
         {
            case ALWAYS_ON_TOP_TRANSITION:
               return "ALWAYS_ON_TOP_TRANSITION";
            case ALWAYS_ON_TOP_NO_INPUT:
               return "ALWAYS_ON_TOP_NO_INPUT";
            case ALWAYS_ON_TOP_TOOLTIP:
               return "ALWAYS_ON_TOP_TOOLTIP";
            case ALWAYS_ON_TOP_POPUP:
               return "GAMEPLAY";
            case ALWAYS_ON_TOP:
               return "ALWAYS_ON_TOP";
            case WIDGETS_POPUP:
               return "WIDGETS_POPUP";
            case SCREEN_MARGINS_BACKGROUND:
               return "SCREEN_MARGINS_BACKGROUND";
            case WORLD_ELEMENTS:
               return "WORLD_ELEMENTS";
            case WIDGETS:
               return "WIDGETS";
            default:
               return null;
         }
      }
   }
}

