package gamedata.Gameplay.SituationHUD
{
   import gamedata.Gameplay.SituationDisplay.SituationJobAssignment;
   import gamedata.Gameplay.SituationDisplay.SituationLevelUpdate;
   import gamedata.Gameplay.SituationDisplay.SituationMeterData;
   import gamedata.shared.GameClockTime;
   import gamedata.shared.ISituationReward;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SituationStart extends OlympusObject implements ISituationReward
   {
      
      public static const SITUATION_USERFACING_TYPE_SOCIAL_EVENT:int = 0;
      
      public static const SITUATION_USERFACING_TYPE_CAREER_EVENT:int = 1;
      
      public static const SITUATION_USERFACING_TYPE_VET_EVENT:int = 2;
      
      public static const SITUATION_USERFACING_TYPE_HOLIDAY_EVENT:int = 3;
      
      public static const SITUATION_USERFACING_TYPE_ACTING_EVENT:int = 4;
      
      public static const SITUATION_USERFACING_TYPE_MOTHER_PLANT_EVENT:int = 5;
      
      public static const SITUATION_USERFACING_TYPE_UNIVERSITY_HOUSING_KICK_OUT_EVENT:* = 6;
      
      public static const SITUATION_USERFACING_TYPE_PIVOTAL_MOMENT:* = 7;
      
      public static const SITUATION_DISPLAY_FLAG_SHOW_TIMER:uint = 1 << 0;
      
      public static const SITUATION_DISPLAY_FLAG_SHOW_GOALS:uint = 1 << 1;
      
      public static const SITUATION_DISPLAY_FLAG_SHOW_SCORE_BAR:uint = 1 << 2;
      
      public static const SITUATION_DISPLAY_FLAG_SHOW_END_TIME:uint = 1 << 3;
      
      public static const SITUATION_DISPLAY_FLAG_STAT_BASED:uint = 1 << 4;
      
      public static const SITUATION_DISPLAY_FLAG_SHOW_CANCEL:uint = 1 << 5;
      
      public static const DISPLAY_TYPE_NORMAL:int = 0;
      
      public static const DISPLAY_TYPE_VET:int = 1;
      
      public static const DISPLAY_TYPE_SIM:int = 2;
      
      public static const DISPLAY_TYPE_SCENARIO:int = 3;
      
      public static const DISPLAY_TYPE_ACTIVITY:int = 4;
      
      public static const DISPLAY_TYPE_PIVOTAL_MOMENT:int = 5;
      
      public static const DISPLAY_TYPE_EVICTION:int = 6;
      
      public static const DISPLAY_TYPE_ROMANCE:int = 7;
      
      public static const DISPLAY_TYPE_LIVE_EVENT:int = 8;
      
      public static const DISPLAY_TYPE_GETAWAY:int = 9;
      
      public static const DISPLAY_TYPE_EV008:int = 10;
      
      public var score:uint;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var end_time:GameClockTime = new GameClockTime();
      
      public var current_level:SituationLevelUpdate = new SituationLevelUpdate();
      
      public var sim_jobs:Array = [SituationJobAssignment];
      
      public var start_time:GameClockTime = new GameClockTime();
      
      public var start_audio_sting:ResourceKey = new ResourceKey();
      
      public var scoring_enabled:Boolean = true;
      
      public var has_stayed_late:Boolean;
      
      public var meter_data:Array = [SituationMeterData];
      
      public var display_type:int;
      
      public var linked_sim_id:String;
      
      public var user_facing_type:int;
      
      public var situation_id:String;
      
      public var allow_non_prestige_events:Boolean;
      
      public var display_priority:uint;
      
      public var background_audio:ResourceKey = new ResourceKey();
      
      public var situation_display_flags:uint = 0;
      
      public var situation_display_style:int = 0;
      
      public var live_event_id:String;
      
      public var situation_end_time_string:LocKey = new LocKey();
      
      public var cancel_tooltip_override:LocKey = new LocKey();
      
      public var situation_guid:uint;
      
      public var sort_id:uint;
      
      public var first_time:Boolean;
      
      public var is_new_situation:Boolean;
      
      public var from_load:Boolean;
      
      public var participants:Array;
      
      public var sim_ids:Array;
      
      public var level_data:Array;
      
      public var situation_display_description:LocKey = new LocKey();
      
      public var tutorial_id:int;
      
      public var pivotal_moment_guid:uint;
      
      public var reward_description:LocKey = new LocKey();
      
      public var current_time:GameClockTime = new GameClockTime();
      
      public function SituationStart(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function GetDefaultPriority(param1:Object) : int
      {
         switch(param1.display_type)
         {
            case DISPLAY_TYPE_LIVE_EVENT:
               return 1 + param1.sort_id;
            case SituationStart.DISPLAY_TYPE_SIM:
               return 2;
            case SituationStart.DISPLAY_TYPE_ACTIVITY:
               return 3;
            case SituationStart.DISPLAY_TYPE_NORMAL:
               return 4;
            case SituationStart.DISPLAY_TYPE_VET:
               return 5;
            case SituationStart.DISPLAY_TYPE_PIVOTAL_MOMENT:
               return 6 + param1.sort_id;
            default:
               return 0;
         }
      }
      
      public static function SituationSortingFunction(param1:Object, param2:Object) : Number
      {
         if(GetDefaultPriority(param1) < GetDefaultPriority(param2))
         {
            return -1;
         }
         return 1;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("end_time" in param1))
         {
            this.end_time = null;
         }
         if(!param1 || !("start_time" in param1))
         {
            this.start_time = null;
         }
         if(!param1 || !("current_time" in param1))
         {
            this.current_time = null;
         }
         if(!param1 || !("display_type" in param1))
         {
            this.display_type = 0;
         }
         if(!param1 || !("background_audio" in param1))
         {
            this.background_audio = null;
         }
         if(!param1 || !("situation_guid" in param1))
         {
            this.situation_guid = null;
         }
         if(!this.situation_end_time_string.IsValid())
         {
            this.situation_end_time_string = null;
         }
         if(!this.cancel_tooltip_override.IsValid())
         {
            this.cancel_tooltip_override = null;
         }
         if(!this.situation_display_description.IsValid())
         {
            this.situation_display_description = null;
         }
         if(!param1 || !("tutorial_id" in param1))
         {
            this.tutorial_id = 0;
         }
         if(!param1 || !("sort_id" in param1))
         {
            this.sort_id = 0;
         }
         FixupArray(this.sim_jobs);
         FixupArray(this.meter_data);
      }
      
      public function IsParticipant(param1:String) : Boolean
      {
         if(this.GetSimJob(param1))
         {
            return true;
         }
         return false;
      }
      
      public function GetSimJob(param1:String) : SituationJobAssignment
      {
         var _loc2_:SituationJobAssignment = null;
         for each(_loc2_ in this.sim_jobs)
         {
            if(_loc2_.sim_id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function IsCareerEventSituationType() : Boolean
      {
         switch(this.user_facing_type)
         {
            case SituationStart.SITUATION_USERFACING_TYPE_CAREER_EVENT:
            case SituationStart.SITUATION_USERFACING_TYPE_ACTING_EVENT:
               return true;
            default:
               return false;
         }
      }
      
      public function HasDisplayFlag(param1:uint) : uint
      {
         return this.situation_display_flags & param1;
      }
      
      public function GetSituationDisplayDescription() : LocKey
      {
         return this.situation_display_description;
      }
      
      public function GetTutorialID() : int
      {
         return this.tutorial_id;
      }
      
      public function GetTitle() : String
      {
         return this.icon_info.GetName();
      }
      
      public function GetDescription() : String
      {
         return this.icon_info.GetDesc();
      }
      
      public function GetRewardIcon() : ResourceKey
      {
         return this.current_level.level_icon.icon;
      }
      
      public function GetRewardTitle() : String
      {
         return this.current_level.level_icon.GetName();
      }
      
      public function GetRewardDescription() : String
      {
         if(Boolean(this.reward_description) && this.reward_description.IsValid())
         {
            return this.reward_description.toString();
         }
         if(Boolean(this.live_event_id) && this.live_event_id != "0")
         {
            return KeysGP.SITUATION_PIVOTAL_MOMENT_REWARD_LIVE_EVENT_QUEST_EXPLANATION.toString();
         }
         return KeysGP.SITUATION_PIVOTAL_MOMENT_REWARD_EXPLANATION.toString();
      }
      
      public function GetRewardTooltip() : String
      {
         return this.current_level.level_icon.tooltip.toString();
      }
      
      public function GetSituationDisplayStyleId() : int
      {
         return this.situation_display_style;
      }
   }
}

