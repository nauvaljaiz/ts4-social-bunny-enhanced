package scaleform.clik.core
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.EAUIComponent;
   import olympus.core.cursors.CursorObject;
   import olympus.interfaces.IAnimation;
   import olympus.motion.Tween;
   import olympus.motion.TweenParams;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.events.ComponentEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.utils.Constraints;
   import scaleform.gfx.Extensions;
   
   public class UIComponent extends EAUIComponent implements IAnimation
   {
      
      public var initialized:Boolean = false;
      
      public var enableInitCallback:Boolean = false;
      
      protected var _invalidHash:Object;
      
      protected var _invalid:Boolean = false;
      
      protected var _componentName:String = "UNKNOWN";
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      protected var _originalWidth:Number = 0;
      
      protected var _originalHeight:Number = 0;
      
      protected var _focusTarget:UIComponent;
      
      protected var _focusable:Boolean = true;
      
      protected var _focused:Number = 0;
      
      protected var _displayFocus:Boolean = false;
      
      protected var _mouseWheelEnabled:Boolean = true;
      
      protected var _inspector:Boolean = false;
      
      protected var _labelHash:Object;
      
      protected var _cursorObj:CursorObject;
      
      public var constraints:Constraints;
      
      public var mcHitArea:Sprite;
      
      public function UIComponent()
      {
         this.preInitialize();
         super();
         this._invalidHash = {};
         this.initialize();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
      }
      
      public static function generateLabelHash(param1:MovieClip) : Object
      {
         var _loc2_:Object = {};
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:Array = param1.currentLabels;
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_[_loc3_[_loc5_].name] = true;
            _loc5_++;
         }
         return _loc2_;
      }
      
      protected function preInitialize() : void
      {
      }
      
      protected function initialize() : void
      {
         this._labelHash = UIComponent.generateLabelHash(this);
         this._originalWidth = super.width / super.scaleX;
         this._originalHeight = super.height / super.scaleY;
         if(this._width == 0)
         {
            this._width = super.width;
         }
         if(this._height == 0)
         {
            this._height = super.height;
         }
         if(!CLIK.initialized)
         {
            if(stage != null)
            {
               CLIK.initialize(stage,this);
               if(this.enableInitCallback && Boolean(Extensions["CLIK_addedToStageCallback"]))
               {
                  Extensions["CLIK_addedToStageCallback"](this.name,CLIK.getTargetPathFor(this),this);
               }
            }
            else
            {
               addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
            }
         }
         this.invalidate();
      }
      
      protected function addedToStage(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false);
         CLIK.initialize(stage,this);
         if(this.enableInitCallback && Boolean(Extensions["CLIK_addedToStageCallback"]))
         {
            _loc2_ = this.name as String;
            _loc3_ = CLIK.getTargetPathFor(this);
            Extensions["CLIK_addedToStageCallback"](_loc2_,_loc3_,this);
         }
      }
      
      public function get componentInspectorSetting() : Boolean
      {
         return this._inspector;
      }
      
      public function set componentInspectorSetting(param1:Boolean) : void
      {
         this._inspector = param1;
         if(param1)
         {
            this.beforeInspectorParams();
         }
         else
         {
            this.afterInspectorParams();
         }
      }
      
      public function get componentName() : String
      {
         return this._componentName;
      }
      
      public function set componentName(param1:String) : void
      {
         this._componentName = param1;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this.setSize(param1,this._height);
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this.setSize(this._width,param1);
      }
      
      override public function get scaleX() : Number
      {
         return this._width / this._originalWidth;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this.width = super.width;
      }
      
      override public function get scaleY() : Number
      {
         return this._height / this._originalHeight;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this.height = super.height;
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 == super.enabled)
         {
            return;
         }
         super.enabled = param1;
         tabEnabled = !this.enabled ? false : this._focusable;
         mouseEnabled = mouseChildren = param1;
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         dispatchEvent(new Event(param1 ? ComponentEvent.SHOW : ComponentEvent.HIDE));
      }
      
      public function get hasFocus() : Boolean
      {
         return this._focused > 0;
      }
      
      public function get focusable() : Boolean
      {
         return this._focusable;
      }
      
      public function set focusable(param1:Boolean) : void
      {
         if(this._focusable == param1)
         {
            return;
         }
         if(this._focusable)
         {
            this.focused = 0;
         }
         this._focusable = param1;
         if(!this._focusable && this.enabled)
         {
            tabEnabled = tabChildren = false;
         }
      }
      
      public function get focused() : Number
      {
         return this._focused;
      }
      
      public function set focused(param1:Number) : void
      {
         if(param1 == this._focused || !this._focusable)
         {
            return;
         }
         this._focused = param1;
         if(stage != null && this._focused > 0)
         {
            stage.focus = this;
         }
         this.changeFocus();
      }
      
      public function get displayFocus() : Boolean
      {
         return this._displayFocus;
      }
      
      public function set displayFocus(param1:Boolean) : void
      {
         if(param1 == this._displayFocus)
         {
            return;
         }
         this._displayFocus = param1;
         this.changeFocus();
      }
      
      public function get focusTarget() : UIComponent
      {
         return this._focusTarget;
      }
      
      public function set focusTarget(param1:UIComponent) : void
      {
         this._focusTarget = param1;
      }
      
      final public function get actualWidth() : Number
      {
         return super.width;
      }
      
      final public function get actualHeight() : Number
      {
         return super.height;
      }
      
      final public function get actualScaleX() : Number
      {
         return super.scaleX;
      }
      
      final public function get actualScaleY() : Number
      {
         return super.scaleY;
      }
      
      public function get cursor() : String
      {
         if(this._cursorObj == null)
         {
            return null;
         }
         return this._cursorObj.CursorName;
      }
      
      public function set cursor(param1:String) : void
      {
         if(this._cursorObj == null)
         {
            this._cursorObj = new CursorObject(this,param1);
         }
         else
         {
            this._cursorObj.CursorName = param1;
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         param1 = Math.max(param1,1);
         param2 = Math.max(param2,1);
         if(this._width != param1 || this._height != param2)
         {
            this._width = param1;
            this._height = param2;
            this.invalidateSize();
         }
      }
      
      public function setActualSize(param1:Number, param2:Number) : void
      {
         if(super.width != param1 || this._width != param1)
         {
            super.width = this._width = param1;
         }
         if(super.height != param2 || this._height != param2)
         {
            super.height = this._height = param2;
         }
      }
      
      final public function setActualScale(param1:Number, param2:Number) : void
      {
         super.scaleX = param1;
         super.scaleY = param2;
         this._width = this._originalWidth * param1;
         this._height = this._originalHeight * param2;
         this.invalidateSize();
      }
      
      public function handleInput(param1:InputEvent) : void
      {
      }
      
      public function dispatchEventToGame(param1:Event) : void
      {
         ExternalInterface.call("__handleEvent",name,param1);
      }
      
      override public function toString() : String
      {
         return "[CLIK UIComponent " + name + "]";
      }
      
      protected function configUI() : void
      {
         if(this.mcHitArea)
         {
            hitArea = this.mcHitArea;
            hitArea.mouseEnabled = false;
         }
      }
      
      protected function draw() : void
      {
      }
      
      protected function changeFocus() : void
      {
      }
      
      protected function beforeInspectorParams() : void
      {
      }
      
      protected function afterInspectorParams() : void
      {
      }
      
      protected function initSize() : void
      {
         var _loc1_:Number = this._width == 0 ? this.actualWidth : this._width;
         var _loc2_:Number = this._height == 0 ? this.actualHeight : this._height;
         super.scaleX = super.scaleY = 1;
         this.setSize(_loc1_,_loc2_);
      }
      
      public function invalidate(... rest) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(rest.length == 0)
         {
            this._invalidHash[InvalidationType.ALL] = true;
         }
         else
         {
            _loc2_ = uint(rest.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._invalidHash[rest[_loc3_]] = true;
               _loc3_++;
            }
         }
         if(!this._invalid)
         {
            this._invalid = true;
            if(stage == null)
            {
               addEventListener(Event.ADDED_TO_STAGE,this.handleStageChange,false,0,true);
            }
            else
            {
               addEventListener(Event.ENTER_FRAME,this.handleEnterFrameValidation,false,0,true);
               addEventListener(Event.RENDER,this.validateNow,false,0,true);
               stage.invalidate();
            }
         }
         else if(stage != null)
         {
            stage.invalidate();
         }
      }
      
      public function validateNow(param1:Event = null) : void
      {
         if(!this.initialized)
         {
            this.initialized = true;
            this.configUI();
         }
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrameValidation);
         removeEventListener(Event.RENDER,this.validateNow);
         if(!this._invalid)
         {
            return;
         }
         this.draw();
         this._invalidHash = {};
         this._invalid = false;
      }
      
      protected function isInvalid(... rest) : Boolean
      {
         if(!this._invalid)
         {
            return false;
         }
         var _loc2_:uint = uint(rest.length);
         if(_loc2_ == 0)
         {
            return this._invalid;
         }
         if(this._invalidHash[InvalidationType.ALL])
         {
            return true;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._invalidHash[rest[_loc3_]])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function invalidateSize() : void
      {
         this.invalidate(InvalidationType.SIZE);
      }
      
      public function invalidateData() : void
      {
         this.invalidate(InvalidationType.DATA);
      }
      
      public function invalidateState() : void
      {
         this.invalidate(InvalidationType.STATE);
      }
      
      protected function handleStageChange(param1:Event) : void
      {
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.handleStageChange);
            addEventListener(Event.RENDER,this.validateNow,false,0,true);
            if(stage != null)
            {
               stage.invalidate();
            }
         }
      }
      
      protected function handleEnterFrameValidation(param1:Event) : void
      {
         this.validateNow();
      }
      
      protected function getInvalid() : String
      {
         var _loc4_:String = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [InvalidationType.ALL,InvalidationType.DATA,InvalidationType.RENDERERS,InvalidationType.SIZE,InvalidationType.STATE];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_.push("* " + _loc2_[_loc3_] + ": " + (this._invalidHash[_loc2_[_loc3_]] == true));
            _loc3_++;
         }
         for(_loc4_ in this._invalidHash)
         {
            if(!_loc2_.indexOf(_loc4_))
            {
               _loc1_.push("* " + _loc4_ + ": true");
            }
         }
         return "Invalid " + this + ": \n" + _loc1_.join("\n");
      }
      
      public function GetRect() : Rectangle
      {
         return this.getRect(parent);
      }
      
      public function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(param1,param2,this,this.GetRect(),param3);
         return param2.totalDuration;
      }
      
      public function AnimateOut(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(param1,param2,this,this.GetRect(),param3);
         return param2.totalDuration;
      }
   }
}

