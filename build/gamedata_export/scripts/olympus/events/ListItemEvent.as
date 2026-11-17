package olympus.events
{
   import flash.events.Event;
   
   public class ListItemEvent extends Event
   {
      
      public static const PRESS:String = "listItemPress";
      
      public static const CLICK:String = "listItemClick";
      
      public static const TOGGLE_SUBITEM:String = "listItemToggleSubItem";
      
      public var isKeyboard:Boolean = false;
      
      public var buttonIdx:uint = 0;
      
      public function ListItemEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:Boolean = false)
      {
         super(param1,param2,param3);
         this.isKeyboard = param5;
         this.buttonIdx = param4;
      }
      
      override public function clone() : Event
      {
         return new ListItemEvent(type,bubbles,cancelable,this.buttonIdx,this.isKeyboard);
      }
      
      override public function toString() : String
      {
         return formatToString("ListItemEvent","type","bubbles","cancelable","eventPhase","buttonIdx","isKeyboard");
      }
   }
}

