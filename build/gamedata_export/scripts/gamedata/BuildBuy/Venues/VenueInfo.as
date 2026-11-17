package gamedata.BuildBuy.Venues
{
   import gamedata.GameEntry.Neighborhood.MultiUnitLotRules;
   import gamedata.Gameplay.Business.BusinessData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import widgets.BuildBuy.VenueConfiguration.controls.IHasVenueRequirementsData;
   import widgets.BuildBuy.VenueConfiguration.controls.VenueRequirementsData;
   import widgets.BuildBuy.VenueConfiguration.controls.VenueSettingsPanelBase;
   import widgets.shared.utils.BusinessUtils;
   
   public class VenueInfo extends OlympusObject implements IHasVenueRequirementsData
   {
      
      public static const ICON_VENUE_DEFAULT:String = "0x11f282e5f2e6e91c";
      
      public static const ICON_APARTMENT:String = "0x0da939fca23436d1";
      
      public static const VENUE_PANEL_OPTIONS:uint = 1 << 0;
      
      public static const VENUE_PANEL_TIERS:uint = 1 << 1;
      
      public static const VENUE_PANEL_TRAITS:uint = 1 << 2;
      
      public static const VENUE_OBJECT_FLAG_NO_FLAG:uint = 0;
      
      public static const VENUE_OBJECT_FLAG_SMALL_BUSINESS:uint = 1;
      
      public var nameKey:LocKey = new LocKey();
      
      public var nameWithTierKey:LocKey = new LocKey();
      
      public var nameUnfulfilledKey:LocKey = new LocKey();
      
      public var descriptionKey:LocKey = new LocKey();
      
      public var currentTierName:LocKey = new LocKey();
      
      public var currentTierNameTwoLines:LocKey = new LocKey();
      
      public var tierBannerMaxFailText:LocKey = new LocKey();
      
      public var tierBannerMinFailText:LocKey = new LocKey();
      
      public var iconKey:ResourceKey = new ResourceKey();
      
      public var thumbnailKey:ResourceKey = new ResourceKey();
      
      public var isFulfilled:Boolean;
      
      public var hasTiers:Boolean;
      
      public var rules:Array = [MultiUnitLotRules];
      
      public var tagKey:String;
      
      public var objectList:Array = [VenueObjectInfo];
      
      public var categoryTags:Array = [uint];
      
      public var isHiddenFromBB:Boolean;
      
      public var venueType:uint;
      
      public var venueFlags:uint;
      
      public var hasSubvenues:Boolean;
      
      public var sourceVenueTagKey:String;
      
      public var venueFeatures:Array = [VenueFeatureInfo];
      
      public var venueOwnerId:String = null;
      
      protected var venuePanelFlags:uint;
      
      protected var venueSettingsPanel:VenueSettingsPanelBase;
      
      public var universityHousingVenueInfo:UniversityHousingVenueInfo;
      
      public function VenueInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(Boolean(param1) && "universityHousingVenueInfo" in param1)
         {
            this.universityHousingVenueInfo = new UniversityHousingVenueInfo();
         }
         super.ParseObject(param1);
         this.venueOwnerId = this.venueOwnerId == "0" ? null : this.venueOwnerId;
         FixupArray(this.objectList);
         FixupArray(this.categoryTags);
         FixupArray(this.venueFeatures);
         FixupArray(this.rules);
         this.SetPanelFlags();
      }
      
      public function get TagKey() : String
      {
         return this.tagKey;
      }
      
      public function get Label() : String
      {
         var _loc1_:String = null;
         if(this.isFulfilled)
         {
            if(this.currentTierName.IsValid())
            {
               return this.nameWithTierKey.toString(this.currentTierName.toString());
            }
            return this.nameKey.toString();
         }
         _loc1_ = this.nameUnfulfilledKey.toString();
         if(_loc1_.length > 0)
         {
            return _loc1_;
         }
         return this.nameKey.toString();
      }
      
      public function get IsRetailLot() : Boolean
      {
         return this.venueType == VenueTypes.RETAIL;
      }
      
      public function get IsRentalLot() : Boolean
      {
         return this.venueType == VenueTypes.RENTAL;
      }
      
      public function get IsBusinessLot() : Boolean
      {
         return this.IsRestaurant() || this.IsVetClinic();
      }
      
      public function IsRestaurant() : Boolean
      {
         return this.venueType == VenueTypes.RESTAURANT;
      }
      
      public function IsVetClinic() : Boolean
      {
         return this.venueType == VenueTypes.VET_CLINIC;
      }
      
      public function get IsResidentialLot() : Boolean
      {
         return this.venueType == VenueTypes.RESIDENTIAL;
      }
      
      public function get IsUniversityHousingLot() : Boolean
      {
         return this.venueType == VenueTypes.UNIVERSITY_HOUSING;
      }
      
      public function get IsMultiUnitLot() : Boolean
      {
         return this.venueType == VenueTypes.MULTI_UNIT;
      }
      
      public function get IsSmallBusinessLot() : Boolean
      {
         return this.venueType == VenueTypes.SMALL_BUSINESS;
      }
      
      public function get IsCustomVenueLot() : Boolean
      {
         return this.venueType == VenueTypes.CUSTOM_VENUE;
      }
      
      public function get AllowsSmallBusiness() : Boolean
      {
         return this.IsSmallBusinessLot || this.IsResidentialLot;
      }
      
      public function get HasVenueOwner() : Boolean
      {
         return this.venueOwnerId != null && this.venueOwnerId != "0";
      }
      
      public function get IsResidentialType() : Boolean
      {
         return this.IsMultiUnitLot || this.IsResidentialLot;
      }
      
      public function get VenueSettingsPanel() : VenueSettingsPanelBase
      {
         return this.venueSettingsPanel;
      }
      
      public function set VenueSettingsPanel(param1:VenueSettingsPanelBase) : void
      {
         this.venueSettingsPanel = param1;
      }
      
      public function set VenueOwner(param1:String) : void
      {
         this.venueOwnerId = param1;
      }
      
      public function IsVenueType(param1:uint) : Boolean
      {
         return this.venueType == param1;
      }
      
      public function IsSubVenue() : Boolean
      {
         return this.sourceVenueTagKey != null;
      }
      
      public function HasVenueFlag(param1:uint) : Boolean
      {
         return this.venueFlags & param1;
      }
      
      public function HasPanelFlag(param1:uint) : Boolean
      {
         return this.venuePanelFlags & param1;
      }
      
      protected function SetPanelFlags() : void
      {
         if(this.IsRestaurant() || this.IsVetClinic() || this.IsUniversityHousingLot)
         {
            this.venuePanelFlags |= VENUE_PANEL_OPTIONS;
         }
         if(this.hasTiers)
         {
            this.venuePanelFlags |= VENUE_PANEL_TIERS;
         }
         this.venuePanelFlags |= VENUE_PANEL_TRAITS;
      }
      
      public function HasDisplayFeatures() : Boolean
      {
         return this.venueFeatures.length > 0;
      }
      
      public function GetRequirementsData(param1:Object) : VenueRequirementsData
      {
         var _loc4_:VenueRequirementsData = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:VenueObjectInfo = null;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         var _loc2_:Object = {"venueKey":this.tagKey};
         if("plexId" in param1)
         {
            _loc2_["plexId"] = param1["plexId"];
         }
         var _loc3_:Object = CommunicationManager.CallGameService("BBGetVenueRequirements",_loc2_);
         if(_loc3_)
         {
            _loc4_ = new VenueRequirementsData();
            _loc4_.IsFulfilled = _loc3_["isFulfilled"] as Boolean;
            _loc4_.IsLotFulfilled = _loc3_["isLotFulfilled"] as Boolean;
            _loc4_.CurrentTier = _loc3_["currentTier"];
            _loc4_.TierList = _loc3_["tierList"];
            _loc5_ = _loc3_["objectList"] as Array;
            _loc6_ = _loc3_["tierList"] as Array;
            _loc7_ = int(_loc5_.length);
            if(Boolean(_loc6_) && _loc6_.length > 0)
            {
               OlympusObject.ConstructArrayInPlace(_loc6_,VenueTierInfo);
            }
            if(_loc7_ > 0)
            {
               OlympusObject.ConstructArrayInPlace(_loc5_,VenueObjectInfo);
            }
            if(_loc6_)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc6_.length)
               {
                  _loc10_ = _loc6_[_loc9_].venueObject;
                  _loc11_ = int(_loc3_["currentTier"]);
                  if(_loc11_ != -1)
                  {
                     _loc10_.enabled = _loc11_ == _loc9_;
                  }
                  _loc4_.TierObjectList.push(_loc10_);
                  _loc9_++;
               }
            }
            _loc8_ = this.IsSmallBusinessLot || BusinessUtils.CurrentZoneHasSimBusiness(BusinessData.SMALL_BUSINESS_TYPE);
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc12_ = _loc5_[_loc9_] as VenueObjectInfo;
               if(!_loc8_ && Boolean(_loc12_.HasFlag(VENUE_OBJECT_FLAG_SMALL_BUSINESS)))
               {
                  break;
               }
               switch(_loc12_.requiredType)
               {
                  case VenueObjectInfo.VOT_LOT_REQUIRED:
                  case VenueObjectInfo.VOT_REQUIRED_MAX:
                  case VenueObjectInfo.VOT_REQUIRED:
                     _loc4_.RequiredObjectList.push(_loc12_);
                     break;
                  case VenueObjectInfo.VOT_RESTRICTION:
                     _loc4_.RestrictionList.push(_loc12_);
                     break;
                  case VenueObjectInfo.VOT_FORBIDDEN:
                     _loc4_.ForbiddenObjectList.push(_loc12_);
                     break;
                  case VenueObjectInfo.VOT_OPTIONAL:
                     _loc4_.OptionalObjectList.push(_loc12_);
               }
               _loc9_++;
            }
            return _loc4_;
         }
         return null;
      }
   }
}

