package olympus.events
{
   import flash.events.Event;
   
   public class TooltipEvent extends Event
   {
      
      public static const SHOW:String = "TooltipShow";
      
      public static const HIDE:String = "TooltipHide";
      
      public static const HIDE_COMPLETE:String = "TooltipHideComplete";
      
      public function TooltipEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new TooltipEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TooltipEvent","type","bubbles","cancelable");
      }
   }
}

