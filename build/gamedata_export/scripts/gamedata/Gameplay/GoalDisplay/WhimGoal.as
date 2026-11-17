package gamedata.Gameplay.GoalDisplay
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class WhimGoal extends OlympusObject
   {
      
      public var whim_guid64:String;
      
      public var whim_name:LocKey = new LocKey();
      
      public var whim_score:int;
      
      public var whim_noncancel:Boolean;
      
      public var whim_icon_key:ResourceKey = new ResourceKey();
      
      public var whim_goal_count:int;
      
      public var whim_current_count:int;
      
      public var whim_target_sim:String;
      
      public var whim_tooltip:LocKey = new LocKey();
      
      public var whim_tooltip_reason:LocKey = new LocKey();
      
      public var whim_locked:Boolean;
      
      public var whim_type:int;
      
      public var slot_whim_type:int;
      
      public var whim_fluff_text:LocKey = new LocKey();
      
      public var whim_can_lock:Boolean;
      
      public var whim_audio_sting_on_complete:ResourceKey = new ResourceKey();
      
      public function WhimGoal(param1:Object = null)
      {
         super(param1);
      }
   }
}

