package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PreferenceGroup extends OlympusObject
   {
      
      public var ages:Array = [uint];
      
      public var capacity:int;
      
      public var categories:Array = [PreferenceCategory];
      
      public var counter_text:LocKey = new LocKey();
      
      public var detailed_description:LocKey = new LocKey();
      
      public var dislike_button_text:LocKey = new LocKey();
      
      public var header_name:LocKey = new LocKey();
      
      public var help_tooltip:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_selected:ResourceKey = new ResourceKey();
      
      public var items_name_negative:LocKey = new LocKey();
      
      public var items_name_negative_header_formatted:LocKey = new LocKey();
      
      public var items_name_positive:LocKey = new LocKey();
      
      public var items_name_positive_header_formatted:LocKey = new LocKey();
      
      public var like_button_text:LocKey = new LocKey();
      
      public var name:LocKey = new LocKey();
      
      public var none_selected_text:LocKey = new LocKey();
      
      public var group_id:int;
      
      public var timeline_label_name:String;
      
      public var show_flair:Boolean;
      
      protected var mValidCategoriesCache:Vector.<PreferenceCategory>;
      
      public function PreferenceGroup(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.categories);
         FixupArray(this.ages);
      }
      
      public function InvalidateValidForSimCaches() : void
      {
         var _loc1_:PreferenceCategory = null;
         this.mValidCategoriesCache = null;
         for each(_loc1_ in this.categories)
         {
            if(_loc1_ != null)
            {
               _loc1_.InvalidateValidForSimCaches();
            }
         }
      }
      
      public function GetValidCategories() : Vector.<PreferenceCategory>
      {
         var _loc1_:PreferenceCategory = null;
         if(!this.mValidCategoriesCache)
         {
            this.mValidCategoriesCache = new Vector.<PreferenceCategory>();
            for each(_loc1_ in this.categories)
            {
               if(_loc1_.IsValid())
               {
                  this.mValidCategoriesCache.push(_loc1_);
               }
            }
         }
         return this.mValidCategoriesCache;
      }
      
      public function IsValid() : Boolean
      {
         return this.GetValidCategories().length > 0;
      }
      
      public function TryGetValidCategoryById(param1:String) : PreferenceCategory
      {
         var _loc3_:PreferenceCategory = null;
         var _loc2_:Vector.<PreferenceCategory> = this.GetValidCategories();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.category_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function IsValidForAge(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in this.ages)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
   }
}

