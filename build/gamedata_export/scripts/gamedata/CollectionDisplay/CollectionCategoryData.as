package gamedata.CollectionDisplay
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.shared.ICategoryData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CollectionCategoryData extends OlympusObject implements ICategoryData
   {
      
      public var collection_id:String;
      
      public var collection_name:LocKey = new LocKey();
      
      public var collection_tooltip:LocKey = new LocKey();
      
      public var collection_icon:ResourceKey = new ResourceKey();
      
      public var object_list:Array = [CollectionItemData];
      
      public var bonus_object_list:Array = [CollectionItemData];
      
      protected var mAllObjectList:Array;
      
      protected var mbSorted:Boolean = false;
      
      public function CollectionCategoryData(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function SortByRarity(param1:CollectionItemData, param2:CollectionItemData) : Number
      {
         var _loc3_:int = param1.rarity - param2.rarity;
         if(_loc3_ != 0)
         {
            return _loc3_;
         }
         return param1.ItemCollectionProduct.Name.localeCompare(param2.ItemCollectionProduct.Name);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:CollectionItemData = null;
         super.ParseObject(param1);
         FixupArray(this.object_list);
         FixupArray(this.bonus_object_list);
         for each(_loc2_ in this.bonus_object_list)
         {
            _loc2_.IsBonus = true;
         }
         this.mAllObjectList = this.object_list.concat(this.bonus_object_list);
      }
      
      public function GetIsNew() : Boolean
      {
         var _loc1_:CollectionItemData = null;
         for each(_loc1_ in this.mAllObjectList)
         {
            if(_loc1_.IsNew)
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetNumBonus() : int
      {
         var _loc2_:CollectionItemData = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.bonus_object_list)
         {
            if(_loc2_.IsFound)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function GetNumBase() : int
      {
         var _loc2_:CollectionItemData = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.object_list)
         {
            if(_loc2_.IsFound)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function GetIsCompleted() : Boolean
      {
         var _loc1_:CollectionItemData = null;
         for each(_loc1_ in this.object_list)
         {
            if(!_loc1_.IsFound)
            {
               return false;
            }
         }
         return true;
      }
      
      public function GetIsFound() : Boolean
      {
         var _loc1_:CollectionItemData = null;
         for each(_loc1_ in this.mAllObjectList)
         {
            if(_loc1_.IsFound)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get NumObjectsAvailable() : int
      {
         return this.ObjectList.length;
      }
      
      public function get NumBonusObjectsAvailable() : int
      {
         return this.bonus_object_list.length;
      }
      
      public function get CategoryName() : LocKey
      {
         return this.collection_name;
      }
      
      public function get CategoryTooltip() : LocKey
      {
         return this.collection_tooltip;
      }
      
      public function get CategoryIcon() : ResourceKey
      {
         return this.collection_icon;
      }
      
      public function get ObjectList() : Array
      {
         return this.object_list;
      }
      
      public function get AllObjectList() : Array
      {
         return this.mAllObjectList;
      }
      
      public function get AllObjectListSorted() : Array
      {
         if(!this.mbSorted)
         {
            this.mbSorted = true;
            this.object_list = this.object_list.sort(SortByRarity);
            this.bonus_object_list = this.bonus_object_list.sort(SortByRarity);
            this.mAllObjectList = this.object_list.concat(this.bonus_object_list);
         }
         return this.mAllObjectList;
      }
      
      public function get ItemCellView() : Class
      {
         return getDefinitionByName("widgets.Gameplay.CollectionDisplay.controls.CollectionItemCellView") as Class;
      }
      
      public function GetItemData(param1:String) : CollectionItemData
      {
         var _loc2_:CollectionItemData = null;
         if(this.object_list != null)
         {
            for each(_loc2_ in this.mAllObjectList)
            {
               if(_loc2_.definition_id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
   }
}

