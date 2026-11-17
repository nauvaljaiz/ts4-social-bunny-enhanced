package olympus.input.adapters
{
   import olympus.constants.ActionCodes;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   
   public class GameStateAdapter extends InputAdapter
   {
      
      public function GameStateAdapter()
      {
         super();
      }
      
      public static function IsCenterAdapterFocused() : Boolean
      {
         return NavManager.Instance.CurrentFocusable is CenterInputAdapterBase;
      }
      
      public static function IsCameraZoomAllowed() : Boolean
      {
         if(CommunicationManager.CallGameService("IsUsingCameraControllerFPS"))
         {
            return IsCenterAdapterFocused();
         }
         return NavManager.Instance.IsAtRoot || IsCenterAdapterFocused();
      }
      
      public static function IsCameraRotateAllowed() : Boolean
      {
         return NavManager.Instance.IsAtRoot || IsCenterAdapterFocused();
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.RIGHT_STICK_MOVE_FAKE)).SetLegendKey(KeysConsole.ZOOM_ROTATE_CAMERA).SetValidCheck(this.IsZoomAndRotateAllowed);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.RIGHT_STICK_MOVE_FAKE)).SetLegendKey(KeysConsole.FREECAM_ROTATE_CAMERA).SetValidCheck(this.IsRotateAllowedFPV);
         AddInputActions([_loc1_,_loc2_]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         var _loc2_:IInputFocusable = super.OnEntered(param1);
         NavManager.Instance.NotifyCameraController();
         return _loc2_;
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         NavManager.Instance.NotifyCameraController();
      }
      
      protected function IsZoomAndRotateAllowed() : Boolean
      {
         return IsCameraRotateAllowed() && IsCameraZoomAllowed() && !CommunicationManager.CallGameService("IsUsingCameraControllerFPS");
      }
      
      protected function IsRotateAllowedFPV() : Boolean
      {
         return IsCameraRotateAllowed() && Boolean(CommunicationManager.CallGameService("IsUsingCameraControllerFPS"));
      }
   }
}

