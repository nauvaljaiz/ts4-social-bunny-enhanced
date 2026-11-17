package widgets.BuildBuy.gamepad.adapters
{
   import olympus.constants.ActionCodes;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.GameStateAdapter;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import widgets.BuildBuy.Magalog.BuildBuyMagalogMain;
   import widgets.BuildBuy.ProductCatalog.controls.CatalogProductVariationSelector;
   import widgets.BuildBuy.gamepad.BuildBuySharedActions;
   import widgets.shared.controls.ToastNotification.ToastNotification;
   
   public class BuildBuyGameStateAdapter extends GameStateAdapter
   {
      
      public static var sbLeftTriggerDown:Boolean = false;
      
      public static var sbRightTriggerDown:Boolean = false;
      
      public static var sbAllowZoomAndRotate:Boolean = true;
      
      internal static const SNAP_FULL_GRID:uint = 0;
      
      internal static const SNAP_HALF_GRID:uint = 1;
      
      internal static const SNAP_FREE_PLACEMENT:uint = 2;
      
      protected var mbSharedActionsRegistered:Boolean = false;
      
      public function BuildBuyGameStateAdapter()
      {
         super();
      }
      
      public static function get CheatsActive() : Boolean
      {
         return sbLeftTriggerDown && sbRightTriggerDown;
      }
      
      public static function ResetTriggers() : void
      {
         sbLeftTriggerDown = false;
         sbRightTriggerDown = false;
      }
      
      public static function IsCameraZoomAllowed() : Boolean
      {
         return GameStateAdapter.IsCameraZoomAllowed() && sbAllowZoomAndRotate;
      }
      
      public static function IsCameraRotateAllowed() : Boolean
      {
         return GameStateAdapter.IsCameraRotateAllowed() && sbAllowZoomAndRotate;
      }
      
      override protected function IsZoomAndRotateAllowed() : Boolean
      {
         return Boolean(super.IsZoomAndRotateAllowed()) && sbAllowZoomAndRotate;
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         sbLeftTriggerDown = false;
         sbRightTriggerDown = false;
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TRIGGER_LEFT,true)).CallFunction(this.OnLeftTriggerDown);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TRIGGER_RIGHT,true)).CallFunction(this.OnRightTriggerDown);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TRIGGER_LEFT,false)).CallFunction(this.OnLeftTriggerUp);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TRIGGER_RIGHT,false)).CallFunction(this.OnRightTriggerUp);
         AddInputActions([_loc1_,_loc2_,_loc3_,_loc4_]);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         CommunicationManager.AddMessageListenerByName("GridSnapSizeCycled",this.HandleGridSnapSizeCycled,"BuildBuyGameStateAdapter");
         CommunicationManager.AddMessageListenerByName("ChangedCurrentFocusable",this.HandleChangedCurrentFocusable,"BuildBuyGameStateAdapter");
         CommunicationManager.AddMessageListenerByName("GamestateAllowCameraZoomAndRotate",this.OnAllowCameraZoomAndRotate,"BuildBuyGameStateAdapter");
         return super.OnEntered(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         CommunicationManager.RemoveMessageListenerByName("GridSnapSizeCycled",this.HandleGridSnapSizeCycled,"BuildBuyGameStateAdapter");
         CommunicationManager.RemoveMessageListenerByName("ChangedCurrentFocusable",this.HandleChangedCurrentFocusable,"BuildBuyGameStateAdapter");
         CommunicationManager.RemoveMessageListenerByName("GamestateAllowCameraZoomAndRotate",this.OnAllowCameraZoomAndRotate,"BuildBuyGameStateAdapter");
         sbAllowZoomAndRotate = true;
      }
      
      protected function HandleChangedCurrentFocusable(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:BuildBuyMagalogMain = null;
         if(NavManager.Instance.CurrentFocusable is BuildBuyCenterAdapterBase || NavManager.Instance.CurrentFocusable is CatalogProductVariationSelector)
         {
            _loc2_ = false;
         }
         else if(NavManager.Instance.CurrentWidgetName == "BuildBuyMagalog")
         {
            _loc3_ = LayoutAPI.GetLoadedWidgetByName("BuildBuyMagalog") as BuildBuyMagalogMain;
            if(_loc3_)
            {
               _loc2_ = _loc3_.ShouldRegisterSharedActions();
            }
         }
         else if(NavManager.Instance.CurrentWidgetName == "BuildBuyProductCatalog")
         {
            _loc2_ = true;
         }
         if(_loc2_ == this.mbSharedActionsRegistered)
         {
            return;
         }
         this.mbSharedActionsRegistered = _loc2_;
         if(this.mbSharedActionsRegistered)
         {
            InputActionManager.RegisterAction(BuildBuySharedActions.jumpToFilter);
            InputActionManager.RegisterAction(BuildBuySharedActions.jumpToSearch);
         }
         else
         {
            InputActionManager.UnregisterAction(BuildBuySharedActions.jumpToFilter);
            InputActionManager.UnregisterAction(BuildBuySharedActions.jumpToSearch);
         }
      }
      
      protected function HandleGridSnapSizeCycled(param1:int) : void
      {
         var _loc2_:LocKey = null;
         switch(param1)
         {
            case SNAP_FULL_GRID:
               _loc2_ = KeysConsole.BUILDBUY_GRID_SNAP_FULL;
               break;
            case SNAP_HALF_GRID:
               _loc2_ = KeysConsole.BUILDBUY_GRID_SNAP_HALF;
               break;
            case SNAP_FREE_PLACEMENT:
               _loc2_ = KeysConsole.BUILDBUY_GRID_SNAP_NONE;
         }
         if(_loc2_)
         {
            CommunicationManager.SendUIMessage("ToastNotify",{
               "type":ToastNotification.TYPE_CLOBBER,
               "label":_loc2_,
               "isControllerFeedback":true
            });
         }
      }
      
      protected function OnLeftTriggerDown() : void
      {
         sbLeftTriggerDown = true;
      }
      
      protected function OnRightTriggerDown() : void
      {
         sbRightTriggerDown = true;
      }
      
      protected function OnLeftTriggerUp() : void
      {
         sbLeftTriggerDown = false;
      }
      
      protected function OnRightTriggerUp() : void
      {
         sbRightTriggerDown = false;
      }
      
      protected function OnAllowCameraZoomAndRotate(param1:Object) : void
      {
         sbAllowZoomAndRotate = param1 as Boolean;
         NavManager.Instance.NotifyCameraController();
      }
   }
}

