package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class EndOfWorkdayPromotion extends OlympusObject
   {
      
      public var text:LocKey = new LocKey();
      
      public var career:CareerInfo = new CareerInfo();
      
      public function EndOfWorkdayPromotion(param1:Object = null)
      {
         super(param1);
      }
   }
}

