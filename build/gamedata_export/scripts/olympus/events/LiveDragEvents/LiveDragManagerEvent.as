package olympus.events.LiveDragEvents
{
   import flash.events.Event;
   
   public class LiveDragManagerEvent extends Event
   {
      
      public static const REQUEST_LIVE_DRAG_START:String = "liveDragManagerRequestStart";
      
      public static const REQUEST_LIVE_DRAG_END:String = "liveDragManagerRequestEnd";
      
      public static const REQUEST_LIVE_DRAG_CANCEL:String = "liveDragManagerRequestCancel";
      
      public var mTargetId:String;
      
      public var mActorId:String;
      
      public var mbIsStack:Boolean;
      
      public function LiveDragManagerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

