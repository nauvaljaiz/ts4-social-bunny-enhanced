package gamedata.Gameplay.SimInfoHUD
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class DevelopmentalMilestoneStaticData extends OlympusObject
   {
      
      protected static var sDevelopmentalMilestoneList:Vector.<DevelopmentalMilestoneStaticData>;
      
      public var developmental_milestone_id:int;
      
      public var ages:Array = [uint];
      
      public var category:int;
      
      public var is_primary_milestone:Boolean;
      
      public var hint_text:LocKey = new LocKey();
      
      public var name:LocKey = new LocKey();
      
      public var ui_sort_order:int;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var unlocked_text:LocKey = new LocKey();
      
      public var unlocked_text_no_context:LocKey = new LocKey();
      
      public var unlocked_text_target_sim_header:LocKey = new LocKey();
      
      public var revealable_name:LocKey = new LocKey();
      
      public function DevelopmentalMilestoneStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function DevelopmentalMilestoneSortingFunction(param1:DevelopmentalMilestoneStaticData, param2:DevelopmentalMilestoneStaticData) : Number
      {
         return param1.ui_sort_order - param2.ui_sort_order;
      }
      
      public static function get DevelopmentalMilestoneList() : Vector.<DevelopmentalMilestoneStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<DevelopmentalMilestoneStaticData> = null;
         var _loc4_:int = 0;
         if(!sDevelopmentalMilestoneList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetDevelopmentalMilestonesData") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               _loc3_ = new Vector.<DevelopmentalMilestoneStaticData>(_loc2_,true);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_[_loc4_] = new DevelopmentalMilestoneStaticData(_loc1_[_loc4_]);
                  _loc4_++;
               }
               _loc3_.sort(DevelopmentalMilestoneSortingFunction);
               sDevelopmentalMilestoneList = _loc3_;
            }
         }
         return sDevelopmentalMilestoneList;
      }
      
      public static function GetDevelopmentalMilestoneById(param1:int) : DevelopmentalMilestoneStaticData
      {
         var _loc3_:DevelopmentalMilestoneStaticData = null;
         var _loc2_:Vector.<DevelopmentalMilestoneStaticData> = DevelopmentalMilestoneList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.developmental_milestone_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.hint_text = FixupLocKey(this.hint_text);
         this.name = FixupLocKey(this.name);
         this.unlocked_text = FixupLocKey(this.unlocked_text);
         this.unlocked_text_no_context = FixupLocKey(this.unlocked_text_no_context);
         this.unlocked_text_target_sim_header = FixupLocKey(this.unlocked_text_target_sim_header);
         this.revealable_name = FixupLocKey(this.revealable_name);
      }
   }
}

