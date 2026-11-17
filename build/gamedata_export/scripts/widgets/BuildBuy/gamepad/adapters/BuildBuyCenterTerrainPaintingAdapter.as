package widgets.BuildBuy.gamepad.adapters
{
   import olympus.events.TickerEvent;
   import olympus.gamepad.EnterParams;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterTerrainPaintingAdapter extends BuildBuyCenterAdapterBase
   {
      
      protected var mBackButtonDownElapsed:Number = 0;
      
      protected var mbWaterDepthMapToggleButtonPressed:Boolean = false;
      
      protected var mbControllerOverlayVisible:Boolean = false;
      
      protected var toggleWaterDepthMapOnAction:InputAction;
      
      protected var toggleWaterDepthMapOffAction:InputAction;
      
      protected var decreaseSizeAction:InputAction;
      
      protected var increaseSizeAction:InputAction;
      
      protected var changeShapeDownAction:InputAction;
      
      protected var changeShapeUpAction:InputAction;
      
      public function BuildBuyCenterTerrainPaintingAdapter()
      {
         super();
         SetMouseButtonActions(MOUSEACTION_DOWN,MOUSEACTION_UP);
      }
      
      override protected function InitializeInputs() : void
      {
         var toggleTerrainAction:InputAction;
         var decreaseSliderAction:InputAction;
         var increaseSliderAction:InputAction;
         var toggleTerrainSlider:InputAction;
         super.InitializeInputs();
         AddUndoRedoActions();
         SetConfirmActionLegend(KeysConsole.TERRAIN_PAINT_PAINT);
         this.toggleWaterDepthMapOnAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_WATER_DEPTH_MAP_ON,true)).SetValidCheck(function():Boolean
         {
            return mbBackButtonDown;
         }).CallFunction(this.OnToggleWaterDepthMap);
         this.toggleWaterDepthMapOffAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_WATER_DEPTH_MAP_OFF,true)).SetValidCheck(function():Boolean
         {
            return mbBackButtonDown;
         }).CallFunction(this.OnToggleWaterDepthMap);
         this.decreaseSizeAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.DECREASE_TERRAIN_BRUSH_SIZE)).SetValidCheck(function():Boolean
         {
            return !mbBackButtonDown;
         }).DispatchUIMessage("TerrainPaintNavigateBrushes",{
            "x":-1,
            "y":0
         }).SetLegendKey(KeysConsole.TERRAIN_PAINT_CHANGE_BRUSH_SIZE_PREVIOUS);
         this.increaseSizeAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.INCREASE_TERRAIN_BRUSH_SIZE)).SetValidCheck(function():Boolean
         {
            return !mbBackButtonDown;
         }).DispatchUIMessage("TerrainPaintNavigateBrushes",{
            "x":1,
            "y":0
         }).SetLegendKey(KeysConsole.TERRAIN_PAINT_CHANGE_BRUSH_SIZE_NEXT);
         this.changeShapeDownAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHANGE_BRUSH_SHAPE_DOWN)).SetValidCheck(function():Boolean
         {
            return !mbBackButtonDown;
         }).DispatchUIMessage("TerrainPaintNavigateBrushes",{
            "x":0,
            "y":1
         }).SetLegendKey(KeysConsole.TERRAIN_PAINT_CHANGE_BRUSH_SHAPE_PREVIOUS);
         this.changeShapeUpAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHANGE_BRUSH_SHAPE_UP)).SetValidCheck(function():Boolean
         {
            return !mbBackButtonDown;
         }).DispatchUIMessage("TerrainPaintNavigateBrushes",{
            "x":0,
            "y":-1
         }).SetLegendKey(KeysConsole.TERRAIN_PAINT_CHANGE_BRUSH_SHAPE_NEXT);
         toggleTerrainAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_TERRAIN_TOOL)).DispatchUIMessage("TerrainPaintToggleTool").SetLegendKey(KeysConsole.TERRAIN_PAINT_CYCLE_TOOL);
         decreaseSliderAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.DECREASE_TERRAIN_SLIDER)).DispatchUIMessage("TerrainPaintAdjustSlider",-1).SetValidCheckUIService("CanTerrainPaintAdjustSlider");
         increaseSliderAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.INCREASE_TERRAIN_SLIDER)).DispatchUIMessage("TerrainPaintAdjustSlider",1).SetValidCheckUIService("CanTerrainPaintAdjustSlider");
         toggleTerrainSlider = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_TERRAIN_SLIDER)).DispatchUIMessage("TerrainPaintToggleSlider").SetLegendKey(KeysConsole.TERRAIN_PAINT_CYCLE_SLIDER).SetValidCheckUIService("CanTerrainPaintToggleSlider");
         AddInputActions([this.toggleWaterDepthMapOnAction,this.toggleWaterDepthMapOffAction,this.decreaseSizeAction,this.increaseSizeAction,this.changeShapeDownAction,this.changeShapeUpAction,toggleTerrainAction,decreaseSliderAction,increaseSliderAction,toggleTerrainSlider]);
      }
      
      public function RegisterWaterDepthMapInputActions() : void
      {
         InputActionManager.AutoregisterActions([this.toggleWaterDepthMapOnAction,this.toggleWaterDepthMapOffAction]);
      }
      
      public function UnregisterWaterDepthMapInputActions() : void
      {
         InputActionManager.AutounregisterActions([this.toggleWaterDepthMapOnAction,this.toggleWaterDepthMapOffAction]);
      }
      
      public function RegisterBrushInputActions() : void
      {
         InputActionManager.AutoregisterActions([this.decreaseSizeAction,this.increaseSizeAction,this.changeShapeDownAction,this.changeShapeUpAction]);
      }
      
      public function UnregisterBrushInputActions() : void
      {
         InputActionManager.AutounregisterActions([this.decreaseSizeAction,this.increaseSizeAction,this.changeShapeDownAction,this.changeShapeUpAction]);
      }
      
      override protected function AddSharedCameraAndViewActions() : void
      {
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         var _loc2_:Object = {"adapter":this};
         CommunicationManager.SendUIMessage("UpdateTerrainPaintingAdapterLegend",_loc2_);
         AddMessageListener("PreFocusControllerLegend",this.OnPreFocusControllerLegend);
         AddMessageListener("HideControllerLegend",this.OnHideControllerLegend);
         return super.OnEntered(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         CommunicationManager.SendUIMessage("ExitedTerrainPaintingAdapter");
         RemoveMessageListener("PreFocusControllerLegend",this.OnPreFocusControllerLegend);
         RemoveMessageListener("HideControllerLegend",this.OnHideControllerLegend);
      }
      
      protected function OnPreFocusControllerLegend() : void
      {
         this.mbControllerOverlayVisible = true;
      }
      
      protected function OnHideControllerLegend() : void
      {
         this.mbControllerOverlayVisible = false;
      }
      
      override protected function OnBackComplete() : void
      {
         if((this.mBackButtonDownElapsed <= BBTunables.TERRAIN_PAINT_ADAPTER_BACK_BUTTON_ELAPSED_TIME || !mbCameraScrolling) && !this.mbControllerOverlayVisible && !this.mbWaterDepthMapToggleButtonPressed)
         {
            HandleBack();
            CommunicationManager.SendUIMessage("BackOutTerrainPaintingAdapter");
         }
         mbBackButtonDown = false;
         this.mbWaterDepthMapToggleButtonPressed = false;
         this.mbControllerOverlayVisible = false;
         this.mBackButtonDownElapsed = 0;
      }
      
      protected function OnToggleWaterDepthMap() : void
      {
         if(mbBackButtonDown)
         {
            this.mbWaterDepthMapToggleButtonPressed = true;
            CommunicationManager.SendUIMessage("PondWaterDepthMapToggle");
         }
      }
      
      override protected function Tick(param1:TickerEvent) : void
      {
         super.Tick(param1);
         if(mbBackButtonDown)
         {
            this.mBackButtonDownElapsed += param1.deltaTime;
         }
      }
   }
}

