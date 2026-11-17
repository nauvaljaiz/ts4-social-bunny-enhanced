package widgets.shared.constants
{
   import olympus.core.widget.Margin;
   import olympus.motion.TweenParams;
   
   public final class ToastNotificationTunables
   {
      
      public static const NOTIFICATION_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Delay(1200).Duration(500).EndProps({"alpha":0});
      
      public static const NOTIFICATION_MIN_WIDTH:Number = 60;
      
      public static const NOTIFICATION_PADDING:Margin = new Margin(40,20,240,20);
      
      public static const NOTIFICATION_CONTROLLER_X_PCT:Number = 0.5;
      
      public static const NOTIFICATION_CONTROLLER_Y:Number = 200;
      
      public function ToastNotificationTunables()
      {
         super();
      }
   }
}

