package olympus.input.adapters
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.input.CameraActionCodes;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyGameStateAdapter;
   import widgets.CameraControl.constants.CameraControlTunables;
   import widgets.shared.constants.WallViewMode;
   
   public class CenterInputAdapterBase extends VirtualCursorInputAdapter
   {
      
      protected var mbDisableUIMouseInput:Boolean = false;
      
      public function CenterInputAdapterBase()
      {
         super();
         SetUpdateRestraintsCallback(this.SetupRestraintsFromNavigation);
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         EnableTicker();
      }
      
      protected function SetupRestraintsFromNavigation() : Boolean
      {
         var _loc1_:Number = this.GetBottomMarginPosition();
         if(_loc1_ == 0)
         {
            SetRestraints(null);
            return false;
         }
         var _loc2_:Point = LayoutAPI.GetStageSize();
         var _loc3_:Number = CameraControlTunables.GAMEPAD_CAMERA_EDGE_PAN_MARGIN_X;
         var _loc4_:Number = CameraControlTunables.GAMEPAD_CAMERA_EDGE_PAN_MARGIN_Y;
         SetRestraints(new Rectangle(_loc3_ + LayoutAPI.ScreenMargin.x,_loc4_ + LayoutAPI.ScreenMargin.y,_loc2_.x - _loc3_ * 2,_loc1_ - _loc4_));
         return true;
      }
      
      protected function AddMessageListener(param1:String, param2:Function, param3:Class = null) : void
      {
         CommunicationManager.AddMessageListenerByName(param1,param2,"Center Cursor",param3);
      }
      
      protected function RemoveMessageListener(param1:String, param2:Function) : void
      {
         CommunicationManager.RemoveMessageListenerByName(param1,param2,"Center Cursor");
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         this.AddMessageListener("StageResized",this.SetupRestraintsFromNavigation);
         if(!this.SetupRestraintsFromNavigation())
         {
            this.AddMessageListener("LoadedBuildBuyNavigation",this.SetupRestraintsFromNavigation);
         }
         CommunicationManager.CallGameService("CameraSetEdgeScrollForGamepad",true,true);
         if(this.mbDisableUIMouseInput)
         {
            CommunicationManager.CallGameService("SetMouseInputEnabled",false);
         }
         return super.OnEntered(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         CommunicationManager.CallGameService("CameraSetEdgeScrollForGamepad",false,true);
         CommunicationManager.CallGameService("SetMouseInputEnabled",true);
         this.RemoveMessageListener("StageResized",this.SetupRestraintsFromNavigation);
         this.RemoveMessageListener("LoadedBuildBuyNavigation",this.SetupRestraintsFromNavigation);
      }
      
      protected function CycleWallViewMode() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Object = CommunicationManager.CallGameService("BBGetWallMode");
         if(_loc1_ is int)
         {
            _loc2_ = _loc1_ as int;
            CommunicationManager.CallGameService("BBSetWallMode",(_loc2_ + 1) % WallViewMode.WALLS_LENGTH);
         }
      }
      
      protected function GoUpOneFloor() : void
      {
         CommunicationManager.SendUIMessage("RequestControlPanelChangeFloor",{"floorChange":1});
      }
      
      protected function GoDownOneFloor() : void
      {
         CommunicationManager.SendUIMessage("RequestControlPanelChangeFloor",{"floorChange":-1});
      }
      
      protected function GetBottomMarginPosition() : Number
      {
         return 0;
      }
      
      protected function AddSharedCameraActions() : *
      {
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CameraActionCodes.CYCLE_WALL_VIEW)).CallFunction(this.CycleWallViewMode).SetLegendKey(KeysConsole.GENERIC_CAMERA_CYCLE_VIEW).SetValidCheck(this.CycleWallViewValidCheck);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CameraActionCodes.UP_ONE_FLOOR)).CallFunction(this.GoUpOneFloor).SetLegendKey(KeysConsole.GENERIC_CAMERA_NEXT_FLOOR).SetValidCheckGameService("IsUsingCameraControllerFPS",null,false);
         var _loc3_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CameraActionCodes.DOWN_ONE_FLOOR)).CallFunction(this.GoDownOneFloor).SetLegendKey(KeysConsole.GENERIC_CAMERA_LOWER_FLOOR).SetValidCheckGameService("IsUsingCameraControllerFPS",null,false);
         var _loc4_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CameraActionCodes.PAN_CAMERA)).SetLegendKey(KeysConsole.PAN_CAMERA).SetValidCheckGameService("IsUsingCameraControllerFPS",null,false);
         AddInputActions([_loc1_,_loc2_,_loc3_,_loc4_]);
      }
      
      protected function CycleWallViewValidCheck() : Boolean
      {
         return !BuildBuyGameStateAdapter.CheatsActive && !CommunicationManager.CallGameService("IsUsingCameraControllerFPS");
      }
      
      override public function IsZoomAllowed() : Boolean
      {
         return true;
      }
      
      override public function IsRotateAllowed() : Boolean
      {
         return true;
      }
      
      override public function IsTravelButtonAllowed() : Boolean
      {
         return NavManager.Instance.IsAtRoot;
      }
   }
}

