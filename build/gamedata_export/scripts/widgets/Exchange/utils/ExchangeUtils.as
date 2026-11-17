package widgets.Exchange.utils
{
   import gamedata.BuildBuy.Venues.VenueInfo;
   import gamedata.BuildBuy.constants.BuildBuyLocks;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.Exchange.ExchangeData;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.BuildBuyLockUnlock;
   import olympus.constants.DialogTypes;
   import olympus.constants.GameStates;
   import olympus.core.ConnectionManager;
   import olympus.data.ArrayDataFeed;
   import olympus.dialog.DialogManager;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysEXCH;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import widgets.Dialog.constants.GenericDialogOption;
   import widgets.Exchange.constants.ExchangeTunables;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public final class ExchangeUtils
   {
      
      protected static const UNSHARE_DIALOG:String = "ExchangeDialog_Unshare";
      
      public static const MAX_TEXT_TO_TEXT_FILTER_LENGTH:uint = 25;
      
      public static const MAX_TEXT_TO_IMAGE_FILTER_LENGTH:uint = 25;
      
      public static const MAX_HASHTAG_LENGTH:uint = 25;
      
      public static const HASHTAG_PATTERN:String = "#[\\p{L}\\p{N}]{1,25}";
      
      public function ExchangeUtils()
      {
         super();
      }
      
      public static function PostExchangeServerOp(param1:String, param2:Object) : void
      {
         CommunicationManager.CallGameService("PostExchangeServerOp",{
            "MessageID":param1,
            "commandArgs":param2
         });
      }
      
      public static function UploadToShare(param1:ExchangeData) : Boolean
      {
         var _loc2_:Boolean = CommunicationManager.CallGameService("ShareTrayItem",{
            "id":param1.id,
            "type":param1.type
         }) as Boolean;
         if(!_loc2_)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "description":KeysEXCH.ERROR_SHARE_DESC.toString(),
               "optionOneText":Keys.GENERIC_OK.toString(),
               "widgetName":"ExchangePanel"
            });
            return false;
         }
         return true;
      }
      
      public static function ConfirmRemoveFromShare(param1:ExchangeData, param2:Function) : void
      {
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":KeysEXCH.CONFIRM_REMOVE_FROM_SHARE_TITLE.toString(TextUtils.EscapeHtml(param1.name)),
            "description":(param1.type == ExchangeData.TYPE_HOUSEHOLD ? KeysEXCH.CONFIRM_REMOVE_FROM_SHARE_DESC_HH.toString() : KeysEXCH.CONFIRM_REMOVE_FROM_SHARE_DESC_BP.toString()),
            "options":GenericDialogOption.SMALL_TITLE,
            "optionOneText":KeysEXCH.CONFIRM_BUTTON_REMOVE.toString(),
            "optionOneCallback":param2,
            "closeText":Keys.GENERIC_CANCEL.toString(),
            "closeCallback":ConnectionManager.RemoveConnectionRequiredFeature,
            "closeParams":UNSHARE_DIALOG,
            "widgetName":"ExchangeDetailPanel"
         });
         ExchangeUtils.RegisterDialogWithConnectionManager(UNSHARE_DIALOG);
      }
      
      public static function RemoveFromShare(param1:ExchangeData) : void
      {
         ConnectionManager.RemoveConnectionRequiredFeature(UNSHARE_DIALOG);
         CommunicationManager.CallGameService("ExchangeUnshareItem",{
            "remoteId":param1.remote_id,
            "itemType":param1.type
         });
      }
      
      public static function UploadToCG(param1:ExchangeData) : Boolean
      {
         return CommunicationManager.CallGameService("ShareTrayItem",{
            "id":param1.id,
            "type":param1.type
         }) as Boolean;
      }
      
      public static function ClearPrevShowcased(param1:ArrayDataFeed, param2:String) : Boolean
      {
         var _loc6_:ExchangeData = null;
         var _loc3_:Array = param1.RequestItemsAt(0,param1.length);
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc3_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_.bIsShowcase && _loc6_.remote_id != param2)
            {
               _loc6_.bIsShowcase = false;
               param1.MarkRangeDirty(_loc4_,_loc4_);
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function SetItemFavorite(param1:ArrayDataFeed, param2:String, param3:Boolean, param4:Boolean = false) : Boolean
      {
         var _loc8_:ExchangeData = null;
         var _loc5_:Array = param1.RequestItemsAt(0,param1.length);
         var _loc6_:int = 0;
         var _loc7_:int = int(_loc5_.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc5_[_loc6_];
            if(_loc8_.remote_id == param2)
            {
               _loc8_.favorites = param3 ? uint(_loc8_.favorites + 1) : uint(Math.max(_loc8_.favorites - 1,0));
               _loc8_.bIsFavorited = param3;
               if(param4)
               {
                  param1.MarkRangeDirty(_loc6_,_loc6_);
               }
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      public static function SetTransactionFinished(param1:ArrayDataFeed, param2:String, param3:Boolean = true) : void
      {
         var _loc7_:ExchangeData = null;
         var _loc8_:Boolean = false;
         var _loc4_:Array = param1.RequestItemsAt(0,param1.length);
         var _loc5_:int = 0;
         var _loc6_:int = int(_loc4_.length);
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc4_[_loc5_];
            _loc8_ = false;
            if(_loc7_.mFavoriteOpRef == param2)
            {
               _loc7_.mFavoriteOpRef = null;
               _loc8_ = true;
            }
            if(_loc7_.mSubscribeOpRef == param2)
            {
               _loc7_.mSubscribeOpRef = null;
               _loc8_ = true;
            }
            if(_loc8_ && param3)
            {
               param1.MarkRangeDirty(_loc5_,_loc5_);
            }
            _loc5_++;
         }
      }
      
      public static function RefreshItemsWithPlayerId(param1:ArrayDataFeed, param2:String) : void
      {
         var _loc6_:ExchangeData = null;
         var _loc3_:Array = param1.RequestItemsAt(0,param1.length);
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc3_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_.creator_id == param2 || _loc6_.modifier_id == param2)
            {
               param1.MarkRangeDirty(_loc4_,_loc4_);
            }
            _loc4_++;
         }
      }
      
      public static function SetSubscribeTransationIdToItems(param1:ArrayDataFeed, param2:String, param3:String, param4:Boolean = false) : void
      {
         var _loc8_:ExchangeData = null;
         var _loc5_:Array = param1.RequestItemsAt(0,param1.length);
         var _loc6_:int = 0;
         var _loc7_:int = int(_loc5_.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc5_[_loc6_];
            if(_loc8_.CreatorOrSharerOriginId == param2)
            {
               _loc8_.mSubscribeOpRef = param3;
               if(param4)
               {
                  param1.MarkRangeDirty(_loc6_,_loc6_);
               }
            }
            _loc6_++;
         }
      }
      
      public static function CanApply(param1:uint, param2:uint) : Boolean
      {
         switch(param1)
         {
            case GameStates.CAS:
               return param2 == ExchangeData.TYPE_HOUSEHOLD || param2 == ExchangeData.TYPE_BODY_PART;
            case GameStates.PLAY:
               return param2 == ExchangeData.TYPE_HOUSEHOLD || param2 == ExchangeData.TYPE_BLUEPRINT || param2 == ExchangeData.TYPE_ROOM || param2 == ExchangeData.TYPE_BODY_PART;
            case GameStates.BUILD:
               return param2 == ExchangeData.TYPE_BLUEPRINT || param2 == ExchangeData.TYPE_ROOM;
            case GameStates.LOT_SELECT:
               return param2 == ExchangeData.TYPE_HOUSEHOLD || param2 == ExchangeData.TYPE_BLUEPRINT;
            default:
               return false;
         }
      }
      
      public static function ShowErrorDialog(param1:String, param2:Function = null) : void
      {
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.SINGLE_BUTTON,
            "options":GenericDialogOption.DISABLE_CLOSE_BUTTON,
            "description":param1,
            "optionOneText":Keys.GENERIC_OK.toString(),
            "optionOneCallback":param2,
            "widgetName":"ExchangeUtils"
         });
      }
      
      public static function RegisterDialogWithConnectionManager(param1:String) : void
      {
         var _loc2_:String = DialogManager.GetCurrentRequest().data.dialog_id;
         ConnectionManager.AddConnectionRequiredFeature(param1,DialogManager.CancelRequest,_loc2_);
      }
      
      public static function GetSaveTooltip(param1:uint, param2:Boolean) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_SAVED_BP.toString() : KeysEXCH.DETAIL_TOOLTIP_SAVE_BP.toString();
            case ExchangeData.TYPE_HOUSEHOLD:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_SAVED_HH.toString() : KeysEXCH.DETAIL_TOOLTIP_SAVE_HH.toString();
            case ExchangeData.TYPE_ROOM:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_SAVED_RM.toString() : KeysEXCH.DETAIL_TOOLTIP_SAVE_RM.toString();
            case ExchangeData.TYPE_BODY_PART:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_SAVED_PART.toString() : KeysEXCH.DETAIL_TOOLTIP_SAVE_PART.toString();
            default:
               return null;
         }
      }
      
      public static function GetShareTooltip(param1:uint, param2:Boolean) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSHARE_BP.toString() : KeysEXCH.DETAIL_TOOLTIP_SHARE_BP.toString();
            case ExchangeData.TYPE_HOUSEHOLD:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSHARE_HH.toString() : KeysEXCH.DETAIL_TOOLTIP_SHARE_HH.toString();
            case ExchangeData.TYPE_ROOM:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSHARE_RM.toString() : KeysEXCH.DETAIL_TOOLTIP_SHARE_RM.toString();
            case ExchangeData.TYPE_BODY_PART:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSHARE_PART.toString() : KeysEXCH.DETAIL_TOOLTIP_SHARE_PART.toString();
            default:
               return null;
         }
      }
      
      public static function GetSubmitTooltip(param1:uint, param2:Boolean, param3:String) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSUBMIT_BP.toString(param3) : KeysEXCH.DETAIL_TOOLTIP_SUBMIT_BP.toString(param3);
            case ExchangeData.TYPE_HOUSEHOLD:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNSUBMIT_HH.toString(param3) : KeysEXCH.DETAIL_TOOLTIP_SUBMIT_HH.toString(param3);
            default:
               return null;
         }
      }
      
      public static function GetFavoriteTooltip(param1:uint, param2:Boolean) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNFAVORITE_BP.toString() : KeysEXCH.DETAIL_TOOLTIP_FAVORITE_BP.toString();
            case ExchangeData.TYPE_HOUSEHOLD:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNFAVORITE_HH.toString() : KeysEXCH.DETAIL_TOOLTIP_FAVORITE_HH.toString();
            case ExchangeData.TYPE_ROOM:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNFAVORITE_RM.toString() : KeysEXCH.DETAIL_TOOLTIP_FAVORITE_RM.toString();
            case ExchangeData.TYPE_BODY_PART:
               return param2 ? KeysEXCH.DETAIL_TOOLTIP_UNFAVORITE_PART.toString() : KeysEXCH.DETAIL_TOOLTIP_FAVORITE_PART.toString();
            default:
               return null;
         }
      }
      
      public static function GetFacebookTooltip(param1:uint) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return KeysEXCH.DETAIL_TOOLTIP_FACEBOOK_BP.toString();
            case ExchangeData.TYPE_HOUSEHOLD:
               return KeysEXCH.DETAIL_TOOLTIP_FACEBOOK_HH.toString();
            case ExchangeData.TYPE_ROOM:
               return KeysEXCH.DETAIL_TOOLTIP_FACEBOOK_RM.toString();
            case ExchangeData.TYPE_BODY_PART:
               return KeysEXCH.DETAIL_TOOLTIP_FACEBOOK_PART.toString();
            default:
               return null;
         }
      }
      
      public static function GetTwitterTooltip(param1:uint) : String
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return KeysEXCH.DETAIL_TOOLTIP_TWITTER_BP.toString();
            case ExchangeData.TYPE_HOUSEHOLD:
               return KeysEXCH.DETAIL_TOOLTIP_TWITTER_HH.toString();
            case ExchangeData.TYPE_ROOM:
               return KeysEXCH.DETAIL_TOOLTIP_TWITTER_RM.toString();
            case ExchangeData.TYPE_BODY_PART:
               return KeysEXCH.DETAIL_TOOLTIP_TWITTER_PART.toString();
            default:
               return null;
         }
      }
      
      public static function GetBuildBuyDisabledReason() : String
      {
         var _loc3_:LocKey = null;
         var _loc4_:uint = 0;
         var _loc1_:VenueInfo = BuildBuyStateData.CurrentVenueInfo;
         if(Boolean(!BuildBuyStateData.IsLotOwnedByPlayer) && Boolean(_loc1_) && _loc1_.IsRetailLot)
         {
            return Keys.MODECONTROL_BUILD_DISABLED.toString();
         }
         var _loc2_:BuildBuyLockUnlock = new BuildBuyLockUnlock(CommunicationManager.CallGameService("GetBBLockUnlock"));
         if(_loc2_.build_buy_locked)
         {
            return _loc2_.reason.toString();
         }
         if(GameplayStateData.SaveLocked)
         {
            return GameplayStateData.SaveLockUnlockMessage.lock_reason.toString();
         }
         if(BuildBuyStateData.IsLotEditable)
         {
            return null;
         }
         _loc4_ = CommunicationManager.CallGameService("GetLotBuildBuyLock") as uint;
         switch(_loc4_)
         {
            case BuildBuyLocks.LOT_TUNING:
               _loc3_ = Keys.MODECONTROL_BUILD_DISABLED_RHLOT;
               break;
            case BuildBuyLocks.TRAVEL_GROUP:
               _loc3_ = KeysEXCH.DETAIL_TOOLTIP_APPLY_DISABLED_VACATION;
               break;
            case BuildBuyLocks.UNIVERSITY_HOUSING:
               _loc3_ = Keys.MODECONTROL_BUILD_DISABLED_UNIVERSITY_HOUSING;
               break;
            default:
               _loc3_ = Keys.MODECONTROL_BUILD_DISABLED;
         }
         return _loc3_.toString();
      }
      
      public static function GetApplyTooltip(param1:uint, param2:uint) : String
      {
         switch(param2)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               switch(param1)
               {
                  case GameStates.PLAY:
                  case GameStates.BUILD:
                  case GameStates.LOT_SELECT:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_BP_STATE_VALID.toString();
                  default:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_BP_STATE_INVALID.toString();
               }
               break;
            case ExchangeData.TYPE_HOUSEHOLD:
               switch(param1)
               {
                  case GameStates.PLAY:
                  case GameStates.CAS:
                  case GameStates.LOT_SELECT:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_HH_STATE_VALID.toString();
                  default:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_HH_STATE_INVALID.toString();
               }
               break;
            case ExchangeData.TYPE_ROOM:
               switch(param1)
               {
                  case GameStates.PLAY:
                  case GameStates.BUILD:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_RM_STATE_VALID.toString();
                  default:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_RM_STATE_INVALID.toString();
               }
               break;
            case ExchangeData.TYPE_BODY_PART:
               switch(param1)
               {
                  case GameStates.PLAY:
                  case GameStates.CAS:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_PART_STATE_VALID.toString();
                  default:
                     return KeysEXCH.DETAIL_TOOLTIP_APPLY_PART_STATE_INVALID.toString();
               }
               break;
            default:
               return KeysEXCH.DETAIL_TOOLTIP_APPLY_DISABLED_GAME_MODE.toString();
         }
      }
      
      public static function ExtractHashTags(param1:String) : Array
      {
         var _loc2_:RegExp = null;
         var _loc3_:Array = null;
         if(!param1)
         {
            return [];
         }
         _loc2_ = new RegExp(HASHTAG_PATTERN,"g");
         _loc3_ = param1.match(_loc2_);
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_[_loc5_] = (_loc3_[_loc5_][0] as String).substr(1);
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function ParseHashTags(param1:String, param2:Boolean) : String
      {
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         _loc3_ = ExtractHashTags(param1);
         var _loc4_:int = int(_loc3_.length);
         if(_loc4_ == 0)
         {
            return param1;
         }
         param1 = TextUtils.EscapeHtml(param1);
         var _loc6_:int = 0;
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = _loc3_[_loc5_];
            _loc7_.push(GenerateTagHtml(_loc10_,param2));
            _loc11_ = param1.indexOf(KeysEXCH.HASHTAG_SYMBOL + _loc10_,_loc6_);
            _loc8_.push(_loc11_);
            _loc6_ = _loc11_ + 1;
            _loc5_++;
         }
         _loc6_ = 0;
         var _loc9_:String = "";
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc12_ = int(_loc8_[_loc5_]);
            _loc13_ = _loc12_ - _loc6_;
            if(_loc13_ > 0)
            {
               _loc9_ = _loc9_.concat(param1.substr(_loc6_,_loc13_));
            }
            _loc9_ = _loc9_.concat(_loc7_[_loc5_]);
            _loc6_ = _loc12_ + (_loc3_[_loc5_] as String).length + 1;
            _loc5_++;
         }
         return _loc9_.concat(param1.substr(_loc6_));
      }
      
      public static function GenerateTagHtml(param1:String, param2:Boolean) : String
      {
         if(param2)
         {
            return "<span class=\'hashTag\'>" + "<a href=\'event:" + param1 + "\'>#" + param1 + "</a></span>";
         }
         return ["<span class=\'hashTagNoClick\'>#",param1,"</span>"].join("");
      }
      
      public static function IsValidHashtag(param1:String) : Boolean
      {
         var _loc2_:RegExp = new RegExp(HASHTAG_PATTERN,"g");
         return _loc2_.test(param1);
      }
      
      public static function ExtractHashTagsAndGenerateHtml(param1:String, param2:Boolean = true, param3:String = " ") : String
      {
         var _loc4_:Array = ExchangeUtils.ExtractHashTags(param1);
         return GenerateHashTagHtmlFromArray(_loc4_,param2,param3);
      }
      
      public static function GenerateHashTagHtmlFromArray(param1:Array, param2:Boolean = true, param3:String = " ") : String
      {
         var _loc7_:String = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         var _loc6_:int = int(param1.length);
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1[_loc5_];
            if(ExchangeUtils.IsValidHashtag(KeysEXCH.HASHTAG_SYMBOL + _loc7_))
            {
               _loc4_.push(ExchangeUtils.GenerateTagHtml(_loc7_,param2));
            }
            _loc5_++;
         }
         return _loc4_.join(param3);
      }
      
      public static function GetSharePanelSizeTier(param1:Number, param2:Number) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Array = ExchangeTunables.SHARE_PANEL_SIZE_TIERS;
         var _loc5_:int = 0;
         var _loc6_:int = int(_loc4_.length);
         while(_loc5_ < _loc6_)
         {
            if(param1 < _loc4_[_loc5_].width || param2 < _loc4_[_loc5_].height)
            {
               break;
            }
            _loc3_ = _loc5_;
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function HandleExchangeNotifySubscriptionError(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1.success)
         {
            return false;
         }
         if("error" in param1)
         {
            SharedExchangeUtils.DisplayServerErrorDialog(param1);
         }
         else
         {
            _loc2_ = "bFailLimit" in param1 && Boolean(param1["bFailLimit"]);
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "description":(_loc2_ ? KeysEXCH.PLAYERSHARE_SUBSCRIBE_FAIL_LIMIT.toString() : KeysEXCH.PLAYERSHARE_SUBSCRIBE_FAIL_GENERIC.toString()),
               "optionOneText":Keys.GENERIC_OK.toString(),
               "widgetName":"ExchangePlayerProfile"
            });
         }
         return true;
      }
      
      public static function get IsBlockedSubscriptionListEnabled() : Boolean
      {
         return SystemUtils.IsConsole;
      }
      
      public static function get IsFilteredSubscriptionListEnabled() : Boolean
      {
         return SystemUtils.IsConsole;
      }
      
      public static function IsPlatformUserIdBlocked(param1:String) : Boolean
      {
         if(param1 == null || param1.length == 0)
         {
            return false;
         }
         var _loc2_:Object = CommunicationManager.CallGameService("IsPlatformUserIdBlocked",param1);
         return _loc2_ != null ? Boolean(_loc2_) : true;
      }
      
      public static function IsPlatformUserNameBlocked(param1:String) : Boolean
      {
         if(param1 == null || param1.length == 0)
         {
            return false;
         }
         var _loc2_:Object = CommunicationManager.CallGameService("IsPlatformUserNameBlocked",param1);
         return _loc2_ != null ? Boolean(_loc2_) : true;
      }
   }
}

