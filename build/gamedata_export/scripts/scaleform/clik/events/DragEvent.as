package scaleform.clik.events
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import scaleform.clik.interfaces.IDragSlot;
   
   public class DragEvent extends Event
   {
      
      public static const DROP:String = "drop";
      
      public static const DRAG_START:String = "dragStart";
      
      public static const DRAG_END:String = "dragEnd";
      
      public static const CANCEL_DRAG:String = "cancelDrag";
      
      public var dragData:Object;
      
      public var dragSlot:IDragSlot;
      
      public var dropSlot:IDragSlot;
      
      public var dragSprite:Sprite;
      
      public var isManualDrag:Boolean = false;
      
      public var spriteOffset:Point = new Point();
      
      public function DragEvent(param1:String, param2:Object = null, param3:IDragSlot = null, param4:IDragSlot = null, param5:Sprite = null, param6:Boolean = true, param7:Boolean = true)
      {
         this.dragData = param2;
         this.dragSlot = param3;
         this.dropSlot = param4;
         this.dragSprite = param5;
         super(param1,param6,param7);
      }
   }
}

