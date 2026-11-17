package olympus.input.helpers
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.constants.ActionCodes;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.gamepad.NavManager;
   import olympus.gui.sliders.Slider;
   import olympus.input.GamepadAnalogSticks;
   import olympus.input.IInputAdapter;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.InputAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterHighlightEvent;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   
   public class SliderHelper
   {
      
      protected static var sScrollInputAction:InputAction;
      
      protected static var sScrollInputActionInModal:InputAction;
      
      protected var mAdapter:InputAdapter;
      
      protected var mSlider:Slider;
      
      protected var mMargin:Number;
      
      protected var mbAnimate:Boolean;
      
      protected var mbCenterHighlight:Boolean;
      
      protected var mRStickScrollTicker:Object = null;
      
      protected var mOnRStickFunction:Function = null;
      
      protected var mCanPerformRStickFunction:Function = null;
      
      protected var mRStickScrollSpeed:Number = 10;
      
      protected var mbUseRStickScroll:Boolean = false;
      
      protected var mbUseRStickScrollIcon:Boolean = false;
      
      protected var mbUseRStickScrollClearHighlightOnScroll:Boolean = false;
      
      protected var mbUseRStickScrollAutoHighlight:Boolean = false;
      
      protected var mbSuppressAutoScroll:Boolean = false;
      
      protected var mbPreventScrollToObjectOnHighlight:Boolean = false;
      
      public function SliderHelper(param1:InputAdapter)
      {
         super();
         this.mAdapter = param1;
         this.mAdapter.OnHighlightChangeCall(this.OnHighlight);
      }
      
      public function set PreventScrollToDisplayObject(param1:Boolean) : void
      {
         this.mbPreventScrollToObjectOnHighlight = param1;
      }
      
      public function AddAdapter(param1:IInputAdapter) : *
      {
         param1.OnInputEventCall(InputAdapterEvent.HIGHLIGHT_CHANGED,this.OnHighlight);
      }
      
      public function SetSliderAndMargin(param1:Slider, param2:Number) : void
      {
         this.mSlider = param1;
         this.mMargin = param2;
      }
      
      public function SetAnimated(param1:Boolean) : void
      {
         this.mbAnimate = param1;
      }
      
      public function SwitchSlider(param1:Slider) : void
      {
         if(param1 != this.mSlider)
         {
            this.RemoveRStickScrolling();
            this.mSlider = param1;
            this.SetupRStickScrolling();
         }
      }
      
      public function UseRStickScroll(param1:Number = 0, param2:Boolean = false) : *
      {
         this.SetUseRStickScroll(true,true);
         this.SetUseRStickScrollAutoHighlight(true);
         this.SetupRStickLegend(param2);
         if(param1 != 0)
         {
            this.SetRStickScrollSpeed(param1);
         }
      }
      
      public function SetUseRStickScroll(param1:Boolean, param2:Boolean, param3:Function = null) : void
      {
         this.mbUseRStickScroll = param1;
         this.mbUseRStickScrollIcon = param2;
         this.mOnRStickFunction = param3;
      }
      
      public function SwitchUseRStickScroll(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:Boolean = param1 != this.mbUseRStickScroll;
         var _loc4_:Boolean = param2 != this.mbUseRStickScrollIcon;
         if(_loc3_ || _loc4_)
         {
            this.RemoveRStickScrolling();
            this.mbUseRStickScroll = param1;
            this.mbUseRStickScrollIcon = param2;
            this.SetupRStickScrolling();
         }
      }
      
      public function SetUseRStickScrollClearHighlightOnScroll(param1:Boolean) : void
      {
         this.mbUseRStickScrollClearHighlightOnScroll = param1;
      }
      
      public function SetUseRStickScrollAutoHighlight(param1:Boolean) : void
      {
         this.mbUseRStickScrollAutoHighlight = param1;
      }
      
      public function SetCanPerformRStickFunction(param1:Function) : void
      {
         this.mCanPerformRStickFunction = param1;
      }
      
      public function SetRStickScrollSpeed(param1:Number) : void
      {
         this.mRStickScrollSpeed = param1;
      }
      
      public function SetCenterHighlight(param1:Boolean) : void
      {
         this.mbCenterHighlight = param1;
      }
      
      public function UnregisterCallbacks() : void
      {
         this.mAdapter.RemoveHighlightChangeCall(this.OnHighlight);
      }
      
      protected function OnHighlight(param1:InputAdapterHighlightEvent) : void
      {
         if(!this.mSlider || this.mSlider.stage == null)
         {
            return;
         }
         var _loc2_:DisplayObject = param1.GetDisplayObject();
         if(_loc2_)
         {
            this.ScrollToDisplayObject(_loc2_);
         }
      }
      
      public function ScrollToDisplayObject(param1:DisplayObject, param2:Boolean = true) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.mbSuppressAutoScroll)
         {
            return;
         }
         if(this.mbPreventScrollToObjectOnHighlight)
         {
            return;
         }
         if(!param1 || !this.mSlider)
         {
            return;
         }
         var _loc3_:Rectangle = param1.getBounds(this.mSlider.stage);
         var _loc4_:Rectangle = this.mSlider.getBounds(this.mSlider.stage);
         if(this.mbCenterHighlight)
         {
            this.mSlider.SetCurrentValue(_loc3_.top - _loc4_.top - _loc4_.height / 2 + _loc3_.height / 2,this.mbAnimate,false);
         }
         else
         {
            _loc5_ = this.GetBottomMargin();
            _loc6_ = this.GetTopMargin();
            if(_loc3_.height > _loc4_.height)
            {
               if(param2)
               {
                  this.mSlider.SetCurrentValue(_loc3_.bottom - _loc4_.bottom + _loc5_,this.mbAnimate,false);
               }
               else
               {
                  this.mSlider.SetCurrentValue(_loc3_.top - _loc4_.top - _loc6_,this.mbAnimate,false);
               }
            }
            else if(_loc3_.bottom + _loc5_ > _loc4_.bottom)
            {
               this.mSlider.SetCurrentValue(_loc3_.bottom - _loc4_.bottom + _loc5_,this.mbAnimate,false);
            }
            else if(_loc3_.top - _loc6_ < _loc4_.top)
            {
               this.mSlider.SetCurrentValue(_loc3_.top - _loc4_.top - _loc6_,this.mbAnimate,false);
            }
         }
      }
      
      public function ScrollToPosition(param1:Number) : void
      {
         if(!this.mSlider || this.mbSuppressAutoScroll)
         {
            return;
         }
         this.mSlider.SetCurrentValue(param1,this.mbAnimate);
      }
      
      public function ScrollToTop() : void
      {
         if(!this.mSlider || this.mbSuppressAutoScroll)
         {
            return;
         }
         this.mSlider.SetCurrentValue(this.mSlider.MinValue,this.mbAnimate);
      }
      
      public function ScrollToBottom() : void
      {
         if(!this.mSlider || this.mbSuppressAutoScroll)
         {
            return;
         }
         this.mSlider.SetCurrentValue(this.mSlider.MaxValue,this.mbAnimate);
      }
      
      protected function GetBottomMargin() : Number
      {
         return this.mMargin;
      }
      
      protected function GetTopMargin() : Number
      {
         return this.mMargin;
      }
      
      public function SetupRStickLegend(param1:Boolean = false) : void
      {
         if(sScrollInputAction == null)
         {
            sScrollInputAction = this.CreateRStickInputActionForLegend(false);
            sScrollInputActionInModal = this.CreateRStickInputActionForLegend(true);
         }
         if(this.mAdapter.GetFirstInputAction(sScrollInputAction.inputTrigger.Code))
         {
            return;
         }
         this.mAdapter.AddInputAction(param1 ? sScrollInputActionInModal : sScrollInputActionInModal);
      }
      
      public function SetupRStickScrolling() : void
      {
         if(this.mbUseRStickScroll && this.mRStickScrollTicker == null)
         {
            this.mRStickScrollTicker = new Object();
            Ticker.Add(this.mRStickScrollTicker,0,this.RStickScrollTick);
         }
         if(this.mbUseRStickScrollIcon && Boolean(this.mSlider))
         {
            this.mSlider.InitRStickIcon();
            this.mSlider.EnableRStickIcon(true);
         }
      }
      
      public function RemoveRStickScrolling() : void
      {
         if(this.mRStickScrollTicker != null)
         {
            Ticker.Remove(this.mRStickScrollTicker);
            this.mRStickScrollTicker = null;
         }
         if(this.mSlider)
         {
            this.mSlider.EnableRStickIcon(false);
         }
      }
      
      protected function RStickScrollTick(param1:TickerEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:Point = null;
         if(!this.mSlider || this.mSlider.stage == null)
         {
            return;
         }
         var _loc2_:Boolean = true;
         if(this.mCanPerformRStickFunction != null)
         {
            _loc2_ = this.mCanPerformRStickFunction(this);
         }
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Number = GamepadAnalogSticks.ApplyDeadzoneToValue(GamepadAnalogSticks.GetRightY());
         if(_loc3_ == 0)
         {
            return;
         }
         var _loc4_:Number = -_loc3_ * this.mRStickScrollSpeed;
         this.mSlider.SetCurrentValue(_loc4_,false,false);
         if(this.mbUseRStickScrollClearHighlightOnScroll)
         {
            NavManager.Instance.RequestHighlight(null);
         }
         if(Boolean(this.mOnRStickFunction) || this.mbUseRStickScrollAutoHighlight)
         {
            _loc5_ = this.mSlider.Value / (this.mSlider.MaxValue - this.mSlider.MinValue);
            _loc6_ = this.mSlider.localToGlobal(new Point(this.mSlider.mcThumb.x,this.mSlider.mcThumb.y + this.mSlider.mcThumb.height * _loc5_));
            _loc7_ = this.mAdapter.GetHighlightedObject();
            if(_loc7_)
            {
               _loc8_ = _loc7_.parent.localToGlobal(new Point(_loc7_.x + _loc7_.width * 0.5,_loc7_.y + _loc7_.height * 0.5));
               _loc6_.x = _loc8_.x;
            }
            this.mbSuppressAutoScroll = true;
            if(Boolean(this.mOnRStickFunction))
            {
               this.mOnRStickFunction(_loc6_);
            }
            if(this.mbUseRStickScrollAutoHighlight)
            {
               this.mAdapter.HighlightClosestToPoint(_loc6_,false);
            }
            this.mbSuppressAutoScroll = false;
         }
      }
      
      public function CreateRStickInputActionForLegend(param1:Boolean, param2:LocKey = null) : InputAction
      {
         return InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.RIGHT_STICK_MOVE_FAKE)).AllowWhileModalOpen(param1).SetLegendKey(param2 ? param2 : KeysConsole.GENERIC_SCROLL);
      }
   }
}

