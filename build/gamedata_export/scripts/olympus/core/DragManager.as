package olympus.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Point;
   import gamedata.shared.ManagerObjectId;
   import olympus.core.cursors.Cursors;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.extensions.DroppableExtension;
   import olympus.interfaces.IExtendable;
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   import scaleform.gfx.Extensions;
   
   public class DragManager
   {
      
      protected const DRAG_MANAGER_MOUSE_PRIORITIES:int = 10;
      
      protected var mDragLayer:Layer;
      
      protected var mDraggedSprite:Sprite;
      
      protected var mbIsDragging:Boolean;
      
      protected var mDraggedId:ManagerObjectId;
      
      protected var mDraggedCursor:String;
      
      protected var mStartPoint:Point;
      
      public function DragManager(param1:Layer)
      {
         super();
         this.mDragLayer = param1;
         var _loc2_:Stage = param1.stage;
         _loc2_.addEventListener(DragManagerEvent.REQUEST_START,this.OnDragManagerRequestStart,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.REQUEST_END,this.OnDragManagerRequestEnd,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.REQUEST_CANCEL,this.OnDragManagerRequestCancel,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.REQUEST_DATA_UPDATE,this.OnDragManagerRequestDataUpdate,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.DRAG_END_COMPLETE,this.OnDragManagerDragEndComplete,false,0,true);
      }
      
      public static function GetTopMostValidDroppable(param1:Point, param2:Stage) : DroppableExtension
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:IExtendable = null;
         var _loc6_:DroppableExtension = null;
         var _loc3_:Array = param2.getObjectsUnderPoint(param1);
         for each(_loc4_ in _loc3_)
         {
            while(Boolean(_loc4_) && !(_loc4_ is IExtendable))
            {
               _loc4_ = _loc4_.parent;
            }
            if(_loc4_)
            {
               _loc5_ = _loc4_ as IExtendable;
               _loc6_ = _loc5_.GetExtension(DroppableExtension,false) as DroppableExtension;
               if((Boolean(_loc6_)) && _loc6_.IsActiveDroppable())
               {
                  return _loc6_;
               }
            }
         }
         return null;
      }
      
      public function Clear() : void
      {
         this.mDragLayer.Clear();
      }
      
      protected function OnDragManagerRequestStart(param1:DragManagerEvent) : void
      {
         var _loc4_:Point = null;
         var _loc2_:Sprite = param1.mDraggedSprite;
         var _loc3_:Stage = this.mDragLayer.stage;
         if(!_loc2_ || this.mbIsDragging)
         {
            return;
         }
         if(this.mDraggedSprite)
         {
            this.mDragLayer.removeChild(this.mDraggedSprite);
         }
         this.mDraggedSprite = _loc2_;
         if(param1.mSpriteOffset)
         {
            _loc4_ = param1.mSpriteOffset;
         }
         else
         {
            _loc4_ = new Point(-_loc2_.mouseX,-_loc2_.mouseY);
         }
         var _loc5_:Point = _loc2_.localToGlobal(new Point(0,0));
         var _loc6_:DisplayObject = _loc2_.mask;
         this.mDragLayer.addChild(_loc2_);
         var _loc7_:Point = this.mDragLayer.globalToLocal(_loc5_);
         _loc2_.x = _loc7_.x;
         _loc2_.y = _loc7_.y;
         if(_loc6_)
         {
            _loc2_.mask = _loc6_;
         }
         this.mbIsDragging = true;
         CommunicationManager.CallGameService("BindDisplayObject",{
            "displayObject":_loc2_,
            "attachPoint":"MOUSE",
            "screenOffset":{
               "x":_loc4_.x,
               "y":_loc4_.y,
               "z":0
            }
         });
         if(param1.mStartPoint)
         {
            this.mStartPoint = param1.mStartPoint;
         }
         else
         {
            this.mStartPoint = new Point(_loc3_.mouseX,_loc3_.mouseY);
         }
         var _loc8_:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DRAG_STARTED);
         _loc8_.mDraggedSprite = _loc2_;
         _loc8_.mDraggedId = param1.mDraggedId;
         _loc8_.mStartPoint = this.mStartPoint;
         this.mDraggedId = param1.mDraggedId;
         _loc3_.dispatchEvent(_loc8_);
         _loc3_.addEventListener(DragManagerEvent.SHOW_DRAGGED_ICON,this.OnShowDraggedIcon,false,0,true);
         _loc3_.addEventListener(DragManagerEvent.HIDE_DRAGGED_ICON,this.OnHideDraggedIcon,false,0,true);
         Cursors.LockCursor(this.mDraggedSprite,param1.mDraggedCursor);
         this.mDraggedCursor = param1.mDraggedCursor;
         if(SystemUtils.UsingController)
         {
            this.mDraggedSprite.visible = Extensions.getMouseTopMostEntity() != null;
         }
      }
      
      protected function OnDragManagerRequestEnd(param1:DragManagerEvent) : void
      {
         this.EndDrag(true);
      }
      
      protected function OnDragManagerRequestCancel(param1:DragManagerEvent) : void
      {
         this.EndDrag();
      }
      
      protected function OnDragManagerRequestDataUpdate(param1:DragManagerEvent) : void
      {
         var _loc2_:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DRAG_UPDATED);
         if(param1.mDraggedId)
         {
            this.mDraggedId = param1.mDraggedId;
            _loc2_.mDraggedId = this.mDraggedId;
            this.mDragLayer.stage.dispatchEvent(_loc2_);
         }
         if(param1.mDraggedCursor)
         {
            if(this.mDraggedCursor != param1.mDraggedCursor)
            {
               this.mDraggedCursor = param1.mDraggedCursor;
               Cursors.UnlockCursor(this.mDraggedSprite);
               Cursors.LockCursor(this.mDraggedSprite,this.mDraggedCursor);
            }
         }
      }
      
      protected function OnDragManagerDragEndComplete(param1:DragManagerEvent) : void
      {
         if(param1.mDraggedSprite != this.mDraggedSprite)
         {
            return;
         }
         if(this.mDraggedSprite)
         {
            this.mDragLayer.removeChild(this.mDraggedSprite);
            this.mDraggedSprite = null;
         }
      }
      
      protected function OnShowDraggedIcon(param1:DragManagerEvent) : void
      {
         this.mDraggedSprite.visible = true;
         Cursors.LockCursor(this.mDraggedSprite,this.mDraggedCursor);
      }
      
      protected function OnHideDraggedIcon(param1:DragManagerEvent) : void
      {
         this.mDraggedSprite.visible = false;
         Cursors.UnlockCursor(this.mDraggedSprite);
      }
      
      protected function EndDrag(param1:Boolean = false) : void
      {
         var _loc2_:Stage = null;
         if(!this.mbIsDragging)
         {
            return;
         }
         _loc2_ = this.mDragLayer.stage;
         var _loc3_:Sprite = this.mDraggedSprite;
         this.mbIsDragging = false;
         CommunicationManager.CallGameService("UnbindDisplayObject",{"displayObject":_loc3_});
         var _loc4_:Point = new Point(_loc2_.mouseX,_loc2_.mouseY);
         var _loc5_:DroppableExtension = param1 ? GetTopMostValidDroppable(_loc4_,_loc2_) : null;
         var _loc6_:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DRAG_ENDED);
         _loc6_.mDraggedSprite = _loc3_;
         _loc6_.mDraggedId = this.mDraggedId;
         _loc6_.mStartPoint = this.mStartPoint;
         _loc6_.mEndPoint = _loc4_;
         _loc6_.mDroppable = _loc5_;
         _loc2_.dispatchEvent(_loc6_);
         _loc2_.removeEventListener(DragManagerEvent.SHOW_DRAGGED_ICON,this.OnShowDraggedIcon,false);
         _loc2_.removeEventListener(DragManagerEvent.HIDE_DRAGGED_ICON,this.OnHideDraggedIcon,false);
         Cursors.UnlockCursor(_loc3_);
      }
   }
}

