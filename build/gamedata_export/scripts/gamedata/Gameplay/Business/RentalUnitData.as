package gamedata.Gameplay.Business
{
   import gamedata.GameEntry.Neighborhood.MultiUnitLotRating;
   import gamedata.Gameplay.shared.BusinessRuleData;
   import gamedata.Gameplay.shared.definitions.UnitRatingCategoryStaticData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class RentalUnitData extends OlympusObject
   {
      
      public var name:String;
      
      public var bedroomCount:int;
      
      public var bathroomCount:int;
      
      public var leaseLength:int;
      
      public var rentPrice:int;
      
      public var houseDescriptionId:String;
      
      public var zoneId:String;
      
      public var plexId:String;
      
      public var rating:MultiUnitLotRating = new MultiUnitLotRating();
      
      public var venueOwnerId:String;
      
      public var occupantId:String;
      
      public var rentalUnitBusinessData:RentalUnitBusinessData = new RentalUnitBusinessData();
      
      public const UNIT_RATING_CATEGORIES:Array = [UnitRatingCategoryStaticData.CATEGORY_TYPE_SIZE,UnitRatingCategoryStaticData.CATEGORY_TYPE_AMENITY,UnitRatingCategoryStaticData.CATEGORY_TYPE_ENVIRONMENT,UnitRatingCategoryStaticData.CATEGORY_TYPE_MAINTENANCE];
      
      public var mOccupantHouseholdName:String;
      
      public var mVenueOwnerHouseholdName:String;
      
      public var mVenueOwnerZoneId:String;
      
      public var mNumBrokenRules:int;
      
      public var mBackgroundFrame:String;
      
      public function RentalUnitData(param1:Object = null)
      {
         super(param1);
         this.SetOccupantVenueOwnerData();
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.UpdateNumBrokenRules();
      }
      
      public function SetOccupantVenueOwnerData(param1:String = null) : void
      {
         var _loc2_:Object = null;
         if(this.IsOccupied && !this.mOccupantHouseholdName)
         {
            _loc2_ = CommunicationManager.CallGameService("GetFamilyInfo",this.occupantId);
            if(_loc2_)
            {
               this.mOccupantHouseholdName = _loc2_.familyName;
            }
         }
         if(this.IsNpcOwned && Boolean(param1))
         {
            this.venueOwnerId = param1;
         }
         if(Boolean(this.venueOwnerId) && !this.mVenueOwnerZoneId)
         {
            _loc2_ = CommunicationManager.CallGameService("GetFamilyInfo",this.venueOwnerId);
            if(_loc2_)
            {
               this.mVenueOwnerHouseholdName = _loc2_.familyName;
               this.mVenueOwnerZoneId = _loc2_.familyLotId;
            }
         }
      }
      
      public function get IsNpcOwned() : Boolean
      {
         return this.venueOwnerId == "0";
      }
      
      public function get IsOccupied() : Boolean
      {
         return this.occupantId != null && this.occupantId != "0";
      }
      
      public function get IsPropertyOwnerUnit() : Boolean
      {
         if(!this.IsOccupied || this.IsNpcOwned)
         {
            return false;
         }
         return this.occupantId == this.venueOwnerId;
      }
      
      public function UpdateNumBrokenRules() : void
      {
         var _loc4_:Object = null;
         if(!this.zoneId)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:Object = CommunicationManager.CallGameService("GetBusinessRules",{"zoneId":this.zoneId}) as Object;
         var _loc3_:Array = _loc2_["rules"] as Array;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.state == BusinessRuleData.BUSINESS_RULE_STATE_BROKEN)
            {
               _loc1_ += 1;
            }
         }
         this.mNumBrokenRules = _loc1_;
      }
      
      public function UpdateRealBedBathCount() : Boolean
      {
         var _loc2_:Object = null;
         var _loc1_:Boolean = false;
         if(this.zoneId)
         {
            _loc2_ = CommunicationManager.CallGameService("BBGetUnitRealBedToiletCount",{"zoneId":this.zoneId});
            if(_loc2_)
            {
               _loc1_ = this.bedroomCount != _loc2_["realBedCount"] || this.bathroomCount != _loc2_["realToiletCount"];
               this.bedroomCount = _loc2_["realBedCount"];
               this.bathroomCount = _loc2_["realToiletCount"];
            }
         }
         return _loc1_;
      }
   }
}

