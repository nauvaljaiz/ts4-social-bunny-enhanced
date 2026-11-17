package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import widgets.shared.data.PreferenceItem;
   
   public class PreferenceCategory extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var category_id:String;
      
      protected var mValidItemsCache:Vector.<PreferenceItem>;
      
      protected var mAllItemsCache:Vector.<PreferenceItem>;
      
      public function PreferenceCategory(param1:Object = null)
      {
         super(param1);
      }
      
      public function InvalidateValidForSimCaches() : void
      {
         this.mValidItemsCache = null;
      }
      
      public function GetAllItemsInCategory() : Vector.<PreferenceItem>
      {
         var _loc1_:Vector.<PreferenceItem> = null;
         var _loc2_:PreferenceItem = null;
         if(!this.mAllItemsCache)
         {
            _loc1_ = PreferenceItem.GetAllPreferenceItems();
            this.mAllItemsCache = new Vector.<PreferenceItem>();
            for each(_loc2_ in _loc1_)
            {
               if(Boolean(_loc2_) && _loc2_.category_id == this.category_id)
               {
                  this.mAllItemsCache.push(_loc2_);
               }
            }
         }
         return this.mAllItemsCache;
      }
      
      public function GetValidItemsInCategory() : Vector.<PreferenceItem>
      {
         var _loc1_:Array = null;
         var _loc2_:PreferenceItem = null;
         if(!this.mValidItemsCache)
         {
            _loc1_ = PreferenceItem.GetAllCASPreferenceItems();
            this.mValidItemsCache = new Vector.<PreferenceItem>();
            for each(_loc2_ in _loc1_)
            {
               if(Boolean(_loc2_) && _loc2_.category_id == this.category_id)
               {
                  this.mValidItemsCache.push(_loc2_);
               }
            }
         }
         return this.mValidItemsCache;
      }
      
      public function IsValid() : Boolean
      {
         return this.GetValidItemsInCategory().length > 0;
      }
   }
}

