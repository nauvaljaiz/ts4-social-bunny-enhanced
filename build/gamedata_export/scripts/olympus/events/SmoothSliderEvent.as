package olympus.events
{
   import flash.events.Event;
   
   public class SmoothSliderEvent extends Event
   {
      
      public static const SLIDE:String = "slide";
      
      public static const SNAP:String = "snap";
      
      public static const DRAG_START:String = "slider_drag_start";
      
      public static const DRAG_CONTINUE:String = "slider_drag_continue";
      
      public static const DRAG_END:String = "slider_drag_end";
      
      public var mPrevSliderValue:Number = 0;
      
      public var mSliderValue:Number = 0;
      
      public var mAllThumbValues:Array;
      
      public function SmoothSliderEvent(param1:String, param2:Number = 0, param3:Number = 0, param4:Array = null)
      {
         super(param1,false,false);
         this.mSliderValue = param2;
         this.mPrevSliderValue = param3;
         this.mAllThumbValues = param4;
      }
   }
}

