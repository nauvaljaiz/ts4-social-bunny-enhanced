package widgets.shared.data
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductGameplayInfo;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ColorSwatchData extends OlympusObject
   {
      
      public static const HUE_DEFAULT_VALUE:Number = 0;
      
      public static const OPACITY_DEFAULT_VALUE:Number = 1;
      
      public static const SATURATION_DEFAULT_VALUE:Number = 0;
      
      public static const VALUE_DEFAULT_VALUE:Number = 0;
      
      public var swatchUseFlags:uint;
      
      public var swatchColors:Array = [uint];
      
      public var dataID:String;
      
      public var icon:String;
      
      public var is_modded:Boolean = false;
      
      public var lockedTooltip:LocKey = new LocKey();
      
      public var productBB:CatalogProduct = new CatalogProduct(null);
      
      public var opacity_range_modifier:Number = 1;
      
      public var opacity_range_min:Number;
      
      public var opacity_range_max:Number;
      
      public var opacity_range_step:Number;
      
      public var hue_range_modifier:Number = 0;
      
      public var hue_range_min:Number;
      
      public var hue_range_max:Number;
      
      public var hue_range_step:Number;
      
      public var saturation_range_modifier:Number = 0;
      
      public var saturation_range_min:Number;
      
      public var saturation_range_max:Number;
      
      public var saturation_range_step:Number;
      
      public var value_range_modifier:Number = 0;
      
      public var value_range_min:Number;
      
      public var value_range_max:Number;
      
      public var value_range_step:Number;
      
      public function ColorSwatchData(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.productBB.gameplayInfo = [ProductGameplayInfo];
         super.ParseObject(param1);
         if(param1["productBB"] == null)
         {
            this.productBB = null;
         }
      }
      
      public function IsLocked() : Boolean
      {
         return this.lockedTooltip.IsValid();
      }
      
      public function IsCustomColor() : Boolean
      {
         return this.hue_range_modifier != HUE_DEFAULT_VALUE || this.opacity_range_modifier != OPACITY_DEFAULT_VALUE || this.saturation_range_modifier != SATURATION_DEFAULT_VALUE || this.value_range_modifier != VALUE_DEFAULT_VALUE;
      }
      
      public function IsSameColor(param1:ColorSwatchData) : Boolean
      {
         return param1.dataID == this.dataID && param1.hue_range_modifier == this.hue_range_modifier && param1.opacity_range_modifier == this.opacity_range_modifier && param1.saturation_range_modifier == this.saturation_range_modifier && param1.value_range_modifier == this.value_range_modifier;
      }
   }
}

