package gamedata.BuildBuy.shared
{
   import gamedata.BuildBuy.constants.ProductTypes;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysBB;
   import olympus.localization.LocKey;
   
   public class SearchResult extends OlympusObject
   {
      
      public var resKey:ResourceKey = new ResourceKey();
      
      public var productType:int = 2;
      
      public var locKey:LocKey = new LocKey();
      
      public var categoryTag:uint = 0;
      
      public var categoryLocKey:LocKey = new LocKey();
      
      public var functionTag:uint = 0;
      
      public var devString:String = "";
      
      public var productTypeOverride:int = 0;
      
      public var floorPlacementLocationOverride:int = 2;
      
      public function SearchResult(param1:Object = null)
      {
         super(param1);
      }
      
      public function ToSearchFilter() : ProductFilter
      {
         var _loc1_:ProductFilter = new ProductFilter();
         if(this.categoryTag)
         {
            _loc1_.categoryTags = [this.categoryTag];
         }
         _loc1_.productType = this.productType >= ProductTypes.count ? ProductTypes.OBJECT : this.productType;
         return _loc1_;
      }
      
      public function ToString() : String
      {
         if(this.devString)
         {
            return KeysBB.BB_FILTER_SEARCH_OPEN_RESULT.toString(this.devString);
         }
         if(!this.categoryLocKey.IsValid() || this.categoryTag == 0)
         {
            return this.locKey.toString();
         }
         return KeysBB.BB_FILTER_SEARCH_RESULT.toString(this.locKey.toString(),this.categoryLocKey.toString());
      }
   }
}

