package gamedata.GameEntry.Neighborhood
{
   import gamedata.GameEntry.shared.RegionDescription;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGE;
   import olympus.utils.ArrayUtils;
   
   public class NeighborhoodData extends OlympusObject
   {
      
      public var id:String;
      
      public var name:String;
      
      public var regionId:String;
      
      public var lots:Array = [NeighborhoodLotData];
      
      public var description:String;
      
      public var streetInfoData:Array = [StreetInfoData];
      
      public var hasStarterLot:Boolean = false;
      
      public function NeighborhoodData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:NeighborhoodLotData = null;
         super.ParseObject(param1);
         if(param1 == null || param1["lots"] == null)
         {
            this.lots = new Array();
         }
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.UpdateOwner(_loc3_.lotOwnerId,this.regionId);
         }
         FixupArray(this.streetInfoData);
      }
      
      public function GetLotByLotDescriptionId(param1:String) : NeighborhoodLotData
      {
         var _loc3_:NeighborhoodLotData = null;
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.lotDescriptionId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function GetLotByInstanceId(param1:String) : NeighborhoodLotData
      {
         var _loc3_:NeighborhoodLotData = null;
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.zoneInstanceId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function UpdateLot(param1:NeighborhoodLotData) : Boolean
      {
         var _loc3_:NeighborhoodLotData = null;
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.zoneInstanceId == param1.zoneInstanceId)
            {
               _loc3_.UpdateZoneData(param1);
               return true;
            }
         }
         return false;
      }
      
      public function ShowRentableLotWarning() : Boolean
      {
         if(!RegionDescription.IsVacationWorld(this.regionId))
         {
            return false;
         }
         return !this.HasRentableLot();
      }
      
      public function HasRentableLot() : Boolean
      {
         var _loc2_:NeighborhoodLotData = null;
         var _loc1_:Array = this.lots;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.IsVacationRentalLot)
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetNumHouseholdsText() : String
      {
         var _loc1_:int = 0;
         if(RegionDescription.IsVacationWorld(this.regionId))
         {
            _loc1_ = this.GetNumPlayerVacationingGroups();
            return _loc1_ > 0 ? KeysGE.NHD_NUM_VACATION_GROUPS_LABEL.toString(_loc1_) : null;
         }
         _loc1_ = this.GetNumPlayerHouseholds();
         return _loc1_ > 0 ? KeysGE.NHD_NUM_PLAYED_HOUSEHOLDS_LABEL.toString(_loc1_) : null;
      }
      
      public function get IsPlayerFacingNeighborhood() : Boolean
      {
         var _loc1_:RegionDescription = RegionDescription.GetRegionDescription(this.regionId);
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.bIsPlayerFacing;
      }
      
      public function GetRegionType() : String
      {
         var _loc1_:RegionDescription = RegionDescription.GetRegionDescription(this.regionId);
         if(!_loc1_)
         {
            return "";
         }
         return _loc1_.GetRegionType();
      }
      
      protected function GetNumPlayerHouseholds() : int
      {
         var _loc3_:NeighborhoodLotData = null;
         var _loc1_:uint = 0;
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.mLotType == NeighborhoodLotData.MY_PLAYABLE_LOT)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      protected function GetNumPlayerVacationingGroups() : int
      {
         var _loc3_:NeighborhoodLotData = null;
         var _loc4_:TravelGroupData = null;
         var _loc1_:uint = 0;
         var _loc2_:Array = this.lots;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.mLotType == NeighborhoodLotData.MY_VACATION_LOT)
            {
               for each(_loc4_ in _loc3_.LotTravelGroups.TravelGroupDatas)
               {
                  if(_loc4_.played)
                  {
                     _loc1_++;
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function GetStreetInfoDataByWorldId(param1:String) : StreetInfoData
      {
         var _loc2_:int = ArrayUtils.IndexOfByFieldName(this.streetInfoData,"worldId",param1);
         return _loc2_ != -1 ? this.streetInfoData[_loc2_] : null;
      }
      
      public function GetStreetInfoDataByWorldDescriptionId(param1:String) : StreetInfoData
      {
         var _loc2_:int = ArrayUtils.IndexOfByFieldName(this.streetInfoData,"worldDescriptionId",param1);
         return _loc2_ != -1 ? this.streetInfoData[_loc2_] : null;
      }
   }
}

