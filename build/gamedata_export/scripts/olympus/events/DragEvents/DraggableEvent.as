package olympus.events.DragEvents
{
   import flash.events.Event;
   
   public class DraggableEvent extends Event
   {
      
      public static const DRAG_START:String = "draggableExtensionStart";
      
      public static const DRAG_END:String = "draggableExtensionEnd";
      
      public var mData:Object;
      
      public function DraggableEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

