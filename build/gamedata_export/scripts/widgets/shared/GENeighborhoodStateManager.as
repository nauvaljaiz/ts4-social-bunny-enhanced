package widgets.shared
{
   import gamedata.Exchange.ExchangeData;
   import gamedata.GameEntry.Neighborhood.NeighborhoodData;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.GameEntry.Neighborhood.ShowMapView;
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.GameEntry.shared.NeighborhoodStateData;
   import gamedata.GameEntry.shared.RegionDescription;
   import gamedata.Gameplay.Pickers.UiDialogPicker;
   import olympus.audio.Audio;
   import olympus.constants.GameStateFlags;
   import olympus.constants.GameStates;
   import olympus.core.UISettings;
   import olympus.io.CommunicationManager;
   import olympus.io.EventManager;
   import olympus.io.TelemetryAttribute;
   import olympus.io.TelemetryManager;
   import olympus.utils.SystemUtils;
   import widgets.GameEntry.constants.HouseholdFilterSortOption;
   import widgets.GameEntry.shared.HouseholdUtils;
   import widgets.shared.constants.GENeighborhoodMode;
   
   public class GENeighborhoodStateManager
   {
      
      protected static var sInstance:GENeighborhoodStateManager;
      
      public var mWorldDescriptionIds:Array = new Array();
      
      protected var mMode:int;
      
      protected var mPreviousMode:int;
      
      protected var mOverrideFlags:uint;
      
      protected var mActiveHousehold:HouseholdData;
      
      protected var mActiveSimLotInstanceId:String;
      
      protected var mActiveNeighborhood:NeighborhoodData;
      
      protected var mPendingExchangeItem:ExchangeData;
      
      protected var mbFreeRealEstate:Boolean;
      
      protected var mShowMapView:ShowMapView;
      
      protected var mTelemetryData:Array;
      
      public function GENeighborhoodStateManager(param1:uint, param2:ShowMapView)
      {
         super();
         this.mMode = GENeighborhoodMode.EDIT;
         this.mPreviousMode = GENeighborhoodMode.NONE;
         this.mOverrideFlags = param1;
         this.mActiveHousehold = null;
         this.mbFreeRealEstate = false;
         this.mShowMapView = param2;
         this.mTelemetryData = null;
      }
      
      public static function getInstance() : GENeighborhoodStateManager
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:ShowMapView = null;
         if(sInstance == null)
         {
            _loc1_ = CommunicationManager.CallGameService("GetGameState",null) as uint;
            if(_loc1_ == GameStates.LOT_SELECT || _loc1_ == GameStates.TRAVEL)
            {
               _loc2_ = CommunicationManager.CallGameService("RequestGameStateFlags",null) as uint;
               _loc3_ = new ShowMapView(CommunicationManager.CallGameService("RequestShowMapViewMessage"));
               sInstance = new GENeighborhoodStateManager(_loc2_,_loc3_);
            }
         }
         return sInstance;
      }
      
      public static function Shutdown() : void
      {
         sInstance = null;
      }
      
      public function get Mode() : int
      {
         return this.mMode;
      }
      
      public function set Mode(param1:int) : void
      {
         this.PreviousMode = this.mMode;
         this.mMode = param1;
         if(this.mMode == GENeighborhoodMode.EDIT)
         {
            this.mPendingExchangeItem = null;
         }
         CommunicationManager.SendUIMessage("GENeighborhoodModeChanged",param1);
      }
      
      public function get PreviousMode() : int
      {
         return this.mPreviousMode;
      }
      
      public function set PreviousMode(param1:int) : void
      {
         this.mPreviousMode = param1;
      }
      
      public function get ActiveHousehold() : HouseholdData
      {
         return this.mActiveHousehold;
      }
      
      public function set ActiveHousehold(param1:HouseholdData) : void
      {
         this.mActiveHousehold = param1;
         if(param1)
         {
            CommunicationManager.SendUIMessage("UpdateHouseholdMoney",{
               "householdId":param1.familyId,
               "currentSimoleons":param1.familyFunds,
               "reason":0
            });
            CommunicationManager.SendMessage("SetActiveFamilyId",param1.familyId);
         }
         else
         {
            CommunicationManager.SendMessage("SetActiveFamilyId",0);
         }
      }
      
      public function get ActiveSimLotInstanceId() : String
      {
         return this.mActiveSimLotInstanceId;
      }
      
      public function set ActiveSimLotInstanceId(param1:String) : void
      {
         this.mActiveSimLotInstanceId = param1;
      }
      
      public function get ActiveNeighborhood() : NeighborhoodData
      {
         return this.mActiveNeighborhood;
      }
      
      public function set ActiveNeighborhood(param1:NeighborhoodData) : void
      {
         var _loc2_:NeighborhoodData = this.mActiveNeighborhood;
         this.mActiveNeighborhood = param1;
         if(_loc2_)
         {
            EventManager.AddRawEvent(Audio.HIDE,Audio.GE_NHD_SELECT,_loc2_.regionId);
         }
         if(param1)
         {
            EventManager.AddRawEvent(Audio.SHOW,Audio.GE_NHD_SELECT,param1.regionId);
         }
      }
      
      public function get PendingExchangeItem() : ExchangeData
      {
         return this.mPendingExchangeItem;
      }
      
      public function set PendingExchangeItem(param1:ExchangeData) : void
      {
         this.mPendingExchangeItem = param1;
      }
      
      public function get IsFreeRealEstate() : Boolean
      {
         return this.mbFreeRealEstate;
      }
      
      public function set IsFreeRealEstate(param1:Boolean) : void
      {
         this.mbFreeRealEstate = param1;
         CommunicationManager.SendUIMessage("FreeRealEstateUpdated",this.mMode);
      }
      
      public function get ShowMapViewInfo() : ShowMapView
      {
         return this.mShowMapView;
      }
      
      public function SetFlag(param1:uint) : void
      {
         this.mOverrideFlags |= 1 << param1 - 1;
         CommunicationManager.CallGameService("SetGameStateFlag",{
            "flag":param1,
            "value":true
         });
      }
      
      public function SetFlagValue(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            this.SetFlag(param1);
         }
         else
         {
            this.ClearFlag(param1);
         }
      }
      
      public function ClearFlag(param1:uint) : void
      {
         this.mOverrideFlags &= ~(1 << param1 - 1);
         CommunicationManager.CallGameService("SetGameStateFlag",{
            "flag":param1,
            "value":false
         });
      }
      
      public function IsFlagSet(param1:uint) : Boolean
      {
         return (this.mOverrideFlags & 1 << param1 - 1) != 0;
      }
      
      public function OnCancelClick() : void
      {
         this.ActiveHousehold = null;
         this.Mode = GENeighborhoodMode.EDIT;
         if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_MOVE))
         {
            CommunicationManager.CallGameService("PlayResume");
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_TRAVEL))
         {
            CommunicationManager.CallGameService("SetControlMode",{"mode":GameStates.PLAY});
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_TRAVEL_NO_PICKER) || this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_VACATION) || this.IsFlagSet(GameStateFlags.LOTSELECT_FOR_PURCHASE_VENUE))
         {
            CommunicationManager.CallGameService("PostServerCommand",{
               "command":"ui.dialog.respond",
               "commandArgs":[this.ShowMapViewInfo.dialog_id,int(UiDialogPicker.DIALOG_RESPONSE_CANCEL)]
            });
            CommunicationManager.CallGameService("SetControlMode",{"mode":GameStates.PLAY});
            this.ClearFlag(GameStateFlags.LOTSELECT_FOR_PURCHASE_VENUE);
         }
         this.ClearFlag(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH);
         this.ClearFlag(GameStateFlags.LOTSELECT_FROM_CAS_MOVE_HH);
      }
      
      public function InitializeNhdStateManager() : Object
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:String = UISettings.SessionSettings.GetValue("world.showConstructedLotAnimation","lotselect") as String;
         if(Boolean(_loc3_) && _loc3_ != "0")
         {
            _loc1_ = UISettings.SessionSettings.GetValue("world.lastSelectedNeighborhoodId","lotselect") as String;
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_MAINMENU_EDIT_PREMADE))
         {
            _loc1_ = this.FromCASAddHousehold();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_TUTORIAL) && !this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH))
         {
            _loc1_ = this.ResumeTutorialMode();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_MAINMENU_EDIT))
         {
            _loc1_ = this.FromInGameEdit();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_EDIT_NBHD))
         {
            _loc1_ = this.FromInGameEdit(true);
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_EDIT_WORLD))
         {
            this.FromInGameEdit();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_EDIT_HH))
         {
            _loc1_ = this.FromCASEditHousehold();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH) && !this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_MOVE_HH))
         {
            _loc1_ = this.FromCASAddHousehold();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_MOVE_HH))
         {
            _loc1_ = this.FromCASMoveInHousehold();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_MOVE) || this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_EVICT))
         {
            _loc1_ = this.FromInGameMove();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_TRANSFER))
         {
            _loc1_ = this.FromInGameTransfer();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_TRAVEL))
         {
            _loc1_ = this.FromInGameTravel();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_TRAVEL_NO_PICKER))
         {
            _loc1_ = this.FromInGameTravelNoPicker();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_INGAME_VACATION))
         {
            _loc1_ = this.FromInGameVacation();
            _loc2_ = true;
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_MANAGEWORLDS_BUILD_EDIT))
         {
            _loc1_ = UISettings.SessionSettings.GetValue("world.lastSelectedNeighborhoodId","lotselect") as String;
            if(!_loc1_)
            {
               _loc1_ = this.FromInGameEdit();
            }
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FOR_PURCHASE_VENUE))
         {
            this.FromPurchaseVenueType();
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_REINCARNATION))
         {
            _loc1_ = this.FromInGameReincarnation();
         }
         var _loc4_:NeighborhoodData = _loc1_ ? CommunicationManager.CallUIService("GetNeighborhoodDataById",_loc1_) as NeighborhoodData : null;
         return {
            "initNhdData":_loc4_,
            "bVacationBucket":_loc2_
         };
      }
      
      public function ConfigurePlaceShareItem(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc2_:ExchangeData = param1.item as ExchangeData;
         this.PendingExchangeItem = _loc2_;
         if(_loc2_.type == ExchangeData.TYPE_BLUEPRINT)
         {
            this.Mode = param1.bPlaceAndEdit ? GENeighborhoodMode.PLACE_BLUEPRINT_AND_EDIT : GENeighborhoodMode.PLACE_BLUEPRINT;
            _loc3_ = new Array();
            _loc3_.push(new TelemetryAttribute("srce",param1.source ? param1.source : "exch"));
            _loc3_.push(new TelemetryAttribute("mode",this.mMode));
            _loc3_.push(new TelemetryAttribute("type",ExchangeData.TYPE_BLUEPRINT));
            _loc3_.push(new TelemetryAttribute("loca",_loc2_.bIsSaved));
            _loc3_.push(new TelemetryAttribute("lbin",_loc2_.isPrepopulated));
            _loc3_.push(new TelemetryAttribute("venu",_loc2_.venueKey));
            this.mTelemetryData = _loc3_;
            _loc4_ = _loc2_.venueKey;
            _loc5_ = UISettings.AccountSettings.GetValue("world.seenVenues") as String;
            _loc6_ = _loc5_ ? _loc5_.split(",") : new Array();
            if(_loc6_.indexOf(_loc4_) == -1)
            {
               _loc6_.push(_loc4_);
               _loc5_ = _loc6_.join();
               UISettings.AccountSettings.SetValue("world.seenVenues",_loc5_);
            }
         }
         else
         {
            this.Mode = GENeighborhoodMode.PLACE_HOUSEHOLD;
         }
      }
      
      public function ConfigureCasMoveInHousehold() : void
      {
         var _loc4_:NeighborhoodLotData = null;
         var _loc1_:NeighborhoodData = this.ActiveNeighborhood;
         var _loc2_:HouseholdData = NeighborhoodStateData.ActiveHouseholdData;
         var _loc3_:String = UISettings.SessionSettings.GetValue("world.moveLotId","lotselect") as String;
         if(Boolean(_loc1_ && _loc2_) && Boolean(_loc3_) && _loc3_ != "0")
         {
            _loc4_ = _loc1_.GetLotByInstanceId(_loc3_);
            if(_loc4_)
            {
               this.ActiveHousehold = _loc2_;
               this.Mode = GENeighborhoodMode.MOVE;
               HouseholdUtils.ShowMoveDialog(_loc2_,null,_loc4_);
            }
         }
         else if(this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH))
         {
            this.ClearFlag(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH);
         }
      }
      
      public function ConfigureCasAddHousehold() : void
      {
         var _loc1_:NeighborhoodData = this.ActiveNeighborhood;
         var _loc2_:HouseholdData = NeighborhoodStateData.ActiveHouseholdData;
         if(!_loc2_ && this.IsFlagSet(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH))
         {
            this.ClearFlag(GameStateFlags.LOTSELECT_FROM_CAS_ADD_HH);
         }
      }
      
      public function WriteTelemetry(param1:String, param2:Object, param3:Boolean = false) : void
      {
         if(!this.mTelemetryData)
         {
            this.mTelemetryData = new Array();
         }
         this.mTelemetryData.push(new TelemetryAttribute(param1,param2));
         if(param3)
         {
            TelemetryManager.DispatchTelemetryEvent("GAME","NHDM","FLOW",this.mTelemetryData);
            this.mTelemetryData = null;
         }
      }
      
      protected function FromCASEditHousehold() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.ActiveHouseholdData;
         if(_loc1_)
         {
            CommunicationManager.SendUIMessage("ShowGameEntryHouseholdPanel",{
               "bShowPlayerProtected":_loc1_.isPlayerProtected,
               "delayFocusUntilMapLoad":SystemUtils.UsingController
            });
            return UISettings.SessionSettings.GetValue("world.lastSelectedNeighborhoodId","lotselect") as String;
         }
         return null;
      }
      
      protected function FromCASAddHousehold() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.ActiveHouseholdData;
         if(_loc1_)
         {
            this.ActiveHousehold = _loc1_;
            this.Mode = GENeighborhoodMode.MOVE;
            return UISettings.SessionSettings.GetValue("world.lastSelectedNeighborhoodId","lotselect") as String;
         }
         return null;
      }
      
      protected function FromCASMoveInHousehold() : String
      {
         var _loc1_:String = UISettings.SessionSettings.GetValue("world.lastSelectedNeighborhoodId","lotselect") as String;
         if(_loc1_)
         {
            return _loc1_;
         }
         return null;
      }
      
      protected function FromInGameEdit(param1:Boolean = false) : String
      {
         var _loc2_:String = null;
         this.Mode = GENeighborhoodMode.EDIT;
         _loc2_ = this.AutoLoadHousehold();
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         var _loc3_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         if(!_loc3_)
         {
            return _loc2_;
         }
         this.ActiveHousehold = _loc3_;
         if(!this.ActiveHousehold.IsHomeless)
         {
            _loc2_ = this.ActiveHousehold.FamilyNeighborhoodId;
         }
         if(!param1)
         {
            return _loc2_;
         }
         var _loc4_:Object = this.GetCurrentLocationIdsForLastPlayedSim(_loc3_.familyId);
         if(!_loc4_)
         {
            return _loc2_;
         }
         var _loc5_:NeighborhoodLotData = CommunicationManager.CallUIService("GetNeighborhoodLotData",_loc4_.lotId) as NeighborhoodLotData;
         if((Boolean(_loc5_)) && (RegionDescription.IsVacationWorld(_loc5_.regionId) || _loc5_.IsOccupiedVenue && _loc5_.lotOwnerId == _loc3_.familyId))
         {
            _loc2_ = _loc4_.nhdId;
         }
         return _loc2_;
      }
      
      protected function FromInGameMove() : String
      {
         var _loc4_:* = undefined;
         var _loc1_:HouseholdData = null;
         var _loc2_:String = UISettings.SessionSettings.GetValue("moveOut.movingHouseholdId","lotselect") as String;
         if(_loc2_ != null)
         {
            UISettings.SessionSettings.RemoveKey("moveOut.movingHouseholdId","lotselect");
            _loc4_ = CommunicationManager.CallGameService("GetFamilyInfo",_loc2_);
            if(_loc4_)
            {
               _loc1_ = new HouseholdData(_loc4_);
            }
         }
         if(_loc1_ == null)
         {
            _loc1_ = NeighborhoodStateData.LastPlayedHouseholdData;
         }
         var _loc3_:Object = this.GetCurrentLocationIdsForLastPlayedSim(_loc1_.familyId);
         this.ActiveHousehold = _loc1_;
         this.ActiveSimLotInstanceId = _loc3_.lotId;
         this.Mode = GENeighborhoodMode.MOVE;
         return _loc3_.nhdId;
      }
      
      protected function FromInGameTransfer() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         var _loc2_:Object = this.GetCurrentLocationIdsForLastPlayedSim(_loc1_.familyId);
         this.ActiveHousehold = _loc1_;
         this.ActiveSimLotInstanceId = _loc2_.lotId;
         var _loc3_:String = UISettings.SessionSettings.GetValue("transfer.sourceHouseholdId","lotselect") as String;
         var _loc4_:String = UISettings.SessionSettings.GetValue("transfer.targetHouseholdId","lotselect") as String;
         var _loc5_:HouseholdData = new HouseholdData(CommunicationManager.CallGameService("GetFamilyInfo",_loc3_));
         var _loc6_:HouseholdData = new HouseholdData(CommunicationManager.CallGameService("GetFamilyInfo",_loc4_));
         CommunicationManager.SendUIMessage("ShowTransferPanel",{
            "sourceHousehold":_loc5_,
            "targetHousehold":_loc6_,
            "delayFocusUntilMapLoad":SystemUtils.UsingController
         });
         return _loc2_.nhdId;
      }
      
      protected function FromInGameTravel() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         var _loc2_:Object = this.GetCurrentLocationIdsForLastPlayedSim(_loc1_.familyId);
         this.ActiveHousehold = _loc1_;
         this.ActiveSimLotInstanceId = _loc2_.lotId;
         this.Mode = this.mShowMapView.mode == ShowMapView.CHANGE_VENUE ? GENeighborhoodMode.CHANGE_VENUE : GENeighborhoodMode.TRAVEL;
         return _loc2_.nhdId;
      }
      
      protected function FromInGameTravelNoPicker() : String
      {
         var _loc1_:Object = null;
         var _loc2_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         if(_loc2_)
         {
            _loc1_ = this.GetCurrentLocationIdsForLastPlayedSim(_loc2_.familyId);
         }
         this.ActiveHousehold = _loc2_;
         this.ActiveSimLotInstanceId = _loc1_.lotId;
         this.Mode = this.mShowMapView.mode == ShowMapView.CHANGE_VENUE ? GENeighborhoodMode.CHANGE_VENUE : GENeighborhoodMode.TRAVEL;
         return _loc1_ ? _loc1_.nhdId : null;
      }
      
      protected function FromInGameVacation() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         this.ActiveHousehold = _loc1_;
         this.Mode = GENeighborhoodMode.VACATION;
         return null;
      }
      
      protected function FromInGameReincarnation() : String
      {
         var _loc1_:HouseholdData = null;
         var _loc2_:String = UISettings.SessionSettings.GetValue("reincarnation.movingHouseholdId","lotselect") as String;
         var _loc3_:String = UISettings.SessionSettings.GetValue("reincarnation.sourceZoneId","lotselect") as String;
         UISettings.SessionSettings.RemoveKey("reincarnation.movingHouseholdId","lotselect");
         UISettings.SessionSettings.RemoveKey("reincarnation.sourceZoneId","lotselect");
         var _loc4_:Object = CommunicationManager.CallGameService("GetFamilyInfo",_loc2_);
         _loc1_ = new HouseholdData(_loc4_);
         var _loc5_:NeighborhoodData = CommunicationManager.CallUIService("GetNeighborhoodByLot",_loc3_) as NeighborhoodData;
         this.ActiveHousehold = _loc1_;
         this.Mode = GENeighborhoodMode.REINCARNATION;
         if(_loc5_ == null)
         {
            return null;
         }
         this.ActiveSimLotInstanceId = _loc5_.id;
         if(Boolean(_loc5_) && RegionDescription.IsVacationWorld(_loc5_.regionId))
         {
            return null;
         }
         return _loc5_.id;
      }
      
      protected function FromPurchaseVenueType() : String
      {
         var _loc1_:HouseholdData = NeighborhoodStateData.LastPlayedHouseholdData;
         var _loc2_:Object = this.GetCurrentLocationIdsForLastPlayedSim(_loc1_.familyId);
         this.ActiveHousehold = _loc1_;
         this.ActiveSimLotInstanceId = _loc2_.lotId;
         this.Mode = GENeighborhoodMode.PURCHASE_VENUE;
         return _loc2_.nhdId;
      }
      
      protected function ResumeTutorialMode() : String
      {
         var _loc1_:int = HouseholdFilterSortOption.FILTER_PLAYED_UNPLAYED | HouseholdFilterSortOption.FILTER_INCLUDE_PLAYER_PROTECTED | HouseholdFilterSortOption.FILTER_STORY_PROGRESSION_ALL;
         var _loc2_:Array = CommunicationManager.CallGameService("GetSortedFilteredFamilyList",{
            "sort":HouseholdFilterSortOption.SORT_DATE_CREATED,
            "filterFlags":_loc1_,
            "neighborhoodIds":NeighborhoodStateData.GetNeighborhoodIds(false,true)
         }) as Array;
         var _loc3_:HouseholdData = new HouseholdData(_loc2_.shift());
         if(_loc3_)
         {
            this.ActiveHousehold = _loc3_;
            this.Mode = GENeighborhoodMode.MOVE;
         }
         return null;
      }
      
      protected function GetCurrentLocationIdsForLastPlayedSim(param1:String) : Object
      {
         var _loc3_:NeighborhoodData = null;
         var _loc2_:Object = CommunicationManager.CallGameService("GetFamilyLastPlayedSimInfo",param1);
         if(_loc2_)
         {
            _loc3_ = CommunicationManager.CallUIService("GetNeighborhoodByLot",_loc2_.currentLotId) as NeighborhoodData;
            return {
               "nhdId":(_loc3_ ? _loc3_.id : null),
               "lotId":_loc2_.currentLotId
            };
         }
         return null;
      }
      
      protected function AutoLoadHousehold() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:HouseholdData = null;
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         var _loc1_:String = UISettings.SessionSettings.GetValue("editMode.HouseholdToAutoLoad","lotselect") as String;
         if(_loc1_ != null)
         {
            _loc2_ = UISettings.SessionSettings.GetValue("editMode.SimToControl","lotselect") as String;
            _loc3_ = UISettings.SessionSettings.GetValue("editMode.LotToLoad","lotselect") as String;
            UISettings.SessionSettings.RemoveKey("editMode.HouseholdToAutoLoad","lotselect");
            UISettings.SessionSettings.RemoveKey("editMode.SimToControl","lotselect");
            UISettings.SessionSettings.RemoveKey("editMode.LotToLoad","lotselect");
            _loc5_ = CommunicationManager.CallGameService("GetFamilyInfo",_loc1_);
            if(_loc5_)
            {
               _loc4_ = new HouseholdData(_loc5_);
            }
            _loc6_ = {
               "householdId":_loc4_.familyId,
               "zoneInstanceId":_loc4_.familyLotId
            };
            if(Boolean(_loc2_) && Boolean(_loc2_ != "") && _loc2_ != "0")
            {
               _loc6_.simId = _loc2_;
            }
            if(Boolean(_loc3_) && Boolean(_loc3_ != "") && _loc3_ != "0")
            {
               _loc6_.zoneInstanceId = _loc3_;
            }
            this.ActiveHousehold = _loc4_;
            CommunicationManager.CallGameService("PlayHousehold",_loc6_);
            return _loc4_.FamilyNeighborhoodId;
         }
         return null;
      }
   }
}

