package widgets.BuildBuy.gamepad.adapters
{
   import gamedata.BuildBuy.Context.ContextData;
   import gamedata.BuildBuy.constants.ProductTypes;
   import gamedata.BuildBuy.shared.ProductFilter;
   import olympus.constants.ActionCodes;
   import olympus.constants.InputActionPriorities;
   import olympus.events.TickerEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.GamepadAnalogSticks;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.CenterInputAdapterBase;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.utils.Clamp;
   import olympus.utils.InputUtils;
   import olympus.utils.TuningTagsUtils;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.constants.PlacementModes;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterAdapterBase extends CenterInputAdapterBase
   {
      
      protected static var sMainInputAdapter:BuildBuyCenterMainAdapter;
      
      protected static var mStoredMousePosX:int = -1;
      
      protected static var mStoredMousePosY:int = -1;
      
      public static const RESTRAINT_MODE_FULLSCREEN:uint = 0;
      
      public static const RESTRAINT_MODE_BB_BOTTOM_OPEN:uint = 1;
      
      protected static var sRestraintMode:uint = RESTRAINT_MODE_FULLSCREEN;
      
      protected var mbRoofIsSelected:Boolean = false;
      
      protected var mbStairsIsSelected:Boolean = false;
      
      protected var mHoldAction:InputAction;
      
      protected var mbCameraScrolling:Boolean = false;
      
      protected var mbUseFaceButtonRotate:Boolean = false;
      
      protected var mbBackButtonDown:Boolean = false;
      
      protected var mProductFilter:ProductFilter;
      
      public var mbShouldSwitchBackToMainAdapterWhenObjectDeselected:Boolean = false;
      
      public var mbShouldFocusBackWhenObjectDeselected:Boolean = false;
      
      protected var mBottomMargin:int = 0;
      
      protected var mbRotatingLeft:Boolean;
      
      protected var mbRotatingRight:Boolean;
      
      protected var mbDoingFreeRotation:Boolean;
      
      protected var mbBlockUndoRedoLeft:Boolean;
      
      protected var mbBlockUndoRedoRight:Boolean;
      
      public function BuildBuyCenterAdapterBase()
      {
         super();
         mbDisableUIMouseInput = false;
         mbRestoreCursorPosition = false;
         IgnoreDefaultAction(ActionCodes.BACK);
      }
      
      protected static function SwitchToMainAdapter() : void
      {
         NavManager.Instance.FocusBackToFirst();
         if(!(NavManager.Instance.CurrentFocusable is BuildBuyCenterMainAdapter))
         {
            if(sMainInputAdapter == null)
            {
               sMainInputAdapter = new BuildBuyCenterMainAdapter();
            }
            NavManager.Instance.FocusPan(sMainInputAdapter);
         }
      }
      
      public static function GetAdapterForProduct(param1:ProductFilter, param2:Boolean) : BuildBuyCenterAdapterBase
      {
         var _loc3_:BuildBuyCenterAdapterBase = null;
         switch(param1.productType)
         {
            case ProductTypes.TERRAINPAINT:
            case ProductTypes.TERRAINSCULPT:
            case ProductTypes.POND:
               _loc3_ = new BuildBuyCenterTerrainPaintingAdapter();
               break;
            case ProductTypes.FLOOR_PATTERN:
               _loc3_ = new BuildBuyCenterPatternAdapter();
               break;
            case ProductTypes.ROOF_PATTERN:
            case ProductTypes.FLOOR_EDGE_PATTERN:
            case ProductTypes.CEILING_PATTERN:
            case ProductTypes.CEILING_RAIL:
            case ProductTypes.FLOOR_TRIM:
            case ProductTypes.RAILING:
            case ProductTypes.FRIEZE:
            case ProductTypes.ROOF_TRIM:
            case ProductTypes.FOUNTAIN_TRIM:
            case ProductTypes.POOL_TRIM:
            case ProductTypes.HALFWALL_TRIM:
            case ProductTypes.PLATFORM_TRIM:
               _loc3_ = new BuildBuyCenterWallAdapter();
               break;
            case ProductTypes.WALL_PATTERN:
               _loc3_ = new BuildBuyCenterWallAdapter();
               _loc3_.SetMouseButtonActions(VirtualCursorInputAdapter.MOUSEACTION_DOWN,VirtualCursorInputAdapter.MOUSEACTION_UP);
               break;
            case ProductTypes.ROOF:
            case ProductTypes.STAIR:
               _loc3_ = new BuildBuyCenterWallAdapter().SetAllowRotate(true);
               break;
            case ProductTypes.FOUNDATION:
               _loc3_ = new BuildBuyCenterFoundationAdapter();
               break;
            case ProductTypes.WALL:
            case ProductTypes.FENCE:
               _loc3_ = new BuildBuyCenterWallAdapter().SetAllowDeleteMode(param1.placementMode != PlacementModes.PLACEMENT_SINGLE).SetAllowRotate(param1.placementMode != PlacementModes.PLACEMENT_SINGLE);
               break;
            case ProductTypes.BLOCK:
               _loc3_ = new BuildBuyCenterWallAdapter().SetAllowDeleteMode(true).SetAllowRotate(true);
               break;
            default:
               _loc3_ = new BuildBuyCenterProductSelectedAdapter();
         }
         _loc3_.mProductFilter = param1;
         if(!param2)
         {
            _loc3_.mbShouldSwitchBackToMainAdapterWhenObjectDeselected = true;
         }
         else if(!param1.IsBuildWindow)
         {
            _loc3_.mbShouldFocusBackWhenObjectDeselected = true;
         }
         return _loc3_;
      }
      
      protected static function CheckFilterHasCategory(param1:ProductFilter, param2:uint) : Boolean
      {
         return param1.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(param2)) != -1;
      }
      
      public static function SetRestraintMode(param1:uint) : void
      {
         sRestraintMode = param1;
      }
      
      public static function CenterCursor() : void
      {
         var _loc1_:BuildBuyCenterAdapterBase = NavManager.Instance.CurrentFocusable as BuildBuyCenterAdapterBase;
         if(_loc1_)
         {
            _loc1_.CenterVirtualCursor();
         }
      }
      
      public function SetUseFaceButtonForRotation(param1:Boolean) : void
      {
         this.mbUseFaceButtonRotate = param1;
      }
      
      protected function SwitchBackToMainAdapterWhenObjectDeselectedCallback(param1:Object) : void
      {
         if(!param1)
         {
            BuildBuyCenterAdapterBase.SwitchToMainAdapter();
         }
      }
      
      protected function FocusBackWhenObjectDeselectedCallback(param1:Object) : void
      {
         if(!param1)
         {
            NavManager.Instance.FocusBack();
         }
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         this.AddSharedCameraAndViewActions();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_GRID)).CallGameService("ToggleBuildBuyGrid").SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_GRID);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.BACK,true)).CallFunction(this.OnBackStart).SetLegendKey(Keys.GENERIC_BACK);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.BACK,false)).CallFunction(this.OnBackComplete);
         this.mHoldAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.REDESIGN,true)).CallFunction(this.OnHoldButtonDown).SetValidCheck(this.HoldActionValid);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.REDESIGN,false)).CallFunction(this.OnHoldButtonUp).SetValidCheck(this.HoldActionValid);
         if(this.mbShouldSwitchBackToMainAdapterWhenObjectDeselected)
         {
            OnBackCall(BuildBuyCenterAdapterBase.SwitchToMainAdapter);
         }
         AddInputActions([_loc1_,_loc2_,_loc3_,this.mHoldAction,_loc4_]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         CommunicationManager.SendUIMessage("CloseNotificationWall");
         CommunicationManager.AddMessageListenerByName("CameraScrolling",this.OnCameraScrolling,"BuildBuyCenterAdapterBase");
         if(this.mbShouldFocusBackWhenObjectDeselected)
         {
            AddMessageListener("BBShowProductInfo",this.FocusBackWhenObjectDeselectedCallback);
         }
         else if(this.mbShouldSwitchBackToMainAdapterWhenObjectDeselected)
         {
            AddMessageListener("BBShowProductInfo",this.SwitchBackToMainAdapterWhenObjectDeselectedCallback);
         }
         AddMessageListener("BBShowContext",this.OnShowContextUI);
         this.SetBottomMargin();
         NavManager.Instance.RegisterAllowedNonRootInputAdapter(this);
         return super.OnEntered(param1);
      }
      
      public function EnsureCursorIsInBounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(mRestraints)
         {
            _loc1_ = mStoredMousePosX;
            _loc2_ = mStoredMousePosY;
            _loc3_ = this.mBottomMargin > 0 ? this.mBottomMargin : int(mRestraints.top + mRestraints.height);
            mStoredMousePosX = Clamp.Int(mStoredMousePosX,mRestraints.left,mRestraints.left + mRestraints.width);
            mStoredMousePosY = Clamp.Int(mStoredMousePosY,mRestraints.top,_loc3_);
            if(_loc1_ != mStoredMousePosX || _loc2_ != mStoredMousePosY)
            {
               SetVirtualCursorPosition(mStoredMousePosX,mStoredMousePosY);
            }
         }
      }
      
      override protected function SetupRestraintsFromNavigation() : Boolean
      {
         this.SetBottomMargin();
         if(super.SetupRestraintsFromNavigation())
         {
            if(mStoredMousePosX == -1)
            {
               CenterVirtualCursor();
            }
            else
            {
               SetVirtualCursorPosition(mStoredMousePosX,mStoredMousePosY);
            }
            return true;
         }
         return false;
      }
      
      protected function SetBottomMargin() : void
      {
         if(sRestraintMode == RESTRAINT_MODE_FULLSCREEN)
         {
            this.mBottomMargin = 0;
         }
         else if(sRestraintMode == RESTRAINT_MODE_BB_BOTTOM_OPEN)
         {
            this.mBottomMargin = CommunicationManager.CallUIService("GetNavigationUpperBound") as Number;
         }
      }
      
      protected function OnShowContextUI(param1:Object) : void
      {
         var _loc2_:ContextData = param1 as ContextData || new ContextData(param1);
         switch(_loc2_.contextType)
         {
            case ContextData.CONTEXT_ROOF:
               this.mbRoofIsSelected = _loc2_.id != -1;
               this.mHoldAction.SetLegendKey(this.mbRoofIsSelected ? KeysConsole.BUILDBUY_INDEPENDENT_EAVES : KeysConsole.SELECTIONMODE_DESIGN_TOOL);
               break;
            case ContextData.CONTEXT_STAIRS:
               this.mbStairsIsSelected = _loc2_.id != -1;
               this.mHoldAction.SetLegendKey(this.mbStairsIsSelected ? KeysConsole.BUILDBUY_INDEPENDENT_FLARE_STAIRS : KeysConsole.SELECTIONMODE_DESIGN_TOOL);
         }
         InputActionManager.NotifyRegisteredActionsChanged();
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.EndBlockUndoRedoLeft();
         this.EndBlockUndoRedoRight();
         return super.Enter(param1);
      }
      
      override public function Exit() : void
      {
         NavManager.Instance.UnregisterAllowedNonRootInputAdapter(this);
         if(this.mbShouldSwitchBackToMainAdapterWhenObjectDeselected)
         {
            RemoveMessageListener("BBShowProductInfo",this.SwitchBackToMainAdapterWhenObjectDeselectedCallback);
         }
         if(this.mbShouldFocusBackWhenObjectDeselected)
         {
            RemoveMessageListener("BBShowProductInfo",this.FocusBackWhenObjectDeselectedCallback);
         }
         RemoveMessageListener("BBShowContext",this.OnShowContextUI);
         this.mbRoofIsSelected = false;
         this.mbStairsIsSelected = false;
         CommunicationManager.RemoveMessageListenerByName("CameraScrolling",this.OnCameraScrolling,"BuildBuyCenterAdapterBase");
         mStoredMousePosX = InputUtils.sMouseX;
         mStoredMousePosY = InputUtils.sMouseY;
         this.SetFreeRotate(false);
         super.Exit();
      }
      
      override protected function GetBottomMarginPosition() : Number
      {
         return this.mBottomMargin;
      }
      
      protected function OnBackStart() : void
      {
         this.mbCameraScrolling = false;
         this.mbBackButtonDown = true;
      }
      
      protected function OnBackComplete() : void
      {
         this.EndPlacingClonedObject();
         if(!this.mbCameraScrolling && this.mbBackButtonDown)
         {
            HandleBack();
         }
         this.mbBackButtonDown = false;
      }
      
      override protected function Back() : void
      {
         super.Back();
         CommunicationManager.CallGameService("BBCancelUserTool");
         CommunicationManager.SendUIMessage("BBInspectorHideMoveToolPanel");
      }
      
      protected function ToggleLotView() : void
      {
         var _loc1_:Boolean = CommunicationManager.CallGameService("GetCameraLotView") as Boolean;
         if(_loc1_)
         {
            CommunicationManager.CallGameService("CameraLeaveLotView");
         }
         else
         {
            CommunicationManager.CallGameService("CameraEnterLotView");
         }
      }
      
      protected function OnCameraScrolling() : void
      {
         this.mbCameraScrolling = true;
      }
      
      protected function HoldActionValid() : Boolean
      {
         return this.mbRoofIsSelected || this.mbStairsIsSelected;
      }
      
      protected function OnHoldButtonDown() : void
      {
         if(this.mbRoofIsSelected)
         {
            CommunicationManager.CallGameService("BBSetIndependentEaves",true);
         }
         else if(this.mbStairsIsSelected)
         {
            CommunicationManager.CallGameService("BBSetAsymmetricalFlaring",true);
         }
      }
      
      protected function OnHoldButtonUp() : void
      {
         if(this.mbRoofIsSelected)
         {
            CommunicationManager.CallGameService("BBSetIndependentEaves",false);
         }
         else if(this.mbStairsIsSelected)
         {
            CommunicationManager.CallGameService("BBSetAsymmetricalFlaring",false);
         }
      }
      
      public function AddObjectRotateActions(param1:Boolean = false) : void
      {
         var _loc2_:InputAction = null;
         var _loc3_:InputAction = null;
         var _loc4_:InputAction = null;
         var _loc5_:InputAction = null;
         var _loc6_:InputAction = null;
         var _loc7_:InputAction = null;
         var _loc8_:InputAction = null;
         if(this.mbUseFaceButtonRotate)
         {
            _loc2_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.ALT_ROTATE_OBJECT)).CallGameService("BBRotateSelectedObject",{"value":1}).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLegendKey(KeysConsole.OBJECT_ROTATE);
            AddInputAction(_loc2_);
         }
         else if(param1)
         {
            _loc3_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT)).CallFunction(this.RotateLeft).SetLegendKey(KeysConsole.OBJECT_ROTATE).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            _loc4_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT)).CallFunction(this.RotateRight).SetLegendKey(KeysConsole.OBJECT_ROTATE).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            AddInputActions([_loc3_,_loc4_]);
         }
         else
         {
            _loc5_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT)).CallFunction(this.StartRotateLeft).SetLegendKey(KeysConsole.OBJECT_ROTATE).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            _loc6_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT,false)).CallFunction(this.EndRotateLeft).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            _loc7_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT)).CallFunction(this.StartRotateRight).SetLegendKey(KeysConsole.OBJECT_ROTATE).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            _loc8_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT,false)).CallFunction(this.EndRotateRight).SetLegendKey(KeysConsole.OBJECT_ROTATE).SetPriority(InputActionPriorities.BUILDBUY_ROTATE_PRIORITY).SetKillPropagation(true).SetLinkedInLegend(true);
            AddInputActions([_loc5_,_loc6_,_loc7_,_loc8_]);
         }
      }
      
      protected function RotateLeft() : void
      {
         CommunicationManager.CallGameService("BBRotateSelectedObject",{"value":-1});
      }
      
      protected function RotateRight() : void
      {
         CommunicationManager.CallGameService("BBRotateSelectedObject",{"value":1});
      }
      
      protected function StartRotateLeft() : void
      {
         this.mbRotatingLeft = true;
         this.SetFreeRotate(this.mbRotatingRight);
      }
      
      protected function EndRotateLeft() : void
      {
         if(!this.mbRotatingLeft)
         {
            return;
         }
         this.mbRotatingLeft = false;
         if(this.mbDoingFreeRotation)
         {
            this.SetFreeRotate(false);
            this.mbRotatingRight = false;
         }
         else
         {
            CommunicationManager.CallGameService("BBRotateSelectedObject",{"value":-1});
         }
      }
      
      protected function StartRotateRight() : void
      {
         this.mbRotatingRight = true;
         this.SetFreeRotate(this.mbRotatingLeft);
      }
      
      protected function EndRotateRight() : void
      {
         if(!this.mbRotatingRight)
         {
            return;
         }
         this.mbRotatingRight = false;
         if(this.mbDoingFreeRotation)
         {
            this.SetFreeRotate(false);
            this.mbRotatingLeft = false;
         }
         else
         {
            CommunicationManager.CallGameService("BBRotateSelectedObject",{"value":1});
         }
      }
      
      protected function SetFreeRotate(param1:Boolean) : void
      {
         this.mbDoingFreeRotation = param1;
         CommunicationManager.SendUIMessage("GamestateAllowCameraZoomAndRotate",!this.mbDoingFreeRotation);
      }
      
      override protected function Tick(param1:TickerEvent) : void
      {
         super.Tick(param1);
         if(this.mbDoingFreeRotation)
         {
            CommunicationManager.CallGameService("BBGamepadFreeRotate",-GamepadAnalogSticks.GetRightStickValuesWithDeadzone().x * param1.deltaTime * BBTunables.CONTROLLER_FREE_ROTATE_SPEED);
         }
      }
      
      protected function AddObjectSharedActions() : void
      {
         this.AddObjectRotateActions();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CYCLE_SNAP_SIZE)).CallFunction(this.CycleGridSnapSize).SetLegendKey(KeysConsole.OBJECT_TOGGLE_GRID_SNAP);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_GRID_ALT)).CallFunction(this.ToggleGridIfNotUsingCheats).SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_GRID);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHEATS_INCREASE_SCALE)).CallFunction(this.IncreaseScaleIfUsingCheats);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHEATS_DECREASE_SCALE)).CallFunction(this.DecreaseScaleIfUsingCheats);
         var _loc5_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHEATS_RAISE_OBJECT)).CallFunction(this.RaiseObjectIfUsingCheats);
         var _loc6_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.CHEATS_LOWER_OBJECT)).CallFunction(this.LowerObjectIfUsingCheats);
         AddInputActions([_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_]);
      }
      
      protected function CycleGridSnapSize() : void
      {
         if(!BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("BBCycleSnapSize");
         }
      }
      
      protected function ToggleGridIfNotUsingCheats() : void
      {
         if(!BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("ToggleBuildBuyGrid");
         }
      }
      
      protected function IncreaseScaleIfUsingCheats() : void
      {
         if(BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("BBIncreaseObjectScale");
         }
      }
      
      protected function DecreaseScaleIfUsingCheats() : void
      {
         if(BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("BBDecreaseObjectScale");
         }
      }
      
      protected function RaiseObjectIfUsingCheats() : void
      {
         if(BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("BBMoveObjectVerticallyUp");
         }
      }
      
      protected function LowerObjectIfUsingCheats() : void
      {
         if(BuildBuyGameStateAdapter.CheatsActive)
         {
            CommunicationManager.CallGameService("BBMoveObjectVerticallyDown");
         }
      }
      
      override protected function GoUpOneFloor() : void
      {
         if(!BuildBuyGameStateAdapter.CheatsActive)
         {
            super.GoUpOneFloor();
         }
      }
      
      override protected function GoDownOneFloor() : void
      {
         if(!BuildBuyGameStateAdapter.CheatsActive)
         {
            super.GoDownOneFloor();
         }
      }
      
      protected function AddSharedCameraAndViewActions() : void
      {
         AddSharedCameraActions();
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOGGLE_LOT_VIEW)).CallFunction(this.ToggleLotView).SetLegendKey(KeysConsole.BUILDBUY_TOGGLE_TOPDOWN_VIEW).SetValidCheck(this.ToggleLotViewValidCheck);
         AddInputAction(_loc1_);
      }
      
      protected function ToggleLotViewValidCheck() : Boolean
      {
         return !BuildBuyGameStateAdapter.CheatsActive;
      }
      
      protected function AddUndoRedoActions() : void
      {
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.UNDO)).CallGameService("BBOpCommand","undo").DispatchUIMessage("BBUndoRedo").SetValidCheck(this.CanUndoAndRedo).SetLinkedInLegend(true).SetLegendKey(KeysConsole.GENERIC_UNDO).SetQuickLegendKey(KeysConsole.GENERIC_UNDO_REDO);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.REDO)).CallGameService("BBOpCommand","redo").DispatchUIMessage("BBUndoRedo").SetValidCheck(this.CanUndoAndRedo).SetLinkedInLegend(true).SetLegendKey(KeysConsole.GENERIC_REDO);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT)).CallFunction(this.StartBlockUndoRedoLeft);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT,false)).CallFunction(this.EndBlockUndoRedoLeft);
         var _loc5_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT)).CallFunction(this.StartBlockUndoRedoRight);
         var _loc6_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT,false)).CallFunction(this.EndBlockUndoRedoRight);
         AddInputActions([_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_]);
      }
      
      protected function CanUndoAndRedo() : Boolean
      {
         return !this.mbBlockUndoRedoLeft && !this.mbBlockUndoRedoRight;
      }
      
      protected function StartBlockUndoRedoLeft() : void
      {
         this.mbBlockUndoRedoLeft = true;
      }
      
      protected function EndBlockUndoRedoLeft() : void
      {
         this.mbBlockUndoRedoLeft = false;
      }
      
      protected function StartBlockUndoRedoRight() : void
      {
         this.mbBlockUndoRedoRight = true;
      }
      
      protected function EndBlockUndoRedoRight() : void
      {
         this.mbBlockUndoRedoRight = false;
      }
      
      protected function AddCloneObjectActions() : void
      {
         var _loc1_:InputAction = null;
         if(!this.mbUseFaceButtonRotate)
         {
            _loc1_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.PLACE_CLONED_OBJECT)).CallFunction(this.PlaceClonedObject).SetLegendKey(KeysConsole.OBJECT_PLACE_MULTIPLES);
            AddInputAction(_loc1_);
         }
         OnConfirmCall(this.EndPlacingClonedObject);
      }
      
      protected function PlaceClonedObject() : void
      {
         CommunicationManager.CallGameService("BBGamepadPlaceMultiple",true);
         CommunicationManager.CallGameService("SendVirtualCursorClick");
      }
      
      protected function EndPlacingClonedObject() : void
      {
         CommunicationManager.CallGameService("BBGamepadPlaceMultiple",false);
      }
      
      override public function IsZoomAllowed() : Boolean
      {
         return BuildBuyGameStateAdapter.sbAllowZoomAndRotate;
      }
      
      override public function IsRotateAllowed() : Boolean
      {
         return BuildBuyGameStateAdapter.sbAllowZoomAndRotate;
      }
   }
}

