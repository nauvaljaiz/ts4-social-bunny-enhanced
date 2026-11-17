package gamedata.Gameplay.SimInfoHUD
{
   import olympus.core.OlympusObject;
   
   public class LifeSkillProgressUpdate extends OlympusObject
   {
      
      public static const GAIN_RATE_THRESHOLDS:Array = [0,1,6];
      
      public static const GAIN_ONESHOT_THRESHOLDS:Array = [0,2,6];
      
      public var sim_id:String;
      
      public var life_skill_id:String;
      
      public var curr_value:Number = 0;
      
      public var rate_of_change:Number = 0;
      
      public var prev_value:Number = 0;
      
      public var elapsedMinutes:Number = 0;
      
      public function LifeSkillProgressUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.elapsedMinutes = Math.max(this.elapsedMinutes,0);
      }
      
      public function get TotalChange() : Number
      {
         return this.curr_value - this.prev_value;
      }
      
      public function get ChangeIntensity() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:Array = null;
         if(this.rate_of_change == 0)
         {
            _loc1_ = this.TotalChange;
            _loc2_ = GAIN_ONESHOT_THRESHOLDS;
         }
         else
         {
            _loc1_ = this.rate_of_change;
            _loc2_ = GAIN_RATE_THRESHOLDS;
         }
         _loc1_ = Math.abs(_loc1_);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc2_.length);
         while(_loc4_ < _loc5_)
         {
            if(_loc1_ >= _loc2_[_loc4_])
            {
               _loc3_ = _loc4_ + 1;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function ToString() : String
      {
         return "sim_id:" + this.sim_id + "|life_skill_id:" + this.life_skill_id + "|curr_value:" + this.curr_value + "|prev_value:" + this.prev_value + "|rate_of_change:" + this.rate_of_change;
      }
   }
}

