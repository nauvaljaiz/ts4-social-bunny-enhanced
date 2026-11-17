package olympus.input.adapters
{
   import flash.events.Event;
   import flash.geom.Point;
   import olympus.gamepad.EnterParams;
   
   public class InputAdapterLeaveEvent extends InputAdapterEvent
   {
      
      protected var mDirection:uint;
      
      protected var mFromPosition:Point;
      
      public function InputAdapterLeaveEvent(param1:uint, param2:Point)
      {
         super(LEAVE);
         this.mDirection = param1;
         this.mFromPosition = param2;
      }
      
      public function GetDirection() : uint
      {
         return this.mDirection;
      }
      
      public function GetFromPosition() : Point
      {
         return this.mFromPosition;
      }
      
      public function CreateEnterParams() : EnterParams
      {
         return new EnterParams(this.mDirection,this.mFromPosition);
      }
      
      override public function clone() : Event
      {
         return new InputAdapterLeaveEvent(this.mDirection,this.mFromPosition);
      }
      
      override public function toString() : String
      {
         return formatToString("InputAdapterLeaveEvent","type","mDirection","mFromPosition","bubbles","cancelable","eventPhase");
      }
   }
}

