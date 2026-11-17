package widgets.shared.constants
{
   import olympus.localization.Keys;
   import widgets.shared.data.TimerTextConfig.TimerTextConfig;
   
   public final class IncentiveAffordanceDataTunables
   {
      
      public static const TIMER_TEXT_CONFIGS:Object = {"default":new TimerTextConfig({
         "leadingText":Keys.GENERIC_TIMER_ENDS_IN,
         "states":[{
            "locKey":Keys.GENERIC_TIMER_REMAINING_DAYS_HOURS,
            "showLeadingText":true,
            "label":"normal"
         },{
            "locKey":Keys.GENERIC_TIMER_REMAINING_HOURS_MINUTES,
            "showLeadingText":true,
            "label":"normal"
         },{
            "locKey":Keys.GENERIC_TIMER_REMAINING_MINUTES_SECONDS,
            "showLeadingText":false,
            "label":"normal"
         },{
            "locKey":Keys.GENERIC_TIMER_ENDED,
            "showLeadingText":false,
            "label":"normal"
         }]
      })};
      
      public function IncentiveAffordanceDataTunables()
      {
         super();
      }
   }
}

