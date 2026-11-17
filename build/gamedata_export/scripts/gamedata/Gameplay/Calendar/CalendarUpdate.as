package gamedata.Gameplay.Calendar
{
   import olympus.core.OlympusObject;
   
   public final class CalendarUpdate extends OlympusObject
   {
      
      public static const TYPE_ADD:uint = 0;
      
      public static const TYPE_REMOVE:uint = 1;
      
      public static const TYPE_UPDATE:uint = 2;
      
      public var update_type:uint;
      
      public var updated_entry:CalendarEntry = new CalendarEntry();
      
      public function CalendarUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

