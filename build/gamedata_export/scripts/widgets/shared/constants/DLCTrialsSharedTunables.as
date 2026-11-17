package widgets.shared.constants
{
   import olympus.core.widget.Margin;
   import olympus.localization.Keys;
   
   public class DLCTrialsSharedTunables
   {
      
      public static const TELEMETRY_CONTEXT_UNKNOWN:int = 0;
      
      public static const TELEMETRY_CONTEXT_TRIAL_DETAILS_MAIN_MENU:int = 1;
      
      public static const TELEMETRY_CONTEXT_TRIAL_DETAILS_TIMER:int = 2;
      
      public static const TELEMETRY_CONTEXT_TRIAL_GOALS_DETAILS:int = 1;
      
      public static const TELEMETRY_CONTEXT_TRIAL_GOALS_NEW_GAME:int = 2;
      
      public static const TELEMETRY_CONTEXT_TRIAL_GOALS_LOAD_GAME:int = 3;
      
      public static const TELEMETRY_CONTEXT_TRIAL_EXPIRED_TIMER:int = 1;
      
      public static const TELEMETRY_CONTEXT_TRIAL_EXPIRED_MAIN_MENU:int = 2;
      
      public static const TIMER_CONFIG:Object = {
         "leadingText":Keys.DLCTRIALS_TIMER_ENDS_IN,
         "states":[{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_DAYS_HOURS,
            "showLeadingText":true,
            "label":"normal"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_HOURS_MINUTES,
            "showLeadingText":true,
            "label":"24_hours"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_MINUTES_SECONDS,
            "showLeadingText":false,
            "label":"24_hours"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_ENDED,
            "showLeadingText":false,
            "label":"24_hours"
         }]
      };
      
      public static const TIMER_POP_OUT_CONFIG:Object = {
         "leadingText":Keys.DLCTRIALS_TIMER_ENDS_IN,
         "states":[{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_DAYS_HOURS,
            "showLeadingText":true,
            "label":"normal"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_HOURS_MINUTES,
            "showLeadingText":true,
            "label":"24_hours"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_REMAINING_MINUTES_SECONDS,
            "showLeadingText":false,
            "label":"24_hours"
         },{
            "locKey":Keys.DLCTRIALS_TIMER_ENDED,
            "showLeadingText":false,
            "label":"24_hours"
         }]
      };
      
      public static const TIMER_REFRESH_INTERVAL_MS:Number = 1000;
      
      public static const TIMER_MARGIN:Margin = Margin.TopRightBottomLeft(2,8,3,8);
      
      public static const TIMER_POPOUT_ANIMATION_DURATION:Number = 200;
      
      public static const TIMER_POPOUT_MARGIN:Margin = Margin.TopRightBottomLeft(2,28,2,6);
      
      public static const TIMER_POPOUT_LEFT_OFFSET:Number = 10;
      
      public function DLCTrialsSharedTunables()
      {
         super();
      }
   }
}

