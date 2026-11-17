package olympus.core.widget
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import olympus.core.ExtendableComponent;
   import olympus.core.Ticker;
   import olympus.core.interfaces.IBase;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.extensions.TelemetryExtension;
   import olympus.extensions.TutorialTipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.InputAdapter;
   import olympus.interfaces.IAnimation;
   import olympus.io.CommunicationManager;
   import olympus.motion.Tween;
   import olympus.motion.TweenParams;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.SystemUtils;
   import scaleform.clik.controls.ButtonGroup;
   
   public class WidgetBase extends ExtendableComponent implements IBase, IAnimation, IInputFocusable
   {
      
      protected static const TEST_NAME:String = "LocalTest";
      
      public var mcPositionHelper:MovieClip;
      
      public var mcImportedSymbols:Sprite;
      
      protected var mName:String;
      
      protected var mTelemName:String;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mAnimateInParams:TweenParams;
      
      protected var mAnimateInRegPoint:Point = new Point(0.5,0.5);
      
      protected var mAnimateOutParams:TweenParams;
      
      protected var mAnimateOutRegPoint:Point = new Point(0.5,0.5);
      
      protected var mCurrentHUDRootInputAdapters:Vector.<InputAdapter>;
      
      protected var mDisplayObjectsToIgnoreMouse:Vector.<DisplayObject>;
      
      protected var mClickableDisplayObjectsToIgnoreFocus:Vector.<DisplayObject>;
      
      protected var mLastHideTime:int = 0;
      
      protected var mbIsAnimatingHide:Boolean = false;
      
      protected var mOnDemandModalRemainVisibleAcrossGameStateChange:Boolean = false;
      
      protected var mbShouldAddToControllerSimulatedStack:Boolean = false;
      
      public function WidgetBase()
      {
         super();
         if(this.mcPositionHelper)
         {
            this.mcPositionHelper.visible = false;
            this.mcPositionHelper.alpha = 0;
         }
         if(this.mcImportedSymbols)
         {
            removeChild(this.mcImportedSymbols);
            this.mcImportedSymbols = null;
         }
         mouseEnabled = false;
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mAudioExtension.CategoryName = "Widget";
         this.mAudioExtension.ElementName = "Main";
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mCurrentHUDRootInputAdapters = new Vector.<InputAdapter>();
            this.mDisplayObjectsToIgnoreMouse = new Vector.<DisplayObject>();
            this.mClickableDisplayObjectsToIgnoreFocus = new Vector.<DisplayObject>();
         }
      }
      
      public function set WidgetName(param1:String) : void
      {
         if(!this.mName || this.mName == TEST_NAME)
         {
            this.mName = param1;
            CommunicationManager.AddMessageListener("Show" + this.mName,this.Show,this);
            CommunicationManager.AddMessageListener("Hide" + this.mName,this.Hide,this);
            CommunicationManager.AddMessageListener("Toggle" + this.mName,this.Toggle,this);
            CommunicationManager.RegisterServiceHandler("RequestHide" + this.mName,this.HandleRequestHide,this);
         }
      }
      
      public function get WidgetName() : String
      {
         return this.mName;
      }
      
      public function get BaseName() : String
      {
         return this.WidgetName;
      }
      
      public function set TelemetryName(param1:String) : void
      {
         this.mTelemName = param1;
      }
      
      public function get TelemetryName() : String
      {
         return this.mTelemName;
      }
      
      public function get Telemetry() : TelemetryExtension
      {
         return GetExtension(TelemetryExtension) as TelemetryExtension;
      }
      
      public function get CanOnDemandAutoUnload() : Boolean
      {
         return !visible;
      }
      
      public function get OnDemandModalRemainVisibleAcrossGameStateChange() : Boolean
      {
         return visible && this.mOnDemandModalRemainVisibleAcrossGameStateChange;
      }
      
      public function set OnDemandModalRemainVisibleAcrossGameStateChange(param1:Boolean) : void
      {
         this.mOnDemandModalRemainVisibleAcrossGameStateChange = param1;
      }
      
      public function get LastHideTime() : int
      {
         return this.mLastHideTime;
      }
      
      public function get IsAnimatingHide() : Boolean
      {
         return this.mbIsAnimatingHide;
      }
      
      public function Initialize() : void
      {
         var _loc1_:ExtendableComponent = null;
         if(SystemUtils.UsingConsoleInputMode)
         {
            _loc1_ = this["btnClose"] as ExtendableComponent;
            if(_loc1_)
            {
               InputModeVisibilityExtension.ShowForMouseKeyboard(_loc1_);
            }
         }
         this.Telemetry.EnableVisibilityTelemetry = true;
      }
      
      public function Unload() : void
      {
         Ticker.RemoveTickersForWidget(this.mName);
         CommunicationManager.RemoveWidgetFunctions(this.mName);
         Tween.KillAllTweensForLabel(this.mName);
         ButtonGroup.RemoveGroupsForBaseName(this.mName);
         TutorialTipExtension.ClearWidgetTips(this.mName);
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.UnregisterHUDRootInputAdapters(this.mCurrentHUDRootInputAdapters);
            NavManager.Instance.UnregisterAllToIgnoreMouse(this.mDisplayObjectsToIgnoreMouse);
            NavManager.Instance.UnregisterClickablesToIgnoreFocus(this.mClickableDisplayObjectsToIgnoreFocus);
            if(this.mCurrentHUDRootInputAdapters)
            {
               this.mCurrentHUDRootInputAdapters.length = 0;
            }
            if(this.mDisplayObjectsToIgnoreMouse)
            {
               this.mDisplayObjectsToIgnoreMouse.length = 0;
            }
            if(this.mClickableDisplayObjectsToIgnoreFocus)
            {
               this.mClickableDisplayObjectsToIgnoreFocus.length = 0;
            }
         }
      }
      
      public function Show(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         if(this.mAnimateInParams)
         {
            _loc2_ = this.AnimateIn(0,this.mAnimateInParams,this.mAnimateInRegPoint);
            DisplayObjectUtils.CreateInputBlocker(this,_loc2_);
         }
         this.mbIsAnimatingHide = false;
         visible = true;
         this.mAudioExtension.DispatchShow();
         this.Telemetry.DispatchShow();
         TutorialTipExtension.ShowWidgetVisibleTips(this.mName);
         if(SystemUtils.UsingMouseKeyboard && this.mbShouldAddToControllerSimulatedStack)
         {
            NavManager.Instance.AddToControllerSimulatedStack(this.mName);
         }
      }
      
      public function Hide(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         this.mAudioExtension.DispatchHide();
         this.Telemetry.DispatchHide();
         if(this.mAnimateOutParams)
         {
            _loc2_ = this.AnimateOut(0,this.mAnimateOutParams,this.mAnimateOutRegPoint);
            DisplayObjectUtils.CreateInputBlocker(this,_loc2_,null,this.HideComplete);
            this.mbIsAnimatingHide = true;
         }
         else
         {
            this.HideComplete(param1);
         }
         this.mLastHideTime = getTimer();
         TutorialTipExtension.HideWidgetTips(this.mName);
         if(SystemUtils.UsingMouseKeyboard && this.mbShouldAddToControllerSimulatedStack)
         {
            NavManager.Instance.RemoveFromControllerSimulatedStack(this.mName);
         }
      }
      
      public function Toggle(param1:Object = null) : void
      {
         var _loc2_:String = !visible ? "Show" : "Hide";
         CommunicationManager.SendUIMessage(_loc2_ + this.mName,param1);
      }
      
      public function HideComplete(param1:Object = null) : void
      {
         this.mbIsAnimatingHide = false;
         visible = false;
         CommunicationManager.SendUIMessage("HideComplete" + this.WidgetName);
      }
      
      public function HandleStageResized(param1:Number, param2:Number) : void
      {
      }
      
      public function HandleRequestHide(param1:Object) : Object
      {
         CommunicationManager.SendUIMessage("Hide" + this.mName,{});
         return true;
      }
      
      public function AddMessageListener(param1:String, param2:Function, param3:Class = null) : Boolean
      {
         return CommunicationManager.AddMessageListener(param1,param2,this,param3);
      }
      
      public function RemoveMessageListener(param1:String, param2:Function) : Boolean
      {
         return CommunicationManager.RemoveMessageListener(param1,param2,this);
      }
      
      public function RegisterServiceHandler(param1:String, param2:Function) : Boolean
      {
         return CommunicationManager.RegisterServiceHandler(param1,param2,this);
      }
      
      public function UnregisterServiceHandler(param1:String, param2:Function) : Boolean
      {
         return CommunicationManager.UnregisterServiceHandler(param1,param2,this);
      }
      
      public function GetRect() : Rectangle
      {
         return this.mcPositionHelper.getRect(this);
      }
      
      public function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(0,param2,this,this.GetRect(),param3);
         return param2.delay + param2.totalDuration;
      }
      
      public function AnimateOut(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(0,param2,this,this.GetRect(),param3);
         return param2.delay + param2.totalDuration;
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return null;
      }
      
      public function Exit() : void
      {
      }
      
      public function OnEntered(param1:EnterParams = null) : void
      {
      }
      
      public function OnExited() : void
      {
      }
      
      public function IsReadyToEnter(param1:EnterParams = null) : Boolean
      {
         return true;
      }
      
      public function GetWidgetCenterForGamepadNavMesh() : Point
      {
         var _loc1_:Rectangle = DisplayObjectUtils.GetVisibleBounds(this);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      public function SetShouldAddToControllerSimulatedStack(param1:Boolean) : void
      {
         this.mbShouldAddToControllerSimulatedStack = param1;
      }
      
      protected function RegisterHUDRootInputAdapter(param1:InputAdapter) : void
      {
         NavManager.Instance.RegisterHUDRootInputAdapter(param1);
         this.mCurrentHUDRootInputAdapters.push(param1);
      }
      
      protected function RegisterHUDRootInputAdapters(param1:Vector.<InputAdapter>) : void
      {
         NavManager.Instance.RegisterHUDRootInputAdapters(param1);
         this.mCurrentHUDRootInputAdapters = this.mCurrentHUDRootInputAdapters.concat(param1);
      }
      
      protected function RegisterToIgnoreMouse(param1:DisplayObject) : void
      {
         NavManager.Instance.RegisterToIgnoreMouse(param1);
         this.mDisplayObjectsToIgnoreMouse.push(param1);
      }
      
      protected function RegisterAllToIgnoreMouse(param1:Vector.<DisplayObject>) : void
      {
         NavManager.Instance.RegisterAllToIgnoreMouse(param1);
         this.mDisplayObjectsToIgnoreMouse = this.mDisplayObjectsToIgnoreMouse.concat(param1);
      }
      
      protected function RegisterClickableToIgnoreFocus(param1:DisplayObject) : void
      {
         NavManager.Instance.RegisterClickableToIgnoreFocus(param1);
         this.mClickableDisplayObjectsToIgnoreFocus.push(param1);
      }
      
      protected function RegisterClickablesToIgnoreFocus(param1:Vector.<DisplayObject>) : void
      {
         NavManager.Instance.RegisterClickablesToIgnoreFocus(param1);
         this.mClickableDisplayObjectsToIgnoreFocus = this.mClickableDisplayObjectsToIgnoreFocus.concat(param1);
      }
      
      override public function toString() : String
      {
         return "[WidgetBase " + this.WidgetName + "]";
      }
   }
}

