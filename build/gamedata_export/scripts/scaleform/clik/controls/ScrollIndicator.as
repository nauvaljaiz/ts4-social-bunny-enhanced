package scaleform.clik.controls
{
   import flash.events.Event;
   import flash.text.TextField;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.constants.ScrollBarDirection;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IScrollBar;
   import scaleform.clik.ui.InputDetails;
   
   public class ScrollIndicator extends UIComponent implements IScrollBar
   {
      
      public static const SCROLL_THUMB_MIN_HEIGHT:Number = 20;
      
      public var direction:String = "vertical";
      
      public var offsetTop:Number = 0;
      
      public var offsetBottom:Number = 0;
      
      protected var _isDragging:Boolean = false;
      
      protected var _minPosition:Number = 0;
      
      protected var _maxPosition:Number = 10;
      
      protected var _pageSize:Number;
      
      protected var _pageScrollSize:Number = 1;
      
      protected var _position:Number = 5;
      
      protected var _scrollTarget:Object;
      
      public var mcThumb:Button;
      
      public var mcTrack:Button;
      
      public function ScrollIndicator()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this.mcThumb == null)
         {
            this.mcThumb = getChildByName("thumb") as Button;
         }
         if(this.mcTrack == null)
         {
            this.mcTrack = getChildByName("track") as Button;
         }
         this.componentName = "ScrollIndicator";
         this.mcThumb.componentName = "ScrollIndicatorButton";
         this.mcTrack.componentName = "ScrollIndicatorButton";
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
         gotoAndPlay(this.enabled ? "default" : "disabled");
      }
      
      public function get position() : Number
      {
         return this._position;
      }
      
      public function set position(param1:Number) : void
      {
         param1 = Math.max(this._minPosition,Math.min(this._maxPosition,param1));
         if(param1 == this._position)
         {
            return;
         }
         this._position = param1;
         dispatchEvent(new Event(Event.SCROLL));
         invalidateData();
      }
      
      public function scrollUp() : void
      {
         this.position -= this._pageScrollSize;
      }
      
      public function scrollDown() : void
      {
         this.position += this._pageScrollSize;
      }
      
      public function get isHorizontal() : Boolean
      {
         return this.direction == ScrollBarDirection.HORIZONTAL;
      }
      
      public function get scrollTarget() : Object
      {
         return this._scrollTarget;
      }
      
      public function set scrollTarget(param1:Object) : void
      {
         if(param1 is String)
         {
            if(!componentInspectorSetting || param1.toString() == "" || parent == null)
            {
               return;
            }
            param1 = parent.getChildByName(param1.toString());
            if(param1 == null)
            {
               return;
            }
         }
         var _loc2_:Object = this._scrollTarget;
         this._scrollTarget = param1;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.SCROLL,this.handleTargetScroll);
            if(_loc2_.scrollBar != null)
            {
               _loc2_.scrollBar = null;
            }
         }
         if(param1 is UIComponent && "scrollBar" in param1 && param1.scrollBar !== null)
         {
            param1.scrollBar = this;
            return;
         }
         if(this._scrollTarget == null)
         {
            tabEnabled = true;
            return;
         }
         this._scrollTarget.addEventListener(Event.SCROLL,this.handleTargetScroll,false,0,true);
         tabEnabled = false;
         this.handleTargetScroll(null);
      }
      
      public function get availableHeight() : Number
      {
         return (this.isHorizontal ? _width : _height) - this.mcThumb.height + this.offsetBottom + this.offsetTop;
      }
      
      public function setScrollProperties(param1:Number, param2:Number, param3:Number, param4:Number = NaN) : void
      {
         this._pageSize = param1;
         if(!isNaN(param4))
         {
            this._pageScrollSize = param4;
         }
         this._minPosition = param2;
         this._maxPosition = param3;
         invalidateSize();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value == InputValue.KEY_UP)
         {
            return;
         }
         var _loc3_:Boolean = this.direction == ScrollBarDirection.HORIZONTAL;
         switch(_loc2_.navEquivalent)
         {
            case NavigationCode.UP:
               if(_loc3_)
               {
                  return;
               }
               --this.position;
               break;
            case NavigationCode.DOWN:
               if(_loc3_)
               {
                  return;
               }
               this.position += 1;
               break;
            case NavigationCode.LEFT:
               if(!_loc3_)
               {
                  return;
               }
               --this.position;
               break;
            case NavigationCode.RIGHT:
               if(!_loc3_)
               {
                  return;
               }
               this.position += 1;
               break;
            case NavigationCode.HOME:
               this.position = 0;
               break;
            case NavigationCode.END:
               this.position = this._maxPosition;
               break;
            default:
               return;
         }
         param1.handled = true;
      }
      
      override public function toString() : String
      {
         return "[CLIK ScrollIndicator " + name + "]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
         mouseChildren = mouseEnabled = false;
         if(this.mcTrack == null)
         {
            this.mcTrack = new Button();
         }
         this.mcThumb.enabled = this.enabled;
         initSize();
         this.direction = rotation != 0 && rotation != 180 ? ScrollBarDirection.HORIZONTAL : ScrollBarDirection.VERTICAL;
      }
      
      override protected function draw() : void
      {
         var _loc1_:TextField = null;
         if(isInvalid(InvalidationType.SIZE))
         {
            this.drawLayout();
            this.updateThumb();
         }
         else if(isInvalid(InvalidationType.DATA))
         {
            if(this._scrollTarget is TextField)
            {
               _loc1_ = this._scrollTarget as TextField;
               this.setScrollProperties(_loc1_.bottomScrollV - _loc1_.scrollV,1,_loc1_.maxScrollV);
            }
            this.updateThumbPosition();
         }
      }
      
      protected function drawLayout() : void
      {
         this.mcTrack.height = this.isHorizontal ? _width : _height;
      }
      
      protected function updateThumb() : void
      {
         if(!this.enabled)
         {
            return;
         }
         var _loc1_:Number = Math.max(1,this._maxPosition - this._minPosition + this._pageSize);
         var _loc2_:Number = (this.isHorizontal ? _width : _height) + this.offsetTop + this.offsetBottom;
         this.mcThumb.height = Math.max(SCROLL_THUMB_MIN_HEIGHT,Math.min(_height,this._pageSize / _loc1_ * _loc2_));
         if(this.mcThumb is UIComponent)
         {
            (this.mcThumb as UIComponent).validateNow();
            (this.mcThumb as UIComponent).setActualSize(this.mcThumb.width,this.mcThumb.height);
         }
         this.updateThumbPosition();
      }
      
      protected function updateThumbPosition() : void
      {
         var _loc1_:Number = (this._position - this._minPosition) / (this._maxPosition - this._minPosition);
         var _loc2_:Number = _loc1_ * this.availableHeight;
         this.mcThumb.y = Math.max(-this.offsetTop,Math.min(this.availableHeight - this.offsetTop,_loc2_));
         this.mcThumb.visible = !(isNaN(this._pageSize) || this._maxPosition == 0);
      }
      
      protected function handleTargetScroll(param1:Event) : void
      {
         if(this._isDragging)
         {
            return;
         }
         var _loc2_:TextField = this._scrollTarget as TextField;
         if(_loc2_ != null)
         {
            this.setScrollProperties(_loc2_.bottomScrollV - _loc2_.scrollV,1,_loc2_.maxScrollV);
            this.position = _loc2_.scrollV;
         }
      }
   }
}

