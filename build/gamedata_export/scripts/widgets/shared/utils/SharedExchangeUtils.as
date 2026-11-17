package widgets.shared.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import gamedata.Dialog.UiDialogChoiceMessage;
   import gamedata.Dialog.UiExchangeArgs;
   import gamedata.Exchange.CGChallengeData;
   import gamedata.Exchange.ExchangeData;
   import gamedata.Exchange.ExchangeSimData;
   import gamedata.Exchange.FeedData;
   import gamedata.MTX.MTXBundleData;
   import gamedata.shared.Species;
   import gamedata.shared.UiDialogNotification;
   import olympus.constants.DialogTypes;
   import olympus.core.ConnectionManager;
   import olympus.core.UISettings;
   import olympus.events.PushButtonEvent;
   import olympus.io.CommunicationManager;
   import olympus.io.EventManager;
   import olympus.io.TelemetryManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysConsole;
   import olympus.localization.KeysEXCH;
   import olympus.utils.SystemUtils;
   import widgets.Community.constants.SocialErrorCode;
   import widgets.Exchange.constants.ExchangeErrorCode;
   import widgets.Exchange.constants.ExchangeOps;
   import widgets.Exchange.utils.ExchangeUtils;
   import widgets.shared.constants.ExchangeFiltersData;
   import widgets.shared.constants.ExchangeShareMode;
   import widgets.shared.constants.ServerProfanityCheckCategory;
   import widgets.shared.constants.ServerProfanityCheckResult;
   import widgets.shared.controls.BadgeContainer;
   import widgets.shared.data.ExchangeFilter;
   
   public class SharedExchangeUtils
   {
      
      public static const MODAL_REMAIN_VISIBLE_MESSAGE_NAME:String = "ModalRemainVisible";
      
      public static const SHARE_MODE_COMMUNITY:String = "community";
      
      public static const SHARE_MODE_CG:String = "cg";
      
      public static const SHARE_MODE_LIBRARY:String = "library";
      
      protected static var gTransactionId:uint = 1;
      
      protected static var gTransactionRequestFailedRefId:String = "";
      
      public function SharedExchangeUtils()
      {
         super();
      }
      
      public static function GetTransactionId() : String
      {
         var _loc1_:uint = gTransactionId++;
         return _loc1_.toString();
      }
      
      public static function get TransactionRequestFailedRefId() : String
      {
         return gTransactionRequestFailedRefId;
      }
      
      public static function set TransactionRequestFailedRefId(param1:String) : void
      {
         gTransactionRequestFailedRefId = param1;
      }
      
      public static function DisplayShareLegalNotice(param1:Function = null, param2:Object = null) : Boolean
      {
         if(!ConnectionManager.IsOnlineAccessDisabled && UISettings.AccountSettings.GetValue("exchange.legalNoticeViewed",ExchangeData.LocalOriginId) == null)
         {
            CommunicationManager.SendUIMessage("ShowExchangeLegalNoticeDialog",{
               "callback":param1,
               "callbackArgs":param2
            });
            return true;
         }
         return false;
      }
      
      public static function ShowPlayerProfile(param1:Object = null) : void
      {
         if(!ConnectionManager.IsOnlineAccessEnabledWithWarning())
         {
            return;
         }
         if(DisplayShareLegalNotice(ShowPlayerProfile,param1))
         {
            return;
         }
         if(param1 == null || param1.playerId == ExchangeData.LocalOriginId)
         {
            CommunicationManager.SendUIMessage("ShowExchangeShare",{"mode":ExchangeShareMode.MY_PROFILE});
            CommunicationManager.SendUIMessage("HideExchangePlayerProfile",null);
         }
         else
         {
            CommunicationManager.SendUIMessage("ShowExchangePlayerProfile",{
               "creator_id":param1.playerId,
               "creator_name":param1.playerName,
               "creator_platform_id":param1.playerPlatformId,
               "creator_platform_name":param1.playerPlatformName
            });
         }
      }
      
      public static function ShowGalleryCatalog(param1:Object) : void
      {
         if(!ConnectionManager.IsOnlineAccessEnabledWithWarning())
         {
            return;
         }
         if(ExchangeShareMode.RequiresConnection(param1.mode) && !ConnectionManager.RequestOnlineFeature(ShowGalleryCatalog,param1))
         {
            return;
         }
         if(DisplayShareLegalNotice(ShowGalleryCatalog,param1))
         {
            return;
         }
         CommunicationManager.SendUIMessage("ShowExchangeShare",{
            "mode":param1.mode,
            "filters":param1.filters,
            "applyContext":param1.applyContext
         });
      }
      
      public static function ShowExchangeDetailPanel(param1:Object) : void
      {
         if(!ConnectionManager.IsOnlineAccessEnabledWithWarning())
         {
            return;
         }
         if(!ConnectionManager.RequestOnlineFeature(ShowExchangeDetailPanel,param1))
         {
            return;
         }
         if(DisplayShareLegalNotice(ShowExchangeDetailPanel,param1))
         {
            return;
         }
         CommunicationManager.CallGameService("RequestShowExchangeDetail",param1);
      }
      
      public static function ShowProductInfoWindow(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(!ConnectionManager.RequestOnlineFeature(ShowProductInfoWindow,param1))
         {
            return;
         }
         _loc2_ = CommunicationManager.CallGameService("GetLocaleId",null) as String;
         _loc3_ = CommunicationManager.CallGameService("ProductInfoBaseUrl",null).productinfobaseurl as String;
         var _loc4_:String = _loc3_ + param1 + "&locale=" + _loc2_;
         CommunicationManager.SendUIMessage("ShowWebBrowser",{
            "url":_loc4_,
            "width":1200,
            "height":800
         });
      }
      
      public static function ShowExchangePackDetail(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param2 && !ConnectionManager.IsOnlineAccessEnabledWithWarning())
         {
            return;
         }
         if(!ConnectionManager.RequestAMPAvailableFeature(ShowExchangePackDetail,param1))
         {
            return;
         }
         if(param1)
         {
            _loc3_ = {};
            if(param1.hasOwnProperty("bundles"))
            {
               _loc4_ = int(param1["bundles"].length);
               if(_loc4_ > 0)
               {
                  _loc5_ = 0;
                  if(param1.hasOwnProperty("bundleIndex"))
                  {
                     _loc6_ = int(param1["bundleIndex"]);
                     if(_loc6_ >= 0 && _loc6_ < _loc4_)
                     {
                        _loc5_ = int(param1["bundleIndex"]);
                     }
                     delete param1["bundleIndex"];
                  }
                  _loc3_ = param1["bundles"][_loc5_];
               }
               delete param1["bundles"];
            }
            else if(param1.hasOwnProperty("bundleData"))
            {
               if(param1["bundleData"])
               {
                  _loc3_ = param1["bundleData"];
               }
               delete param1["bundleData"];
            }
            if(!param1.hasOwnProperty("bundleId"))
            {
               param1["bundleId"] = _loc3_.bundleId;
            }
            if(Boolean(_loc3_) && Boolean(_loc3_ as MTXBundleData))
            {
               param1["usedItemIdList"] = _loc3_.usedItemIdList;
            }
         }
         CommunicationManager.SendUIMessage("ShowExchangePackDetail",param1);
      }
      
      public static function ShowMTXCatalog(param1:Object) : void
      {
         if(!ConnectionManager.RequestInternetConnection(ShowMTXCatalog,param1))
         {
            return;
         }
         CommunicationManager.CallGameService("MTXDisplayCatalog",param1);
      }
      
      public static function DownloadNewEntitlements() : void
      {
         var _loc5_:String = null;
         CommunicationManager.CallGameService("MTXDownloadNewEntitlements");
         var _loc1_:Boolean = CommunicationManager.CallGameService("GetIsIgoEnabled") as Boolean;
         var _loc2_:Boolean = CommunicationManager.CallGameService("GetIsIgoAvailable") as Boolean;
         var _loc3_:Boolean = SystemUtils.DistributionPlatform == SystemUtils.DISTRIBUTION_PLATFORM_STEAM;
         var _loc4_:String = _loc1_ && _loc2_ && !_loc3_ ? (SystemUtils.IsMac ? Keys.MTX_DOWNLOAD_PREP_DESC_MAC.toString() : Keys.MTX_DOWNLOAD_PREP_DESC.toString()) : Keys.MTX_DOWNLOAD_PREP_DESC_IGO_DISABLED.toString();
         if(CommunicationManager.CallUIService("IsWidgetVisible","ExchangeDetail"))
         {
            _loc5_ = CommunicationManager.CallUIService("GetSavedForLaterMessage") as String;
            if(_loc5_.length > 0)
            {
               _loc4_ += "\n\n" + _loc5_;
               CommunicationManager.SendUIMessage("ExchangeDetailSaveItem",null);
            }
         }
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES,
            "title":Keys.MTX_DOWNLOAD_PREP_TITLE.toString(),
            "description":_loc4_,
            "optionOneText":Keys.GENERIC_OK.toString()
         });
      }
      
      public static function DownloadAvailableEntitlements() : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(SystemUtils.IsXB1 || SystemUtils.IsPS4)
         {
            return;
         }
         var _loc1_:Array = CommunicationManager.CallGameService("MTXGetEntitlementsForDownload") as Array;
         if(_loc1_.length == 0)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:String = UISettings.AccountSettings.GetValue("mtx.notifiedpackinstall") as String;
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            for each(_loc5_ in _loc1_)
            {
               if(_loc4_.indexOf(_loc5_) == -1)
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         else
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            UISettings.AccountSettings.SetValue("mtx.notifiedpackinstall",_loc1_.join());
            CommunicationManager.CallGameService("MTXDownloadNewEntitlements");
         }
      }
      
      public static function ShowDownloadInProgressDialog(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         if(param1 == true)
         {
            _loc2_ = CommunicationManager.CallGameService("GetIsIgoEnabled") as Boolean;
            _loc3_ = CommunicationManager.CallGameService("GetIsIgoAvailable") as Boolean;
            _loc4_ = SystemUtils.DistributionPlatform == SystemUtils.DISTRIBUTION_PLATFORM_STEAM;
            _loc5_ = _loc2_ && _loc3_ && !_loc4_ ? (SystemUtils.IsMac ? Keys.MTX_DOWNLOAD_IN_PROGRESS_DESC_MAC.toString() : Keys.MTX_DOWNLOAD_IN_PROGRESS_DESC.toString()) : Keys.MTX_DOWNLOAD_IN_PROGRESS_DESC_IGO_DISABLED.toString();
            CommunicationManager.SendUIMessage("ShowDialog",{
               "dialog_id":"MTXPackDownloadInProgress",
               "type":DialogTypes.SINGLE_BUTTON,
               "title":Keys.MTX_DOWNLOAD_IN_PROGRESS_TITLE.toString(),
               "description":_loc5_,
               "optionOneText":Keys.GENERIC_OK.toString()
            });
         }
      }
      
      public static function SetDownloadInProgressHandler(param1:DisplayObject, param2:Boolean) : void
      {
         if(param1)
         {
            if(param2)
            {
               CommunicationManager.AddMessageListener("ShowDownloadInProgressDialog",ShowDownloadInProgressDialog,param1);
            }
            else
            {
               CommunicationManager.RemoveMessageListener("ShowDownloadInProgressDialog",ShowDownloadInProgressDialog,param1);
            }
         }
      }
      
      public static function DownloadToMySaves(param1:ExchangeData, param2:Boolean = false) : void
      {
         CommunicationManager.CallGameService("ExchangeDownloadItem",{
            "remoteId":param1.remote_id,
            "isTemp":param2
         });
      }
      
      public static function SetFavorite(param1:ExchangeData, param2:Boolean) : String
      {
         TransactionRequestFailedRefId = "";
         return CommunicationManager.CallGameService("ExchangeSetFavorite",{
            "remoteId":param1.remote_id,
            "localId":param1.id,
            "itemType":param1.type,
            "isAdd":param2
         }) as String;
      }
      
      public static function SetExchangeOpErrorHandler(param1:DisplayObject, param2:Boolean) : void
      {
         if(param1)
         {
            if(param2)
            {
               CommunicationManager.AddMessageListener("ExchangeOpResult",ExchangeOpErrorResultHandler,param1);
            }
            else
            {
               CommunicationManager.RemoveMessageListener("ExchangeOpResult",ExchangeOpErrorResultHandler,param1);
            }
         }
      }
      
      public static function ExchangeOpErrorResultHandler(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = param1.result == ExchangeErrorCode.EXCHANGE_OP_RESULT_SUCCESS;
         switch(param1.opcode)
         {
            case ExchangeOps.RESULT_EOP_ADD_FAVORITE:
            case ExchangeOps.RESULT_EOP_REMOVE_FAVORITE:
               if(!_loc2_)
               {
                  _loc3_ = param1["refId"];
                  if(_loc3_)
                  {
                     SharedExchangeUtils.TransactionRequestFailedRefId = _loc3_;
                  }
               }
         }
      }
      
      public static function CheckServerResponse(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if("result" in param1)
         {
            return param1.result == ExchangeErrorCode.EXCHANGE_OP_RESULT_SUCCESS;
         }
         if("error" in param1)
         {
            return param1.error == SocialErrorCode.SOCE_NOERROR;
         }
         return true;
      }
      
      public static function DisplayServerProfanityErrorDialog(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:String = null;
         if(HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_ANY))
         {
            _loc2_ = KeysEXCH.SERVER_ERROR_PROFANITY_GENERIC.toString();
            if(HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_NAME_FIRST) || HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_NAME_LAST))
            {
               _loc2_ = KeysEXCH.SERVER_ERROR_PROFANITY_SIM_NAME.toString();
            }
            else if(HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_BREED))
            {
               _loc2_ = KeysEXCH.SERVER_ERROR_PROFANITY_BREED_NAME.toString();
            }
            else if(HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_PRONOUN))
            {
               _loc2_ = KeysEXCH.SERVER_ERROR_PROFANITY_PRONOUN.toString();
            }
            else if(HasServerReponseDetectedProfanity(param1,ServerProfanityCheckCategory.CAT_COMMENT))
            {
               _loc2_ = KeysEXCH.SERVER_ERROR_PROFANITY_COMMENT.toString();
            }
         }
         if(_loc2_ != null)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "description":_loc2_,
               "optionOneText":Keys.GENERIC_OK.toString()
            });
         }
         return _loc2_ != null;
      }
      
      public static function DisplayServerErrorDialog(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            return;
         }
         if(DisplayServerProfanityErrorDialog(param1))
         {
            return;
         }
         if("error" in param1 && param1.error == ExchangeErrorCode.EXCHANGE_OP_RESULT_FAIL_THROTTLE || "result" in param1 && param1.result == ExchangeErrorCode.EXCHANGE_OP_RESULT_FAIL_THROTTLE)
         {
            _loc2_ = KeysEXCH.SERVER_ERROR_SPAM.toString();
         }
         else if("error" in param1 && param1.error == SocialErrorCode.SOCE_USER_BLOCKED)
         {
            _loc2_ = KeysEXCH.COMMENTS_DISABLED_ACCESS.toString();
         }
         else
         {
            _loc2_ = KeysEXCH.SERVER_ERROR_GENERIC.toString();
         }
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.SINGLE_BUTTON,
            "description":_loc2_,
            "optionOneText":Keys.GENERIC_OK.toString()
         });
      }
      
      public static function HasServerReponseDetectedProfanity(param1:Object, param2:int) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Object = param1["ugc_share_msg"];
         if(_loc3_ == null)
         {
            return false;
         }
         var _loc4_:Array = _loc3_["ctd_details"];
         if(_loc4_ == null)
         {
            return false;
         }
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = "value" in _loc5_ ? int(_loc5_["value"]) : ServerProfanityCheckResult.RES_UNINTIALIZED;
            if(!(_loc6_ == ServerProfanityCheckResult.RES_UNINTIALIZED || _loc6_ == ServerProfanityCheckResult.RES_PASS))
            {
               _loc7_ = "category" in _loc5_ ? int(_loc5_["category"]) : ServerProfanityCheckCategory.CAT_UNINITIALIZED;
               if(_loc7_ != ServerProfanityCheckCategory.CAT_SERVICE)
               {
                  if(param2 == ServerProfanityCheckCategory.CAT_ANY || _loc7_ == param2)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function GetBreedHashtagsString(param1:ExchangeData) : String
      {
         var _loc4_:ExchangeSimData = null;
         var _loc5_:String = null;
         var _loc2_:String = param1.description;
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            return _loc2_;
         }
         var _loc3_:Array = param1.sim_data;
         for each(_loc4_ in _loc3_)
         {
            if(Species.IsPet(_loc4_.species))
            {
               if(!(!_loc4_.breedName || _loc4_.breedName.length == 0))
               {
                  _loc5_ = KeysEXCH.HASHTAG.toString(_loc4_.breedName.split(" ").join(""));
                  if(!_loc2_ || _loc2_.length == 0)
                  {
                     _loc2_ = _loc5_;
                  }
                  else if(_loc2_.indexOf(_loc5_) == -1)
                  {
                     _loc2_ = Keys.GENERIC_SPACE.toString(_loc2_,_loc5_);
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public static function CanShowSocialFeedNotification(param1:UiDialogNotification) : Boolean
      {
         var _loc2_:UiDialogChoiceMessage = null;
         var _loc3_:UiExchangeArgs = null;
         if(Boolean(param1 && param1.information_level == UiDialogNotification.LEVEL_GALLERY) && Boolean(param1.choices) && param1.choices.length > 0)
         {
            _loc2_ = param1.choices[0] as UiDialogChoiceMessage;
            if(_loc2_)
            {
               _loc3_ = _loc2_.exchange_args;
               if(_loc3_)
               {
                  return SharedExchangeUtils.CanShowSocialFeedItemType(_loc3_.feed_type,_loc3_.creator_id,_loc3_.is_maxis_curated);
               }
            }
         }
         return true;
      }
      
      public static function IsNotificationFromMaxisCurator(param1:UiDialogNotification) : Boolean
      {
         var _loc2_:UiDialogChoiceMessage = null;
         var _loc3_:UiExchangeArgs = null;
         if(Boolean(param1 && param1.information_level == UiDialogNotification.LEVEL_GALLERY) && Boolean(param1.choices) && param1.choices.length > 0)
         {
            _loc2_ = param1.choices[0] as UiDialogChoiceMessage;
            if(_loc2_)
            {
               _loc3_ = _loc2_.exchange_args;
               if(_loc3_)
               {
                  return _loc3_.is_maxis_curated;
               }
            }
         }
         return false;
      }
      
      public static function CanShowSocialFeedItemType(param1:uint, param2:String, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         switch(param1)
         {
            case FeedData.TYPE_ITEM_SHOWCASE:
               return false;
            case FeedData.TYPE_ITEM_FAVORITE:
               if(!param3 && param2 != ExchangeData.LocalOriginId)
               {
                  return false;
               }
               break;
            case FeedData.TYPE_ITEM_DOWNLOAD:
               if(param2 == null)
               {
                  return !param4;
               }
               if(param2 == ExchangeData.LocalOriginId)
               {
                  return false;
               }
               break;
            case FeedData.TYPE_ITEM_UPLOAD:
               if(param4 && param2 == null)
               {
                  return false;
               }
         }
         return true;
      }
      
      public static function StartHashtagSearch(param1:String, param2:int) : void
      {
         var _loc3_:String = param2 == ExchangeShareMode.COMMUNITY ? SHARE_MODE_COMMUNITY : SHARE_MODE_LIBRARY;
         var _loc4_:ExchangeFilter = UISettings.SessionSettings.GetValue("exchangeFilters",_loc3_) as ExchangeFilter;
         if(_loc4_)
         {
            _loc4_.searchType = ExchangeFiltersData.SEARCH_TYPE_HASHTAG;
            _loc4_.searchText = param1;
         }
         else
         {
            _loc4_ = new ExchangeFilter(param2,{
               "searchType":ExchangeFiltersData.SEARCH_TYPE_HASHTAG,
               "searchText":param1
            });
         }
         EventManager.DispatchInteractionEvent(PushButtonEvent.CLICK,"Hyperlink","Exchange","TextField");
         SharedExchangeUtils.ShowGalleryCatalog({
            "mode":param2,
            "filters":_loc4_
         });
      }
      
      public static function IsHomepagePanelAvailable() : Boolean
      {
         return false;
      }
      
      public static function CheckUGCPermitted(param1:Boolean = false) : Boolean
      {
         var _loc2_:Object = new Object();
         _loc2_["silent"] = !param1;
         if(SystemUtils.IsXB1 && param1)
         {
            _loc2_["systemMessageText"] = KeysConsole.PERMISSION_WARNING_UGC_XBOX.toString();
         }
         return Boolean(CommunicationManager.CallGameService("CheckPermissionUGC",_loc2_));
      }
      
      public static function CheckCrossPlatformPlayPermitted(param1:Boolean = false) : Boolean
      {
         var _loc2_:Object = new Object();
         _loc2_["silent"] = !param1;
         if(SystemUtils.IsXB1 && param1)
         {
            _loc2_["systemMessageText"] = KeysConsole.PERMISSION_WARNING_CROSSPLALTFORM_XBOX.toString();
         }
         var _loc3_:Boolean = Boolean(CommunicationManager.CallGameService("CheckPermissionCrossPlatformPlay",_loc2_));
         if(!_loc3_ && SystemUtils.IsPS4 && param1)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":KeysConsole.PERMISSION_WARNING_CROSSPLATFORM_TITLE.toString(),
               "description":KeysConsole.PERMISSION_WARNING_CROSSPLATFORM_BODY.toString(),
               "optionOneText":Keys.GENERIC_OK.toString()
            });
         }
         return _loc3_;
      }
      
      public static function RemoveCGHashtags(param1:ExchangeData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:CGChallengeData = null;
         if(param1.bIsCGItem)
         {
            _loc2_ = CommunicationManager.CallGameService("GetSavedItem",{
               "itemType":param1.type,
               "remoteId":param1.remote_id
            });
            if(_loc2_)
            {
               param1.Update(new ExchangeData(_loc2_));
            }
            _loc3_ = ExchangeData.CGChallengesData;
            for each(_loc4_ in _loc3_)
            {
               param1.description = param1.description.replace(KeysEXCH.HASHTAG_SYMBOL + _loc4_.HashTag,"");
            }
            param1.description = param1.description.replace(KeysEXCH.HASHTAG_SYMBOL + KeysEXCH.CG_ALL_HASHTAG.toString(),"");
            CommunicationManager.CallGameService("UpdateExchangeTrayItem",{
               "localId":param1.id,
               "itemType":param1.type,
               "name":param1.name,
               "description":param1.description,
               "hashtags":ExchangeUtils.ExtractHashTags(param1.description).join(",")
            });
         }
      }
      
      public static function OnShareClick(param1:PushButtonEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:BadgeContainer = null;
         if(!SharedExchangeUtils.DisplayShareLegalNotice(OnShareClick,param1))
         {
            _loc2_ = 0;
            _loc3_ = param1.target as DisplayObjectContainer;
            if(_loc3_)
            {
               _loc4_ = _loc3_["mcBadgeContainer"] as BadgeContainer;
               if(_loc4_)
               {
                  _loc2_ = _loc4_.Value;
               }
            }
            if(CommunicationManager.CallUIService("IsTransitionScreenVisible"))
            {
               return;
            }
            TelemetryManager.DispatchTelemetryEvent("GAME","GALL","SHCL",{"nnot":_loc2_});
            CommunicationManager.SendUIMessage("ToggleExchangeShare",{"mode":(_loc2_ > 0 ? ExchangeShareMode.HOMEPAGE : UISettings.SessionSettings.GetValue("lastViewedMode","share"))});
         }
      }
      
      public static function IsServerProfanityCheckingEnabled() : Boolean
      {
         var _loc1_:Object = CommunicationManager.CallGameService("IsServerProfanityCheckingEnabled");
         return _loc1_ != null ? Boolean(_loc1_) : false;
      }
   }
}

