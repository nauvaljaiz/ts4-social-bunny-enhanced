package gamedata.shared
{
   import olympus.core.OlympusObject;
   
   public class NotificationStaticData extends OlympusObject
   {
      
      public static const MINIMUM_WALL_TIME_MILLISECONDS:Number = 4000;
      
      protected static const WALL_TIME_MILLISECONDS_PER_CHARACTER:Number = 100;
      
      protected static const COLLAPSE_TIME_MILLISECONDS:Number = 5000;
      
      protected static var sNotificationStaticData:NotificationStaticData = null;
      
      public var send_to_wall_time_per_char:Number = 0;
      
      public var collapse_time:Number = 0;
      
      public function NotificationStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get STATIC_DATA() : NotificationStaticData
      {
         if(!sNotificationStaticData)
         {
            sNotificationStaticData = new NotificationStaticData({
               "send_to_wall_time_per_char":WALL_TIME_MILLISECONDS_PER_CHARACTER,
               "collapse_time":COLLAPSE_TIME_MILLISECONDS
            });
         }
         return sNotificationStaticData;
      }
   }
}

