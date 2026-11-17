package widgets.CAS.constants
{
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.Species;
   import olympus.core.widget.Margin;
   
   public final class CASTunables
   {
      
      public static const SWATCH_PANEL_LOOKVARIANT_NUM_COLS:int = 8;
      
      public static const SWATCH_PANEL_OPTIONS_NUM_COLS:int = 9;
      
      public static const SWATCH_PANEL_BACKGROUND_PADDING:Number = 6;
      
      public static const SWATCH_PANEL_SCROLLING_LIST_MARGINS:Margin = new Margin(0,0,0,0);
      
      public static const SWATCH_PANEL_SCROLLING_LIST_ITEMPADDING:Margin = new Margin(0,0,0,0);
      
      public static const SWATCH_PANEL_SCROLLING_LIST_WIDTH:Number = 250;
      
      public static const SWATCH_PANEL_LAYER_BUTTONS_Y_OFFSET:Number = -1;
      
      public static const BODY_TYPE_PANEL_SCROLLING_LIST_MARGINS:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const BODY_TYPE_PANEL_SCROLLING_LIST_ITEMPADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const BODY_TYPE_PANEL_OPTIONS_NUM_COLS:int = 6;
      
      public static const BODY_TYPE_BACKGROUND_PADDING:Number = 6;
      
      public static const BODY_TYPE_CONTROLLER_PROMPT_PADDING:Number = 8;
      
      public static const BODY_TYPE_CENTERING_ADJUSTMENT:Number = 14;
      
      public static const DECORATION_BANNER_TITLE_FONT:String = "#0033FF";
      
      public static const DECORATION_BANNER_OUTFIT_FONT:String = "#009966";
      
      public static const GENDER_BUTTONS_OPTION_OFFSET:Number = 7;
      
      public static const GENDER_OPTION_VALUE_OPTION_PADDING:Number = 10;
      
      public static const GENDER_OPTION_VALUE_CELL_VIEW_MARGIN:Margin = new Margin(-20,20,0,0);
      
      public static const GENDER_OPTION_CLIP_GRID_Y_OFFSET:Number = 10;
      
      public static const GENDER_OPTION_CLIP_TOOLTIP_PADDING:Number = 23;
      
      public static const GENDER_OPTION_CLIP_TOOLTIP_X_OFFSET:Number = 3;
      
      public static const AGE_CELL_VIEW_SIM_MARGIN:Margin = new Margin(10.5,-12.4,0,2.9);
      
      public static const AGE_PANE_GRID_BG_SIM_OFFSET:Number = 14;
      
      public static const AGE_CELL_VIEW_PET_MARGIN:Margin = new Margin(10.5,15.8,0,31.5);
      
      public static const AGE_PANE_GRID_BG_PET_OFFSET:Number = 7;
      
      public static const BREED_VARIANT_LIST_MAX_WIDTH:Number = 94;
      
      public static const BREED_VARIANT_LIST_CELL_MARGIN:Margin = new Margin(0,1,0,0);
      
      public static const GAMEPAD_SIM_ROTATE_SPEED_PS4:Number = 2;
      
      public static const GAMEPAD_SIM_ROTATE_SPEED_XB1:Number = 6;
      
      public static const GAMEPAD_SIM_ZOOM_SPEED_PS4:Number = 1.2;
      
      public static const GAMEPAD_SIM_ZOOM_SPEED_XB1:Number = 1.2;
      
      public static const GAMEPAD_RELATIVE_CURSOR_BOUNDS_SIZE_X:Number = 0.4;
      
      public static const GAMEPAD_RELATIVE_CURSOR_BOUNDS_SIZE_Y:Number = 0.9;
      
      public static const COLOR_SLIDERS_VARIATION_GRID_SCROLLLIST_WIDTH:Number = 100;
      
      public static const COLOR_SLIDERS_VARIATION_GRID_SCROLLLIST_MAX_HEIGHT:Number = 100;
      
      public static const COLOR_SLIDERS_VARIATION_GRID_SLIDERS_BLOCK_MARGIN:Margin = new Margin(25,0,-20,0);
      
      public static const COLOR_SLIDERS_VARIATION_GRID_SCROLLBAR_PADDING:Number = 4;
      
      public static const SIM_ATTACH_PANEL_LEGEND_OFFSET:Number = 20;
      
      public static const SIM_ATTACH_OPTS_HUMAN:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.02},
            "screenOffset":{"x":0}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.02},
            "screenOffset":{"x":0}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-260}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-260}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-184}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-238}
         }
      };
      
      public static const SIM_ATTACH_OPTS_DOG:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.2},
            "screenOffset":{"x":50}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.3},
            "screenOffset":{"x":-200}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.2},
            "screenOffset":{"x":-200}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-320}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-373}
         }
      };
      
      public static const SIM_ATTACH_OPTS_SMALLDOG:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.075},
            "screenOffset":{"x":0}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.15},
            "screenOffset":{"x":-200}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.09},
            "screenOffset":{"x":-260}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-225}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-278}
         }
      };
      
      public static const SIM_ATTACH_OPTS_PUPPY:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.075},
            "screenOffset":{"x":0}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.15},
            "screenOffset":{"x":-200}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.09},
            "screenOffset":{"x":-260}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-225}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-278}
         }
      };
      
      public static const SIM_ATTACH_OPTS_CAT:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.075},
            "screenOffset":{"x":0}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.15},
            "screenOffset":{"x":-200}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.09},
            "screenOffset":{"x":-260}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-225}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-278}
         }
      };
      
      public static const SIM_ATTACH_OPTS_HORSE:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.12},
            "screenOffset":{"x":120}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.3},
            "screenOffset":{"x":120}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.7},
            "screenOffset":{"x":-280}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.6},
            "screenOffset":{"x":-260}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-235}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-288}
         }
      };
      
      public static const SIM_ATTACH_OPTS_FOAL:Object = {
         "head_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "body_menu":{
            "attachPoint":"b__ROOT__",
            "viewOffset":{"x":0.09},
            "screenOffset":{"x":50}
         },
         "bodymod_panel":{
            "viewOffset":{"x":-0.5},
            "screenOffset":{"x":-200}
         },
         "detailmode_panel":{
            "viewOffset":{"x":-0.4},
            "screenOffset":{"x":-200}
         },
         "ghost_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-235}
         },
         "wing_toggle":{
            "viewOffset":{"x":-0.075},
            "screenOffset":{"x":-288}
         }
      };
      
      public function CASTunables()
      {
         super();
      }
      
      public static function GetSimAttachOpts(param1:uint, param2:uint) : Object
      {
         if(param1 == Species.TYPE_DOG)
         {
            return SimAgeTypes.IsPuppyOrKitten(param2) ? SIM_ATTACH_OPTS_PUPPY : SIM_ATTACH_OPTS_DOG;
         }
         if(param1 == Species.TYPE_SMALLDOG)
         {
            return SimAgeTypes.IsPuppyOrKitten(param2) ? SIM_ATTACH_OPTS_PUPPY : SIM_ATTACH_OPTS_SMALLDOG;
         }
         if(param1 == Species.TYPE_CAT)
         {
            return SIM_ATTACH_OPTS_CAT;
         }
         if(param1 == Species.TYPE_HORSE)
         {
            return SimAgeTypes.IsChild(param2) ? SIM_ATTACH_OPTS_FOAL : SIM_ATTACH_OPTS_HORSE;
         }
         return SIM_ATTACH_OPTS_HUMAN;
      }
   }
}

