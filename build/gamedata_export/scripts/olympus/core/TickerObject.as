package olympus.core
{
   import flash.events.EventDispatcher;
   import olympus.events.TickerEvent;
   
   public class TickerObject extends EventDispatcher
   {
      
      public var mCurTime:Number = 0;
      
      public var mTotalTime:Number = 0;
      
      public var mbGameSpeedDependent:Boolean;
      
      public var mbToRemove:Object;
      
      public function TickerObject(param1:Number, param2:Function, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         this.mTotalTime = param1;
         this.mbGameSpeedDependent = param3;
         this.mCurTime = 0;
         this.mbToRemove = false;
         addEventListener(TickerEvent.TICK,param2,false,0,param4);
      }
      
      public function Reset() : void
      {
         this.mbToRemove = false;
         this.mCurTime = 0;
      }
      
      public function Update(param1:TickerEvent) : Boolean
      {
         if(this.mbGameSpeedDependent)
         {
            this.mCurTime += param1.deltaTimeGameSpeed;
         }
         else
         {
            this.mCurTime += param1.deltaTime;
         }
         if(this.mCurTime >= this.mTotalTime)
         {
            this.mbToRemove = true;
            dispatchEvent(param1);
            return true;
         }
         return false;
      }
   }
}

