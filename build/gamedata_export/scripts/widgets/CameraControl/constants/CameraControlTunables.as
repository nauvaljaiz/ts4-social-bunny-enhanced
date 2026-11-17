package widgets.CameraControl.constants
{
   import flash.geom.Point;
   import olympus.motion.TweenParams;
   
   public class CameraControlTunables
   {
      
      public static const CAMERA_CONTROLS_HUD_PANEL_ANIMATION_REG_POINT:Point = new Point(0.8,0);
      
      public static const CAMERA_ZOOM_SNAP_INTERVAL:Number = 1 / 16;
      
      public static const WALL_MODE_POPUP_TWEEN_PARAMS:TweenParams = TweenParams.TweenParam().Duration(100).StartProps({"alpha":0}).EndProps({"alpha":1});
      
      public static const CONTINUOUS_CAMERA_TIMER_DELAY:uint = 250;
      
      public static const LEFT_CONTINUOUS_CAMERA_ROTATION_SPEED:Number = 0.5;
      
      public static const RIGHT_CONTINUOUS_CAMERA_ROTATION_SPEED:Number = -0.5;
      
      public static const LEFT_CAMERA_ROTATION_DEGREES:Number = 45;
      
      public static const RIGHT_CAMERA_ROTATION_DEGREES:Number = -45;
      
      public static const CONTINUOUS_CAMERA_ZOOM_IN_SPEED:Number = 0.35;
      
      public static const CONTINUOUS_CAMERA_ZOOM_OUT_SPEED:Number = -0.35;
      
      public static const GAMEPAD_CAMERA_EDGE_PAN_MARGIN_X:* = 0;
      
      public static const GAMEPAD_CAMERA_EDGE_PAN_MARGIN_Y:* = 54;
      
      public function CameraControlTunables()
      {
         super();
      }
   }
}

