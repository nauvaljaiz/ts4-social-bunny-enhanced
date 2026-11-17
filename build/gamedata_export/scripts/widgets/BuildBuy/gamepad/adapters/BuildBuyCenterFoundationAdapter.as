package widgets.BuildBuy.gamepad.adapters
{
   import olympus.constants.ActionCodes;
   import olympus.gamepad.EnterParams;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   import widgets.shared.controls.ToastNotification.ToastNotification;
   
   public class BuildBuyCenterFoundationAdapter extends BuildBuyCenterAdapterBase
   {
      
      public function BuildBuyCenterFoundationAdapter()
      {
         super();
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddUndoRedoActions();
         AddCloneObjectActions();
         RemoveInputActionByCode(ActionCodes.CONFIRM);
         UpdateConfirmActionLegend(KeysConsole.BUILDBUY_PLACE);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_FOUNDATION_PLACEMENT_MODE)).CallGameService("BBToggleFoundationWallMode").SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_ROOM_AND_WALL_MODE);
         AddInputAction(_loc1_);
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         CommunicationManager.AddMessageListenerByName("FoundationToggledToWallMode",this.HandleFoundationToggledToWallMode,"BuildBuyCenterFoundationAdapter");
         CommunicationManager.AddMessageListenerByName("FoundationToggledToRoomMode",this.HandleFoundationToggledToRoomMode,"BuildBuyCenterFoundationAdapter");
         return super.Enter(param1);
      }
      
      override public function Exit() : void
      {
         super.Exit();
         CommunicationManager.AddMessageListenerByName("FoundationToggledToWallMode",this.HandleFoundationToggledToWallMode,"BuildBuyCenterFoundationAdapter");
         CommunicationManager.AddMessageListenerByName("FoundationToggledToRoomMode",this.HandleFoundationToggledToRoomMode,"BuildBuyCenterFoundationAdapter");
      }
      
      protected function HandleFoundationToggledToWallMode() : void
      {
         CommunicationManager.SendUIMessage("ToastNotify",{
            "type":ToastNotification.TYPE_CLOBBER,
            "label":KeysConsole.BUILDBUY_TOGGLED_WALL_MODE,
            "isControllerFeedback":true
         });
      }
      
      protected function HandleFoundationToggledToRoomMode() : void
      {
         CommunicationManager.SendUIMessage("ToastNotify",{
            "type":ToastNotification.TYPE_CLOBBER,
            "label":KeysConsole.BUILDBUY_TOGGLED_ROOM_MODE,
            "isControllerFeedback":true
         });
      }
      
      protected function ToggleWallDelete() : void
      {
         CommunicationManager.CallGameService("BBToggleWallDeleteMode");
      }
   }
}

