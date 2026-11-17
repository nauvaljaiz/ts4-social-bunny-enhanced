package olympus.events
{
   import flash.events.Event;
   import olympus.core.Time;
   
   public class TickerEvent extends Event
   {
      
      public static const TICK:String = "tick";
      
      public var deltaTime:Number = 0;
      
      public var deltaTimeGameSpeed:Number = 0;
      
      public var deltaSimTimeUsingGameSpeed:Number = 0;
      
      public function TickerEvent(param1:String, param2:Number, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.deltaTime = param2;
         var _loc5_:Number = param2 * Time.mGameSpeed;
         this.deltaTimeGameSpeed = _loc5_;
         this.deltaSimTimeUsingGameSpeed = _loc5_ * Time.mTimeRatio;
      }
      
      public function get DeltaSimMinutesUsingGameSpeed() : Number
      {
         return this.deltaSimTimeUsingGameSpeed * 0.00001667;
      }
      
      override public function clone() : Event
      {
         return this;
      }
      
      override public function toString() : String
      {
         return formatToString("TickerEvent","deltaTime");
      }
   }
}

