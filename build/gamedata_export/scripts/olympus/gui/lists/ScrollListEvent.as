package olympus.gui.lists
{
   import flash.events.Event;
   import olympus.interfaces.IView;
   
   public class ScrollListEvent extends Event
   {
      
      public static const VISIBILITY_UPDATED:String = "visibility_updated";
      
      public var mVisibleCells:Vector.<IView>;
      
      public var mShownCells:Vector.<IView>;
      
      public var mHiddenCells:Vector.<IView>;
      
      public var mbListScrolled:Boolean;
      
      public function ScrollListEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new ScrollListEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ScrollListEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

