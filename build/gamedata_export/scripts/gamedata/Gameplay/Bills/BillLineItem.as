package gamedata.Gameplay.Bills
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class BillLineItem extends OlympusObject
   {
      
      public var amount:int;
      
      public var label:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function BillLineItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.label.IsValid())
         {
            this.label = null;
         }
         if(!this.tooltip.IsValid())
         {
            this.tooltip = null;
         }
      }
   }
}

