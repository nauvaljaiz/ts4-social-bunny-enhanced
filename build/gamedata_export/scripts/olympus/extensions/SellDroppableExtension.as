package olympus.extensions
{
   import gamedata.Gameplay.LiveDrag.LiveDragCancel;
   import gamedata.Gameplay.LiveDrag.LiveDragEnd;
   import gamedata.Gameplay.LiveDrag.LiveDragStart;
   import gamedata.shared.ManagerObjectId;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.events.DragEvents.DroppableEvent;
   import olympus.interfaces.IExtendable;
   import olympus.io.CommunicationManager;
   
   public class SellDroppableExtension extends DroppableExtension
   {
      
      public static var SlotType:Class = DroppableExtension;
      
      protected var mbIsActiveDroppable:Boolean = false;
      
      protected var mDraggedId:ManagerObjectId;
      
      protected var mSellValue:int;
      
      public function SellDroppableExtension()
      {
         super();
      }
      
      override public function Extend(param1:IExtendable) : void
      {
         super.Extend(param1);
         CommunicationManager.AddMessageListener("LiveDragStarted",this.HandleLiveDragStarted,mControl,LiveDragStart);
         CommunicationManager.AddMessageListener("LiveDragEnded",this.HandleLiveDragEnded,mControl,LiveDragEnd);
         CommunicationManager.AddMessageListener("LiveDragCancelled",this.HandleLiveDragCancelled,mControl,LiveDragCancel);
      }
      
      override public function IsActiveDroppable() : Boolean
      {
         return this.mbIsActiveDroppable && mbDragStarted;
      }
      
      override protected function OnDragStarted(param1:DragManagerEvent) : void
      {
         if(!this.IsValidDrag(param1.mDraggedId))
         {
            return;
         }
         mDraggedSprite = param1.mDraggedSprite;
         mbDragStarted = true;
         if(this.mbIsActiveDroppable)
         {
            HandleDragStarted(this.mSellValue);
         }
      }
      
      override protected function OnDragEnded(param1:DragManagerEvent) : void
      {
         var _loc2_:DroppableEvent = null;
         if(!mbDragStarted)
         {
            return;
         }
         mDraggedSprite = null;
         mbDragStarted = false;
         if(this.mbIsActiveDroppable)
         {
            HandleDragEnded();
         }
         else
         {
            _loc2_ = new DroppableEvent(DroppableEvent.VALID_DRAG_ENDED);
            mControl.dispatchEvent(_loc2_);
         }
      }
      
      override protected function OnDragUpdated(param1:DragManagerEvent) : void
      {
         var _loc2_:DroppableEvent = null;
         if(!this.IsValidDrag(param1.mDraggedId))
         {
            if(this.mbIsActiveDroppable && mbDragStarted)
            {
               HandleDragEnded();
            }
            mbDragStarted = false;
            return;
         }
         if(this.mbIsActiveDroppable && !mbDragStarted)
         {
            HandleDragStarted(this.mSellValue);
         }
         else if(this.mbIsActiveDroppable && mbDragStarted)
         {
            _loc2_ = new DroppableEvent(DroppableEvent.VALID_DRAG_STARTED);
            _loc2_.mData = this.mSellValue;
            mControl.dispatchEvent(_loc2_);
         }
         mbDragStarted = true;
      }
      
      protected function HandleLiveDragStarted(param1:LiveDragStart) : void
      {
         var _loc2_:DroppableEvent = null;
         if(!mControl.visible)
         {
            return;
         }
         this.mSellValue = param1.sell_value;
         if(!this.mbIsActiveDroppable && mbDragStarted && this.mSellValue >= 0)
         {
            HandleDragStarted(this.mSellValue);
            this.mbIsActiveDroppable = true;
         }
         else
         {
            _loc2_ = new DroppableEvent(DroppableEvent.VALID_DRAG_STARTED);
            _loc2_.mData = this.mSellValue;
            mControl.dispatchEvent(_loc2_);
            this.mbIsActiveDroppable = this.mSellValue < 0 ? false : true;
         }
      }
      
      protected function HandleLiveDragEnded(param1:LiveDragEnd) : void
      {
         if(!param1.next_drag_object_id)
         {
            this.mbIsActiveDroppable = false;
         }
      }
      
      protected function HandleLiveDragCancelled(param1:LiveDragCancel) : void
      {
         this.mbIsActiveDroppable = false;
      }
      
      override protected function IsValidDrag(param1:ManagerObjectId) : Boolean
      {
         this.mDraggedId = param1;
         if(!mControl.visible)
         {
            return false;
         }
         if(Boolean(param1) && param1.manager_id == ManagerObjectId.MGR_OBJECT)
         {
            return true;
         }
         return false;
      }
   }
}

