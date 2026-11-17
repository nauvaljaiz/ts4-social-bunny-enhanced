package widgets.CAS.events
{
   import flash.events.Event;
   
   public class CASCatalogEvent extends Event
   {
      
      public static const SWATCH_SELECTED:String = "swatchSelected";
      
      public static const VARIATION_SELECTED:String = "variationSelected";
      
      public static const VARIATION_ROLL_OVER:String = "variationRollOver";
      
      public static const VARIATION_ROLL_OUT:String = "variationRollOut";
      
      public static const TOGGLE_VARIATION_GRID:String = "toggleVariationGrid";
      
      public static const REMOVE_BUTTON_CLICKED:String = "casCatalogRemoveButtonClicked";
      
      public var baseProductId:String;
      
      public var variationProductId:String;
      
      public var isSelected:Boolean;
      
      public function CASCatalogEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:String = null, param5:String = null, param6:Boolean = false)
      {
         super(param1,param2,param3);
         this.baseProductId = param4;
         this.variationProductId = param5;
         this.isSelected = param6;
      }
      
      override public function clone() : Event
      {
         return new CASCatalogEvent(type,bubbles,cancelable,this.baseProductId,this.variationProductId,this.isSelected);
      }
      
      override public function toString() : String
      {
         return formatToString("CatalogEvent","type","bubbles","cancelable","baseProductId","variationProductId","isSelected");
      }
   }
}

