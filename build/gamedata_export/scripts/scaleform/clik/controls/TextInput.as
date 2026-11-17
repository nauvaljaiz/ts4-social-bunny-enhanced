package scaleform.clik.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import olympus.extensions.AudioExtension;
   import olympus.input.helpers.VirtualKeyboardHelper;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ComponentEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.clik.utils.Constraints;
   
   public class TextInput extends UIComponent
   {
      
      public var defaultText:String = "";
      
      public var defaultTextFormat:TextFormat;
      
      public var constraintsDisabled:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:uint = 0;
      
      protected var _editable:Boolean = true;
      
      protected var _actAsButton:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _isHtml:Boolean = false;
      
      protected var _state:String = "default";
      
      protected var _newFrame:String;
      
      protected var mTabIndex:int;
      
      protected var mRestrict:String;
      
      private var hscroll:Number = 0;
      
      public var textField:TextField;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mVirtualKeyboardParams:Object = null;
      
      public function TextInput()
      {
         super();
         this.componentName = "TextInput";
         this.mRestrict = Keys.ALWAYS_RESTRICTED;
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mAudioExtension.CategoryName = "TextInput";
         this.mAudioExtension.Hookup(Event.CHANGE);
      }
      
      override protected function preInitialize() : void
      {
         if(!this.constraintsDisabled)
         {
            constraints = new Constraints(this);
         }
      }
      
      override protected function initialize() : void
      {
         tabEnabled = false;
         mouseEnabled = mouseChildren = this.enabled;
         super.initialize();
      }
      
      override public function get focusable() : Boolean
      {
         return _focusable;
      }
      
      override public function set focusable(param1:Boolean) : void
      {
         super.focusable = param1;
         tabEnabled = false;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._isHtml = false;
         this._text = param1;
         invalidateData();
      }
      
      public function get htmlText() : String
      {
         return this._text;
      }
      
      public function set htmlText(param1:String) : void
      {
         this._isHtml = true;
         this._text = param1;
         invalidateData();
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         this._displayAsPassword = param1;
         if(this.textField != null)
         {
            this.textField.displayAsPassword = param1;
         }
      }
      
      public function get maxChars() : uint
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:uint) : void
      {
         this._maxChars = param1;
         if(this.textField != null)
         {
            this.textField.maxChars = param1;
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         if(this.textField != null)
         {
            this.textField.type = this._editable && this.enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         }
      }
      
      public function get actAsButton() : Boolean
      {
         return this._actAsButton;
      }
      
      public function set actAsButton(param1:Boolean) : void
      {
         if(this._actAsButton == param1)
         {
            return;
         }
         this._actAsButton = param1;
         if(param1)
         {
            addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut,false,0,true);
         }
         else
         {
            removeEventListener(MouseEvent.ROLL_OVER,this.handleRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOut);
         }
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         this._alwaysShowSelection = param1;
         if(this.textField != null)
         {
            this.textField.alwaysShowSelection = param1;
         }
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.setState(this.defaultState);
      }
      
      public function get length() : uint
      {
         return this.textField.length;
      }
      
      public function get defaultState() : String
      {
         return !this.enabled ? "disabled" : (focused ? "focused" : "default");
      }
      
      override public function get tabIndex() : int
      {
         return this.mTabIndex;
      }
      
      override public function set tabIndex(param1:int) : void
      {
         this.mTabIndex = param1;
         invalidateState();
      }
      
      public function appendText(param1:String) : void
      {
         this._text += param1;
         this._isHtml = false;
         invalidateData();
      }
      
      public function appendHtml(param1:String) : void
      {
         this._text += param1;
         this._isHtml = true;
         invalidateData();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD)
         {
            return;
         }
      }
      
      override public function toString() : String
      {
         return "[CLIK TextInput " + name + "]";
      }
      
      public function set restrict(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = TextUtils.JoinRestrictStrings(Keys.ALWAYS_RESTRICTED,param1);
         }
         this.mRestrict = _loc2_;
         invalidateState();
      }
      
      public function get restrict() : String
      {
         return this.mRestrict;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(!this.constraintsDisabled)
         {
            constraints.addElement("textField",this.textField,Constraints.ALL);
         }
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.setState(this.defaultState,"default");
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
            this.updateAfterStateChange();
            this.updateTextField();
            dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
            invalidate(InvalidationType.SIZE);
         }
         else if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            setActualSize(_width,_height);
            if(!this.constraintsDisabled)
            {
               constraints.update(_width,_height);
            }
         }
      }
      
      override protected function changeFocus() : void
      {
         this.setState(this.defaultState);
      }
      
      protected function updateTextField() : void
      {
         if(this.textField == null)
         {
            return;
         }
         this.updateText();
         this.textField.maxChars = this._maxChars;
         this.textField.displayAsPassword = this._displayAsPassword;
         this.textField.alwaysShowSelection = this._alwaysShowSelection;
         this.textField.selectable = this.enabled ? this._editable : this.enabled;
         this.textField.type = this._editable && this.enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.textField.tabEnabled = this._editable && this.enabled;
         this.textField.restrict = this.mRestrict;
         this.textField.tabIndex = this.mTabIndex;
         this.textField.addEventListener(Event.CHANGE,this.handleTextChange,false,0,true);
      }
      
      protected function updateText() : void
      {
         if(this._text != "")
         {
            if(this._isHtml)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
         else
         {
            this.textField.text = "";
            if(!_focused && !this._displayAsPassword && this.defaultText != "")
            {
               this.textField.text = this.defaultText;
               if(this.defaultTextFormat != null)
               {
                  this.textField.setTextFormat(this.defaultTextFormat);
               }
            }
         }
      }
      
      protected function setState(... rest) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(rest.length == 1)
         {
            _loc4_ = rest[0].toString();
            if(this._state != _loc4_ && Boolean(_labelHash[_loc4_]))
            {
               this._state = this._newFrame = _loc4_;
               invalidateState();
            }
            return;
         }
         var _loc2_:uint = uint(rest.length);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = rest[_loc3_].toString();
            if(_labelHash[_loc5_])
            {
               this._state = this._newFrame = _loc5_;
               invalidateState();
               break;
            }
            _loc3_++;
         }
      }
      
      protected function updateAfterStateChange() : void
      {
         var _loc1_:Boolean = false;
         if(!initialized)
         {
            return;
         }
         constraints.updateElement("textField",this.textField);
         if(_focused)
         {
            stage.focus = this.textField;
            if(SystemUtils.UsingConsoleInputMode)
            {
               if(SystemUtils.UsingMouseKeyboard && !SystemUtils.UsingController)
               {
                  _loc1_ = Boolean(CommunicationManager.CallGameService("DoesInputLanguageUseIME",null,true));
                  if(_loc1_)
                  {
                     this.OpenVirtualKeyboard();
                  }
               }
               else
               {
                  this.OpenVirtualKeyboard();
               }
            }
         }
      }
      
      protected function handleRollOver(param1:MouseEvent) : void
      {
         if(Boolean(focused) || !this.enabled)
         {
            return;
         }
         this.setState("over");
      }
      
      protected function handleRollOut(param1:MouseEvent) : void
      {
         if(Boolean(focused) || !this.enabled)
         {
            return;
         }
         this.setState("out","default");
      }
      
      protected function handleTextChange(param1:Event) : void
      {
         this._text = this._isHtml ? this.textField.htmlText : this.textField.text;
         param1.stopPropagation();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function SetupVirtualKeyboardParams(param1:Function = null, param2:String = "Default", param3:String = null, param4:String = null) : void
      {
         if(this.mRestrict == Keys.ALLOWED_CHARS_IN_NUMERIC.toString())
         {
            param2 = VirtualKeyboardHelper.KEYBOARD_TYPE_NUMBERS;
         }
         this.mVirtualKeyboardParams = {
            "callback":param1,
            "keyboardType":param2,
            "description":param3,
            "defaultTextOverride":param4
         };
      }
      
      public function SetVirtualKeyboardParamsObject(param1:Object) : void
      {
         this.SetupVirtualKeyboardParams(param1.callback,param1.keyboardType,param1.description,param1.defaultTextOverride);
      }
      
      public function HasVirtualKeyboardParams() : Boolean
      {
         return this.mVirtualKeyboardParams != null;
      }
      
      public function OpenVirtualKeyboard() : void
      {
         if(this.mVirtualKeyboardParams)
         {
            VirtualKeyboardHelper.Open(this.mVirtualKeyboardParams.keyboardType,this.DoVirtualKeyboardCallback,this.mVirtualKeyboardParams.defaultTextOverride != null ? this.mVirtualKeyboardParams.defaultTextOverride : this.text,this.mVirtualKeyboardParams.description != null ? this.mVirtualKeyboardParams.description : this.defaultText,this.maxChars);
         }
      }
      
      protected function DoVirtualKeyboardCallback(param1:int, param2:String) : void
      {
         if(Boolean(this.mVirtualKeyboardParams) && this.mVirtualKeyboardParams.callback is Function)
         {
            this.mVirtualKeyboardParams.callback(this,param1,param2);
         }
         else
         {
            this.DefaultOnVKeyboardOutput(param1,param2);
         }
         focused = 0;
      }
      
      protected function DefaultOnVKeyboardOutput(param1:uint, param2:String) : void
      {
         if(param1 == VirtualKeyboardHelper.STATUS_COMPLETE)
         {
            this._text = param2;
            this.updateText();
         }
      }
   }
}

