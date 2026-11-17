package gamedata.Gameplay.RetailSummary
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class RetailSummaryDialog extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var subtitle:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public var hours_open:uint;
      
      public var line_items:Array = [RetailSummaryLineItem];
      
      public var total_amount:int;
      
      public function RetailSummaryDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.line_items);
      }
   }
}

