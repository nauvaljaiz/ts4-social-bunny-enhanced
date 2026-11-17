package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.core.widget.Margin;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SituationData extends OlympusObject
   {
      
      public static const CATEGORY_DEFAULT:* = 0;
      
      public static const CATEGORY_DEBUG:* = 1;
      
      public static const CATEGORY_WEDDING:* = 2;
      
      public static const CATEGORY_DATE:* = 3;
      
      public static const CATEGORY_HANGOUT:* = 4;
      
      public static const CATEGORY_BLIND_DATE:* = 5;
      
      public static const CATEGORY_FUNERAL:* = 6;
      
      public static const CATEGORY_GETAWAY:* = 7;
      
      public static const MEDAL_NO_ATTEMPTS:int = -1;
      
      public static const MEDAL_UNEARNED:int = 0;
      
      public static const MEDAL_BRONZE:int = 1;
      
      public static const MEDAL_SILVER:int = 2;
      
      public static const MEDAL_GOLD:int = 3;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var cost:uint;
      
      public var max_participants:uint;
      
      public var rewards:Array = [SituationLevelReward];
      
      public var jobs:Array = [SituationJobData];
      
      public var available_activity_ids:Array = [String];
      
      public var unavailable_activity_ids:Array = [String];
      
      public var required_activity_ids:Array = [String];
      
      public var randomizable_activity_ids:Array = [String];
      
      public var num_randomized:int = 0;
      
      public var style_data:SituationStyleData;
      
      public var minimum_activities:int = 0;
      
      public var activities_disabled_tooltip:LocKey = new LocKey();
      
      public var challenge_reward_override:Array = [LocKey];
      
      public var activity_goal_situation:Boolean = false;
      
      public var jobs_per_row:Number;
      
      public var job_cell_padding:Margin;
      
      public var role_updates_activity_preferences:Array = [String];
      
      public var sim_filter_requesting_sim_override:String;
      
      public var getaway_schedule:Object;
      
      public var max_duration_nights:uint;
      
      public var default_duration_nights:uint;
      
      public var category:uint;
      
      public var id:String;
      
      public var name:String;
      
      public var locked:Boolean;
      
      public var isNewItem:Boolean;
      
      public var medal:int;
      
      public var medal_icon_override:ResourceKey;
      
      public var tooltip:LocKey;
      
      public var isScoring:Boolean;
      
      public var isScoringAllowed:Boolean;
      
      public var scoringDisabledReason:LocKey;
      
      public var scoringLockReason:LocKey;
      
      public var editing:Boolean = false;
      
      public function SituationData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.rewards);
         FixupArray(this.jobs);
         FixupArray(this.available_activity_ids);
         FixupArray(this.unavailable_activity_ids);
         FixupArray(this.required_activity_ids);
         FixupArray(this.randomizable_activity_ids);
         FixupArray(this.challenge_reward_override);
         if("style_data" in param1)
         {
            this.style_data = new SituationStyleData(param1.style_data);
         }
         if("job_cell_padding" in param1)
         {
            this.job_cell_padding = new Margin(param1.job_cell_padding[0],param1.job_cell_padding[1],param1.job_cell_padding[2],param1.job_cell_padding[3]);
         }
      }
      
      public function HasActivities() : Boolean
      {
         return this.available_activity_ids.length > 0 || this.required_activity_ids.length > 0;
      }
   }
}

