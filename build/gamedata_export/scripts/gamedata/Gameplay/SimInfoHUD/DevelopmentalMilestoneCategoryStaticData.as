package gamedata.Gameplay.SimInfoHUD
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class DevelopmentalMilestoneCategoryStaticData extends OlympusObject
   {
      
      protected static var sDevelopmentalMilestoneCategoryList:Vector.<DevelopmentalMilestoneCategoryStaticData>;
      
      public var ages:Array = [uint];
      
      public var developmental_milestone_category_id:int;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var sim_info_panel_default_icon:ResourceKey = new ResourceKey();
      
      public var sim_info_panel_over_icon:ResourceKey = new ResourceKey();
      
      public function DevelopmentalMilestoneCategoryStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function DevelopmentalMilestoneCategorySortingFunction(param1:DevelopmentalMilestoneCategoryStaticData, param2:DevelopmentalMilestoneCategoryStaticData) : Number
      {
         return param1.developmental_milestone_category_id - param2.developmental_milestone_category_id;
      }
      
      public static function get DevelopmentalMilestoneCategoryList() : Vector.<DevelopmentalMilestoneCategoryStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<DevelopmentalMilestoneCategoryStaticData> = null;
         var _loc4_:int = 0;
         if(!sDevelopmentalMilestoneCategoryList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetDevelopmentalMilestoneCategoryData") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               _loc3_ = new Vector.<DevelopmentalMilestoneCategoryStaticData>(_loc2_,true);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_[_loc4_] = new DevelopmentalMilestoneCategoryStaticData(_loc1_[_loc4_]);
                  _loc4_++;
               }
               _loc3_.sort(DevelopmentalMilestoneCategorySortingFunction);
               sDevelopmentalMilestoneCategoryList = _loc3_;
            }
         }
         return sDevelopmentalMilestoneCategoryList;
      }
      
      public static function GetDevelopmentalMilestoneCategoryById(param1:int) : DevelopmentalMilestoneCategoryStaticData
      {
         var _loc3_:DevelopmentalMilestoneCategoryStaticData = null;
         var _loc2_:Vector.<DevelopmentalMilestoneCategoryStaticData> = DevelopmentalMilestoneCategoryList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.developmental_milestone_category_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.tooltip = FixupLocKey(this.tooltip);
      }
   }
}

