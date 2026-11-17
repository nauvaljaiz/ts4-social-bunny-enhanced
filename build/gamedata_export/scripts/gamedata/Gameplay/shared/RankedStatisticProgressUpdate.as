package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.core.Time;
   
   public class RankedStatisticProgressUpdate extends OlympusObject
   {
      
      public var simId:String;
      
      public var stat_id:String;
      
      public var change_rate:Number = 0;
      
      public var rank:uint = 0;
      
      public var curr_rank_points:uint = 0;
      
      public var value_difference:Number = 0;
      
      public var elapsedSeconds:uint;
      
      public var startTime:uint;
      
      public function RankedStatisticProgressUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.elapsedSeconds = Math.max(0,this.elapsedSeconds);
         this.startTime = Time.GetGameTime().ConvertToMinutes();
      }
      
      public function get CurrentPoints() : uint
      {
         if(this.change_rate == 0)
         {
            return this.curr_rank_points;
         }
         var _loc1_:int = this.curr_rank_points + this.GetPointsAccrued();
         return Math.max(0,_loc1_);
      }
      
      public function GetPointsAccrued() : int
      {
         var _loc1_:uint = this.elapsedSeconds / 60;
         _loc1_ += Math.max(Time.GetGameTime().ConvertToMinutes() - this.startTime,0);
         return _loc1_ * this.change_rate;
      }
   }
}

