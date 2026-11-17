package widgets.Gameplay.constants
{
   import olympus.core.widget.Margin;
   import olympus.motion.Easing;
   import olympus.motion.TweenParams;
   
   public final class GameplayTunables
   {
      
      public static const PHONECALL_TIMEOUT_TICK:uint = 15000;
      
      public static const PHONE_ALARM_TIMEOUT_SIM_MINUTES:uint = 60;
      
      public static const SKILL_BAR_HEADLINE_Y:Number = -115;
      
      public static const SKILL_BAR_NO_HEADLINE_Y:Number = -75;
      
      public static const ACTION_DETAIL_HIDE_DELAY:int = 1000;
      
      public static const SKILL_BAR_DROP_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Delay(ACTION_DETAIL_HIDE_DELAY).Duration(300).EndProps({"y":SKILL_BAR_NO_HEADLINE_Y});
      
      public static const SKILL_BAR_RISE_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Duration(300).EndProps({"y":SKILL_BAR_HEADLINE_Y});
      
      public static const SKILL_BAR_FILL_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Duration(500).Ease(Easing.easeOutSine);
      
      public static const SKILL_BAR_STRIPE_FILL_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Duration(500).Ease(Easing.easeInOutSine);
      
      public static const SKILL_BAR_LIGHT_FILL_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().EndProps({"alpha":0.4}).Duration(200);
      
      public static const SKILL_BAR_FILL_NEW_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Duration(500);
      
      public static const SKILL_BAR_FADE_OUT_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().EndProps({"alpha":0}).Duration(200);
      
      public static const SKILL_BAR_FADE_IN_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().EndProps({"alpha":1}).Duration(300);
      
      public static const SKILL_BAR_HIDE_DELAY:uint = 2000;
      
      public static const HOVERTIP_HIDE_ANIM_DURATION:int = 200;
      
      public static const HOVERTIP_SHOW_DELAY:int = 500;
      
      public static const HOVERTIP_HIDE_DELAY:int = 0;
      
      public static const DESTROY_DELAY:int = 5000;
      
      public static const HOVERTIP_ICON_GRID_MARGIN:Margin = new Margin(2);
      
      public static const HOVERTIP_ICON_GRID_MAX:int = 10;
      
      public static const HOVERTIP_ICON_GRID_TEXT_SPACING:Number = 1;
      
      public static const HEADLINE_FADE_OUT_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().EndProps({"alpha":0}).Duration(200);
      
      public static const HEADLINE_FADE_IN_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().EndProps({"alpha":1}).Duration(200);
      
      public static const NAMEPLATE_HIDE_DELAY:int = 500;
      
      public static const NAMEPLATE_SHOW_DELAY:int = 400;
      
      public static const NAMEPLATE_LINGER_RELATIONSHIP_CHANGED:int = 5000;
      
      public static const RELATIONSHIP_CHANGE_DOUBLE_THRESHOLD:Number = 1;
      
      public static const FRIEND_RELATIONSHIP_CHANGE_DOUBLE_THRESHOLD:Number = 1;
      
      public static const ROMANCE_RELATIONSHIP_CHANGE_DOUBLE_THRESHOLD:Number = 1;
      
      public static const FRIEND_RELATIONSHIP_ID:int = 0;
      
      public static const ROMANCE_RELATIONSHIP_ID:int = 1;
      
      public static const VAMPIRE_CHANGE_DOUBLE_THRESHOLD:Number = 100;
      
      public static const VAMPIRE_CHANGE_TRIPLE_THRESHOLD:Number = 200;
      
      public static const FAME_CHANGE_DOUBLE_THRESHOLD:Number = 100;
      
      public static const INSCRIPTION_TEXT_COLOR:uint = 16777011;
      
      public static const LIVE_DRAG_CANCEL_TWEEN_DURATION:Number = 300;
      
      public static const OBJECTIVE_SMALLEST_FONT:int = 6;
      
      public static const OBJECTIVE_CELL_VIEW_MARGIN_Y:Number = 8;
      
      public static const SPECIAL_MOMENT_ZOOM:Number = 0.1;
      
      public static const GAMEPAD_PIE_MENU_DEADZONE:Number = 0.8;
      
      public static const RENT_UPDATE_MSG:String = "RentalUnitRentUpdate";
      
      public static const TUTORIAL_FILL_VACANCY_CLICK:String = "RentalUnitFillVacancySatisfyTutorialTip";
      
      public function GameplayTunables()
      {
         super();
      }
   }
}

