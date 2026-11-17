package olympus.input.adapters
{
   import flash.events.Event;
   
   public class InputAdapterEvent extends Event
   {
      
      public static const LEAVE:String = "iae_leave";
      
      public static const HIGHLIGHT_CHANGED:String = "iae_highlight_changed";
      
      public static const CONFIRM:String = "iae_confirm";
      
      public static const BACK:String = "iae_back";
      
      public static const TAB:String = "iae_tab";
      
      public static const ENTERED:String = "iae_entered";
      
      public static const EXITED:String = "iae_exited";
      
      public function InputAdapterEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new InputAdapterEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("InputAdapterEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

