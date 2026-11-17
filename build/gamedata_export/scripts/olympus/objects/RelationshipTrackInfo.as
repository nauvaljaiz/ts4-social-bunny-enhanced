package olympus.objects
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import olympus.core.OlympusObject;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.localization.LocKey;
   
   public class RelationshipTrackInfo extends OlympusObject implements IEventDispatcher
   {
      
      public static const RELATIONSHIP_TRACK_TICK:String = "relationshipTrackTick";
      
      public static const UPDATE_DELAY_TIME:Number = 20000;
      
      public var track_bit:RelationshipBitInfo = new RelationshipBitInfo();
      
      public var track_score:Number = 0;
      
      public var track_pop_up_priority:int;
      
      public var track_id:String;
      
      public var change:Number = 0;
      
      public var change_rate:Number = 0;
      
      public var elapsed_seconds:Number = 0;
      
      public var visible_in_relationship_panel:Boolean = true;
      
      public var track_type:uint = 0;
      
      public var sign_type:uint = 0;
      
      public var duration_type:uint = 0;
      
      public var archetype_name:LocKey = new LocKey();
      
      public var display_priority:uint;
      
      public var display_in_sim_profile:Boolean = false;
      
      public var track_name:LocKey = new LocKey();
      
      public var mTrackPriority:uint;
      
      protected var mAccruedTime:Number = 0;
      
      protected var mNextUpdateTime:Number = 0;
      
      protected var mEventDispatcher:EventDispatcher;
      
      public function RelationshipTrackInfo(param1:Object = null)
      {
         super(param1);
         this.mEventDispatcher = new EventDispatcher(this);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.elapsed_seconds = Math.max(this.elapsed_seconds,0);
         if(this.change_rate != 0)
         {
            this.track_score += this.elapsed_seconds / 60 * this.change_rate;
            Ticker.Add(this,0,this.OnTick);
         }
      }
      
      public function get CurrentTrackScore() : Number
      {
         var _loc1_:Number = this.mAccruedTime * 0.00001667;
         return this.track_score + _loc1_ * this.change_rate;
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
            this.dispatchEvent(new Event(RELATIONSHIP_TRACK_TICK));
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

