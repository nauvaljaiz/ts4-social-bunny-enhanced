package gamedata.MTX
{
   import olympus.core.OlympusObject;
   
   public class BundlePurchaseData extends OlympusObject
   {
      
      public var discountPricePercent:String;
      
      public var discountVCPricePercent:String;
      
      public var originalPrice:String;
      
      public var currentPrice:String;
      
      public var currentVCPrice:String;
      
      public var originalVCPrice:String;
      
      public var vcQuantity:String;
      
      public var isFree:Boolean = false;
      
      public var isPriceDiscounted:Boolean = false;
      
      public var isVCPriceDiscounted:Boolean = false;
      
      public var isPreorder:Boolean = false;
      
      public var isPurchasable:Boolean = true;
      
      public var isTrial:Boolean = false;
      
      public var trialStatus:int = MTXBundleData.TRIAL_STATUS_NONE;
      
      public var vcOfferProductId:String;
      
      public function BundlePurchaseData(param1:Object = null)
      {
         super(param1);
      }
      
      public function get DiscountPercent() : String
      {
         if(this.originalPrice != null && this.originalPrice != "")
         {
            return this.discountPricePercent;
         }
         return this.discountVCPricePercent;
      }
      
      public function get IsSequentialDataValid() : Boolean
      {
         return this.originalPrice != null && this.originalPrice != "" && this.originalVCPrice != null && this.originalVCPrice != "";
      }
      
      public function GetDiscountStateForTelemetry() : Boolean
      {
         if(this.currentVCPrice != null && this.currentVCPrice != "")
         {
            return this.isVCPriceDiscounted;
         }
         return this.isPriceDiscounted;
      }
   }
}

