package olympus.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IMEEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import olympus.constants.Alignment;
   import olympus.constants.KeyCodes;
   import olympus.core.cursors.Cursors;
   import olympus.core.widget.Margin;
   import olympus.events.GenericEvent;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.CursorExtension;
   import olympus.extensions.TooltipExtension;
   import olympus.gui.buttons.CancelButton;
   import olympus.gui.buttons.CloseButton;
   import olympus.gui.buttons.DeleteButton;
   import olympus.input.helpers.VirtualKeyboardHelper;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import scaleform.clik.managers.FocusHandler;
   
   public class EditTextField extends GUIComponent
   {
      
      public static const EVENT_TEXT_VALIDITY_CHANGED:String = "event_text_validity_changed";
      
      public static const EVENT_TEXT_EDITMODE_CHANGED:String = "event_text_editmode_change";
      
      protected static const STATIC_BORDER_COLOR:uint = 14079702;
      
      protected static const TEXTFIELD_EXTRA_WIDTH:Number = 5;
      
      protected static const TEXTFIELD_EXTRA_HEIGHT:uint = 5;
      
      protected static const ERROR_ICON_MARGIN:Margin = new Margin(10,-19,7,7);
      
      protected static const ERROR_BG_MARGIN:Margin = new Margin(2,1,2,2);
      
      protected static const ARROW_KEY_CODES:Vector.<uint> = new <uint>[KeyCodes.LEFT_ARROW,KeyCodes.RIGHT_ARROW,KeyCodes.UP_ARROW,KeyCodes.DOWN_ARROW];
      
      protected static const MODE_EDIT_DEFAULT_HIDE:int = 0;
      
      protected static const MODE_EDIT_DEFAULT_SHOW:int = 1;
      
      protected static const MODE_STATIC_DEFAULT_SHOW:int = 2;
      
      protected static const MODE_STATIC_DEFAULT_HIDE:int = 3;
      
      public var txtStatic:TextField;
      
      public var txtInput:TextField;
      
      public var txtDefault:TextField;
      
      public var mcError:GUIComponent;
      
      public var mcControllerHighlight:MovieClip;
      
      public var mErrorTooltip:TooltipExtension;
      
      protected var mText:String = "";
      
      protected var mStaticText:String = "";
      
      protected var mBgClip:DisplayObject;
      
      protected var mbEditMode:Boolean;
      
      protected var mbInputTextMouseDown:Boolean = false;
      
      protected var mMinWidth:Number = 40;
      
      protected var mMaxChars:uint = 20;
      
      protected var mMinChars:uint = 2;
      
      protected var mMinCharsErrorText:String;
      
      protected var mDefaultText:String;
      
      protected var mValidateInputFunc:Function;
      
      protected var mbShowBorder:Boolean = true;
      
      protected var mbShowBackground:Boolean = true;
      
      protected var mbSubmitOnFocusOut:Boolean = true;
      
      protected var mbSubmitChangeWhenNotDirty:Boolean = false;
      
      protected var mbDispatchOnTextChangeValidityChangedEvent:Boolean = false;
      
      protected var mbDispatchEditModeChangeEvent:Boolean = false;
      
      protected var mbResizeTextField:Boolean = true;
      
      protected var mbAllowMinWidthResize:Boolean = false;
      
      protected var mbValidateOnFocusOut:Boolean = false;
      
      protected var mbForceEditWhenInvalid:Boolean = false;
      
      protected var mErrorAudio:AudioExtension;
      
      protected var mTabTarget:EditTextField;
      
      protected var mEllipsize:Boolean = false;
      
      protected var mbShiftEnterNewline:Boolean = false;
      
      protected var mStaticTextColor:uint;
      
      protected var mDefaultTextColor:uint;
      
      protected var mEditColor:uint;
      
      protected var mStaticTextStyleSheet:StyleSheet = new StyleSheet();
      
      protected var mErrorIconMargin:Margin = ERROR_ICON_MARGIN;
      
      protected var mErrorBgMargin:Margin = ERROR_BG_MARGIN;
      
      protected var mInputTextFormat:TextFormat;
      
      protected var mbLastIsValidTextState:Boolean;
      
      protected var mCurrentSubMode:int;
      
      protected var mVirtualKeyboardParams:Object = null;
      
      protected var mEnterKeyIsSubmit:Boolean = true;
      
      public function EditTextField()
      {
         super();
         this.mStaticTextColor = this.txtStatic.textColor;
         this.mEditColor = this.txtInput.textColor;
         this.mDefaultTextColor = this.txtDefault.textColor;
         this.mbShowBackground = !SystemUtils.UsingController;
         this.SetupControllerHighlight();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.txtInput.mouseEnabled = this.txtDefault.mouseEnabled = false;
         var _loc1_:TextField = this.txtInput;
         _loc1_.visible = false;
         _loc1_.backgroundColor = this.txtDefault.backgroundColor = 16777215;
         _loc1_.borderColor = this.mEditColor;
         _loc1_.background = this.mbShowBorder && this.mbShowBackground;
         _loc1_.border = this.txtStatic.border = this.mbShowBorder;
         _loc1_.maxChars = this.mMaxChars;
         _loc1_.tabEnabled = false;
         this.txtStatic.borderColor = STATIC_BORDER_COLOR;
         this.UpdateStaticTextStyleSheet();
         this.SetText(this.mText,this.mStaticText);
         this.ResizeAndReposition(_loc1_);
         this.ResizeAndReposition(this.txtStatic);
         _loc1_ = this.txtDefault;
         _loc1_.background = this.mbShowBorder && this.mbShowBackground;
         _loc1_.border = this.mbShowBorder;
         _loc1_.borderColor = this.mDefaultTextColor;
         _loc1_.visible = false;
         _loc1_.tabEnabled = false;
         var _loc2_:int = MODE_STATIC_DEFAULT_HIDE;
         if(this.mDefaultText)
         {
            this.ResizeAndReposition(_loc1_);
            if(!this.mText)
            {
               _loc2_ = MODE_STATIC_DEFAULT_SHOW;
            }
         }
         this.SubMode = _loc2_;
         this.Cursor = Cursors.PENCIL_ICON;
         this.mErrorTooltip = this.mcError.GetExtension(TooltipExtension) as TooltipExtension;
         this.mErrorTooltip.VerticalAlignment = Alignment.CENTER;
         this.mErrorTooltip.HorizontalAlignment = Alignment.RIGHT;
         this.mcError.visible = false;
         this.mErrorAudio = this.mcError.GetExtension(AudioExtension) as AudioExtension;
         this.mErrorAudio.CategoryName = "Nag";
         var _loc3_:AudioExtension = GetExtension(AudioExtension) as AudioExtension;
         _loc3_.CategoryName = "EditTextField";
         _loc3_.Hookup(Event.CHANGE);
         if(enabled)
         {
            addEventListener(MouseEvent.CLICK,this.StartEdit,false,0,true);
         }
         this.txtStatic.addEventListener(Event.CHANGE,this.OnStaticTextChange,false,0,true);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 == super.enabled)
         {
            return;
         }
         super.enabled = param1;
         this.IsEditMode = false;
         this.txtStatic.border = param1 && this.mbShowBorder;
         if(param1)
         {
            this.Cursor = Cursors.PENCIL_ICON;
            addEventListener(MouseEvent.CLICK,this.StartEdit,false,0,true);
         }
         else
         {
            this.Cursor = Cursors.ARROW;
            removeEventListener(MouseEvent.CLICK,this.StartEdit);
         }
      }
      
      public function get textHeight() : Number
      {
         return this.txtInput.textHeight;
      }
      
      public function set htmlText(param1:String) : void
      {
         if(this.mText != param1)
         {
            this.SetText(param1,param1);
         }
      }
      
      public function get htmlText() : String
      {
         return this.mText;
      }
      
      public function get CurrentText() : String
      {
         return this.txtInput.text;
      }
      
      public function SetText(param1:String, param2:String, param3:Boolean = true) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         if(param3)
         {
            param1 = TextUtils.EscapeHtml(param1);
            param2 = TextUtils.EscapeHtml(param2);
         }
         this.txtInput.htmlText = this.mText = param1;
         this.mStaticText = param2;
         if(this.mInputTextFormat)
         {
            this.txtInput.setTextFormat(this.mInputTextFormat);
         }
         this.txtStatic.styleSheet = this.mStaticTextStyleSheet;
         if(this.mEllipsize)
         {
            TextUtils.SetAndEllipsizeText(this.txtStatic,param2);
            param2 = this.txtStatic.text;
         }
         this.txtStatic.htmlText = "<span class=\'default\'>" + param2 + "</span>";
         if(mbInitialized)
         {
            this.ResizeAndReposition(this.txtInput);
            this.ResizeAndReposition(this.txtStatic);
            this.SubMode = !param1 && Boolean(this.mDefaultText) ? MODE_STATIC_DEFAULT_SHOW : MODE_STATIC_DEFAULT_HIDE;
         }
      }
      
      public function set DefaultText(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.txtDefault.text = this.mDefaultText = param1;
         if(mbInitialized)
         {
            this.ResizeAndReposition(this.txtDefault);
            this.SubMode = !this.mText && Boolean(param1) ? MODE_STATIC_DEFAULT_SHOW : MODE_STATIC_DEFAULT_HIDE;
         }
      }
      
      public function set BgClip(param1:DisplayObject) : void
      {
         this.mBgClip = param1;
         if(param1)
         {
            this.x = param1.x;
         }
         if(Boolean(this.mDefaultText) && mbInitialized)
         {
            this.ResizeAndReposition(this.txtDefault);
         }
      }
      
      public function set TabTarget(param1:EditTextField) : void
      {
         this.mTabTarget = param1;
      }
      
      public function set Ellipsize(param1:Boolean) : void
      {
         if(this.mEllipsize != param1)
         {
            this.mEllipsize = param1;
            this.SetText(this.mText,this.mStaticText);
         }
      }
      
      public function set MaxChars(param1:uint) : void
      {
         this.mMaxChars = param1;
         this.txtInput.maxChars = param1;
      }
      
      public function get MaxChars() : uint
      {
         return this.mMaxChars;
      }
      
      public function set MinChars(param1:uint) : void
      {
         this.mMinChars = param1;
      }
      
      public function set MinWidth(param1:Number) : void
      {
         this.mMinWidth = param1;
         if(mbInitialized && Boolean(this.mText))
         {
            this.ResizeAndReposition(this.txtInput);
            this.ResizeAndReposition(this.txtStatic);
            this.SubMode = MODE_STATIC_DEFAULT_HIDE;
         }
      }
      
      public function set MinCharsErrorText(param1:String) : void
      {
         this.mMinCharsErrorText = param1;
      }
      
      public function set EnterKeyIsSubmit(param1:Boolean) : void
      {
         this.mEnterKeyIsSubmit = param1;
      }
      
      public function set ShiftEnterNewline(param1:Boolean) : void
      {
         this.mbShiftEnterNewline = param1;
      }
      
      public function set StaticTextBackgroundColor(param1:uint) : void
      {
         this.txtStatic.backgroundColor = param1;
      }
      
      public function set TextColor(param1:uint) : void
      {
         this.mStaticTextColor = param1;
         this.UpdateStaticTextStyleSheet();
      }
      
      public function set DefaultTextColor(param1:uint) : void
      {
         this.mDefaultTextColor = param1;
         this.txtDefault.textColor = this.mDefaultTextColor;
         this.txtDefault.borderColor = this.mDefaultTextColor;
      }
      
      public function set EditTextColor(param1:uint) : void
      {
         this.mEditColor = param1;
      }
      
      public function set ShowBorder(param1:Boolean) : void
      {
         this.mbShowBorder = param1;
         this.txtInput.border = this.txtStatic.border = this.txtDefault.border = param1;
         this.txtInput.background = this.txtStatic.background = this.txtDefault.background = param1 && this.mbShowBackground;
      }
      
      public function set ShowBackground(param1:Boolean) : void
      {
         this.mbShowBackground = param1;
         this.txtInput.background = this.txtDefault.background = this.mbShowBorder && this.mbShowBackground;
         this.SubMode = this.mCurrentSubMode;
      }
      
      public function set SubmitOnFocusOut(param1:Boolean) : void
      {
         this.mbSubmitOnFocusOut = param1;
      }
      
      public function set SubmitChangeWhenNotDirty(param1:Boolean) : void
      {
         this.mbSubmitChangeWhenNotDirty = param1;
      }
      
      public function set DispatchOnTextChangeValidityEvents(param1:Boolean) : void
      {
         this.mbDispatchOnTextChangeValidityChangedEvent = param1;
      }
      
      public function set DispatchEditModeChangeEvent(param1:Boolean) : void
      {
         this.mbDispatchEditModeChangeEvent = param1;
      }
      
      public function set ResizeTextField(param1:Boolean) : void
      {
         this.mbResizeTextField = param1;
      }
      
      public function set AllowMinWidthResize(param1:Boolean) : void
      {
         this.mbAllowMinWidthResize = param1;
      }
      
      public function set ValidateOnFocusOut(param1:Boolean) : void
      {
         this.mbValidateOnFocusOut = param1;
      }
      
      public function set Restrict(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = TextUtils.JoinRestrictStrings(Keys.ALWAYS_RESTRICTED,param1);
         }
         this.txtInput.restrict = _loc2_;
      }
      
      public function SetRestricted(param1:String) : void
      {
         this.txtInput.restrict = param1;
      }
      
      public function set TextSelectable(param1:Boolean) : void
      {
         this.txtStatic.selectable = param1;
      }
      
      public function set FontSize(param1:Number) : void
      {
         var _loc5_:TextField = null;
         var _loc6_:TextFormat = null;
         var _loc2_:Number = param1 + TEXTFIELD_EXTRA_HEIGHT;
         var _loc3_:Object = this.mStaticTextStyleSheet.getStyle(".default") || new Object();
         _loc3_.fontSize = param1;
         this.mStaticTextStyleSheet.setStyle(".default",_loc3_);
         this.txtStatic.styleSheet = this.mStaticTextStyleSheet;
         this.txtStatic.height = _loc2_;
         this.ResizeAndReposition(this.txtStatic);
         var _loc4_:Array = [this.txtDefault,this.txtInput];
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = _loc5_.getTextFormat();
            _loc6_.size = param1;
            _loc5_.setTextFormat(_loc6_);
            _loc5_.defaultTextFormat = _loc6_;
            _loc5_.height = _loc2_;
            this.ResizeAndReposition(_loc5_);
         }
         this.mInputTextFormat = _loc6_;
      }
      
      protected function IsValidText(param1:String) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.length < this.mMinChars)
         {
            return false;
         }
         return Boolean(this.mValidateInputFunc) ? this.mValidateInputFunc(param1) == null : true;
      }
      
      public function get IsValid() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = true;
         if(this.txtInput.length < this.mMinChars)
         {
            _loc1_ = this.mMinCharsErrorText;
            _loc2_ = false;
         }
         else if(this.mValidateInputFunc != null)
         {
            _loc1_ = this.mValidateInputFunc(this.txtInput.text);
            _loc2_ = _loc1_ == null;
         }
         if(_loc2_)
         {
            this.SetErrorVisible(false);
         }
         else
         {
            this.SetErrorVisible(true,_loc1_);
            if(this.mbForceEditWhenInvalid)
            {
               this.StartEdit();
            }
            else
            {
               this.IsEditMode = false;
            }
         }
         return _loc2_;
      }
      
      public function get IsEditModeActive() : Boolean
      {
         return this.mbEditMode;
      }
      
      public function set ErrorIconMargin(param1:Margin) : void
      {
         this.mErrorIconMargin = param1;
      }
      
      public function set ErrorBgMargin(param1:Margin) : void
      {
         this.mErrorBgMargin = param1;
      }
      
      public function set ValidateInputFunction(param1:Function) : void
      {
         this.mValidateInputFunc = param1;
      }
      
      public function SetStaticTextStyle(param1:String) : void
      {
         this.mStaticTextStyleSheet.parseCSS(param1);
      }
      
      public function StartEdit(param1:MouseEvent = null, param2:Boolean = true) : void
      {
         var _loc3_:Boolean = false;
         if(!this.mbEditMode)
         {
            this.IsEditMode = true;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseFocusChange,false,0,true);
         }
         this.FocusIn();
         if(SystemUtils.UsingConsoleInputMode && param2)
         {
            if(SystemUtils.UsingMouseKeyboard && !SystemUtils.UsingController)
            {
               _loc3_ = Boolean(CommunicationManager.CallGameService("DoesInputLanguageUseIME",null));
               if(_loc3_)
               {
                  this.OpenVirtualKeyboard();
               }
               else
               {
                  CommunicationManager.AddMessageListener("UsingControllerToggled",this.HandleUsingControllerToggledWhileEditing,this);
               }
            }
            else
            {
               this.OpenVirtualKeyboard();
            }
         }
      }
      
      public function CancelEdit() : void
      {
         this.SetText(this.mText,this.mStaticText);
         this.SetErrorVisible(false);
         this.IsEditMode = false;
         if(SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.RemoveMessageListener("UsingControllerToggled",this.HandleUsingControllerToggledWhileEditing,this);
         }
      }
      
      protected function set IsEditMode(param1:Boolean) : void
      {
         var _loc2_:TextField = null;
         if(this.mbEditMode == param1)
         {
            return;
         }
         if(param1)
         {
            _loc2_ = this.txtInput;
            if(this.mbDispatchOnTextChangeValidityChangedEvent)
            {
               this.mbLastIsValidTextState = this.IsValidText(_loc2_.text);
            }
            if(this.mDefaultText)
            {
               this.OnTextChangeDefault();
               _loc2_.addEventListener(Event.CHANGE,this.OnTextChangeDefault,false,0,true);
               _loc2_.addEventListener(IMEEvent.IME_COMPOSITION,this.OnTextChangeDefault,false,0,true);
            }
            else
            {
               this.OnTextChange();
               _loc2_.addEventListener(Event.CHANGE,this.OnTextChange,false,0,true);
            }
            this.SubMode = Boolean(this.mDefaultText) && !_loc2_.text ? MODE_EDIT_DEFAULT_SHOW : MODE_EDIT_DEFAULT_HIDE;
            this.Cursor = Cursors.IBEAM;
            this.mbInputTextMouseDown = false;
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.OnInputTextMouseDown,false,0,true);
            removeEventListener(MouseEvent.CLICK,this.StartEdit);
            _loc2_.addEventListener(KeyboardEvent.KEY_DOWN,this.OnEditKeyDown,false,0,true);
         }
         else
         {
            this.RemoveEventListeners();
            addEventListener(MouseEvent.CLICK,this.StartEdit,false,0,true);
            this.Cursor = Cursors.PENCIL_ICON;
            FocusHandler.getInstance().setFocus(null);
            this.SubMode = Boolean(this.txtInput.text) || !this.mDefaultText ? MODE_STATIC_DEFAULT_HIDE : MODE_STATIC_DEFAULT_SHOW;
         }
         this.txtInput.mouseEnabled = param1;
         this.mbEditMode = param1;
         if(this.mbDispatchEditModeChangeEvent)
         {
            dispatchEvent(new GenericEvent(EVENT_TEXT_EDITMODE_CHANGED));
         }
      }
      
      protected function set SubMode(param1:int) : void
      {
         var _loc2_:TextField = this.txtInput;
         switch(param1)
         {
            case MODE_STATIC_DEFAULT_SHOW:
               this.txtDefault.visible = _loc2_.visible = true;
               _loc2_.border = _loc2_.background = false;
               _loc2_.x = this.txtDefault.x;
               _loc2_.width = this.txtDefault.width;
               this.txtStatic.visible = false;
               this.txtDefault.background = this.mbShowBorder && this.mbShowBackground;
               this.txtDefault.visible = true;
               _loc2_.dispatchEvent(new Event(Event.RESIZE));
               break;
            case MODE_STATIC_DEFAULT_HIDE:
               this.txtDefault.background = this.txtDefault.visible = false;
               this.txtStatic.visible = true;
               this.txtStatic.scrollH = 0;
               this.txtStatic.x = this.txtInput.x;
               this.txtStatic.width = this.txtInput.width;
               this.txtInput.visible = false;
               break;
            case MODE_EDIT_DEFAULT_HIDE:
               this.txtInput.visible = true;
               this.txtInput.border = this.mbShowBorder;
               this.txtInput.textColor = this.mEditColor;
               this.txtStatic.visible = false;
               break;
            case MODE_EDIT_DEFAULT_SHOW:
               this.txtInput.visible = true;
               this.txtStatic.visible = false;
         }
         this.mCurrentSubMode = param1;
      }
      
      public function SetErrorVisible(param1:Boolean, param2:String = null) : void
      {
         if(!mbInitialized)
         {
            return;
         }
         if(!param1)
         {
            this.mErrorTooltip.Clear();
            this.mcError.visible = false;
         }
         else
         {
            if(this.mbResizeTextField || this.mbAllowMinWidthResize)
            {
               this.ResizeErrorIconAndBG();
            }
            this.mcError.visible = true;
            if(param2)
            {
               this.mErrorTooltip.Text = param2;
               this.mErrorTooltip.Show();
            }
            this.mErrorAudio.DispatchShow();
         }
      }
      
      public function ResizeErrorIconAndBG() : void
      {
         var _loc1_:TextField = this.txtInput;
         var _loc2_:Margin = this.mErrorBgMargin;
         var _loc3_:DisplayObject = this.mcError.getChildByName("mcBg");
         _loc3_.x = _loc1_.x - _loc2_.mLeft;
         _loc3_.y = _loc1_.y - _loc2_.mTop;
         if(this.mbResizeTextField)
         {
            _loc3_.width = _loc1_.width + _loc2_.Horizontal;
         }
         else
         {
            _loc3_.width = Math.max(this.mMinWidth + _loc2_.Horizontal,_loc3_.width);
         }
         _loc3_.height = _loc1_.height + _loc2_.Vertical;
         var _loc4_:DisplayObject = this.mcError.getChildByName("mcIcon");
         _loc4_.x = _loc3_.x + _loc3_.width - _loc4_.width - this.mErrorIconMargin.mRight;
         _loc4_.y = _loc3_.y + this.mErrorIconMargin.mTop;
      }
      
      protected function ResizeAndReposition(param1:TextField) : void
      {
         if(!this.mbResizeTextField && !this.mbAllowMinWidthResize)
         {
            return;
         }
         var _loc2_:Number = this.mbResizeTextField ? Math.max(this.mMinWidth,param1.textWidth + TEXTFIELD_EXTRA_WIDTH) : Math.max(param1.width,this.mMinWidth);
         param1.width = _loc2_;
         if(this.mBgClip)
         {
            param1.x = 0.5 * (this.mBgClip.width - _loc2_);
         }
         param1.dispatchEvent(new Event(Event.RESIZE));
      }
      
      protected function SubmitEdit(param1:Boolean = true) : void
      {
         var _loc2_:String = TextUtils.EscapeHtml(this.txtInput.text);
         if(this.mText != _loc2_ || this.mbSubmitChangeWhenNotDirty)
         {
            this.SetText(_loc2_,_loc2_,false);
            if(param1)
            {
               dispatchEvent(new GenericEvent(GenericEvent.CHANGE));
            }
         }
         this.IsEditMode = false;
         if(SystemUtils.UsingConsoleInputMode && SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.RemoveMessageListener("UsingControllerToggled",this.HandleUsingControllerToggledWhileEditing,this);
         }
      }
      
      public function ValidateSubmitEdit() : Boolean
      {
         if(this.mbValidateOnFocusOut && !this.IsValid)
         {
            return false;
         }
         this.SubmitEdit();
         return true;
      }
      
      public function SetTextFromVKeyboard(param1:String) : void
      {
         this.txtInput.text = param1;
         this.ValidateSubmitEdit();
      }
      
      protected function OnMouseFocusChange(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = param1 && param1.target;
         if(Boolean(param1) && (_loc2_ is CloseButton || _loc2_ is CancelButton || _loc2_ is DeleteButton))
         {
            this.CancelEdit();
            return;
         }
         var _loc3_:TextField = this.txtInput;
         if(_loc2_ == _loc3_ || this.mbInputTextMouseDown)
         {
            this.mbInputTextMouseDown = false;
            return;
         }
         if(!InputUtils.IsLeftMouseButton(param1))
         {
            stage.focus = null;
         }
         if(this.mbValidateOnFocusOut && !this.IsValid)
         {
            return;
         }
         this.SubmitEdit(this.mbSubmitOnFocusOut);
      }
      
      protected function OnTextChangeDefault(param1:Event = null) : void
      {
         if(Boolean(param1) && this.mcError.visible)
         {
            this.SetErrorVisible(false);
         }
         var _loc2_:String = Boolean(param1) && param1 is TextEvent ? (param1 as TextEvent).text : this.txtInput.text;
         if(!_loc2_)
         {
            this.txtDefault.visible = true;
            this.txtInput.textColor = this.mDefaultTextColor;
            this.txtInput.background = this.txtInput.border = false;
            this.txtInput.x = this.txtDefault.x;
            this.txtInput.width = this.txtDefault.width;
            this.txtInput.dispatchEvent(new Event(Event.RESIZE));
         }
         else
         {
            if(_loc2_.length > 0 && this.txtDefault.visible)
            {
               this.txtDefault.visible = false;
               this.txtInput.background = this.mbShowBorder && this.mbShowBackground;
               this.txtInput.border = this.mbShowBorder;
               this.txtInput.textColor = this.mEditColor;
            }
            if(this.mbResizeTextField || this.mbAllowMinWidthResize)
            {
               if(this.mbResizeTextField)
               {
                  this.txtInput.scrollH = 0;
               }
               this.ResizeAndReposition(this.txtInput);
            }
         }
         if(this.mbDispatchOnTextChangeValidityChangedEvent)
         {
            this.CheckTextValidityChanged();
         }
      }
      
      protected function OnTextChange(param1:Event = null) : void
      {
         if(Boolean(param1) && this.mcError.visible)
         {
            this.SetErrorVisible(false);
         }
         if(this.mbResizeTextField || this.mbAllowMinWidthResize)
         {
            if(this.mbResizeTextField)
            {
               this.txtInput.scrollH = 0;
            }
            this.ResizeAndReposition(this.txtInput);
         }
         if(this.mbDispatchOnTextChangeValidityChangedEvent)
         {
            this.CheckTextValidityChanged();
         }
      }
      
      protected function OnStaticTextChange(param1:Event) : void
      {
         param1.stopImmediatePropagation();
      }
      
      protected function OnEditKeyDown(param1:KeyboardEvent) : void
      {
         if(ARROW_KEY_CODES.indexOf(param1.keyCode) != -1)
         {
            if(param1.shiftKey)
            {
               this.SelectText(param1.keyCode);
            }
            param1.stopPropagation();
         }
         else if(this.mEnterKeyIsSubmit && param1.keyCode == KeyCodes.ENTER && (!this.mbShiftEnterNewline || this.mbShiftEnterNewline && !param1.shiftKey))
         {
            if(!this.ValidateSubmitEdit())
            {
               return;
            }
         }
         else if(param1.keyCode == KeyCodes.TAB)
         {
            if(!this.ValidateSubmitEdit())
            {
               return;
            }
            if(this.mTabTarget)
            {
               this.mTabTarget.enabled = false;
               this.mTabTarget.enabled = true;
               this.mTabTarget.StartEdit();
            }
         }
         else if(param1.keyCode == KeyCodes.ESC)
         {
            this.CancelEdit();
         }
      }
      
      protected function SelectText(param1:int) : void
      {
         var tf:TextField = null;
         var selectionBeginIndex:int = 0;
         var selectionEndIndex:int = 0;
         var keyCode:int = param1;
         tf = this.txtInput;
         selectionBeginIndex = tf.selectionBeginIndex;
         selectionEndIndex = tf.selectionEndIndex;
         var caretIndex:int = tf.caretIndex;
         setTimeout(function():void
         {
            switch(keyCode)
            {
               case ARROW_KEY_CODES[0]:
                  tf.setSelection(selectionBeginIndex - 1,selectionEndIndex);
                  break;
               case ARROW_KEY_CODES[1]:
                  tf.setSelection(selectionBeginIndex,selectionEndIndex + 1);
                  break;
               case ARROW_KEY_CODES[2]:
                  tf.setSelection(0,selectionEndIndex);
                  break;
               case ARROW_KEY_CODES[3]:
                  tf.setSelection(selectionBeginIndex,txtStatic.length);
            }
         },1);
      }
      
      protected function OnInputTextMouseDown(param1:MouseEvent) : void
      {
         this.mbInputTextMouseDown = true;
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         super.OnRemovedFromStage(param1);
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseFocusChange);
         }
         this.mValidateInputFunc = null;
      }
      
      protected function UpdateStaticTextStyleSheet() : void
      {
         var _loc1_:uint = uint(0xFFFFFF & this.mStaticTextColor);
         var _loc2_:String = _loc1_.toString(16);
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc3_:Object = this.mStaticTextStyleSheet.getStyle(".default") || new Object();
         _loc3_.color = "#" + _loc2_;
         this.mStaticTextStyleSheet.setStyle(".default",_loc3_);
      }
      
      protected function set Cursor(param1:String) : void
      {
         (GetExtension(CursorExtension) as CursorExtension).ConfigureCursors(param1,param1);
      }
      
      public function set ForceEditWhenInvalid(param1:Boolean) : void
      {
         this.mbForceEditWhenInvalid = param1;
      }
      
      protected function RemoveEventListeners() : void
      {
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseFocusChange);
         }
         var _loc1_:TextField = this.txtInput;
         _loc1_.removeEventListener(Event.CHANGE,this.OnTextChangeDefault);
         _loc1_.removeEventListener(IMEEvent.IME_COMPOSITION,this.OnTextChangeDefault);
         _loc1_.removeEventListener(Event.CHANGE,this.OnTextChange);
         _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.OnInputTextMouseDown);
         _loc1_.removeEventListener(KeyboardEvent.KEY_DOWN,this.OnEditKeyDown);
      }
      
      protected function FocusIn() : void
      {
         stage.focus = this.txtInput;
         var _loc1_:uint = this.txtDefault.visible ? 0 : uint(this.txtInput.length);
         this.txtInput.setSelection(_loc1_,_loc1_);
         this.txtInput.scrollH = 0;
      }
      
      protected function CheckTextValidityChanged() : void
      {
         if(this.IsValidText(this.txtInput.text) != this.mbLastIsValidTextState)
         {
            this.mbLastIsValidTextState = !this.mbLastIsValidTextState;
            dispatchEvent(new GenericEvent(EVENT_TEXT_VALIDITY_CHANGED,false,false,this.mbLastIsValidTextState));
         }
      }
      
      protected function SetupControllerHighlight() : void
      {
         if(!this.mcControllerHighlight)
         {
            return;
         }
         this.txtInput.addEventListener(Event.RESIZE,this.HandleTxtInputResize,false,0,true);
         this.HandleTxtInputResize();
         this.mcControllerHighlight.visible = SystemUtils.UsingController;
      }
      
      protected function HandleTxtInputResize(param1:Event = null) : void
      {
         if(this.mcControllerHighlight)
         {
            this.mcControllerHighlight.x = this.txtInput.x;
            this.mcControllerHighlight.y = this.txtInput.y;
            this.mcControllerHighlight.width = this.txtInput.width;
            this.mcControllerHighlight.height = this.txtInput.height;
         }
      }
      
      protected function HandleUsingControllerToggledWhileEditing() : void
      {
         this.ValidateSubmitEdit();
         CommunicationManager.RemoveMessageListener("UsingControllerToggled",this.HandleUsingControllerToggledWhileEditing,this);
      }
      
      public function SetupVirtualKeyboardParams(param1:Function = null, param2:String = "Default", param3:String = null, param4:* = null) : void
      {
         this.mVirtualKeyboardParams = {
            "callback":param1,
            "keyboardType":param2,
            "description":param3,
            "defaultTextOverride":param4
         };
      }
      
      public function SetVirtualKeyboardParamsObject(param1:Object) : void
      {
         this.mVirtualKeyboardParams = param1;
      }
      
      public function HasVirtualKeyboardParams() : Boolean
      {
         return this.mVirtualKeyboardParams != null;
      }
      
      public function OpenVirtualKeyboard() : void
      {
         if(this.mVirtualKeyboardParams)
         {
            VirtualKeyboardHelper.Open(this.mVirtualKeyboardParams.keyboardType,this.DoVirtualKeyboardCallback,this.mVirtualKeyboardParams.defaultTextOverride != null ? this.mVirtualKeyboardParams.defaultTextOverride : this.CurrentText,this.mVirtualKeyboardParams.description != null ? this.mVirtualKeyboardParams.description : this.txtDefault.text,this.MaxChars);
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
         if(this.mbEditMode)
         {
            this.IsEditMode = false;
         }
      }
      
      protected function DefaultOnVKeyboardOutput(param1:uint, param2:String) : void
      {
         if(param1 == VirtualKeyboardHelper.STATUS_COMPLETE)
         {
            this.SetTextFromVKeyboard(param2);
         }
      }
   }
}

