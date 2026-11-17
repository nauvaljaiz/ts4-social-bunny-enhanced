package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class InputAdapterConfirmEvent extends InputAdapterEvent
   {
      
      protected var mSelectedObj:DisplayObject;
      
      public function InputAdapterConfirmEvent(param1:DisplayObject)
      {
         super(CONFIRM);
         this.mSelectedObj = param1;
      }
      
      public function GetObjName() : String
      {
         return this.mSelectedObj ? this.mSelectedObj.name : null;
      }
      
      public function GetObj() : DisplayObject
      {
         return this.mSelectedObj;
      }
      
      override public function clone() : Event
      {
         return new InputAdapterConfirmEvent(this.mSelectedObj);
      }
      
      override public function toString() : String
      {
         return formatToString("InputAdapterEvent","type","mSelectedObj","bubbles","cancelable","eventPhase");
      }
   }
}

