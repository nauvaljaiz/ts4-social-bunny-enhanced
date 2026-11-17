package widgets.Gameplay.gamepad.adapters
{
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.CenterInputAdapterBase;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.Gameplay.gamepad.GameplayActionCodes;
   
   public class GameplayCenterAdapterBase extends CenterInputAdapterBase
   {
      
      private var mIsFollowEnabled:Boolean = false;
      
      public function GameplayCenterAdapterBase()
      {
         super();
         mbRestoreCursorPosition = false;
      }
      
      public function HandleNotifyMainCameraCenterOnObject(param1:Object) : void
      {
         this.mIsFollowEnabled = param1["followEnabled"];
      }
      
      public function IsFollowInputActionValid() : Boolean
      {
         return !this.mIsFollowEnabled && !CommunicationManager.CallGameService("IsUsingCameraControllerFPS",null);
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddSharedCameraActions();
         CommunicationManager.AddMessageListenerByName("NotifyMainCameraCenterOnObject",this.HandleNotifyMainCameraCenterOnObject,"GameplayCenterAdapterBase");
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.TOGGLE_FOLLOW_SIM,false)).DispatchUIMessage("RequestToggleFollowSelectedSim").SetLegendKey(KeysConsole.LIVE_SS_SNAP_TO_SIM).SetValidCheck(this.IsFollowInputActionValid);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.CYCLE_SIM)).CallGameService("SelectNextSim").SetLegendKey(KeysConsole.LIVE_TOGGLE_SIM).SetValidCheckGameService("IsUsingCameraControllerFPS",null,false);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.TOGGLE_FOLLOW_SIM)).CallGameService("SnapCameraToFPV").SetLegendKey(KeysConsole.RESET_CAMERA_FPV).SetValidCheckGameService("IsUsingCameraControllerFPS",null,true);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.FPV_INTERACTION)).SetLegendKey(KeysConsole.RIGHT_CLICK).SetValidCheckGameService("IsUsingCameraControllerFPS",null,true);
         AddInputActions([_loc1_,_loc3_,_loc2_,_loc4_]);
      }
      
      protected function ShouldShowNextSimQuickLegend() : Boolean
      {
         return false;
      }
   }
}

