package gamedata.Gameplay.BalanceSystem.StaticData
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BalanceSystemDescriptionData extends OlympusObject
   {
      
      public var buff_reference:String;
      
      public var buff_description:LocKey = new LocKey();
      
      public function BalanceSystemDescriptionData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.buff_description = FixupLocKey(this.buff_description);
      }
   }
}

