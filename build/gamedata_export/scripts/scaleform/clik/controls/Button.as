package scaleform.clik.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import olympus.core.cursors.Cursors;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.HighlightExtension;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import scaleform.clik.constants.ConstrainMode;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.ComponentEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.clik.utils.ConstrainedElement;
   import scaleform.clik.utils.Constraints;
   import scaleform.gfx.MouseEventEx;
   
   public class Button extends UIComponent
   {
      
      public var lockDragStateChange:Boolean = false;
      
      public var repeatDelay:Number = 500;
      
      public var repeatInterval:Number = 200;
      
      public var constraintsDisabled:Boolean = false;
      
      public var allowDeselect:Boolean = true;
      
      public var preventAutosizing:Boolean = false;
      
      public var preventClickPropagation:Boolean = false;
      
      protected var _toggle:Boolean = false;
      
      protected var _label:String;
      
      protected var _state:String;
      
      protected var _group:ButtonGroup;
      
      protected var _groupName:String;
      
      protected var _selected:Boolean = false;
      
      protected var _data:Object;
      
      protected var _autoRepeat:Boolean = false;
      
      protected var _autoSize:String = "none";
      
      protected var _pressedByKeyboard:Boolean = false;
      
      protected var _cursorDown:String;
      
      protected var _selectedField:String = "selected";
      
      protected var _stateMap:Object = {
         "up":["up"],
         "over":["over"],
         "down":["down"],
         "release":["release","over"],
         "out":["out","up"],
         "disabled":["disabled"],
         "disabledOver":["disabledOver","disabled"],
         "selecting":["selecting","over"],
         "toggle":["toggle","up"],
         "kb_selecting":["kb_selecting","up"],
         "kb_release":["kb_release","out","up"],
         "kb_down":["kb_down","down"]
      };
      
      protected var _newFrame:String;
      
      protected var _newFocusIndicatorFrame:String;
      
      protected var _repeatTimer:Timer;
      
      protected var _mouseDown:int = 0;
      
      protected var _focusIndicatorLabelHash:Object;
      
      protected var _autoRepeatEvent:ButtonEvent;
      
      public var textField:TextField;
      
      public var defaultTextFormat:TextFormat;
      
      public var mcTextField:MovieClip;
      
      protected var _focusIndicator:MovieClip;
      
      protected var bRightMouseButtonEnabled:Boolean = false;
      
      protected var mAllowedButtonMask:uint = InputUtils.LEFT_BUTTON;
      
      protected var mMinimumFontShrinkHeight:Number = 0;
      
      protected var mbShowTooltipIfLabelEllipsized:Boolean = false;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mHighlightExtension:HighlightExtension;
      
      protected var statesDefault:Vector.<String> = Vector.<String>([""]);
      
      protected var controllerStatesDefault:Vector.<String> = Vector.<String>(["controller_",""]);
      
      protected var statesSelected:Vector.<String> = Vector.<String>(["selected_",""]);
      
      protected var controllerStatesSelected:Vector.<String> = Vector.<String>(["controller_selected_","selected_","controller_",""]);
      
      public function Button()
      {
         super();
         this.componentName = "Button";
         cursor = Cursors.BUTTON_OVER;
         this.cursorDown = Cursors.BUTTON_DOWN;
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mHighlightExtension = GetExtension(HighlightExtension) as HighlightExtension;
         this.mAudioExtension.CategoryName = "Button";
         this.mAudioExtension.Hookup(ButtonEvent.PRESS);
         this.mAudioExtension.Hookup(ButtonEvent.CLICK);
         this.mAudioExtension.Hookup(ButtonEvent.RELEASE_OUTSIDE);
      }
      
      override protected function preInitialize() : void
      {
         if(!this.constraintsDisabled)
         {
            constraints = new Constraints(this,ConstrainMode.COUNTER_SCALE);
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
      }
      
      public function get AudioExt() : AudioExtension
      {
         return this.mAudioExtension;
      }
      
      public function get selectedField() : String
      {
         return this._selectedField;
      }
      
      public function set selectedField(param1:String) : void
      {
         this._selectedField = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         invalidateData();
         if(Boolean(this._data) && this._data.hasOwnProperty(this._selectedField))
         {
            this.selected = this._data[this._selectedField] as Boolean;
         }
      }
      
      public function get autoRepeat() : Boolean
      {
         return this._autoRepeat;
      }
      
      public function set autoRepeat(param1:Boolean) : void
      {
         this._autoRepeat = param1;
         if(!this._autoRepeat)
         {
            this.stopAutoRepeat();
         }
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(super.enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         mouseEnabled = true;
         var _loc3_:Boolean = this._focusIndicator == null && (_displayFocus || Boolean(_focused) || Boolean(stage) && hitTestPoint(stage.mouseX,stage.mouseY,true));
         if(super.enabled)
         {
            _loc2_ = _loc3_ ? "over" : "up";
         }
         else
         {
            _loc2_ = _loc3_ ? "disabledOver" : "disabled";
         }
         this.setState(_loc2_);
      }
      
      override public function get focusable() : Boolean
      {
         return _focusable;
      }
      
      override public function set focusable(param1:Boolean) : void
      {
         super.focusable = param1;
      }
      
      public function get toggle() : Boolean
      {
         return this._toggle;
      }
      
      public function set toggle(param1:Boolean) : void
      {
         this._toggle = param1;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         var _loc2_:Boolean = Boolean(stage) && hitTestPoint(stage.mouseX,stage.mouseY,true);
         if(this.enabled)
         {
            if(_loc2_)
            {
               this.setState("over");
            }
            else if(!_focused)
            {
               this.setState("toggle");
            }
            else if(this._pressedByKeyboard && this._focusIndicator != null)
            {
               this.setState("kb_selecting");
            }
            else
            {
               this.setState("selecting");
            }
         }
         else
         {
            this.setState(_loc2_ ? "disabledOver" : "disabled");
         }
         validateNow();
         var _loc3_:Event = new Event(Event.SELECT);
         dispatchEvent(_loc3_);
      }
      
      public function get group() : ButtonGroup
      {
         return this._group;
      }
      
      public function set group(param1:ButtonGroup) : void
      {
         if(this._group != null)
         {
            this._group.removeButton(this);
         }
         this._group = param1;
         if(this._group != null)
         {
            this._group.addButton(this);
         }
      }
      
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function set groupName(param1:String) : void
      {
         if(_inspector && param1 == "")
         {
            return;
         }
         if(this._groupName == param1)
         {
            return;
         }
         if(param1 != null)
         {
            addEventListener(Event.ADDED,this.addToAutoGroup,false,0,true);
            addEventListener(Event.REMOVED,this.addToAutoGroup,false,0,true);
         }
         else
         {
            removeEventListener(Event.ADDED,this.addToAutoGroup);
            removeEventListener(Event.REMOVED,this.addToAutoGroup);
         }
         this._groupName = param1;
         this.addToAutoGroup(null);
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(this._label == param1)
         {
            return;
         }
         this._label = param1;
         invalidateData();
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function set autoSize(param1:String) : void
      {
         if(param1 == this._autoSize)
         {
            return;
         }
         this._autoSize = param1;
         invalidateData();
      }
      
      public function get cursorDown() : String
      {
         return this._cursorDown;
      }
      
      public function set cursorDown(param1:String) : void
      {
         this._cursorDown = param1;
      }
      
      public function get focusIndicator() : MovieClip
      {
         return this._focusIndicator;
      }
      
      public function set focusIndicator(param1:MovieClip) : void
      {
         this._focusIndicatorLabelHash = null;
         this._focusIndicator = param1;
         this._focusIndicatorLabelHash = UIComponent.generateLabelHash(this._focusIndicator);
      }
      
      public function get rightMouseButtonEnabled() : Boolean
      {
         return (this.mAllowedButtonMask & InputUtils.RIGHT_BUTTON) != 0;
      }
      
      public function set rightMouseButtonEnabled(param1:Boolean) : void
      {
         this.mAllowedButtonMask = param1 ? uint(this.mAllowedButtonMask | InputUtils.RIGHT_BUTTON) : uint(this.mAllowedButtonMask ^ InputUtils.RIGHT_BUTTON);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:uint = _loc2_.controllerIndex;
         switch(_loc2_.navEquivalent)
         {
            case NavigationCode.ENTER:
               if(_loc2_.value == InputValue.KEY_DOWN)
               {
                  this.handlePress(_loc3_);
                  param1.handled = true;
               }
               else if(_loc2_.value == InputValue.KEY_UP)
               {
                  if(this._pressedByKeyboard)
                  {
                     this.handleRelease(_loc3_);
                     param1.handled = true;
                  }
               }
         }
      }
      
      public function stopAutoRepeat() : void
      {
         var _loc1_:Timer = this._repeatTimer;
         if(_loc1_)
         {
            _loc1_.stop();
            _loc1_.reset();
            _loc1_.removeEventListener(TimerEvent.TIMER_COMPLETE,this.beginRepeat);
            _loc1_.removeEventListener(TimerEvent.TIMER,this.handleRepeat);
            this._repeatTimer = null;
         }
      }
      
      override public function toString() : String
      {
         return "[CLIK Button " + name + "]";
      }
      
      override protected function configUI() : void
      {
         if(!this.constraintsDisabled)
         {
            constraints.addElement("textField",this.getTextField(),Constraints.ALL);
         }
         super.configUI();
         if(!this._state)
         {
            this.setState("up");
         }
         this.focusable = false;
         tabEnabled = _focusable;
         mouseChildren = tabChildren = false;
         addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMousePress,false,0,true);
         addEventListener(MouseEvent.CLICK,this.handleMouseRelease,false,0,true);
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         if(this._focusIndicator != null && !_focused && this._focusIndicator.totalFrames == 1)
         {
            this.focusIndicator.visible = false;
         }
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STATE))
         {
            if(this._newFrame)
            {
               gotoAndPlay(this._newFrame);
               this._newFrame = null;
            }
            if(this._newFocusIndicatorFrame)
            {
               this.focusIndicator.gotoAndPlay(this._newFocusIndicatorFrame);
               this._newFocusIndicatorFrame = null;
            }
            this.updateAfterStateChange();
            dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
            invalidate(InvalidationType.DATA,InvalidationType.SIZE);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
            if(this.autoSize != TextFieldAutoSize.NONE)
            {
               invalidateSize();
            }
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            if(!this.preventAutosizing)
            {
               this.alignForAutoSize();
               setActualSize(_width,_height);
            }
            if(!this.constraintsDisabled)
            {
               constraints.update(_width,_height);
            }
         }
      }
      
      protected function addToAutoGroup(param1:Event) : void
      {
         if(parent == null)
         {
            this.group = null;
            return;
         }
         var _loc2_:ButtonGroup = ButtonGroup.getGroup(this._groupName,parent);
         if(_loc2_ == this.group)
         {
            return;
         }
         this.group = _loc2_;
      }
      
      protected function calculateWidth() : Number
      {
         var _loc2_:ConstrainedElement = null;
         var _loc1_:Number = actualWidth;
         if(!this.constraintsDisabled)
         {
            _loc2_ = constraints.getElement("textField");
            _loc1_ = Math.ceil(this.getTextField().textWidth + _loc2_.left + _loc2_.right + 5);
         }
         return _loc1_;
      }
      
      protected function alignForAutoSize() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!initialized || this._autoSize == TextFieldAutoSize.NONE || this.getTextField() == null)
         {
            return;
         }
         _loc1_ = _width;
         var _loc2_:Number = _width = this.calculateWidth();
         switch(this._autoSize)
         {
            case TextFieldAutoSize.RIGHT:
               _loc3_ = x + _loc1_;
               x = _loc3_ - _loc2_;
               break;
            case TextFieldAutoSize.CENTER:
               _loc4_ = x + _loc1_ * 0.5;
               x = _loc4_ - _loc2_ * 0.5;
         }
      }
      
      public function get showTooltipIfLabelEllipsized() : Boolean
      {
         return this.mbShowTooltipIfLabelEllipsized;
      }
      
      public function set showTooltipIfLabelEllipsized(param1:Boolean) : void
      {
         this.mbShowTooltipIfLabelEllipsized = param1;
      }
      
      public function get minimumFontShrinkHeight() : Number
      {
         return this.mMinimumFontShrinkHeight;
      }
      
      public function set minimumFontShrinkHeight(param1:Number) : void
      {
         this.mMinimumFontShrinkHeight = param1;
      }
      
      public function get fontSize() : Number
      {
         var _loc1_:TextField = this.getTextField();
         if(_loc1_)
         {
            return Number(_loc1_.getTextFormat().size);
         }
         return 0;
      }
      
      public function set fontSize(param1:Number) : void
      {
         var _loc3_:TextFormat = null;
         var _loc2_:TextField = this.getTextField();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getTextFormat();
            _loc3_.size = param1;
            _loc2_.setTextFormat(_loc3_);
            invalidateData();
         }
      }
      
      protected function updateText() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:TextField = this.getTextField();
         if(this._label != null && _loc1_ != null)
         {
            if(this.mMinimumFontShrinkHeight > 0)
            {
               _loc2_ = !TextUtils.ResizeTextToFit(_loc1_,this._label,_loc1_.width,_loc1_.height,this.mMinimumFontShrinkHeight);
               if(this.showTooltipIfLabelEllipsized)
               {
                  if(_loc2_)
                  {
                     tooltipText = this._label;
                  }
                  else
                  {
                     tooltipText = null;
                  }
               }
            }
            else
            {
               _loc1_.htmlText = this._label;
            }
         }
      }
      
      override protected function changeFocus() : void
      {
         var _loc1_:String = null;
         if(!this.enabled)
         {
            return;
         }
         if(this._focusIndicator == null)
         {
            this.setState(Boolean(_focused) || _displayFocus ? "over" : "out");
            if(this._pressedByKeyboard && !_focused)
            {
               this._pressedByKeyboard = false;
            }
         }
         else
         {
            if(this._focusIndicator.totalframes == 1)
            {
               this._focusIndicator.visible = _focused > 0;
            }
            else
            {
               _loc1_ = "state" + _focused;
               if(this._focusIndicatorLabelHash[_loc1_])
               {
                  this._newFocusIndicatorFrame = "state" + _focused;
               }
               else
               {
                  this._newFocusIndicatorFrame = _focused ? "show" : "hide";
               }
               invalidateState();
            }
            if(this._pressedByKeyboard && !_focused)
            {
               this.setState("kb_release");
               this._pressedByKeyboard = false;
            }
         }
      }
      
      protected function stopAutoRepeatIfNeeded() : void
      {
         if(Boolean(this._repeatTimer) && Boolean(this._mouseDown == 0) && !this._pressedByKeyboard)
         {
            this.stopAutoRepeat();
         }
      }
      
      protected function handleMouseRollOver(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         var _loc3_:uint = _loc2_ == null ? 0 : _loc2_.mouseIdx;
         if(param1.buttonDown)
         {
            dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_OVER));
            if(this.lockDragStateChange && Boolean(this._mouseDown << _loc3_ & 1))
            {
               return;
            }
         }
         if(!this.enabled)
         {
            if(_tooltipObj)
            {
               SendTooltipEvent(param1);
            }
            this.setState("disabledOver");
            return;
         }
         if(Boolean(_focused) || _displayFocus)
         {
            if(this._focusIndicator != null)
            {
               this.setState("over");
            }
         }
         else
         {
            this.setState("over");
         }
         SendTooltipEvent(param1);
      }
      
      protected function handleMouseRollOut(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         var _loc3_:uint = _loc2_ == null ? 0 : _loc2_.mouseIdx;
         if(param1.buttonDown)
         {
            dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_OUT));
            if(Boolean(this._mouseDown & 1 << _loc3_))
            {
               if(stage != null)
               {
                  stage.addEventListener(MouseEvent.MOUSE_UP,this.handleReleaseOutside,false,0,true);
               }
               if(this.lockDragStateChange)
               {
                  return;
               }
            }
         }
         if(!this.enabled)
         {
            if(_tooltipObj)
            {
               SendTooltipEvent(param1);
            }
            this.setState("disabled");
            return;
         }
         var _loc4_:String = this._state == "down" ? "release" : "out";
         if(_displayFocus || Boolean(_focused))
         {
            if(this._focusIndicator != null)
            {
               this.setState(_loc4_);
            }
         }
         else
         {
            this.setState(_loc4_);
         }
         SendTooltipEvent(param1);
      }
      
      protected function handleMousePress(param1:MouseEvent) : void
      {
         if(!InputUtils.IsButtonAllowed(param1,this.mAllowedButtonMask))
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         var _loc3_:uint = _loc2_ == null ? 0 : _loc2_.mouseIdx;
         if(this.preventClickPropagation)
         {
            param1.stopImmediatePropagation();
         }
         this._mouseDown |= 1 << _loc3_;
         if(this.enabled)
         {
            this.setState("down");
            if(this.autoRepeat && this._repeatTimer == null)
            {
               this._autoRepeatEvent = new ButtonEvent(ButtonEvent.CLICK,true,false,_loc3_,_loc2_.buttonIdx,false,true);
               this._repeatTimer = new Timer(this.repeatDelay,1);
               this._repeatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.beginRepeat,false,0,true);
               this._repeatTimer.start();
            }
            dispatchEvent(new ButtonEvent(ButtonEvent.PRESS,false,false,_loc3_,_loc2_.buttonIdx));
            Cursors.LockCursor(this,this.cursorDown);
         }
      }
      
      protected function handleMouseRelease(param1:MouseEvent) : void
      {
         if(!InputUtils.IsButtonAllowed(param1,this.mAllowedButtonMask))
         {
            return;
         }
         this._autoRepeatEvent = null;
         if(this.preventClickPropagation)
         {
            param1.stopImmediatePropagation();
         }
         if(!this.enabled)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         var _loc3_:uint = _loc2_ == null ? 0 : _loc2_.mouseIdx;
         this._mouseDown ^= 1 << _loc3_;
         if(_displayFocus || Boolean(_focused))
         {
            this.setState(this._focusIndicator == null ? "over" : "release");
         }
         else
         {
            this.setState("release");
         }
         Cursors.UnlockCursor(this);
         this.handleClick(_loc3_);
         dispatchEvent(new ButtonEvent(ButtonEvent.CLICK,true,false,_loc3_,_loc2_.buttonIdx));
      }
      
      protected function handleReleaseOutside(param1:MouseEvent) : void
      {
         this._autoRepeatEvent = null;
         if(contains(param1.target as DisplayObject))
         {
            return;
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleReleaseOutside);
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         var _loc3_:uint = _loc2_ == null ? 0 : _loc2_.mouseIdx;
         this._mouseDown ^= 1 << _loc3_;
         dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE));
         if(!this.enabled)
         {
            return;
         }
         if(_displayFocus || Boolean(_focused))
         {
            this.setState(this._focusIndicator == null ? "over" : "up");
         }
         else
         {
            this.setState("up");
         }
         Cursors.UnlockCursor(this);
      }
      
      protected function handlePress(param1:uint = 0) : void
      {
         if(!this.enabled)
         {
            return;
         }
         this._pressedByKeyboard = true;
         this.setState(this._focusIndicator == null ? "down" : "kb_down");
         if(this.autoRepeat && this._repeatTimer == null)
         {
            this._autoRepeatEvent = new ButtonEvent(ButtonEvent.CLICK,true,false,param1,0,true);
            this._repeatTimer = new Timer(this.repeatDelay,1);
            this._repeatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.beginRepeat,false,0,true);
            this._repeatTimer.start();
         }
         dispatchEvent(new ButtonEvent(ButtonEvent.PRESS,true,false,param1,0,true));
      }
      
      protected function handleRelease(param1:uint = 0) : void
      {
         if(!this.enabled)
         {
            return;
         }
         if(!(_displayFocus || _focused))
         {
            this.setState(this._focusIndicator == null ? "release" : "kb_release");
         }
         else
         {
            this.setState("over");
         }
         this._pressedByKeyboard = false;
         this.handleClick(param1);
         dispatchEvent(new ButtonEvent(ButtonEvent.CLICK,true,false,param1,0,true));
      }
      
      protected function handleClick(param1:uint = 0) : void
      {
         if(this.toggle && (!this.selected || this.allowDeselect))
         {
            this.selected = !this.selected;
         }
         this.stopAutoRepeatIfNeeded();
         if(_tooltipObj)
         {
            _tooltipObj.HideTooltip();
         }
      }
      
      protected function beginRepeat(param1:TimerEvent) : void
      {
         this._repeatTimer.delay = this.repeatInterval;
         this._repeatTimer.repeatCount = 0;
         this._repeatTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.beginRepeat);
         this._repeatTimer.addEventListener(TimerEvent.TIMER,this.handleRepeat,false,0,true);
         this._repeatTimer.reset();
         this._repeatTimer.start();
      }
      
      protected function handleRepeat(param1:TimerEvent) : void
      {
         this.stopAutoRepeatIfNeeded();
         if(this._autoRepeatEvent)
         {
            dispatchEvent(this._autoRepeatEvent);
         }
      }
      
      protected function setState(param1:String) : void
      {
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         this._state = param1;
         var _loc2_:Vector.<String> = this.getStatePrefixes();
         var _loc3_:Array = this._stateMap[param1];
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return;
         }
         var _loc4_:uint = _loc2_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = _loc3_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc6_ + _loc3_[_loc8_];
               if(_labelHash[_loc9_])
               {
                  this._newFrame = _loc9_;
                  invalidateState();
                  return;
               }
               _loc8_++;
            }
            _loc5_++;
         }
      }
      
      protected function getStatePrefixes() : Vector.<String>
      {
         var _loc1_:Vector.<String> = null;
         if(SystemUtils.UsingController)
         {
            _loc1_ = this._selected ? this.controllerStatesSelected : this.controllerStatesDefault;
         }
         else
         {
            _loc1_ = this._selected ? this.statesSelected : this.statesDefault;
         }
         return _loc1_;
      }
      
      protected function updateAfterStateChange() : void
      {
         if(!initialized)
         {
            return;
         }
         var _loc1_:TextField = this.getTextField();
         if(constraints != null && !this.constraintsDisabled && _loc1_ != null)
         {
            constraints.updateElement("textField",_loc1_);
         }
      }
      
      protected function getTextField() : TextField
      {
         if(this.textField)
         {
            return this.textField;
         }
         if(this.mcTextField)
         {
            return this.mcTextField["textField"];
         }
         return null;
      }
   }
}

