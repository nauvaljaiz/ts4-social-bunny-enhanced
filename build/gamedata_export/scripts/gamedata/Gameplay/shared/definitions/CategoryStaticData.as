package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CategoryStaticData extends OlympusObject
   {
      
      protected static var sCategories:Array;
      
      public var name:LocKey = new LocKey();
      
      public var ui_sort_order:int;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var is_sim_info_panel:Boolean;
      
      public var uid:uint;
      
      public function CategoryStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get CATEGORIES() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sCategories)
         {
            _loc1_ = CommunicationManager.CallGameService("GetAspirationCategoryStaticData",null,false) as Array;
            if(!_loc1_)
            {
               return null;
            }
            _loc2_ = int(_loc1_.length);
            sCategories = new Array(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sCategories[_loc3_] = new CategoryStaticData(_loc1_[_loc3_]);
               _loc3_++;
            }
            sCategories.sortOn("ui_sort_order",Array.NUMERIC);
         }
         return sCategories;
      }
      
      public static function GetCategoryData(param1:uint) : CategoryStaticData
      {
         var _loc5_:CategoryStaticData = null;
         var _loc2_:Array = CATEGORIES;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_] as CategoryStaticData;
            if(_loc5_.uid == param1)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("icon" in param1))
         {
            this.icon = null;
         }
      }
   }
}

