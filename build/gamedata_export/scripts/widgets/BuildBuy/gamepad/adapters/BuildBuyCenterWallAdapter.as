package widgets.BuildBuy.gamepad.adapters
{
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterWallAdapter extends BuildBuyCenterAdapterBase
   {
      
      protected var mbAllowDeleteMode:Boolean;
      
      protected var mbAllowRotate:Boolean;
      
      public function BuildBuyCenterWallAdapter()
      {
         super();
      }
      
      public function SetAllowDeleteMode(param1:Boolean) : BuildBuyCenterWallAdapter
      {
         this.mbAllowDeleteMode = param1;
         return this;
      }
      
      public function SetAllowRotate(param1:Boolean) : BuildBuyCenterWallAdapter
      {
         this.mbAllowRotate = param1;
         return this;
      }
      
      override protected function InitializeInputs() : void
      {
         var _loc2_:InputAction = null;
         var _loc3_:InputAction = null;
         super.InitializeInputs();
         AddUndoRedoActions();
         SetConfirmActionLegend(KeysConsole.LIVE_PLACE_OBJECT);
         var _loc1_:Boolean = Boolean(CommunicationManager.CallUIService("BBContextIsWallToolClipVisible"));
         if(_loc1_ && this.mbAllowDeleteMode)
         {
            _loc2_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_WALL_DELETE_MODE)).CallFunction(this.ToggleWallDelete).SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_DELETE_MODE);
            AddInputAction(_loc2_);
         }
         else if(this.mbAllowRotate)
         {
            AddObjectRotateActions(true);
         }
         else
         {
            _loc3_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_PATTERN_TOOL)).SetValidCheckUIService("CanCyclePatternTool").DispatchUIMessage("CyclePatternTool").SetLegendKey(KeysConsole.TERRAIN_PAINT_CYCLE_TOOL);
            AddInputAction(_loc3_);
         }
      }
      
      protected function ToggleWallDelete() : void
      {
         CommunicationManager.CallGameService("BBToggleWallDeleteMode");
      }
   }
}

