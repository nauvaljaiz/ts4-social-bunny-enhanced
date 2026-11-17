package gamedata.GameEntry.shared
{
   import gamedata.GameEntry.Neighborhood.NeighborhoodData;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.GameEntry.Neighborhood.TravelGroupData;
   import olympus.constants.GameStateFlags;
   import olympus.constants.GameStates;
   import olympus.core.UISettings;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   import widgets.GameEntry.HouseholdPanel.constants.HouseholdPanelModes;
   import widgets.GameEntry.shared.HouseholdUtils;
   import widgets.shared.GENeighborhoodStateManager;
   import widgets.shared.constants.GENeighborhoodMode;
   
   public class NeighborhoodStateData
   {
      
      protected static var sAllNeighborhoodData:Object;
      
      protected static var sTravelGroups:TravelGroups;
      
      protected static var sActiveHouseholdData:HouseholdData;
      
      protected static var sLastPlayedHouseholdData:HouseholdData;
      
      protected static var sInitializationData:Object;
      
      public static const HOUSELESS_NHD_ID:String = "0";
      
      public static const ALL_NEIGHBORHOOD_STATE_DATA_LOADED:String = "AllNeighborhoodDataLoaded";
      
      public static const SINGLE_NEIGHBORHOOD_STATE_DATA_UPDATED:String = "SingleNeighborhoodDataLoaded";
      
      protected static const NEIGHBORHOOD_STATE_DATA_STRING:String = "NeighborhoodStateData";
      
      protected static var sbNeighborhoodDataRequested:Boolean = false;
      
      public function NeighborhoodStateData()
      {
         super();
      }
      
      public static function AddListeners(param1:CommunicationManager) : void
      {
         param1.AddMessageListener("GameStateChanged",HandleGameStateChange,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("NeighborhoodDataMessage",HandleNeighborhoodDataMessage,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("SingleNeighborhoodDataMessage",HandleSingleNeighborhoodDataMessage,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("TravelGroupUpdated",HandleTravelGroupUpdated,NEIGHBORHOOD_STATE_DATA_STRING,TravelGroupData);
         param1.AddMessageListener("TravelGroupDeleted",HandleTravelGroupDeleted,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("TravelListUpdated",HandleTravelListUpdated,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("PlaceShareItem",HandlePlaceShareItem,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("SetFreeRealEstate",HandleSetFreeRealEstate,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("HideTransitionScreen",HandleHideTransitionScreen,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("MoveOutComplete",HandleMoveComplete,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("LotUpdated",HandleLotUpdated,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.AddMessageListener("HouseholdUpdated",HandleHouseholdUpdated,NEIGHBORHOOD_STATE_DATA_STRING,HouseholdData);
         param1.AddMessageListener("HouseholdDeleted",HandleHouseholdDeleted,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("CanApplyExchangeItem",HandleCanApplyExchangeItem,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("GetNeighborhoodByLot",HandleGetNeighborhoodByLot,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("GetNeighborhoodDataById",HandleGetNeighborhoodDataById,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("GetNeighborhoodDataList",HandleGetNeighborhoodDataList,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("GetNeighborhoodLotData",HandleGetNeighborhoodLotData,NEIGHBORHOOD_STATE_DATA_STRING);
         param1.RegisterServiceHandler("GetNeighborhoodName",HandleGetNeighborhoodName,NEIGHBORHOOD_STATE_DATA_STRING);
      }
      
      public static function get AllNeighborhoodData() : Object
      {
         if(!sAllNeighborhoodData && !sbNeighborhoodDataRequested)
         {
            CommunicationManager.CallGameService("RequestNeighborhoodData");
            sbNeighborhoodDataRequested = true;
         }
         return sAllNeighborhoodData;
      }
      
      public static function get ActiveHouseholdData() : HouseholdData
      {
         var _loc1_:Object = null;
         if(!sActiveHouseholdData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetFamilyInfo");
            if(_loc1_)
            {
               sActiveHouseholdData = new HouseholdData(_loc1_);
            }
         }
         return sActiveHouseholdData;
      }
      
      public static function get LastPlayedHouseholdData() : HouseholdData
      {
         var _loc1_:Object = null;
         if(!sLastPlayedHouseholdData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetLastPlayedFamilyInfo");
            if(_loc1_)
            {
               sLastPlayedHouseholdData = new HouseholdData(_loc1_);
            }
         }
         return sLastPlayedHouseholdData;
      }
      
      public static function GetNeighborhoodIds(param1:Boolean, param2:Boolean) : Array
      {
         var _loc5_:NeighborhoodData = null;
         var _loc6_:String = null;
         var _loc3_:Array = new Array();
         var _loc4_:Object = AllNeighborhoodData;
         if(!_loc4_)
         {
            return _loc3_;
         }
         if(param2)
         {
            _loc3_.push(HOUSELESS_NHD_ID);
         }
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.IsPlayerFacingNeighborhood)
            {
               _loc6_ = _loc5_.id;
               if(!(!param1 && RegionDescription.IsVacationWorld(_loc6_)))
               {
                  _loc3_.push(_loc6_);
               }
            }
         }
         return _loc3_;
      }
      
      public static function get InitializationData() : Object
      {
         return sInitializationData;
      }
      
      public static function get AllTravelGroups() : TravelGroups
      {
         return sTravelGroups;
      }
      
      public static function GetTravelGroupSims(param1:String, param2:int) : Array
      {
         return sTravelGroups.GetTravelGroupSims(param1,param2);
      }
      
      public static function GetTravelGroupSimNames(param1:String, param2:int) : String
      {
         var _loc5_:String = null;
         var _loc3_:String = "";
         var _loc4_:Array = sTravelGroups.GetTravelGroupSims(param1,param2);
         for each(_loc5_ in _loc4_)
         {
            _loc3_ += "\t" + Keys.GENERIC_SIM_NAME.toString({"simId":_loc5_}) + "\n";
         }
         return _loc3_;
      }
      
      public static function ShutDownStateManagers() : void
      {
         ClearCache();
         GENeighborhoodStateManager.Shutdown();
      }
      
      protected static function UpdateTravelGroup(param1:TravelGroupData, param2:Boolean = false) : void
      {
         var _loc3_:NeighborhoodLotData = CommunicationManager.CallUIService("GetNeighborhoodLotData",param1.zone_id) as NeighborhoodLotData;
         var _loc4_:TravelGroupData = sTravelGroups.TravelGroupDatas[param1.travel_group_id];
         if(!param2 && Boolean(_loc4_))
         {
            _loc4_.Update(param1);
            _loc3_.UpdateOwner(_loc3_.lotOwnerId,_loc3_.regionId);
         }
         else
         {
            if(_loc3_)
            {
               _loc3_.UpdateTravelGroups(param1);
            }
            sTravelGroups.AddOrReplace(param1);
         }
         CommunicationManager.SendUIMessage("UpdateLotClip",param1.zone_id);
      }
      
      protected static function HandleGetNeighborhoodByLot(param1:String) : NeighborhoodData
      {
         var _loc3_:NeighborhoodData = null;
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return null;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.GetLotByInstanceId(param1))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected static function HandleGetNeighborhoodDataById(param1:String) : NeighborhoodData
      {
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_[param1];
      }
      
      protected static function HandleGetNeighborhoodDataList() : Array
      {
         var _loc3_:NeighborhoodData = null;
         var _loc1_:Array = new Array();
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return _loc1_;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.IsPlayerFacingNeighborhood)
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      protected static function HandleGetNeighborhoodLotData(param1:String) : NeighborhoodLotData
      {
         var _loc3_:NeighborhoodData = null;
         var _loc4_:NeighborhoodLotData = null;
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return null;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.GetLotByInstanceId(param1);
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      protected static function HandleGetNeighborhoodName(param1:String) : String
      {
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:NeighborhoodData = _loc2_[param1] as NeighborhoodData;
         if(_loc3_)
         {
            return _loc3_.name;
         }
         return null;
      }
      
      protected static function HandleCanApplyExchangeItem() : LocKey
      {
         return GENeighborhoodMode.HUD_BUTTON_DISABLED_TOOLTIPS[GENeighborhoodStateManager.getInstance().Mode];
      }
      
      protected static function HandleGameStateChange(param1:uint) : void
      {
         ClearCache();
         if(param1 == GameStates.TRAVEL || param1 == GameStates.LOT_SELECT)
         {
            CommunicationManager.CallGameService("RequestNeighborhoodData",null);
         }
      }
      
      protected static function HandleTravelGroupUpdated(param1:TravelGroupData) : void
      {
         var _loc2_:String = param1.travel_group_id;
         if(!sTravelGroups || !sTravelGroups.TravelGroupDatas[_loc2_])
         {
            return;
         }
         UpdateTravelGroup(param1);
      }
      
      protected static function HandleTravelGroupDeleted(param1:String) : void
      {
         if(!sTravelGroups || !sTravelGroups.TravelGroupDatas[param1])
         {
            return;
         }
      }
      
      protected static function DeleteTravelGroupID(param1:String) : void
      {
         var _loc2_:TravelGroupData = null;
         _loc2_ = sTravelGroups.TravelGroupDatas[param1];
         var _loc3_:NeighborhoodLotData = HandleGetNeighborhoodLotData(_loc2_.zone_id);
         _loc3_.LotTravelGroups.Remove(param1);
         _loc3_.UpdateOwner(_loc3_.lotOwnerId);
         CommunicationManager.SendUIMessage("UpdateLotClip",_loc2_.zone_id);
         sTravelGroups.Remove(param1);
      }
      
      protected static function HandleTravelListUpdated(param1:Array) : void
      {
         var _loc4_:TravelGroupData = null;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         if(!sTravelGroups)
         {
            sTravelGroups = new TravelGroups();
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TravelGroupData(param1[_loc3_]);
            if(_loc4_.NumHouseholds == 0)
            {
               if(sTravelGroups.TravelGroupDatas[_loc4_.travel_group_id])
               {
                  DeleteTravelGroupID(_loc4_.travel_group_id);
               }
            }
            else
            {
               UpdateTravelGroup(new TravelGroupData(param1[_loc3_]),true);
            }
            _loc3_++;
         }
      }
      
      protected static function HandleSingleNeighborhoodDataMessage(param1:Object) : void
      {
         var _loc2_:NeighborhoodData = new NeighborhoodData(param1);
         if(sAllNeighborhoodData == null)
         {
            sAllNeighborhoodData = new Object();
         }
         sAllNeighborhoodData[_loc2_.id] = _loc2_;
         CommunicationManager.SendUIMessage(SINGLE_NEIGHBORHOOD_STATE_DATA_UPDATED,_loc2_.id);
      }
      
      protected static function HandleNeighborhoodDataMessage(param1:Object) : void
      {
         var _loc5_:NeighborhoodData = null;
         var _loc7_:Array = null;
         var _loc11_:TravelGroupData = null;
         var _loc12_:NeighborhoodLotData = null;
         var _loc2_:Object = new Object();
         var _loc3_:Array = param1.nhdData as Array;
         var _loc4_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = new NeighborhoodData(_loc3_[_loc6_]);
            _loc2_[_loc5_.id] = _loc5_;
            _loc6_++;
         }
         sAllNeighborhoodData = _loc2_;
         sbNeighborhoodDataRequested = false;
         _loc7_ = param1.travelGroupData;
         var _loc8_:int = int(_loc7_.length);
         var _loc9_:TravelGroups = new TravelGroups();
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc11_ = new TravelGroupData(_loc7_[_loc6_]);
            _loc12_ = HandleGetNeighborhoodLotData(_loc11_.zone_id);
            _loc12_.UpdateTravelGroups(_loc11_);
            _loc9_.AddOrReplace(_loc11_);
            _loc6_++;
         }
         sTravelGroups = _loc9_;
         var _loc10_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(_loc10_)
         {
            sInitializationData = _loc10_.InitializeNhdStateManager();
         }
         CommunicationManager.SendUIMessage(ALL_NEIGHBORHOOD_STATE_DATA_LOADED);
      }
      
      public static function IsNeighborhoodStateDataLoaded() : Boolean
      {
         return sAllNeighborhoodData != null;
      }
      
      protected static function HandlePlaceShareItem(param1:Object) : void
      {
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         _loc2_.ConfigurePlaceShareItem(param1);
      }
      
      protected static function HandleSetFreeRealEstate(param1:Boolean) : void
      {
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(!_loc2_)
         {
            return;
         }
         _loc2_.IsFreeRealEstate = param1;
      }
      
      protected static function HandleHideTransitionScreen(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(_loc2_)
         {
            if(_loc2_.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_MOVE_HH))
            {
               _loc2_.ConfigureCasMoveInHousehold();
            }
            else if(_loc2_.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH))
            {
               _loc2_.ConfigureCasAddHousehold();
            }
         }
         var _loc3_:Boolean = UISettings.SessionSettings.GetValue("scenarios.shouldOpenHouseholdPanel","scenarios") as Boolean;
         if(_loc3_)
         {
            _loc4_ = CommunicationManager.CallGameService("GetCurrentScenario") as String;
            if(_loc4_)
            {
               _loc5_ = CommunicationManager.CallGameService("GetGameState") as uint;
               if(_loc5_ == GameStates.LOT_SELECT)
               {
                  CommunicationManager.SendUIMessage("ShowGameEntryHouseholdPanel",{
                     "mode":HouseholdPanelModes.MODE_SCENARIO,
                     "scenarioId":_loc4_,
                     "delayFocusUntilMapLoad":SystemUtils.UsingController
                  });
               }
            }
            else
            {
               UISettings.SessionSettings.SetValue("scenarios.shouldOpenHouseholdPanel",false,"scenarios");
            }
         }
      }
      
      protected static function HandleMoveComplete(param1:Object) : void
      {
         var _loc2_:String = param1["householdId"] as String;
         var _loc3_:String = param1["lotId"] as String;
         var _loc4_:NeighborhoodLotData = HandleGetNeighborhoodLotData(_loc3_);
         if(_loc4_)
         {
            _loc4_.UpdateOwner(_loc2_);
         }
         var _loc5_:HouseholdData = ActiveHouseholdData;
         if((Boolean(_loc5_)) && _loc3_ == _loc5_.familyLotId)
         {
            sActiveHouseholdData = null;
         }
      }
      
      protected static function HandleLotUpdated(param1:Object) : void
      {
         var _loc4_:NeighborhoodData = null;
         var _loc2_:Object = AllNeighborhoodData;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:NeighborhoodLotData = new NeighborhoodLotData(param1);
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.UpdateLot(_loc3_))
            {
               return;
            }
         }
      }
      
      protected static function HandleHouseholdUpdated(param1:HouseholdData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:NeighborhoodLotData = null;
         var _loc6_:TravelGroupData = null;
         if(!param1.IsHomeless)
         {
            UpdateLotOwner(param1.familyLotId,param1.familyId);
            _loc3_ = HouseholdUtils.GetOwnedBusinessZoneIds(param1.familyId);
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = HandleGetNeighborhoodLotData(_loc4_);
               if(!((Boolean(_loc5_)) && _loc5_.IsMultiUnitBuilding))
               {
                  UpdateLotOwner(_loc4_,param1.familyId);
               }
            }
         }
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(Boolean(param1.isNPC && _loc2_) && Boolean(_loc2_.ActiveHousehold) && _loc2_.ActiveHousehold.familyId == param1.familyId)
         {
            _loc2_.ActiveHousehold = null;
         }
         if(sTravelGroups)
         {
            _loc6_ = sTravelGroups.FindTravelGroup(param1.familyId);
            if((Boolean(_loc6_)) && (_loc6_.isPlayerProtected != param1.isPlayerProtected || _loc6_.played == param1.isNPC))
            {
               CommunicationManager.CallGameService("ModifyTravelGroupData",{
                  "travelGroupId":_loc6_.travel_group_id,
                  "bPlayed":!param1.isNPC
               });
            }
         }
      }
      
      protected static function UpdateLotOwner(param1:String, param2:String) : void
      {
         var _loc3_:NeighborhoodLotData = HandleGetNeighborhoodLotData(param1);
         if(_loc3_)
         {
            _loc3_.UpdateOwner(param2);
         }
      }
      
      protected static function HandleHouseholdDeleted(param1:Object) : void
      {
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(Boolean(_loc2_) && Boolean(_loc2_.ActiveHousehold) && _loc2_.ActiveHousehold.familyId == param1.householdId)
         {
            _loc2_.ActiveHousehold = null;
         }
      }
      
      protected static function ClearCache() : void
      {
         sAllNeighborhoodData = null;
         sLastPlayedHouseholdData = null;
         sActiveHouseholdData = null;
         sTravelGroups = null;
         sInitializationData = null;
         sbNeighborhoodDataRequested = false;
      }
   }
}

