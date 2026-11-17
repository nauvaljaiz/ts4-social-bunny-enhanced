package gamedata.Gameplay.RetailSummary
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RetailSummaryLineItem extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var item_type:LocKey = new LocKey();
      
      public var value:int;
      
      public function RetailSummaryLineItem(param1:Object = null)
      {
         super(param1);
      }
   }
}

