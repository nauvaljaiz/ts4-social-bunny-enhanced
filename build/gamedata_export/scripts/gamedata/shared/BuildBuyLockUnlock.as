package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BuildBuyLockUnlock extends OlympusObject
   {
      
      public var build_buy_locked:Boolean = false;
      
      public var reason:LocKey = new LocKey();
      
      public function BuildBuyLockUnlock(param1:Object = null)
      {
         super(param1);
         if(!param1 || !("reason" in param1))
         {
            this.reason = null;
         }
      }
   }
}

