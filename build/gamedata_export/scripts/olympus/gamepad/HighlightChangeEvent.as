package olympus.gamepad
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HighlightChangeEvent extends Event
   {
      
      public static const HIGHLIGHT_CHANGE:String = "highlightChange";
      
      public var mPreviousHighlight:DisplayObject;
      
      public var mCurrentHighlight:DisplayObject;
      
      public function HighlightChangeEvent(param1:DisplayObject, param2:DisplayObject)
      {
         super(HIGHLIGHT_CHANGE,false,false);
         this.mPreviousHighlight = param2;
         this.mCurrentHighlight = param1;
      }
      
      override public function clone() : Event
      {
         return new HighlightChangeEvent(this.mCurrentHighlight,this.mPreviousHighlight);
      }
      
      override public function toString() : String
      {
         return formatToString("HighlightChangeEvent","type","mCurrentHighlight","mPreviousHighlight");
      }
   }
}

