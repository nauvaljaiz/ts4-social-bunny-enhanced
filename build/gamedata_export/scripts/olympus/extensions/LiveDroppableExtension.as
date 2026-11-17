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
   
   public class LiveDroppableExtension extends DroppableExtension
   {
      
      public static var SlotType:Class = DroppableExtension;
      
      protected var mbIsActiveDroppable:Boolean = false;
      
      protected var mDraggedId:ManagerObjectId;
      
      protected var mControlId:String;
      
      protected var mStackId:String;
      
      public function LiveDroppableExtension()
      {
         super();
      }
      
      public function GetControlId() : String
      {
         return this.mControlId;
      }
      
      public function SetControlId(param1:String) : void
      {
         this.mControlId = param1;
      }
      
      public function GetStackId() : String
      {
         return this.mStackId;
      }
      
      public function SetStackId(param1:String) : void
      {
         this.mStackId = param1;
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
            HandleDragStarted(param1.mDraggedId.object_id);
         }
      }
      
      override protected function OnDragEnded(param1:DragManagerEvent) : void
      {
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
      }
      
      override protected function OnDragUpdated(param1:DragManagerEvent) : void
      {
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
            HandleDragStarted(param1.mDraggedId.object_id);
         }
         mbDragStarted = true;
      }
      
      protected function HandleLiveDragStarted(param1:LiveDragStart) : void
      {
         var _loc2_:Array = null;
         _loc2_ = param1.drop_object_ids;
         var _loc3_:int = _loc2_.indexOf(this.mControlId);
         if(_loc3_ < 0 || Boolean(this.mStackId) && Boolean(this.mStackId != param1.stack_id))
         {
            if(this.mbIsActiveDroppable && mbDragStarted)
            {
               HandleDragEnded();
            }
            this.mbIsActiveDroppable = false;
            mbDragStarted = false;
            return;
         }
         if(!this.mbIsActiveDroppable && mbDragStarted)
         {
            HandleDragStarted(param1.live_drag_object_id);
         }
         this.mbIsActiveDroppable = true;
         CommunicationManager.SendUIMessage(DroppableEvent.VALID_DRAG_STARTED);
      }
      
      protected function HandleLiveDragEnded(param1:LiveDragEnd) : void
      {
         if(!param1.next_drag_object_id)
         {
            this.mbIsActiveDroppable = false;
            CommunicationManager.SendUIMessage(DroppableEvent.VALID_DRAG_ENDED);
         }
      }
      
      protected function HandleLiveDragCancelled(param1:LiveDragCancel) : void
      {
         this.mbIsActiveDroppable = false;
      }
      
      override protected function IsValidDrag(param1:ManagerObjectId) : Boolean
      {
         this.mDraggedId = param1;
         if(Boolean(param1) && param1.manager_id == ManagerObjectId.MGR_OBJECT)
         {
            return true;
         }
         return false;
      }
   }
}

