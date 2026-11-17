package widgets.BuildBuy.gamepad.adapters
{
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterPatternAdapter extends BuildBuyCenterAdapterBase
   {
      
      public function BuildBuyCenterPatternAdapter()
      {
         super();
         SetMouseButtonActions(MOUSEACTION_DOWN,MOUSEACTION_UP);
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         SetUseFaceButtonForRotation(false);
         AddUndoRedoActions();
         AddObjectRotateActions();
         SetConfirmActionLegend(KeysConsole.BUILDBUY_PLACE);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_TILE_SIZE)).CallGameService("BBToggleQuarterTile").SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_TILE_SIZE);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_PATTERN_TOOL)).SetValidCheckUIService("CanCyclePatternTool").DispatchUIMessage("CyclePatternTool").SetLegendKey(KeysConsole.TERRAIN_PAINT_CYCLE_TOOL);
         AddInputActions([_loc1_,_loc2_]);
      }
   }
}

