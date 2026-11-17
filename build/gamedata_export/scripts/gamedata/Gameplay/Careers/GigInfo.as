package gamedata.Gameplay.Careers
{
   import gamedata.BuildBuy.Venues.VenueObjectInfo;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.ObjectiveInfo;
   import gamedata.Gameplay.shared.definitions.AspirationBasicStaticData;
   import gamedata.Gameplay.shared.definitions.CareerBuildBuyInfo;
   import gamedata.Gameplay.shared.definitions.CareerStaticData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysBB;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import widgets.BuildBuy.VenueConfiguration.controls.IHasVenueRequirementsData;
   import widgets.BuildBuy.VenueConfiguration.controls.VenueRequirementsData;
   
   public final class GigInfo extends OlympusObject implements IHasVenueRequirementsData
   {
      
      public static const CAREER_PANEL_INDEX:int = 0;
      
      public static const CAREER_TOOLTIP_INDEX:int = 1;
      
      protected static const TOP_FLOOR_VALUE:int = 999;
      
      protected static const BOTTOM_FLOOR_VALUE:int = -999;
      
      public var gig_type:String;
      
      public var gig_name:LocKey;
      
      public var gig_time:String;
      
      public var gig_icon:ResourceKey;
      
      public var min_pay:uint;
      
      public var max_pay:uint;
      
      public var audition_time:String;
      
      public var gig_description:LocKey;
      
      public var aspiration_id:String;
      
      public var aspiration:AspirationBasicStaticData;
      
      public var customer_id:String;
      
      public var tip_title:LocKey;
      
      public var tip_icon:IconInfo;
      
      public var additional_objectives:Array;
      
      public var career_panel_info_text:LocKey;
      
      public var client_preferences:Array;
      
      public var known_client_preferences:Array;
      
      public var client_hh_name:String;
      
      public var client_lot_id:uint;
      
      public var budget_spent:uint;
      
      public var gig_budget:uint;
      
      public var use_level_restriction:Boolean;
      
      public var level_restriction:int;
      
      public var tile_restriction:int;
      
      public var career_id:String;
      
      public var gig_end_time:String;
      
      public var hide_inactive_objectives:Boolean;
      
      public var gig_uid:String;
      
      public var chained_objectives:Array;
      
      protected var tiles_added:int;
      
      protected var mCareerStaticData:CareerStaticData;
      
      protected var mObjectiveIndex:Array;
      
      public function GigInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.gig_type = param1.gig_type;
         this.gig_time = param1.gig_time;
         this.min_pay = param1.min_pay;
         this.max_pay = param1.max_pay;
         this.audition_time = param1.audition_time;
         this.aspiration_id = param1.aspiration_id;
         this.customer_id = param1.customer_id;
         this.client_hh_name = param1.client_hh_name;
         this.client_lot_id = param1.client_lot_id;
         this.budget_spent = param1.budget_spent;
         this.gig_budget = param1.gig_budget;
         this.use_level_restriction = param1.use_level_restriction;
         this.level_restriction = param1.level_restriction;
         this.tile_restriction = param1.tile_restriction;
         this.gig_end_time = param1.gig_end_time;
         this.gig_uid = param1.gig_uid;
         if("gig_name" in param1)
         {
            this.gig_name = new LocKey(param1.gig_name);
         }
         if("gig_icon" in param1)
         {
            this.gig_icon = new ResourceKey(param1.gig_icon);
         }
         if("gig_description" in param1)
         {
            this.gig_description = new LocKey(param1.gig_description);
         }
         if("aspiration" in param1)
         {
            this.aspiration = new AspirationBasicStaticData(param1.aspiration);
         }
         if("tip_title" in param1)
         {
            this.tip_title = new LocKey(param1.tip_title);
         }
         if("tip_icon" in param1)
         {
            this.tip_icon = new IconInfo(param1.tip_icon);
         }
         if("career_panel_info_text" in param1)
         {
            this.career_panel_info_text = new LocKey(param1.career_panel_info_text);
         }
         if("additional_objectives" in param1)
         {
            this.additional_objectives = new Array();
            ConstructArrayFromArray(this.additional_objectives,param1.additional_objectives,String);
         }
         if("client_preferences" in param1)
         {
            this.client_preferences = new Array();
            ConstructArrayFromArray(this.client_preferences,param1.client_preferences,String);
         }
         if("known_client_preferences" in param1)
         {
            this.known_client_preferences = new Array();
            ConstructArrayFromArray(this.known_client_preferences,param1.known_client_preferences,String);
         }
         if("career_id" in param1)
         {
            this.career_id = param1.career_id;
            this.mCareerStaticData = CareerStaticData.GetStaticData(this.career_id);
         }
         if("chained_objectives" in param1)
         {
            this.chained_objectives = new Array();
            for each(_loc2_ in param1.chained_objectives)
            {
               if("objectives" in _loc2_)
               {
                  _loc3_ = new Array();
                  ConstructArrayFromArray(_loc3_,_loc2_.objectives,String);
                  this.chained_objectives.push(_loc3_);
               }
            }
         }
         if(this.chained_objectives)
         {
            this.mObjectiveIndex = new Array();
            _loc4_ = 0;
            while(_loc4_ < this.chained_objectives.length)
            {
               _loc5_ = this.FindFirstIncompleteObjectiveIndex(_loc4_);
               this.mObjectiveIndex.push([_loc5_,_loc5_]);
               _loc4_++;
            }
         }
      }
      
      public function get TagKey() : String
      {
         return this.gig_type;
      }
      
      public function HasBBRequirements() : Boolean
      {
         return this.use_level_restriction || this.tile_restriction >= 0;
      }
      
      public function GetObjectiveIds() : Array
      {
         if(this.aspiration == null)
         {
            return this.additional_objectives;
         }
         return this.aspiration.objectiveUids.concat(this.additional_objectives);
      }
      
      public function GetBuildBuyInfo() : CareerBuildBuyInfo
      {
         if(this.mCareerStaticData)
         {
            return this.mCareerStaticData.build_buy_info;
         }
         return null;
      }
      
      public function GetRequirementsData(param1:Object) : VenueRequirementsData
      {
         var _loc4_:VenueObjectInfo = null;
         var _loc5_:VenueObjectInfo = null;
         var _loc2_:VenueRequirementsData = new VenueRequirementsData();
         var _loc3_:GigInfo = BuildBuyStateData.GetGigInfo(true);
         if(_loc3_)
         {
            _loc2_.IsFulfilled = _loc2_.IsLotFulfilled = true;
            if(_loc3_.tile_restriction >= 0)
            {
               if(Boolean(param1) && "gigTileChange" in param1)
               {
                  this.tiles_added = param1["gigTileChange"];
               }
               _loc4_ = new VenueObjectInfo({
                  "tooltipOverride":KeysBB.BB_VENUES_RESTRICTED_TOOLTIP,
                  "current":this.tiles_added,
                  "min":0,
                  "max":_loc3_.tile_restriction,
                  "requiredType":VenueObjectInfo.VOT_REQUIRED_MAX
               },false);
               _loc4_.filtersBB = false;
            }
            if(_loc3_.use_level_restriction)
            {
               _loc5_ = new VenueObjectInfo({
                  "nameKey":this.GetRestrictedFloorLocKey(_loc3_.level_restriction),
                  "tooltipOverride":KeysBB.BB_VENUES_RESTRICTED_TOOLTIP,
                  "showProgress":false,
                  "enabled":false
               },false);
            }
            if(!_loc4_)
            {
               _loc2_.RestrictionList.push(_loc5_);
               return _loc2_;
            }
            if(_loc3_.tile_restriction == 0)
            {
               _loc4_.nameKey = KeysBB.BB_VENUES_TILE_RESTRICTION_NO_TILES;
               _loc4_.showProgress = false;
               _loc4_.enabled = false;
               _loc2_.RestrictionList.push(_loc4_);
               if(_loc5_)
               {
                  _loc2_.RestrictionList.push(_loc5_);
               }
            }
            else
            {
               _loc4_.nameKey = KeysBB.BB_VENUES_TILE_RESTRICTION;
               _loc4_.enabled = true;
               _loc2_.RequiredObjectList.push(_loc4_);
               if(_loc5_)
               {
                  _loc2_.RequiredObjectList.push(_loc5_);
               }
            }
         }
         return _loc2_;
      }
      
      protected function GetRestrictedFloorLocKey(param1:int) : LocKey
      {
         switch(param1)
         {
            case 0:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_0;
            case 1:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_1;
            case 2:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_2;
            case 3:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_3;
            case -1:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_B1;
            case -2:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_B2;
            case -3:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_B3;
            case -4:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_B4;
            case TOP_FLOOR_VALUE:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_TOP;
            case BOTTOM_FLOOR_VALUE:
               return KeysBB.BB_VENUE_GIG_INFO_PANEL_FLOOR_RESTRICTION_BOTTOM;
            default:
               return null;
         }
      }
      
      private function FindFirstIncompleteObjectiveIndex(param1:int) : int
      {
         var _loc3_:ObjectiveInfo = null;
         var _loc2_:int = 0;
         for each(_loc3_ in GameplayStateData.GetAspirationObjectiveInfos(this.chained_objectives[param1]))
         {
            if(!_loc3_.IsComplete)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc2_ - 1;
      }
      
      public function HasObjectiveId(param1:String, param2:int) : Boolean
      {
         return this.chained_objectives[param2].indexOf(param1) >= 0;
      }
      
      public function GetChainedObjectiveIds(param1:int, param2:int, param3:Boolean) : Array
      {
         var _loc7_:ObjectiveInfo = null;
         var _loc4_:int = int(this.mObjectiveIndex[param1][param2]);
         if(_loc4_ < 0)
         {
            return [];
         }
         var _loc5_:Array = this.chained_objectives[param1];
         var _loc6_:Array = _loc5_.slice(_loc4_);
         if(_loc6_.length <= 1)
         {
            return _loc6_;
         }
         if(param3)
         {
            if(GameplayStateData.GetAspirationObjectiveInfos([_loc6_[0]])[0].IsComplete)
            {
               _loc4_++;
            }
         }
         else
         {
            for each(_loc7_ in GameplayStateData.GetAspirationObjectiveInfos(_loc6_))
            {
               if(!_loc7_.IsComplete)
               {
                  break;
               }
               _loc4_++;
            }
            _loc4_ = Math.min(_loc4_,_loc5_.length - 1);
            _loc6_ = _loc5_.slice(_loc4_);
         }
         this.mObjectiveIndex[param1][param2] = _loc4_;
         return _loc6_;
      }
   }
}

