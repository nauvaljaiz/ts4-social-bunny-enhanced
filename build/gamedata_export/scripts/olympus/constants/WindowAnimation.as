package olympus.constants
{
   import olympus.audio.Audio;
   import olympus.motion.Easing;
   import olympus.motion.TweenParams;
   
   public final class WindowAnimation
   {
      
      public static const WINDOW_LARGE_HORIZONTAL_IN:TweenParams = TweenParams.TweenParam().AudioStyleName(Audio.PANEL_POP_IN).Duration(200).StartProps({
         "alpha":1,
         "scaleX":0.9,
         "scaleY":0.9
      }).EndProps({
         "alpha":1.01,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const WINDOW_LARGE_HORIZONTAL_OUT:TweenParams = TweenParams.TweenParam().AudioStyleName(Audio.PANEL_POP_OFF).Duration(200).StartProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).EndProps({
         "alpha":0,
         "scaleX":1.2,
         "scaleY":1.2
      }).Ease(Easing.easeOutQuad).AddStep().EndProps({
         "scaleX":1,
         "scaleY":1
      }).Duration(1).Done();
      
      public static const PANEL_SMALL_VERT_IN:TweenParams = TweenParams.TweenParam().Duration(200).StartProps({
         "alpha":0.99,
         "scaleX":1,
         "scaleY":0.4
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const PANEL_LARGE_VERT_IN:TweenParams = TweenParams.TweenParam().Duration(300).StartProps({
         "alpha":0.99,
         "scaleX":1,
         "scaleY":0.4
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const PANEL_SMALL_HORIZ_IN:TweenParams = TweenParams.TweenParam().Duration(200).StartProps({
         "alpha":0.99,
         "scaleX":0.4,
         "scaleY":1
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const PANEL_LARGE_HORIZ_IN:TweenParams = TweenParams.TweenParam().Duration(300).StartProps({
         "alpha":0.99,
         "scaleX":0.4,
         "scaleY":1
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const PANEL_BOUNCE_IN:TweenParams = TweenParams.TweenParam().Duration(800).StartProps({
         "alpha":0.99,
         "scaleX":1,
         "scaleY":0.4
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutElastic);
      
      public static const PANEL_IN:TweenParams = TweenParams.TweenParam().Duration(200).StartProps({
         "alpha":0,
         "scaleX":0.2,
         "scaleY":0.2
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutBack);
      
      public static const PANEL_OUT:TweenParams = TweenParams.TweenParam().Duration(200).StartProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).EndProps({
         "alpha":0,
         "scaleX":0.2,
         "scaleY":0.2
      }).Ease(Easing.easeInBack).AddStep().EndProps({
         "alpha":0,
         "scaleX":1,
         "scaleY":1
      }).Duration(1).Done();
      
      public static const CONTENT_TWEEN_DELAYED:TweenParams = TweenParams.TweenParam().Delay(50).Duration(200).StartProps({
         "alpha":0,
         "scaleX":0.9,
         "scaleY":0.9
      }).EndProps({
         "alpha":1,
         "scaleX":1,
         "scaleY":1
      }).Ease(Easing.easeOutQuad);
      
      public static const CONTENT_FADE_IN:TweenParams = TweenParams.TweenParam().Duration(100).StartProps({"alpha":0}).EndProps({"alpha":1});
      
      public static const CONTENT_FADE_OUT:TweenParams = TweenParams.TweenParam().Duration(100).StartProps({"alpha":1}).EndProps({"alpha":0});
      
      public function WindowAnimation()
      {
         super();
      }
   }
}

