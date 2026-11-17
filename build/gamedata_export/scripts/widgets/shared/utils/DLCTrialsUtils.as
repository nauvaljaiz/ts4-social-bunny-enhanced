package widgets.shared.utils
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import gamedata.Dialog.UiDialogMessage;
   import gamedata.GameContent;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.MTX.MTXBundleData;
   import olympus.constants.DialogTypes;
   import olympus.constants.GameStates;
   import olympus.core.UISettings;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.utils.DateUtils;
   import widgets.shared.constants.DLCTrialsSharedTunables;
   import widgets.shared.data.DLCTrialUrlData;
   
   public class DLCTrialsUtils
   {
      
      internal static var sFreeTrialProductIds:Array;
      
      internal static var sFreeTrialBundle:MTXBundleData;
      
      internal static var sTrialUrls:DLCTrialUrlData;
      
      internal static var sTrialExpiredTimer:Timer;
      
      internal static const DIALOG_CAN_TRY_IMAGE_BUILDBUY:String = "0x5e052949f5d4f8f6";
      
      internal static const DIALOG_CAN_TRY_IMAGE_CAS:String = "0x15a03f27cacbe049";
      
      public function DLCTrialsUtils()
      {
         super();
      }
      
      protected static function EnsureValid() : void
      {
         if(sFreeTrialProductIds)
         {
            return;
         }
         GetFreeTrialProductIds();
         EnsureFreeTrialBundleValid();
         if(Boolean(sFreeTrialBundle) && !sTrialExpiredTimer)
         {
            SetupTrialExpiredTimer();
         }
         RequestFreeTrialSurveyUrls();
      }
      
      protected static function EnsureFreeTrialBundleValid() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         if(Boolean(sFreeTrialProductIds) && sFreeTrialProductIds.length > 0)
         {
            for each(_loc1_ in sFreeTrialProductIds)
            {
               _loc2_ = CommunicationManager.CallGameService("GetBundleData",{"bundleId":_loc1_});
               if(_loc2_)
               {
                  sFreeTrialBundle = new MTXBundleData(_loc2_);
                  break;
               }
            }
         }
      }
      
      protected static function SetupTrialExpiredTimer() : void
      {
         var _loc1_:Date = sFreeTrialBundle.trialTerminateDate;
         var _loc2_:Date = DateUtils.DateDST();
         DateUtils.DateTimeObjectToDate(CommunicationManager.CallGameService("GetCurrentOriginTime"),_loc2_);
         var _loc3_:Number = _loc1_.time - _loc2_.time;
         if(_loc3_ <= 0)
         {
            OnTrialExpired();
         }
         else
         {
            if(sTrialExpiredTimer)
            {
               sTrialExpiredTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,CheckTrialExpired,false);
            }
            sTrialExpiredTimer = new Timer(_loc3_,1);
            sTrialExpiredTimer.addEventListener(TimerEvent.TIMER_COMPLETE,CheckTrialExpired,false,0,true);
            sTrialExpiredTimer.start();
         }
      }
      
      protected static function OnTrialTimerExpiredGameSaveUnlock() : void
      {
         CommunicationManager.RemoveMessageListenerByName("GameSaveLockUnlock",OnTrialTimerExpiredGameSaveUnlock,"DLCTrialsUtils");
         CommunicationManager.RemoveMessageListenerByName("GameStateLoadComplete",OnTrialTimerExpiredGameSaveUnlock,"DLCTrialsUtils");
         DLCTrialsUtils.OnTrialExpired();
      }
      
      protected static function CheckTrialExpired() : void
      {
         var _loc1_:Date = DateUtils.DateDST();
         DateUtils.DateTimeObjectToDate(CommunicationManager.CallGameService("GetCurrentOriginTime"),_loc1_);
         if(sFreeTrialBundle.trialTerminateDate.time >= _loc1_.time)
         {
            SetupTrialExpiredTimer();
            return;
         }
         if(sTrialExpiredTimer)
         {
            sTrialExpiredTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,CheckTrialExpired,false);
         }
         DLCTrialsUtils.OnTrialExpired();
      }
      
      protected static function OnTrialExpired() : void
      {
         if(GameplayStateData.SaveLocked)
         {
            CommunicationManager.AddMessageListenerByName("GameSaveLockUnlock",OnTrialTimerExpiredGameSaveUnlock,"DLCTrialsUtils");
            return;
         }
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState") as uint;
         if(_loc1_ == GameStates.CAS)
         {
            CommunicationManager.AddMessageListenerByName("GameStateLoadComplete",OnTrialTimerExpiredGameSaveUnlock,"DLCTrialsUtils");
            return;
         }
         if(IsFreeTrial())
         {
            CommunicationManager.SendUIMessage("ShowDLCTrials",{
               "dialogName":"TrialExpired",
               "context":DLCTrialsSharedTunables.TELEMETRY_CONTEXT_TRIAL_EXPIRED_TIMER
            });
         }
         DLCTrialsUtils.NotifyTrialEnded();
      }
      
      public static function GetFreeTrialProductIds() : Array
      {
         if(!sFreeTrialProductIds)
         {
            sFreeTrialProductIds = CommunicationManager.CallGameService("GetRunningTrialsProductIds") as Array;
         }
         return sFreeTrialProductIds;
      }
      
      public static function MarkFreeTrialDataDirty() : void
      {
         sFreeTrialProductIds = null;
      }
      
      public static function IsFreeTrial() : Boolean
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.trialStatus == MTXBundleData.TRIAL_STATUS_ACTIVE;
      }
      
      public static function IsFreeTrialEntitled() : Boolean
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(!_loc1_)
         {
            return false;
         }
         switch(_loc1_.trialStatus)
         {
            case MTXBundleData.TRIAL_STATUS_NOT_MOUNTED:
            case MTXBundleData.TRIAL_STATUS_ACTIVE:
               return true;
            default:
               return false;
         }
      }
      
      public static function IsFreeTrialNotEntitled() : Boolean
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.trialStatus == MTXBundleData.TRIAL_STATUS_NOT_ENTITLED;
      }
      
      public static function GetFreeTrialEndDate() : Date
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(_loc1_)
         {
            return _loc1_.trialTerminateDate;
         }
         return new Date(0);
      }
      
      public static function GetFreeTrialMtxBundle() : MTXBundleData
      {
         EnsureValid();
         if(sFreeTrialBundle)
         {
            return sFreeTrialBundle;
         }
         return null;
      }
      
      public static function GetFreeTrialPackId() : int
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(_loc1_)
         {
            return _loc1_.packId;
         }
         return GameContent.PACKID_UNDEFINED;
      }
      
      public static function GetFreeTrialSurveyUrls(param1:String) : DLCTrialUrlData
      {
         var _loc2_:Object = null;
         if(!sTrialUrls || sTrialUrls.productId != param1)
         {
            _loc2_ = CommunicationManager.CallGameService("GetFreeTrialSurveyUrls",{"productId":param1}) as Object;
            if(_loc2_)
            {
               sTrialUrls = new DLCTrialUrlData(_loc2_);
            }
         }
         return sTrialUrls;
      }
      
      public static function GetDLCTrialConversionSurveyURL(param1:String) : String
      {
         var _loc2_:DLCTrialUrlData = GetFreeTrialSurveyUrls(param1);
         if(_loc2_)
         {
            return _loc2_.surveyConversionUrl;
         }
         return null;
      }
      
      public static function GetDLCTrialExitSurveyURL(param1:String) : String
      {
         var _loc2_:DLCTrialUrlData = GetFreeTrialSurveyUrls(param1);
         if(_loc2_)
         {
            return _loc2_.surveyExitUrl;
         }
         return null;
      }
      
      public static function NotifyTrialEnded() : void
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(!_loc1_)
         {
            return;
         }
         CommunicationManager.CallGameService("FreeTrialTimerExpired",{"productId":_loc1_.bundleId});
         sFreeTrialBundle = null;
         EnsureFreeTrialBundleValid();
         GameContent.Refresh();
         CommunicationManager.SendUIMessage("FreeTrialRefresh");
      }
      
      public static function ShowCanTryDialog(param1:Boolean = false) : void
      {
         var _loc2_:MTXBundleData = GetFreeTrialMtxBundle();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:UiDialogMessage = new UiDialogMessage({
            "title":Keys.DLCTRIALS_DIALOGS_TRYNEWITEMS_TITLE,
            "dialog_type":UiDialogMessage.TYPE_ICONS_LABELS,
            "dialog_style":DialogTypes.STYLE_LARGE_ICON,
            "text":Keys.DLCTRIALS_DIALOGS_TRYNEWITEMS_DESCRIPTION.Clone([_loc2_.name.toString()]),
            "icon_info":{"icon":(param1 ? DIALOG_CAN_TRY_IMAGE_BUILDBUY : DIALOG_CAN_TRY_IMAGE_CAS)},
            "choices":[{
               "audio_event_name":"OKButton",
               "text":Keys.GENERIC_OK
            }]
         });
         CommunicationManager.SendUIMessage("ShowDialog",_loc3_);
      }
      
      public static function SetFreeTrialAccountSetting(param1:String) : void
      {
         var _loc2_:int = GetFreeTrialPackId();
         UISettings.AccountSettings.ListStoreValue(param1,String(_loc2_));
      }
      
      public static function GetFreeTrialAccountSetting(param1:String) : Boolean
      {
         var _loc2_:int = GetFreeTrialPackId();
         return UISettings.AccountSettings.ListContainsValue(param1,String(_loc2_));
      }
      
      public static function ClearFreeTrialAccountSetting(param1:String) : void
      {
         var _loc2_:int = GetFreeTrialPackId();
         UISettings.AccountSettings.ListRemoveValue(param1,String(_loc2_));
      }
      
      public static function SetMountDLCPackOnNextBoot() : void
      {
         var _loc1_:int = DLCTrialsUtils.GetFreeTrialPackId();
         if(DLCTrialsUtils.GetFreeTrialPackId() != GameContent.PACKID_UNDEFINED)
         {
            CommunicationManager.CallGameService("SetPackMountPreference",{"packSkipMountMap":[{
               "packId":_loc1_,
               "skipMount":false
            }]});
         }
      }
      
      public static function ClearMountDLCPackOnNextBoot() : void
      {
         var _loc1_:int = DLCTrialsUtils.GetFreeTrialPackId();
         if(DLCTrialsUtils.GetFreeTrialPackId() != GameContent.PACKID_UNDEFINED)
         {
            CommunicationManager.CallGameService("SetPackMountPreference",{"packSkipMountMap":[{
               "packId":_loc1_,
               "skipMount":true
            }]});
         }
      }
      
      public static function GetTrialTermsText(param1:MTXBundleData) : String
      {
         var _loc2_:Date = param1.trialTerminateDate;
         return Keys.DLCTRIALS_DIALOGS_TERMS.toString({"date":DateUtils.DateToLocalizationDayOfWeekToken(_loc2_)},{"date":DateUtils.DateToLocalizationToken(_loc2_)});
      }
      
      public static function RequestFreeTrialSurveyUrls() : void
      {
         var _loc1_:MTXBundleData = GetFreeTrialMtxBundle();
         if(!_loc1_)
         {
            return;
         }
         sTrialUrls = null;
         CommunicationManager.AddMessageListenerByName("FreeTrialSurveyResponse",HandleFreeTrialSurveyResponse,"DLCTrialsUtils");
         CommunicationManager.CallGameService("RequestDLCTrialMessages",{"response":"FreeTrialSurveyResponse"});
      }
      
      public static function HandleFreeTrialSurveyResponse(param1:Object) : void
      {
         CommunicationManager.RemoveMessageListenerByName("FreeTrialSurveyResponse",HandleFreeTrialSurveyResponse,"DLCTrialsUtils");
         var _loc2_:MTXBundleData = GetFreeTrialMtxBundle();
         if(_loc2_ != null)
         {
            GetFreeTrialSurveyUrls(_loc2_.bundleId);
         }
      }
   }
}

