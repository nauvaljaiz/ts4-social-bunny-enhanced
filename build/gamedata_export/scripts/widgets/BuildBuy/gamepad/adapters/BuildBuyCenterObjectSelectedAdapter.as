package widgets.BuildBuy.gamepad.adapters
{
   import olympus.constants.ActionCodes;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterObjectSelectedAdapter extends BuildBuyCenterAdapterBase
   {
      
      protected var mbCanPutInInventory:Boolean = false;
      
      public function BuildBuyCenterObjectSelectedAdapter(param1:Boolean = false)
      {
         super();
         this.mbCanPutInInventory = param1;
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddObjectSharedActions();
         SetConfirmActionLegend(KeysConsole.BUILDBUY_PLACE);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.DELETE)).CallGameService("BBDeleteSelectedObject").SetValidCheckGameService("BBCanDeleteSelectedObject").SetLegendKey(KeysConsole.BUILDBUY_INVENTORY_SELL);
         AddInputAction(_loc1_);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.STORE_IN_INVENTORY)).CallGameService("BBMoveSelectedObjectToInventory").SetLegendKey(KeysConsole.OBJECT_SEND_TO_HOUSEHOLD_INVENTORY).SetValidCheck(this.CanPlaceInInventory);
         AddInputAction(_loc2_);
      }
      
      protected function CanPlaceInInventory() : Boolean
      {
         return this.mbCanPutInInventory;
      }
   }
}

