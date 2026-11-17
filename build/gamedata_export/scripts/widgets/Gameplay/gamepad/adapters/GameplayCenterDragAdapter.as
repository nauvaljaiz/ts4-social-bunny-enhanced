package widgets.Gameplay.gamepad.adapters
{
   import flash.geom.Point;
   import olympus.constants.ActionCodes;
   import olympus.core.DragManager;
   import olympus.events.DragEvents.DroppableEvent;
   import olympus.extensions.DroppableExtension;
   import olympus.extensions.LiveDroppableExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysConsole;
   import olympus.utils.InputUtils;
   import widgets.Gameplay.gamepad.GameplayActionCodes;
   
   public class GameplayCenterDragAdapter extends GameplayCenterAdapterBase
   {
      
      protected var mValidItemForInventory:Boolean = false;
      
      public function GameplayCenterDragAdapter()
      {
         super();
         SetMouseButtonActions(MOUSEACTION_NONE,MOUSEACTION_NONE);
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.CONFIRM)).CallFunction(this.GamepadMouseDragFinish);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.BACK,false)).CallFunction(this.CancelDrag).SetLegendKey(Keys.GENERIC_BACK);
         SetConfirmActionLegend(KeysConsole.LIVE_PLACE_OBJECT);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.PUT_ITEM_IN_INVENTORY)).CallFunction(this.PutItemInInventory).SetValidCheck(this.CanPutItemInInventory).SetLegendKey(KeysConsole.LIVE_PLACE_IN_INVENTORY);
         AddInputActions([_loc1_,_loc2_,_loc3_]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         AddMessageListener("LiveDragEnded",this.OnLiveDragFinished);
         AddMessageListener("LiveDragCancelled",this.OnLiveDragFinished);
         AddMessageListener("CursorModeToggled",this.CancelDrag);
         AddMessageListener("HideCompleteControllerLegend",this.OnHideControllerLegendComplete);
         AddMessageListener(DroppableEvent.VALID_DRAG_STARTED,this.OnValidDragStarted);
         AddMessageListener(DroppableEvent.VALID_DRAG_ENDED,this.OnValidDragEnded);
         return super.OnEntered(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         RemoveMessageListener("LiveDragEnded",this.OnLiveDragFinished);
         RemoveMessageListener("LiveDragCancelled",this.OnLiveDragFinished);
         RemoveMessageListener("CursorModeToggled",this.CancelDrag);
         RemoveMessageListener("HideCompleteControllerLegend",this.OnHideControllerLegendComplete);
         RemoveMessageListener(DroppableEvent.VALID_DRAG_STARTED,this.OnValidDragStarted);
         RemoveMessageListener(DroppableEvent.VALID_DRAG_ENDED,this.OnValidDragEnded);
      }
      
      protected function OnHideControllerLegendComplete() : void
      {
         FireMouseMoveEvent();
      }
      
      protected function OnLiveDragFinished(param1:Object) : void
      {
         NavManager.Instance.FocusBack();
         FireMouseMoveEvent();
      }
      
      protected function CancelDrag() : void
      {
         var _loc1_:Boolean = Boolean(CommunicationManager.CallGameService("VirtualCursorIsCameraPanning"));
         if(_loc1_)
         {
            return;
         }
         CommunicationManager.CallGameService("GamepadMouseDragCancel");
      }
      
      protected function PutItemInInventory() : void
      {
         CommunicationManager.SendUIMessage("PlaceDraggedItemInInventory");
      }
      
      protected function GamepadMouseDragFinish() : void
      {
         var _loc1_:Point = null;
         var _loc3_:LiveDroppableExtension = null;
         _loc1_ = new Point(InputUtils.sMouseX,InputUtils.sMouseY);
         var _loc2_:DroppableExtension = DragManager.GetTopMostValidDroppable(_loc1_,LayoutAPI.GetStage());
         if(_loc2_)
         {
            _loc3_ = _loc2_ as LiveDroppableExtension;
            if(_loc3_)
            {
               CommunicationManager.SendUIMessage("PlaceDraggedItemInInventory",{"ControlId":_loc3_.GetControlId()});
            }
            return;
         }
         CommunicationManager.CallGameService("GamepadMouseDragFinish");
      }
      
      protected function OnValidDragStarted() : void
      {
         this.mValidItemForInventory = true;
      }
      
      protected function OnValidDragEnded() : void
      {
         this.mValidItemForInventory = false;
      }
      
      protected function CanPutItemInInventory() : Boolean
      {
         return this.mValidItemForInventory;
      }
   }
}

