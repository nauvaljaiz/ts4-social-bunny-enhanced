package widgets.Gameplay.gamepad.adapters
{
   import olympus.gamepad.EnterParams;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.GameStateAdapter;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import widgets.Gameplay.gamepad.GameplayActionCodes;
   
   public class GameplayStateAdapter extends GameStateAdapter
   {
      
      protected static var sInstance:GameplayStateAdapter;
      
      protected var mSelectAndFocusPreviousSimAction:InputAction;
      
      protected var mSelectAndFocusNextSimAction:InputAction;
      
      public function GameplayStateAdapter()
      {
         super();
      }
      
      protected static function ShouldShowNextSimQuickLegend() : Boolean
      {
         return false;
      }
      
      public static function IsSelectSimAllowed() : Boolean
      {
         if(Boolean(sInstance) && Boolean(IsCenterAdapterFocused))
         {
            return InputActionManager.CanInputActionTrigger(sInstance.mSelectAndFocusPreviousSimAction,true);
         }
         return false;
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         this.mSelectAndFocusPreviousSimAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.FOCUS_PREVIOUS_SIM)).DispatchUIMessage("CycleAndFocusPreviousSim").SetValidCheckUIService("IsNotInFreeCam").SetValidQuickLegendCheck(ShouldShowNextSimQuickLegend).SetLegendKey(KeysConsole.LIVE_SNAP_SIM_LEFT);
         this.mSelectAndFocusNextSimAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(GameplayActionCodes.FOCUS_NEXT_SIM)).DispatchUIMessage("CycleAndFocusNextSim").SetValidCheckUIService("IsNotInFreeCam").SetValidQuickLegendCheck(ShouldShowNextSimQuickLegend).SetLegendKey(KeysConsole.LIVE_SNAP_SIM_RIGHT);
         AddInputActions([this.mSelectAndFocusPreviousSimAction,this.mSelectAndFocusNextSimAction]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         var _loc2_:IInputFocusable = super.OnEntered(param1);
         if(_loc2_ == this)
         {
            sInstance = this;
         }
         return _loc2_;
      }
      
      override protected function OnExited() : void
      {
         sInstance = null;
         super.OnExited();
      }
   }
}

