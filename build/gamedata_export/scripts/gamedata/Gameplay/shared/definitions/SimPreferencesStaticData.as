package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import widgets.shared.data.PreferenceItem;
   
   public class SimPreferencesStaticData extends OlympusObject
   {
      
      protected static var sPreferenceData:SimPreferencesStaticData;
      
      public var casPreferenceMoleculeEmptyTooltip:LocKey = new LocKey();
      
      public var decoratorCareerPreferenceCategories:Array = [ResourceKey];
      
      public var maxPreferenceWarning:LocKey = new LocKey();
      
      public var preferenceCapacity:int;
      
      public var preferenceSimPanelEmpty:LocKey = new LocKey();
      
      public var randomizeDiagText:LocKey = new LocKey();
      
      public var randomizeDiagTitle:LocKey = new LocKey();
      
      public var randomizeDiagTooltip:LocKey = new LocKey();
      
      public var casPreferencesCategoryTabIcon:ResourceKey = new ResourceKey();
      
      public var casPreferencesCategoryTabIconSelected:ResourceKey = new ResourceKey();
      
      public var casPreferencesCategoryTabTooltip:LocKey = new LocKey();
      
      public var preferenceGroups:Array = [PreferenceGroup];
      
      protected var mGroupByTraitIdCache:Object;
      
      protected var mGroupByIdCache:Object;
      
      protected var mValidGroupsCache:Vector.<PreferenceGroup>;
      
      protected var mGroupByPreferenceItemIdCache:Object;
      
      protected var mGroupByCategoryIdCache:Object;
      
      public function SimPreferencesStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : SimPreferencesStaticData
      {
         if(!sPreferenceData)
         {
            sPreferenceData = new SimPreferencesStaticData(CommunicationManager.CallGameService("GetPreferenceTuning"));
         }
         return sPreferenceData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.decoratorCareerPreferenceCategories);
         FixupArray(this.preferenceGroups);
      }
      
      protected function GetGroupByIdCache() : Object
      {
         var _loc1_:PreferenceGroup = null;
         if(!this.mGroupByIdCache)
         {
            this.mGroupByIdCache = new Object();
            for each(_loc1_ in this.preferenceGroups)
            {
               this.mGroupByIdCache[_loc1_.group_id] = _loc1_;
            }
         }
         return this.mGroupByIdCache;
      }
      
      protected function GetGroupByTraitIdCache() : Object
      {
         var _loc1_:PreferenceGroup = null;
         var _loc2_:PreferenceCategory = null;
         var _loc3_:Vector.<PreferenceItem> = null;
         var _loc4_:PreferenceItem = null;
         if(!this.mGroupByTraitIdCache)
         {
            this.mGroupByTraitIdCache = new Object();
            for each(_loc1_ in this.preferenceGroups)
            {
               for each(_loc2_ in _loc1_.categories)
               {
                  _loc3_ = _loc2_.GetAllItemsInCategory();
                  for each(_loc4_ in _loc3_)
                  {
                     this.mGroupByTraitIdCache[_loc4_.liked_trait_id] = _loc1_.group_id;
                     this.mGroupByTraitIdCache[_loc4_.disliked_trait_id] = _loc1_.group_id;
                  }
               }
            }
         }
         return this.mGroupByTraitIdCache;
      }
      
      protected function GetGroupByPreferenceItemIdCache() : Object
      {
         var _loc1_:PreferenceGroup = null;
         var _loc2_:PreferenceCategory = null;
         var _loc3_:Vector.<PreferenceItem> = null;
         var _loc4_:PreferenceItem = null;
         if(!this.mGroupByPreferenceItemIdCache)
         {
            this.mGroupByPreferenceItemIdCache = new Object();
            for each(_loc1_ in this.preferenceGroups)
            {
               for each(_loc2_ in _loc1_.categories)
               {
                  _loc3_ = _loc2_.GetAllItemsInCategory();
                  for each(_loc4_ in _loc3_)
                  {
                     this.mGroupByPreferenceItemIdCache[_loc4_.item_id] = _loc1_.group_id;
                  }
               }
            }
         }
         return this.mGroupByPreferenceItemIdCache;
      }
      
      protected function GetGroupByCategoryIdCache() : Object
      {
         var _loc1_:PreferenceGroup = null;
         var _loc2_:PreferenceCategory = null;
         if(!this.mGroupByCategoryIdCache)
         {
            this.mGroupByCategoryIdCache = new Object();
            for each(_loc1_ in this.preferenceGroups)
            {
               for each(_loc2_ in _loc1_.categories)
               {
                  this.mGroupByCategoryIdCache[_loc2_.category_id] = _loc1_.group_id;
               }
            }
         }
         return this.mGroupByCategoryIdCache;
      }
      
      public function InvalidateValidForSimCaches() : void
      {
         var _loc1_:PreferenceGroup = null;
         this.mValidGroupsCache = null;
         for each(_loc1_ in this.preferenceGroups)
         {
            if(_loc1_ != null)
            {
               _loc1_.InvalidateValidForSimCaches();
            }
         }
      }
      
      public function TryGetGroupById(param1:int) : PreferenceGroup
      {
         var _loc2_:* = this.GetGroupByIdCache();
         if(Boolean(_loc2_) && param1 in _loc2_)
         {
            return _loc2_[param1];
         }
         return null;
      }
      
      public function GetValidGroups() : Vector.<PreferenceGroup>
      {
         var _loc1_:PreferenceGroup = null;
         if(!this.mValidGroupsCache)
         {
            this.mValidGroupsCache = new Vector.<PreferenceGroup>();
            for each(_loc1_ in this.preferenceGroups)
            {
               if(_loc1_.IsValid())
               {
                  this.mValidGroupsCache.push(_loc1_);
               }
            }
         }
         return this.mValidGroupsCache;
      }
      
      public function TryGetGroupByTraitId(param1:String) : PreferenceGroup
      {
         var _loc2_:Object = this.GetGroupByTraitIdCache();
         if(Boolean(_loc2_) && param1 in _loc2_)
         {
            return this.TryGetGroupById(_loc2_[param1]);
         }
         return null;
      }
      
      public function TryGetGroupByPreferenceItemId(param1:String) : PreferenceGroup
      {
         var _loc2_:* = this.GetGroupByPreferenceItemIdCache();
         if(Boolean(_loc2_) && param1 in _loc2_)
         {
            return this.TryGetGroupById(_loc2_[param1]);
         }
         return null;
      }
      
      public function TryGetGroupByCategoryId(param1:String) : PreferenceGroup
      {
         var _loc2_:* = this.GetGroupByCategoryIdCache();
         if(Boolean(_loc2_) && param1 in _loc2_)
         {
            return this.TryGetGroupById(_loc2_[param1]);
         }
         return null;
      }
   }
}

