package gamedata.BuildBuy.shared
{
   import gamedata.BuildBuy.constants.FilterCategories;
   import gamedata.BuildBuy.constants.ProductTypes;
   import olympus.core.OlympusObject;
   import olympus.utils.TuningTagsUtils;
   
   public class ProductFilter extends OlympusObject
   {
      
      public static const WALL_CURVE_FLAT:int = 0;
      
      public static const WALL_CURVE_CURVED:int = 1;
      
      public static const WALL_CURVE_CURVED_SMALL:int = 2;
      
      public var productType:int = 2;
      
      public var secondaryProductType:int = -1;
      
      public var navMode:int = 0;
      
      public var categoryTags:Array = [uint];
      
      public var categoryPriorityTags:Array = [uint];
      
      public var specialTags:Array = [uint];
      
      public var styleResourceKeys:Array = [Object];
      
      public var colorTags:Array = [uint];
      
      public var wallHeightRequired:int;
      
      public var filterByGameplayUnlocks:Boolean;
      
      public var filterPurchasedProducts:Boolean;
      
      public var filterModdedContent:Boolean;
      
      public var filterHiddenObjects:Boolean;
      
      public var packIds:Array = new Array();
      
      public var filterUGC:Boolean;
      
      public var searchResult:SearchResult = null;
      
      public var placementMode:int = 0;
      
      public var floorPlacementLocation:int = 2;
      
      public function ProductFilter(param1:Object = null)
      {
         super(param1);
         FixupArray(this.styleResourceKeys);
         FixupArray(this.colorTags);
         FixupArray(this.categoryTags);
         FixupArray(this.categoryPriorityTags);
         FixupArray(this.specialTags);
      }
      
      public function get IsWallPattern() : Boolean
      {
         return this.productType == ProductTypes.WALL_PATTERN;
      }
      
      public function get IsFloorPattern() : Boolean
      {
         return this.productType == ProductTypes.FLOOR_PATTERN;
      }
      
      public function get IsCeilingPattern() : Boolean
      {
         return this.productType == ProductTypes.CEILING_PATTERN;
      }
      
      public function get IsWaterStyles() : Boolean
      {
         return this.productType == ProductTypes.FLOOR_PATTERN && (this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BUILD_WATER_STYLES)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_FUNCTION_WATER_STYLES)) > -1);
      }
      
      public function get IsBuildWindow() : Boolean
      {
         return this.productType == ProductTypes.OBJECT && (this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_WINDOW)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_WINDOW_CURVED)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_WINDOW_CURVED_SMALL)) > -1);
      }
      
      public function get IsBuildDoor() : Boolean
      {
         return this.productType == ProductTypes.OBJECT && (this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_DOOR)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_DOOR_CURVED)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_DOOR_CURVED_SMALL)) > -1);
      }
      
      public function get WallCurve() : int
      {
         if(this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_WINDOW_CURVED)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_DOOR_CURVED)) > -1)
         {
            return WALL_CURVE_CURVED;
         }
         if(this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_WINDOW_CURVED_SMALL)) > -1 || this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_DOOR_CURVED_SMALL)) > -1)
         {
            return WALL_CURVE_CURVED_SMALL;
         }
         return WALL_CURVE_FLAT;
      }
      
      public function get IsBed() : Boolean
      {
         return this.productType == ProductTypes.OBJECT && this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_SS_BED)) > -1;
      }
      
      public function get IsSofa() : Boolean
      {
         return this.productType == ProductTypes.OBJECT && this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_SS_SOFA)) > -1;
      }
      
      public function get IsBuildWall() : Boolean
      {
         return this.productType == ProductTypes.WALL || this.productType == ProductTypes.BLOCK && this.categoryTags.indexOf(TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_WALLTOOL)) > -1;
      }
      
      public function get IsFloorTrim() : Boolean
      {
         return this.productType == ProductTypes.FLOOR_TRIM;
      }
      
      public function get IsFrieze() : Boolean
      {
         return this.productType == ProductTypes.FRIEZE;
      }
      
      public function get IsHeightWallRestricted() : Boolean
      {
         return this.IsBuildWindow || this.IsBuildDoor || this.IsFrieze;
      }
      
      public function get IsHeightBlockLevelRestricted() : Boolean
      {
         return this.IsFloorTrim;
      }
      
      public function get SearchCategoryTags() : Array
      {
         if(Boolean(this.searchResult) && TuningTagsUtils.GetGroup(FilterCategories.SEARCHGROUP_IN_FILTERBAR).indexOf(this.searchResult.categoryTag) > -1)
         {
            return [this.searchResult.categoryTag];
         }
         return this.categoryTags;
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["productType"] = this.productType;
         _loc1_["styleResourceKeys"] = this.styleResourceKeys;
         _loc1_["colorTags"] = this.colorTags;
         _loc1_["specialTags"] = this.specialTags;
         _loc1_["categoryPriorityTags"] = this.categoryPriorityTags;
         _loc1_["wallHeightRequired"] = this.wallHeightRequired;
         _loc1_["filterByGameplayUnlocks"] = this.filterByGameplayUnlocks;
         _loc1_["filterModdedContent"] = this.filterModdedContent;
         _loc1_["filterPurchasedProducts"] = this.filterPurchasedProducts;
         _loc1_["filterHiddenObjects"] = this.filterHiddenObjects;
         _loc1_["packIds"] = this.packIds;
         _loc1_["filterUGC"] = this.filterUGC;
         _loc1_["packFlags"] = 0;
         if(this.searchResult)
         {
            if(this.searchResult.functionTag)
            {
               _loc1_["categoryTags"] = this.categoryTags;
               _loc1_["functionTag"] = this.searchResult.functionTag;
            }
            else
            {
               _loc1_["categoryTags"] = this.SearchCategoryTags;
            }
            if(this.searchResult.productTypeOverride)
            {
               _loc1_["productType"] = this.searchResult.productTypeOverride;
            }
            _loc1_["searchText"] = this.searchResult.devString;
         }
         else
         {
            _loc1_["categoryTags"] = this.categoryTags;
         }
         return _loc1_;
      }
      
      public function Clone() : ProductFilter
      {
         var _loc1_:ProductFilter = new ProductFilter();
         _loc1_.productType = this.productType;
         _loc1_.secondaryProductType = this.secondaryProductType;
         _loc1_.styleResourceKeys = this.styleResourceKeys;
         _loc1_.colorTags = this.colorTags;
         _loc1_.categoryTags = this.categoryTags;
         _loc1_.categoryPriorityTags = this.categoryPriorityTags;
         _loc1_.specialTags = this.specialTags;
         _loc1_.wallHeightRequired = this.wallHeightRequired;
         _loc1_.searchResult = this.searchResult;
         _loc1_.filterByGameplayUnlocks = this.filterByGameplayUnlocks;
         _loc1_.filterPurchasedProducts = this.filterPurchasedProducts;
         _loc1_.filterModdedContent = this.filterModdedContent;
         _loc1_.filterHiddenObjects = this.filterHiddenObjects;
         _loc1_.packIds = this.packIds;
         _loc1_.filterUGC = this.filterUGC;
         _loc1_.placementMode = this.placementMode;
         _loc1_.floorPlacementLocation = this.floorPlacementLocation;
         return _loc1_;
      }
   }
}

