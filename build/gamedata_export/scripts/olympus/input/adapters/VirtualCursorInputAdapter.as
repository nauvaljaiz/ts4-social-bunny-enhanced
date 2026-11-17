package olympus.input.adapters
{
   import flash.geom.Rectangle;
   import olympus.constants.ActionCodes;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.utils.InputUtils;
   
   public class VirtualCursorInputAdapter extends InputAdapter
   {
      
      public static const MOUSEACTION_NONE:uint = 0;
      
      public static const MOUSEACTION_DOWN:uint = 1;
      
      public static const MOUSEACTION_UP:uint = 2;
      
      public static const MOUSEACTION_CLICK:uint = 3;
      
      protected var mbEnabled:Boolean;
      
      protected var mRestraints:Rectangle;
      
      protected var mMouseButtonOnConfirmDown:uint = 3;
      
      protected var mMouseButtonOnConfirmUp:uint = 0;
      
      protected var mbRestoreCursorPosition:Boolean = true;
      
      protected var mStoredCursorX:Number;
      
      protected var mStoredCursorY:Number;
      
      protected var mConfirmInputAction:InputAction;
      
      protected var mConfirmInputActionLegendKey:LocKey = KeysConsole.GENERIC_SELECT;
      
      protected var mUpdateRestraintsCallback:Function;
      
      public function VirtualCursorInputAdapter()
      {
         super();
         this.SetRestraints(null);
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         this.mStoredCursorX = -1;
         this.mStoredCursorY = -1;
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.LEFT_STICK_MOVE_FAKE)).SetLegendKey(KeysConsole.MOVE_CURSOR).SetValidCheckGameService("IsUsingCameraControllerFPS",null,false);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.LEFT_STICK_MOVE_FAKE)).SetLegendKey(KeysConsole.ZOOM_CAMERA).SetValidCheckGameService("IsUsingCameraControllerFPS",null,true);
         this.mConfirmInputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.CONFIRM)).SetLegendKey(this.mConfirmInputActionLegendKey).AllowWhileModalOpen(true);
         AddInputActions([_loc1_,_loc2_,this.mConfirmInputAction]);
      }
      
      public function CenterVirtualCursor() : void
      {
         if(this.mRestraints)
         {
            this.mStoredCursorX = this.mRestraints.left + this.mRestraints.width / 2;
            this.mStoredCursorY = this.mRestraints.top + this.mRestraints.height / 2;
         }
         else
         {
            this.mStoredCursorX = LayoutAPI.StageWidth / 2;
            this.mStoredCursorY = LayoutAPI.StageHeight / 2;
         }
         this.SetVirtualCursorPosition(this.mStoredCursorX,this.mStoredCursorY);
      }
      
      public function SetVirtualCursorPosition(param1:int, param2:int) : void
      {
         CommunicationManager.CallGameService("SetVirtualCursorPosition",{
            "x":param1,
            "y":param2
         },true);
      }
      
      public function FireMouseMoveEvent() : *
      {
         this.SetVirtualCursorPosition(-1,-1);
      }
      
      public function SetRestraints(param1:Rectangle) : VirtualCursorInputAdapter
      {
         this.mRestraints = param1;
         if(this.mbEnabled)
         {
            this.UpdateVirtualCursorParams();
         }
         return this;
      }
      
      public function GetRestraints() : Rectangle
      {
         return this.mRestraints;
      }
      
      public function SetMouseButtonActions(param1:uint = 3, param2:uint = 0) : VirtualCursorInputAdapter
      {
         this.mMouseButtonOnConfirmDown = param1;
         this.mMouseButtonOnConfirmUp = param2;
         if(this.mbEnabled)
         {
            this.UpdateVirtualCursorParams();
         }
         return this;
      }
      
      protected function UpdateVirtualCursorParams() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mRestraints)
         {
            _loc2_ = this.mRestraints.left as Number;
            _loc3_ = this.mRestraints.top as Number;
            _loc1_ = {
               "restraintLeft":_loc2_,
               "restraintTop":_loc3_,
               "restraintRight":_loc2_ + this.mRestraints.width,
               "restraintBottom":_loc3_ + this.mRestraints.height
            };
         }
         else
         {
            _loc1_ = {
               "restraintLeft":-1,
               "restraintTop":-1,
               "restraintRight":-1,
               "restraintBottom":-1
            };
         }
         _loc1_.enabled = this.mbEnabled;
         _loc1_.onConfirmDown = this.mMouseButtonOnConfirmDown;
         _loc1_.onConfirmUp = this.mMouseButtonOnConfirmUp;
         CommunicationManager.CallGameService("SetupVirtualCursor",_loc1_,true);
         if(this.mbEnabled)
         {
            this.FireMouseMoveEvent();
         }
      }
      
      public function SetUpdateRestraintsCallback(param1:Function) : void
      {
         this.mUpdateRestraintsCallback = param1;
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         super.OnEntered(param1);
         this.mbEnabled = true;
         this.UpdateRestraints();
         if(this.mbRestoreCursorPosition)
         {
            if(this.mStoredCursorX >= 0 && this.mStoredCursorY >= 0)
            {
               this.SetVirtualCursorPosition(this.mStoredCursorX,this.mStoredCursorY);
            }
            else
            {
               this.CenterVirtualCursor();
            }
         }
         CommunicationManager.AddMessageListenerByName("UpdateVirtualCursorRestraints",this.UpdateRestraints,"VirtualCursorInputAdapter");
         return GetStackFocusable(param1);
      }
      
      override public function Exit() : void
      {
         this.mStoredCursorX = InputUtils.sMouseX;
         this.mStoredCursorY = InputUtils.sMouseY;
         super.Exit();
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         this.mbEnabled = false;
         this.UpdateVirtualCursorParams();
         CommunicationManager.RemoveMessageListenerByName("UpdateVirtualCursorRestraints",this.UpdateRestraints,"VirtualCursorInputAdapter");
         NavManager.Instance.ClearVirtualCursorHighlight();
      }
      
      public function SetConfirmActionLegend(param1:LocKey) : void
      {
         this.mConfirmInputActionLegendKey = param1;
         if(this.mConfirmInputAction)
         {
            this.mConfirmInputAction.SetLegendKey(param1);
         }
      }
      
      protected function UpdateRestraints() : void
      {
         if(Boolean(this.mUpdateRestraintsCallback))
         {
            this.mUpdateRestraintsCallback();
         }
         this.UpdateVirtualCursorParams();
      }
   }
}

