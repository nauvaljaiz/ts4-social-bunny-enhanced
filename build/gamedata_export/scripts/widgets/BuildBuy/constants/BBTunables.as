package widgets.BuildBuy.constants
{
   import flash.geom.Point;
   import gamedata.BuildBuy.Context.ContextData;
   import olympus.core.widget.Margin;
   import olympus.localization.KeysBB;
   
   public final class BBTunables
   {
      
      public static const FILTERS_PANEL_WIDTH:Number = 196;
      
      public static const FILTERS_PANEL_HEIGHT:Number = 300;
      
      public static const FILTERS_PANEL_CONTROLLER_SCROLL_MARGIN:Number = 10;
      
      public static const FILTER_PANEL_TWEEN_GROWTH_POINT:Point = new Point(0,1);
      
      public static const FILTERS_PANEL_VERTICAL_OFFSET:Number = -4;
      
      public static const FILTER_BUBBLE_EXPANDED_BOTTOM_PADDING:Number = -1;
      
      public static const CATALOG_RENDERER_WIDTH:Number = 92;
      
      public static const CATALOG_PANEL_MINIMUM_COLUMNS:Number = 5;
      
      public static const CATALOG_INVENTORY_CELL_PADDING:Margin = new Margin(0,0,0,0);
      
      public static const INVENTORY_RENDERER_WIDTH:Number = 92;
      
      public static const INVENTORY_RENDERER_HEIGHT:Number = 93.5;
      
      public static const INVENTORY_PANEL_MINIMUM_COLUMNS:Number = 5;
      
      public static const INVENTORY_PANEL_LIST_OFFSETS:Margin = new Margin(0);
      
      public static const INVENTORY_PANEL_LIST_MARGIN:Margin = new Margin(2,20,2,0);
      
      public static const INVENTORY_STACK_LIST_OFFSETS:Margin = new Margin(8,6);
      
      public static const INVENTORY_STACK_LIST_MARGIN:Margin = new Margin(0,14,0,4);
      
      public static const INVENTORY_STACK_NUM_COLUMNS:int = 4;
      
      public static const INVENTORY_STACK_NUM_ROWS:int = 2;
      
      public static const INVENTORY_STACK_MAX_ITEM_COUNT:int = 99;
      
      public static const VARIATION_GRID_STACK_MAX_COLORS:int = 15;
      
      public static const VARIATION_GRID_STACK_OFFSET:Number = 24;
      
      public static const VARIATION_GRID_EXPANDED_IN_WORLD_PADDING:Margin = new Margin(2);
      
      public static const VARIATION_GRID_EXPANDED_IN_WORLD_GRID_PADDING:Margin = new Margin(5);
      
      public static const VARIATION_GRID_EXPANDED_CATALOG_PADDING:Margin = new Margin(1,1,2,2);
      
      public static const VARIATION_GRID_EXPANDED_CATALOG_GRID_PADDING:Margin = new Margin(3,4,4,3);
      
      public static const VARIATION_GRID_EXPANDED_MAX_COLUMNS:int = 5;
      
      public static const VARIATION_GRID_EXPANDED_MAX_ROWS:int = 4;
      
      public static const VARIATION_GRID_IN_WORLD_ROLL_OUT_DELAY:Number = 250;
      
      public static const PRODUCT_INFO_PANEL_HIDE_DELAY:uint = 90;
      
      public static const TERRAIN_BRUSH_SLIDER_GRANULARITY:Number = 1;
      
      public static const TERRAIN_PAINT_SOFTNESS_GRANULARITY:Number = 0.1;
      
      public static const TERRAIN_MANIP_STRENGTH_GRANULARITY:Number = 0.1;
      
      public static const TERRAIN_MANIP_HEIGHT_GRANULARITY:Number = 0.25;
      
      public static const TERRAIN_PAINT_ADAPTER_BACK_BUTTON_ELAPSED_TIME:Number = 500;
      
      public static const NAVPANEL_DROPDOWN_MENU_OFFSET:Margin = new Margin(-3,18,-3,7);
      
      public static const INVENTORY_DROPDOWN_MENU_OFFSET:Margin = new Margin(-3,18,-3,7);
      
      public static const LOT_NAME_ERROR_ICON_MARGIN:Margin = new Margin(4,-20,7,7);
      
      public static const LOT_NAME_ERROR_BG_MARGIN:Margin = new Margin(2,1,1,2);
      
      public static const CONTEXT_CONTROLLER_WIDTH:Number = 58;
      
      public static const CONTROLLER_FREE_ROTATE_SPEED:Number = 0.01;
      
      public static const CONTEXT_PLATFORM_TIMER_DELAY:Number = 300;
      
      public static const CONTEXT_PLATFORM_START_TIMER_DELAY:Number = 300;
      
      public static const CONTEXT_CONTROLS_TOOLTIP_FIXED_WIDTH:Number = 225;
      
      public static const CONTEXT_CONTROLS_TOOLTIP_MARGIN:Margin = new Margin(10,10,10,10);
      
      public static const CONTEXT_CONTROLS_TOOLTIP_INTERNAL_MARGIN:Margin = new Margin(4,4,4,4);
      
      public static const CONTEXT_CONTROLS_TOOLTIP_SCREEN_CLAMP_MARGIN:Margin = new Margin(10,10,10,10);
      
      public static const CONTEXT_UNIT_SELECT_DROPDOWN_MIN_FONT_SIZE:Number = 12;
      
      public static const SMALL_BUSINESS_PRIVACY_OPTIONS:Array = [];
      
      public static const STAIR_RAIL_OPTIONS:Array = [];
      
      SMALL_BUSINESS_PRIVACY_OPTIONS[ContextData.AREA_TYPE_BUSINESS_RESIDENTIAL] = {
         "name":KeysBB.BB_SMALL_BUSINESS_PANEL_RESIDENTIAL_LABEL,
         "tooltip":KeysBB.BB_SMALL_BUSINESS_RESIDENTIAL_AREA_TOOLTIP
      };
      SMALL_BUSINESS_PRIVACY_OPTIONS[ContextData.AREA_TYPE_BUSINESS_PUBLIC] = {
         "name":KeysBB.BB_SMALL_BUSINESS_PANEL_PUBLIC_LABEL,
         "tooltip":KeysBB.BB_SMALL_BUSINESS_PUBLIC_AREA_TOOLTIP
      };
      SMALL_BUSINESS_PRIVACY_OPTIONS[ContextData.AREA_TYPE_BUSINESS_EMPLOYEES_ONLY] = {
         "name":KeysBB.BB_SMALL_BUSINESS_PANEL_EMPLOYEES_ONLY_LABEL,
         "tooltip":KeysBB.BB_SMALL_BUSINESS_EMPLOYEES_ONLY_AREA_TOOLTIP
      };
      STAIR_RAIL_OPTIONS[ContextData.RAIL_TYPE_NONE] = {"name":KeysBB.BB_CONTEXT_STAIR_RAIL_NONE};
      STAIR_RAIL_OPTIONS[ContextData.RAIL_TYPE_LEFT] = {"name":KeysBB.BB_CONTEXT_STAIR_RAIL_LEFT};
      STAIR_RAIL_OPTIONS[ContextData.RAIL_TYPE_RIGHT] = {"name":KeysBB.BB_CONTEXT_STAIR_RAIL_RIGHT};
      STAIR_RAIL_OPTIONS[ContextData.RAIL_TYPE_DOUBLE] = {"name":KeysBB.BB_CONTEXT_STAIR_RAIL_DOUBLE};
      
      public function BBTunables()
      {
         super();
      }
   }
}

