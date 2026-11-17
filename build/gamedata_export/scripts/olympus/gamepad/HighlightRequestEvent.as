package olympus.gamepad
{
   import flash.events.Event;
   
   public class HighlightRequestEvent extends Event
   {
      
      public static const HIGHLIGHT_REQUEST:String = "highlight_request";
      
      public var shouldHighlight:Boolean;
      
      public function HighlightRequestEvent(param1:Boolean)
      {
         super(HIGHLIGHT_REQUEST,false,false);
         this.shouldHighlight = param1;
      }
      
      override public function clone() : Event
      {
         return new HighlightRequestEvent(this.shouldHighlight);
      }
      
      override public function toString() : String
      {
         return formatToString("HighlightEvent","isHighlighted","eventPhase");
      }
   }
}

