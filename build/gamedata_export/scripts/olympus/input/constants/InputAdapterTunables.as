package olympus.input.constants
{
   import olympus.math.Geometry;
   
   public final class InputAdapterTunables
   {
      
      public static const ANALOG_DEADZONE:Number = 0.4;
      
      public static const ANALOG_DEADZONE_SQ:Number = ANALOG_DEADZONE * ANALOG_DEADZONE;
      
      public static const DEFAULT_STARTING_DIR_INPUT_DEBOUNCE:uint = 250;
      
      public static const DEFAULT_DIR_INPUT_ACCELERATION:uint = 20;
      
      public static const DEFAULT_DIR_INPUT_MINIMUM_DEBOUNCE:* = 50;
      
      public static const SCREEN_MARGINS_ANALOG_DEBOUNCE:uint = 10;
      
      public static const MAX_SCREEN_MARGIN_PERCENT:Number = 0.05;
      
      public static const DEFAULT_SCREEN_MARGIN_PERCENT:Number = 0;
      
      public static const OMNIDIRECTIONAL_SEARCH_MAX_ARC_LENGTH:Number = Geometry.QUARTER_PI;
      
      public static const OMNIDIRECTIONAL_SEARCH_MAX_ARC_LENGTH_WIDE:Number = Geometry.HALF_PI * 0.9;
      
      public static const DEFAULT_LINK_PROXY_HIGHLIGHT_COLOR:uint = 65280;
      
      public static const DEFAULT_LINK_PROXY_HIGHLIGHT_ALPHA:Number = 0.8;
      
      public static const DEFAULT_LINK_PROXY_OUTLINE_THICKNESS:uint = 2;
      
      public function InputAdapterTunables()
      {
         super();
      }
   }
}

