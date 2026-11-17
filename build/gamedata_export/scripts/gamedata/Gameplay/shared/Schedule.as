package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.ScheduleEntryStaticData;
   import olympus.core.OlympusObject;
   import olympus.core.Time;
   import olympus.math.TimeSpan;
   
   public class Schedule extends OlympusObject
   {
      
      public var schedule_entries:Array = [ScheduleEntry];
      
      public function Schedule(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.schedule_entries);
      }
      
      public function ConvertToScheduleEntryStaticData() : Array
      {
         var _loc2_:ScheduleEntry = null;
         var _loc3_:ScheduleEntryStaticData = null;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.schedule_entries)
         {
            _loc3_ = new ScheduleEntryStaticData();
            _loc3_.hour = _loc2_.start_hour;
            _loc3_.minute = _loc2_.start_minute;
            _loc3_.duration = _loc2_.duration;
            _loc3_.schedule_shift_type = _loc2_.schedule_shift_type;
            _loc3_.multi_day_start_day = _loc2_.multi_day_start_day;
            _loc3_.multi_day_end_day = _loc2_.multi_day_end_day;
            for each(_loc4_ in _loc2_.days)
            {
               switch(_loc4_)
               {
                  case 0:
                     _loc3_.days.sunday = true;
                     break;
                  case 1:
                     _loc3_.days.monday = true;
                     break;
                  case 2:
                     _loc3_.days.tuesday = true;
                     break;
                  case 3:
                     _loc3_.days.wednesday = true;
                     break;
                  case 4:
                     _loc3_.days.thursday = true;
                     break;
                  case 5:
                     _loc3_.days.friday = true;
                     break;
                  case 6:
                     _loc3_.days.saturday = true;
               }
            }
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function GetWorkDays(param1:int = 0) : Array
      {
         var _loc3_:ScheduleEntry = null;
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.schedule_entries)
         {
            if(_loc3_.schedule_shift_type == param1)
            {
               for each(_loc4_ in _loc3_.days)
               {
                  if(_loc2_.indexOf(_loc4_) < 0)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
            }
         }
         _loc2_.sort();
         return _loc2_;
      }
      
      public function GetNextScheduledTimes(param1:int = 0) : Object
      {
         var _loc2_:TimeSpan = null;
         var _loc4_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc2_ = Time.GetGameTime();
         var _loc3_:uint = _loc2_.DayOfWeek % 7;
         _loc4_ = this.GetNextDayInSchedule(_loc3_,param1);
         var _loc5_:uint = Number(_loc4_.schedule.duration % 1) * 60;
         if(Boolean(_loc4_) && _loc4_.days == 0)
         {
            _loc6_ = int(_loc4_.schedule.hour);
            _loc7_ = int(_loc4_.schedule.minute);
            _loc10_ = _loc6_ + uint(_loc4_.schedule.duration);
            _loc11_ = _loc6_ + _loc7_ + _loc5_;
            if(_loc2_.Hours > _loc10_ || _loc2_.Hours == _loc10_ && _loc2_.Minutes > _loc11_)
            {
               _loc4_ = this.GetNextDayInSchedule((_loc3_ + 1) % 7,param1);
               _loc4_.days += 1;
            }
         }
         if(!_loc4_)
         {
            return null;
         }
         _loc6_ = int(_loc4_.schedule.hour);
         _loc7_ = int(_loc4_.schedule.minute);
         var _loc8_:TimeSpan = new TimeSpan(0,0,_loc7_,_loc6_,_loc2_.Days + _loc4_.days,_loc2_.Months,_loc2_.Years);
         var _loc9_:TimeSpan = new TimeSpan(0,0,_loc7_ + _loc5_,_loc6_ + uint(_loc4_.schedule.duration),_loc2_.Days + _loc4_.days,_loc2_.Months,_loc2_.Years);
         return {
            "startTime":_loc8_,
            "endTime":_loc9_
         };
      }
      
      public function GetNextDayInSchedule(param1:int, param2:int = 0, param3:Boolean = false) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:int = param1;
         var _loc6_:ScheduleEntryStaticData = null;
         while(true)
         {
            _loc6_ = this.GetDaysScheduleEntry(_loc5_,param2);
            if(_loc6_)
            {
               if(!param3)
               {
                  break;
               }
               param3 = false;
            }
            _loc5_ = (_loc5_ + 1) % 7;
            _loc4_++;
            if(_loc5_ == param1)
            {
               return null;
            }
         }
         return {
            "schedule":_loc6_,
            "days":_loc4_
         };
      }
      
      protected function GetDaysScheduleEntry(param1:int, param2:int = 0) : ScheduleEntryStaticData
      {
         var _loc3_:Array = null;
         var _loc4_:ScheduleEntryStaticData = null;
         if(this.GetWorkDays(param2).indexOf(param1) != -1)
         {
            if(param2 == ScheduleEntry.SCHEDULESHIFT_ALL_DAY || param2 == ScheduleEntry.SCHEDULESHIFT_TWENTY_FOUR_HOURS)
            {
               return this.ConvertToScheduleEntryStaticData()[0];
            }
            _loc3_ = this.ConvertToScheduleEntryStaticData();
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.schedule_shift_type == param2)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
   }
}

