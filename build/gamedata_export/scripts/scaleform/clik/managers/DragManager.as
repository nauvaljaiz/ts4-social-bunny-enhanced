package scaleform.clik.managers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import olympus.io.CommunicationManager;
   import scaleform.clik.events.DragEvent;
   import scaleform.clik.interfaces.IDragSlot;
   
   public class DragManager
   {
      
      protected static var _stage:Stage;
      
      protected static var _dragCanvas:Sprite;
      
      protected static var _dragData:Object;
      
      protected static var _dragTarget:Sprite;
      
      protected static var _origDragSlot:IDragSlot;
      
      protected static var _initialized:Boolean = false;
      
      protected static var _inDrag:Boolean = false;
      
      public function DragManager()
      {
         super();
      }
      
      public static function init(param1:Stage) : void
      {
         if(_initialized)
         {
            return;
         }
         _initialized = true;
         DragManager._stage = param1;
         _dragCanvas = new Sprite();
         _dragCanvas.mouseEnabled = _dragCanvas.mouseChildren = false;
         _stage.addChild(_dragCanvas);
         _stage.addEventListener(DragEvent.DRAG_START,DragManager.handleStartDragEvent,false,0,true);
      }
      
      public static function inDrag() : Boolean
      {
         return _inDrag;
      }
      
      public static function handleStartDragEvent(param1:DragEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         if(param1.dragSprite == null)
         {
            return;
         }
         _dragData = param1.dragData;
         _dragTarget = param1.dragSprite;
         var _loc2_:Sprite = _dragTarget;
         _origDragSlot = param1.dragSlot;
         if(_loc2_.parent)
         {
            _loc4_ = new Point(_loc2_.x,_loc2_.y);
            _loc5_ = _loc2_.parent.localToGlobal(_loc4_);
            _loc3_ = new Point(_loc5_.x - _stage.mouseX,_loc5_.y - _stage.mouseY);
         }
         else
         {
            _loc3_ = param1.spriteOffset;
         }
         _dragCanvas.addChild(_loc2_);
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         if(param1.isManualDrag)
         {
            _stage.addEventListener(DragEvent.CANCEL_DRAG,handleEndDragEvent,false,0,true);
         }
         else
         {
            _stage.addEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false,0,true);
         }
         _inDrag = true;
         CommunicationManager.CallGameService("BindDisplayObject",{
            "displayObject":_loc2_,
            "attachPoint":"MOUSE",
            "screenOffset":{
               "x":_loc3_.x,
               "y":_loc3_.y,
               "z":0
            }
         });
      }
      
      public static function handleEndDragEvent(param1:Event) : void
      {
         var _loc5_:DragEvent = null;
         var _loc6_:DragEvent = null;
         _stage.removeEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false);
         _stage.removeEventListener(DragEvent.CANCEL_DRAG,handleEndDragEvent,false);
         _inDrag = false;
         var _loc2_:Sprite = _dragTarget;
         var _loc3_:Boolean = false;
         var _loc4_:IDragSlot = findSpriteAncestorOf(_loc2_.dropTarget) as IDragSlot;
         if(_loc4_ != null && _origDragSlot != null && _loc4_ is IDragSlot && _loc4_ != _origDragSlot)
         {
            _loc5_ = new DragEvent(DragEvent.DROP,_dragData,_origDragSlot,_loc4_,_loc2_);
            _loc3_ = _loc4_.handleDropEvent(_loc5_);
         }
         CommunicationManager.CallGameService("UnbindDisplayObject",{"displayObject":_loc2_});
         _loc2_.mouseEnabled = _loc2_.mouseChildren = true;
         _dragCanvas.removeChild(_loc2_);
         if(_origDragSlot)
         {
            _loc6_ = new DragEvent(DragEvent.DRAG_END,_dragData,_origDragSlot,_loc4_,_loc2_);
            _origDragSlot.handleDragEndEvent(_loc6_,_loc3_);
            _origDragSlot.dispatchEvent(_loc6_);
         }
         _dragTarget = null;
         _origDragSlot = null;
      }
      
      protected static function handleStageAddedEvent(param1:Event) : void
      {
      }
      
      protected static function findSpriteAncestorOf(param1:DisplayObject) : IDragSlot
      {
         while(Boolean(param1) && !(param1 is IDragSlot))
         {
            param1 = param1.parent;
         }
         return param1 as IDragSlot;
      }
   }
}

