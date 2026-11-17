package olympus.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class ScrollerEvent extends Event
   {
      
      public static const SCROLL:String = "scroll";
      
      public static const SCROLL_BEGIN:String = "scrollBegin";
      
      public static const SCROLL_END:String = "scrollEnd";
      
      public var mScrollRect:Rectangle;
      
      public function ScrollerEvent(param1:String, param2:Rectangle = null)
      {
         super(param1,false,false);
         this.mScrollRect = param2;
      }
   }
}

