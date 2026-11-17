package olympus.extensions
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gamedata.shared.ManagerObjectId;
   import olympus.core.cursors.Cursors;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.events.DragEvents.DraggableEvent;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.utils.InputUtils;
   
   public class DraggableExtension implements IExtension
   {
      
      protected static const DRAG_THRESHOLD:Number = 5;
      
      protected var mControl:MovieClip;
      
      protected var mOrigin:Point;
      
      protected var mbIsDragged:Boolean;
      
      protected var mbStopNextClick:Boolean;
      
      protected var mDraggedSprite:Sprite;
      
      protected var mDraggableId:ManagerObjectId;
      
      protected var mOffset:Point;
      
      protected var mCursorDragState:String;
      
      public function DraggableExtension()
      {
         super();
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(!(param1 is MovieClip))
         {
            throw new Error("Cannot apply DraggableExtension to object which is not a MovieClip!");
         }
         this.mControl = param1 as MovieClip;
         this.mControl.addEventListener(MouseEvent.MOUSE_DOWN,this.OnControlMouseDown,false,0,true);
         this.mControl.addEventListener(MouseEvent.CLICK,this.OnControlMouseClick,false,5,true);
         var _loc2_:CursorExtension = (this.mControl as IExtendable).GetExtension(CursorExtension) as CursorExtension;
         _loc2_.ConfigureCursors(Cursors.HAND_OPEN,Cursors.HAND_CLOSED);
      }
      
      public function set DraggedSprite(param1:Sprite) : void
      {
         if(!param1)
         {
            return;
         }
         this.mDraggedSprite = param1;
         this.mDraggedSprite.mouseEnabled = this.mDraggedSprite.mouseChildren = false;
      }
      
      public function set DraggedId(param1:ManagerObjectId) : void
      {
         this.mDraggableId = param1;
      }
      
      public function set Offset(param1:Point) : void
      {
         this.mOffset = param1;
      }
      
      public function ConfigureCursors(param1:String, param2:String, param3:String = null) : void
      {
         var _loc4_:CursorExtension = (this.mControl as IExtendable).GetExtension(CursorExtension) as CursorExtension;
         this.mCursorDragState = param3;
         _loc4_.ConfigureCursors(param1,param2);
      }
      
      protected function OnControlMouseDown(param1:MouseEvent) : void
      {
         if(!InputUtils.IsLeftMouseButton(param1))
         {
            return;
         }
         if(!this.mDraggableId)
         {
            return;
         }
         this.mOrigin = new Point(this.mControl.mouseX,this.mControl.mouseY);
         this.mControl.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false,0,true);
         this.mbIsDragged = false;
         this.mbStopNextClick = false;
      }
      
      protected function OnControlMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:CursorExtension = null;
         var _loc7_:DragManagerEvent = null;
         var _loc8_:Point = null;
         _loc2_ = this.mControl.mouseX - this.mOrigin.x;
         _loc3_ = this.mControl.mouseY - this.mOrigin.y;
         var _loc4_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         var _loc5_:Stage = this.mControl.stage;
         if(!this.mDraggableId)
         {
            _loc5_.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false);
            return;
         }
         if(_loc4_ >= DRAG_THRESHOLD)
         {
            _loc5_.addEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStartConfirmed,false,0,true);
            _loc5_.addEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEndConfirmed,false,0,true);
            _loc5_.addEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated,false,0,true);
            this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage,false,0,true);
            _loc6_ = (this.mControl as IExtendable).GetExtension(CursorExtension) as CursorExtension;
            _loc6_.UnlockCursor();
            _loc5_.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false);
            _loc7_ = new DragManagerEvent(DragManagerEvent.REQUEST_START);
            _loc8_ = this.mControl.localToGlobal(new Point(0,0));
            _loc7_.mStartPoint = _loc8_;
            _loc7_.mDraggedId = this.mDraggableId;
            _loc7_.mDraggedSprite = this.mDraggedSprite;
            _loc7_.mSpriteOffset = this.mOffset;
            _loc7_.mDraggedCursor = this.mCursorDragState;
            _loc5_.dispatchEvent(_loc7_);
         }
      }
      
      protected function OnControlMouseClick(param1:MouseEvent) : void
      {
         if(!this.mDraggableId)
         {
            return;
         }
         if(!this.mbStopNextClick)
         {
            this.mControl.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false);
            return;
         }
         param1.stopImmediatePropagation();
         this.mbStopNextClick = false;
      }
      
      protected function OnDragStartConfirmed(param1:DragManagerEvent) : void
      {
         this.mControl.stage.removeEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStartConfirmed,false);
         if(param1.mDraggedId != this.mDraggableId)
         {
            return;
         }
         this.mbIsDragged = true;
         this.mbStopNextClick = true;
         var _loc2_:DraggableEvent = new DraggableEvent(DraggableEvent.DRAG_START);
         _loc2_.mData = param1.mDraggedId;
         this.mControl.dispatchEvent(_loc2_);
      }
      
      protected function OnDragEndConfirmed(param1:DragManagerEvent) : void
      {
         this.mControl.stage.removeEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEndConfirmed,false);
         this.mControl.stage.removeEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated,false);
         this.mbIsDragged = false;
         var _loc2_:DraggableEvent = new DraggableEvent(DraggableEvent.DRAG_END);
         _loc2_.mData = param1.mDraggedId;
         this.mControl.dispatchEvent(_loc2_);
      }
      
      protected function OnDragUpdated(param1:DragManagerEvent) : void
      {
      }
      
      protected function OnRemovedFromStage(param1:Event) : void
      {
         var _loc2_:Stage = this.mControl.stage;
         _loc2_.removeEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStartConfirmed,false);
         _loc2_.removeEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEndConfirmed,false);
         _loc2_.removeEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated,false);
         this.mControl.removeEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage,false);
         this.mbIsDragged = false;
         var _loc3_:CursorExtension = (this.mControl as IExtendable).GetExtension(CursorExtension) as CursorExtension;
         _loc3_.UnlockCursor();
      }
   }
}

