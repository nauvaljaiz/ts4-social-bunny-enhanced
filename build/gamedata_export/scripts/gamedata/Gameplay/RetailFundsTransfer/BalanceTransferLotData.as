package gamedata.Gameplay.RetailFundsTransfer
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BalanceTransferLotData extends OlympusObject
   {
      
      public var lot_name:LocKey = new LocKey();
      
      public var zone_id:String;
      
      public var balance:int;
      
      public function BalanceTransferLotData(param1:Object = null)
      {
         super(param1);
      }
   }
}

