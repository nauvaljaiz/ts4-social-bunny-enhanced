package gamedata.Gameplay.shared
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import gamedata.CAS.shared.CASConfiguration;
   import gamedata.CollectionDisplay.CollectibleItemUpdate;
   import gamedata.CollectionDisplay.CollectionData;
   import gamedata.CollectionDisplay.CollectionItemData;
   import gamedata.Dialog.DynamicSignView;
   import gamedata.GameContent;
   import gamedata.GameEntry.Neighborhood.NeighborhoodData;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.GameEntry.Neighborhood.StreetInfoData;
   import gamedata.GameEntry.Neighborhood.TravelGroupData;
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.GameEntry.shared.RegionDescription;
   import gamedata.GameEntry.shared.TravelGroups;
   import gamedata.GameTray.SetMoney;
   import gamedata.Gameplay.Buffs.BuffInfo;
   import gamedata.Gameplay.Calendar.CalendarEntry;
   import gamedata.Gameplay.FactionReputation.FactionReputationData;
   import gamedata.Gameplay.Persistence.GameSaveLockUnlock;
   import gamedata.Gameplay.ScreenSlam.UiScreenSlamMessage;
   import gamedata.Gameplay.SituationHUD.SituationOutcomeData;
   import gamedata.Gameplay.SituationHUD.SituationStart;
   import gamedata.Gameplay.shared.definitions.AspirationStaticData;
   import gamedata.Gameplay.shared.definitions.AspirationTrackStaticData;
   import gamedata.Gameplay.shared.definitions.BusinessPreset;
   import gamedata.shared.ChallengeNotificationData;
   import gamedata.shared.CurrencyBuckData;
   import gamedata.shared.LiveFestivalEventData;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.RankedStatisticData;
   import gamedata.shared.ResourceKey;
   import gamedata.shared.ScenarioOutcomeData;
   import gamedata.shared.ScenarioStaticData;
   import gamedata.shared.SimAgeTypes;
   import olympus.constants.DialogModality;
   import olympus.constants.GameStateFlags;
   import olympus.constants.GameStates;
   import olympus.core.OlympusObject;
   import olympus.core.UISettings;
   import olympus.dialog.DialogManager;
   import olympus.dialog.DialogRequest;
   import olympus.dialog.IDialog;
   import olympus.io.CommunicationManager;
   import olympus.io.TelemetryManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.objects.RelationshipByIdInfo;
   import olympus.objects.RelationshipDeleteById;
   import olympus.objects.RelationshipInfo;
   import olympus.objects.SimIdentity;
   import olympus.objects.SimPB;
   import olympus.utils.ArrayUtils;
   import widgets.Dialog.constants.GenericDialogOption;
   import widgets.Dialog.data.LocalRequestData;
   import widgets.LiveEvent.data.LiveEventData;
   import widgets.Scenarios.constants.ScenarioTunables;
   import widgets.shared.GENeighborhoodStateManager;
   import widgets.shared.constants.GENeighborhoodMode;
   import widgets.shared.constants.LiveEventSharedTunables;
   import widgets.shared.constants.ScenariosSharedTunables;
   import widgets.shared.constants.SituationSharedTunables;
   import widgets.shared.constants.TelemetryConstants;
   
   public class GameplayStateData
   {
      
      protected static var sPreviousGameState:uint;
      
      protected static var sCurrentGameState:uint;
      
      protected static var sLockUnlockMessage:GameSaveLockUnlock;
      
      protected static var sHouseholdData:HouseholdData;
      
      protected static var sCurrentZoneId:String;
      
      protected static var sCurrentWorldId:String;
      
      protected static var sPrimaryAspirationTrackId:String;
      
      protected static var sUnfinishedBusinessAspirationTrackId:String;
      
      protected static var sActiveHouseholdId:String;
      
      protected static var sActiveSimId:String;
      
      protected static var sSimAgeUpdate:AgeUpdate;
      
      protected static var sSimAgeProgressUpdate:AgeProgressUpdate;
      
      protected static var sAllRankedStatisticProgressUpdates:Vector.<RankedStatisticProgressUpdate>;
      
      protected static var sAllDefaultRankedStatisticProgressUpdates:Dictionary;
      
      protected static var sAllRelationshipInfo:Vector.<RelationshipInfo>;
      
      protected static var sAllBuffInfo:Vector.<BuffInfo>;
      
      protected static var sCurrentWhims:Object;
      
      protected static var sAllSkillInfo:Vector.<SimSkillInfo>;
      
      protected static var sAllSkillProgressUpdates:Vector.<SkillProgressUpdate>;
      
      protected static var sAllTraitTypeMap:Object;
      
      protected static var sAllTraitIds:Array;
      
      protected static var sSimIdentity:SimIdentity;
      
      protected static var sSimOccultUpdate:OccultUpdate;
      
      protected static var sSelectableSims:Array;
      
      protected static var sCurrentMood:MoodUpdate;
      
      protected static var sHouseholdCollection:CollectionData;
      
      protected static var sHouseholdBuckFunds:Object;
      
      protected static var sActiveSimBuckFunds:Object;
      
      protected static var sActiveSimGatheringClubId:String;
      
      protected static var sCurrentSituations:Array;
      
      protected static var sActiveHoliday:SendActiveHolidayInfo;
      
      protected static var sAllCareerInfo:Vector.<CareerInfo>;
      
      protected static var sAllAspirationUpdateInfo:AspirationUpdate;
      
      protected static var sCurrentAspiration:AspirationInfo;
      
      protected static var sAllUnfinishedBusinessAspirationUpdateInfo:UnfinishedBusinessAspirationUpdate;
      
      protected static var sCurrentUnfinishedBusinessAspiration:AspirationInfo;
      
      protected static var sCurrentAspirationTrack:AspirationTrackInfo;
      
      protected static var sCurrentUnfinishedBusinessAspirationTrack:AspirationTrackInfo;
      
      protected static var sFullCareerInfo:FullCareerInfo;
      
      protected static var sGoHomeInteraction:String;
      
      protected static var sCurrentRegionDescriptionId:String;
      
      protected static var sCurrentActiveLiveFestivalEvent:LiveFestivalEventData;
      
      protected static var sDynamicSignShowArgs:Object;
      
      protected static var sDelayedSituationOutcome:SituationOutcomeData;
      
      protected static var sCustomBusinessPresets:Array;
      
      protected static var sTravelGroups:TravelGroups;
      
      protected static const GAMEPLAY_STATE_DATA_STRING:String = "GameplayStateData";
      
      protected static const VALUE_REQUIRES_UPDATE:int = -1;
      
      protected static const BATUU_REGION_ID:String = "239546";
      
      protected static const SIXAM_REGION_ID:String = "72481";
      
      public static const TRAVELGROUPS_UPDATED:String = "Travelgroups_Updated";
      
      protected static var sAllAchievementObjectiveInfo:Object = new Object();
      
      protected static var sSimGender:int = VALUE_REQUIRES_UPDATE;
      
      protected static var sSimSpecies:int = VALUE_REQUIRES_UPDATE;
      
      protected static var sSimIsGhost:Boolean = false;
      
      protected static var sSatisfactionPoints:int = VALUE_REQUIRES_UPDATE;
      
      protected static var sAllAspirationInfo:Object = new Object();
      
      protected static var sAllObjectiveInfo:Object = new Object();
      
      protected static var sAllUnfinishedBusinessObjectiveInfo:Object = new Object();
      
      protected static var sAllSavedAspirationUpdate:AspirationUpdate = new AspirationUpdate(new Object());
      
      protected static var sAllSavedUnfinishedBusinessAspirationUpdate:UnfinishedBusinessAspirationUpdate = new UnfinishedBusinessAspirationUpdate(new Object());
      
      protected static var sAllSavedObjectivesUpdate:Array = new Array();
      
      protected static var sCurrentRegionCurrencyBucksType:uint = uint.MAX_VALUE;
      
      protected static var sIsNewPlayerGuidanceActive:Boolean = false;
      
      protected static var sLuckLevel:int = VALUE_REQUIRES_UPDATE;
      
      protected static var sHasLuckLevel:Boolean = false;
      
      protected static var sIsGameplayDataReady:Boolean = false;
      
      protected static const GAMEPLAY_DATA_READY_TIMEOUT_MS:int = 600000;
      
      protected static var sGameplayDataReadyStartTime:int = -1;
      
      protected static var sUnhandledSituationMessages:Array = [];
      
      public function GameplayStateData()
      {
         super();
      }
      
      public static function AddListeners(param1:CommunicationManager) : void
      {
         param1.AddMessageListener("GameStateChanged",HandleGameStateChange,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("GameStateLoadComplete",HandleGameStateLoadComplete,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("AchievementObjectiveInfoUpdate",HandleAchievementObjectiveInfoUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("UpdateHouseholdMoney",HandleSetMoney,GAMEPLAY_STATE_DATA_STRING,SetMoney);
         param1.AddMessageListener("HouseholdUpdate",HandleHouseholdUpdate,GAMEPLAY_STATE_DATA_STRING,HouseholdData);
         param1.AddMessageListener("SimActivated",HandleSimActivated,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SimDeactivated",HandleSimDeactivated,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SimAgeUpdate",HandleSimAgeUpdate,GAMEPLAY_STATE_DATA_STRING,AgeUpdate);
         param1.AddMessageListener("SimAgeProgressUpdate",HandleSimAgeProgressUpdate,GAMEPLAY_STATE_DATA_STRING,AgeProgressUpdate);
         param1.AddMessageListener("UpdateSimRelationshipById",HandleUpdateRelationshipInfo,GAMEPLAY_STATE_DATA_STRING,RelationshipByIdInfo);
         param1.AddMessageListener("DeleteSimRelationshipById",HandleDeleteRelationship,GAMEPLAY_STATE_DATA_STRING,RelationshipDeleteById);
         param1.AddMessageListener("BuffUpdate",HandleBuffUpdate,GAMEPLAY_STATE_DATA_STRING,BuffInfo);
         param1.AddMessageListener("ObjectiveInfoUpdate",HandleAspirationObjectiveInfoUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("CompletedAspirationUpdate",HandleCompletedAspirationUpdate,GAMEPLAY_STATE_DATA_STRING,AspirationUpdate);
         param1.AddMessageListener("UnfinishedBusinessAspirationUpdate",HandleUnfinishedBusinessAspirationUpdate,GAMEPLAY_STATE_DATA_STRING,UnfinishedBusinessAspirationUpdate);
         param1.AddMessageListener("UnfinishedBusinessAspirationSelectedUpdate",HandleUnfinishedBusinessAspirationSelection,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SetCareers",HandleSetCareers,GAMEPLAY_STATE_DATA_STRING,FullCareerInfo);
         param1.AddMessageListener("SetCurrentWhims",HandleSetCurrentWhims,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("UpdateSimSkill",HandleUpdateSimSkill,GAMEPLAY_STATE_DATA_STRING,SimSkillInfo);
         param1.AddMessageListener("SkillProgressUpdate",HandleSkillProgressUpdate,GAMEPLAY_STATE_DATA_STRING,SkillProgressUpdate);
         param1.AddMessageListener("SkillDelete",HandleSkillDelete,GAMEPLAY_STATE_DATA_STRING,SkillDelete);
         param1.AddMessageListener("UpdateTraits",HandleUpdateTraits,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SetTraitAtRisk",HandleSetTraitAtRisk,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("AspirationSelectedUpdate",HandleAspirationSelection,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("GameSaveLockUnlock",HandleGameSaveLockUnlock,GAMEPLAY_STATE_DATA_STRING,GameSaveLockUnlock);
         param1.AddMessageListener("UpdateSelectableSims",HandleUpdateSelectableSims,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SetWhimBucks",HandleSetWhimBucks,GAMEPLAY_STATE_DATA_STRING,SetWhimBucks);
         param1.AddMessageListener("MoodUpdate",HandleMoodUpdate,GAMEPLAY_STATE_DATA_STRING,MoodUpdate);
         param1.AddMessageListener("SituationStart",HandleSituationStart,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SituationGoalsUpdate",HandleSituationGoalsUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ScenarioGoalsUpdate",HandleScenarioGoalsUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SituationEnded",HandleSituationEnd,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ScenarioStart",HandleScenarioStart,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ScenarioEnded",HandleSituationEnd,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ScenarioOutcomeData",HandleScenarioOutcome,GAMEPLAY_STATE_DATA_STRING,ScenarioOutcomeData);
         param1.AddMessageListener("SituationOutcomeData",HandleSituationOutcome,GAMEPLAY_STATE_DATA_STRING,SituationOutcomeData);
         param1.AddMessageListener("CollectibleItemUpdate",HandleCollectibleItemUpdate,GAMEPLAY_STATE_DATA_STRING,CollectibleItemUpdate);
         param1.AddMessageListener("SetAtWorkInfo",HandleSetAtWorkInfo,GAMEPLAY_STATE_DATA_STRING,SetAtWorkInfo);
         param1.AddMessageListener("SetBuckFunds",HandleSetBuckFunds,GAMEPLAY_STATE_DATA_STRING,SetBuckFunds);
         param1.AddMessageListener("SetSimBuckFunds",HandleSetSimBuckFunds,GAMEPLAY_STATE_DATA_STRING,SetBuckFunds);
         param1.AddMessageListener("TransitionScreenHidden",HandleTransitionScreenHidden,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ActiveSimLeftGathering",HandleActiveSimLeftGathering,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("ActiveSimJoinedGathering",HandleActiveSimJoinedGathering,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SimOccultUpdate",HandleSimOccultTypeUpdate,GAMEPLAY_STATE_DATA_STRING,OccultUpdate);
         param1.AddMessageListener("RankedStatisticProgressUpdate",HandleRankedStatisticProgressUpdate,GAMEPLAY_STATE_DATA_STRING,RankedStatisticProgressUpdate);
         param1.AddMessageListener("SendActiveHolidayInfo",HandleSendActiveHolidayInfo,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("TutorialModeChanged",HandleTutorialModeChanged,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("BusinessPresetsUpdate",HandleBusinessPresetsUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("LuckUpdate",HandleLuckUpdate,GAMEPLAY_STATE_DATA_STRING);
         if(sGameplayDataReadyStartTime < 0)
         {
            sGameplayDataReadyStartTime = getTimer();
         }
         param1.AddMessageListener("UiScreenSlam",HandleScreenSlamMessage,GAMEPLAY_STATE_DATA_STRING,UiScreenSlamMessage);
         param1.AddMessageListener("ScreenSlamHideComplete",OnScreenSlamHidden,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SituationPrepare",HandleSituationPrepare,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("DynamicSignView",HandleDynamicSignView,GAMEPLAY_STATE_DATA_STRING,DynamicSignView);
         param1.AddMessageListener("NotifyChallengeEventActivated",HandleNotifyChallengeEventActivated,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("NewPlayerGameEntryGuidanceActivate",HandleNewPlayerGuidanceUpdate,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("SetUIAccountSettingsValue",HandleSetUIAccountSettingsValue,GAMEPLAY_STATE_DATA_STRING);
         param1.AddMessageListener("TravelListUpdated",HandleTravelListUpdated,GAMEPLAY_STATE_DATA_STRING);
      }
      
      public static function GetAchievementObjectiveInfos(param1:Array) : Vector.<ObjectiveInfo>
      {
         return GetObjectiveInfos(param1,"GetAchievementObjectiveInfo",sAllAchievementObjectiveInfo);
      }
      
      public static function get CurrentZoneId() : String
      {
         var _loc1_:String = sCurrentZoneId;
         if(!_loc1_)
         {
            _loc1_ = CommunicationManager.CallGameService("BBGetCurrentZoneId",null,true) as String;
            sCurrentZoneId = _loc1_;
         }
         return _loc1_;
      }
      
      public static function get SaveLocked() : Boolean
      {
         return sLockUnlockMessage ? sLockUnlockMessage.is_locked : false;
      }
      
      public static function get SaveLockUnlockMessage() : GameSaveLockUnlock
      {
         return sLockUnlockMessage;
      }
      
      public static function get CurrentWorldId() : String
      {
         if(!sCurrentWorldId)
         {
            sCurrentWorldId = CommunicationManager.CallGameService("GetWorldIdForZone",{"zoneInstanceId":GameplayStateData.CurrentZoneId}) as String;
         }
         return sCurrentWorldId;
      }
      
      public static function get CurrentStreetInfoData() : StreetInfoData
      {
         var _loc1_:NeighborhoodData = GameplayStateData.CurrentNeighborhoodData;
         var _loc2_:String = GameplayStateData.CurrentWorldId;
         return _loc1_ == null ? null : _loc1_.GetStreetInfoDataByWorldId(_loc2_);
      }
      
      public static function get CurrentNeighborhoodData() : NeighborhoodData
      {
         var _loc1_:String = GameplayStateData.CurrentZoneId;
         return CommunicationManager.CallUIService("GetNeighborhoodByLot",_loc1_) as NeighborhoodData;
      }
      
      public static function get IsNewPlayerGuidanceActive() : Boolean
      {
         return sIsNewPlayerGuidanceActive;
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
                  sTravelGroups.Remove(_loc4_.travel_group_id);
               }
            }
            else
            {
               sTravelGroups.AddOrReplace(new TravelGroupData(param1[_loc3_]));
            }
            _loc3_++;
         }
         CommunicationManager.SendUIMessage(TRAVELGROUPS_UPDATED);
      }
      
      public static function get CurrentRegionDescriptionId() : String
      {
         var _loc1_:NeighborhoodLotData = null;
         var _loc2_:RegionDescription = null;
         if(!sCurrentRegionDescriptionId)
         {
            _loc1_ = new NeighborhoodLotData(CommunicationManager.CallGameService("GetNeighborhoodLotData",CurrentZoneId));
            if(Boolean(_loc1_) && Boolean(_loc1_.regionId))
            {
               _loc2_ = RegionDescription.GetRegionDescription(_loc1_.regionId);
               if(_loc2_)
               {
                  sCurrentRegionDescriptionId = _loc2_.id;
               }
            }
         }
         return sCurrentRegionDescriptionId;
      }
      
      public static function get CurrentRegionCurrencyBucksType() : uint
      {
         if(sCurrentRegionCurrencyBucksType == uint.MAX_VALUE)
         {
            sCurrentRegionCurrencyBucksType = CommunicationManager.CallGameService("BBUIGetRegionBucksType") as uint;
         }
         return sCurrentRegionCurrencyBucksType;
      }
      
      public static function get CurrentRegionCurrencyStringKey() : LocKey
      {
         var _loc1_:CurrencyBuckData = null;
         if(CurrentRegionCurrencyBucksType != SetBuckFunds.BUCK_TYPE_NONE)
         {
            _loc1_ = CurrencyBuckData.GetCurrencyBuckData(CurrentRegionCurrencyBucksType);
            if(Boolean(_loc1_) && Boolean(_loc1_.valueKey))
            {
               return _loc1_.valueKey;
            }
         }
         return Keys.GENERIC_MONEY;
      }
      
      public static function get IsCurrentRegionCurrencySimoleon() : Boolean
      {
         return CurrentRegionCurrencyBucksType == SetBuckFunds.BUCK_TYPE_NONE;
      }
      
      public static function IsRegionBatuu(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            param1 = CurrentRegionDescriptionId;
         }
         return param1 == BATUU_REGION_ID;
      }
      
      public static function IsRegionSixam(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            param1 = CurrentRegionDescriptionId;
         }
         return param1 == SIXAM_REGION_ID;
      }
      
      public static function get ActiveHouseholdData() : HouseholdData
      {
         var _loc1_:* = undefined;
         if(!sHouseholdData || !sHouseholdData.familyId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetFamilyInfo");
            if(_loc1_)
            {
               sHouseholdData = new HouseholdData(_loc1_);
            }
         }
         return sHouseholdData;
      }
      
      public static function get HouseholdName() : String
      {
         return ActiveHouseholdData.familyName;
      }
      
      public static function get HouseholdZoneId() : String
      {
         return ActiveHouseholdData.familyLotId;
      }
      
      public static function get CurrentSimoleons() : uint
      {
         if(ActiveHouseholdData)
         {
            return ActiveHouseholdData.familyFunds;
         }
         return 0;
      }
      
      public static function get CurrentCurrencyFunds() : uint
      {
         if(IsCurrentRegionCurrencySimoleon)
         {
            return CurrentSimoleons;
         }
         return GetBuckFunds(CurrentRegionCurrencyBucksType);
      }
      
      public static function get ActiveHouseholdId() : String
      {
         var _loc1_:HouseholdData = null;
         if(!sActiveHouseholdId)
         {
            _loc1_ = ActiveHouseholdData;
            sActiveHouseholdId = _loc1_ ? _loc1_.familyId : "";
         }
         return sActiveHouseholdId;
      }
      
      public static function get HasSims() : Boolean
      {
         var _loc3_:SimPB = null;
         var _loc1_:Array = SelectableSims;
         if(!_loc1_ || _loc1_.length == 0)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.is_selectable)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public static function get SelectableSims() : Array
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(!sSelectableSims)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSimSelectorList");
            if(_loc1_)
            {
               _loc2_ = new Array();
               _loc3_ = _loc1_.sims;
               for each(_loc4_ in _loc3_)
               {
                  _loc2_.push(new SimPB(_loc4_));
               }
               sSelectableSims = _loc2_;
            }
            else
            {
               sSelectableSims = null;
            }
         }
         return sSelectableSims;
      }
      
      public static function get IsActiveSimOnLot() : Boolean
      {
         var _loc3_:SimPB = null;
         var _loc1_:Array = SelectableSims;
         var _loc2_:String = ActiveSimId;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.id == _loc2_)
            {
               return Boolean(_loc3_) && _loc3_.InZone && !_loc3_.at_work;
            }
         }
         return false;
      }
      
      public static function get HouseholdCollection() : CollectionData
      {
         var _loc1_:CollectionData = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:CollectibleItemUpdate = null;
         var _loc5_:CollectionItemData = null;
         if(!sHouseholdCollection)
         {
            _loc1_ = new CollectionData(CommunicationManager.CallGameService("GetCollectionStaticData") as Array);
            sHouseholdCollection = _loc1_;
            _loc2_ = CommunicationManager.CallGameService("GetCollectionHouseholdUpdate");
            if(!_loc2_ || !(_loc2_ is Array))
            {
               return sHouseholdCollection;
            }
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new CollectibleItemUpdate(_loc3_);
               _loc5_ = sHouseholdCollection.GetItemData(_loc4_.object_def_id);
               if(_loc5_)
               {
                  _loc5_.UpdateInfo = _loc4_;
               }
            }
         }
         return sHouseholdCollection;
      }
      
      public static function GetBuckFunds(param1:uint) : uint
      {
         var _loc2_:Object = null;
         if(!sHouseholdBuckFunds)
         {
            _loc2_ = CommunicationManager.CallGameService("GetBuckFundsInfo",ActiveSimId);
            if(!_loc2_)
            {
               return 0;
            }
            sHouseholdBuckFunds = _loc2_ ? _loc2_ : new Object();
         }
         return uint(sHouseholdBuckFunds[param1]);
      }
      
      public static function GetActiveHoliday() : SendActiveHolidayInfo
      {
         var _loc1_:Object = null;
         if(!sActiveHoliday)
         {
            _loc1_ = CommunicationManager.CallGameService("GetActiveHoliday",null,true);
            if(_loc1_)
            {
               sActiveHoliday = new SendActiveHolidayInfo(_loc1_);
               if(_loc1_.holiday_type)
               {
                  sActiveHoliday.holiday_info.holiday_type = _loc1_.holiday_type;
               }
            }
         }
         return sActiveHoliday;
      }
      
      public static function get ActiveSimId() : String
      {
         var _loc1_:String = null;
         if(!sActiveSimId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetActiveSim",null,true) as String;
            sActiveSimId = _loc1_;
         }
         return sActiveSimId;
      }
      
      public static function get ActiveSimToken() : Object
      {
         return {"simId":GameplayStateData.ActiveSimId};
      }
      
      public static function get ActiveSimIdentity() : SimIdentity
      {
         if(!sSimIdentity)
         {
            sSimIdentity = new SimIdentity(CommunicationManager.CallGameService("GetSimNameInfo",{"simId":ActiveSimId}));
         }
         return sSimIdentity;
      }
      
      public static function get SimAge() : AgeUpdate
      {
         if(!sSimAgeUpdate)
         {
            sSimAgeUpdate = new AgeUpdate(CommunicationManager.CallGameService("GetSimAge",ActiveSimId));
         }
         return sSimAgeUpdate;
      }
      
      public static function get SimAgeProgress() : AgeProgressUpdate
      {
         if(!sSimAgeProgressUpdate)
         {
            sSimAgeProgressUpdate = new AgeProgressUpdate(CommunicationManager.CallGameService("GetSimAgeProgress",ActiveSimId));
         }
         return sSimAgeProgressUpdate;
      }
      
      public static function get SimGender() : uint
      {
         if(sSimGender == VALUE_REQUIRES_UPDATE)
         {
            sSimGender = CommunicationManager.CallGameService("GetSimGender",ActiveSimId) as uint;
         }
         return sSimGender;
      }
      
      public static function get SimOccultType() : OccultUpdate
      {
         if(!sSimOccultUpdate)
         {
            sSimOccultUpdate = new OccultUpdate(CommunicationManager.CallGameService("GetSimOccultType",ActiveSimId));
         }
         return sSimOccultUpdate;
      }
      
      public static function get SimSpecies() : uint
      {
         if(sSimSpecies == VALUE_REQUIRES_UPDATE)
         {
            sSimSpecies = CommunicationManager.CallGameService("GetSimSpecies",ActiveSimId) as uint;
         }
         return sSimSpecies;
      }
      
      public static function get SimIsGhost() : Boolean
      {
         BuildTraitMap();
         return sSimIsGhost;
      }
      
      public static function get AllSimRankedStatisticProgressUpdates() : Vector.<RankedStatisticProgressUpdate>
      {
         var _loc1_:Vector.<RankedStatisticProgressUpdate> = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         if(!sAllRankedStatisticProgressUpdates)
         {
            _loc1_ = new Vector.<RankedStatisticProgressUpdate>();
            _loc2_ = CommunicationManager.CallGameService("GetAllSimRankedStatisticUpdate",{"simId":ActiveSimId}) as Array;
            for each(_loc3_ in _loc2_)
            {
               _loc1_.push(new RankedStatisticProgressUpdate(_loc3_));
            }
            sAllRankedStatisticProgressUpdates = _loc1_;
         }
         return sAllRankedStatisticProgressUpdates;
      }
      
      public static function get AllDefaultRankedStatisticProgressUpdates() : Dictionary
      {
         if(!sAllDefaultRankedStatisticProgressUpdates)
         {
            sAllDefaultRankedStatisticProgressUpdates = new Dictionary();
         }
         return sAllDefaultRankedStatisticProgressUpdates;
      }
      
      public static function HasPlayedFactionRep() : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:RankedStatisticProgressUpdate = null;
         var _loc1_:FactionReputationData = FactionReputationData.FACTIONREPDATA;
         var _loc2_:Array = new Array(_loc1_.resistanceRepStat,_loc1_.firstOrderRepStat,_loc1_.scoundrelRepStat);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ == "0")
            {
               return false;
            }
            _loc4_ = GetSimRankedStatisticProgressUpdate(_loc3_,false);
            if(_loc4_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function get AllRelationshipInfo() : Vector.<RelationshipInfo>
      {
         if(!sAllRelationshipInfo)
         {
            PopulateAllRelationshipInfo();
         }
         return sAllRelationshipInfo;
      }
      
      public static function PopulateAllRelationshipInfo() : void
      {
         var _loc3_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetAllSimRelationshipInfo",{"actorSimId":ActiveSimId},true) as Array;
         var _loc2_:Vector.<RelationshipInfo> = new Vector.<RelationshipInfo>();
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(new RelationshipInfo(_loc3_));
         }
         sAllRelationshipInfo = _loc2_;
      }
      
      public static function GetRelationshipInfoWithTargetSim(param1:String) : RelationshipInfo
      {
         var _loc3_:RelationshipInfo = null;
         var _loc2_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         if(!_loc2_)
         {
            return null;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.targetId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function DisableRelationshipInfoNewValueFlags(param1:String, param2:String = null) : void
      {
         var _loc6_:RelationshipInfo = null;
         if(Boolean(param2) && param2 != ActiveSimId)
         {
            CommunicationManager.CallGameService("SetRelationshipInfoNewValueFlags",{
               "targetId":param1,
               "actorSimId":param2,
               "hasNewSentiments":false,
               "hasNewSatisfactionValue":false
            },true);
         }
         var _loc3_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.targetId == param1)
            {
               _loc3_[_loc5_].hasNewSentiments = false;
               _loc3_[_loc5_].hasNewSatisfactionValue = false;
               CommunicationManager.CallGameService("SetRelationshipInfoNewValueFlags",{
                  "targetId":param1,
                  "hasNewSentiments":false,
                  "hasNewSatisfactionValue":false
               },true);
               return;
            }
            _loc5_++;
         }
      }
      
      public static function DisableRelationshipHasNewSentiment(param1:String, param2:String = null) : void
      {
         var _loc6_:RelationshipInfo = null;
         if(Boolean(param2) && param2 != ActiveSimId)
         {
            CommunicationManager.CallGameService("SetRelationshipHasNewSentiments",{
               "targetId":param1,
               "actorSimId":param2,
               "hasNewSentiments":false
            },true);
         }
         var _loc3_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.targetId == param1)
            {
               _loc3_[_loc5_].hasNewSentiments = false;
               CommunicationManager.CallGameService("SetRelationshipHasNewSentiments",{
                  "targetId":param1,
                  "hasNewSentiments":false
               },true);
               return;
            }
            _loc5_++;
         }
      }
      
      public static function DisableRelationshipHasNewSatisfactionValue(param1:String, param2:String = null) : void
      {
         var _loc6_:RelationshipInfo = null;
         if(Boolean(param2) && param2 != ActiveSimId)
         {
            CommunicationManager.CallGameService("SetRelationshipHasNewSatisfactionValue",{
               "targetId":param1,
               "actorSimId":param2,
               "hasNewSatisfactionValue":false
            },true);
         }
         var _loc3_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.targetId == param1)
            {
               _loc3_[_loc5_].hasNewSatisfactionValue = false;
               CommunicationManager.CallGameService("SetRelationshipHasNewSatisfactionValue",{
                  "targetId":param1,
                  "hasNewSatisfactionValue":false
               },true);
               return;
            }
            _loc5_++;
         }
      }
      
      public static function get AllBuffInfo() : Vector.<BuffInfo>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<BuffInfo> = sAllBuffInfo;
         if(!_loc1_)
         {
            _loc2_ = CommunicationManager.CallGameService("GetSimBuffsInfo",ActiveSimId) as Array;
            _loc1_ = new Vector.<BuffInfo>();
            for each(_loc3_ in _loc2_)
            {
               _loc1_.push(new BuffInfo(_loc3_));
            }
            sAllBuffInfo = _loc1_;
         }
         return _loc1_;
      }
      
      public static function get AllCareerInfo() : Vector.<CareerInfo>
      {
         var _loc2_:FullCareerInfo = null;
         var _loc3_:CareerInfo = null;
         var _loc1_:Vector.<CareerInfo> = sAllCareerInfo;
         if(!_loc1_)
         {
            sAllCareerInfo = _loc1_ = new Vector.<CareerInfo>();
            _loc2_ = FullSimCareerInfo;
            if(_loc2_)
            {
               for each(_loc3_ in _loc2_.careers)
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public static function get FullSimCareerInfo() : FullCareerInfo
      {
         var _loc1_:Object = null;
         if(!sFullCareerInfo)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSimFullCareerInfo",ActiveSimId);
            if(_loc1_)
            {
               _loc1_.sim_id = ActiveSimId;
               sFullCareerInfo = new FullCareerInfo(_loc1_);
            }
         }
         return sFullCareerInfo;
      }
      
      public static function get AllAspirationUpdateInfo() : AspirationUpdate
      {
         var _loc1_:AspirationUpdate = null;
         if(!sAllAspirationUpdateInfo)
         {
            _loc1_ = new AspirationUpdate(CommunicationManager.CallGameService("GetSimAspirationInfo",ActiveSimId));
            MergeAspirationUpdateWithObjectiveInfo(_loc1_);
            sAllAspirationUpdateInfo = _loc1_;
         }
         return sAllAspirationUpdateInfo;
      }
      
      public static function get AllUnfinishedBusinessAspirationUpdateInfo() : UnfinishedBusinessAspirationUpdate
      {
         var _loc1_:UnfinishedBusinessAspirationUpdate = null;
         if(!sAllUnfinishedBusinessAspirationUpdateInfo)
         {
            _loc1_ = new UnfinishedBusinessAspirationUpdate(CommunicationManager.CallGameService("GetSimUnfinishedBusinessAspirationInfo",ActiveSimId));
            MergeUnfinishedBusinessAspirationUpdateWithObjectiveInfo(_loc1_);
            sAllUnfinishedBusinessAspirationUpdateInfo = _loc1_;
         }
         return sAllUnfinishedBusinessAspirationUpdateInfo;
      }
      
      public static function get AllSkillInfo() : Vector.<SimSkillInfo>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<SimSkillInfo> = sAllSkillInfo;
         if(!_loc1_)
         {
            _loc2_ = CommunicationManager.CallGameService("GetAllSimSkillInfo",{"simId":ActiveSimId}) as Array;
            _loc1_ = new Vector.<SimSkillInfo>();
            for each(_loc3_ in _loc2_)
            {
               _loc1_.push(new SimSkillInfo(_loc3_));
            }
            sAllSkillInfo = _loc1_;
         }
         return _loc1_;
      }
      
      public static function get AllSkillProgressUpdates() : Vector.<SkillProgressUpdate>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:SkillProgressUpdate = null;
         var _loc1_:Vector.<SkillProgressUpdate> = sAllSkillProgressUpdates;
         if(!_loc1_)
         {
            _loc2_ = CommunicationManager.CallGameService("GetSimSkillProgress",{"simId":ActiveSimId}) as Array;
            _loc1_ = new Vector.<SkillProgressUpdate>();
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new SkillProgressUpdate(_loc3_);
               _loc1_.push(_loc4_);
            }
            sAllSkillProgressUpdates = _loc1_;
         }
         return _loc1_;
      }
      
      public static function BuildTraitMap() : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:SimTraitsInfo = null;
         var _loc6_:String = null;
         var _loc7_:Vector.<SimTraitsInfo> = null;
         var _loc1_:Object = sAllTraitTypeMap;
         if(!_loc1_)
         {
            _loc2_ = ActiveSimId;
            _loc3_ = CommunicationManager.CallGameService("GetAllSimTraitsInfo",{"simId":_loc2_}) as Array;
            _loc1_ = new Object();
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = new SimTraitsInfo(_loc4_);
               _loc6_ = _loc5_.TraitType;
               if(!_loc1_[_loc6_])
               {
                  _loc1_[_loc6_] = new Vector.<SimTraitsInfo>();
               }
               _loc7_ = _loc1_[_loc6_];
               _loc7_.push(_loc5_);
               if(_loc6_ == SimTraitsInfo.TRAIT_GHOST)
               {
                  SetSimIsGhost(true);
               }
            }
            sAllTraitTypeMap = _loc1_;
         }
      }
      
      public static function get AllTraitInfo() : Vector.<SimTraitsInfo>
      {
         var _loc2_:Vector.<SimTraitsInfo> = null;
         BuildTraitMap();
         var _loc1_:* = new Vector.<SimTraitsInfo>();
         for each(_loc2_ in sAllTraitTypeMap)
         {
            _loc1_ = _loc1_.concat(_loc2_);
         }
         return _loc1_;
      }
      
      public static function get AllTraitInfoMap() : Object
      {
         BuildTraitMap();
         return sAllTraitTypeMap;
      }
      
      public static function get AllTraitIds() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Vector.<SimTraitsInfo> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(!sAllTraitIds)
         {
            _loc1_ = new Array();
            _loc2_ = AllTraitInfo;
            _loc1_.length = _loc2_.length;
            _loc3_ = 0;
            _loc4_ = _loc2_.length;
            while(_loc3_ < _loc4_)
            {
               _loc1_[_loc3_] = _loc2_[_loc3_].trait_id;
               _loc3_++;
            }
            sAllTraitIds = _loc1_;
         }
         return sAllTraitIds;
      }
      
      public static function GetTraitInfoByType(param1:String) : Vector.<SimTraitsInfo>
      {
         var _loc2_:Vector.<SimTraitsInfo> = AllTraitInfoMap[param1];
         return _loc2_ ? _loc2_ : new Vector.<SimTraitsInfo>();
      }
      
      public static function GetTraitsOfType(param1:String, param2:String) : Array
      {
         var _loc3_:String = ActiveSimId;
         var _loc4_:Array = CommunicationManager.CallGameService("GetFilteredSimTraitInfo",{
            "simId":_loc3_,
            "traitType":param1,
            "uiCategory":param2
         }) as Array;
         OlympusObject.ConstructArrayInPlace(_loc4_,SimTraitsInfo);
         return _loc4_;
      }
      
      public static function get PrimaryAspirationTrackId() : String
      {
         var _loc1_:Object = null;
         if(!sPrimaryAspirationTrackId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSimPrimaryAspiration",ActiveSimId);
            sPrimaryAspirationTrackId = _loc1_ ? _loc1_["aspiration_id"] : null;
         }
         return sPrimaryAspirationTrackId;
      }
      
      public static function get UnfinishedBusinessAspirationTrackId() : String
      {
         var _loc1_:Object = null;
         if(!sUnfinishedBusinessAspirationTrackId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSimUnfinishedBusinessAspiration",ActiveSimId);
            sUnfinishedBusinessAspirationTrackId = _loc1_ ? _loc1_["unfinished_business_aspiration_id"] : null;
         }
         return sUnfinishedBusinessAspirationTrackId;
      }
      
      public static function GetCurrentUnfinishedBusinessAspirationInTrack(param1:String) : AspirationInfo
      {
         var _loc5_:AspirationInfo = null;
         if(ActiveSimId == "0")
         {
            return null;
         }
         var _loc2_:UnfinishedBusinessAspirationUpdate = AllUnfinishedBusinessAspirationUpdateInfo;
         var _loc3_:AspirationTrackStaticData = AspirationTrackStaticData.GetTrackData(param1);
         var _loc4_:AspirationStaticData = _loc3_ ? _loc3_.GetCurrentUnfinishedBusinessAspirationInTrack(_loc2_) : null;
         if(_loc4_)
         {
            _loc5_ = GetAspirationInfos([_loc4_.uid])[0];
            if(_loc5_)
            {
               _loc5_.isUnlocked = true;
            }
            return _loc5_;
         }
         return null;
      }
      
      public static function get CurrentAspiration() : AspirationInfo
      {
         if(!sCurrentAspiration)
         {
            sCurrentAspiration = GetCurrentAspirationInTrack(PrimaryAspirationTrackId);
         }
         return sCurrentAspiration;
      }
      
      public static function get CurrentUnfinishedBusinessAspiration() : AspirationInfo
      {
         if(!sCurrentUnfinishedBusinessAspiration)
         {
            sCurrentUnfinishedBusinessAspiration = GetCurrentUnfinishedBusinessAspirationInTrack(UnfinishedBusinessAspirationTrackId);
         }
         return sCurrentUnfinishedBusinessAspiration;
      }
      
      public static function GetCurrentAspirationInTrack(param1:String) : AspirationInfo
      {
         var _loc5_:AspirationInfo = null;
         if(ActiveSimId == "0")
         {
            return null;
         }
         var _loc2_:AspirationUpdate = AllAspirationUpdateInfo;
         var _loc3_:AspirationTrackStaticData = AspirationTrackStaticData.GetTrackData(param1);
         var _loc4_:AspirationStaticData = _loc3_ ? _loc3_.GetCurrentAspirationInTrack(_loc2_) : null;
         if(_loc4_)
         {
            _loc5_ = GetAspirationInfos([_loc4_.uid])[0];
            if(_loc5_)
            {
               _loc5_.isUnlocked = true;
            }
            return _loc5_;
         }
         return null;
      }
      
      public static function get CurrentAspirationTrack() : AspirationTrackInfo
      {
         var _loc1_:AspirationTrackStaticData = null;
         var _loc2_:AspirationTrackInfo = null;
         if(!sCurrentAspirationTrack)
         {
            if(ActiveSimId == "0")
            {
               return null;
            }
            _loc1_ = AspirationTrackStaticData.GetTrackData(PrimaryAspirationTrackId);
            if(!_loc1_)
            {
               return null;
            }
            _loc2_ = new AspirationTrackInfo(_loc1_);
            _loc2_.MergeInformation(PrimaryAspirationTrackId,AllAspirationUpdateInfo);
            sCurrentAspirationTrack = _loc2_;
         }
         return sCurrentAspirationTrack;
      }
      
      public static function get CurrentUnfinishedBusinessAspirationTrack() : AspirationTrackInfo
      {
         var _loc1_:AspirationTrackStaticData = null;
         var _loc2_:AspirationTrackInfo = null;
         if(!sCurrentUnfinishedBusinessAspirationTrack)
         {
            if(ActiveSimId == "0")
            {
               return null;
            }
            _loc1_ = AspirationTrackStaticData.GetTrackData(UnfinishedBusinessAspirationTrackId);
            if(!_loc1_)
            {
               return null;
            }
            _loc2_ = new AspirationTrackInfo(_loc1_);
            sCurrentUnfinishedBusinessAspirationTrack = _loc2_;
         }
         return sCurrentUnfinishedBusinessAspirationTrack;
      }
      
      public static function GetAspirationInfos(param1:Array) : Vector.<AspirationInfo>
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:AspirationInfo = null;
         var _loc2_:Vector.<AspirationInfo> = new Vector.<AspirationInfo>();
         var _loc3_:int = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_ in sAllAspirationInfo)
            {
               _loc2_.push(sAllAspirationInfo[_loc5_]);
            }
            else
            {
               _loc6_ = new AspirationInfo(AspirationStaticData.GetStaticData(_loc5_));
               sAllAspirationInfo[_loc5_] = _loc6_;
               _loc2_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function GetAspirationObjectiveInfos(param1:Array) : Vector.<ObjectiveInfo>
      {
         return GetObjectiveInfos(param1,"GetObjectiveInfo",sAllObjectiveInfo);
      }
      
      public static function GetUnfinishedBusinessAspirationObjectiveInfos(param1:Array) : Vector.<ObjectiveInfo>
      {
         return GetObjectiveInfos(param1,"GetObjectiveInfo",sAllUnfinishedBusinessObjectiveInfo);
      }
      
      public static function get CurrentMidlifeCrisis() : TimedAspirationUpdate
      {
         var _loc3_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetSimTimedAspirationUpdate",GameplayStateData.ActiveSimId) as Array;
         var _loc2_:TimedAspirationUpdate = null;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_)
            {
               if(!(_loc3_.timed_aspiration_type != TimedAspirationUpdate.TIMED_ASPIRATION_MIDLIFE_CRISIS || _loc3_.update_type == TimedAspirationUpdate.UPDATE_TYPE_REMOVE))
               {
                  _loc2_ = new TimedAspirationUpdate(_loc3_);
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public static function get CurrentChildhoodInspirations() : Vector.<TimedAspirationUpdate>
      {
         var _loc3_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetSimTimedAspirationUpdate",GameplayStateData.ActiveSimId) as Array;
         var _loc2_:Vector.<TimedAspirationUpdate> = new Vector.<TimedAspirationUpdate>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_)
            {
               if(_loc3_.timed_aspiration_type == TimedAspirationUpdate.TIMED_ASPIRATION_CHILDHOOD_INSPIRATION)
               {
                  _loc2_.push(new TimedAspirationUpdate(_loc3_));
               }
            }
         }
         return _loc2_;
      }
      
      public static function get GetSuggestedAspirations() : Array
      {
         var _loc1_:Object = CommunicationManager.CallGameService("GetSimSuggestedAspirationUpdate",ActiveSimId);
         return _loc1_ ? _loc1_["visible_suggested_aspiration_list"] : null;
      }
      
      public static function get CurrentWhims() : Object
      {
         var _loc1_:Object = sCurrentWhims;
         if(!_loc1_)
         {
            _loc1_ = new Object();
            sCurrentWhims = _loc1_;
         }
         return _loc1_;
      }
      
      public static function get CurrentWhimsForActiveSim() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:Object = CurrentWhims;
         if(!(ActiveSimId in _loc1_))
         {
            _loc2_ = CommunicationManager.CallGameService("GetSimWhimsInfo",ActiveSimId);
            _loc1_[ActiveSimId] = _loc2_;
         }
         else
         {
            _loc2_ = _loc1_[ActiveSimId];
         }
         return _loc2_;
      }
      
      public static function get SatisfactionPoints() : int
      {
         var _loc1_:Object = null;
         if(sSatisfactionPoints == VALUE_REQUIRES_UPDATE)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSimWhimBucksInfo",ActiveSimId);
            sSatisfactionPoints = _loc1_ ? int(_loc1_.whim_bucks) : 0;
         }
         return sSatisfactionPoints;
      }
      
      public static function get CurrentMood() : MoodUpdate
      {
         if(sCurrentMood == null)
         {
            sCurrentMood = new MoodUpdate(CommunicationManager.CallGameService("GetSimMood",ActiveSimId));
         }
         return sCurrentMood;
      }
      
      public static function get CurrentSituations() : Array
      {
         var _loc1_:Array = null;
         if(!sCurrentSituations)
         {
            _loc1_ = CommunicationManager.CallGameService("GetAllActiveSituations") as Array;
            sCurrentSituations = _loc1_;
         }
         return sCurrentSituations;
      }
      
      public static function get IsSituationRunning() : Boolean
      {
         return CommunicationManager.CallGameService("IsSituationRunning") as Boolean;
      }
      
      public static function get IsBlockingSituationRunning() : Boolean
      {
         return CommunicationManager.CallGameService("IsBlockingSituationRunning") as Boolean;
      }
      
      public static function get IsCareerSituationRunning() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:SituationStart = null;
         var _loc1_:Array = CurrentSituations;
         if(_loc1_)
         {
            _loc2_ = 0;
            _loc3_ = int(_loc1_.length);
            while(_loc2_ < _loc3_)
            {
               _loc4_ = new SituationStart(_loc1_[_loc2_]);
               if(_loc4_.IsCareerEventSituationType())
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public static function get IsDateSituationRunning() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Array = CurrentSituations;
         if(_loc1_)
         {
            _loc2_ = 0;
            _loc3_ = int(_loc1_.length);
            if(_loc2_ < _loc3_)
            {
               return ArrayUtils.IndexOfByFieldName(_loc1_,"display_type",SituationStart.DISPLAY_TYPE_ROMANCE) != -1;
            }
         }
         return false;
      }
      
      public static function get IsHolidaySituationRunning() : Boolean
      {
         if(!GameContent.HAS_EP05)
         {
            return false;
         }
         var _loc1_:Array = CurrentSituations;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            return ArrayUtils.IndexOfByFieldName(_loc1_,"user_facing_type",SituationStart.SITUATION_USERFACING_TYPE_HOLIDAY_EVENT) != -1;
         }
         return false;
      }
      
      public static function get IsActivitySituationRunning() : Boolean
      {
         var _loc1_:Array = CurrentSituations;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            return ArrayUtils.IndexOfByFieldName(_loc1_,"display_type",SituationStart.DISPLAY_TYPE_ACTIVITY) != -1;
         }
         return false;
      }
      
      public static function get HasGetawaysScheduled() : Boolean
      {
         var _loc2_:CalendarEntry = null;
         var _loc1_:Array = CommunicationManager.CallGameService("CalendarGetEntries") as Array;
         if(!_loc1_ || _loc1_.length == 0)
         {
            return false;
         }
         OlympusObject.ConstructArrayInPlace(_loc1_,CalendarEntry);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.getaway_name != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function get IsGetawayInProgress() : Boolean
      {
         if(!sTravelGroups)
         {
            return false;
         }
         var _loc1_:TravelGroupData = sTravelGroups.FindTravelGroup(ActiveHouseholdId);
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.group_type == TravelGroupData.GROUPTYPE_GETAWAY;
      }
      
      public static function IsCurrentGetawayLot() : Boolean
      {
         if(!sTravelGroups)
         {
            return false;
         }
         var _loc1_:TravelGroupData = sTravelGroups.FindTravelGroup(ActiveHouseholdId);
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.group_type == TravelGroupData.GROUPTYPE_GETAWAY && _loc1_.zone_id == CurrentZoneId;
      }
      
      public static function get OnlyPivotalMomentSituationsRunning() : Boolean
      {
         var _loc2_:Object = null;
         var _loc1_:Array = CurrentSituations;
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_["display_type"] != SituationStart.DISPLAY_TYPE_PIVOTAL_MOMENT)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public static function IsWeatherEnabled() : Boolean
      {
         return GameContent.HAS_EP05 || IsEP10World();
      }
      
      public static function IsEP10World() : Boolean
      {
         var _loc3_:RegionDescription = null;
         var _loc1_:String = GameplayStateData.CurrentZoneId;
         if(!_loc1_)
         {
            return false;
         }
         var _loc2_:Object = CommunicationManager.CallGameService("GetNeighborhoodLotData",_loc1_);
         if(_loc2_)
         {
            _loc3_ = RegionDescription.GetRegionDescription(_loc2_.regionId);
            if(_loc3_)
            {
               return _loc3_.IsSummitWeatherCompatible();
            }
         }
         return false;
      }
      
      public static function get SavedAspirationUpdate() : AspirationUpdate
      {
         if(sAllSavedAspirationUpdate.aspirations_completed.length == 0 && sAllSavedAspirationUpdate.unlocked_hidden_aspiration_tracks.length == 0 && sAllSavedAspirationUpdate.objectives_completed.length == 0)
         {
            return null;
         }
         return sAllSavedAspirationUpdate;
      }
      
      public static function get SavedUnfinishedBusinessAspirationUpdate() : UnfinishedBusinessAspirationUpdate
      {
         if(sAllSavedUnfinishedBusinessAspirationUpdate.objectives.length == 0)
         {
            return null;
         }
         return sAllSavedUnfinishedBusinessAspirationUpdate;
      }
      
      public static function get SavedObjectiveUpdate() : Array
      {
         if(sAllSavedObjectivesUpdate.length == 0)
         {
            return null;
         }
         return sAllSavedObjectivesUpdate;
      }
      
      public static function get ActiveSimGatheringClubId() : String
      {
         if(!sActiveSimGatheringClubId)
         {
            sActiveSimGatheringClubId = CommunicationManager.CallGameService("GetClubGatheringForSim",ActiveSimId) as String;
         }
         return sActiveSimGatheringClubId;
      }
      
      public static function GetActiveSimBuckFunds(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         if(!sActiveSimBuckFunds)
         {
            sActiveSimBuckFunds = new Object();
         }
         if(!sActiveSimBuckFunds[param1])
         {
            _loc2_ = CommunicationManager.CallGameService("GetSimBuckFundsInfo",{
               "simId":ActiveSimId,
               "buckType":param1
            }) as uint;
            sActiveSimBuckFunds[param1] = _loc2_;
         }
         return uint(sActiveSimBuckFunds[param1]);
      }
      
      public static function GetSimRankedStatisticProgressUpdate(param1:String, param2:Boolean = false) : RankedStatisticProgressUpdate
      {
         var _loc4_:RankedStatisticProgressUpdate = null;
         var _loc5_:Dictionary = null;
         var _loc6_:RankedStatisticProgressUpdate = null;
         var _loc7_:uint = 0;
         var _loc8_:RankedStatisticData = null;
         var _loc3_:Vector.<RankedStatisticProgressUpdate> = AllSimRankedStatisticProgressUpdates;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.stat_id == param1)
            {
               return _loc4_;
            }
         }
         if(param2)
         {
            _loc5_ = AllDefaultRankedStatisticProgressUpdates;
            if(param1 in _loc5_)
            {
               return _loc5_[param1];
            }
            _loc6_ = new RankedStatisticProgressUpdate(CommunicationManager.CallGameService("GetDefaultRankedStatisticProgress",{
               "simId":ActiveSimId,
               "rankedStatId":param1
            }));
            _loc7_ = _loc6_.rank;
            _loc6_.rank = _loc7_ - 1;
            _loc8_ = RankedStatisticData.GetDataById(param1);
            if(_loc8_.zero_point != 0)
            {
               _loc6_.curr_rank_points = _loc8_.GetPointsInRankFromTotalPoints(_loc8_.zero_point);
            }
            _loc5_[param1] = _loc6_;
            return _loc6_;
         }
         return null;
      }
      
      public static function get GoHomeInteraction() : String
      {
         if(!sGoHomeInteraction)
         {
            sGoHomeInteraction = CommunicationManager.CallGameService("GetGoHomeInteraction") as String;
         }
         return sGoHomeInteraction;
      }
      
      public static function IsActiveSimCorrectAgeForOccult(param1:int) : Boolean
      {
         var _loc2_:int = CommunicationManager.CallGameService("GetOccultMinAgeForUI",param1) as int;
         var _loc3_:Boolean = SimAgeTypes.CompareAges(_loc2_,GameplayStateData.SimAge.age) <= 0;
         return _loc3_ || !SimAgeTypes.IsValidAge(_loc2_);
      }
      
      public static function get IsReincarnating() : Boolean
      {
         var _loc2_:uint = 0;
         var _loc1_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(_loc1_ != null)
         {
            return _loc1_.Mode == GENeighborhoodMode.REINCARNATION;
         }
         _loc2_ = CommunicationManager.CallGameService("GetGameState") as uint;
         var _loc3_:Boolean = _loc2_ == GameStates.CAS;
         if(_loc3_)
         {
            return CASConfiguration.IsReincarnationMode;
         }
         return false;
      }
      
      public static function get HasLuckLevel() : Boolean
      {
         TryRefreshLuckLevel();
         return sHasLuckLevel;
      }
      
      public static function get LuckLevel() : int
      {
         TryRefreshLuckLevel();
         return sLuckLevel;
      }
      
      private static function TryRefreshLuckLevel() : void
      {
         var _loc1_:Object = null;
         if(sLuckLevel == VALUE_REQUIRES_UPDATE)
         {
            _loc1_ = CommunicationManager.CallGameService("GetLuckLevel",GameplayStateData.ActiveSimId);
            sLuckLevel = _loc1_ ? int(_loc1_) : 0;
            sHasLuckLevel = _loc1_ != null;
         }
      }
      
      public static function GetActiveLiveFestivalEvent() : LiveFestivalEventData
      {
         var _loc1_:Object = null;
         if(sCurrentActiveLiveFestivalEvent == null)
         {
            _loc1_ = CommunicationManager.CallGameService("GetActiveLiveFestivalEvent");
            sCurrentActiveLiveFestivalEvent = new LiveFestivalEventData(_loc1_);
         }
         return sCurrentActiveLiveFestivalEvent;
      }
      
      protected static function HandleBusinessPresetsUpdate(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:BusinessPreset = null;
         if(!param1)
         {
            sCustomBusinessPresets = [];
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:Array = param1 as Array;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new BusinessPreset(_loc4_);
            _loc2_.push(_loc5_);
         }
         sCustomBusinessPresets = _loc2_;
         CommunicationManager.SendUIMessage("CustomBusinessPresetsUpdated");
      }
      
      public static function GetCustomBusinessPresets() : Array
      {
         if(!sCustomBusinessPresets)
         {
            HandleBusinessPresetsUpdate(CommunicationManager.CallGameService("GetCustomBusinessPresets"));
         }
         return sCustomBusinessPresets;
      }
      
      protected static function HandleGameStateChange(param1:uint) : void
      {
         sPreviousGameState = sCurrentGameState;
         sCurrentGameState = param1;
         sActiveSimId = null;
         sHouseholdData = null;
         sActiveHouseholdId = null;
         UISettings.HouseholdSettings.ActiveId = null;
         sCurrentZoneId = null;
         sCurrentWorldId = null;
         sCurrentWhims = null;
         sHouseholdCollection = null;
         sHouseholdBuckFunds = null;
         sCurrentSituations = null;
         sActiveHoliday = null;
         sCurrentRegionDescriptionId = null;
         sCurrentRegionCurrencyBucksType = uint.MAX_VALUE;
         sCurrentActiveLiveFestivalEvent = null;
         sDynamicSignShowArgs = null;
         ClearSimInfo();
         if(sCurrentGameState == GameStates.PLAY)
         {
            if(sPreviousGameState != GameStates.BUILD)
            {
               sTravelGroups = null;
            }
         }
         else if(sCurrentGameState == GameStates.BUILD)
         {
            if(sPreviousGameState != GameStates.PLAY)
            {
               sTravelGroups = null;
            }
         }
         else
         {
            sTravelGroups = null;
         }
         if(sCurrentGameState != GameStates.PLAY)
         {
            sAllSavedAspirationUpdate.aspirations_completed.length = 0;
            sAllSavedAspirationUpdate.unlocked_hidden_aspiration_tracks.length = 0;
            sAllSavedAspirationUpdate.objectives_completed.length = 0;
            sAllSavedObjectivesUpdate.length = 0;
            sDelayedSituationOutcome = null;
            sAllSavedUnfinishedBusinessAspirationUpdate.objectives.length = 0;
         }
         if(sPreviousGameState == GameStates.LOT_SELECT)
         {
            sIsNewPlayerGuidanceActive = false;
         }
         else if(sPreviousGameState == GameStates.PLAY)
         {
            sUnhandledSituationMessages.length = 0;
         }
         if(sCurrentGameState == GameStates.MAIN_MENU || sCurrentGameState == GameStates.LOT_SELECT)
         {
            UISettings.SessionSettings.RemoveID("OutfitSelectionSettings");
            UISettings.SessionSettings.RemoveID("CustomScheduleSettings");
            UISettings.SessionSettings.RemoveID("editOutfitPicker");
            UISettings.SessionSettings.RemoveID("situationCreationJobOutfitCas");
         }
      }
      
      protected static function HandleGameStateLoadComplete() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(sCurrentGameState == GameStates.PLAY)
         {
            CommunicationManager.CallGameService("RequestLotDataUpdate");
            _loc1_ = CommunicationManager.CallGameService("GetAllActiveSituations") as Array;
            _loc2_ = CommunicationManager.CallGameService("GetCurrentScenario") as String;
            _loc3_ = GetCurrentLiveEventId();
            if(Boolean(_loc1_ && _loc1_.length > 0) || Boolean(_loc2_ != null) || _loc3_ != null)
            {
               HandleSituationStart({"situations":_loc1_},_loc2_,true,_loc3_);
            }
            else
            {
               ChallengeNotificationData.TryShowChallengeDisplay();
            }
            if(sDelayedSituationOutcome != null)
            {
               HandleSituationOutcome(sDelayedSituationOutcome);
               sDelayedSituationOutcome = null;
            }
            _loc4_ = UISettings.SessionSettings.GetValue("reopenSituationCreation","situationCreationJobOutfitCas");
            if(_loc4_)
            {
               UISettings.SessionSettings.RemoveKey("reopenSituationCreation","situationCreationJobOutfitCas");
               if(_loc4_.edit_data.fromCalendar)
               {
                  CommunicationManager.SendUIMessage("ShowCalendar");
               }
               CommunicationManager.SendUIMessage("ShowSituationCreation",_loc4_);
            }
         }
      }
      
      protected static function HandleAchievementObjectiveInfoUpdate(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         HandleObjectiveInfoUpdate(_loc2_,sAllAchievementObjectiveInfo);
      }
      
      protected static function HandleSetMoney(param1:SetMoney) : void
      {
         var _loc2_:HouseholdData = ActiveHouseholdData;
         if(_loc2_)
         {
            _loc2_.familyFunds = param1.currentSimoleons;
         }
      }
      
      protected static function HandleHouseholdUpdate(param1:HouseholdData) : void
      {
         if(Boolean(sHouseholdData) && sHouseholdData.familyId == param1.familyId)
         {
            sHouseholdData = param1;
         }
      }
      
      protected static function HandleSimActivated(param1:Object) : void
      {
         var _loc2_:String = param1["simId"];
         if(_loc2_ != sActiveSimId)
         {
            ClearSimInfo();
            sActiveSimId = _loc2_;
            PopulateAllRelationshipInfo();
            sAllSavedAspirationUpdate.aspirations_completed.length = 0;
            sAllSavedAspirationUpdate.unlocked_hidden_aspiration_tracks.length = 0;
            sAllSavedAspirationUpdate.objectives_completed.length = 0;
            sAllSavedObjectivesUpdate.length = 0;
            sAllSavedUnfinishedBusinessAspirationUpdate.objectives.length = 0;
         }
         UISettings.SimSettings.ActiveId = sActiveSimId;
      }
      
      protected static function HandleSimDeactivated(param1:Object) : void
      {
         if(sActiveSimId == param1["simId"])
         {
            sActiveSimId = "0";
            UISettings.SimSettings.ActiveId = null;
            ClearSimInfo();
         }
      }
      
      protected static function HandleSimAgeUpdate(param1:AgeUpdate) : void
      {
         if(param1.simId != ActiveSimId)
         {
            return;
         }
         sSimAgeUpdate = param1;
      }
      
      protected static function HandleSimAgeProgressUpdate(param1:AgeProgressUpdate) : void
      {
         if(param1.simId != ActiveSimId)
         {
            return;
         }
         sSimAgeProgressUpdate = param1;
      }
      
      protected static function HandleUpdateRelationshipInfo(param1:RelationshipByIdInfo) : void
      {
         var _loc6_:RelationshipInfo = null;
         var _loc2_:ManagerObjectId = param1.managerObjectId;
         if(param1.relInfo.actorId != GameplayStateData.ActiveSimId)
         {
            return;
         }
         var _loc3_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.targetId == param1.relInfo.targetId)
            {
               _loc3_[_loc5_] = param1.relInfo;
               return;
            }
            _loc5_++;
         }
         _loc3_.push(param1.relInfo);
      }
      
      protected static function HandleDeleteRelationship(param1:RelationshipDeleteById) : void
      {
         var _loc3_:RelationshipInfo = null;
         if(param1.actorId != GameplayStateData.ActiveSimId)
         {
            return;
         }
         var _loc2_:Vector.<RelationshipInfo> = AllRelationshipInfo;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.targetId == param1.targetId)
            {
               _loc2_.splice(_loc2_.indexOf(_loc3_),1);
               return;
            }
         }
      }
      
      protected static function HandleBuffUpdate(param1:BuffInfo) : void
      {
         var _loc5_:BuffInfo = null;
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         var _loc2_:Vector.<BuffInfo> = sAllBuffInfo;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.buff_id == param1.buff_id)
            {
               if(param1.update_type == BuffInfo.BUFF_UPDATE_TYPE_ADD || param1.update_type == BuffInfo.BUFF_UPDATE_TYPE_UPDATE)
               {
                  _loc2_[_loc4_] = param1;
               }
               else
               {
                  _loc2_.splice(_loc4_,1);
               }
               return;
            }
            _loc4_++;
         }
         if(param1.update_type == BuffInfo.BUFF_UPDATE_TYPE_ADD)
         {
            _loc2_.push(param1);
         }
      }
      
      protected static function HandleScreenSlamMessage(param1:UiScreenSlamMessage) : void
      {
         CommunicationManager.SendUIMessage("ShowScreenSlam",param1);
      }
      
      protected static function HandleSetCareers(param1:FullCareerInfo) : void
      {
         var _loc2_:CareerInfo = null;
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         sFullCareerInfo = param1;
         sAllCareerInfo = new Vector.<CareerInfo>();
         for each(_loc2_ in sFullCareerInfo.careers)
         {
            sAllCareerInfo.push(_loc2_);
         }
      }
      
      protected static function HandleSetAtWorkInfo(param1:SetAtWorkInfo) : void
      {
         var _loc2_:Vector.<CareerInfo> = null;
         var _loc5_:CareerInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:CareerInfo = null;
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         _loc2_ = AllCareerInfo;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(param1.career_uid == _loc5_.uid)
            {
               _loc5_.work_state = param1.work_state;
               _loc5_.panel_string = param1.panel_string;
               _loc5_.tooltip_string = param1.tooltip_string;
               _loc5_.end_time_override = param1.end_time_override;
               _loc5_.enable_go_to_work = param1.enable_go_to_work;
               _loc5_.enable_go_to_work_early = param1.enable_go_to_work_early;
               break;
            }
            if(_loc5_.uni_classes.length)
            {
               _loc6_ = int(_loc5_.uni_classes.length);
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = _loc5_.uni_classes[_loc7_];
                  if(param1.career_uid == _loc8_.uid)
                  {
                     _loc8_.work_state = param1.work_state;
                     _loc8_.panel_string = param1.panel_string;
                     _loc8_.tooltip_string = param1.tooltip_string;
                     _loc8_.end_time_override = param1.end_time_override;
                     _loc8_.enable_go_to_work = param1.enable_go_to_work;
                     _loc8_.enable_go_to_work_early = param1.enable_go_to_work_early;
                     return;
                  }
                  _loc7_++;
               }
            }
            _loc4_++;
         }
      }
      
      protected static function HandleAspirationObjectiveInfoUpdate(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         HandleObjectiveInfoUpdate(_loc2_,sAllObjectiveInfo);
         if(sCurrentGameState != GameStates.PLAY)
         {
            sAllSavedObjectivesUpdate = sAllSavedObjectivesUpdate.concat(param1);
         }
      }
      
      protected static function HandleCompletedAspirationUpdate(param1:AspirationUpdate) : void
      {
         var _loc2_:AspirationUpdate = null;
         if(param1.sim_id == ActiveSimId)
         {
            _loc2_ = AllAspirationUpdateInfo;
            _loc2_.MergeAspirationUpdates(param1);
            MergeAspirationUpdateWithObjectiveInfo(param1);
            if(sCurrentGameState != GameStates.PLAY)
            {
               sAllSavedAspirationUpdate.MergeAspirationUpdates(param1);
            }
         }
         sCurrentAspiration = null;
         sCurrentAspirationTrack = null;
      }
      
      protected static function HandleUnfinishedBusinessAspirationUpdate(param1:UnfinishedBusinessAspirationUpdate) : void
      {
         var _loc2_:UnfinishedBusinessAspirationUpdate = null;
         if(param1.sim_id == ActiveSimId)
         {
            _loc2_ = AllUnfinishedBusinessAspirationUpdateInfo;
            _loc2_.MergeAspirationUpdates(param1);
            MergeUnfinishedBusinessAspirationUpdateWithObjectiveInfo(param1);
            if(sCurrentGameState != GameStates.PLAY)
            {
               sAllSavedUnfinishedBusinessAspirationUpdate.MergeAspirationUpdates(param1);
            }
         }
         sCurrentUnfinishedBusinessAspiration = null;
         sCurrentUnfinishedBusinessAspirationTrack = null;
      }
      
      protected static function HandleSetCurrentWhims(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         CurrentWhims[ActiveSimId] = param1;
      }
      
      protected static function HandleUpdateSimSkill(param1:SimSkillInfo) : void
      {
         var _loc2_:Vector.<SimSkillInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:SimSkillInfo = null;
         if(param1.sim_id == ActiveSimId)
         {
            _loc2_ = AllSkillInfo;
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_];
               if(_loc5_.skill_id == param1.skill_id)
               {
                  _loc2_[_loc4_] = param1;
                  return;
               }
               _loc4_++;
            }
            _loc2_.push(param1);
         }
      }
      
      protected static function HandleSkillProgressUpdate(param1:SkillProgressUpdate) : void
      {
         var _loc2_:Vector.<SkillProgressUpdate> = null;
         var _loc5_:SkillProgressUpdate = null;
         _loc2_ = AllSkillProgressUpdates;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.skill_id == param1.skill_id)
            {
               _loc2_[_loc4_] = param1;
               return;
            }
            _loc4_++;
         }
         _loc2_.push(param1);
      }
      
      protected static function HandleSkillDelete(param1:SkillDelete) : void
      {
         var _loc2_:Vector.<SkillProgressUpdate> = null;
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         _loc2_ = AllSkillProgressUpdates;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].skill_id == param1.skill_id)
            {
               _loc2_.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      protected static function HandleUpdateTraits(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SimTraitsInfo = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Vector.<SimTraitsInfo> = null;
         var _loc7_:SimTraitsInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         if(!param1.hasOwnProperty("traits_to_add") && !param1.hasOwnProperty("traits_to_remove"))
         {
            sAllTraitTypeMap = null;
            sAllTraitIds = null;
         }
         else
         {
            if(param1.hasOwnProperty("traits_to_add"))
            {
               if(!sAllTraitTypeMap)
               {
                  BuildTraitMap();
               }
               if(!sAllTraitIds)
               {
                  AllTraitIds;
               }
               for each(_loc2_ in param1["traits_to_add"])
               {
                  _loc3_ = new SimTraitsInfo(_loc2_);
                  _loc4_ = _loc3_.TraitType;
                  if(!sAllTraitTypeMap[_loc4_])
                  {
                     sAllTraitTypeMap[_loc4_] = new Vector.<SimTraitsInfo>();
                  }
                  _loc5_ = false;
                  _loc6_ = sAllTraitTypeMap[_loc4_];
                  for each(_loc7_ in _loc6_)
                  {
                     if(_loc7_.trait_id == _loc3_.trait_id)
                     {
                        _loc5_ = true;
                        break;
                     }
                  }
                  if(!_loc5_)
                  {
                     _loc3_.IsJustAdded = true;
                     _loc6_.push(_loc3_);
                     sAllTraitIds.push(_loc3_.trait_id);
                  }
                  if(_loc4_ == SimTraitsInfo.TRAIT_GHOST)
                  {
                     SetSimIsGhost(true);
                  }
               }
            }
            if(Boolean(param1.hasOwnProperty("traits_to_remove")) && Boolean(sAllTraitTypeMap) && Boolean(sAllTraitIds))
            {
               for each(_loc2_ in param1["traits_to_remove"])
               {
                  _loc3_ = new SimTraitsInfo(_loc2_);
                  _loc4_ = _loc3_.TraitType;
                  _loc6_ = sAllTraitTypeMap[_loc4_];
                  _loc8_ = -1;
                  if(_loc6_)
                  {
                     _loc10_ = 0;
                     while(_loc10_ < _loc6_.length)
                     {
                        if(_loc6_[_loc10_].trait_id == _loc3_.trait_id)
                        {
                           _loc8_ = _loc10_;
                           break;
                        }
                        _loc10_++;
                     }
                     if(_loc8_ > -1)
                     {
                        _loc6_.splice(_loc8_,1);
                     }
                  }
                  _loc9_ = sAllTraitIds.indexOf(_loc3_.trait_id);
                  if(_loc9_ > -1)
                  {
                     sAllTraitIds.splice(_loc9_,1);
                  }
                  if(_loc4_ == SimTraitsInfo.TRAIT_GHOST)
                  {
                     SetSimIsGhost(false);
                  }
               }
            }
         }
      }
      
      public static function ClearIsJustAddedTrait(param1:SimTraitsInfo) : void
      {
         var _loc3_:SimTraitsInfo = null;
         var _loc2_:Vector.<SimTraitsInfo> = sAllTraitTypeMap[param1.TraitType];
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.trait_id == param1.trait_id)
            {
               _loc3_.IsJustAdded = false;
               return;
            }
         }
      }
      
      public static function ProcessUpdateTraitsMessage(param1:Object, param2:Function, param3:Function, param4:Function, param5:Function = null) : *
      {
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:SimTraitsInfo = null;
         if(!param1.hasOwnProperty("traits_to_add") && !param1.hasOwnProperty("traits_to_remove"))
         {
            if(Boolean(param2))
            {
               param2();
            }
         }
         else
         {
            _loc6_ = false;
            if(param1.hasOwnProperty("traits_to_add") && Boolean(param3))
            {
               for each(_loc7_ in param1["traits_to_add"])
               {
                  _loc8_ = new SimTraitsInfo(_loc7_);
                  if(param3(_loc8_))
                  {
                     _loc6_ = true;
                  }
               }
            }
            if(param1.hasOwnProperty("traits_to_remove") && Boolean(param4))
            {
               for each(_loc7_ in param1["traits_to_remove"])
               {
                  _loc8_ = new SimTraitsInfo(_loc7_);
                  if(param4(_loc8_))
                  {
                     _loc6_ = true;
                  }
               }
            }
            if(_loc6_ && Boolean(param5))
            {
               param5();
            }
         }
      }
      
      public static function HandleSituationScoreUpdate(param1:Object) : void
      {
         var _loc2_:int = ArrayUtils.IndexOfByFieldName(sCurrentSituations,"situation_id",param1.situation_id);
         if(_loc2_ != -1)
         {
            sCurrentSituations[_loc2_].current_level = param1.current_level;
            sCurrentSituations[_loc2_].score = param1.score;
         }
      }
      
      protected static function HandleSetTraitAtRisk(param1:Object) : void
      {
         var _loc4_:SimTraitsInfo = null;
         BuildTraitMap();
         var _loc2_:SimTraitsInfo = new SimTraitsInfo(param1);
         var _loc3_:Vector.<SimTraitsInfo> = sAllTraitTypeMap[_loc2_.TraitType];
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.trait_id == _loc2_.trait_id)
               {
                  _loc4_.at_risk = _loc2_.at_risk;
                  break;
               }
            }
         }
      }
      
      protected static function HandleAspirationSelection(param1:Object) : void
      {
         var _loc2_:String = param1["aspiration_id"];
         if(_loc2_ == "-1")
         {
            return;
         }
         if(_loc2_ == "0")
         {
            sPrimaryAspirationTrackId = null;
         }
         else
         {
            sPrimaryAspirationTrackId = _loc2_;
         }
         sCurrentAspiration = null;
         sCurrentAspirationTrack = null;
      }
      
      protected static function HandleUnfinishedBusinessAspirationSelection(param1:Object) : void
      {
         var _loc2_:String = param1["aspiration_id"];
         if(_loc2_ == "-1")
         {
            return;
         }
         if(_loc2_ == "0")
         {
            sUnfinishedBusinessAspirationTrackId = null;
         }
         else
         {
            sUnfinishedBusinessAspirationTrackId = _loc2_;
         }
         sCurrentUnfinishedBusinessAspiration = null;
         sCurrentUnfinishedBusinessAspirationTrack = null;
      }
      
      protected static function HandleGameSaveLockUnlock(param1:GameSaveLockUnlock) : void
      {
         sLockUnlockMessage = param1;
      }
      
      protected static function HandleUpdateSelectableSims(param1:Object) : void
      {
         var _loc4_:Object = null;
         if(!param1)
         {
            sSelectableSims = new Array();
            return;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1["sims"];
         for each(_loc4_ in _loc3_)
         {
            _loc2_.push(new SimPB(_loc4_));
         }
         sSelectableSims = _loc2_;
      }
      
      protected static function HandleSetWhimBucks(param1:SetWhimBucks) : void
      {
         sSatisfactionPoints = int(param1.whim_bucks);
      }
      
      protected static function HandleMoodUpdate(param1:MoodUpdate) : void
      {
         if(param1.sim_id == ActiveSimId)
         {
            sCurrentMood = param1;
         }
      }
      
      protected static function HandleScenarioStart(param1:Object) : void
      {
         if(!param1 || !("scenario_id" in param1))
         {
            return;
         }
         var _loc2_:String = param1.scenario_id;
         HandleSituationStart(null,_loc2_);
         if(Boolean(_loc2_) && UISettings.AccountSettings.ListStoreValue(ScenarioTunables.SETTINGS_STARTED_KEY,_loc2_))
         {
            CommunicationManager.SendUIMessage("ShowScenarios",{
               "dialogName":ScenariosSharedTunables.SCENARIOS_SCENARIO_DIALOG_DETAILS,
               "scenarioData":ScenarioStaticData.GetStaticData(_loc2_),
               "source":TelemetryConstants.SCENARIO_DETAILS_SOURCE_FIRST_TIME_LIVE
            });
         }
      }
      
      protected static function HandleSituationStart(param1:Object, param2:String = null, param3:Boolean = false, param4:String = null) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(param1 != null)
         {
            sCurrentSituations = param1.situations as Array;
         }
         if(param2 == null)
         {
            param2 = CommunicationManager.CallGameService("GetCurrentScenario") as String;
         }
         if(param4 == null)
         {
            param4 = GetCurrentLiveEventId();
         }
         var _loc5_:Array = sCurrentSituations as Array;
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.situation_id)
            {
               _loc6_["is_new_situation"] = !param3 && _loc6_["first_time"] == true;
               _loc6_["is_minimized"] = false;
               _loc6_.sort_id = _loc6_.pivotal_moment_guid;
            }
            else
            {
               _loc6_.display_type = parseInt(_loc6_.display_type);
               _loc6_.is_new_situation = false;
               _loc6_.situation_guid = _loc6_.pivotal_moment_guid;
               _loc6_.user_facing_type = SituationStart.SITUATION_USERFACING_TYPE_PIVOTAL_MOMENT;
               _loc6_.is_minimized = true;
               _loc6_.icon_info = new IconInfo();
               _loc6_.icon_info.icon = new ResourceKey();
               _loc6_.icon_info.name = LocKey.FromHash(_loc6_.display_name.hash);
               _loc6_.sort_id = _loc6_.pivotal_moment_guid;
            }
         }
         sCurrentSituations = _loc5_;
         CommunicationManager.SendUIMessage("ShowSituationDisplay",{
            "situations":_loc5_,
            "scenarioId":param2,
            "liveEventId":param4
         });
         ChallengeNotificationData.HideChallengeDisplay();
         for each(_loc7_ in sUnhandledSituationMessages)
         {
            CommunicationManager.SendUIMessage(_loc7_.messageName,_loc7_.args);
         }
         sUnhandledSituationMessages.length = 0;
      }
      
      protected static function HandleSituationEnd(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc2_:String = CommunicationManager.CallGameService("GetCurrentScenario") as String;
         var _loc3_:Array = sCurrentSituations;
         if(Boolean(_loc3_) && param1.hasOwnProperty("situation_id"))
         {
            _loc5_ = ArrayUtils.IndexOfByFieldName(_loc3_,"situation_id",param1["situation_id"]);
            if(_loc5_ == -1)
            {
               _loc5_ = ArrayUtils.IndexOfByFieldName(_loc3_,"situation_guid",param1["situation_id"]);
            }
            if(_loc5_ != -1)
            {
               _loc3_.splice(_loc5_,1);
            }
         }
         var _loc4_:String = GetCurrentLiveEventId();
         if(Boolean(_loc3_ && _loc3_.length > 0) || Boolean(_loc2_ != null) || _loc4_ != null)
         {
            CommunicationManager.SendUIMessage("ShowSituationDisplay",{
               "situations":_loc3_,
               "scenarioId":_loc2_,
               "liveEventId":_loc4_
            });
            return;
         }
         CommunicationManager.SendUIMessage("HideSituationDisplay",param1);
         ChallengeNotificationData.TryShowChallengeDisplay();
      }
      
      protected static function HandleSituationGoalsUpdate(param1:Object) : void
      {
         if(GameStateFlags.IsBetweenStates)
         {
            sUnhandledSituationMessages.push({
               "messageName":"SituationGoalsUpdate",
               "args":param1
            });
         }
      }
      
      protected static function HandleScenarioGoalsUpdate(param1:Object) : void
      {
         if(GameStateFlags.IsBetweenStates)
         {
            sUnhandledSituationMessages.push({
               "messageName":"ScenarioGoalsUpdate",
               "args":param1
            });
         }
      }
      
      protected static function GetCurrentLiveEventId() : String
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:LiveEventData = null;
         var _loc1_:Array = GetAllLiveEventIds(true);
         var _loc2_:String = _loc1_ != null && _loc1_.length > 0 ? _loc1_[0] : null;
         if(_loc2_ == null)
         {
            _loc1_ = GetAllLiveEventIds();
            if(_loc1_ == null || _loc1_.length == 0)
            {
               return null;
            }
            for each(_loc3_ in _loc1_)
            {
               _loc4_ = CommunicationManager.CallGameService("GetLiveEventData",{"eventId":_loc3_}) as Object;
               if(_loc4_)
               {
                  _loc5_ = new LiveEventData(_loc4_);
                  if(_loc5_.eventState == LiveEventSharedTunables.LIVE_EVENT_STATE_AFTER_LAST_PERIOD)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      protected static function GetAllLiveEventIds(param1:Boolean = false) : Array
      {
         return CommunicationManager.CallGameService("GetLiveEventIdsByType",{
            "type":LiveEventSharedTunables.LIVE_EVENT_TYPE_UNKNOWN,
            "onlyActive":param1
         }) as Array;
      }
      
      protected static function HandleScenarioOutcome(param1:ScenarioOutcomeData) : void
      {
         CommunicationManager.SendUIMessage("ShowScenarios",{
            "dialogName":ScenariosSharedTunables.SCENARIOS_SCENARIO_DIALOG_OUTCOME,
            "outcomeData":param1
         });
      }
      
      protected static function HandleSituationOutcome(param1:SituationOutcomeData) : void
      {
         var _loc2_:Class = null;
         var _loc3_:IDialog = null;
         var _loc4_:LocalRequestData = null;
         var _loc5_:DialogRequest = null;
         if(sCurrentGameState != GameStates.PLAY)
         {
            if(sDelayedSituationOutcome == null)
            {
               sDelayedSituationOutcome = param1;
            }
         }
         else
         {
            _loc2_ = getDefinitionByName("widgets.Dialog.dialogs.PivotalMomentDetails") as Class;
            if(_loc2_ != null)
            {
               _loc3_ = new _loc2_(param1,SituationSharedTunables.PIVOTAL_MOMENT_DETAILS_SOURCE_OUTCOME);
               _loc4_ = new LocalRequestData();
               _loc4_.options = GenericDialogOption.PAUSE_WHEN_DIALOG_UP_IN_SINGLE_PLAYER;
               _loc5_ = new DialogRequest(_loc3_,_loc4_);
               _loc5_.modality = DialogModality.LOCAL;
               DialogManager.RequestDialog(_loc5_);
            }
         }
      }
      
      protected static function HandleSituationPrepare(param1:Object) : void
      {
         CommunicationManager.SendUIMessage("ShowSituationCreation",param1);
      }
      
      protected static function HandleNotifyChallengeEventActivated(param1:Object) : void
      {
         if(sCurrentGameState == GameStates.PLAY)
         {
            ChallengeNotificationData.TryShowChallengeDisplay();
         }
      }
      
      protected static function HandleDynamicSignView(param1:Object) : void
      {
         if(Boolean(CommunicationManager.CallUIService("IsWidgetLoading","ScreenSlam")) || Boolean(CommunicationManager.CallUIService("IsWidgetVisible","ScreenSlam")))
         {
            sDynamicSignShowArgs = param1;
            return;
         }
         CommunicationManager.SendUIMessage("ShowDynamicSignDialog",param1);
      }
      
      protected static function OnScreenSlamHidden() : void
      {
         if(sDynamicSignShowArgs)
         {
            CommunicationManager.SendUIMessage("ShowDynamicSignDialog",sDynamicSignShowArgs);
            sDynamicSignShowArgs = null;
         }
      }
      
      protected static function HandleCollectibleItemUpdate(param1:CollectibleItemUpdate) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:CollectionItemData = HouseholdCollection.GetItemData(param1.object_def_id);
         if(_loc2_)
         {
            _loc2_.UpdateInfo = param1;
         }
      }
      
      protected static function HandleSetBuckFunds(param1:SetBuckFunds) : void
      {
         var _loc2_:uint = GetBuckFunds(param1.bucks_type);
         if(_loc2_ != param1.available_funds)
         {
            sHouseholdBuckFunds[param1.bucks_type] = param1.available_funds;
         }
      }
      
      protected static function HandleSetSimBuckFunds(param1:SetBuckFunds) : void
      {
         var _loc2_:uint = GetActiveSimBuckFunds(param1.bucks_type);
         if(_loc2_ != param1.available_funds)
         {
            sActiveSimBuckFunds[param1.bucks_type] = param1.available_funds;
         }
      }
      
      protected static function HandleTransitionScreenHidden(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(sCurrentGameState == GameStates.PLAY)
         {
            _loc2_ = UISettings.SessionSettings.GetValue("ClubOutfitsData");
            if(_loc2_)
            {
               CommunicationManager.SendUIMessage("ShowClubOutfits",{
                  "outfit":true,
                  "cache":_loc2_,
                  "bSkipAnimation":true
               });
            }
            _loc3_ = TelemetryManager.GetSessionValue("StartGameLoadTimer");
            if(_loc3_)
            {
               _loc4_ = {
                  "time":getTimer() - _loc3_["timer"],
                  "svid":_loc3_["saveSlotId"],
                  "actn":_loc3_["action"]
               };
               TelemetryManager.DispatchTelemetryEvent("GAME","SAVE","LDTM",_loc4_);
               TelemetryManager.SetSessionValue("StartGameLoadTimer",null);
            }
         }
      }
      
      protected static function HandleActiveSimLeftGathering(param1:Object) : void
      {
         sActiveSimGatheringClubId = null;
      }
      
      protected static function HandleActiveSimJoinedGathering(param1:Object) : void
      {
         sActiveSimGatheringClubId = param1 as String;
      }
      
      protected static function HandleSimOccultTypeUpdate(param1:OccultUpdate) : void
      {
         if(param1.simId != ActiveSimId)
         {
            return;
         }
         sSimOccultUpdate = param1;
      }
      
      protected static function HandleRankedStatisticProgressUpdate(param1:RankedStatisticProgressUpdate) : void
      {
         var _loc4_:Vector.<RankedStatisticProgressUpdate> = null;
         if(param1.simId != ActiveSimId)
         {
            return;
         }
         var _loc2_:String = param1.stat_id;
         var _loc3_:Dictionary = AllDefaultRankedStatisticProgressUpdates;
         if(_loc2_ in _loc3_)
         {
            delete _loc3_[_loc2_];
         }
         _loc4_ = AllSimRankedStatisticProgressUpdates;
         var _loc5_:* = _loc4_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_[_loc6_].stat_id == _loc2_)
            {
               _loc4_[_loc6_] = param1;
               return;
            }
            _loc6_++;
         }
         _loc4_.push(param1);
      }
      
      protected static function HandleSendActiveHolidayInfo(param1:Object) : void
      {
         sActiveHoliday = new SendActiveHolidayInfo(param1);
         if(param1.holiday_type)
         {
            sActiveHoliday.holiday_info.holiday_type = param1.holiday_type;
         }
      }
      
      protected static function HandleTutorialModeChanged(param1:Object = null) : void
      {
         ChallengeNotificationData.TryShowChallengeDisplay();
      }
      
      protected static function HandleNewPlayerGuidanceUpdate(param1:Boolean) : void
      {
         sIsNewPlayerGuidanceActive = param1;
         CommunicationManager.SendUIMessage("NewPlayerGuidanceRefresh");
      }
      
      protected static function HandleSetUIAccountSettingsValue(param1:Object) : void
      {
         var _loc2_:String = param1["key"];
         var _loc3_:String = param1["value"];
         UISettings.AccountSettings.SetValue(_loc2_,_loc3_);
      }
      
      protected static function HandleLuckUpdate(param1:Object = null) : void
      {
         if(param1.sim_id != ActiveSimId)
         {
            return;
         }
         sLuckLevel = param1.current_level;
         sHasLuckLevel = true;
      }
      
      protected static function HandleGameplayDataReady(param1:Object) : void
      {
         sIsGameplayDataReady = true;
      }
      
      public static function ClearSimInfo() : void
      {
         sSimAgeUpdate = null;
         sSimAgeProgressUpdate = null;
         sAllRelationshipInfo = null;
         sAllBuffInfo = null;
         sAllCareerInfo = null;
         sAllAspirationUpdateInfo = null;
         sAllUnfinishedBusinessAspirationUpdateInfo = null;
         sPrimaryAspirationTrackId = null;
         sCurrentAspiration = null;
         sCurrentAspirationTrack = null;
         sCurrentUnfinishedBusinessAspiration = null;
         sCurrentUnfinishedBusinessAspirationTrack = null;
         sAllSkillProgressUpdates = null;
         sAllSkillInfo = null;
         sAllTraitTypeMap = null;
         sAllTraitIds = null;
         sAllAspirationInfo = new Object();
         sAllObjectiveInfo = new Object();
         sSimGender = VALUE_REQUIRES_UPDATE;
         sSimIdentity = null;
         sSatisfactionPoints = VALUE_REQUIRES_UPDATE;
         sCurrentMood = null;
         sActiveSimGatheringClubId = null;
         sActiveSimBuckFunds = null;
         sSimOccultUpdate = null;
         sSimSpecies = VALUE_REQUIRES_UPDATE;
         sSimIsGhost = false;
         sAllRankedStatisticProgressUpdates = null;
         sAllDefaultRankedStatisticProgressUpdates = null;
         sFullCareerInfo = null;
         sLuckLevel = VALUE_REQUIRES_UPDATE;
         sHasLuckLevel = false;
      }
      
      protected static function GetObjectiveInfos(param1:Array, param2:String, param3:Object) : Vector.<ObjectiveInfo>
      {
         var _loc6_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:ObjectiveInfo = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = int(param1.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = param1[_loc6_];
            if(!(_loc8_ in param3))
            {
               _loc4_.push(_loc8_);
            }
            _loc6_++;
         }
         if(_loc4_.length > 0)
         {
            _loc9_ = CommunicationManager.CallGameService(param2,{
               "simId":ActiveSimId,
               "objectiveIds":_loc4_
            }) as Array;
            _loc10_ = int(_loc9_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc10_)
            {
               _loc11_ = new ObjectiveInfo(_loc9_[_loc6_]);
               param3[_loc11_.uid] = _loc11_;
               _loc6_++;
            }
         }
         var _loc7_:Vector.<ObjectiveInfo> = new Vector.<ObjectiveInfo>();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = param1[_loc6_];
            if(_loc8_ in param3)
            {
               _loc7_.push(param3[_loc8_]);
            }
            _loc6_++;
         }
         return _loc7_;
      }
      
      protected static function HandleObjectiveInfoUpdate(param1:Array, param2:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:ObjectiveInfo = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.uid;
            if(_loc6_ in param2)
            {
               _loc7_ = param2[_loc6_];
               _loc7_.numCompleted = _loc5_.numCompleted;
               _loc7_.numTotal = _loc5_.numTotal;
            }
            else
            {
               _loc7_ = new ObjectiveInfo(_loc5_);
               param2[_loc6_] = _loc7_;
            }
            _loc4_++;
         }
      }
      
      protected static function MergeAspirationUpdateWithObjectiveInfo(param1:AspirationUpdate) : void
      {
         var _loc2_:ObjectiveInfo = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Array = param1.objectives_completed;
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_ in sAllObjectiveInfo)
            {
               _loc2_ = sAllObjectiveInfo[_loc5_] as ObjectiveInfo;
               ForceComplete(_loc2_);
            }
            else
            {
               _loc3_.push(_loc5_);
            }
         }
         _loc6_ = param1.objectives_reset;
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_ in sAllObjectiveInfo)
            {
               _loc2_ = sAllObjectiveInfo[_loc7_] as ObjectiveInfo;
               _loc2_.numCompleted = 0;
            }
         }
         if(_loc3_.length > 0)
         {
            _loc8_ = CommunicationManager.CallGameService("GetObjectiveInfo",{
               "simId":ActiveSimId,
               "objectiveIds":_loc3_
            }) as Array;
            _loc9_ = _loc8_ ? int(_loc8_.length) : 0;
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc2_ = new ObjectiveInfo(_loc8_[_loc10_]);
               _loc2_.numCompleted = _loc2_.numTotal;
               sAllObjectiveInfo[_loc2_.uid] = _loc2_;
               _loc10_++;
            }
         }
      }
      
      protected static function MergeUnfinishedBusinessAspirationUpdateWithObjectiveInfo(param1:UnfinishedBusinessAspirationUpdate) : void
      {
         var _loc2_:ObjectiveInfo = null;
         var _loc4_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ObjectiveInfo = null;
         var _loc3_:Array = new Array();
         _loc4_ = param1.objectives;
         var _loc5_:Array = param1.unfinishedBusinessObjectivesCompleted;
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_ in sAllUnfinishedBusinessObjectiveInfo)
            {
               _loc2_ = sAllUnfinishedBusinessObjectiveInfo[_loc6_] as ObjectiveInfo;
               ForceComplete(_loc2_);
            }
            else
            {
               _loc3_.push(_loc6_);
            }
         }
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_ in sAllUnfinishedBusinessObjectiveInfo)
            {
               _loc2_ = sAllUnfinishedBusinessObjectiveInfo[_loc6_] as ObjectiveInfo;
               ForceComplete(_loc2_);
            }
            else
            {
               _loc3_.push(_loc6_);
            }
         }
         if(_loc3_.length > 0)
         {
            _loc4_ = CommunicationManager.CallGameService("GetObjectiveInfo",{
               "simId":ActiveSimId,
               "objectiveIds":_loc3_
            }) as Array;
            _loc7_ = _loc4_ ? int(_loc4_.length) : 0;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc2_ = new ObjectiveInfo(_loc4_[_loc8_]);
               _loc2_.numCompleted = _loc2_.numTotal;
               _loc9_ = sAllUnfinishedBusinessObjectiveInfo[_loc2_.uid] as ObjectiveInfo;
               if(_loc9_ != null)
               {
                  _loc2_.animationState = _loc9_.animationState;
               }
               sAllUnfinishedBusinessObjectiveInfo[_loc2_.uid] = _loc2_;
               _loc8_++;
            }
         }
      }
      
      protected static function SetSimIsGhost(param1:Boolean) : void
      {
         if(param1 == sSimIsGhost)
         {
            return;
         }
         sSimIsGhost = param1;
         CommunicationManager.SendUIMessage("SimGhostUpdate",{
            "simId":ActiveSimId,
            "simIsGhost":sSimIsGhost
         });
      }
      
      protected static function ForceComplete(param1:ObjectiveInfo) : void
      {
         param1.numCompleted = param1.numTotal;
      }
      
      public static function get IsGameplayDataReady() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!sIsGameplayDataReady)
         {
            if(CommunicationManager.CallGameService("IsGameplayDataReady"))
            {
               sIsGameplayDataReady = true;
               return true;
            }
            _loc1_ = getTimer();
            if(sGameplayDataReadyStartTime < 0)
            {
               sGameplayDataReadyStartTime = _loc1_;
            }
            else
            {
               _loc2_ = _loc1_ - sGameplayDataReadyStartTime;
               if(_loc2_ >= GAMEPLAY_DATA_READY_TIMEOUT_MS)
               {
                  sIsGameplayDataReady = true;
               }
            }
         }
         return sIsGameplayDataReady;
      }
   }
}

