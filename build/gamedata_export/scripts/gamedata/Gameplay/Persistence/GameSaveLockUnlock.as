package gamedata.Gameplay.Persistence
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class GameSaveLockUnlock extends OlympusObject
   {
      
      public var is_locked:Boolean;
      
      public var lock_reason:LocKey = new LocKey();
      
      public var mbLockGallery:Boolean = true;
      
      public function GameSaveLockUnlock(param1:Object = null)
      {
         super(param1);
      }
   }
}

