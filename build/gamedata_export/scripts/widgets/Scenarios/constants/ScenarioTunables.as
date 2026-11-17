package widgets.Scenarios.constants
{
   import flash.geom.Point;
   import olympus.core.widget.Margin;
   import olympus.localization.Keys;
   import scaleform.gfx.TextFieldEx;
   import widgets.shared.data.Scenarios.ScenarioDisplayFilterData;
   
   public final class ScenarioTunables
   {
      
      public static const SCENARIO_SETTING_NO_SETTING:int = 0;
      
      public static const SCENARIO_SETTING_STARTS_FROM_CAS:int = 1 << 0;
      
      public static const SCENARIO_SETTING_RESET_SCENARIO:int = 1 << 1;
      
      public static const SCENARIO_SETTING_SHOW_REQUIREMENTS:int = 1 << 2;
      
      public static const SETTINGS_SEEN_KEY:String = "scenarios_seen";
      
      public static const SETTINGS_STARTED_KEY:String = "scenarios_started";
      
      public static const REFRESH_SCENARIO_BUTTON_ALERT_MESSAGE:String = "RefreshScenarioButtonAlert";
      
      public static const SCENARIO_CELL_CLICK_EVENT:String = "ScenarioCellClick";
      
      public static const SCENARIO_LESSON_ID:String = "273177";
      
      public static const SCENARIOS_DISPLAY_PANEL_TITLE_TOP_MARGIN:Number = 25;
      
      public static const SCENARIOS_DISPLAY_PANEL_ELEMENTS_DISTANCE:Number = 55;
      
      public static const SCENARIOS_DISPLAY_PANEL_STICK_SCROLL_SPEED:Number = 50;
      
      public static const SCENARIOS_DISPLAY_PANEL_MOUSE_WHEEL_SCROLL_SPEED:Number = 50;
      
      public static const SCENARIOS_DISPLAY_PANEL_AUTO_SCROLL_MARGIN:Number = 100;
      
      public static const SCENARIOS_DISPLAY_PANEL_SCROLL_LIST_MARGIN:Margin = Margin.TopRightBottomLeft(0,18,20,30);
      
      public static const SCENARIOS_DISPLAY_PANEL_CONTENT_MARGIN:Margin = Margin.TopRightBottomLeft(0,10,20,15);
      
      public static const SCENARIOS_DISPLAY_PANEL_BUTTON_CLOSE_MARGIN:Margin = Margin.TopRightBottomLeft(10,10,0,0);
      
      public static const SCENARIOS_PANEL_FILTER_DATA:ScenarioDisplayFilterData = new ScenarioDisplayFilterData(0,0,0,false);
      
      public static const TIMER_CONFIG:Object = {"states":[{
         "locKey":Keys.DLCTRIALS_TIMER_REMAINING_DAYS_HOURS,
         "showLeadingText":false,
         "label":"normal"
      },{
         "locKey":Keys.DLCTRIALS_TIMER_REMAINING_HOURS_MINUTES,
         "showLeadingText":false,
         "label":"24_hours"
      },{
         "locKey":Keys.DLCTRIALS_TIMER_REMAINING_MINUTES_SECONDS,
         "showLeadingText":false,
         "label":"24_hours"
      },{
         "locKey":Keys.DLCTRIALS_TIMER_ENDED,
         "showLeadingText":false,
         "label":"24_hours"
      }]};
      
      public static const SCENARIO_CARD_CELL_PADDING:Margin = Margin.TopRightBottomLeft(4,2,4,2);
      
      public static const SCENARIO_CARD_LIST_ITEM_PADDING:Margin = Margin.TopRightBottomLeft(2,2,2,2);
      
      public static const SCENARIO_CARD_BACK_CONTENT_MARGIN:Margin = Margin.TopRightBottomLeft(10,0,0,20);
      
      public static const SCENARIO_CARD_GRID_TO_TITLE_SPACING:Number = 15;
      
      public static const SCENARIO_CARD_BACK_BOTTOM_ADDED_SPACING:Number = 15;
      
      public static const SCENARIO_CARD_MOUSE_WHEEL_SCROLL_SPEED:Number = 50;
      
      public static const SCENARIO_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,2,2,2);
      
      public static const SCENARIO_LIST_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const SCENARIO_LIST_TAGLINE_LIMITED_TIME_TEXT_MARGIN:Margin = Margin.TopRightBottomLeft(2,0,7,0);
      
      public static const SCENARIO_CARD_GROUP_TITLE_OFFSET:Number = 5;
      
      public static const SCENARIO_CARD_GROUP_TITLE_PREFERRED_FONT_SIZE:Number = 20;
      
      public static const SCENARIO_CARD_GROUP_MARGIN:Margin = Margin.TopRightBottomLeft(0,0,10,0);
      
      public static const INFO_PAGE_AUTO_SCROLL_MARGIN:Number = 100;
      
      public static const SCENARIO_DETAILS_GRID_CELL_PADDING:Margin = Margin.TopRightBottomLeft(0,10,0,0);
      
      public static const SCENARIO_DETAILS_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const SCENARIO_LOAD_GRID_CELL_PADDING:Margin = Margin.TopRightBottomLeft(0,10,0,0);
      
      public static const SCENARIO_LOAD_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const SCENARIO_LOAD_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,2,2,2);
      
      public static const SCENARIO_LOAD_NEW_SAVE_ONLY_BUTTON_TO_BACKGROUND_SPACING:Number = 8;
      
      public static const SCENARIO_GOAL_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,2,2,2);
      
      public static const SCENARIO_LIVE_PANEL_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const SCENARIO_GOAL_HEADER_ICON_TEXT_SPACING:Number = 4;
      
      public static const SCENARIO_GOAL_HEADER_TEXT_RIGHT_PADDING:Number = 3;
      
      public static const SCENARIO_GOAL_HEADER_TEXT_PADDING:Number = 4;
      
      public static const SCENARIO_REQUIREMENT_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,2,2,2);
      
      public static const SCENARIO_REQUIREMENTS_PANEL_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const SCENARIO_REQUIREMENTS_LIST_TO_LIST_BACKGROUND_SPACING:Number = 5;
      
      public static const SCENARIO_REQUIREMENTS_LIST_BACKGROUND_TO_OVERALL_BACKGROUND_SPACING:Number = 7;
      
      public static const SCENARIO_REQUIREMENTS_LIST_BACKGROUND_ARROW_OFFSET:Number = 4;
      
      public static const SCENARIO_REQUIREMENTS_SPACING_FROM_CONTROL_PANEL:Number = 6;
      
      public static const SCENARIO_REQUIREMENTS_LIST_MAX_HEIGHT:Number = 200;
      
      public static const SCENARIO_REQUIREMENTS_ANIMATION_REG_POINT:Point = new Point(0.8,0);
      
      public static const LIMITED_TIME_PILL_MARGIN:Margin = Margin.TopRightBottomLeft(2,8,3,8);
      
      public static const LIMITED_TIME_ICON_FROM_TEXT_SPACING:Number = 2;
      
      public static const GAMEPAD_SCROLL_MARGIN:Number = 100;
      
      public static const CONSOLE_SCENARIO_SLIDER_SPEED:Number = 10;
      
      public static const SCENARIO_OUTCOME_DIALOG_VERTICAL_ALIGNMENT:String = TextFieldEx.VALIGN_TOP;
      
      public function ScenarioTunables()
      {
         super();
      }
   }
}

