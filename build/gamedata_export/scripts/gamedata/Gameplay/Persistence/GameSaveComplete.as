package gamedata.Gameplay.Persistence
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class GameSaveComplete extends OlympusObject
   {
      
      public static const SUCCESS:uint = 0;
      
      public static const FAILED_ON_COOLDOWN:uint = 1;
      
      public static const FAILED_EXCEPTION_OCCURRED:uint = 2;
      
      public static const FAILED_SAVE_LOCKED:uint = 3;
      
      public static const FAILED_STORAGE_FULL:uint = 4;
      
      public static const DO_NOT_EXIT:uint = 0;
      
      public static const JUST_EXIT:uint = 1;
      
      public static const EXIT_ON_SAVE_SUCCESS:uint = 2;
      
      public static const JUST_RESTART:uint = 3;
      
      public static const RESTART_ON_SAVE_SUCCESS:uint = 4;
      
      public var return_status:uint;
      
      public var slot_id:int;
      
      public var save_cooldown:Number = 0;
      
      public var failure_reason:LocKey = new LocKey();
      
      public function GameSaveComplete(param1:Object = null)
      {
         super(param1);
      }
   }
}

