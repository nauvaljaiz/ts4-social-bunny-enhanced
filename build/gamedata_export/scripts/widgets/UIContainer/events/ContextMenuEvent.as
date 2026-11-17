package widgets.UIContainer.events
{
   import flash.events.Event;
   
   public class ContextMenuEvent extends Event
   {
      
      public static const SELECTION:String = "SelectionMade";
      
      public var selectionData:Object;
      
      public function ContextMenuEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.selectionData = param4;
      }
      
      override public function clone() : Event
      {
         return new ContextMenuEvent(type,bubbles,cancelable,this.selectionData);
      }
      
      override public function toString() : String
      {
         return formatToString("ContextMenuEvent","type","bubbles","cancelable","selectionData");
      }
   }
}

