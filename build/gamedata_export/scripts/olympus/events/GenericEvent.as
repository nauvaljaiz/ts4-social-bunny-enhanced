package olympus.events
{
   import flash.events.Event;
   
   public class GenericEvent extends Event
   {
      
      public static const CLOSE:String = "generic_close";
      
      public static const RESIZE:String = "generic_resize";
      
      public static const COMPLETE:String = "generic_complete";
      
      public static const INIT:String = "generic_init";
      
      public static const CHANGE:String = "generic_change";
      
      public static const REMOVE:String = "generic_remove";
      
      public static const SELECT:String = "generic_select";
      
      public var data:Object;
      
      public function GenericEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         super(param1,param2,param3);
         this.data = param4;
      }
      
      override public function clone() : Event
      {
         return new GenericEvent(type,bubbles,cancelable,this.data);
      }
   }
}

