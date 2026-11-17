package olympus.gamepad
{
   import olympus.input.IInputFocusable;
   
   public class WidgetInputFocusable
   {
      
      public var mWidgetName:String;
      
      public var mFocusable:IInputFocusable;
      
      public function WidgetInputFocusable(param1:String, param2:IInputFocusable)
      {
         super();
         this.mWidgetName = param1;
         this.mFocusable = param2;
      }
      
      public function toString() : String
      {
         return "[WidgetInputFocusable focusable=" + this.mFocusable + " widget=" + this.mWidgetName + "]";
      }
   }
}

