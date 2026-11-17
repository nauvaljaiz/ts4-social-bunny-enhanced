package gamedata.BuildBuy.shared
{
   import gamedata.BuildBuy.Venues.VenueInfo;
   import gamedata.GameContent;
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.GameTray.SetMoney;
   import gamedata.Gameplay.Business.BusinessData;
   import gamedata.Gameplay.Careers.GigInfo;
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import widgets.BuildBuy.data.PurchaseAvailabilityData;
   
   public class BuildBuyStateData
   {
      
      protected static var sbIsLotEditable:Object;
      
      protected static var sAvailabilityData:PurchaseAvailabilityData;
      
      protected static var sCommunicationManager:CommunicationManager;
      
      protected static var sVenueRequirements:Object;
      
      public static const PURCHASE_AVAILABILITY_UPDATE:String = "BBPurchaseAvailabilityDataUpdate";
      
      public static const VENUE_SELECT:String = "VenueSelected";
      
      public static const VIEW_VENUE_LOTS:String = "ViewVenueLots";
      
      protected static const BUILDBUY_STATE_DATA_STRING:String = "BuildBuyStateData";
      
      protected static var sCurrentLotFreeBuild:int = -1;
      
      protected static var sCurrentLotOwned:int = -1;
      
      protected static var sCurrentLotOwnedByPlayer:int = -1;
      
      protected static var sTickerObj:Object = new Object();
      
      protected static var sCurrentVenueInfo:VenueInfo = null;
      
      protected static var sCurrentVenue:Object = null;
      
      protected static var sCurrentBuildingType:int = -1;
      
      protected static var sRequirementsVenueInfo:VenueInfo = null;
      
      protected static var sGigInfo:GigInfo = null;
      
      protected static var sOwnerId:String = null;
      
      protected static var sEntryPlexValid:Boolean = false;
      
      protected static var sEntryPlexId:uint = 0;
      
      protected static var sUnitDatas:Array = null;
      
      protected static var sHomeUnitExists:int = -1;
      
      protected static var sEntryUnitOccupied:int = -1;
      
      protected static var sVenueNames:Object = null;
      
      public function BuildBuyStateData()
      {
         super();
      }
      
      public static function AddListeners(param1:CommunicationManager) : void
      {
         param1.AddMessageListener("GameStateChanged",HandleGameStateChange,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("GameStateLoadComplete",HandleGameStateLoadComplete,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("UpdateHouseholdMoney",HandleUpdateAvailableFunds,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBHighestWallUpdate",HandleHighestWallUpdate,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBUpdateFoundationHeight",HandleUpdateFoundationHeight,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBHighestLevelWithBlocksUpdate",HandleHighestLevelWithBlocksUpdate,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBHighestBlockLevelUpdate",HandleHighestLevelWithBlocksUpdate,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBRefreshVenueData",HandleRefreshVenueData,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBUpdateMannequinCount",HandleUpdateMannequinCount,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BusinessFundsUpdate",HandleBusinessFundsUpdate,BUILDBUY_STATE_DATA_STRING);
         param1.AddMessageListener("BBRefreshUnitData",HandleRefreshUnitData,BUILDBUY_STATE_DATA_STRING);
         sCommunicationManager = param1;
      }
      
      protected static function AddUnitListeners() : void
      {
         sCommunicationManager.AddMessageListener("BBUpdateUnitData",HandleUpdateUnitData,BUILDBUY_STATE_DATA_STRING);
         sCommunicationManager.AddMessageListener("BBDeleteUnitData",HandleDeleteUnitData,BUILDBUY_STATE_DATA_STRING);
         sCommunicationManager.AddMessageListener("BBUnitOccupantsUpdated",HandleUnitOccupantsUpdated,BUILDBUY_STATE_DATA_STRING);
         sCommunicationManager.AddMessageListener("BBSetEntryUnit",HandleSetEntryUnit,BUILDBUY_STATE_DATA_STRING);
      }
      
      public static function ClearStaticData() : void
      {
         sCurrentLotFreeBuild = -1;
         sCurrentLotOwned = -1;
         sCurrentLotOwnedByPlayer = -1;
         sbIsLotEditable = null;
         sAvailabilityData = null;
         sCurrentVenue = null;
         sCurrentVenueInfo = null;
         sRequirementsVenueInfo = null;
         sCurrentBuildingType = -1;
         sVenueRequirements = null;
         sGigInfo = null;
         sOwnerId = null;
         sEntryPlexValid = false;
         if(sUnitDatas)
         {
            sCommunicationManager.RemoveMessageListener("BBUpdateUnitData",HandleUpdateUnitData,BUILDBUY_STATE_DATA_STRING);
            sCommunicationManager.RemoveMessageListener("BBDeleteUnitData",HandleDeleteUnitData,BUILDBUY_STATE_DATA_STRING);
            sCommunicationManager.RemoveMessageListener("BBUnitOccupantsUpdated",HandleUnitOccupantsUpdated,BUILDBUY_STATE_DATA_STRING);
            sCommunicationManager.RemoveMessageListener("BBSetEntryUnit",HandleSetEntryUnit,BUILDBUY_STATE_DATA_STRING);
         }
         sUnitDatas = null;
         sHomeUnitExists = -1;
         sEntryUnitOccupied = -1;
         sVenueNames = null;
      }
      
      public static function get CurrentVenueInfo() : VenueInfo
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(sCurrentVenueInfo == null)
         {
            _loc1_ = CurrentVenue;
            if(!_loc1_ || !("venueKey" in _loc1_))
            {
               return null;
            }
            _loc2_ = CommunicationManager.CallGameService("BBGetVenueInfo",{"venueKey":_loc1_.venueKey as String});
            if(!_loc2_)
            {
               return null;
            }
            sCurrentVenueInfo = new VenueInfo(_loc2_);
         }
         return sCurrentVenueInfo;
      }
      
      public static function get CurrentVenue() : Object
      {
         if(sCurrentVenue == null)
         {
            sCurrentVenue = CommunicationManager.CallGameService("BBGetCurrentVenue",null);
         }
         return sCurrentVenue;
      }
      
      public static function get RequirementsVenueInfo() : VenueInfo
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(sRequirementsVenueInfo == null)
         {
            _loc1_ = CommunicationManager.CallGameService("BBGetRequirementsVenue");
            if(!_loc1_ || !("venueKey" in _loc1_))
            {
               return null;
            }
            _loc2_ = CommunicationManager.CallGameService("BBGetVenueInfo",{"venueKey":_loc1_.venueKey as String});
            if(!_loc2_)
            {
               return null;
            }
            sRequirementsVenueInfo = new VenueInfo(_loc2_);
         }
         return sRequirementsVenueInfo;
      }
      
      public static function get CurrentLotFreeBuild() : Boolean
      {
         if(sCurrentLotFreeBuild == -1)
         {
            if(CommunicationManager.CallGameService("BBIsLotFreeBuild") as Boolean)
            {
               sCurrentLotFreeBuild = 1;
            }
            else
            {
               sCurrentLotFreeBuild = 0;
            }
         }
         return sCurrentLotFreeBuild == 1;
      }
      
      public static function get IsLotOwned() : Boolean
      {
         if(sCurrentLotOwned == -1)
         {
            if(CommunicationManager.CallGameService("BBIsLotOwned") as Boolean)
            {
               sCurrentLotOwned = 1;
            }
            else
            {
               sCurrentLotOwned = 0;
            }
         }
         return sCurrentLotOwned == 1;
      }
      
      public static function get IsLotOwnedByPlayer() : Boolean
      {
         if(sCurrentLotOwnedByPlayer == -1)
         {
            if(CommunicationManager.CallGameService("BBIsLotOwnedByPlayer") as Boolean)
            {
               sCurrentLotOwnedByPlayer = 1;
            }
            else
            {
               sCurrentLotOwnedByPlayer = 0;
            }
         }
         return sCurrentLotOwnedByPlayer == 1;
      }
      
      public static function get OwnerId() : String
      {
         if(!sOwnerId)
         {
            sOwnerId = CommunicationManager.CallGameService("BBGetPropertyOwner") as String;
         }
         return sOwnerId;
      }
      
      public static function IsHomeUnit(param1:UnitData) : Boolean
      {
         if(!param1.occupied)
         {
            return false;
         }
         if(param1.plexId == EntryPlexId)
         {
            return true;
         }
         if(HomeUnitExists)
         {
            if(sEntryUnitOccupied == 0 && param1.tenantId == OwnerId)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function get HomeUnitExists() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:UnitData = null;
         if(sHomeUnitExists == -1)
         {
            sHomeUnitExists = 0;
            sEntryUnitOccupied = 0;
            _loc1_ = OwnerId;
            _loc2_ = EntryPlexId;
            for each(_loc3_ in UnitDatas)
            {
               if(_loc3_.occupied)
               {
                  if(_loc3_.plexId == _loc2_)
                  {
                     sHomeUnitExists = 1;
                     sEntryUnitOccupied = 1;
                     break;
                  }
                  if(_loc3_.tenantId == _loc1_)
                  {
                     sHomeUnitExists = 1;
                  }
               }
            }
         }
         return sHomeUnitExists == 1;
      }
      
      public static function get HomeUnitIsDefaultUnit() : Boolean
      {
         var _loc3_:UnitData = null;
         var _loc1_:String = OwnerId;
         var _loc2_:uint = CommunicationManager.CallGameService("BBGetDefaultUnit") as uint;
         for each(_loc3_ in UnitDatas)
         {
            if(_loc3_.occupied)
            {
               if(_loc3_.tenantId == _loc1_)
               {
                  return _loc3_.plexId == EntryPlexId && _loc3_.plexId == _loc2_;
               }
            }
         }
         return false;
      }
      
      public static function get EntryPlexId() : uint
      {
         if(!sEntryPlexValid)
         {
            sEntryPlexId = CommunicationManager.CallGameService("BBGetEntryUnit") as uint;
            sEntryPlexValid = true;
         }
         return sEntryPlexId;
      }
      
      public static function HasInactiveHomeUnit() : Boolean
      {
         var _loc2_:UnitData = null;
         var _loc1_:String = OwnerId;
         for each(_loc2_ in UnitDatas)
         {
            if(_loc2_.occupied)
            {
               if(_loc2_.tenantId == _loc1_)
               {
                  return _loc2_.plexId != EntryPlexId;
               }
            }
         }
         return false;
      }
      
      public static function get UnitDatas() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(!sUnitDatas)
         {
            sUnitDatas = new Array();
            _loc1_ = CommunicationManager.CallGameService("BBGetUnitDataList") as Array;
            if(_loc1_)
            {
               _loc1_.sortOn("sortOrder");
               for each(_loc2_ in _loc1_)
               {
                  sUnitDatas.push(new UnitData(_loc2_));
               }
            }
            AddUnitListeners();
         }
         return sUnitDatas;
      }
      
      public static function get PropertyOwnerMode() : Boolean
      {
         return CurrentVenueInfo.IsMultiUnitLot;
      }
      
      public static function HasTenants() : Boolean
      {
         var _loc2_:UnitData = null;
         var _loc1_:String = OwnerId;
         for each(_loc2_ in UnitDatas)
         {
            if(_loc2_.occupied && _loc2_.tenantId != _loc1_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function HasOtherOccupants() : Boolean
      {
         var _loc1_:UnitData = null;
         for each(_loc1_ in UnitDatas)
         {
            if(_loc1_.occupied && _loc1_.plexId != EntryPlexId)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function get SmallBusinessMode() : Boolean
      {
         return CurrentVenueInfo.AllowsSmallBusiness && GameContent.HAS_EP18;
      }
      
      public static function get IsLotEditable() : Boolean
      {
         var _loc1_:Object = null;
         if(sbIsLotEditable == null)
         {
            _loc1_ = CommunicationManager.CallGameService("IsLotEditable");
            if(_loc1_)
            {
               sbIsLotEditable = true;
            }
            else
            {
               sbIsLotEditable = false;
            }
         }
         return Boolean(sbIsLotEditable);
      }
      
      public static function get CurrentBuildingType() : int
      {
         if(sCurrentBuildingType == -1)
         {
            sCurrentBuildingType = CommunicationManager.CallGameService("BBGetBuildingType") as int;
         }
         return sCurrentBuildingType;
      }
      
      public static function get PurchaseAvailability() : PurchaseAvailabilityData
      {
         var _loc1_:PurchaseAvailabilityData = null;
         var _loc2_:HouseholdData = null;
         var _loc3_:BusinessData = null;
         var _loc4_:VenueInfo = null;
         if(sAvailabilityData == null)
         {
            _loc1_ = new PurchaseAvailabilityData();
            _loc2_ = new HouseholdData(CommunicationManager.CallGameService("GetFamilyInfo"));
            _loc3_ = new BusinessData(CommunicationManager.CallGameService("GetBusinessDataWithZoneId",GameplayStateData.CurrentZoneId));
            _loc4_ = CurrentVenueInfo;
            if(IsLotOwnedByPlayer && (Boolean(_loc4_) && Boolean(!(_loc4_.IsResidentialType || _loc4_.AllowsSmallBusiness))))
            {
               if(_loc3_)
               {
                  _loc1_.availableFunds = _loc3_.funds;
               }
               else
               {
                  _loc1_.availableFunds = 0;
               }
            }
            else
            {
               _loc1_.availableFunds = _loc2_.familyFunds;
            }
            _loc1_.bWorldBuilder = CommunicationManager.CallGameService("IsWorldbuilder") as Boolean;
            _loc1_.bFreeBuild = CurrentLotFreeBuild || Boolean(GetGigInfo());
            _loc1_.highestLevelWithBlocks = CommunicationManager.CallGameService("BBGetMaxLevelWithBlocks") as int;
            _loc1_.highestWallHeight = CommunicationManager.CallGameService("BBGetMaxWallHeight") as int;
            _loc1_.highestLeveLHeight = CommunicationManager.CallGameService("BBGetMaxLevelHeight") as int;
            _loc1_.foundationHeight = CommunicationManager.CallGameService("BBGetFoundationHeight") as Number;
            _loc1_.mannequinExcessCount = CommunicationManager.CallGameService("BBGetMannequinExcessCount") as int;
            sAvailabilityData = _loc1_;
         }
         return sAvailabilityData;
      }
      
      public static function GetCurrentVenueRequirements(param1:Boolean = false) : Object
      {
         var _loc2_:VenueInfo = null;
         if(sVenueRequirements == null || param1)
         {
            _loc2_ = CurrentVenueInfo;
            if(_loc2_)
            {
               sVenueRequirements = CommunicationManager.CallGameService("BBGetVenueRequirements",{"venueKey":_loc2_.tagKey});
            }
         }
         return sVenueRequirements;
      }
      
      public static function GetGigInfo(param1:Boolean = false) : GigInfo
      {
         var _loc2_:VenueInfo = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(sGigInfo == null || param1)
         {
            _loc2_ = CurrentVenueInfo;
            if(_loc2_)
            {
               _loc3_ = GetCurrentVenueRequirements(param1);
               if(Boolean(_loc3_) && "lot_build_buy_gig_infos" in _loc3_)
               {
                  _loc4_ = _loc3_["lot_build_buy_gig_infos"] as Array;
                  if(_loc4_.length > 0)
                  {
                     sGigInfo = new GigInfo(_loc4_[0].gig_info);
                  }
               }
            }
         }
         return sGigInfo;
      }
      
      protected static function SendAvailabilityUpdateMessage() : void
      {
         if(Ticker.Has(sTickerObj))
         {
            return;
         }
         Ticker.Add(sTickerObj,1,BuildBuyStateData.HandleAvailabilityTicker);
      }
      
      protected static function HandleAvailabilityTicker(param1:TickerEvent) : void
      {
         sCommunicationManager.SendUIMessage(PURCHASE_AVAILABILITY_UPDATE,null);
      }
      
      public static function GetVenueName(param1:String) : LocKey
      {
         if(sVenueNames == null)
         {
            sVenueNames = new Object();
         }
         else if(param1 in sVenueNames)
         {
            return sVenueNames[param1];
         }
         var _loc2_:VenueInfo = new VenueInfo(CommunicationManager.CallGameService("BBGetVenueInfo",{"venueKey":param1}));
         sVenueNames[param1] = _loc2_.nameKey;
         return _loc2_.nameKey;
      }
      
      protected static function HandleGameStateChange(param1:Object) : void
      {
         ClearStaticData();
      }
      
      protected static function HandleGameStateLoadComplete(param1:Object) : void
      {
         sCurrentVenue = null;
         sCurrentVenueInfo = null;
         sCommunicationManager.SendUIMessage("BBVenueInfoUpdate",null);
      }
      
      protected static function HandleUpdateAvailableFunds(param1:SetMoney) : void
      {
         if(param1.reason == SetMoney.REASON_UNDEFINED || sAvailabilityData == null || sAvailabilityData.availableFunds == param1.currentSimoleons || IsLotOwnedByPlayer && CurrentVenueInfo.IsRetailLot)
         {
            return;
         }
         sAvailabilityData.availableFunds = param1.currentSimoleons;
         SendAvailabilityUpdateMessage();
      }
      
      protected static function HandleHighestLevelWithBlocksUpdate(param1:int) : void
      {
         if(Boolean(sAvailabilityData) && sAvailabilityData.highestLevelWithBlocks != param1)
         {
            sAvailabilityData.highestLevelWithBlocks = param1;
            SendAvailabilityUpdateMessage();
         }
      }
      
      protected static function HandleHighestWallUpdate(param1:int) : void
      {
         if(sAvailabilityData)
         {
            sAvailabilityData.highestLeveLHeight = CommunicationManager.CallGameService("BBGetMaxLevelHeight",null) as int;
            sAvailabilityData.highestLevelWithBlocks = CommunicationManager.CallGameService("BBGetMaxLevelWithBlocks",null) as int;
            sAvailabilityData.highestWallHeight = param1;
            SendAvailabilityUpdateMessage();
         }
      }
      
      protected static function HandleUpdateFoundationHeight(param1:Number) : void
      {
         if(!sAvailabilityData)
         {
            sAvailabilityData = PurchaseAvailability;
            SendAvailabilityUpdateMessage();
            return;
         }
         if(sAvailabilityData.foundationHeight != param1)
         {
            sAvailabilityData.foundationHeight = param1;
            SendAvailabilityUpdateMessage();
         }
      }
      
      protected static function HandleRefreshVenueData(param1:Object = null) : void
      {
         sCurrentVenue = null;
         sCurrentVenueInfo = null;
         sCommunicationManager.SendUIMessage("BBVenueInfoUpdate",null);
      }
      
      protected static function HandleUpdateMannequinCount(param1:int) : void
      {
         if(sAvailabilityData)
         {
            sAvailabilityData.mannequinExcessCount = param1;
            SendAvailabilityUpdateMessage();
         }
      }
      
      protected static function HandleBusinessFundsUpdate(param1:Object) : void
      {
         if(!(IsLotOwnedByPlayer || !(CurrentVenueInfo.IsResidentialType || CurrentVenueInfo.AllowsSmallBusiness)))
         {
            return;
         }
         PurchaseAvailability.availableFunds = param1.available_funds as int;
         SendAvailabilityUpdateMessage();
      }
      
      protected static function HandleRefreshUnitData(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Array = param1 as Array;
         if(!_loc2_)
         {
            return;
         }
         _loc2_.sortOn("sortOrder");
         sHomeUnitExists = -1;
         sEntryUnitOccupied = -1;
         sUnitDatas = new Array();
         for each(_loc3_ in _loc2_)
         {
            sUnitDatas.push(new UnitData(_loc3_));
         }
         AddUnitListeners();
         sCommunicationManager.SendUIMessage("BBUnitDataRefreshed");
      }
      
      protected static function HandleUnitOccupantsUpdated(param1:Object) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:UnitData = null;
         var _loc2_:Array = param1 as Array;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:uint = _loc2_.length;
         if(_loc3_ != sUnitDatas.length)
         {
            HandleRefreshUnitData(param1);
            return;
         }
         _loc2_.sortOn("sortOrder");
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = uint(_loc2_[_loc5_]["plexId"]);
            if(sUnitDatas[_loc5_].plexId != _loc6_)
            {
               HandleRefreshUnitData(param1);
               return;
            }
            _loc7_ = _loc2_[_loc5_]["tenantId"] as String;
            if(sUnitDatas[_loc5_].tenantId != _loc7_)
            {
               sUnitDatas[_loc5_].tenantId = _loc7_;
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         if(_loc4_.length > 0)
         {
            if(sHomeUnitExists != -1 || sEntryUnitOccupied != -1)
            {
               _loc8_ = HomeUnitExists;
               sHomeUnitExists = -1;
               sEntryUnitOccupied = -1;
               if(_loc8_ != HomeUnitExists)
               {
                  _loc4_.length = 0;
                  for each(_loc9_ in sUnitDatas)
                  {
                     _loc4_.push(_loc9_.plexId);
                  }
               }
            }
            sCommunicationManager.SendUIMessage("BBUOccupantUpdatedPlexIds",_loc4_);
         }
      }
      
      protected static function HandleSetEntryUnit(param1:Object) : void
      {
         var _loc2_:uint = param1 as uint;
         sEntryPlexValid = true;
         if(sEntryPlexId != _loc2_)
         {
            sHomeUnitExists = -1;
            sEntryUnitOccupied = -1;
            sEntryPlexId = _loc2_;
            sCommunicationManager.SendUIMessage("BBUnitDataRefreshed");
         }
      }
      
      protected static function HandleUpdateUnitData(param1:Object) : void
      {
         var _loc2_:UnitData = new UnitData(param1);
         var _loc3_:int = 0;
         while(_loc3_ < sUnitDatas.length)
         {
            if(sUnitDatas[_loc3_].sortOrder == _loc2_.sortOrder)
            {
               sUnitDatas[_loc3_] = _loc2_;
               return;
            }
            _loc3_++;
         }
         sUnitDatas.push(_loc2_);
         sCommunicationManager.SendUIMessage("BBUnitCountChanged");
      }
      
      protected static function HandleDeleteUnitData(param1:Object) : void
      {
         var _loc2_:uint = param1 as uint;
         var _loc3_:int = 0;
         while(_loc3_ < sUnitDatas.length)
         {
            if(sUnitDatas[_loc3_].plexId == _loc2_)
            {
               sUnitDatas.splice(_loc3_,1);
               sCommunicationManager.SendUIMessage("BBUnitCountChanged");
               return;
            }
            _loc3_++;
         }
      }
   }
}

