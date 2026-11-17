package widgets.shared.data
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class PreferenceItem extends OlympusObject
   {
      
      protected static var sPreferenceItems:Vector.<PreferenceItem>;
      
      public var item_id:String;
      
      public var category_id:String;
      
      public var liked_trait_id:String;
      
      public var disliked_trait_id:String;
      
      public var tooltip:LocKey = new LocKey();
      
      protected var cached_sorting_name:String;
      
      public function PreferenceItem(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAllPreferenceItems() : Vector.<PreferenceItem>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sPreferenceItems)
         {
            _loc1_ = CommunicationManager.CallGameService("GetPreferenceItems") as Array;
            sPreferenceItems = new Vector.<PreferenceItem>(_loc1_.length,true);
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sPreferenceItems[_loc3_] = new PreferenceItem(_loc1_[_loc3_]);
               _loc3_++;
            }
            sPreferenceItems.sort(Compare);
         }
         return sPreferenceItems;
      }
      
      public static function GetLikedDislikedTraidIdsForCategory(param1:String, param2:Array) : Object
      {
         var _loc6_:PreferenceItem = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Vector.<PreferenceItem> = GetAllPreferenceItems();
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.category_id == param1)
            {
               if(param2.indexOf(_loc6_.liked_trait_id) != -1)
               {
                  _loc3_.push(_loc6_.liked_trait_id);
               }
               if(param2.indexOf(_loc6_.disliked_trait_id) != -1)
               {
                  _loc4_.push(_loc6_.disliked_trait_id);
               }
            }
         }
         return {
            "likes":_loc3_,
            "dislikes":_loc4_
         };
      }
      
      public static function GetAllCASPreferenceItems() : Array
      {
         var _loc1_:Array = CommunicationManager.CallGameService("CasGetPreferenceItemsForSim") as Array;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(_loc1_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(new PreferenceItem(_loc1_[_loc4_]));
            _loc4_++;
         }
         _loc2_.sort(Compare);
         return _loc2_;
      }
      
      protected static function Compare(param1:PreferenceItem, param2:PreferenceItem) : int
      {
         var _loc3_:String = param1.GetSortingName();
         var _loc4_:String = param2.GetSortingName();
         return _loc3_.localeCompare(_loc4_);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.tooltip.IsValid())
         {
            this.tooltip = null;
         }
      }
      
      public function GetSortingName() : String
      {
         var _loc1_:TraitsStaticData = null;
         if(!this.cached_sorting_name)
         {
            _loc1_ = TraitsStaticData.GetStaticData(this.liked_trait_id);
            this.cached_sorting_name = _loc1_.GetDescriptionLocKeyBySimIdToken(null).toString();
         }
         return this.cached_sorting_name;
      }
   }
}

