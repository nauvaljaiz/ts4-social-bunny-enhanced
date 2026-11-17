package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RankedStatisticBucksPerkInfo extends OlympusObject
   {
      
      public var type:uint;
      
      public var perk_removal_tooltip:LocKey;
      
      public var bucks_title:LocKey;
      
      public var bucks_tooltip:LocKey;
      
      public var perk_currency_label:LocKey;
      
      public function RankedStatisticBucksPerkInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         if("type" in param1)
         {
            this.type = param1["type"];
         }
         if("perk_removal_tooltip" in param1)
         {
            this.perk_removal_tooltip = new LocKey(param1["perk_removal_tooltip"]);
         }
         if("bucks_title" in param1)
         {
            this.bucks_title = new LocKey(param1["bucks_title"]);
         }
         if("bucks_tooltip" in param1)
         {
            this.bucks_tooltip = new LocKey(param1["bucks_tooltip"]);
         }
         if("perk_currency_label" in param1)
         {
            this.perk_currency_label = new LocKey(param1["perk_currency_label"]);
         }
      }
   }
}

