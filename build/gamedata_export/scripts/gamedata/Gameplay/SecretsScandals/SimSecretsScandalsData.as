package gamedata.Gameplay.SecretsScandals
{
   import olympus.core.OlympusObject;
   
   public class SimSecretsScandalsData extends OlympusObject
   {
      
      public static const RELATIONSHIP_SECRET_STATUS_DISCOVERED:uint = 1;
      
      public static const RELATIONSHIP_SECRET_STATUS_PROMISED_TO_KEEP:uint = 2;
      
      public static const RELATIONSHIP_SECRET_STATUS_BLACKMAILED:uint = 3;
      
      public static const RELATIONSHIP_SECRET_STATUS_PRE_BLACKMAILED:uint = 4;
      
      public var secrets:Array = [SecretScandalDataSimpleData];
      
      public var scandals:Array = [SecretScandalDataSimpleData];
      
      public function SimSecretsScandalsData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.secrets);
         FixupArray(this.scandals);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

