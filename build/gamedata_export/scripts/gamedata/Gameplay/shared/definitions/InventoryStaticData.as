package gamedata.Gameplay.shared.definitions
{
   import gamedata.Gameplay.shared.InventoryFilterCategory;
   import gamedata.Gameplay.shared.InventoryFilterType;
   import gamedata.Gameplay.shared.InventorySortType;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGP;
   
   public class InventoryStaticData extends OlympusObject
   {
      
      protected static var sInventoryData:InventoryStaticData;
      
      public static const SORT_TYPE_NAME:int = 0;
      
      public static const SORT_TYPE_NEW:int = 1;
      
      public static const SORT_TYPE_PRICE:int = 2;
      
      public static const SORT_TYPE_FILTER_TYPE:int = 3;
      
      public static const SORT_TYPE_DYNAMIC_TYPE:int = 4;
      
      public static const MISC_FILTER:InventoryFilterType = new InventoryFilterType({
         "debugName":"MISC",
         "name":KeysGP.INVENTORY_MISC_FILTER_NAME,
         "tags":[]
      });
      
      public static const FAVORITES_FILTER:InventoryFilterType = new InventoryFilterType({
         "debugName":"FAVORITES",
         "name":KeysGP.INVENTORY_FAVORITES_FILTER_NAME,
         "tags":[]
      });
      
      public static const NEW_FILTER:InventoryFilterType = new InventoryFilterType({
         "debugName":"NEW",
         "name":KeysGP.INVENTORY_NEW_FILTER_NAME,
         "tags":[]
      });
      
      public var sortTypes:Array = [InventorySortType];
      
      public var filterCategories:Array = [InventoryFilterCategory];
      
      public var allFilterTags:Array = [uint];
      
      public var mAllFilterTypes:Array;
      
      public function InventoryStaticData(param1:Object = null)
      {
         super(param1);
         if(!param1)
         {
            FixupArray(this.sortTypes);
            FixupArray(this.filterCategories);
            FixupArray(this.allFilterTags);
         }
      }
      
      public static function GetStaticData() : InventoryStaticData
      {
         if(!sInventoryData)
         {
            sInventoryData = new InventoryStaticData(CommunicationManager.CallGameService("GetInventoryTuning"));
         }
         return sInventoryData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:InventoryFilterCategory = null;
         var _loc3_:InventoryFilterType = null;
         super.ParseObject(param1);
         FixupArray(this.sortTypes);
         FixupArray(this.filterCategories);
         FixupArray(this.allFilterTags);
         this.filterCategories.push(this.CreateSpecialCategoryFromFilter(MISC_FILTER));
         this.filterCategories.splice(0,0,this.CreateSpecialCategoryFromFilter(NEW_FILTER));
         this.filterCategories.splice(0,0,this.CreateSpecialCategoryFromFilter(FAVORITES_FILTER));
         this.mAllFilterTypes = new Array();
         for each(_loc2_ in this.filterCategories)
         {
            for each(_loc3_ in _loc2_.filters)
            {
               this.mAllFilterTypes.push(_loc3_);
            }
         }
      }
      
      protected function CreateSpecialCategoryFromFilter(param1:InventoryFilterType) : InventoryFilterCategory
      {
         var _loc2_:InventoryFilterCategory = new InventoryFilterCategory({"name":param1.name});
         _loc2_.filters = [param1];
         _loc2_.mbShowSingleFilter = true;
         return _loc2_;
      }
   }
}

