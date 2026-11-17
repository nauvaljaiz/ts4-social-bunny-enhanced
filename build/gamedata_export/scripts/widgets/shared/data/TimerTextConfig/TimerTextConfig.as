package widgets.shared.data.TimerTextConfig
{
   import flash.display.MovieClip;
   import olympus.core.OlympusObject;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.utils.DateUtils;
   
   public class TimerTextConfig extends OlympusObject
   {
      
      public static const DISPLAY_TYPE_ERROR:int = -1;
      
      public static const DISPLAY_TYPE_DAYS_HOURS:int = 0;
      
      public static const DISPLAY_TYPE_HOURS_MINUTES:int = 1;
      
      public static const DISPLAY_TYPE_MINUTES_SECONDS:int = 2;
      
      public static const DISPLAY_TYPE_ENDED:int = 3;
      
      protected static const DEFAULT_CONFIG:* = {
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
            "showLeadingText":true,
            "label":"normal"
         },{
            "locKey":Keys.GENERIC_TIMER_ENDED,
            "showLeadingText":false,
            "label":"normal"
         }]
      };
      
      protected static var sGenericConfig:TimerTextConfig = null;
      
      public var leadingText:LocKey;
      
      public var states:Array = [TimerTextState];
      
      public function TimerTextConfig(param1:Object = null)
      {
         super(param1);
         FixupArray(this.states);
      }
      
      public static function get GenericConfig() : TimerTextConfig
      {
         if(sGenericConfig == null)
         {
            sGenericConfig = new TimerTextConfig(DEFAULT_CONFIG);
         }
         return sGenericConfig;
      }
      
      public function ProcessTime(param1:Date) : Object
      {
         var _loc2_:String = null;
         var _loc3_:int = DISPLAY_TYPE_ERROR;
         if(param1 == null)
         {
            return {
               "state":_loc3_,
               "text":_loc2_
            };
         }
         var _loc4_:Object = DateUtils.GetTimeRemaining(param1);
         if(_loc4_.days > 0)
         {
            _loc3_ = DISPLAY_TYPE_DAYS_HOURS;
            _loc2_ = this.states[_loc3_].locKey.toString(_loc4_.days,_loc4_.hours);
         }
         else if(_loc4_.hours > 0)
         {
            _loc3_ = DISPLAY_TYPE_HOURS_MINUTES;
            _loc2_ = this.states[_loc3_].locKey.toString(_loc4_.hours,_loc4_.minutes);
         }
         else if(_loc4_.minutes >= 0 && _loc4_.seconds >= 0)
         {
            _loc3_ = DISPLAY_TYPE_MINUTES_SECONDS;
            _loc2_ = this.states[_loc3_].locKey.toString(_loc4_.minutes,_loc4_.seconds);
         }
         else
         {
            _loc3_ = DISPLAY_TYPE_ENDED;
            _loc2_ = this.states[_loc3_].locKey.toString();
         }
         if(Boolean(this.leadingText) && Boolean(this.states[_loc3_].showLeadingText))
         {
            _loc2_ = Keys.GENERIC_SPACE.toString(this.leadingText.toString(),_loc2_);
         }
         return {
            "state":_loc3_,
            "text":_loc2_
         };
      }
      
      public function ApplyStateLabel(param1:int, param2:MovieClip) : void
      {
         if(this.states[param1].label)
         {
            if(this.states[param1].label != param2.currentFrameLabel)
            {
               param2.gotoAndPlay(this.states[param1].label);
            }
         }
      }
   }
}

