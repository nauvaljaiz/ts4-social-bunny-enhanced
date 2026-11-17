package scaleform.clik.controls
{
   import olympus.events.ListItemEvent;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.ListData;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class ListItemRenderer extends Button implements IListItemRenderer
   {
      
      protected var _index:uint = 4294967295;
      
      protected var _owner:UIComponent;
      
      protected var _selectable:Boolean = true;
      
      protected var _contextData:Object;
      
      public function ListItemRenderer()
      {
         super();
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function get owner() : UIComponent
      {
         return this._owner;
      }
      
      public function set owner(param1:UIComponent) : void
      {
         this._owner = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
      }
      
      override public function get selected() : Boolean
      {
         return _selected;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         var _loc3_:Object = null;
         if(!this._selectable || _selected == param1)
         {
            return;
         }
         super.selected = param1;
         var _loc2_:Boolean = false;
         if(param1 && Boolean(this.owner))
         {
            _loc2_ = this.owner.focused > 0;
            if(!_loc2_)
            {
               _loc3_ = this.owner.focusTarget;
            }
            if(Boolean(_loc3_) && Boolean(_loc3_.focused))
            {
               _loc2_ = true;
            }
         }
         displayFocus = param1 && _loc2_;
      }
      
      public function setListData(param1:ListData) : void
      {
         this.index = param1.index;
         _selected = param1.selected;
         label = param1.label || "";
         this._contextData = param1.contextData;
         setState("up");
      }
      
      public function get groupId() : int
      {
         return 0;
      }
      
      override public function toString() : String
      {
         return "[CLIK ListItemRenderer " + this.index + ", " + name + "]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusTarget = this.owner;
         tabEnabled = false;
         this.addEventListener(ButtonEvent.PRESS,this.dispatchListItemEvent,false,0,true);
         this.addEventListener(ButtonEvent.CLICK,this.dispatchListItemEvent,false,0,true);
      }
      
      protected function dispatchListItemEvent(param1:ButtonEvent) : Boolean
      {
         var _loc2_:String = null;
         switch(param1.type)
         {
            case ButtonEvent.PRESS:
               _loc2_ = ListItemEvent.PRESS;
               break;
            case ButtonEvent.CLICK:
               _loc2_ = ListItemEvent.CLICK;
               dispatchEvent(new ListItemEvent(ListItemEvent.TOGGLE_SUBITEM,false,true,param1.buttonIdx,param1.isKeyboard));
               break;
            default:
               return true;
         }
         return dispatchEvent(new ListItemEvent(_loc2_,false,true,param1.buttonIdx,param1.isKeyboard));
      }
   }
}

