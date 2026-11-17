package widgets.Dialog.constants
{
   public final class GenericDialogOption
   {
      
      public static const DISABLE_CLOSE_BUTTON:uint = 1 << 0;
      
      public static const SMALL_TITLE:uint = 1 << 1;
      
      public static const PAUSE_WHEN_DIALOG_UP_IN_SINGLE_PLAYER:uint = 1 << 2;
      
      public static const DISABLE_PICKER_CLOSE_BUTTON:uint = 1 << 3;
      
      public static const VERTICAL_NOTIFICATION_BUTTONS:uint = 1 << 4;
      
      public static const MAX_OPTIONS:uint = 1 << 4;
      
      public function GenericDialogOption()
      {
         super();
      }
      
      public static function HasOption(param1:uint, param2:uint) : Boolean
      {
         if(param2 > MAX_OPTIONS)
         {
            return false;
         }
         return (param1 & param2) != 0;
      }
   }
}

