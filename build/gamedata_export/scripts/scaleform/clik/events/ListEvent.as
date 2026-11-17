package scaleform.clik.events
{
   import flash.events.Event;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class ListEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const ITEM_PRESS:String = "itemPress";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
      
      public static const INDEX_CHANGE:String = "indexChange";
      
      public static const SCROLL_CHANGE:String = "scrollChange";
      
      public var index:int = -1;
      
      public var columnIndex:int = -1;
      
      public var rowIndex:int = -1;
      
      public var itemRenderer:IListItemRenderer;
      
      public var isKeyboard:Boolean = false;
      
      public var buttonIdx:uint = 0;
      
      public function ListEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:int = -1, param5:int = -1, param6:int = -1, param7:IListItemRenderer = null, param8:uint = 0, param9:Boolean = false)
      {
         super(param1,param2,param3);
         this.index = param4;
         this.rowIndex = param6;
         this.columnIndex = param5;
         this.itemRenderer = param7;
         this.isKeyboard = param9;
         this.buttonIdx = param8;
      }
      
      override public function clone() : Event
      {
         return new ListEvent(type,bubbles,cancelable,this.index,this.columnIndex,this.rowIndex,this.itemRenderer,this.buttonIdx,this.isKeyboard);
      }
      
      override public function toString() : String
      {
         return formatToString("ListEvent","type","bubbles","cancelable","index","columnIndex","rowIndex","buttonIdx","isKeyboard");
      }
   }
}

