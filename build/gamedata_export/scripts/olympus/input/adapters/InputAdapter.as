package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import olympus.constants.ActionCodes;
   import olympus.constants.GameStates;
   import olympus.core.Ticker;
   import olympus.core.TooltipManager;
   import olympus.events.TickerEvent;
   import olympus.extensions.HighlightExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.sliders.Slider;
   import olympus.input.GamepadAnalogSticks;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.constants.InputAdapterTunables;
   import olympus.input.helpers.SliderHelper;
   import olympus.interfaces.IBoundsOverride;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.math.Geometry;
   import olympus.utils.DisplayObjectUtils;
   import scaleform.gfx.MouseEventEx;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyGameStateAdapter;
   
   public class InputAdapter extends EventDispatcher implements IInputAdapter
   {
      
      public static const EDGE_LEAVE:uint = 0;
      
      public static const EDGE_LOOP:uint = 1;
      
      public static const EDGE_STOP:uint = 2;
      
      protected static var sCurrentDpadDirectionalInput:int = -1;
      
      protected static var sbIsLoadingScreenActive:Boolean = false;
      
      protected var mInputActions:Array;
      
      protected var mEdgeBehavior:uint = 0;
      
      protected var mbInputsInitialized:Boolean = false;
      
      protected var mbCurrentlyEntered:Boolean = false;
      
      protected var mbHighlightClosestOnEnter:Boolean = false;
      
      protected var mbConfirmAdded:Boolean = false;
      
      protected var mbBackAdded:Boolean = false;
      
      protected var mSliderHelper:SliderHelper;
      
      protected var mDefaultHighlight:DisplayObject;
      
      protected var mbUseTicker:Boolean = false;
      
      protected var mbDirectionalInputAdded:Boolean = false;
      
      protected var mStartingDirInputDebounce:uint = 250;
      
      protected var mDirInputAcceleration:uint = 20;
      
      protected var mDirInputMinimumDebounce:uint = 50;
      
      protected var mCurrentDirectionalInputDebounce:Number;
      
      protected var mLastDirectionalInputUpdateTime:Number = -1;
      
      protected var mPanOnLeaveArgs:Object;
      
      protected var mIgnoreDefaultActionCodes:Vector.<uint>;
      
      protected var mbAllowAllActionsDuringLoadingScreen:Boolean = false;
      
      protected var mConfirmAction:InputAction = null;
      
      protected var mbDisableNavigation:Boolean = false;
      
      public function InputAdapter()
      {
         super();
         this.mIgnoreDefaultActionCodes = new Vector.<uint>();
      }
      
      public static function set IsLoadingScreenActive(param1:Boolean) : void
      {
         sbIsLoadingScreenActive = param1;
         if(param1)
         {
            sCurrentDpadDirectionalInput = -1;
         }
      }
      
      public static function ConfirmSelectedObject(param1:Object) : DisplayObject
      {
         var _loc4_:MouseEventEx = null;
         var _loc5_:MouseEventEx = null;
         var _loc6_:MouseEventEx = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:MovieClip = param1 as MovieClip;
         var _loc3_:DisplayObject = param1 as DisplayObject;
         if((!_loc2_ || _loc2_.enabled) && Boolean(_loc3_))
         {
            _loc4_ = new MouseEventEx(MouseEvent.MOUSE_DOWN);
            _loc4_.buttonIdx = MouseEventEx.LEFT_BUTTON;
            _loc4_.buttonDown = true;
            _loc3_.dispatchEvent(_loc4_);
            _loc5_ = new MouseEventEx(MouseEvent.MOUSE_UP);
            _loc5_.buttonIdx = MouseEventEx.LEFT_BUTTON;
            _loc5_.buttonDown = false;
            _loc3_.dispatchEvent(_loc5_);
            _loc6_ = new MouseEventEx(MouseEvent.CLICK);
            _loc6_.buttonIdx = MouseEventEx.LEFT_BUTTON;
            _loc6_.buttonDown = false;
            _loc3_.dispatchEvent(_loc6_);
            return _loc3_;
         }
         return null;
      }
      
      public static function IsCameraZoomAllowed() : Boolean
      {
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState") as uint;
         if(_loc1_ == GameStates.BUILD)
         {
            return BuildBuyGameStateAdapter.IsCameraZoomAllowed();
         }
         return GameStateAdapter.IsCameraZoomAllowed();
      }
      
      public static function IsCameraRotateAllowed() : Boolean
      {
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState") as uint;
         if(_loc1_ == GameStates.BUILD)
         {
            return BuildBuyGameStateAdapter.IsCameraRotateAllowed();
         }
         return GameStateAdapter.IsCameraRotateAllowed();
      }
      
      protected function InitializeInputs() : void
      {
      }
      
      public function TryInitializeInputs() : Boolean
      {
         if(!this.mbInputsInitialized)
         {
            this.mbInputsInitialized = true;
            this.InitializeInputs();
            return true;
         }
         return false;
      }
      
      protected function ShouldRegisterDefaultAction(param1:uint) : Boolean
      {
         return this.mIgnoreDefaultActionCodes.indexOf(param1) == -1;
      }
      
      public function IgnoreDefaultAction(param1:uint) : InputAdapter
      {
         this.mIgnoreDefaultActionCodes.push(param1);
         return this;
      }
      
      public function SetEdgeBehavior(param1:uint) : InputAdapter
      {
         this.mEdgeBehavior = param1;
         return this;
      }
      
      public function SetHighlightClosestOnEnter(param1:Boolean) : InputAdapter
      {
         this.mbHighlightClosestOnEnter = param1;
         return this;
      }
      
      public function SetDirectionalInputDebounceValues(param1:uint, param2:uint, param3:*) : InputAdapter
      {
         this.mStartingDirInputDebounce = param1;
         this.mDirInputAcceleration = param2;
         this.mDirInputMinimumDebounce = param3;
         return this;
      }
      
      public function SetAllowedDuringLoadingScreen(param1:Boolean) : InputAdapter
      {
         var _loc2_:InputAction = null;
         this.mbAllowAllActionsDuringLoadingScreen = param1;
         for each(_loc2_ in this.mInputActions)
         {
            _loc2_.AllowDuringLoadingScreen(param1 || _loc2_.IsAllowedDuringLoadingScreen());
         }
         return this;
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         if(this.mbCurrentlyEntered)
         {
            return this;
         }
         this.TryInitializeInputs();
         if(this.mbUseTicker)
         {
            Ticker.Add(this,0,this.Tick);
         }
         if(this.mInputActions)
         {
            InputActionManager.AutoregisterActions(this.mInputActions);
         }
         if(Boolean(param1) && Boolean(param1.mDirection == NavDirection.FORWARD) && Boolean(this.mDefaultHighlight))
         {
            this.SetHighlightedObject(this.mDefaultHighlight);
         }
         else if(Boolean(param1) && Boolean(param1.mFromPos) && this.mbHighlightClosestOnEnter)
         {
            this.HighlightClosestToPoint(param1.mFromPos);
         }
         if(this.mbDirectionalInputAdded)
         {
            this.mLastDirectionalInputUpdateTime = getTimer();
            this.mCurrentDirectionalInputDebounce = this.mStartingDirInputDebounce;
         }
         else
         {
            this.EndAnyRepeatingDirectionalInputs();
         }
         this.mbCurrentlyEntered = true;
         var _loc2_:IInputFocusable = this.OnEntered(param1);
         this.FireEnteredEvent();
         return _loc2_;
      }
      
      protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         if(this.mSliderHelper)
         {
            this.mSliderHelper.SetupRStickScrolling();
         }
         return this;
      }
      
      public function Exit() : void
      {
         if(!this.mbCurrentlyEntered)
         {
            return;
         }
         this.mbCurrentlyEntered = false;
         if(this.mInputActions)
         {
            InputActionManager.AutounregisterActions(this.mInputActions);
         }
         if(this.mbUseTicker)
         {
            Ticker.Remove(this);
         }
         TooltipManager.getInstance().HideTooltips(true);
         this.OnExited();
         this.FireExitedEvent();
      }
      
      protected function OnExited() : void
      {
         if(this.mSliderHelper)
         {
            this.mSliderHelper.RemoveRStickScrolling();
         }
      }
      
      public function IsCurrentlyEntered() : Boolean
      {
         return this.mbCurrentlyEntered;
      }
      
      protected function Tick(param1:TickerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.mbDirectionalInputAdded)
         {
            _loc2_ = getTimer();
            if(this.mLastDirectionalInputUpdateTime <= 0 || _loc2_ - this.mLastDirectionalInputUpdateTime > this.mCurrentDirectionalInputDebounce)
            {
               _loc3_ = false;
               _loc4_ = GamepadAnalogSticks.GetLeftX();
               _loc5_ = -GamepadAnalogSticks.GetLeftY();
               if(!sbIsLoadingScreenActive && Geometry.GetLengthSquared(_loc4_,_loc5_) > InputAdapterTunables.ANALOG_DEADZONE_SQ)
               {
                  _loc3_ = true;
                  this.HighlightDirectionAnalog(_loc4_,_loc5_);
               }
               else if(sCurrentDpadDirectionalInput != -1)
               {
                  _loc3_ = true;
                  this.ApplyDirectionalInput(sCurrentDpadDirectionalInput);
               }
               if(_loc3_)
               {
                  this.mLastDirectionalInputUpdateTime = _loc2_;
                  this.mCurrentDirectionalInputDebounce = Math.max(this.mCurrentDirectionalInputDebounce - this.mDirInputAcceleration,this.mDirInputMinimumDebounce);
               }
               else
               {
                  this.mCurrentDirectionalInputDebounce = this.mStartingDirInputDebounce;
               }
            }
         }
      }
      
      protected function InitializeRepeatingDirectionalInput(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(sCurrentDpadDirectionalInput != param1)
         {
            sCurrentDpadDirectionalInput = param1;
            _loc2_ = getTimer();
            this.mLastDirectionalInputUpdateTime = _loc2_;
            this.ApplyDirectionalInput(param1);
         }
      }
      
      protected function EndRepeatingDirectionalInput(param1:int) : void
      {
         if(sCurrentDpadDirectionalInput == param1)
         {
            this.EndAnyRepeatingDirectionalInputs();
         }
      }
      
      public function EndAnyRepeatingDirectionalInputs() : void
      {
         sCurrentDpadDirectionalInput = -1;
         this.mCurrentDirectionalInputDebounce = this.mStartingDirInputDebounce;
      }
      
      public function AddConfirmAction(param1:uint = 1, param2:LocKey = null) : void
      {
         if(this.mbConfirmAdded)
         {
            return;
         }
         if(!this.ShouldRegisterDefaultAction(param1))
         {
            return;
         }
         this.mbConfirmAdded = true;
         this.mConfirmAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(param1)).CallFunction(this.HandleConfirm).AllowWhileModalOpen(true).SetLegendKey(param2 ? param2 : Keys.GENERIC_CONFIRM);
         this.AddInputAction(this.mConfirmAction);
      }
      
      public function GetConfirmAction() : InputAction
      {
         this.AddConfirmAction();
         return this.mConfirmAction;
      }
      
      protected function AddBackAction() : void
      {
         if(!this.ShouldRegisterDefaultAction(ActionCodes.BACK))
         {
            return;
         }
         if(this.mbBackAdded)
         {
            return;
         }
         this.mbBackAdded = true;
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.BACK)).CallFunction(this.HandleBack).AllowWhileModalOpen(true).SetLegendKey(Keys.GENERIC_BACK);
         this.AddInputAction(_loc1_);
      }
      
      protected function EnableTicker() : void
      {
         this.mbUseTicker = true;
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         switch(param1)
         {
            case InputAdapterEvent.CONFIRM:
               this.OnConfirmCall(param2);
               break;
            case InputAdapterEvent.BACK:
               this.OnBackCall(param2);
               break;
            case InputAdapterEvent.HIGHLIGHT_CHANGED:
               this.OnHighlightChangeCall(param2);
               break;
            case InputAdapterEvent.LEAVE:
               this.OnLeaveCall(param2);
               break;
            case InputAdapterEvent.ENTERED:
               this.OnEnteredCall(param2);
               break;
            case InputAdapterEvent.EXITED:
               this.OnExitedCall(param2);
         }
         return this;
      }
      
      public function OnConfirmCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.CONFIRM,param1);
         this.AddConfirmAction();
         return this;
      }
      
      public function OnBackCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.BACK,param1);
         this.AddBackAction();
         return this;
      }
      
      public function OnHighlightChangeCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.HIGHLIGHT_CHANGED,param1);
         return this;
      }
      
      public function RemoveHighlightChangeCall(param1:Function) : InputAdapter
      {
         this.removeEventListener(InputAdapterEvent.HIGHLIGHT_CHANGED,param1,false);
         return this;
      }
      
      public function OnLeaveCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.LEAVE,param1);
         return this;
      }
      
      public function OnEnteredCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.ENTERED,param1);
         return this;
      }
      
      public function OnExitedCall(param1:Function) : InputAdapter
      {
         this.addEventListener(InputAdapterEvent.EXITED,param1);
         return this;
      }
      
      final protected function AddDirectionalInputs() : void
      {
         var _loc2_:InputAction = null;
         var _loc3_:InputAction = null;
         var _loc4_:InputAction = null;
         var _loc5_:InputAction = null;
         var _loc6_:InputAction = null;
         var _loc7_:InputAction = null;
         var _loc8_:InputAction = null;
         var _loc9_:InputAction = null;
         var _loc10_:InputAction = null;
         if(this.mbDirectionalInputAdded)
         {
            return;
         }
         this.mbDirectionalInputAdded = true;
         this.EnableTicker();
         var _loc1_:Array = [];
         if(this.ShouldRegisterDefaultAction(ActionCodes.NAVIGATE_RIGHT))
         {
            _loc3_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_RIGHT)).CallFunction(this.BeginHighlightRight).SetLegendKey(KeysConsole.GENERIC_RIGHT);
            _loc4_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_RIGHT,false)).CallFunction(this.EndHighlightRight);
            _loc1_.push(_loc3_,_loc4_);
         }
         if(this.ShouldRegisterDefaultAction(ActionCodes.NAVIGATE_LEFT))
         {
            _loc5_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_LEFT)).CallFunction(this.BeginHighlightLeft).SetLegendKey(KeysConsole.GENERIC_LEFT);
            _loc6_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_LEFT,false)).CallFunction(this.EndHighlightLeft);
            _loc1_.push(_loc5_,_loc6_);
         }
         if(this.ShouldRegisterDefaultAction(ActionCodes.NAVIGATE_DOWN))
         {
            _loc7_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_DOWN)).CallFunction(this.BeginHighlightDown).SetLegendKey(KeysConsole.GENERIC_DOWN);
            _loc8_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_DOWN,false)).CallFunction(this.EndHighlightDown);
            _loc1_.push(_loc7_,_loc8_);
         }
         if(this.ShouldRegisterDefaultAction(ActionCodes.NAVIGATE_UP))
         {
            _loc9_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_UP)).CallFunction(this.BeginHighlightUp).SetLegendKey(KeysConsole.GENERIC_UP);
            _loc10_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_UP,false)).CallFunction(this.EndHighlightUp);
            _loc1_.push(_loc9_,_loc10_);
         }
         for each(_loc2_ in _loc1_)
         {
            _loc2_.AllowWhileModalOpen(true);
         }
         this.AddInputActions(_loc1_);
      }
      
      final protected function FireLeaveEvent(param1:uint, param2:Point) : void
      {
         dispatchEvent(new InputAdapterLeaveEvent(param1,param2));
      }
      
      final protected function FireHighlightChangeEvent(param1:IView, param2:DisplayObject) : void
      {
         dispatchEvent(new InputAdapterHighlightEvent(param1,param2));
      }
      
      final protected function FireBackEvent() : void
      {
         dispatchEvent(new InputAdapterEvent(InputAdapterEvent.BACK));
      }
      
      final protected function FireConfirmEvent(param1:DisplayObject) : void
      {
         dispatchEvent(new InputAdapterConfirmEvent(param1));
      }
      
      final protected function FireEnteredEvent() : void
      {
         dispatchEvent(new InputAdapterEvent(InputAdapterEvent.ENTERED));
      }
      
      final protected function FireExitedEvent() : void
      {
         dispatchEvent(new InputAdapterEvent(InputAdapterEvent.EXITED));
      }
      
      public function AddInputActions(param1:Array) : void
      {
         var _loc2_:InputAction = null;
         for each(_loc2_ in param1)
         {
            this.AddInputAction(_loc2_);
         }
      }
      
      public function AddInputAction(param1:InputAction) : void
      {
         if(!this.mInputActions)
         {
            this.mInputActions = [];
         }
         this.mInputActions.push(param1);
         param1.AllowDuringLoadingScreen(this.mbAllowAllActionsDuringLoadingScreen || param1.IsAllowedDuringLoadingScreen());
         if(this.mbCurrentlyEntered)
         {
            InputActionManager.UnregisterAction(param1);
            InputActionManager.RegisterAction(param1);
         }
      }
      
      public function RemoveInputActionByCode(param1:uint) : InputAction
      {
         var _loc3_:InputAction = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.mInputActions.length)
         {
            _loc3_ = this.mInputActions[_loc2_];
            if(_loc3_.inputTrigger.Code == param1)
            {
               if(this.mbCurrentlyEntered)
               {
                  InputActionManager.UnregisterAction(_loc3_);
               }
               this.mInputActions.splice(_loc2_,1);
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetFirstInputAction(param1:uint) : InputAction
      {
         var _loc2_:InputAction = null;
         for each(_loc2_ in this.mInputActions)
         {
            if(_loc2_.inputTrigger.Code == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function AutoscrollSlider(param1:Slider, param2:Number = 0, param3:Boolean = false) : InputAdapter
      {
         if(!this.mSliderHelper)
         {
            this.mSliderHelper = new SliderHelper(this);
         }
         this.mSliderHelper.SetSliderAndMargin(param1,param2);
         this.mSliderHelper.SetAnimated(param3);
         return this;
      }
      
      public function CleanupAutoscrollSlider() : void
      {
         if(this.mSliderHelper != null)
         {
            this.mSliderHelper.UnregisterCallbacks();
            this.SetSliderHelper(null);
         }
      }
      
      public function UpdateSliderScroll() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.mSliderHelper)
         {
            _loc1_ = this.GetHighlightedObject();
            if(_loc1_)
            {
               this.mSliderHelper.ScrollToDisplayObject(_loc1_);
            }
         }
      }
      
      public function GetSliderHelper() : SliderHelper
      {
         return this.mSliderHelper;
      }
      
      public function SetSliderHelper(param1:SliderHelper) : InputAdapter
      {
         this.mSliderHelper = param1;
         return this;
      }
      
      public function GetHighlightedObject() : DisplayObject
      {
         return null;
      }
      
      public function ResetHighlight() : void
      {
         var _loc1_:Vector.<DisplayObject> = this.GetVisibleObjects();
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            this.SetHighlightedObject(_loc1_[0],true);
         }
      }
      
      public function SetDefaultHighlight(param1:DisplayObject) : InputAdapter
      {
         this.mDefaultHighlight = param1;
         return this;
      }
      
      protected function ChangeHighlight(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false) : void
      {
         var _loc4_:IExtendable = null;
         var _loc5_:DisplayObject = null;
         if(param1 == param2 && !param3)
         {
            return;
         }
         if(param2)
         {
            _loc4_ = param2 as IExtendable;
            if(_loc4_)
            {
               _loc4_.GetExtension(HighlightExtension);
            }
            _loc5_ = param2 as DisplayObject;
            if(_loc5_)
            {
               NavManager.Instance.RequestHighlight(_loc5_);
            }
         }
         this.FireHighlightChangeEvent(param2 as IView,param2);
      }
      
      public function ConfirmHighlight() : DisplayObject
      {
         return ConfirmSelectedObject(this.GetHighlightedObject());
      }
      
      protected function BeginHighlightRight() : void
      {
         this.InitializeRepeatingDirectionalInput(NavDirection.RIGHT);
      }
      
      protected function BeginHighlightLeft() : void
      {
         this.InitializeRepeatingDirectionalInput(NavDirection.LEFT);
      }
      
      protected function BeginHighlightDown() : void
      {
         this.InitializeRepeatingDirectionalInput(NavDirection.DOWN);
      }
      
      protected function BeginHighlightUp() : void
      {
         this.InitializeRepeatingDirectionalInput(NavDirection.UP);
      }
      
      protected function EndHighlightRight() : void
      {
         this.EndRepeatingDirectionalInput(NavDirection.RIGHT);
      }
      
      protected function EndHighlightLeft() : void
      {
         this.EndRepeatingDirectionalInput(NavDirection.LEFT);
      }
      
      protected function EndHighlightDown() : void
      {
         this.EndRepeatingDirectionalInput(NavDirection.DOWN);
      }
      
      protected function EndHighlightUp() : void
      {
         this.EndRepeatingDirectionalInput(NavDirection.UP);
      }
      
      public function HandleConfirm() : void
      {
         var _loc1_:DisplayObject = this.Confirm();
         this.FireConfirmEvent(_loc1_);
      }
      
      protected function HandleBack() : void
      {
         this.Back();
         this.FireBackEvent();
      }
      
      public function GetCurrentHighlightPoint() : Point
      {
         var _loc2_:Rectangle = null;
         var _loc1_:DisplayObject = this.GetHighlightedObject() as DisplayObject;
         if(!_loc1_)
         {
            return null;
         }
         var _loc3_:IBoundsOverride = _loc1_ as IBoundsOverride;
         if(_loc3_)
         {
            _loc2_ = _loc3_.GetBoundsOverride(_loc1_.stage);
         }
         else
         {
            _loc2_ = _loc1_.getBounds(_loc1_.stage);
         }
         return new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2);
      }
      
      public function HighlightClosestToPoint(param1:Point, param2:Boolean = false) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc3_:Vector.<DisplayObject> = this.GetVisibleObjects();
         if(!_loc3_ || _loc3_.length == 0)
         {
            return false;
         }
         var _loc4_:DisplayObject = DisplayObjectUtils.FindClosestToPoint(_loc3_,param1);
         this.SetHighlightedObject(_loc4_,param2);
         return true;
      }
      
      public function HighlightDirectionAnalog(param1:Number, param2:Number) : void
      {
         if(Math.abs(param1) > Math.abs(param2))
         {
            if(param1 < 0)
            {
               this.HighlightDirection(-1,0);
            }
            else
            {
               this.HighlightDirection(1,0);
            }
         }
         else if(param2 < 0)
         {
            this.HighlightDirection(0,-1);
         }
         else
         {
            this.HighlightDirection(0,1);
         }
      }
      
      public function ApplyDirectionalInput(param1:uint) : void
      {
         switch(param1)
         {
            case NavDirection.RIGHT:
               this.HighlightDirectionAnalog(1,0);
               break;
            case NavDirection.DOWN:
               this.HighlightDirectionAnalog(0,1);
               break;
            case NavDirection.LEFT:
               this.HighlightDirectionAnalog(-1,0);
               break;
            case NavDirection.UP:
               this.HighlightDirectionAnalog(0,-1);
         }
      }
      
      protected function HighlightDirection(param1:int, param2:int) : void
      {
      }
      
      protected function Confirm() : DisplayObject
      {
         return null;
      }
      
      protected function Back() : void
      {
      }
      
      public function GetVisibleObjects() : Vector.<DisplayObject>
      {
         return null;
      }
      
      public function SetHighlightedObject(param1:DisplayObject, param2:Boolean = false) : void
      {
      }
      
      public function EnablePanOnLeave(param1:Object = null) : InputAdapter
      {
         this.mPanOnLeaveArgs = param1;
         this.SetHighlightClosestOnEnter(true);
         this.OnLeaveCall(this.HandlePanOnLeave);
         return this;
      }
      
      public function HandlePanOnLeave(param1:InputAdapterLeaveEvent) : void
      {
         NavManager.Instance.FocusWidgetPan(param1.GetDirection(),param1.GetFromPosition(),this.mPanOnLeaveArgs);
      }
      
      public function GetStackFocusable(param1:EnterParams = null) : IInputFocusable
      {
         return this;
      }
      
      public function UpdateConfirmActionLegend(param1:LocKey) : void
      {
         if(this.mConfirmAction)
         {
            this.mConfirmAction.SetLegendKey(param1);
         }
      }
      
      public function set DisableNavigation(param1:Boolean) : void
      {
         this.mbDisableNavigation = param1;
      }
      
      public function get DisableNavigation() : Boolean
      {
         return this.mbDisableNavigation;
      }
      
      public function IsZoomAllowed() : Boolean
      {
         return IsCameraZoomAllowed();
      }
      
      public function IsRotateAllowed() : Boolean
      {
         return IsCameraRotateAllowed();
      }
      
      public function IsTravelButtonAllowed() : Boolean
      {
         return false;
      }
   }
}

