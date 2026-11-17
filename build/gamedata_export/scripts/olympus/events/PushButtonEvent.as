package olympus.events
{
   import flash.events.Event;
   
   public class PushButtonEvent extends Event
   {
      
      public static const PRESS:String = "buttonPress";
      
      public static const CLICK:String = "buttonClick";
      
      public static const SELECT:String = "buttonSelect";
      
      public static const RELEASE_OUT:String = "buttonReleaseOut";
      
      public static const ROLL_OVER:String = "rollOver";
      
      public static const ROLL_OUT:String = "rollOut";
      
      public var buttonIdx:uint = 0;
      
      public function PushButtonEvent(param1:String, param2:uint = 0)
      {
         super(param1,false,false);
         this.buttonIdx = param2;
      }
   }
}

