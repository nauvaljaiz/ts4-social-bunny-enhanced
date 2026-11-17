package olympus.events
{
   import flash.events.Event;
   
   public class TweenEvent extends Event
   {
      
      public static const TWEEN_COMPLETE:String = "tweenComplete";
      
      public static const TWEEN_STEP_COMPLETE:String = "tweenStepComplete";
      
      public static const TWEEN_CHANGE:String = "tweenChange";
      
      public function TweenEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TweenEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TweenEvent","type","bubbles","cancelable");
      }
   }
}

