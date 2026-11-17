package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class SendActiveHolidayInfo extends OlympusObject
   {
      
      public static const HOLIDAY_UPDATE_TYPE_START:uint = 0;
      
      public static const HOLIDAY_UPDATE_TYPE_UPDATE:uint = 1;
      
      public static const HOLIDAY_UPDATE_TYPE_END:uint = 2;
      
      public var update_type:uint;
      
      public var holiday_info:HolidayInfo = new HolidayInfo();
      
      public function SendActiveHolidayInfo(param1:Object = null)
      {
         super(param1);
      }
   }
}

