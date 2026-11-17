package gamedata.Gameplay.shared
{
   import gamedata.GameEntry.shared.RegionDescription;
   import gamedata.Gameplay.SimInfoHUD.DevelopmentalMilestoneStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class DevelopmentalMilestoneData extends OlympusObject
   {
      
      public static const MILESTONE_STATE_ACTIVE:uint = 0;
      
      public static const MILESTONE_STATE_UNLOCKED:uint = 1;
      
      public var sim_id:String;
      
      public var developmental_milestone_id:uint;
      
      public var state:uint;
      
      public var new_in_ui:Boolean;
      
      public var unlocked_with_sim_id:String;
      
      public var unlocked_with_object_name:LocKey = new LocKey();
      
      public var unlocked_in_lot_name:String;
      
      public var unlocked_in_region_id:String;
      
      public var unlocked_career_name:LocKey = new LocKey();
      
      public var unlocked_career_level:LocKey = new LocKey();
      
      public var unlocked_death_type:LocKey = new LocKey();
      
      public var unlocked_trait_name:LocKey = new LocKey();
      
      public var unlocked_small_business_name:String;
      
      public var unlocked_dynasty_name:String;
      
      public var goal_id:uint;
      
      public var completed_time:uint;
      
      public var age_completed:uint;
      
      public var mStaticData:DevelopmentalMilestoneStaticData;
      
      public function DevelopmentalMilestoneData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetTooltipDescriptionText(param1:DevelopmentalMilestoneData) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:RegionDescription = null;
         var _loc10_:LocKey = null;
         if(param1.state == DevelopmentalMilestoneData.MILESTONE_STATE_UNLOCKED)
         {
            _loc2_ = null;
            if(param1.unlocked_with_sim_id != null)
            {
               _loc2_ = {"simId":param1.unlocked_with_sim_id};
            }
            _loc3_ = null;
            if(param1.unlocked_with_object_name != null)
            {
               _loc3_ = {
                  "type":LocKey.TOKEN_TYPE_OBJECT,
                  "catalog_name_key":param1.unlocked_with_object_name.hash
               };
            }
            _loc4_ = null;
            if(param1.unlocked_in_region_id != null)
            {
               _loc9_ = RegionDescription.GetRegionDescription(param1.unlocked_in_region_id);
               _loc10_ = _loc9_.regionName;
               if((Boolean(_loc10_)) && _loc10_.IsValid())
               {
                  _loc4_ = _loc10_.toString();
               }
            }
            _loc5_ = null;
            if(param1.unlocked_career_name != null)
            {
               _loc5_ = param1.unlocked_career_name.toString();
            }
            _loc6_ = null;
            if(param1.unlocked_career_level != null)
            {
               _loc6_ = param1.unlocked_career_level.toString();
            }
            _loc7_ = null;
            if(param1.unlocked_death_type != null)
            {
               _loc7_ = param1.unlocked_death_type.toString();
            }
            _loc8_ = null;
            if(param1.unlocked_trait_name != null)
            {
               _loc8_ = param1.unlocked_trait_name.toString();
            }
            if(param1.StaticData.unlocked_text_no_context != null && _loc2_ == null && _loc3_ == null && param1.unlocked_in_lot_name == null && _loc4_ == null && _loc5_.length == 0 && _loc6_.length == 0 && _loc7_.length == 0 && _loc8_.length == 0 && param1.unlocked_small_business_name == null && param1.unlocked_dynasty_name == null)
            {
               return param1.StaticData.unlocked_text_no_context.toString(GameplayStateData.ActiveSimToken);
            }
            if(param1.StaticData.unlocked_text != null)
            {
               return param1.StaticData.unlocked_text.toString(GameplayStateData.ActiveSimToken,_loc2_,_loc3_,param1.unlocked_in_lot_name,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,param1.unlocked_small_business_name,param1.unlocked_dynasty_name);
            }
         }
         else if(param1.StaticData.hint_text != null)
         {
            return param1.StaticData.hint_text.toString(GameplayStateData.ActiveSimToken);
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.unlocked_with_object_name = FixupLocKey(this.unlocked_with_object_name);
      }
      
      public function get StaticData() : DevelopmentalMilestoneStaticData
      {
         if(!this.mStaticData && Boolean(this.developmental_milestone_id))
         {
            this.mStaticData = DevelopmentalMilestoneStaticData.GetDevelopmentalMilestoneById(this.developmental_milestone_id);
         }
         return this.mStaticData;
      }
   }
}

