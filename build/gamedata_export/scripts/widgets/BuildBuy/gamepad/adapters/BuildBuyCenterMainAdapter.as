package widgets.BuildBuy.gamepad.adapters
{
   import gamedata.BuildBuy.Context.ContextData;
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.BuildBuy.constants.FilterCategories;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductFilter;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import olympus.utils.ArrayUtils;
   import olympus.utils.TuningTagsUtils;
   import widgets.BuildBuy.constants.ActionModes;
   import widgets.BuildBuy.gamepad.BuildBuyActionCodes;
   
   public class BuildBuyCenterMainAdapter extends BuildBuyCenterAdapterBase
   {
      
      protected static var sInstance:BuildBuyCenterMainAdapter;
      
      protected var mbEyedropperActive:Boolean = false;
      
      protected var mbRedesignActive:Boolean = false;
      
      protected var mbBlockContextMenuActive:Boolean;
      
      protected var mEyedropperOrSellDownAction:InputAction;
      
      protected var mPreviousToolAction:InputAction;
      
      protected var mNextToolAction:InputAction;
      
      public function BuildBuyCenterMainAdapter()
      {
         super();
      }
      
      public static function IsToolTabbingAllowed() : Boolean
      {
         if(Boolean(sInstance) && Boolean(NavManager.Instance.CurrentFocusable is BuildBuyCenterMainAdapter) && Boolean(sInstance.mPreviousToolAction))
         {
            return InputActionManager.CanInputActionTrigger(sInstance.mPreviousToolAction,true);
         }
         return false;
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         AddUndoRedoActions();
         this.mEyedropperOrSellDownAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.EYEDROPPER_OR_DELETE_ROOM,true)).CallFunction(this.OnSellRoomOrUseEyedropperButtonDown).SetValidCheck(this.CanSellRoomOrUseEyedropper).SetLegendKey(KeysConsole.SELECTIONMODE_EYEDROPPER_TOOL);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.EYEDROPPER_OR_DELETE_ROOM,false)).CallFunction(this.OnEyedropperButtonUp);
         this.mPreviousToolAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOOL_PREVIOUS)).DispatchUIMessage("BBInspectorPreviousTool").SetValidQuickLegendCheck(this.NotValidForQuickLegend).SetLegendKey(KeysConsole.SELECTIONMODE_PREVIOUS_QUICK_TOOL);
         this.mNextToolAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.TOOL_NEXT)).DispatchUIMessage("BBInspectorNextTool").SetValidQuickLegendCheck(this.NotValidForQuickLegend).SetLegendKey(KeysConsole.SELECTIONMODE_NEXT_QUICK_TOOL);
         AddInputActions([this.mEyedropperOrSellDownAction,_loc1_,this.mPreviousToolAction,this.mNextToolAction]);
      }
      
      protected function OnSellRoomOrUseEyedropperButtonDown() : void
      {
         if(this.mbBlockContextMenuActive)
         {
            CommunicationManager.CallGameService("BBDeleteSelectedObject");
         }
         else
         {
            this.mbEyedropperActive = true;
            CommunicationManager.SendUIMessage("BBToggleEyedropper",true);
            FireMouseMoveEvent();
         }
      }
      
      protected function CanSellRoomOrUseEyedropper() : Boolean
      {
         if(this.mbBlockContextMenuActive)
         {
            return CommunicationManager.CallGameService("BBCanDeleteSelectedObject") as Boolean;
         }
         return true;
      }
      
      protected function OnEyedropperButtonUp() : void
      {
         if(this.mbEyedropperActive)
         {
            this.mbEyedropperActive = false;
            CommunicationManager.CallGameService("BBUseEyedropperTool");
         }
      }
      
      override protected function HoldActionValid() : Boolean
      {
         return true;
      }
      
      override protected function OnHoldButtonDown() : void
      {
         super.OnHoldButtonDown();
         if(!mbRoofIsSelected && !mbStairsIsSelected)
         {
            this.mbRedesignActive = true;
            CommunicationManager.SendUIMessage("BBToggleDesignTool",true);
            FireMouseMoveEvent();
         }
      }
      
      override protected function OnHoldButtonUp() : void
      {
         super.OnHoldButtonUp();
         if(this.mbRedesignActive)
         {
            this.mbRedesignActive = false;
            CommunicationManager.CallGameService("BBUseDesignTool");
         }
      }
      
      protected function OnObjectSelected(param1:Object) : void
      {
         var _loc2_:ProductFilter = null;
         var _loc3_:CatalogProduct = null;
         var _loc4_:Boolean = false;
         var _loc5_:BuildBuyCenterObjectSelectedAdapter = null;
         mbRoofIsSelected = false;
         mbStairsIsSelected = false;
         mHoldAction.SetLegendKey(KeysConsole.SELECTIONMODE_DESIGN_TOOL);
         if(param1)
         {
            if(param1.filter)
            {
               _loc2_ = new ProductFilter(param1.filter);
               NavManager.Instance.FocusPan(GetAdapterForProduct(_loc2_,false));
            }
            else
            {
               _loc3_ = new CatalogProduct(param1);
               _loc4_ = false;
               if(_loc3_)
               {
                  _loc4_ = _loc3_.IsInventoryable() && _loc3_.resourceKey.type == CatalogResourceTypes.OBJECT && !ArrayUtils.ContainsAny(TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_ALL),param1["productTags"]);
               }
               _loc5_ = new BuildBuyCenterObjectSelectedAdapter(_loc4_);
               _loc5_.mbShouldSwitchBackToMainAdapterWhenObjectDeselected = true;
               NavManager.Instance.FocusForward(_loc5_);
            }
         }
      }
      
      override protected function OnShowContextUI(param1:Object) : void
      {
         super.OnShowContextUI(param1);
         var _loc2_:ContextData = param1 as ContextData || new ContextData(param1);
         switch(_loc2_.contextType)
         {
            case ContextData.CONTEXT_ROOF:
            case ContextData.CONTEXT_STAIRS:
            case ContextData.CONTEXT_BLOCK:
            case ContextData.CONTEXT_MULTI_BLOCK:
            case ContextData.CONTEXT_FOUNTAIN:
            case ContextData.CONTEXT_YARD:
            case ContextData.CONTEXT_POOL:
               this.SetBlockContextMenuActive(_loc2_.id != -1);
         }
      }
      
      protected function SetBlockContextMenuActive(param1:Boolean) : void
      {
         if(this.mbBlockContextMenuActive == param1)
         {
            return;
         }
         this.mbBlockContextMenuActive = param1;
         if(param1)
         {
            this.mEyedropperOrSellDownAction.SetLegendKey(KeysConsole.BUILDBUY_INVENTORY_SELL);
         }
         else
         {
            this.mEyedropperOrSellDownAction.SetLegendKey(KeysConsole.SELECTIONMODE_EYEDROPPER_TOOL);
         }
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         sInstance = this;
         return super.Enter(param1);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         AddMessageListener("BBShowProductInfo",this.OnObjectSelected);
         AddMessageListener("BBProductCloned",this.OnObjectSelected);
         var _loc2_:IInputFocusable = super.OnEntered(param1);
         var _loc3_:int = CommunicationManager.CallUIService("BBGetActionMode") as int;
         if(_loc3_ == ActionModes.CATALOG_SELECT)
         {
            CommunicationManager.CallGameService("BBCancelUserTool",null,true);
         }
         return _loc2_;
      }
      
      override public function Exit() : void
      {
         sInstance = null;
         super.Exit();
         RemoveMessageListener("BBShowProductInfo",this.OnObjectSelected);
         RemoveMessageListener("BBProductCloned",this.OnObjectSelected);
         CommunicationManager.SendUIMessage("BBHideProductToolTip");
         BuildBuyGameStateAdapter.ResetTriggers();
         if(this.mbEyedropperActive)
         {
            this.mbEyedropperActive = false;
            CommunicationManager.SendUIMessage("BBToggleEyedropper",false);
         }
         if(this.mbRedesignActive)
         {
            this.mbRedesignActive = false;
            CommunicationManager.SendUIMessage("BBToggleDesignTool",false);
         }
      }
      
      protected function NotValidForQuickLegend() : Boolean
      {
         return false;
      }
   }
}

