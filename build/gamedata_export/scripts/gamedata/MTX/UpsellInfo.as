package gamedata.MTX
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UpsellInfo extends OlympusObject
   {
      
      public var productId:String;
      
      public var productName:LocKey = new LocKey();
      
      public var upsellId:String;
      
      public var upsellName:LocKey = new LocKey();
      
      public var upsellDescription:LocKey = new LocKey();
      
      public var upsellPiwUrl:String;
      
      public var price:Number = 0;
      
      public var discountPrice:Number = 0;
      
      public var offerId:String;
      
      protected var mbAccepted:Boolean;
      
      public function UpsellInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public function get Accepted() : Boolean
      {
         return this.mbAccepted;
      }
      
      public function set Accepted(param1:Boolean) : void
      {
         this.mbAccepted = param1;
      }
      
      public function get IsDiscounted() : Boolean
      {
         return this.discountPrice < this.price;
      }
      
      public function get DiscountPercent() : int
      {
         return (this.price - this.discountPrice) / this.price * 100;
      }
   }
}

