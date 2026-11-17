package olympus.core
{
   import gamedata.shared.GameClockTime;
   import olympus.io.CommunicationManager;
   import olympus.math.TimeSpan;
   
   public class Time
   {
      
      protected static var sGameClockTime:GameClockTime;
      
      protected static var sCurrentTime:TimeSpan;
      
      public static const GAME_SINGLE_PLAYER_PAUSE:String = "GAME_SINGLE_PLAYER_PAUSE";
      
      public function Time()
      {
         super();
      }
      
      public static function get mGameSpeed() : Number
      {
         return sGameClockTime.gameSpeed;
      }
      
      public static function get mTimeRatio() : Number
      {
         return sGameClockTime.ratio;
      }
      
      public static function get mClockSpeed() : int
      {
         return sGameClockTime.clockSpeed;
      }
      
      public static function get mSunrise() : Number
      {
         return sGameClockTime.sunrise;
      }
      
      public static function get mSunset() : Number
      {
         return sGameClockTime.sunset;
      }
      
      public static function get mSuperSpeed() : Boolean
      {
         return sGameClockTime.superSpeed;
      }
      
      public static function get Paused() : Boolean
      {
         return mGameSpeed == 0;
      }
      
      public static function ConvertToSimTime(param1:uint) : uint
      {
         return param1 * mTimeRatio;
      }
      
      public static function ConvertUsingGameSpeed(param1:uint, param2:Boolean = true) : uint
      {
         if(param2 || mGameSpeed > 0)
         {
            param1 *= mGameSpeed;
         }
         return param1;
      }
      
      public static function ConvertToSimTimeUsingGameSpeed(param1:uint, param2:Boolean = true) : uint
      {
         if(param2 || mGameSpeed > 0)
         {
            param1 *= mGameSpeed;
         }
         return param1 * mTimeRatio;
      }
      
      public static function GetGameTime() : TimeSpan
      {
         if(!sCurrentTime)
         {
            sCurrentTime = new TimeSpan(0,sGameClockTime.second,sGameClockTime.minute,sGameClockTime.hour,sGameClockTime.dayOfWeek);
         }
         return sCurrentTime;
      }
      
      public static function AddToGameTime(param1:uint, param2:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         var _loc3_:TimeSpan = GetGameTime();
         var _loc4_:uint = _loc3_.DayOfWeek;
         var _loc5_:uint = _loc3_.Hours;
         var _loc6_:Boolean = _loc3_.AddMilliseconds(param1,param2);
         _loc3_.Set(_loc3_.Milliseconds,_loc3_.Seconds,_loc3_.Minutes,_loc3_.Hours,_loc3_.Days % 7,_loc3_.Months,_loc3_.Years);
         sCurrentTime = _loc3_;
         var _loc7_:uint = _loc3_.DayOfWeek;
         var _loc8_:uint = _loc3_.Hours;
         if(_loc4_ != _loc7_)
         {
            CommunicationManager.SendUIMessage("TimeDayChanged",_loc7_);
         }
         if(_loc5_ != _loc8_)
         {
            CommunicationManager.SendUIMessage("TimeHourChanged",_loc8_);
         }
         return _loc6_;
      }
      
      public static function HandleUpdateGameClock(param1:GameClockTime) : void
      {
         var _loc2_:TimeSpan = GetGameTime();
         var _loc3_:uint = _loc2_.DayOfWeek;
         var _loc4_:uint = _loc2_.Hours;
         var _loc5_:Boolean = sGameClockTime.gameSpeed != param1.gameSpeed;
         var _loc6_:Boolean = sGameClockTime.gameSpeed == 0 || param1.gameSpeed == 0;
         sCurrentTime = null;
         sGameClockTime = param1;
         sCurrentTime = GetGameTime();
         var _loc7_:uint = sCurrentTime.DayOfWeek;
         var _loc8_:uint = sCurrentTime.Hours;
         if(_loc3_ != _loc7_)
         {
            CommunicationManager.SendUIMessage("TimeDayChanged",_loc7_);
         }
         if(_loc4_ != _loc8_)
         {
            CommunicationManager.SendUIMessage("TimeHourChanged",_loc8_);
         }
         if(_loc5_)
         {
            if(_loc6_)
            {
               CommunicationManager.SendUIMessage("PauseToggled");
            }
            CommunicationManager.SendUIMessage("GameSpeedChanged",null);
         }
      }
      
      public static function IsValid() : *
      {
         return sGameClockTime != null;
      }
      
      public static function RefreshGameClockTime() : void
      {
         sGameClockTime = new GameClockTime(CommunicationManager.CallGameService("GetGameClockTime",null));
      }
   }
}

