package gamedata.Gameplay.SituationDisplay
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SituationGoal extends OlympusObject
   {
      
      public static const PREFERENCE_INVALID:int = -1;
      
      public static const PREFERENCE_DOES_NOT_CARE:int = 0;
      
      public static const PREFERENCE_LIKES:int = 1;
      
      public static const PREFERENCE_LOVES:int = 2;
      
      public static const DISPLAY_TYPE_DEFAULT:uint = 0;
      
      public static const DISPLAY_TYPE_NO_ITERATIONS:uint = 1;
      
      public static const INVALID_GOAL_ID:int = 0;
      
      public static const ON_CLICK_ACTION_PDP:int = 0;
      
      public static const ON_CLICK_ACTION_TUTORIAL:int = 1;
      
      public var goal_id:uint;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var goal_name:LocKey = new LocKey();
      
      public var max_iterations:int;
      
      public var current_iterations:int;
      
      public var goal_tooltip:LocKey = new LocKey();
      
      public var audio_sting:ResourceKey = new ResourceKey();
      
      public var display_type:uint;
      
      public var highlight_goal:Boolean;
      
      public var goal_preference:int;
      
      public var goal_preference_tooltip:LocKey;
      
      public var secondary_icon_info:IconInfo = new IconInfo();
      
      public var expiration_time:String = null;
      
      public var tutorial_tip_group_guid:String;
      
      public var is_mandatory:Boolean = true;
      
      public var is_complete:Boolean = false;
      
      public var ui_element:String = "0";
      
      public var mtx_bundle_id:String = null;
      
      public var goal_guid:uint;
      
      public function SituationGoal(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.goal_tooltip.IsValid())
         {
            this.goal_tooltip = null;
         }
         if(param1["icon_info"] == null)
         {
            this.icon_info = null;
         }
         if(!("goal_preference" in param1))
         {
            this.goal_preference = PREFERENCE_INVALID;
         }
         if("goal_preference_tooltip" in param1)
         {
            this.goal_preference_tooltip = new LocKey(param1.goal_preference_tooltip);
         }
         if(param1["secondary_icon_info"] == null)
         {
            this.secondary_icon_info = null;
         }
      }
   }
}

