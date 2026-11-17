package scaleform.clik.controls
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import olympus.events.ListItemEvent;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IDataProvider;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class CoreList extends UIComponent
   {
      
      protected var _itemRenderer:Class;
      
      protected var _selectedIndex:int = -1;
      
      protected var _newSelectedIndex:int = -1;
      
      protected var _dataProvider:IDataProvider;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var renderers:Vector.<IListItemRenderer>;
      
      protected var usingExternalRenderers:Boolean = false;
      
      protected var totalRenderers:uint = 0;
      
      protected var state:String = "default";
      
      protected var _newFrame:String;
      
      protected var _contextData:Object;
      
      protected var _selections:Array;
      
      protected var container:Sprite;
      
      public function CoreList()
      {
         super();
         this.componentName = "CoreList";
      }
      
      override protected function initialize() : void
      {
         this.dataProvider = new DataProvider();
         super.initialize();
      }
      
      override public function get focusable() : Boolean
      {
         return _focusable;
      }
      
      override public function set focusable(param1:Boolean) : void
      {
         super.focusable = param1;
      }
      
      public function set itemRendererName(param1:String) : void
      {
         if(_inspector && param1 == "CLIKListItemRenderer" || param1 == "")
         {
            return;
         }
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         if(_loc2_ != null)
         {
            this.itemRenderer = _loc2_;
         }
      }
      
      public function get itemRenderer() : Class
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(param1:Class) : void
      {
         if(this._itemRenderer != param1)
         {
            this._itemRenderer = param1;
            this.invalidateRenderers();
         }
      }
      
      public function get contextData() : Object
      {
         return this._contextData;
      }
      
      public function set contextData(param1:Object) : void
      {
         if(this._contextData != param1)
         {
            this._contextData = param1;
            invalidateData();
         }
      }
      
      public function set itemRendererInstanceName(param1:String) : void
      {
         var _loc4_:IListItemRenderer = null;
         if(param1 == null || param1 == "" || parent == null)
         {
            return;
         }
         var _loc2_:uint = 0;
         var _loc3_:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
         while(++_loc2_)
         {
            _loc4_ = parent.getChildByName(param1 + _loc2_) as IListItemRenderer;
            if(_loc4_ == null)
            {
               if(_loc2_ != 0)
               {
                  break;
               }
            }
            else
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length == 0)
         {
            if(componentInspectorSetting)
            {
               return;
            }
            _loc3_ = null;
         }
         this.itemRendererList = _loc3_;
      }
      
      public function set itemRendererList(param1:Vector.<IListItemRenderer>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.usingExternalRenderers)
         {
            _loc2_ = this.renderers.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.cleanUpRenderer(this.getRendererAt(_loc3_));
               _loc3_++;
            }
         }
         this.usingExternalRenderers = param1 != null;
         this.renderers = param1;
         if(this.usingExternalRenderers)
         {
            _loc2_ = this.renderers.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.setupRenderer(this.getRendererAt(_loc3_));
               _loc3_++;
            }
            this.totalRenderers = this.renderers.length;
         }
         this.invalidateRenderers();
      }
      
      public function get selectedIndex() : int
      {
         var _loc1_:int = 0;
         if(!this.multiselectable)
         {
            return this._selectedIndex;
         }
         for each(_loc1_ in this._selections)
         {
            if(_loc1_ != -1)
            {
               return _loc1_;
            }
         }
         return -1;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(!this.multiselectable)
         {
            if(this._selectedIndex == param1)
            {
               return;
            }
            this._selectedIndex = param1;
            this.invalidateSelectedIndex();
            dispatchEvent(new ListEvent(ListEvent.INDEX_CHANGE,true,false,this._selectedIndex,-1,-1,this.getRendererAt(this._selectedIndex),0,false));
         }
         else
         {
            this._selections = [param1];
         }
         this.invalidateSelectedIndex();
      }
      
      public function get selections() : Array
      {
         return this._selections;
      }
      
      public function set selections(param1:Array) : void
      {
         if(this._selections != param1)
         {
            this._selections = param1;
            this.invalidateSelectedIndex();
         }
      }
      
      public function get multiselectable() : Boolean
      {
         return this._selections != null;
      }
      
      public function set multiselectable(param1:Boolean) : void
      {
         this._selections = param1 ? new Array() : null;
      }
      
      public function isSelected(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(!this.multiselectable)
         {
            return param1 == this.selectedIndex;
         }
         for each(_loc2_ in this._selections)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addSelection(param1:int, param2:int) : void
      {
         this._selections[param1] = param2;
      }
      
      public function removeSelection(param1:int) : void
      {
         this._selections[param1] = -1;
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:IListItemRenderer = null;
         super.enabled = param1;
         this.setState(super.enabled ? "default" : "disabled");
         if(this.renderers != null)
         {
            _loc2_ = this.renderers.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.getRendererAt(_loc3_);
               _loc4_.enabled = this.enabled;
               _loc3_++;
            }
         }
      }
      
      public function get dataProvider() : IDataProvider
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IDataProvider) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider != null)
         {
            this._dataProvider.removeEventListener(Event.CHANGE,this.handleDataChange,false);
         }
         this._dataProvider = param1;
         if(this._dataProvider == null)
         {
            return;
         }
         this._dataProvider.addEventListener(Event.CHANGE,this.handleDataChange,false,0,true);
         this.ClearSelectionAndTooltip();
      }
      
      protected function clearSelections() : void
      {
         this.selectedIndex = -1;
         if(this.multiselectable)
         {
            this._selections = new Array();
         }
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField != param1)
         {
            this._labelField = param1;
            invalidateData();
         }
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         if(this._labelFunction != param1)
         {
            this._labelFunction = param1;
            invalidateData();
         }
      }
      
      public function get availableWidth() : Number
      {
         return _width;
      }
      
      public function get availableHeight() : Number
      {
         return _height;
      }
      
      public function scrollToIndex(param1:uint) : void
      {
      }
      
      public function scrollToSelected() : void
      {
         this.scrollToIndex(this._selectedIndex);
      }
      
      public function itemToLabel(param1:Object) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(this._labelFunction != null)
         {
            return this._labelFunction(param1);
         }
         if(this._labelField != null && this._labelField in param1 && param1[this._labelField] != null)
         {
            return param1[this._labelField];
         }
         return param1.toString();
      }
      
      public function invalidateRenderers() : void
      {
         invalidate(InvalidationType.RENDERERS);
      }
      
      public function invalidateSelectedIndex() : void
      {
         invalidate(InvalidationType.SELECTED_INDEX);
      }
      
      override public function toString() : String
      {
         return "[CLIK CoreList " + name + "]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.container == null)
         {
            this.container = new Sprite();
            addChild(this.container);
         }
         tabEnabled = _focusable;
         tabChildren = false;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         addEventListener(InputEvent.INPUT,handleInput,false,0,true);
      }
      
      override protected function draw() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         if(isInvalid(InvalidationType.SELECTED_INDEX))
         {
            this.updateSelectedIndex();
         }
         if(isInvalid(InvalidationType.STATE))
         {
            if(this._newFrame)
            {
               gotoAndPlay(this._newFrame);
               this._newFrame = null;
            }
         }
         if(!this.usingExternalRenderers && isInvalid(InvalidationType.RENDERERS))
         {
            if(this.renderers != null)
            {
               _loc2_ = this.renderers.length;
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  _loc3_ = this.getRendererAt(_loc1_);
                  this.cleanUpRenderer(_loc3_);
                  _loc4_ = _loc3_ as DisplayObject;
                  if(this.container.contains(_loc4_))
                  {
                     this.container.removeChild(_loc4_);
                  }
                  _loc1_++;
               }
            }
            this.renderers = new Vector.<IListItemRenderer>();
            invalidateData();
         }
         if(!this.usingExternalRenderers && isInvalid(InvalidationType.SIZE))
         {
            _loc5_ = this.container.mask;
            removeChild(this.container);
            setActualSize(_width,_height);
            this.container.scaleX = 1 / scaleX;
            this.container.scaleY = 1 / scaleY;
            this.totalRenderers = this.calculateRendererTotal(this.availableWidth,this.availableHeight);
            addChild(this.container);
            this.container.mask = _loc5_;
            invalidateData();
         }
         if(!this.usingExternalRenderers && isInvalid(InvalidationType.RENDERERS,InvalidationType.SIZE))
         {
            this.drawRenderers(this.totalRenderers);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            this.refreshData();
         }
         if(!this.usingExternalRenderers && isInvalid(InvalidationType.RENDERERS,InvalidationType.SIZE))
         {
            this.drawLayout();
         }
      }
      
      override protected function changeFocus() : void
      {
         if(Boolean(_focused) || _displayFocus)
         {
            this.setState("focused","default");
         }
         else
         {
            this.setState("default");
         }
      }
      
      protected function refreshData() : void
      {
      }
      
      protected function updateSelectedIndex() : void
      {
      }
      
      protected function calculateRendererTotal(param1:Number, param2:Number) : uint
      {
         return param2 / 20 >> 0;
      }
      
      protected function drawLayout() : void
      {
      }
      
      protected function drawRenderers(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:IListItemRenderer = null;
         var _loc5_:DisplayObject = null;
         if(this._itemRenderer == null)
         {
            return;
         }
         _loc2_ = int(this.renderers.length);
         while(_loc2_ < this.totalRenderers)
         {
            _loc4_ = this.createRenderer(_loc2_);
            if(_loc4_ == null)
            {
               break;
            }
            this.renderers.push(_loc4_);
            this.container.addChild(_loc4_ as DisplayObject);
            _loc2_++;
         }
         _loc3_ = int(this.renderers.length);
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= this.totalRenderers)
         {
            _loc4_ = this.getRendererAt(_loc2_);
            if(_loc4_ != null)
            {
               this.cleanUpRenderer(_loc4_);
               _loc5_ = _loc4_ as DisplayObject;
               if(this.container.contains(_loc5_))
               {
                  this.container.removeChild(_loc5_);
               }
            }
            this.renderers.splice(_loc2_,1);
            _loc2_--;
         }
      }
      
      protected function createRenderer(param1:uint) : IListItemRenderer
      {
         var _loc2_:IListItemRenderer = new this._itemRenderer() as IListItemRenderer;
         if(_loc2_ == null)
         {
            return null;
         }
         this.setupRenderer(_loc2_);
         (_loc2_ as DisplayObject).name = "Renderer" + param1;
         return _loc2_;
      }
      
      protected function getRendererAt(param1:uint, param2:int = 0) : IListItemRenderer
      {
         if(this.renderers == null)
         {
            return null;
         }
         var _loc3_:uint = param1 - param2;
         if(_loc3_ >= this.renderers.length)
         {
            return null;
         }
         return this.renderers[_loc3_] as IListItemRenderer;
      }
      
      protected function setupRenderer(param1:IListItemRenderer) : void
      {
         param1.owner = this;
         param1.focusTarget = this;
         param1.tabEnabled = false;
         param1.doubleClickEnabled = true;
         if(this.usingExternalRenderers)
         {
            param1.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         }
         param1.addEventListener(ListItemEvent.PRESS,this.dispatchItemEvent,false,0,true);
         param1.addEventListener(ListItemEvent.CLICK,this.handleItemClick,false,0,true);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.dispatchItemEvent,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.dispatchItemEvent,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.dispatchItemEvent,false,0,true);
      }
      
      protected function cleanUpRenderer(param1:IListItemRenderer) : void
      {
         param1.owner = null;
         param1.focusTarget = null;
         param1.doubleClickEnabled = false;
         param1.removeEventListener(ListItemEvent.PRESS,this.dispatchItemEvent);
         param1.removeEventListener(ListItemEvent.CLICK,this.handleItemClick);
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.dispatchItemEvent);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.dispatchItemEvent);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.dispatchItemEvent);
         param1.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
      }
      
      protected function dispatchItemEvent(param1:Event) : Boolean
      {
         var _loc2_:String = null;
         switch(param1.type)
         {
            case ListItemEvent.PRESS:
               _loc2_ = ListEvent.ITEM_PRESS;
               break;
            case ListItemEvent.CLICK:
               _loc2_ = ListEvent.ITEM_CLICK;
               break;
            case MouseEvent.ROLL_OVER:
               _loc2_ = ListEvent.ITEM_ROLL_OVER;
               break;
            case MouseEvent.ROLL_OUT:
               _loc2_ = ListEvent.ITEM_ROLL_OUT;
               break;
            case MouseEvent.DOUBLE_CLICK:
               _loc2_ = ListEvent.ITEM_DOUBLE_CLICK;
               break;
            default:
               return true;
         }
         var _loc3_:IListItemRenderer = param1.currentTarget as IListItemRenderer;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         if(param1 is ListItemEvent)
         {
            _loc4_ = (param1 as ListItemEvent).isKeyboard;
            _loc5_ = (param1 as ListItemEvent).buttonIdx;
         }
         var _loc6_:ListEvent = new ListEvent(_loc2_,false,true,_loc3_.index,0,_loc3_.index,_loc3_,_loc5_,_loc4_);
         return dispatchEvent(_loc6_);
      }
      
      protected function handleDataChange(param1:Event) : void
      {
         this.ClearSelectionAndTooltip();
      }
      
      protected function ClearSelectionAndTooltip() : void
      {
         var _loc1_:IListItemRenderer = null;
         var _loc2_:UIComponent = null;
         for each(_loc1_ in this.renderers)
         {
            _loc2_ = _loc1_ as UIComponent;
            if(_loc2_)
            {
               _loc2_.ClearTooltip();
            }
         }
         invalidateData();
         this.clearSelections();
      }
      
      protected function handleItemClick(param1:ListItemEvent) : void
      {
         var _loc2_:IListItemRenderer = param1.currentTarget as IListItemRenderer;
         var _loc3_:Number = _loc2_.index;
         if(isNaN(_loc3_))
         {
            return;
         }
         if(this.dispatchItemEvent(param1))
         {
            if(!this.multiselectable)
            {
               this.selectedIndex = _loc3_;
            }
            else
            {
               if(this.isSelected(_loc3_))
               {
                  this.removeSelection(_loc2_.groupId);
               }
               else
               {
                  this.addSelection(_loc2_.groupId,_loc3_);
               }
               this.invalidateSelectedIndex();
            }
         }
      }
      
      protected function handleMouseWheel(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            this.scrollList(param1.delta > 0 ? 1 : -1);
         }
      }
      
      protected function scrollList(param1:int) : void
      {
      }
      
      protected function setState(... rest) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(rest.length == 1)
         {
            _loc4_ = rest[0].toString();
            if(this.state != _loc4_ && Boolean(_labelHash[_loc4_]))
            {
               this.state = this._newFrame = _loc4_;
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
               this.state = this._newFrame = _loc5_;
               invalidateState();
               break;
            }
            _loc3_++;
         }
      }
      
      public function GetLength() : int
      {
         return this._dataProvider ? int(this._dataProvider.length) : 0;
      }
   }
}

