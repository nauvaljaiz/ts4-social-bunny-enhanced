package gamedata.Gameplay.shared
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import olympus.core.OlympusObject;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.utils.Clamp;
   
   public class PurchaseIntentUpdate extends OlympusObject implements IEventDispatcher
   {
      
      public static const PURCHASE_INTENT_PROGRESS_TICK:String = "purchaseIntentProgressTick";
      
      public static const MIN_VALUE:int = 1;
      
      public static const MAX_VALUE:int = 101;
      
      public static const UPDATE_DELAY_TIME:Number = 1000;
      
      public var sim_id:String;
      
      public var curr_value:int;
      
      public var target_value:int;
      
      public var show_continuously:Boolean = false;
      
      protected var mAccruedTime:Number = 0;
      
      protected var mNextUpdateTime:Number = 0;
      
      protected var mEventDispatcher:EventDispatcher;
      
      public function PurchaseIntentUpdate(param1:Object = null)
      {
         super(param1);
         this.mEventDispatcher = new EventDispatcher(this);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.curr_value = Clamp.Int(this.curr_value + MIN_VALUE,MIN_VALUE,MAX_VALUE);
         this.target_value = Clamp.Int(this.target_value + MIN_VALUE,MIN_VALUE,MAX_VALUE);
         Ticker.Add(this,0,this.OnTick);
      }
      
      protected function OnTick(param1:TickerEvent) : void
      {
         var _loc2_:Number = param1.deltaSimTimeUsingGameSpeed;
         if(_loc2_ == 0)
         {
            return;
         }
         this.mAccruedTime += _loc2_;
         if(this.mAccruedTime > this.mNextUpdateTime)
         {
            this.dispatchEvent(new Event(PURCHASE_INTENT_PROGRESS_TICK));
            this.mNextUpdateTime = this.mAccruedTime + UPDATE_DELAY_TIME;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.mEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.mEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.mEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.mEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.mEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

