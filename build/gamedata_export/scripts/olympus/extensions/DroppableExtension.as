package olympus.extensions
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import gamedata.shared.ManagerObjectId;
   import olympus.core.cursors.Cursors;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.events.DragEvents.DroppableEvent;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.interfaces.IStatesUser;
   
   public class DroppableExtension implements IExtension
   {
      
      protected var mControl:MovieClip;
      
      protected var mbDragStarted:Boolean;
      
      protected var mDraggedSprite:Sprite;
      
      protected var mOverCursor:String = "11687588188357872021";
      
      protected var mOutCursor:String = "12933378511900959033";
      
      public function DroppableExtension()
      {
         super();
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(!(param1 is MovieClip))
         {
            throw new Error("Cannot apply DroppableExtension to object which is not a MovieClip!");
         }
         this.mControl = param1 as MovieClip;
         var _loc2_:Stage = this.mControl.stage;
         this.mControl.addEventListener(Event.ADDED_TO_STAGE,this.OnControlAddedToStage,false,0,true);
         this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnControlRemovedFromStage,false,0,true);
         if(_loc2_)
         {
            _loc2_.addEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStarted,false,0,true);
            _loc2_.addEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEnded,false,0,true);
            _loc2_.addEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated,false,0,true);
         }
      }
      
      public function ConfigureCursors(param1:String, param2:String) : void
      {
         this.mOverCursor = param1;
         this.mOutCursor = param2;
      }
      
      public function IsActiveDroppable() : Boolean
      {
         return false;
      }
      
      protected function OnControlAddedToStage(param1:Event) : void
      {
         var _loc2_:Stage = this.mControl.stage;
         _loc2_.addEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStarted,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEnded,false,0,true);
         _loc2_.addEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated,false,0,true);
      }
      
      protected function OnControlRemovedFromStage(param1:Event) : void
      {
         var _loc2_:Stage = this.mControl.stage;
         _loc2_.removeEventListener(DragManagerEvent.DRAG_STARTED,this.OnDragStarted);
         _loc2_.removeEventListener(DragManagerEvent.DRAG_ENDED,this.OnDragEnded);
         _loc2_.removeEventListener(DragManagerEvent.DRAG_UPDATED,this.OnDragUpdated);
      }
      
      protected function OnDragStarted(param1:DragManagerEvent) : void
      {
      }
      
      protected function OnDragEnded(param1:DragManagerEvent) : void
      {
      }
      
      protected function OnDragUpdated(param1:DragManagerEvent) : void
      {
      }
      
      protected function OnRollOver(param1:MouseEvent) : void
      {
         Cursors.UnlockCursor(this.mDraggedSprite);
         Cursors.LockCursor(this.mDraggedSprite,this.mOverCursor);
      }
      
      protected function OnRollOut(param1:MouseEvent) : void
      {
         Cursors.UnlockCursor(this.mDraggedSprite);
         Cursors.LockCursor(this.mDraggedSprite,this.mOutCursor);
      }
      
      protected function IsValidDrag(param1:ManagerObjectId) : Boolean
      {
         return false;
      }
      
      protected function HandleDragStarted(param1:Object = null) : void
      {
         this.mControl.addEventListener(MouseEvent.ROLL_OVER,this.OnRollOver,false,0,true);
         this.mControl.addEventListener(MouseEvent.ROLL_OUT,this.OnRollOut,false,0,true);
         var _loc2_:Stage = this.mControl.stage;
         var _loc3_:DroppableEvent = new DroppableEvent(DroppableEvent.VALID_DRAG_STARTED);
         _loc3_.mData = param1;
         this.mControl.dispatchEvent(_loc3_);
         if(this.mControl.hitTestPoint(_loc2_.mouseX,_loc2_.mouseY))
         {
            Cursors.UnlockCursor(this.mDraggedSprite);
            Cursors.LockCursor(this.mDraggedSprite,this.mOverCursor);
            this.mControl.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER,false));
         }
         if(this.mControl is IStatesUser)
         {
            (this.mControl as IStatesUser).EnableStatePrefix("drag");
         }
      }
      
      protected function HandleDragEnded(param1:Object = null) : void
      {
         this.mControl.removeEventListener(MouseEvent.ROLL_OVER,this.OnRollOver,false);
         this.mControl.removeEventListener(MouseEvent.ROLL_OUT,this.OnRollOut,false);
         var _loc2_:DroppableEvent = new DroppableEvent(DroppableEvent.VALID_DRAG_ENDED);
         _loc2_.mData = param1;
         this.mControl.dispatchEvent(_loc2_);
         if(this.mControl is IStatesUser)
         {
            (this.mControl as IStatesUser).DisableStatePrefix("drag");
         }
      }
   }
}

