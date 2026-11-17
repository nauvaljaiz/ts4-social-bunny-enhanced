package widgets.Gameplay.SimInfoHUD.constants
{
   import flash.geom.Point;
   import olympus.core.widget.Margin;
   import olympus.motion.TweenParams;
   
   public final class SimInfoSummaryPanelTunables
   {
      
      public static const SUMMARY_PANEL_HEIGHT_SETTINGS:String = "SummaryPanelHeightSetting";
      
      public static const COMPLETED_FRAME_LABEL:String = "completed";
      
      public static const RECENTLY_COMPLETE_FRAME_LABEL:String = "recently_completed";
      
      public static const INCOMPLETE_FRAME_LABEL:String = "incomplete";
      
      public static const DEFAULT_PANEL_HEIGHT_PADDING:Number = 130;
      
      public static const SIM_NAME_MIN_FONT_SIZE:int = 10;
      
      public static const CONTENT_PADDING:Number = 2;
      
      public static const LIFE_SKILL_TOOLTIP_MARGIN:Margin = new Margin(10);
      
      public static const LIFE_SKILL_TOOLTIP_TEXT_OFFSET:Number = 4;
      
      public static const RANKED_STAT_ICON_CROSS_FADE_TWEEN_PARAM:TweenParams = TweenParams.TweenParam().Duration(500).Delay(500);
      
      public static const FACTION_REP_CELLVIEW_MARGIN:* = new Margin(2,0,2,4);
      
      public static const MIN_NUMBER_OF_ARROW_LOOPS:uint = 3;
      
      public static const FIRST_ORDER_PRIMARY_COLOR:uint = 11542307;
      
      public static const RESISTANCE_PRIMARY_COLOR:uint = 44484;
      
      public static const SCOUNDREL_PRIMARY_COLOR:uint = 7100187;
      
      public static const SUMMARY_PANEL_LIFESKILLS:uint = 0;
      
      public static const SUMMARY_PANEL_FAME:uint = 1;
      
      public static const SUMMARY_PANEL_FACTIONREP:uint = 2;
      
      public static const SUMMARY_PANEL_RESOLUTIONS:uint = 3;
      
      public static const SUMMARY_PANEL_TRAITS:uint = 4;
      
      public static const SUMMARY_PANEL_DEGREES:uint = 5;
      
      public static const SUMMARY_PANEL_ROBOT:uint = 6;
      
      public static const SUMMARY_PANEL_CIVICPOLICIES:uint = 7;
      
      public static const SUMMARY_PANEL_LIFESTYLES:uint = 8;
      
      public static const SUMMARY_PANEL_PREFERENCES:uint = 9;
      
      public static const SUMMARY_PANEL_MILESTONES:uint = 10;
      
      public static const SUMMARY_PANEL_RELATIONSHIP_PREFERENCES:uint = 11;
      
      public static const SUMMARY_PANEL_GHOST_POWERS:uint = 12;
      
      public static const SUMMARY_PANEL_LUCK:uint = 13;
      
      public static const SUMMARY_PANEL_BALANCE_SYSTEM:uint = 14;
      
      public static const FACTION_REP_INCREMENT_X_OFFSET:Number = 4;
      
      public static const FACTION_REP_INCREMENT_Y_OFFSET:Number = 50;
      
      public static const FACTION_REP_INCREMENT_CLASS_NAME:String = "widgets.Gameplay.SimInfoHUD.FactionRepPanel.IncrementClip";
      
      public static const LIFESTYLES_SETTINGS_SEEN_KEY:String = "lifestyles_seen";
      
      public static const LIFESTYLES_TOOLTIP_WIDTH:Number = 350;
      
      public static const SIMOLOGY_SCROLL_SPEED:Number = 30;
      
      public static const PREFERENCES_PANEL_GROUP_COLUMNS:Number = 1;
      
      public static const PREFERENCES_PANEL_CATEGORY_COLUMNS:Number = 5;
      
      public static const PREFERENCES_PANEL_CONTENT_PADDING:Number = 4;
      
      public static const PREFERENCES_PANEL_CELL_MARGIN:Margin = new Margin(0,4,1,4);
      
      public static const RELATIONSHIP_PREFERENCES_PANEL_CONTENT_PADDING:Number = 4;
      
      public static const CONSOLE_HEIGHT_SCROLL_UP_AMOUNT:Number = 73;
      
      public static const CONSOLE_HEIGHT_SCROLL_DOWN_AMOUNT:Number = 73;
      
      public static const PANEL_PERK_POINT_FLYAWAY_OFFSET:Point = new Point(5,-20);
      
      public static const GHOST_MANA_PROGRESS_BAR_MIN_VAL:int = 0;
      
      public static const GHOST_MANA_PROGRESS_BAR_MAX_VAL:int = 100;
      
      public static const GHOST_MANA_PROGRESS_BAR_END_FRAME:int = 200;
      
      public static const CHILD_REWARD_TRAIT_CELL_VIEW_WIDTH:Number = 168;
      
      public function SimInfoSummaryPanelTunables()
      {
         super();
      }
   }
}

