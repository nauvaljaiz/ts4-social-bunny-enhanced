package gamedata.Gameplay.BalanceSystem.StaticData
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class BalanceSystemStaticData extends OlympusObject
   {
      
      protected static var sBalanceSystemStaticData:BalanceSystemStaticData = null;
      
      public var balance_max_value:Number;
      
      public var balance_min_value:Number;
      
      public var balance_system_commodity:String;
      
      public var major_imbalance_min_value:Number;
      
      public var minor_imbalance_min_value:Number;
      
      public var balance_system_descriptions:Array = [BalanceSystemDescriptionData];
      
      public function BalanceSystemStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : BalanceSystemStaticData
      {
         if(!sBalanceSystemStaticData)
         {
            sBalanceSystemStaticData = new BalanceSystemStaticData(CommunicationManager.CallGameService("GetBalanceSystemStaticData"));
         }
         return sBalanceSystemStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.balance_system_descriptions);
      }
   }
}

