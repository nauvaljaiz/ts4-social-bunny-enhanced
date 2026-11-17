package gamedata.GameEntry.Neighborhood
{
   import gamedata.BuildBuy.Venues.VenueFlags;
   import gamedata.BuildBuy.Venues.VenueInfo;
   import gamedata.Exchange.ExchangeData;
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.GameEntry.shared.LotDescription;
   import gamedata.GameEntry.shared.TravelGroups;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.BuildingType;
   import gamedata.shared.HouseholdSimData;
   import gamedata.shared.ZoneModifier;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.math.TimeSpan;
   
   public class NeighborhoodLotData extends OlympusObject
   {
      
      public static const VACANT_LOT:int = 0;
      
      public static const MY_PLAYABLE_LOT:int = 1;
      
      public static const MY_NPC_LOT:int = 2;
      
      public static const VENUE:int = 3;
      
      public static const VENUE_INCOMPLETE:int = 4;
      
      public static const VACANT_VACATION_LOT:int = 5;
      
      public static const MY_VACATION_LOT:int = 6;
      
      public static const NPC_VACATION_LOT:int = 7;
      
      public static const VENUE_OWNED_INCOMPLETE:int = 8;
      
      public static const VENUE_OWNED:int = 9;
      
      public static const NON_PLAYER_PROTECTED_NPC_LOT:int = 10;
      
      public static const NON_PLAYER_PROTECTED_VACATION_LOT:int = 11;
      
      public static const VENUE_BUILDBUY_LOCKED:int = 12;
      
      public static const VACANT_UNIVERSITY_HOUSING_LOT:int = 13;
      
      public static const VACANT_UNIVERSITY_HOUSING_LOT_INCOMPLETE:int = 14;
      
      public static const MY_PLAYABLE_UNIVERSITY_HOUSING_LOT:int = 15;
      
      public static const MY_PLAYABLE_UNIVERSITY_HOUSING_LOT_INCOMPLETE:int = 16;
      
      public static const NPC_UNIVERSITY_HOUSING_LOT:int = 17;
      
      public static const NPC_NON_PLAYER_PROTECTED_UNIVERSITY_HOUSING_LOT:int = 18;
      
      public static const NPC_UNIVERSITY_HOUSING_LOT_INCOMPLETE:int = 19;
      
      private static const UNIVERSITY_HOUSING_LOT_TYPES:Array = [VACANT_UNIVERSITY_HOUSING_LOT,VACANT_UNIVERSITY_HOUSING_LOT_INCOMPLETE,MY_PLAYABLE_UNIVERSITY_HOUSING_LOT,MY_PLAYABLE_UNIVERSITY_HOUSING_LOT_INCOMPLETE,NPC_UNIVERSITY_HOUSING_LOT,NPC_NON_PLAYER_PROTECTED_UNIVERSITY_HOUSING_LOT,NPC_UNIVERSITY_HOUSING_LOT_INCOMPLETE];
      
      public static const SHARED_ZONE_PLEX_ID:int = 300;
      
      protected static var RENTAL_PRICE_MULTIPLY:Number = -1;
      
      protected static var RENTAL_PRICE_ADD:Number = 0;
      
      protected static var GETAWAY_COST_MULTIPLY:Number = -1;
      
      protected static var GETAWAY_COST_ADD:Number = 0;
      
      protected static var GETAWAY_COST_HOUSEHOLD_SIM_MULTIPLIER:Number = 0;
      
      protected static var GETAWAY_COST_NPC_SIM_MULTIPLIER:Number = 0;
      
      protected static var GETAWAY_PROFIT_MULTIPLY:Number = -1;
      
      protected static var GETAWAY_PROFIT_ADD:Number = 0;
      
      protected static var GETAWAY_PROFIT_SIM_MULTIPLIER:Number = 0;
      
      public var lotDescriptionId:String;
      
      public var zoneInstanceId:String;
      
      public var houseDescriptionId:String;
      
      public var lotName:String;
      
      public var lotDescription:String;
      
      public var lotOwnerId:String;
      
      public var hasBlueprintPending:Boolean;
      
      public var housePrice:Number = 0;
      
      public var furnishingsPrice:Number = 0;
      
      public var lotDescriptionData:LotDescription = new LotDescription();
      
      public var numBeds:uint = 0;
      
      public var numBaths:uint = 0;
      
      public var venueData:VenueInfo = new VenueInfo();
      
      public var regionId:String;
      
      public var lotTraits:Array = [ZoneModifier];
      
      public var occupantId:String;
      
      public var plexId:uint = 0;
      
      public var rentPrice:uint = 0;
      
      public var depositBase:uint = 0;
      
      public var buildingType:int;
      
      public var plexMinLevel:int;
      
      public var plexMaxLevel:int;
      
      public var masterZoneId:String;
      
      public var ecoFootprintState:uint = 0;
      
      public var rating:MultiUnitLotRating = new MultiUnitLotRating();
      
      public var leaseLength:uint = 0;
      
      public var colorIndex:uint = 0;
      
      public var warningMessage:String = null;
      
      public var mLotType:int;
      
      protected var mOwnerData:HouseholdData = null;
      
      protected var mSmallBusinessInfo:Array = [];
      
      protected var mTravelGroups:TravelGroups = new TravelGroups();
      
      protected var lotChallenges:Array = [ZoneModifier];
      
      public function NeighborhoodLotData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lotTraits);
         FixupArray(this.lotChallenges);
         var _loc2_:* = int(this.lotTraits.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.lotTraits[_loc2_].modifierType == ZoneModifier.MODIFIER_TYPE_CHALLENGE)
            {
               this.lotChallenges.push(this.lotTraits[_loc2_]);
               this.lotTraits.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      public function get OwnerData() : HouseholdData
      {
         return this.mOwnerData;
      }
      
      public function get SmallBusinessData() : Array
      {
         return this.mSmallBusinessInfo;
      }
      
      public function get IsOccupied() : Boolean
      {
         return this.mLotType == MY_PLAYABLE_LOT || this.mLotType == MY_NPC_LOT || this.mLotType == NON_PLAYER_PROTECTED_NPC_LOT;
      }
      
      public function get IsVenueType() : Boolean
      {
         return this.mLotType == NeighborhoodLotData.VENUE || this.mLotType == NeighborhoodLotData.VENUE_INCOMPLETE || this.mLotType == NeighborhoodLotData.VENUE_OWNED || this.mLotType == NeighborhoodLotData.VENUE_OWNED_INCOMPLETE || this.mLotType == NeighborhoodLotData.VENUE_BUILDBUY_LOCKED;
      }
      
      public function get IsVacationRentalLot() : Boolean
      {
         return this.mLotType == MY_VACATION_LOT || this.mLotType == NPC_VACATION_LOT || this.mLotType == VACANT_VACATION_LOT || this.mLotType == NON_PLAYER_PROTECTED_VACATION_LOT;
      }
      
      public function get IsUniversityHousingLot() : Boolean
      {
         return UNIVERSITY_HOUSING_LOT_TYPES.indexOf(this.mLotType) >= 0;
      }
      
      public function get IsOccupiedUniversityHousingLot() : Boolean
      {
         if(this.mLotType == VACANT_UNIVERSITY_HOUSING_LOT || this.mLotType == VACANT_UNIVERSITY_HOUSING_LOT_INCOMPLETE)
         {
            return false;
         }
         return this.IsUniversityHousingLot;
      }
      
      public function get IsOccupiedVacationRentalLot() : Boolean
      {
         return this.mLotType == MY_VACATION_LOT || this.mLotType == NPC_VACATION_LOT || this.mLotType == NON_PLAYER_PROTECTED_VACATION_LOT;
      }
      
      public function get IsOccupiedVenue() : Boolean
      {
         return this.mLotType == VENUE_OWNED || this.mLotType == VENUE_OWNED_INCOMPLETE;
      }
      
      public function get HasVenueOwner() : Boolean
      {
         return Boolean(this.venueData) && this.venueData.HasVenueOwner;
      }
      
      public function get IsNPCVacationLot() : Boolean
      {
         return this.mLotType == NPC_VACATION_LOT || this.mLotType == NON_PLAYER_PROTECTED_VACATION_LOT;
      }
      
      public function get IsNPCOccupiedLot() : Boolean
      {
         return this.mLotType == MY_NPC_LOT || this.mLotType == NON_PLAYER_PROTECTED_NPC_LOT;
      }
      
      public function get IsPenthouse() : Boolean
      {
         return this.buildingType == BuildingType.PENTHOUSE_PLEX;
      }
      
      public function get IsPenthouseRental() : Boolean
      {
         return this.buildingType == BuildingType.BT_PENTHOUSE_RENTAL;
      }
      
      public function get IsInPlex() : Boolean
      {
         return this.buildingType == BuildingType.FULLY_CONTAINED_PLEX;
      }
      
      public function get IsMultiUnitBuilding() : Boolean
      {
         return this.buildingType == BuildingType.BT_MULTI_UNIT || this.buildingType == BuildingType.BT_PENTHOUSE_RENTAL;
      }
      
      public function get IsMultiUnitBuildingSharedZone() : Boolean
      {
         return this.IsMultiUnitBuilding && this.plexId == SHARED_ZONE_PLEX_ID;
      }
      
      public function get IsPrimaryLot() : Boolean
      {
         return this.masterZoneId == this.zoneInstanceId;
      }
      
      public function get HousePrice() : Number
      {
         if(this.IsInPlex)
         {
            return 0;
         }
         return this.housePrice;
      }
      
      public function get FurnishingsPrice() : Number
      {
         return this.furnishingsPrice;
      }
      
      public function get LotPrice() : int
      {
         if(this.IsInPlex)
         {
            return this.DepositPrice;
         }
         return this.lotDescriptionData.price;
      }
      
      public function get DepositPrice() : int
      {
         if(this.IsInPlex)
         {
            return this.depositBase;
         }
         return 0;
      }
      
      public function get TotalPrice() : Number
      {
         return this.LotPrice + this.HousePrice + this.FurnishingsPrice;
      }
      
      public function get UnfurnishedPrice() : Number
      {
         return this.LotPrice + this.HousePrice;
      }
      
      public function get VacationRentalPrice() : uint
      {
         if(RENTAL_PRICE_MULTIPLY == -1)
         {
            this.LoadLotRentalPriceValues();
         }
         return uint(this.TotalPrice * RENTAL_PRICE_MULTIPLY + RENTAL_PRICE_ADD);
      }
      
      public function ComputeGetawayCost(param1:int = 0, param2:int = 0) : uint
      {
         if(GETAWAY_COST_MULTIPLY == -1)
         {
            this.LoadGetawayRentalPriceValues();
         }
         return uint(this.TotalPrice * GETAWAY_COST_MULTIPLY * (1 + GETAWAY_COST_HOUSEHOLD_SIM_MULTIPLIER * param1) * (1 - GETAWAY_COST_NPC_SIM_MULTIPLIER * param2) + GETAWAY_COST_ADD);
      }
      
      public function ComputeGetawayEarnings(param1:int = 0, param2:int = 0) : uint
      {
         if(GETAWAY_PROFIT_MULTIPLY == -1)
         {
            this.LoadGetawayRentalPriceValues();
         }
         if(param2 == 0)
         {
            return 0;
         }
         return uint(this.TotalPrice * GETAWAY_PROFIT_MULTIPLY * (1 + GETAWAY_PROFIT_SIM_MULTIPLIER * param2) + GETAWAY_PROFIT_ADD);
      }
      
      public function GetActiveHouseholdHasNoExpenses(param1:Boolean = false) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         if(this.IsMultiUnitBuilding)
         {
            _loc2_ = GameplayStateData.ActiveHouseholdId;
            _loc3_ = this.venueData.HasVenueOwner && _loc2_ == this.venueData.venueOwnerId;
            if(_loc3_)
            {
               if(param1)
               {
                  return !this.lotOwnerId;
               }
               if(this.lotOwnerId == _loc2_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get IsEmpty() : Boolean
      {
         return this.housePrice == 0 && this.furnishingsPrice == 0;
      }
      
      public function get IsFurnished() : Boolean
      {
         return this.furnishingsPrice != 0;
      }
      
      public function get LotTravelGroups() : TravelGroups
      {
         return this.mTravelGroups;
      }
      
      public function UpdateTravelGroups(param1:TravelGroupData) : void
      {
         if(!this.mTravelGroups)
         {
            this.mTravelGroups = new TravelGroups();
         }
         this.mTravelGroups.Update(param1);
         this.UpdateOwner(this.lotOwnerId);
      }
      
      public function HasZoneModifiers() : Boolean
      {
         return this.lotTraits.length > 0 || this.lotChallenges.length > 0;
      }
      
      public function get ZoneModifiers() : Array
      {
         return this.lotTraits.concat(this.lotChallenges);
      }
      
      public function get LotTraits() : Array
      {
         return this.lotTraits;
      }
      
      public function get LotChallenges() : Array
      {
         return this.lotChallenges;
      }
      
      public function LeaseLengthAsDays() : uint
      {
         var _loc1_:TimeSpan = new TimeSpan();
         _loc1_.Set(0,0,0,0,this.leaseLength);
         return _loc1_.ConvertToMinutes();
      }
      
      public function UpdateZoneData(param1:NeighborhoodLotData) : void
      {
         this.lotName = param1.lotName;
         this.lotDescription = param1.lotDescription;
         this.housePrice = param1.housePrice;
         this.furnishingsPrice = param1.furnishingsPrice;
         this.hasBlueprintPending = param1.hasBlueprintPending;
         this.numBeds = param1.numBeds;
         this.numBaths = param1.numBaths;
         this.plexId = param1.plexId;
         this.buildingType = param1.buildingType;
         this.plexMinLevel = param1.plexMinLevel;
         this.plexMaxLevel = param1.plexMaxLevel;
         this.masterZoneId = param1.masterZoneId;
         this.regionId = param1.regionId;
         this.venueData = param1.venueData;
         this.lotTraits = param1.lotTraits;
         this.rating = param1.rating;
         this.occupantId = param1.occupantId;
      }
      
      protected function DetermineVacationLotType() : int
      {
         var _loc2_:TravelGroupData = null;
         var _loc1_:int = VACANT_VACATION_LOT;
         for each(_loc2_ in this.mTravelGroups.TravelGroupDatas)
         {
            if(_loc2_.played)
            {
               return MY_VACATION_LOT;
            }
            if(_loc2_.isPlayerProtected)
            {
               _loc1_ = NPC_VACATION_LOT;
            }
            else if(_loc1_ != NPC_VACATION_LOT)
            {
               _loc1_ = NON_PLAYER_PROTECTED_VACATION_LOT;
            }
         }
         return _loc1_;
      }
      
      private function GetUniversityHousingLotType() : int
      {
         var _loc1_:Boolean = this.venueData.isFulfilled;
         if(this.mOwnerData == null)
         {
            return _loc1_ ? VACANT_UNIVERSITY_HOUSING_LOT : VACANT_UNIVERSITY_HOUSING_LOT_INCOMPLETE;
         }
         if(this.mOwnerData.isNPC)
         {
            if(_loc1_)
            {
               return this.mOwnerData.isPlayerProtected ? NPC_UNIVERSITY_HOUSING_LOT : NPC_NON_PLAYER_PROTECTED_UNIVERSITY_HOUSING_LOT;
            }
            return NPC_UNIVERSITY_HOUSING_LOT_INCOMPLETE;
         }
         return _loc1_ ? MY_PLAYABLE_UNIVERSITY_HOUSING_LOT : MY_PLAYABLE_UNIVERSITY_HOUSING_LOT_INCOMPLETE;
      }
      
      private function GetResidentialLotType() : int
      {
         if(this.mOwnerData == null)
         {
            return VACANT_LOT;
         }
         if(this.mOwnerData.isNPC)
         {
            return this.mOwnerData.isPlayerProtected ? MY_NPC_LOT : NON_PLAYER_PROTECTED_NPC_LOT;
         }
         return MY_PLAYABLE_LOT;
      }
      
      private function GetVenueLotType() : int
      {
         var _loc1_:Boolean = this.venueData.isFulfilled;
         if(_loc1_)
         {
            return this.mOwnerData ? VENUE_OWNED : VENUE;
         }
         return this.mOwnerData ? VENUE_OWNED_INCOMPLETE : VENUE_INCOMPLETE;
      }
      
      public function UpdateOwner(param1:String, param2:String = null) : void
      {
         var _loc3_:int = 0;
         this.lotOwnerId = param1;
         this.RequestOwnerData();
         if(this.venueData.HasVenueFlag(VenueFlags.VACATION_TARGET))
         {
            _loc3_ = this.DetermineVacationLotType();
         }
         else if(this.lotDescriptionData.disableBuildBuy)
         {
            _loc3_ = VENUE_BUILDBUY_LOCKED;
         }
         else if(this.venueData.IsUniversityHousingLot)
         {
            _loc3_ = this.GetUniversityHousingLotType();
         }
         else if(this.venueData.IsResidentialType)
         {
            _loc3_ = this.GetResidentialLotType();
         }
         else
         {
            _loc3_ = this.GetVenueLotType();
         }
         this.mLotType = _loc3_;
      }
      
      public function UpdateVenueOwner(param1:String) : void
      {
         this.venueData.venueOwnerId = param1;
      }
      
      public function IsLotLargerThanBlueprint(param1:ExchangeData) : Boolean
      {
         return this.lotDescriptionData.lotSizeX >= param1.sizeX && this.lotDescriptionData.lotSizeY >= param1.sizeZ;
      }
      
      public function GetEcoFootprintState() : uint
      {
         return this.ecoFootprintState;
      }
      
      public function GetMultiUnitOwnerFamilyName() : String
      {
         var _loc2_:HouseholdData = null;
         var _loc1_:Object = CommunicationManager.CallGameService("GetFamilyInfo",this.venueData.venueOwnerId);
         if(_loc1_)
         {
            _loc2_ = new HouseholdData(_loc1_);
            return _loc1_.familyName;
         }
         return null;
      }
      
      protected function RequestOwnerData() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:HouseholdData = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:HouseholdSimData = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(this.lotOwnerId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetFamilyInfo",this.lotOwnerId);
            _loc2_ = [];
            if(_loc1_)
            {
               _loc3_ = new HouseholdData(_loc1_);
               if(this.venueData.AllowsSmallBusiness)
               {
                  _loc5_ = CommunicationManager.CallGameService("GetHouseholdSmallBusinesses",{"householdId":_loc3_.familyId}) as Object;
                  if(_loc5_)
                  {
                     _loc6_ = _loc3_.familySims;
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_.length)
                     {
                        _loc7_ = _loc6_[_loc8_] as HouseholdSimData;
                        _loc9_ = _loc5_[_loc7_.id];
                        if((Boolean(_loc9_)) && Boolean(_loc9_.allowed_zone_ids) && _loc9_.allowed_zone_ids.indexOf(this.zoneInstanceId) != -1)
                        {
                           _loc2_.push(_loc9_);
                        }
                        _loc8_++;
                     }
                  }
               }
               _loc4_ = CommunicationManager.CallGameService("GetHouseholdSimsInZone",{
                  "lotId":_loc3_.familyLotId,
                  "householdId":_loc3_.familyId
               }) as Array;
               if(_loc4_)
               {
                  _loc6_ = _loc3_.familySims;
                  _loc10_ = 0;
                  _loc11_ = int(_loc6_.length);
                  while(_loc10_ < _loc11_)
                  {
                     _loc7_ = _loc6_[_loc10_] as HouseholdSimData;
                     _loc7_.bAtHome = _loc4_.indexOf(_loc7_.id) != -1;
                     _loc10_++;
                  }
               }
            }
            this.mOwnerData = _loc3_;
            this.mSmallBusinessInfo = _loc2_;
         }
         else
         {
            this.mOwnerData = null;
            this.mSmallBusinessInfo = [];
         }
      }
      
      protected function LoadLotRentalPriceValues() : void
      {
         var _loc1_:Object = CommunicationManager.CallGameService("GetLotRentalPriceCalculator");
         RENTAL_PRICE_MULTIPLY = _loc1_.multiply;
         RENTAL_PRICE_ADD = _loc1_.add;
      }
      
      protected function LoadGetawayRentalPriceValues() : void
      {
         var _loc1_:Object = CommunicationManager.CallGameService("GetGetawayLotRentalPriceCalculator");
         GETAWAY_COST_MULTIPLY = _loc1_.rent_multiply;
         GETAWAY_COST_ADD = _loc1_.rent_add;
         GETAWAY_COST_HOUSEHOLD_SIM_MULTIPLIER = _loc1_.household_sim_count_multiplier;
         GETAWAY_COST_NPC_SIM_MULTIPLIER = _loc1_.npc_sim_count_multiplier;
         GETAWAY_PROFIT_MULTIPLY = _loc1_.profit_multiply;
         GETAWAY_PROFIT_ADD = _loc1_.profit_add;
         GETAWAY_PROFIT_SIM_MULTIPLIER = _loc1_.sim_count_multiplier;
      }
   }
}

