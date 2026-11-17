package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.math.Interpolation;
   import olympus.utils.Clamp;
   
   public class RankedStatisticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sOccultMap:Object = new Object();
      
      protected static var sRankedStatMap:Object = new Object();
      
      public var id:String;
      
      public var increments:Array = [RankedStatisticIncrementData];
      
      public var num_ranks:int;
      
      public var initial_rank:int;
      
      public var buck_types:Array = [uint];
      
      public var center_bar_tooltip:Boolean;
      
      public var zero_point:uint;
      
      public var bar_color:uint;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var starting_rank_display_override:int = 0;
      
      public var incrementsInRanksLookup:Array;
      
      public var pointsPerRank:Array;
      
      public var totalPoints:uint;
      
      public var startingPointsPerRank:Array;
      
      public var zeroPointRank:uint;
      
      public function RankedStatisticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetDataByOccultType(param1:int) : RankedStatisticData
      {
         var _loc2_:RankedStatisticData = sOccultMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Object = sGetStaticDataFunc({"occultType":param1});
         if(_loc3_)
         {
            _loc2_ = new RankedStatisticData(_loc3_);
            sOccultMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function GetDataById(param1:String) : RankedStatisticData
      {
         var _loc2_:RankedStatisticData = sRankedStatMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Object = sGetStaticDataFunc({"rankedStatId":param1});
         if(_loc3_)
         {
            _loc2_ = new RankedStatisticData(_loc3_);
            sRankedStatMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:RankedStatisticIncrementData = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.ParseObject(param1);
         if(this.icon.instance == "0")
         {
            this.icon = null;
         }
         this.totalPoints = 0;
         this.pointsPerRank = new Array(this.num_ranks);
         this.incrementsInRanksLookup = new Array(this.num_ranks);
         this.startingPointsPerRank = new Array(this.num_ranks);
         for each(_loc2_ in this.increments)
         {
            _loc3_ = uint(_loc2_.points);
            _loc4_ = uint(_loc2_.rankIndex);
            if(!this.pointsPerRank[_loc4_])
            {
               this.pointsPerRank[_loc4_] = 0;
               this.startingPointsPerRank[_loc4_] = this.totalPoints;
            }
            this.pointsPerRank[_loc4_] += _loc3_;
            this.totalPoints += _loc3_;
            if(!this.incrementsInRanksLookup[_loc4_])
            {
               this.incrementsInRanksLookup[_loc4_] = new Array();
            }
            this.incrementsInRanksLookup[_loc4_].push(_loc2_);
         }
         this.zeroPointRank = this.CalculateRank(this.zero_point);
      }
      
      public function get LastRank() : uint
      {
         return this.initial_rank + this.num_ranks - 1;
      }
      
      public function GetRank(param1:int) : RankedStatisticIncrementData
      {
         var _loc2_:Array = this.GetIncrementsInRank(param1);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            return _loc2_[0];
         }
         return null;
      }
      
      public function GetCurrentRankIncrement(param1:int, param2:int) : RankedStatisticIncrementData
      {
         var _loc4_:int = 0;
         var _loc5_:RankedStatisticIncrementData = null;
         var _loc3_:Array = this.GetIncrementsInRank(param1);
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = 0;
            for each(_loc5_ in _loc3_)
            {
               if(param2 < _loc4_ + _loc5_.points)
               {
                  return _loc5_;
               }
               _loc4_ += _loc5_.points;
            }
            return _loc5_;
         }
         return null;
      }
      
      public function CalculateRank(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this.num_ranks;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = int(this.pointsPerRank[_loc2_]);
            _loc5_ = _loc2_ + 1 < _loc3_ ? int(this.pointsPerRank[_loc2_ + 1]) : -1;
            if(param1 < _loc4_ && _loc5_ != 0)
            {
               return _loc2_ + this.initial_rank;
            }
            param1 -= _loc4_;
            _loc2_++;
         }
         return _loc2_ + this.initial_rank;
      }
      
      public function GetIncrementsInRank(param1:int) : Array
      {
         return this.incrementsInRanksLookup[this.GetRankIndex(param1)];
      }
      
      public function GetStartingPointsForRank(param1:int) : int
      {
         return this.startingPointsPerRank[this.GetRankIndex(param1)];
      }
      
      public function GetPointsInRank(param1:int) : int
      {
         return this.pointsPerRank[this.GetRankIndex(param1)];
      }
      
      public function GetRankIndex(param1:*) : int
      {
         var _loc2_:int = param1 - this.initial_rank;
         return Clamp.Int(_loc2_,0,this.num_ranks - 1);
      }
      
      public function GetAdjustedMeterValue(param1:uint, param2:int, param3:Number = -1, param4:Number = -1) : Number
      {
         if(param1 >= this.num_ranks)
         {
            return this.totalPoints;
         }
         var _loc5_:Number = this.totalPoints / this.num_ranks;
         var _loc6_:Number = this.GetPointsInRank(param1);
         var _loc7_:Number = Interpolation.InvLerp(param2,0,_loc6_);
         if(_loc6_ == 0)
         {
            _loc7_ = 0;
         }
         if(param3 != -1 && param4 != -1)
         {
            _loc7_ = Interpolation.Lerp(_loc7_,param3,param4);
            return this.totalPoints * _loc7_;
         }
         var _loc8_:Number = _loc7_ * _loc5_;
         return _loc5_ * param1 + _loc8_;
      }
      
      public function GetAdjustedMeterValueFromTotalPoints(param1:int) : Number
      {
         var _loc2_:int = this.CalculateRank(param1);
         var _loc3_:int = param1 - this.GetStartingPointsForRank(_loc2_);
         return this.GetAdjustedMeterValue(_loc2_,_loc3_);
      }
      
      public function GetPointsInRankFromTotalPoints(param1:int) : Number
      {
         var _loc2_:int = this.CalculateRank(param1);
         return param1 - this.GetStartingPointsForRank(_loc2_);
      }
   }
}

