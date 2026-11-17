package gamedata.Gameplay.Calendar
{
   import olympus.controls.objects.MenuItem;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.utils.ObjectUtils;
   
   public class CalendarFilterData extends OlympusObject
   {
      
      protected static var sActiveEntryFilters:Object;
      
      protected static var sActiveRegionLockedEntryFilters:Object;
      
      protected static var sbBirthdayFilterActive:Boolean = true;
      
      protected static var sbWorkFilterActive:Boolean = true;
      
      protected static var sbFavoriteFilterActive:Boolean = false;
      
      protected static var sbAnyFilterActive:Boolean = false;
      
      public var filter_name:LocKey = new LocKey();
      
      public var entry_types:Array = new Array(uint);
      
      public var is_birthday_filter:Boolean;
      
      public var is_work_filter:Boolean;
      
      public var is_favorite_filter:Boolean;
      
      public var region_resource:String;
      
      public var required_packs:Array = new Array(uint);
      
      public function CalendarFilterData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function SetActiveFilters(param1:Array) : void
      {
         var _loc2_:CalendarFilterData = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         sActiveEntryFilters = new Object();
         sActiveRegionLockedEntryFilters = new Object();
         sbBirthdayFilterActive = false;
         sbWorkFilterActive = false;
         sbFavoriteFilterActive = false;
         sbAnyFilterActive = false;
         for each(_loc3_ in param1)
         {
            _loc2_ = (_loc3_ is MenuItem ? _loc3_.data : _loc3_) as CalendarFilterData;
            if(_loc2_.is_birthday_filter)
            {
               sbBirthdayFilterActive = true;
               sbAnyFilterActive = true;
            }
            if(_loc2_.is_work_filter)
            {
               sbWorkFilterActive = true;
               sbAnyFilterActive = true;
            }
            if(_loc2_.is_favorite_filter)
            {
               sbFavoriteFilterActive = true;
               sbAnyFilterActive = true;
            }
            if(_loc2_.region_resource)
            {
               _loc4_ = sActiveRegionLockedEntryFilters[_loc2_.region_resource];
               if(!_loc4_)
               {
                  _loc4_ = new Array();
                  sActiveRegionLockedEntryFilters[_loc2_.region_resource] = _loc4_;
               }
               for each(_loc5_ in _loc2_.entry_types)
               {
                  _loc4_.push(_loc5_);
                  sbAnyFilterActive = true;
               }
            }
            else
            {
               for each(_loc5_ in _loc2_.entry_types)
               {
                  sActiveEntryFilters[_loc5_] = true;
                  sbAnyFilterActive = true;
               }
            }
         }
      }
      
      public static function IsEventTypeFilterActive(param1:uint, param2:String = null) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         if(ObjectUtils.IsEmpty(sActiveEntryFilters) && ObjectUtils.IsEmpty(sActiveRegionLockedEntryFilters))
         {
            return !sbAnyFilterActive;
         }
         if(param1 in sActiveEntryFilters)
         {
            return sActiveEntryFilters[param1];
         }
         if(Boolean(param2) && param2 in sActiveRegionLockedEntryFilters)
         {
            _loc3_ = sActiveRegionLockedEntryFilters[param2] as Array;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function IsBirthdayFilterActive() : Boolean
      {
         return sbBirthdayFilterActive || !sbAnyFilterActive;
      }
      
      public static function IsWorkFilterActive() : Boolean
      {
         return sbWorkFilterActive || !sbAnyFilterActive;
      }
      
      public static function IsFavoriteFilterActive() : Boolean
      {
         return sbFavoriteFilterActive || !sbAnyFilterActive;
      }
      
      public static function IsAnyFilterActive() : Boolean
      {
         return sbAnyFilterActive;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.entry_types);
         FixupArray(this.required_packs);
      }
      
      public function GetAsMenuItem() : MenuItem
      {
         return new MenuItem(this.filter_name.toString(),this);
      }
   }
}

