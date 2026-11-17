package olympus.gui.sliders
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import olympus.audio.Audio;
   import olympus.controls.GUIComponent;
   import olympus.controls.IconComponent;
   import olympus.core.cursors.Cursors;
   import olympus.events.PushButtonEvent;
   import olympus.events.SmoothSliderEvent;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.CursorExtension;
   import olympus.extensions.HighlightExtension;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.gui.buttons.Button;
   import olympus.motion.Easing;
   import olympus.motion.Tween;
   import olympus.utils.Clamp;
   import olympus.utils.LibraryUtils;
   import olympus.utils.SystemUtils;
   
   public class Slider extends GUIComponent
   {
      
      public static const SLIDER_THUMB_MOTION_DURATION:Number = 500;
      
      public static const SLIDER_THUMB_MIN_HEIGHT:Number = 30;
      
      public static const SLIDER_CONSOLE_ICON_SIZE:Number = 21;
      
      public static const SLIDER_CONSOLE_ICON_TRACK_PADDING_X:Number = 2;
      
      public static const SLIDER_CONSOLE_ICON_TRACK_PADDING_Y:Number = 2;
      
      public static const SLIDER_RSTICK_IMAGE_PS4:String = "0x8b7f31df9e1d7331";
      
      public static const SLIDER_RSTICK_IMAGE_XB1:String = "0x39f59bc3c7330a23";
      
      public var mcThumb:Button;
      
      public var mcTrack:Button;
      
      public var mcIcon:IconComponent;
      
      protected var mHighlightExtension:HighlightExtension;
      
      protected var mbIsDragging:Boolean;
      
      protected var mDraggingThumb:Button;
      
      protected var mMinValue:Number = 0;
      
      protected var mMaxValue:Number = 100;
      
      protected var mValueRange:Number = 100;
      
      protected var mCurValue:Number = 0;
      
      protected var mCurSnappedValue:Number = 0;
      
      protected var mbIsVertical:Boolean = true;
      
      protected var mPreviousMousePos:Number = 0;
      
      protected var mbAlwaysVisible:Boolean = true;
      
      protected var mSliderMin:Number = 0;
      
      protected var mSliderMax:Number = 0;
      
      protected var mSliderLength:Number = 0;
      
      protected var mSnapInterval:Number = 0;
      
      protected var mSliderSizeRatio:Number = 0;
      
      protected var mThumbTween:Tween;
      
      protected var mThumbs:Array = [];
      
      public function Slider()
      {
         super();
         this.mThumbs.push(this.mcThumb);
         this.mcTrack.height *= scaleY;
         scaleY = scaleX = 1;
         this.mHighlightExtension = GetExtension(HighlightExtension) as HighlightExtension;
         var _loc1_:AudioExtension = GetExtension(AudioExtension) as AudioExtension;
         _loc1_.CategoryName = "Slider";
         _loc1_.ElementName = "SmoothSlider";
         _loc1_.Hookup(SmoothSliderEvent.DRAG_START,Audio.SLIDER_DRAG_START);
         _loc1_.Hookup(SmoothSliderEvent.DRAG_END,Audio.SLIDER_DRAG_END);
         _loc1_.Hookup(SmoothSliderEvent.DRAG_CONTINUE,Audio.SLIDER_LIVE_CHANGE);
         this.mThumbTween = new Tween(0,this.mcThumb);
      }
      
      override public function get width() : Number
      {
         return this.mcTrack.width;
      }
      
      override public function set width(param1:Number) : void
      {
         this.mcTrack.width = param1;
         this.mcThumb.width = param1;
         if(!this.mbIsVertical)
         {
            this.UpdateSliderDimensions();
         }
      }
      
      override public function get height() : Number
      {
         return this.mcTrack.y + this.mcTrack.height;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = 0;
         if(Boolean(this.mcIcon) && this.mcIcon.visible)
         {
            _loc2_ = this.mcIcon.y + SLIDER_CONSOLE_ICON_SIZE + SLIDER_CONSOLE_ICON_TRACK_PADDING_Y;
            this.mcTrack.height = param1 - _loc2_;
         }
         else
         {
            this.mcTrack.height = param1;
         }
         this.mcTrack.y = _loc2_;
         if(this.mbIsVertical)
         {
            if(this.mSliderSizeRatio != 0)
            {
               this.SetThumbSize(this.mSliderSizeRatio);
            }
            else
            {
               this.UpdateSliderDimensions();
            }
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.mcThumb.enabled = param1;
         this.mcTrack.enabled = param1;
      }
      
      public function set SnapInterval(param1:Number) : void
      {
         this.mSnapInterval = param1;
      }
      
      public function get SnapInterval() : Number
      {
         return this.mSnapInterval;
      }
      
      public function get Value() : Number
      {
         return this.mCurValue;
      }
      
      public function get AllValues() : Array
      {
         return [this.Value];
      }
      
      public function get MinValue() : Number
      {
         return this.mMinValue;
      }
      
      public function get MaxValue() : Number
      {
         return this.mMaxValue;
      }
      
      public function get IsDragging() : Boolean
      {
         return this.mbIsDragging;
      }
      
      public function set AlwaysVisible(param1:Boolean) : void
      {
         this.mbAlwaysVisible = param1;
      }
      
      public function get AlwaysVisible() : Boolean
      {
         return this.mbAlwaysVisible;
      }
      
      public function SetCurrentValue(param1:Number, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true) : void
      {
         if(this.mMaxValue < 0)
         {
            return;
         }
         if(!param3)
         {
            param1 += this.mCurValue;
         }
         if(this.mThumbs.length > 1 && param1 >= this.AllValues[1])
         {
            return;
         }
         param1 = Clamp.Num(param1,this.mMinValue,this.mMaxValue);
         var _loc5_:Number = this.mCurValue;
         this.mCurValue = param1;
         var _loc6_:Number = this.SnapValue(param1);
         this.mCurSnappedValue = _loc6_;
         if(param4)
         {
            if(param2)
            {
               dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.SLIDE,_loc6_,_loc5_,this.AllValues));
            }
            else
            {
               dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.SNAP,_loc6_,0,this.AllValues));
            }
         }
         var _loc7_:Number = (_loc6_ - this.mMinValue) / this.mValueRange;
         this.AdjustThumbPosition(_loc7_,param2);
      }
      
      public function SetCurrentValues(param1:Array, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true) : void
      {
         if(param1.length == 0)
         {
            throw new Error("Empty array passed to Slider::SetCurrentValues.");
         }
         this.SetCurrentValue(param1[0],param2,param3,param4);
      }
      
      public function SetValueRange(param1:Number, param2:Number, param3:Number = 0) : void
      {
         this.mMinValue = param1;
         this.mMaxValue = param2;
         this.mValueRange = this.mMaxValue - this.mMinValue;
         this.mSnapInterval = param3;
         this.enabled = param2 > 0;
         visible = this.mbAlwaysVisible || enabled;
         this.mcThumb.visible = this.mbAlwaysVisible ? enabled : true;
         this.mcTrack.enabled = enabled;
      }
      
      public function SetThumbSize(param1:Number = 0) : void
      {
         if(param1 == 0)
         {
            this.mSliderSizeRatio = 0;
            return;
         }
         param1 = Math.min(1,param1);
         this.mSliderSizeRatio = param1;
         if(this.mbIsVertical)
         {
            this.mcThumb.height = Math.max(SLIDER_THUMB_MIN_HEIGHT,param1 * this.mcTrack.height);
         }
         this.UpdateSliderDimensions();
      }
      
      public function EnableAutoScroll() : void
      {
      }
      
      public function ForceDragEnd() : void
      {
         (this.mcThumb.GetExtension(CursorExtension) as CursorExtension).UnlockCursor();
         if(this.mbIsDragging)
         {
            this.OnEndDrag(null);
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.mcThumb.addEventListener(PushButtonEvent.PRESS,this.OnThumbPress,false,0,true);
         this.mcThumb.addEventListener(PushButtonEvent.CLICK,this.OnThumbRelease,false,0,true);
         this.mcThumb.AudioExt.ElementName = "SliderThumb";
         this.mcThumb.AudioExt.CategoryName = "SliderThumb";
         (this.mcThumb.GetExtension(CursorExtension) as CursorExtension).ConfigureCursors(Cursors.HAND_OPEN,Cursors.HAND_CLOSED);
         this.mcTrack.addEventListener(PushButtonEvent.PRESS,this.OnTrackPress,false,0,true);
         this.mcTrack.addEventListener(PushButtonEvent.CLICK,this.OnTrackClick,false,0,true);
         this.mcTrack.AudioExt.ElementName = "SliderTrack";
         this.UpdateSliderDimensions();
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         super.OnRemovedFromStage(param1);
         this.ForceDragEnd();
      }
      
      protected function OnThumbPress(param1:PushButtonEvent) : void
      {
         var _loc2_:Boolean = this.mbIsDragging;
         if(_loc2_)
         {
            return;
         }
         _loc2_ = true;
         this.mDraggingThumb = this.mcThumb;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnPerformDrag,false,0,true);
         this.mcThumb.addEventListener(PushButtonEvent.CLICK,this.OnEndDrag,false,0,true);
         this.mcThumb.addEventListener(PushButtonEvent.RELEASE_OUT,this.OnEndDrag,false,0,true);
         this.mPreviousMousePos = this.mbIsVertical ? mouseY : mouseX;
         this.mcThumb.TooltipExt.Clear(true);
         this.mbIsDragging = _loc2_;
         dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.DRAG_START,this.mCurValue,this.mCurValue,this.AllValues));
      }
      
      protected function OnThumbRelease(param1:PushButtonEvent) : void
      {
         this.mbIsDragging = false;
         this.mDraggingThumb = null;
         this.mCurValue = this.mCurSnappedValue;
      }
      
      protected function OnEndDrag(param1:PushButtonEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnPerformDrag);
         this.mcThumb.removeEventListener(PushButtonEvent.CLICK,this.OnEndDrag);
         this.mcThumb.removeEventListener(PushButtonEvent.RELEASE_OUT,this.OnEndDrag);
         this.mbIsDragging = false;
         this.mDraggingThumb = null;
         this.mCurValue = this.mCurSnappedValue;
         dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.DRAG_END,this.mCurValue,this.mCurValue,this.AllValues));
      }
      
      protected function OnPerformDrag(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!param1.buttonDown && !SystemUtils.UsingController)
         {
            this.mcThumb.SetState("up");
            this.ForceDragEnd();
            return;
         }
         var _loc2_:Number = this.mbIsVertical ? mouseY : mouseX;
         if(this.mPreviousMousePos != _loc2_)
         {
            _loc3_ = this.mCurValue;
            _loc4_ = (_loc2_ - this.mPreviousMousePos) / this.mSliderLength * this.mValueRange;
            this.SetCurrentValue(_loc4_,false,false);
            if(this.mCurValue != _loc3_)
            {
               this.mPreviousMousePos = _loc2_;
               dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.DRAG_CONTINUE,this.mCurValue,_loc3_,this.AllValues));
            }
         }
      }
      
      protected function OnTrackPress(param1:PushButtonEvent) : void
      {
      }
      
      protected function OnTrackClick(param1:PushButtonEvent) : void
      {
         if(mouseY > this.mcThumb.y && mouseY < this.mcThumb.y + this.mcThumb.height)
         {
         }
         var _loc2_:Number = this.mCurValue;
         var _loc3_:Number = this.mbIsVertical ? mouseY : mouseX;
         var _loc4_:Number = (_loc3_ - this.mSliderMin) / this.mSliderLength;
         _loc4_ = Clamp.Num(_loc4_,0,1);
         var _loc5_:Number = this.mMinValue + _loc4_ * this.mValueRange;
         _loc5_ = this.SnapValue(_loc5_);
         if(_loc5_ == this.mCurValue)
         {
            return;
         }
         var _loc6_:Number = (_loc5_ - this.mMinValue) / this.mValueRange;
         var _loc7_:Number = Math.round(_loc6_ * this.mSliderLength + this.mSliderMin);
         if(this.mbIsVertical)
         {
            _loc7_ = Clamp.Num(_loc7_,this.mSliderMin,this.mSliderMax);
            this.mThumbTween.Stop();
            this.mThumbTween = new Tween(SLIDER_THUMB_MOTION_DURATION,this.mcThumb,{"y":_loc7_},0,Easing.easeOutQuint);
            this.mThumbTween.Start();
         }
         this.mCurValue = _loc5_;
         dispatchEvent(new SmoothSliderEvent(SmoothSliderEvent.SLIDE,_loc5_,_loc2_,this.AllValues));
      }
      
      protected function SnapValue(param1:Number) : Number
      {
         if(this.mSnapInterval != 0)
         {
            return Math.round(param1 / this.mSnapInterval) * this.mSnapInterval;
         }
         return param1;
      }
      
      protected function AdjustThumbPosition(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:Number = Math.round(param1 * this.mSliderLength + this.mSliderMin);
         var _loc4_:Number = this.mThumbs.length > 1 && this.mbIsVertical ? this.mThumbs[1].y - this.mcThumb.width : this.mSliderMax;
         _loc3_ = Clamp.Num(_loc3_,this.mSliderMin,_loc4_);
         if(this.mbIsVertical)
         {
            if(param2 && this.mcThumb.y != _loc3_ || this.mThumbTween.IsActive())
            {
               this.mThumbTween.Stop();
               this.mThumbTween = new Tween(SLIDER_THUMB_MOTION_DURATION,this.mcThumb,{"y":_loc3_});
               this.mThumbTween.Start();
            }
            else
            {
               this.mcThumb.y = _loc3_;
            }
         }
      }
      
      protected function UpdateSliderDimensions() : void
      {
         this.mSliderLength = this.mcTrack.height - this.mcThumb.height;
         if(this.mSliderLength <= 0)
         {
            return;
         }
         this.mSliderMin = this.mcTrack.y;
         this.mSliderMax = this.mSliderMin + this.mSliderLength;
         if(this.mMaxValue == this.mMinValue)
         {
            return;
         }
         var _loc1_:Number = (this.mCurValue - this.mMinValue) / this.mValueRange;
         this.AdjustThumbPosition(_loc1_);
      }
      
      public function ThumbBelongsToSlider(param1:DisplayObject) : Boolean
      {
         return this.mThumbs.indexOf(param1) != -1;
      }
      
      public function SetControllerHighlight(param1:Boolean) : void
      {
         this.mcTrack.SetState(param1 ? "over" : "out");
      }
      
      public function InitRStickIcon() : void
      {
         var _loc2_:String = null;
         if(!SystemUtils.UsingConsoleInputMode || !this.mbIsVertical)
         {
            return;
         }
         if(this.mcIcon != null)
         {
            return;
         }
         var _loc1_:Class = LibraryUtils.GetLibraryClass(LibraryUtils.GUI_IMAGE);
         this.mcIcon = new _loc1_();
         this.mcIcon.width = SLIDER_CONSOLE_ICON_SIZE;
         this.mcIcon.height = SLIDER_CONSOLE_ICON_SIZE;
         InputModeVisibilityExtension.ShowForController(this.mcIcon);
         InputModeVisibilityExtension.HideForShowControlsOverlayOption(this.mcIcon);
         addChild(this.mcIcon);
         if(SystemUtils.IsPS4)
         {
            _loc2_ = SLIDER_RSTICK_IMAGE_PS4;
         }
         else
         {
            _loc2_ = SLIDER_RSTICK_IMAGE_XB1;
         }
         this.mcIcon.LoadImage(_loc2_);
         this.mcIcon.x = this.mcTrack.x - (SLIDER_CONSOLE_ICON_SIZE - this.mcTrack.width) * 0.5;
         this.mcIcon.y = 0;
         if(this.stage != null)
         {
            this.height = this.height;
         }
      }
      
      public function EnableRStickIcon(param1:Boolean) : void
      {
         if(this.mcIcon == null)
         {
            return;
         }
         var _loc2_:Boolean = this.mcIcon.visible != param1;
         InputModeVisibilityExtension.SetVisible(this.mcIcon,param1);
         if(_loc2_ && this.stage != null)
         {
            this.height = this.height;
         }
      }
   }
}

