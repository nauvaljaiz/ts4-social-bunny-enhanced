package olympus.events.DragEvents
{
   import flash.events.Event;
   
   public class DroppableEvent extends Event
   {
      
      public static const VALID_DRAG_STARTED:String = "droppableExtensionDragStarted";
      
      public static const VALID_DRAG_ENDED:String = "droppableExtensionDragEnded";
      
      public var mData:Object;
      
      public function DroppableEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

