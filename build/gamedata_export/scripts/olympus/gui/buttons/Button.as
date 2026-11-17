package olympus.gui.buttons
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import olympus.controls.GUIComponent;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.CursorExtension;
   import olympus.extensions.HighlightExtension;
   import olympus.extensions.Selectability;
   import olympus.extensions.TooltipExtension;
   import olympus.interfaces.IBoundsOverride;
   import olympus.interfaces.IStatesUser;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   
   public class Button extends GUIComponent implements IStatesUser, IView, IBoundsOverride
   {
      
      protected static const STATE_MAP:Object = {
         "up":["up"],
         "over":["over"],
         "down":["down"],
         "release":["release","over"],
         "out":["out","up"],
         "disabled":["disabled"],
         "disabledOver":["disabledOver","disabled"],
         "toggle":["toggle","up"],
         "wiggle":["wiggle","up"],
         "updated":["updated"]
      };
      
      protected static const DEFAULT_PREFIX_MAP:Object = {
         "none":[""],
         "selected":["selected_",""],
         "drag":["drag_",""],
         "drag_selected":["drag_selected_","selected_",""]
      };
      
      protected static const DEFAULT_CONTROLLER_PREFIX_MAP:Object = {
         "none":[""],
         "selected":["selected_",""],
         "drag":["drag_",""],
         "drag_selected":["drag_selected_","selected_",""],
         "controller":["controller_",""],
         "controller_selected":["controller_selected_","selected_","controller_",""],
         "controller_drag":["controller_drag_","drag_","controller_",""],
         "controller_drag_selected":["controller_drag_selected_","controller_selected_","drag_selected_","selected_","controller_",""]
      };
      
      protected static const CONTROLLER_PREFIX:String = "controller_";
      
      protected static const CONTROLLER_STATE:String = "controller";
      
      protected var mPrefixMap:Object;
      
      protected var mControllerPrefixMap:Object;
      
      protected var mMouseKeyboardPrefixMap:Object;
      
      protected var mStatePrefixes:Array = new Array();
      
      protected var mState:String = "up";
      
      protected var mbStopClickPropagation:Boolean = false;
      
      protected var mbClearTooltipOnClick:Boolean = true;
      
      protected var mbIsToggleButton:Boolean = false;
      
      protected var mAllowedButtonMask:uint = InputUtils.LEFT_BUTTON;
      
      protected var mFrameLabels:Object;
      
      protected var mbHasTween:Boolean = false;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mCursorExtension:CursorExtension;
      
      protected var mSelectExtension:Selectability;
      
      protected var mHighlightExtension:HighlightExtension;
      
      protected var mTooltipExtension:TooltipExtension;
      
      public function Button()
      {
         super();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mControllerPrefixMap = DEFAULT_CONTROLLER_PREFIX_MAP;
            this.mMouseKeyboardPrefixMap = DEFAULT_PREFIX_MAP;
         }
         if(SystemUtils.UsingController)
         {
            this.mPrefixMap = DEFAULT_CONTROLLER_PREFIX_MAP;
         }
         else
         {
            this.mPrefixMap = DEFAULT_PREFIX_MAP;
         }
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mCursorExtension = GetExtension(CursorExtension) as CursorExtension;
         this.mSelectExtension = GetExtension(Selectability) as Selectability;
         this.mHighlightExtension = GetExtension(HighlightExtension) as HighlightExtension;
         this.mTooltipExtension = GetExtension(TooltipExtension) as TooltipExtension;
         this.mAudioExtension.CategoryName = "Button";
         this.mAudioExtension.Hookup(PushButtonEvent.CLICK);
         this.mAudioExtension.Hookup(PushButtonEvent.PRESS);
         this.mAudioExtension.Hookup(PushButtonEvent.RELEASE_OUT);
      }
      
      protected static function CheckControllerPrefixed(param1:String) : Boolean
      {
         return param1.length > 0 && param1.indexOf(CONTROLLER_PREFIX) < 0;
      }
      
      protected static function GetStatePrefixKey(param1:Array) : String
      {
         if(param1.length == 0)
         {
            return "none";
         }
         return param1.join("_");
      }
      
      public function set PrefixMap(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:* = 0;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         this.mMouseKeyboardPrefixMap = param1;
         if(SystemUtils.UsingConsoleInputMode)
         {
            _loc2_ = new Object();
            for(_loc3_ in param1)
            {
               if(_loc3_.indexOf(CONTROLLER_STATE) < 0 && _loc3_ != "none")
               {
                  _loc2_[_loc3_] = param1[_loc3_];
               }
            }
            if(param1[CONTROLLER_STATE] == null)
            {
               param1[CONTROLLER_STATE] = [CONTROLLER_PREFIX,""];
            }
            for(_loc3_ in _loc2_)
            {
               _loc4_ = _loc2_[_loc3_];
               _loc5_ = _loc4_.filter(CheckControllerPrefixed);
               _loc6_ = _loc5_.length;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc5_[_loc7_] = CONTROLLER_PREFIX + _loc5_[_loc7_];
                  _loc7_++;
               }
               _loc8_ = _loc5_.concat(_loc4_);
               _loc9_ = _loc8_.length;
               _loc10_ = int(_loc9_ - 1);
               while(_loc10_ >= 0)
               {
                  if(_loc8_[_loc10_].length == 0)
                  {
                     _loc8_.splice(_loc10_,0,CONTROLLER_PREFIX);
                  }
                  _loc10_--;
               }
               if(_loc3_.charAt(0) <= CONTROLLER_STATE.charAt(0))
               {
                  _loc12_ = _loc3_.split("_");
                  _loc12_.push(CONTROLLER_STATE);
                  _loc12_.sort();
                  _loc11_ = _loc12_.join("_");
               }
               else
               {
                  _loc11_ = CONTROLLER_PREFIX + _loc3_;
               }
               param1[_loc11_] = _loc8_;
            }
            this.mControllerPrefixMap = param1;
         }
         if(SystemUtils.UsingController)
         {
            this.mPrefixMap = this.mControllerPrefixMap;
         }
         else
         {
            this.mPrefixMap = this.mMouseKeyboardPrefixMap;
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(super.enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         if(super.enabled)
         {
            this.SetState(Boolean(stage) && hitTestPoint(stage.mouseX,stage.mouseY,true) ? "over" : "up");
         }
         else
         {
            this.SetState(this.mState == "over" || this.mState == "release" ? "disabledOver" : "disabled");
         }
      }
      
      override public function set doubleClickEnabled(param1:Boolean) : void
      {
         super.doubleClickEnabled = param1;
         if(param1)
         {
            addEventListener(MouseEvent.DOUBLE_CLICK,this.OnMouseDoubleClick,false,0,true);
         }
         else
         {
            removeEventListener(MouseEvent.DOUBLE_CLICK,this.OnMouseDoubleClick,false);
         }
      }
      
      public function get RightMouseButtonEnabled() : Boolean
      {
         return (this.mAllowedButtonMask & InputUtils.RIGHT_BUTTON) != 0;
      }
      
      public function set RightMouseButtonEnabled(param1:Boolean) : void
      {
         this.mAllowedButtonMask = param1 ? uint(this.mAllowedButtonMask | InputUtils.RIGHT_BUTTON) : uint(this.mAllowedButtonMask ^ InputUtils.RIGHT_BUTTON);
      }
      
      public function set StopClickPropagation(param1:Boolean) : void
      {
         this.mbStopClickPropagation = param1;
      }
      
      public function set ClearTooltipOnClick(param1:Boolean) : void
      {
         this.mbClearTooltipOnClick = param1;
      }
      
      public function get AudioExt() : AudioExtension
      {
         return this.mAudioExtension;
      }
      
      public function get CursorExt() : CursorExtension
      {
         return this.mCursorExtension;
      }
      
      public function get Selected() : Boolean
      {
         return this.mSelectExtension.Selected;
      }
      
      public function set Selected(param1:Boolean) : void
      {
         this.mSelectExtension.Selected = param1;
      }
      
      public function get Toggle() : Boolean
      {
         return this.mbIsToggleButton;
      }
      
      public function set Toggle(param1:Boolean) : void
      {
         this.mbIsToggleButton = param1;
      }
      
      public function get TooltipExt() : TooltipExtension
      {
         return this.mTooltipExtension;
      }
      
      public function SetState(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         this.mState = param1;
         if(!mbInitialized)
         {
            return;
         }
         _loc2_ = GetStatePrefixKey(this.mStatePrefixes);
         var _loc3_:Array = this.mPrefixMap[_loc2_];
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = STATE_MAP[param1];
            if(_loc6_ == null)
            {
               return;
            }
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc3_[_loc5_] + _loc6_[_loc8_];
               if(this.mFrameLabels[_loc9_])
               {
                  gotoAndPlay(_loc9_);
                  if(this.mbHasTween)
                  {
                     visible = !visible;
                     visible = !visible;
                  }
                  return;
               }
               _loc8_++;
            }
            _loc5_++;
         }
      }
      
      public function GetStatePrefix() : String
      {
         var _loc1_:uint = 0;
         if(this.mStatePrefixes.length)
         {
            if(!SystemUtils.UsingController)
            {
               return this.mStatePrefixes[0];
            }
            _loc1_ = 0;
            while(_loc1_ < this.mStatePrefixes.length)
            {
               if(this.mStatePrefixes[_loc1_].indexOf(CONTROLLER_STATE) < 0)
               {
                  return this.mStatePrefixes[_loc1_];
               }
               _loc1_++;
            }
         }
         return "";
      }
      
      public function SetStatePrefix(param1:String) : void
      {
         var _loc2_:String = GetStatePrefixKey(this.mStatePrefixes);
         this.mStatePrefixes.length = 0;
         if(param1)
         {
            if(!SystemUtils.UsingController || param1 != "none")
            {
               this.mStatePrefixes = [param1];
            }
            if(SystemUtils.UsingController && param1 != CONTROLLER_STATE)
            {
               this.mStatePrefixes.push(CONTROLLER_STATE);
               this.mStatePrefixes.sort();
            }
         }
         if(_loc2_ != GetStatePrefixKey(this.mStatePrefixes))
         {
            this.ApplyStatePrefixes();
         }
      }
      
      public function EnableStatePrefix(param1:String, param2:Boolean = true) : void
      {
         if(this.mStatePrefixes.length == 0)
         {
            this.SetStatePrefix(param1);
            return;
         }
         var _loc3_:Array = this.mStatePrefixes;
         if(_loc3_.indexOf(param1) >= 0)
         {
            return;
         }
         _loc3_.push(param1);
         _loc3_.sort();
         if(param2)
         {
            this.ApplyStatePrefixes();
         }
      }
      
      public function DisableStatePrefix(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Array = null;
         if(this.mStatePrefixes.length == 0)
         {
            return;
         }
         _loc3_ = this.mStatePrefixes;
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ < 0)
         {
            return;
         }
         _loc3_.splice(_loc4_,1);
         if(param2)
         {
            this.ApplyStatePrefixes();
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         var _loc1_:Array = this.currentLabels;
         var _loc2_:int = int(_loc1_.length);
         this.mFrameLabels = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.mFrameLabels[_loc1_[_loc3_].name] = true;
            _loc3_++;
         }
         mouseChildren = false;
         mbInitialized = true;
         this.SetState(this.mState);
         if(SystemUtils.UsingController)
         {
            this.EnableStatePrefix(CONTROLLER_STATE);
         }
      }
      
      protected function OnMouseRollOver(param1:MouseEvent) : void
      {
         this.mTooltipExtension.SendTooltipEvent(param1);
         if(enabled)
         {
            this.SetState(this.mState == "down" ? "down" : "over");
         }
         else
         {
            this.SetState("disabledOver");
         }
      }
      
      protected function OnMouseRollOut(param1:MouseEvent) : void
      {
         this.mTooltipExtension.SendTooltipEvent(param1);
         if(enabled)
         {
            this.SetState(this.mState == "down" ? "down" : "out");
         }
         else
         {
            this.SetState("disabled");
         }
      }
      
      protected function OnMousePress(param1:MouseEvent) : void
      {
         if(!InputUtils.IsButtonAllowed(param1,this.mAllowedButtonMask))
         {
            return;
         }
         if(enabled)
         {
            this.SetState("down");
            dispatchEvent(new PushButtonEvent(PushButtonEvent.PRESS,InputUtils.GetButtonIndex(param1)));
            this.mCursorExtension.LockCursor();
            if(stage)
            {
               stage.addEventListener(MouseEvent.MOUSE_UP,this.OnStageMouseUp,false,0,true);
            }
         }
         if(this.mbStopClickPropagation)
         {
            param1.stopPropagation();
         }
      }
      
      protected function OnMouseRelease(param1:MouseEvent) : void
      {
         if(!InputUtils.IsButtonAllowed(param1,this.mAllowedButtonMask))
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnStageMouseUp);
         if(enabled)
         {
            this.SetState("release");
            this.mCursorExtension.UnlockCursor();
            if(this.mbIsToggleButton)
            {
               this.Selected = !this.Selected;
            }
            dispatchEvent(new PushButtonEvent(PushButtonEvent.CLICK,InputUtils.GetButtonIndex(param1)));
            if(this.mbClearTooltipOnClick)
            {
               this.mTooltipExtension.Clear();
            }
         }
         if(this.mbStopClickPropagation)
         {
            param1.stopPropagation();
         }
      }
      
      protected function OnMouseDoubleClick(param1:MouseEvent) : void
      {
         if(!InputUtils.IsButtonAllowed(param1,this.mAllowedButtonMask))
         {
            return;
         }
         this.mCursorExtension.UnlockCursor();
      }
      
      protected function OnStageMouseUp(param1:MouseEvent) : void
      {
         if(contains(param1.target as DisplayObject))
         {
            return;
         }
         if(Boolean(stage) && stage.hasEventListener(MouseEvent.MOUSE_UP))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnStageMouseUp);
         }
         dispatchEvent(new PushButtonEvent(PushButtonEvent.RELEASE_OUT,InputUtils.GetButtonIndex(param1)));
         this.SetState(enabled ? "up" : "disabled");
         this.mCursorExtension.UnlockCursor();
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver,false);
         removeEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut,false);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMousePress,false);
         removeEventListener(MouseEvent.CLICK,this.OnMouseRelease,false);
         if(SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.RemoveMessageListenerByName("UsingControllerToggled",this.HandleUsingControllerToggled,"Button");
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnStageMouseUp,false);
         }
         super.OnRemovedFromStage(param1);
      }
      
      override protected function OnAddedToStage(param1:Event) : void
      {
         super.OnAddedToStage(param1);
         addEventListener(MouseEvent.ROLL_OVER,this.OnMouseRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.OnMouseRollOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMousePress,false,0,true);
         addEventListener(MouseEvent.CLICK,this.OnMouseRelease,false,0,true);
         if(SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.AddMessageListenerByName("UsingControllerToggled",this.HandleUsingControllerToggled,"Button");
         }
      }
      
      protected function ApplyStatePrefixes() : void
      {
         var _loc1_:Array = null;
         if(this.currentLabel)
         {
            _loc1_ = this.currentLabel.split("_");
            if(_loc1_.length > 0)
            {
               this.SetState(_loc1_.pop());
            }
         }
      }
      
      public function Draw(param1:Object, param2:Object = null) : void
      {
         if(Boolean(param1) && Boolean("tooltipData" in param1) && Boolean(this.mTooltipExtension))
         {
            this.mTooltipExtension.Data = param1.tooltipData;
         }
         if(Boolean(param2) && "isSelected" in param2)
         {
            this.Selected = param2.isSelected;
         }
      }
      
      public function UpdateViewport(param1:Rectangle) : void
      {
         x = param1.x;
         y = param1.y;
         if(param1.width > 0)
         {
            width = param1.width;
         }
         if(param1.height > 0)
         {
            height = param1.height;
         }
      }
      
      public function GetBoundsOverride(param1:DisplayObject) : Rectangle
      {
         if(mcHitArea)
         {
            return mcHitArea.getBounds(param1);
         }
         return getBounds(param1);
      }
      
      protected function HandleUsingControllerToggled() : void
      {
         if(SystemUtils.UsingController)
         {
            this.mPrefixMap = this.mControllerPrefixMap;
            this.DisableStatePrefix("none");
            this.EnableStatePrefix(CONTROLLER_STATE);
         }
         else
         {
            this.mPrefixMap = this.mMouseKeyboardPrefixMap;
            this.DisableStatePrefix(CONTROLLER_STATE);
         }
      }
   }
}

