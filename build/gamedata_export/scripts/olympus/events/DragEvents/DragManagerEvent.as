package olympus.events.DragEvents
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import gamedata.shared.ManagerObjectId;
   import olympus.extensions.DroppableExtension;
   
   public class DragManagerEvent extends Event
   {
      
      public static const REQUEST_START:String = "dragManagerRequestStart";
      
      public static const REQUEST_END:String = "dragManagerRequestEnd";
      
      public static const SHOW_DRAGGED_ICON:String = "dragManagerShowIcon";
      
      public static const HIDE_DRAGGED_ICON:String = "dragManagerHideIcon";
      
      public static const REQUEST_CANCEL:String = "dragManagerRequestCancel";
      
      public static const REQUEST_DATA_UPDATE:String = "dragManagerRequestDataUpdate";
      
      public static const DRAG_END_COMPLETE:String = "dragManagerDragEndComplete";
      
      public static const DRAG_STARTED:String = "dragManagerDragStarted";
      
      public static const DRAG_ENDED:String = "dragManagerDragEnded";
      
      public static const DRAG_UPDATED:String = "dragManagerDragUpdated";
      
      public var mDraggedSprite:Sprite;
      
      public var mSpriteOffset:Point;
      
      public var mDraggedId:ManagerObjectId;
      
      public var mDraggedCursor:String;
      
      public var mStartPoint:Point;
      
      public var mEndPoint:Point;
      
      public var mDroppable:DroppableExtension;
      
      public function DragManagerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

