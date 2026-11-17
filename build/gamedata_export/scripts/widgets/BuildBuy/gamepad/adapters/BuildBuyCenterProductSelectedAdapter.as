package widgets.BuildBuy.gamepad.adapters
{
   import olympus.constants.ActionCodes;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterProductSelectedAdapter extends BuildBuyCenterAdapterBase
   {
      
      protected var mbCycleVariantEnabled:Boolean = true;
      
      public function BuildBuyCenterProductSelectedAdapter(param1:Boolean = true)
      {
         super();
         this.mbCycleVariantEnabled = param1;
      }
      
      override protected function InitializeInputs() : void
      {
         var _loc1_:InputAction = null;
         super.InitializeInputs();
         AddObjectSharedActions();
         AddCloneObjectActions();
         RemoveInputActionByCode(ActionCodes.CONFIRM);
         UpdateConfirmActionLegend(KeysConsole.LIVE_PLACE_OBJECT);
         if(this.mbCycleVariantEnabled)
         {
            _loc1_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CYCLE_VARIANT)).CallGameService("BBCycleVariant").SetLegendKey(KeysConsole.BUILDBUY_CHANGE_VARIANT);
            AddInputAction(_loc1_);
         }
      }
   }
}

