package gamedata.Gameplay.Pickers
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class PurchasePickerRowData extends OlympusObject
   {
      
      public var base_data:PickerBaseRowData;
      
      public var def_id:String;
      
      public var num_owned:uint;
      
      public var num_available:int = -1;
      
      public var object_id:String;
      
      public var custom_price:int = -1;
      
      public var fashion_trend:LocKey;
      
      public var prediscounted_price:int = -1;
      
      public var is_discounted:Boolean;
      
      public var tag_list:Array;
      
      public var purchaseAmount:uint;
      
      public var showDescription:Boolean;
      
      public var showDescriptionTooltip:Boolean;
      
      public var showCost:Boolean;
      
      public var maxSelectableInRow:uint = 0;
      
      public var nameColumnWidth:Number;
      
      public var enableRow:Boolean = true;
      
      public var itemSelected:Boolean = false;
      
      public var mEnableIncrease:Boolean = true;
      
      protected var mCatalogProduct:CatalogProduct;
      
      public function PurchasePickerRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.base_data = new PickerBaseRowData(param1.base_data);
         this.def_id = param1.def_id;
         this.num_owned = param1.num_owned;
         this.tag_list = new Array();
         if(param1.tag_list != null)
         {
            ConstructArrayFromArray(this.tag_list,param1.tag_list,uint);
         }
         if("num_available" in param1)
         {
            this.num_available = param1.num_available;
         }
         if("object_id" in param1)
         {
            this.object_id = param1.object_id;
         }
         if("custom_price" in param1)
         {
            this.custom_price = param1.custom_price;
         }
         if("fashion_trend" in param1)
         {
            this.fashion_trend = LocKey.GetValidatedLocKey(param1.fashion_trend);
         }
         if("prediscounted_price" in param1)
         {
            this.prediscounted_price = param1.prediscounted_price;
         }
         if("is_discounted" in param1)
         {
            this.is_discounted = param1.is_discounted;
         }
         this.mCatalogProduct = new CatalogProduct(CommunicationManager.CallGameService("GetCatalogProduct",{"defId":this.def_id}));
      }
      
      public function get CatalogProductDefinition() : CatalogProduct
      {
         return this.mCatalogProduct;
      }
   }
}

