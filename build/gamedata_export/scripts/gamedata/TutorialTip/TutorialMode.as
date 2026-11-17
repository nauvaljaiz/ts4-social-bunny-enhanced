package gamedata.TutorialTip
{
   import olympus.io.CommunicationManager;
   
   public final class TutorialMode
   {
      
      public static const DISABLED:int = 0;
      
      public static const STANDARD:int = 1;
      
      public static const FTUE:int = 2;
      
      public static function mGetTutorialMode():int
      {
         return DISABLED;
      }
      public function TutorialMode()
      {
         super();
      }
      
      public static function IsFTUE() : Boolean
      {
         if(!mGetTutorialMode)
         {
            return false;
         }
         return mGetTutorialMode() == FTUE;
      }
      
      public static function IsNotFTUE() : Boolean
      {
         return !IsFTUE();
      }
      
      public static function IsDisabled() : Boolean
      {
         return mGetTutorialMode() == DISABLED;
      }
      
      public static function IsFTUEDialogEnabled() : Boolean
      {
         var _loc1_:Boolean = CommunicationManager.CallGameService("GetFtueEnabled") as Boolean;
         if(!_loc1_)
         {
            return false;
         }
         return CommunicationManager.CallGameService("OptionsGetValue",{"name":"EnableFTUETutorialStart"}) == 1;
      }
   }
}

