package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationMeterData extends OlympusObject
   {
      
      public var meter_id:int;
      
      public var minimum_value:Number;
      
      public var maximum_value:Number;
      
      public var meter_text:LocKey = new LocKey();
      
      public var meter_tooltip:LocKey = new LocKey();
      
      public var thresholds:Array = [SituationMeterThreshold];
      
      public function SituationMeterData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:SituationMeterThreshold = null;
         super.ParseObject(param1);
         if(!param1 || !("thresholds" in param1))
         {
            this.thresholds = new Array();
         }
         else
         {
            FixupArray(this.thresholds);
         }
         if(this.thresholds.length == 0)
         {
            _loc2_ = new SituationMeterThreshold();
            _loc2_.threshold = this.minimum_value;
            _loc2_.color = 4294967295;
            this.thresholds.push(_loc2_);
         }
         var _loc3_:SituationMeterThreshold = this.thresholds[this.thresholds.length - 1];
         if(_loc3_.threshold < this.maximum_value || this.thresholds.length == 1)
         {
            _loc2_ = new SituationMeterThreshold();
            _loc2_.threshold = this.maximum_value;
            _loc2_.color = _loc3_.color;
            this.thresholds.push(_loc2_);
         }
      }
      
      public function GetThresholdRangeIndices(param1:Number) : Array
      {
         var _loc4_:SituationMeterThreshold = null;
         var _loc5_:SituationMeterThreshold = null;
         if(!this.thresholds || this.thresholds.length < 2)
         {
            return null;
         }
         if(param1 <= this.minimum_value)
         {
            return [0,1];
         }
         if(param1 >= this.maximum_value)
         {
            return [this.thresholds.length - 2,this.thresholds.length - 1];
         }
         var _loc2_:int = 0;
         var _loc3_:* = this.thresholds.length - 1;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.thresholds[_loc2_];
            _loc5_ = this.thresholds[_loc2_ + 1];
            if(param1 >= _loc4_.threshold && param1 < _loc5_.threshold)
            {
               return [_loc2_,_loc2_ + 1];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetThresholdRange(param1:Number) : Array
      {
         var _loc2_:Array = this.GetThresholdRangeIndices(param1);
         if(Boolean(_loc2_) && _loc2_.length == 2)
         {
            return [this.thresholds[_loc2_[0]],this.thresholds[_loc2_[1]]];
         }
         return null;
      }
   }
}

