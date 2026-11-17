package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import olympus.interfaces.IView;
   
   public class InputAdapterHighlightEvent extends InputAdapterEvent
   {
      
      protected var mView:IView;
      
      protected var mDisplayObject:DisplayObject;
      
      public function InputAdapterHighlightEvent(param1:IView, param2:DisplayObject)
      {
         super(HIGHLIGHT_CHANGED);
         this.mView = param1;
         this.mDisplayObject = param2;
      }
      
      public function GetView() : IView
      {
         return this.mView;
      }
      
      public function GetDisplayObject() : DisplayObject
      {
         return this.mDisplayObject;
      }
      
      override public function clone() : Event
      {
         return new InputAdapterHighlightEvent(this.mView,this.mDisplayObject);
      }
      
      override public function toString() : String
      {
         return formatToString("InputAdapterEvent","type","mView","bubbles","cancelable","eventPhase");
      }
   }
}

