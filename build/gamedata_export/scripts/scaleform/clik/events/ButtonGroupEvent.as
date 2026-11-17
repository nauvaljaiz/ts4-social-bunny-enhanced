package scaleform.clik.events
{
   import flash.events.Event;
   import scaleform.clik.controls.Button;
   
   public class ButtonGroupEvent extends Event
   {
      
      public static const BUTTON_CLICK:String = "groupButtonClick";
      
      public var index:int = -1;
      
      public var button:Button;
      
      public function ButtonGroupEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:Button = null)
      {
         super(param1,param2,param3);
         this.index = param4;
         this.button = param5;
      }
      
      override public function clone() : Event
      {
         return new ButtonGroupEvent(type,bubbles,cancelable,this.index,this.button);
      }
      
      override public function toString() : String
      {
         return formatToString("ButtonGroupEvent","type","bubbles","cancelable","index","button");
      }
   }
}

