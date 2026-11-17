package widgets.BuildBuy.events
{
   import flash.events.Event;
   import gamedata.BuildBuy.shared.CatalogProduct;
   
   public class CatalogEvent extends Event
   {
      
      public static const SELL_CLICK:String = "sellClick";
      
      public static const INVENTORY_ITEM_SELECTED:String = "inventoryItemSelected";
      
      public static const SWATCH_SELECTED:String = "swatchSelected";
      
      public static const VARIATION_SELECTED:String = "variationSelected";
      
      public static const STACK_SELECTED:String = "stackSelected";
      
      public var product:CatalogProduct;
      
      public var stateIndex:int;
      
      public function CatalogEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:CatalogProduct = null, param5:int = 0)
      {
         super(param1,param2,param3);
         this.product = param4;
         this.stateIndex = param5;
      }
      
      override public function clone() : Event
      {
         return new CatalogEvent(type,bubbles,cancelable,this.product,this.stateIndex);
      }
      
      override public function toString() : String
      {
         return formatToString("CatalogEvent","type","bubbles","cancelable","product","stateIndex");
      }
   }
}

