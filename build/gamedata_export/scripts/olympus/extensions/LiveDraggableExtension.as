package olympus.extensions
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gamedata.Gameplay.shared.InventorySlotInfo;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.interfaces.IExtendable;
   import widgets.Gameplay.SimInfoHUD.InventoryPanel.DraggedClip;
   
   public class LiveDraggableExtension extends DraggableExtension
   {
      
      protected var mDraggedClip:DraggedClip;
      
      protected var mSavedSlotInfo:InventorySlotInfo;
      
      protected var mSavedNumStacked:uint;
      
      public function LiveDraggableExtension()
      {
         super();
      }
      
      public function SetData(param1:InventorySlotInfo, param2:uint) : void
      {
         this.mSavedNumStacked = param2;
         this.mSavedSlotInfo = param1;
         if(this.mDraggedClip)
         {
            this.mDraggedClip.Draw(param1,param2);
         }
      }
      
      override protected function OnControlMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:CursorExtension = null;
         _loc2_ = mControl.mouseX - mOrigin.x;
         _loc3_ = mControl.mouseY - mOrigin.y;
         var _loc4_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         var _loc5_:Stage = mControl.stage;
         if(!mDraggableId)
         {
            _loc5_.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false);
            return;
         }
         if(_loc4_ >= DRAG_THRESHOLD && Boolean(_loc5_))
         {
            _loc5_.addEventListener(DragManagerEvent.DRAG_STARTED,OnDragStartConfirmed,false,0,true);
            _loc5_.addEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEndConfirmed,false,0,true);
            _loc5_.addEventListener(DragManagerEvent.DRAG_UPDATED,OnDragUpdated,false,0,true);
            mControl.addEventListener(Event.REMOVED_FROM_STAGE,OnRemovedFromStage,false,0,true);
            _loc6_ = (mControl as IExtendable).GetExtension(CursorExtension) as CursorExtension;
            _loc6_.UnlockCursor();
            _loc5_.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnControlMouseMove,false);
            this.SendRequestStartDragEvent();
         }
      }
      
      override protected function OnDragEndConfirmed(param1:DragManagerEvent) : void
      {
         this.mDraggedClip.visible = false;
         super.OnDragEndConfirmed(param1);
         this.mDraggedClip = null;
      }
      
      public function SendRequestStartDragEvent() : void
      {
         var _loc1_:Stage = null;
         _loc1_ = mControl.stage;
         var _loc2_:DraggedClip = new DraggedClip();
         mControl.addChild(_loc2_);
         _loc2_.Draw(this.mSavedSlotInfo,this.mSavedNumStacked);
         this.mDraggedClip = _loc2_;
         this.mDraggedClip.visible = true;
         var _loc3_:DragManagerEvent = new DragManagerEvent(DragManagerEvent.REQUEST_START);
         var _loc4_:Point = mControl.localToGlobal(new Point(0,0));
         _loc3_.mDraggedSprite = _loc2_;
         _loc3_.mStartPoint = _loc4_;
         _loc3_.mDraggedId = mDraggableId;
         _loc3_.mSpriteOffset = mOffset;
         _loc3_.mDraggedCursor = mCursorDragState;
         _loc1_.dispatchEvent(_loc3_);
      }
   }
}

