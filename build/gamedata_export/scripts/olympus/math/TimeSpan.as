package olympus.math
{
   public class TimeSpan
   {
      
      public static const MILLISECONDS:int = 0;
      
      public static const SECONDS:int = 1;
      
      public static const MINUTES:int = 2;
      
      public static const HOURS:int = 3;
      
      public static const DAYS:int = 4;
      
      public static const MONTHS:int = 5;
      
      public static const YEARS:int = 6;
      
      protected var mMilliseconds:uint;
      
      protected var mSeconds:uint;
      
      protected var mMinutes:uint;
      
      protected var mHours:uint;
      
      protected var mDays:uint;
      
      protected var mMonths:uint;
      
      protected var mYears:uint;
      
      public function TimeSpan(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0)
      {
         super();
         this.Set(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function get Milliseconds() : uint
      {
         return this.mMilliseconds;
      }
      
      public function get Seconds() : uint
      {
         return this.mSeconds;
      }
      
      public function get Minutes() : uint
      {
         return this.mMinutes;
      }
      
      public function get Hours() : uint
      {
         return this.mHours;
      }
      
      public function get Days() : uint
      {
         return this.mDays;
      }
      
      public function get Months() : uint
      {
         return this.mMonths;
      }
      
      public function get Years() : uint
      {
         return this.mYears;
      }
      
      public function get DayOfWeek() : uint
      {
         var _loc1_:uint = this.mDays % 7;
         if(_loc1_ == 0)
         {
            _loc1_ = 7;
         }
         return _loc1_;
      }
      
      public function Set(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0) : void
      {
         if(param1 >= 1000)
         {
            param2 += param1 / 1000;
            param1 %= 1000;
         }
         if(param2 >= 60)
         {
            param3 += param2 / 60;
            param2 %= 60;
         }
         if(param3 >= 60)
         {
            param4 += param3 / 60;
            param3 %= 60;
         }
         if(param4 >= 24)
         {
            param5 += param4 / 24;
            param4 %= 24;
         }
         if(param6 > 12)
         {
            param7 += param6 / 12;
            param6 %= 12;
         }
         this.mMilliseconds = param1;
         this.mSeconds = param2;
         this.mMinutes = param3;
         this.mHours = param4;
         this.mDays = param5;
         this.mMonths = param6;
         this.mYears = param7;
      }
      
      public function Clone() : TimeSpan
      {
         return new TimeSpan(this.mMilliseconds,this.mSeconds,this.mMinutes,this.mHours,this.mDays,this.mMonths,this.mYears);
      }
      
      public function ToStringMilliseconds(param1:uint = 2) : String
      {
         var _loc2_:String = this.mMilliseconds.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringSeconds(param1:uint = 2) : String
      {
         var _loc2_:String = this.mSeconds.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringMinutes(param1:uint = 2) : String
      {
         var _loc2_:String = this.mMinutes.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringHours(param1:uint = 2) : String
      {
         var _loc2_:String = this.mHours.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringDays(param1:uint = 2) : String
      {
         var _loc2_:String = this.mDays.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringMonths(param1:uint = 2) : String
      {
         var _loc2_:String = this.mMonths.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function ToStringYears(param1:uint = 2) : String
      {
         var _loc2_:String = this.mYears.toString();
         while(_loc2_.length < param1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function SubtractMilliseconds(param1:uint) : Boolean
      {
         var _loc2_:int = this.mMilliseconds - param1;
         while(_loc2_ < 0)
         {
            if(this.mSeconds > 0)
            {
               --this.mSeconds;
               _loc2_ += 1000;
            }
            else if(this.mMinutes > 0)
            {
               --this.mMinutes;
               this.mSeconds = 60;
            }
            else if(this.mHours > 0)
            {
               --this.mHours;
               this.mMinutes = 60;
            }
            else
            {
               if(this.mDays <= 0)
               {
                  this.mMilliseconds = 0;
                  return false;
               }
               --this.mDays;
               this.mHours = 24;
            }
         }
         this.mMilliseconds = _loc2_;
         return true;
      }
      
      public function Subtract(param1:TimeSpan) : Boolean
      {
         var _loc2_:int = this.mMilliseconds - param1.Milliseconds;
         var _loc3_:* = int(this.mSeconds - param1.Seconds);
         var _loc4_:* = int(this.mMinutes - param1.Minutes);
         var _loc5_:* = int(this.mHours - param1.Hours);
         var _loc6_:* = int(this.mDays - param1.Days);
         if(_loc2_ < 0)
         {
            _loc3_--;
            _loc2_ += 1000;
         }
         if(_loc3_ < 0)
         {
            _loc4_--;
            _loc3_ += 60;
         }
         if(_loc4_ < 0)
         {
            _loc5_--;
            _loc4_ += 60;
         }
         if(_loc5_ < 0)
         {
            _loc6_--;
            _loc5_ += 24;
         }
         if(_loc6_ < 0)
         {
            this.mMilliseconds = 0;
            this.mSeconds = 0;
            this.mMinutes = 0;
            this.mHours = 0;
            this.mDays = 0;
            return false;
         }
         this.mMilliseconds = _loc2_;
         this.mSeconds = _loc3_;
         this.mMinutes = _loc4_;
         this.mHours = _loc5_;
         this.mDays = _loc6_;
         return true;
      }
      
      public function AddMilliseconds(param1:uint, param2:int = 0) : Boolean
      {
         param1 += this.mMilliseconds;
         var _loc3_:uint = this.mSeconds;
         var _loc4_:Boolean = false;
         if(param1 >= 1000)
         {
            _loc3_ += param1 / 1000;
            this.mMilliseconds = param1 % 1000;
            if(param2 == MILLISECONDS)
            {
               _loc4_ = true;
            }
            var _loc5_:uint = this.mMinutes;
            var _loc6_:uint = this.mHours;
            var _loc7_:uint = this.mDays;
            if(_loc3_ >= 60)
            {
               _loc5_ += _loc3_ / 60;
               this.mSeconds = _loc3_ % 60;
               if(param2 == SECONDS)
               {
                  _loc4_ = true;
               }
               if(_loc5_ >= 60)
               {
                  _loc6_ += _loc5_ / 60;
                  this.mMinutes = _loc5_ % 60;
                  if(param2 == MINUTES)
                  {
                     _loc4_ = true;
                  }
                  if(_loc6_ >= 24)
                  {
                     _loc7_ += _loc6_ / 24;
                     this.mHours = _loc6_ % 24;
                     if(param2 == HOURS)
                     {
                        _loc4_ = true;
                     }
                     this.mDays = _loc7_;
                     return _loc4_;
                  }
                  this.mHours = _loc6_;
                  return _loc4_;
               }
               this.mMinutes = _loc5_;
               return _loc4_;
            }
            this.mSeconds = _loc3_;
            return _loc4_;
         }
         this.mMilliseconds = param1;
         return _loc4_;
      }
      
      public function Add(param1:TimeSpan) : void
      {
         this.AddMilliseconds(param1.ConvertToMilliseconds());
      }
      
      public function ConvertToMilliseconds() : uint
      {
         var _loc1_:uint = this.mSeconds + this.ConvertToMinutes() * 60;
         return this.mMilliseconds + _loc1_ * 1000;
      }
      
      public function ConvertToMinutes(param1:Boolean = false) : uint
      {
         var _loc2_:uint = this.mHours + this.mDays * 24;
         var _loc3_:uint = this.mMinutes + _loc2_ * 60;
         if(param1)
         {
            if(this.mSeconds > 0 || this.mMilliseconds > 0)
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      public function toString() : String
      {
         return "[Y: " + this.ToStringYears() + ", M:" + this.ToStringMonths() + ", D: " + this.ToStringDays() + ", H: " + this.ToStringHours() + ", M: " + this.ToStringMinutes() + ", S: " + this.ToStringSeconds() + ", MS: " + this.ToStringMilliseconds() + "]";
      }
      
      public function toSaveString() : String
      {
         return this.ToStringYears() + "," + this.ToStringMonths() + "," + this.ToStringDays() + "," + this.ToStringHours() + "," + this.ToStringMinutes() + "," + this.ToStringSeconds() + "," + this.ToStringMilliseconds();
      }
   }
}

