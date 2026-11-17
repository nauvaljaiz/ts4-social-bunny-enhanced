package widgets.Gameplay.gamepad.adapters
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import olympus.utils.InputUtils;
   import olympus.utils.LibraryUtils;
   import olympus.utils.SystemUtils;
   import scaleform.gfx.Extensions;
   import widgets.Gameplay.gamepad.GameplayActionCodes;
   
   public class GameplayCenterMainAdapter extends GameplayCenterAdapterBase
   {
      
      protected var mbLiveDrag:Boolean = false;
      
      public function GameplayCenterMainAdapter()
      {
         super();
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.BEGIN_DRAG_ITEM)).CallFunction(this.BeginLiveDrag).SetLegendKey(KeysConsole.LIVE_DRAG_ITEM).SetValidCheck(this.CanLiveDrag);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.CANCEL_ACTION)).DispatchUIMessage("RemoveCurrentInteractions").SetLegendKey(KeysConsole.LIVE_CANCEL_CURRENT_ACTION);
         AddInputActions([_loc1_,_loc2_]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         AddMessageListener("LiveDragStarted",this.HandleLiveDragStarted);
         if(this.mbLiveDrag)
         {
            this.mbLiveDrag = false;
         }
         else
         {
            FireMouseMoveEvent();
         }
         return super.OnEntered(param1);
      }
      
      protected function HandleLiveDragStarted(param1:Object) : void
      {
         if(!SystemUtils.UsingController)
         {
            return;
         }
         if(NavManager.Instance.CurrentWidgetName == "PieMenu")
         {
            CommunicationManager.SendUIMessage("HidePieMenu");
         }
         if(NavManager.Instance.CurrentWidgetName == "ControllerLegend")
         {
            CommunicationManager.CallGameService("GamepadMouseDragCancel");
            return;
         }
         this.mbLiveDrag = true;
         NavManager.Instance.FocusForward(new GameplayCenterDragAdapter());
      }
      
      protected function BeginLiveDrag() : void
      {
         var _loc1_:DisplayObject = Extensions.getTopMostEntity(InputUtils.sMouseX,InputUtils.sMouseY,true);
         var _loc2_:Class = LibraryUtils.GetClass("widgets.Gameplay.SimInfoHUD.InventoryPanel.InventoryCellViewButton");
         if(Boolean(_loc2_) && _loc1_ is _loc2_)
         {
            CommunicationManager.SendUIMessage("BeginInventoryLiveDrag",_loc1_);
         }
         else
         {
            CommunicationManager.CallGameService("GamepadMouseDragStart");
         }
      }
      
      protected function CanLiveDrag() : Boolean
      {
         var _loc1_:DisplayObject = Extensions.getTopMostEntity(InputUtils.sMouseX,InputUtils.sMouseY,true);
         var _loc2_:Class = LibraryUtils.GetClass("widgets.Gameplay.SimInfoHUD.InventoryPanel.InventoryCellViewButton");
         var _loc3_:Boolean = Boolean(CommunicationManager.CallUIService("IsWidgetVisible","ControllerLegend"));
         return !_loc1_ || _loc1_ is Stage || _loc2_ && _loc1_ is _loc2_ || _loc3_;
      }
   }
}

