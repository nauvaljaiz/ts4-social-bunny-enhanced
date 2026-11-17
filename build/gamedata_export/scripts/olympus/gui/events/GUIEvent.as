package olympus.gui.events
{
   import flash.events.Event;
   
   public class GUIEvent extends Event
   {
      
      public static const REDRAW:String = "redraw";
      
      public static const REFRESH:String = "refresh";
      
      public function GUIEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

