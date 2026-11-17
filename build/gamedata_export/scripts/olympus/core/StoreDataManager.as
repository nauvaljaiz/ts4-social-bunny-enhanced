package olympus.core
{
   import olympus.constants.PageDataRequestStates;
   import olympus.errors.Assert;
   import olympus.io.CommunicationManager;
   
   public class StoreDataManager
   {
      
      protected static var sInstance:StoreDataManager;
      
      public static var CONNECTION_STATE_UNAVAILABLE:int = 0;
      
      public static var CONNECTION_STATE_AVAILABLE:int = 1;
      
      public static var CONNECTION_STATE_REFRESHING:int = 2;
      
      public static var CONNECTION_STATE_CONNECTING:int = 3;
      
      public static const MESSAGE_STORE_AVAILABLE:String = "StoreAvailable";
      
      public static const MESSAGE_STORE_AVAILABLE_FROM_REFRESH:String = "StoreAvailableFromRefreshing";
      
      public static const MESSAGE_STORE_REFRESHING:String = "StoreRefreshing";
      
      protected var mStoreConnectionState:int = 0;
      
      protected var bFirstAvailableHit:Boolean = false;
      
      protected var mCurrentDataRequestStatus:int;
      
      protected var mbDirty:Boolean = false;
      
      public function StoreDataManager()
      {
         super();
         sInstance = this;
      }
      
      public static function RequestStoreAvailableFeature(param1:Function = null, param2:Object = null, param3:String = null, param4:Boolean = true) : Boolean
      {
         var _loc5_:int = StoreConnectionState;
         if(_loc5_ == CONNECTION_STATE_AVAILABLE)
         {
            return true;
         }
         if(_loc5_ == CONNECTION_STATE_REFRESHING)
         {
            return true;
         }
         if(_loc5_ == CONNECTION_STATE_CONNECTING)
         {
            return true;
         }
         return ConnectionManager.RequestAMPAvailableFeature(param1,param2,param3,param4);
      }
      
      public static function get IsDirty() : Boolean
      {
         return sInstance.mbDirty;
      }
      
      public static function set IsDirty(param1:Boolean) : void
      {
         sInstance.mbDirty = param1;
         CommunicationManager.SendUIMessage("StoreDataUpdate",IsDirty);
      }
      
      public static function get FirstAvailableHit() : Boolean
      {
         return sInstance.bFirstAvailableHit;
      }
      
      public static function get IsEmptyStore() : Boolean
      {
         if(!ConnectionManager.IsAMPAvailable())
         {
            return false;
         }
         var _loc1_:Boolean = Boolean(CommunicationManager.CallGameService("RequestCommerceDisplayEmptyStore"));
         return !_loc1_;
      }
      
      public static function get IsStoreConnected() : Boolean
      {
         return StoreConnectionState != StoreDataManager.CONNECTION_STATE_UNAVAILABLE && !(StoreConnectionState == StoreDataManager.CONNECTION_STATE_CONNECTING && !StoreDataManager.FirstAvailableHit);
      }
      
      public static function get StoreConnectionState() : int
      {
         return sInstance.mStoreConnectionState == -1 ? StoreDataManager.CONNECTION_STATE_UNAVAILABLE : sInstance.mStoreConnectionState;
      }
      
      public static function set StoreConnectionState(param1:int) : void
      {
         sInstance.mStoreConnectionState = param1;
         sInstance.SendStoreConnectionStateChange(param1);
      }
      
      public function Initialize(param1:UIManager) : void
      {
         CommunicationManager.AddMessageListener("AmpManager.stateChanged",this.OnAmpStateChange,param1);
         CommunicationManager.AddMessageListener("StoreDataRequestStatusChanged",this.OnStoreDataRequestStatusChanged,param1);
         var _loc2_:* = CommunicationManager.CallGameService("RequestAmpSDKState",{},true);
         if(_loc2_ != null)
         {
            this.SetStoreConnectionState(_loc2_ as int);
         }
      }
      
      public function SendStoreConnectionStateChange(param1:int) : void
      {
         CommunicationManager.SendUIMessage("StoreConnectionStateChange",param1);
      }
      
      protected function SetStoreConnectionState(param1:int) : void
      {
         switch(StoreConnectionState)
         {
            case CONNECTION_STATE_UNAVAILABLE:
               if(param1 == ConnectionManager.AMP_MANAGER_AVAILABLE)
               {
                  StoreConnectionState = CONNECTION_STATE_AVAILABLE;
               }
               else if(param1 != ConnectionManager.AMP_MANAGER_UNAVAILABLE)
               {
                  StoreConnectionState = CONNECTION_STATE_CONNECTING;
               }
               break;
            case CONNECTION_STATE_CONNECTING:
               if(param1 == ConnectionManager.AMP_MANAGER_UNAVAILABLE)
               {
                  StoreConnectionState = CONNECTION_STATE_UNAVAILABLE;
               }
               else if(param1 == ConnectionManager.AMP_MANAGER_AVAILABLE)
               {
                  if(!this.bFirstAvailableHit)
                  {
                     this.bFirstAvailableHit = true;
                  }
                  else
                  {
                     CommunicationManager.SendUIMessage(StoreDataManager.MESSAGE_STORE_AVAILABLE,{"ampState":param1});
                  }
                  StoreConnectionState = CONNECTION_STATE_AVAILABLE;
               }
               break;
            case CONNECTION_STATE_REFRESHING:
               if(param1 == ConnectionManager.AMP_MANAGER_AVAILABLE)
               {
                  CommunicationManager.SendUIMessage(StoreDataManager.MESSAGE_STORE_AVAILABLE_FROM_REFRESH,{"ampState":param1});
                  StoreConnectionState = CONNECTION_STATE_AVAILABLE;
               }
               else if(param1 == ConnectionManager.AMP_MANAGER_UNAVAILABLE)
               {
                  StoreConnectionState = CONNECTION_STATE_UNAVAILABLE;
               }
               break;
            case CONNECTION_STATE_AVAILABLE:
               if(param1 == ConnectionManager.AMP_MANAGER_UNAVAILABLE)
               {
                  StoreConnectionState = CONNECTION_STATE_UNAVAILABLE;
               }
               else if(param1 == ConnectionManager.AMP_MANAGER_REFRESHING_ITEMS)
               {
                  CommunicationManager.SendUIMessage(MESSAGE_STORE_REFRESHING,{"ampState":param1});
                  StoreConnectionState = CONNECTION_STATE_REFRESHING;
               }
         }
      }
      
      protected function OnStoreDataRequestStatusChanged(param1:Object) : void
      {
         if(!param1 || !param1.hasOwnProperty("state"))
         {
            return;
         }
         this.mCurrentDataRequestStatus = param1["state"];
         switch(this.mCurrentDataRequestStatus)
         {
            case PageDataRequestStates.DATA_REQUEST_STATUS_NOT_INITIALIZED:
               IsDirty = false;
               break;
            case PageDataRequestStates.DATA_REQUEST_STATUS_PENDING:
               IsDirty = true;
               break;
            case PageDataRequestStates.DATA_REQUEST_STATUS_IN_PROGRESS:
               IsDirty = true;
               break;
            case PageDataRequestStates.DATA_REQUEST_STATUS_COMPLETE:
               IsDirty = false;
               break;
            case PageDataRequestStates.DATA_REQUEST_STATUS_RETRY:
               IsDirty = true;
         }
      }
      
      protected function OnAmpStateChange(param1:Object) : void
      {
         if(!param1.hasOwnProperty("newState"))
         {
            Assert.Throw("No amp state distributed with amp-state-change message.");
            return;
         }
         var _loc2_:int = int(param1["newState"]);
         this.SetStoreConnectionState(_loc2_);
      }
   }
}

