package widgets.shared.controls.ToastNotification
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import olympus.audio.Audio;
   import olympus.core.PopUpManager;
   import olympus.events.GenericEvent;
   import olympus.events.TweenEvent;
   import olympus.gamepad.LayoutAPI;
   import olympus.motion.Tween;
   import widgets.shared.constants.ToastNotificationTunables;
   
   public class ToastNotification extends MovieClip
   {
      
      public static const TYPE_CLOBBER:String = "clobber";
      
      public static const TYPE_ERROR:String = "error";
      
      public static const TYPE_WARNING:String = "warning";
      
      public var mcNotification:MovieClip;
      
      public function ToastNotification(param1:String)
      {
         super();
         this.mcNotification.gotoAndStop(param1);
         this.mcNotification.txtLabel.autoSize = TextFieldAutoSize.LEFT;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get Label() : String
      {
         return this.mcNotification.txtLabel.text;
      }
      
      public function set Label(param1:String) : void
      {
         var _loc2_:TextField = this.mcNotification.txtLabel;
         _loc2_.htmlText = param1;
         var _loc3_:MovieClip = this.mcNotification.bg;
         _loc3_.width = 2 * _loc2_.x + _loc2_.width;
         if(_loc3_.width < ToastNotificationTunables.NOTIFICATION_MIN_WIDTH)
         {
            _loc3_.width = ToastNotificationTunables.NOTIFICATION_MIN_WIDTH;
            _loc2_.x = 0.5 * (ToastNotificationTunables.NOTIFICATION_MIN_WIDTH - _loc2_.width);
         }
      }
      
      public function Show(param1:String, param2:DisplayObjectContainer, param3:Boolean, param4:Boolean) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.visible = true;
         this.Label = param1;
         param2.addChild(this);
         var _loc5_:MovieClip = this.mcNotification;
         _loc5_.x = -0.5 * _loc5_.width;
         var _loc6_:Tween = new Tween(ToastNotificationTunables.NOTIFICATION_TWEEN_PARAMS.duration,_loc5_,ToastNotificationTunables.NOTIFICATION_TWEEN_PARAMS.endProps,ToastNotificationTunables.NOTIFICATION_TWEEN_PARAMS.delay);
         _loc6_.EventType = Audio.TWEEN_FADE_OUT;
         _loc6_.addEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenComplete,false,0,true);
         _loc6_.Start();
         if(param3)
         {
            _loc7_ = 0.5 * param2.stage.stageWidth;
            _loc8_ = 0.5 * param2.stage.stageHeight;
            if(param4)
            {
               _loc7_ = ToastNotificationTunables.NOTIFICATION_CONTROLLER_X_PCT * param2.stage.stageWidth;
               _loc8_ = LayoutAPI.ScreenMargin.y + ToastNotificationTunables.NOTIFICATION_CONTROLLER_Y;
            }
            PopUpManager.Show(this,stage,_loc7_,_loc8_);
         }
      }
      
      protected function OnTweenComplete(param1:TweenEvent) : void
      {
         PopUpManager.Remove(this);
         dispatchEvent(new GenericEvent(GenericEvent.CLOSE));
      }
   }
}

