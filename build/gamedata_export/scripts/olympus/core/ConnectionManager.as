package olympus.core
{
   import olympus.constants.DialogTypes;
   import olympus.constants.RequestPlayOnlineResult;
   import olympus.dialog.DialogManager;
   import olympus.errors.Assert;
   import olympus.gamepad.NavManager;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   import olympus.utils.WidgetUtils;
   import widgets.Dialog.constants.ConnectionDialogCustomStates;
   import widgets.Dialog.constants.ConnectionDialogServiceType;
   
   public class ConnectionManager
   {
      
      protected static var sInstance:ConnectionManager;
      
      public static const FEATURE_PARAMETER_ENABLE_AMP:String = "0x4b1a0bc840152302";
      
      public static const FEATURE_PARAMETER_AMP_LOGIN_DISABLED:String = "0x5416896b1a8c9114";
      
      public static const AMP_MANAGER_AVAILABLE:int = 0;
      
      public static const AMP_MANAGER_REFRESHING_ITEMS:int = 1;
      
      public static const AMP_MANAGER_PENDING_REFRESH:int = 2;
      
      public static const AMP_MANAGER_PROCESSING_TRANSACTION:int = 3;
      
      public static const AMP_MANAGER_AWAITING_FINALIZE:int = 4;
      
      public static const AMP_MANAGER_TIME_OUT:int = 5;
      
      public static const AMP_MANAGER_UNAVAILABLE:int = 6;
      
      public static const DISCONNECT_REASON_NONE:int = 0;
      
      public static const DISCONNECT_REASON_USER:int = 1;
      
      public static const DISCONNECT_REASON_ORIGIN:int = 2;
      
      public static const DISCONNECT_REASON_KILLSWITCH:int = 3;
      
      public static const DISCONNECT_REASON_AFK:int = 4;
      
      public static const NUCLEUS_ERROR_NONE:int = 0;
      
      public static const NUCLEUS_ERROR_NO_USER:int = 1;
      
      public static const NUCLEUS_ERROR_LOGIN_CANCELLED:int = 2;
      
      public static const NUCLEUS_ERROR_LOGIN_FAILURE:int = 3;
      
      public static const NUCLEUS_ERROR_FAILED_TO_GET_PERSONA:int = 4;
      
      public static const NUCLEUS_ERROR_FAILED_TO_GET_TOKEN:int = 5;
      
      protected var mConnectionRequiredFeatures:Object;
      
      protected var mAmpAvailableFeatures:Object;
      
      protected var mOnConnectionCallback:Function;
      
      protected var mOnConnectionParam:Object;
      
      protected var mbOnlineAccessDisabled:Boolean;
      
      protected var mbGalleryDisabled:Boolean;
      
      protected var mIsChildAccount:Boolean;
      
      protected var mDisconnectionReason:int = 0;
      
      protected var mbIsTwitterServiceQueried:Boolean = false;
      
      protected var mbIsTwitterServiceEnabled:Boolean;
      
      protected var mLastAmpState:int = -1;
      
      protected var mbConnectedToPSN:Boolean;
      
      public function ConnectionManager()
      {
         super();
         sInstance = this;
      }
      
      public static function get IsConnectionRequired() : Boolean
      {
         return sInstance.mConnectionRequiredFeatures.length > 0;
      }
      
      public static function get IsOnlineAccessDisabled() : Boolean
      {
         return sInstance.mbOnlineAccessDisabled;
      }
      
      public static function get IsGalleryDisabled() : Boolean
      {
         return sInstance.mbGalleryDisabled;
      }
      
      public static function get IsChildAccount() : Boolean
      {
         return sInstance.mIsChildAccount;
      }
      
      public static function get IsPCChildAccount() : Boolean
      {
         return IsChildAccount && SystemUtils.IsPC;
      }
      
      public static function get IsConnectedToPSN() : Boolean
      {
         return sInstance.mbConnectedToPSN;
      }
      
      public static function get DisconnectionReasonCode() : int
      {
         return sInstance.mDisconnectionReason;
      }
      
      public static function get IsNucleusLoggedIn() : Boolean
      {
         if(SystemUtils.IsConsole)
         {
            return CommunicationManager.CallGameService("IsNucleusLoggedIn",null,true) as Boolean;
         }
         return true;
      }
      
      public static function set IsOnlineAccessDisabled(param1:Boolean) : void
      {
         if(!sInstance.mIsChildAccount && !ConnectionManager.IsGalleryDisabled)
         {
            sInstance.mbOnlineAccessDisabled = param1;
            if(param1)
            {
               RequestGoOffline();
            }
            CommunicationManager.SendUIMessage("OnlineAccessStateChanged",!param1);
         }
      }
      
      public static function IsOnlineAccessEnabledWithWarning() : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = true;
         if(SystemUtils.IsConsole)
         {
            _loc4_ = !IsChildAccount && CommunicationManager.CallGameService("OptionsGetAllowConsoleGalleryAccess",null,true) as Boolean;
            _loc1_ = (_loc4_) && IsNucleusLoggedIn;
         }
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(!_loc1_)
         {
            _loc2_ = Keys.REQUEST_GO_ONLINE_ERROR_TITLE.toString();
            _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_INTERNET_NOT_CONNECTED.toString();
         }
         else if(IsOnlineAccessDisabled)
         {
            _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_ONLINE_OPTION_DISABLED.toString();
         }
         if(_loc3_)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":_loc2_,
               "description":_loc3_,
               "optionOneText":Keys.GENERIC_OK.toString()
            });
            return false;
         }
         return true;
      }
      
      public static function get TwitterEnabled() : Boolean
      {
         return false;
      }
      
      public static function get TwitterAvailable() : Boolean
      {
         return IsTwitterServiceEnabled;
      }
      
      public static function get IsTwitterServiceEnabled() : Boolean
      {
         if(!sInstance.mbIsTwitterServiceQueried)
         {
            sInstance.mbIsTwitterServiceEnabled = CommunicationManager.CallGameService("GetIsTwitterServiceEnabled") as Boolean;
            sInstance.mbIsTwitterServiceQueried = true;
         }
         return sInstance.mbIsTwitterServiceEnabled && IsUGCOnline;
      }
      
      public static function HandleConnectionRequestResult(param1:Object, param2:int) : void
      {
         var _loc3_:LocKey = null;
         var _loc4_:int = int(param1);
         switch(_loc4_)
         {
            case RequestPlayOnlineResult.REQUEST_SUCCEEDED:
               break;
            case RequestPlayOnlineResult.INTERNET_NOT_CONNECTED:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_INTERNET_NOT_CONNECTED;
               break;
            case RequestPlayOnlineResult.SERVICES_DISABLED:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_SERVICES_DISABLED;
               break;
            case RequestPlayOnlineResult.ORIGIN_IN_OFFLINE_MODE:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_ORIGIN_OFFLINE_MODE;
               break;
            case RequestPlayOnlineResult.UNDER_AGE:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_ONLINE_DISABLED;
               break;
            case RequestPlayOnlineResult.ORIGIN_MANDATORY_UPDATE:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_ORIGIN_MANDATORY_UPDATE;
               break;
            case RequestPlayOnlineResult.EA_ACCOUNT_NOT_LINKED:
               if(SystemUtils.IsConsole)
               {
                  _loc3_ = KeysConsole.REQUEST_GO_ONLINE_ERROR_EA_ACCOUNT_NOT_LINKED;
               }
               else
               {
                  _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_GENERIC;
                  Assert.Throw("Console related RequestPlayOnlineResult received on non-console build!");
               }
               break;
            default:
               _loc3_ = Keys.REQUEST_GO_ONLINE_ERROR_GENERIC;
         }
         if(_loc3_)
         {
            CommunicationManager.CallUIService("HideConnectionDialog",{
               "bIsStayOffline":true,
               "bNetworkConnectionHandler":false
            });
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":Keys.REQUEST_GO_ONLINE_ERROR_TITLE.toString(),
               "description":_loc3_.toString(),
               "optionOneText":Keys.GENERIC_OK.toString(),
               "optionOneCallback":sInstance.OnCancelRequiredConnect
            });
            CommunicationManager.SendUIMessage("OnlineRequestFailed",{"service":param2});
         }
      }
      
      public static function RequestGoOnline() : void
      {
         if(IsUGCOnline)
         {
            return;
         }
         var _loc1_:Object = CommunicationManager.CallGameService("SetOnlineStatus",true);
         HandleConnectionRequestResult(_loc1_,ConnectionDialogServiceType.UGC_SERVICE);
      }
      
      public static function RequestAMPAvailable() : void
      {
         if(IsAMPAvailable())
         {
            return;
         }
         var _loc1_:Object = CommunicationManager.CallGameService("SetAmpOnline",true);
         HandleConnectionRequestResult(_loc1_,ConnectionDialogServiceType.AMP_SERVICE);
      }
      
      public static function RequestGoOffline() : void
      {
         if(IsUGCOnline)
         {
            WidgetUtils.HideExchangeWidgets();
            CommunicationManager.CallGameService("SetOnlineStatus",false);
         }
      }
      
      public static function get IsUGCOnline() : Boolean
      {
         return CommunicationManager.CallGameService("GetIsOnline") as Boolean;
      }
      
      public static function get IsConnectedToOnlineServices() : Boolean
      {
         return CommunicationManager.CallGameService("GetIsConnectedToOnlineServices") as Boolean;
      }
      
      public static function get HasInternetConnection() : Boolean
      {
         return CommunicationManager.CallGameService("GetHasInternet") as Boolean;
      }
      
      public static function IsAMPConnected() : Boolean
      {
         var _loc1_:int = CommunicationManager.CallGameService("RequestAmpSDKState") as int;
         return _loc1_ != ConnectionManager.AMP_MANAGER_UNAVAILABLE && _loc1_ != ConnectionManager.AMP_MANAGER_TIME_OUT;
      }
      
      public static function IsAMPAvailable() : Boolean
      {
         var _loc1_:int = CommunicationManager.CallGameService("RequestAmpSDKState") as int;
         return _loc1_ == ConnectionManager.AMP_MANAGER_AVAILABLE;
      }
      
      public static function RequestOnlineFeature(param1:Function = null, param2:Object = null, param3:String = null, param4:Boolean = true) : Boolean
      {
         var _loc5_:ConnectionManager = null;
         if(IsUGCOnline)
         {
            return true;
         }
         if(!IsOnlineAccessDisabled)
         {
            _loc5_ = sInstance;
            _loc5_.mOnConnectionCallback = param1;
            _loc5_.mOnConnectionParam = param2;
            if(param4)
            {
               _loc5_.ShowConnectionDialog({
                  "customState":ConnectionDialogCustomStates.CONNECTION_REQUIRED,
                  "OnCancelCallback":_loc5_.CancelGoOnline
               });
            }
         }
         return false;
      }
      
      public static function RequestAMPAvailableFeature(param1:Function = null, param2:Object = null, param3:String = null, param4:Boolean = true) : Boolean
      {
         var _loc5_:ConnectionManager = null;
         if(IsAMPAvailable())
         {
            return true;
         }
         if(!IsOnlineAccessDisabled)
         {
            _loc5_ = sInstance;
            _loc5_.mOnConnectionCallback = param1;
            _loc5_.mOnConnectionParam = param2;
            if(param4)
            {
               _loc5_.ShowConnectionDialog({
                  "customState":ConnectionDialogCustomStates.AMP_CONNECTION_REQUIRED,
                  "OnCancelCallback":_loc5_.CancelAmpGoOnline
               });
               if(StoreDataManager.StoreConnectionState == StoreDataManager.CONNECTION_STATE_REFRESHING)
               {
                  _loc5_.ShowConnectionDialog({
                     "customState":ConnectionDialogCustomStates.AMP_CONNECTION_REFRESHING,
                     "title":Keys.CONNECTION_DIALOG_LABEL_REFRESHING.toString(),
                     "OnCancelLabel":Keys.GENERIC_CANCEL.toString(),
                     "OnCancelCallback":_loc5_.OnCancelAmpRefreshingAvailableRequest
                  });
               }
            }
         }
         return false;
      }
      
      public static function RequestInternetConnection(param1:Function = null, param2:Object = null) : Boolean
      {
         if(HasInternetConnection)
         {
            return true;
         }
         sInstance.ShowConnectionDialog({
            "customState":ConnectionDialogCustomStates.INTERNET_REQUIRED,
            "OnConfirmCallback":param1,
            "OnConfirmParams":param2
         });
         return false;
      }
      
      public static function AddConnectionRequiredFeature(param1:String, param2:Function, param3:Object = null) : void
      {
         var _loc4_:Object = sInstance.mConnectionRequiredFeatures;
         if(!(param1 in _loc4_))
         {
            ++_loc4_.length;
         }
         _loc4_[param1] = {
            "Callback":param2,
            "CallbackArg":param3
         };
      }
      
      public static function AddAmpAvailableFeature(param1:String, param2:Function, param3:Object = null) : void
      {
         var _loc4_:Object = sInstance.mAmpAvailableFeatures;
         if(!(param1 in _loc4_))
         {
            ++_loc4_.length;
         }
         _loc4_[param1] = {
            "Callback":param2,
            "CallbackArg":param3
         };
      }
      
      public static function RemoveConnectionRequiredFeature(param1:String) : void
      {
         var _loc2_:Object = sInstance.mConnectionRequiredFeatures;
         if(param1 in _loc2_)
         {
            delete _loc2_[param1];
            --_loc2_.length;
         }
      }
      
      public static function RemoveAmpAvailableFeature(param1:String) : void
      {
         var _loc2_:Object = sInstance.mAmpAvailableFeatures;
         if(param1 in _loc2_)
         {
            delete _loc2_[param1];
            --_loc2_.length;
         }
      }
      
      public function Initialize(param1:UIManager) : void
      {
         sInstance.mConnectionRequiredFeatures = {"length":0};
         sInstance.mAmpAvailableFeatures = {"length":0};
         CommunicationManager.AddMessageListener("ConnectionOnline",this.OnConnectionOnline,param1);
         CommunicationManager.AddMessageListener("ConnectionOffline",this.OnConnectionOffline,param1);
         CommunicationManager.AddMessageListener("ConnectionRequestFailure",this.OnConnectionRequestFailure,param1);
         CommunicationManager.AddMessageListener("AmpManager.stateChanged",this.OnAmpStateChange,param1);
         if(SystemUtils.IsConsole)
         {
            CommunicationManager.AddMessageListener("InternetDisconnected",this.HandleInternetDisconnected,param1);
         }
         this.mbGalleryDisabled = CommunicationManager.CallGameService("GetIsGalleryDisabled") as Boolean;
         this.mIsChildAccount = CommunicationManager.CallGameService("GetIsChildAccount") as Boolean;
         this.mbOnlineAccessDisabled = this.mIsChildAccount;
         if(SystemUtils.IsConsole)
         {
            CommunicationManager.AddMessageListener("NucleusLoginComplete",this.HandleNucleusLoginComplete,param1);
            CommunicationManager.AddMessageListener("NucleusLoginFailure",this.HandleNucleusLoginFailure,param1);
         }
         if(SystemUtils.IsPS4)
         {
            CommunicationManager.AddMessageListener("DisconnectedFromPSN",this.HandleDisconnectedFromPSN,param1);
            CommunicationManager.AddMessageListener("ReconnectedToPSN",this.HandleReconnectedToPSN,param1);
         }
      }
      
      protected function OnCancelRequiredConnect(param1:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:int = Boolean(param1) && param1.hasOwnProperty("service") ? int(param1.service) : ConnectionDialogServiceType.UGC_SERVICE;
         var _loc3_:Object = _loc2_ == ConnectionDialogServiceType.UGC_SERVICE ? this.mConnectionRequiredFeatures : this.mAmpAvailableFeatures;
         _loc3_.length = 0;
         for(_loc4_ in _loc3_)
         {
            if(_loc4_ != "length")
            {
               _loc5_ = _loc3_[_loc4_];
               delete _loc3_[_loc4_];
               _loc5_.Callback(_loc5_.CallbackArg);
            }
         }
         this.mOnConnectionCallback = null;
         this.mOnConnectionParam = null;
      }
      
      protected function OnCancelAmpAvailableRequest(param1:*) : void
      {
         this.OnCancelRequiredConnect({"service":ConnectionDialogServiceType.AMP_SERVICE});
         CommunicationManager.SendUIMessage("OnlineRequestFailed",{"service":ConnectionDialogServiceType.AMP_SERVICE});
      }
      
      protected function OnCancelAmpRefreshingAvailableRequest(param1:*) : void
      {
         this.OnCancelRequiredConnect({"service":ConnectionDialogServiceType.AMP_SERVICE});
      }
      
      protected function OnConnectionOnline(param1:Object) : void
      {
         if(Boolean(CommunicationManager.CallUIService("HideConnectionDialog",{
            "bIsStayOffline":false,
            "bNetworkConnectionHandler":true
         })) && this.mOnConnectionCallback != null)
         {
            this.mOnConnectionCallback(this.mOnConnectionParam);
            this.mOnConnectionCallback = null;
            this.mOnConnectionParam = null;
         }
         sInstance.mbIsTwitterServiceEnabled = CommunicationManager.CallGameService("GetIsTwitterServiceEnabled") as Boolean;
      }
      
      protected function OnConnectionOffline(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.mDisconnectionReason = param1.reasonCode;
         if(this.mConnectionRequiredFeatures.length == 0)
         {
            if(!SystemUtils.IsConsole)
            {
               CommunicationManager.CallUIService("HideConnectionDialog",{
                  "bIsStayOffline":true,
                  "bNetworkConnectionHandler":true
               });
            }
         }
         else if(!SystemUtils.IsConsole || HasInternetConnection)
         {
            _loc2_ = this.mDisconnectionReason == DISCONNECT_REASON_AFK ? ConnectionDialogCustomStates.RECONNECT_AFTER_AFK : ConnectionDialogCustomStates.CONNECTION_REQUIRED;
            this.ShowConnectionDialog({
               "customState":_loc2_,
               "OnCancelCallback":this.OnCancelRequiredConnect
            });
         }
         sInstance.mbIsTwitterServiceEnabled = CommunicationManager.CallGameService("GetIsTwitterServiceEnabled") as Boolean;
      }
      
      protected function OnConnectionRequestFailure(param1:Object) : void
      {
         this.ShowConnectionDialog({
            "loginResponse":int(param1),
            "OnCancelCallback":this.OnCancelRequiredConnect
         });
      }
      
      protected function OnAmpStateChange(param1:Object) : void
      {
         var _loc2_:int = int(param1["newState"]);
         if(this.mLastAmpState == _loc2_)
         {
            return;
         }
         this.mLastAmpState = _loc2_;
         switch(_loc2_)
         {
            case ConnectionManager.AMP_MANAGER_AVAILABLE:
               this.OnAmpAvailable(param1);
               break;
            case ConnectionManager.AMP_MANAGER_PENDING_REFRESH:
            case ConnectionManager.AMP_MANAGER_REFRESHING_ITEMS:
               this.OnAmpRefreshing(param1);
               break;
            case ConnectionManager.AMP_MANAGER_UNAVAILABLE:
               this.OnAmpNotAvailable(param1);
         }
      }
      
      protected function HandleNucleusLoginComplete(param1:Object) : void
      {
         if(SystemUtils.IsConsole && !CommunicationManager.CallGameService("OptionsGetAllowConsoleGalleryAccess"))
         {
            return;
         }
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":KeysConsole.ACCOUNT_LINKED_ONLINE_SERVICES_RESTART_TITLE.toString(),
            "description":KeysConsole.ACCOUNT_LINKED_ONLINE_SERVICES_RESTART_BODY.toString(),
            "optionOneText":Keys.GENERIC_YES.toString(),
            "optionOneCallback":CommunicationManager.CallGameService,
            "optionOneParams":"ReturnToPressStart",
            "closeText":Keys.GENERIC_NO.toString()
         });
      }
      
      protected function HandleNucleusLoginFailure(param1:Object) : void
      {
         var _loc2_:int = param1["errorCode"] as int;
         if(_loc2_ == NUCLEUS_ERROR_NO_USER || _loc2_ == NUCLEUS_ERROR_LOGIN_FAILURE || _loc2_ == NUCLEUS_ERROR_FAILED_TO_GET_PERSONA || _loc2_ == NUCLEUS_ERROR_FAILED_TO_GET_TOKEN)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":KeysConsole.NUCLEUS_LOGIN_FAILURE_TITLE.toString(),
               "description":KeysConsole.NUCLEUS_LOGIN_FAILURE_BODY.toString(_loc2_.toString(16)),
               "optionOneText":Keys.GENERIC_OK.toString()
            });
         }
      }
      
      protected function HandleDisconnectedFromPSN() : void
      {
         if(this.mbConnectedToPSN)
         {
            CommunicationManager.SendUIMessage("InternetDisconnected");
         }
         this.mbConnectedToPSN = false;
      }
      
      protected function HandleReconnectedToPSN() : void
      {
         this.mbConnectedToPSN = true;
      }
      
      protected function HandleInternetDisconnected(param1:Object) : void
      {
         var _loc2_:String = null;
         if(SystemUtils.IsConsole)
         {
            DialogManager.CancelRequest("PackPreviewDialog");
            if(NavManager.Instance.CurrentWidgetName == "ExchangePackDetail")
            {
               CommunicationManager.SendUIMessage("HideExchangePackDetail");
            }
            CommunicationManager.SendUIMessage("HideExchangeSubscriptions");
            CommunicationManager.CallUIService("HideConnectionDialog",{"bIsStayOffline":true});
            _loc2_ = SystemUtils.IsPS4 ? KeysConsole.DISCONNECTED_FROM_ACCOUNT_SERVICES_KBM_PS4.toString() : KeysConsole.DISCONNECTED_FROM_ACCOUNT_SERVICES.toString();
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":Keys.GENERIC_CAUTION.toString(),
               "description":_loc2_,
               "optionOneText":Keys.GENERIC_OK.toString(),
               "optionOneCallback":sInstance.OnCancelRequiredConnect,
               "closeCallback":sInstance.OnCancelRequiredConnect
            });
         }
      }
      
      protected function CancelGoOnline() : void
      {
         CommunicationManager.CallGameService("CancelRequestGoOnline",null);
         this.mOnConnectionCallback = null;
         this.mOnConnectionParam = null;
      }
      
      protected function ShowConnectionDialog(param1:Object) : void
      {
         CommunicationManager.SendUIMessage("ShowConnectionDialog",param1);
      }
      
      protected function CancelAmpGoOnline() : void
      {
         CommunicationManager.CallGameService("CancelRequestAmpGoOnline",null);
         this.mOnConnectionCallback = null;
         this.mOnConnectionParam = null;
      }
      
      protected function OnAmpAvailable(param1:Object) : void
      {
         if(Boolean(CommunicationManager.CallUIService("HideConnectionDialog",{
            "bIsStayOffline":false,
            "bFromNetworkConnection":false
         })) && this.mOnConnectionCallback != null)
         {
            this.mOnConnectionCallback(this.mOnConnectionParam);
            this.mOnConnectionCallback = null;
            this.mOnConnectionParam = null;
         }
      }
      
      protected function OnAmpRefreshing(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(CommunicationManager.CallUIService("IsConnectionDialogShown"));
         if(!_loc2_)
         {
            return;
         }
         this.ShowConnectionDialog({
            "onlyUpdateExisting":true,
            "customState":ConnectionDialogCustomStates.AMP_CONNECTION_REFRESHING
         });
      }
      
      protected function OnAmpNotAvailable(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(CommunicationManager.CallUIService("IsConnectionDialogShown"));
         if(_loc2_)
         {
            this.ShowConnectionDialog({
               "customState":ConnectionDialogCustomStates.AMP_CONNECTION_FAILED,
               "OnCancelCallback":this.OnCancelAmpAvailableRequest
            });
            return;
         }
         if(this.mAmpAvailableFeatures.length == 0)
         {
            return;
         }
         this.ShowConnectionDialog({
            "customState":ConnectionDialogCustomStates.AMP_CONNECTION_REQUIRED,
            "OnCancelCallback":this.OnCancelAmpAvailableRequest
         });
      }
   }
}

