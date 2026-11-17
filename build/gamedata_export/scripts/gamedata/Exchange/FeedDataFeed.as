package gamedata.Exchange
{
   import gamedata.Dialog.UiDialogChoiceMessage;
   import gamedata.Dialog.UiExchangeArgs;
   import gamedata.shared.UiDialogNotification;
   import olympus.core.ConnectionManager;
   import olympus.core.UISettings;
   import olympus.data.ArrayDataFeed;
   import olympus.io.CommunicationManager;
   import widgets.Community.constants.SocialOps;
   import widgets.Community.utils.CommunityUtils;
   
   public class FeedDataFeed extends ArrayDataFeed
   {
      
      private static var gInstance:FeedDataFeed;
      
      protected static const FEED_DATAFEED_STRING:String = "ExchangeFeedDataFeed";
      
      protected var mbNewSearch:Boolean = true;
      
      protected var mbRequestInProgress:Boolean = false;
      
      protected var mbNoMoreDataAvailable:Boolean = false;
      
      public function FeedDataFeed()
      {
         super();
         this.AddListeners();
      }
      
      public static function get Instance() : FeedDataFeed
      {
         if(gInstance == null)
         {
            gInstance = new FeedDataFeed();
         }
         return gInstance;
      }
      
      public static function get LastViewedTimestamp() : String
      {
         var _loc1_:String = UISettings.SessionSettings.GetValue("lastViewedFeedTimestamp","share") as String;
         if(_loc1_ == null)
         {
            _loc1_ = UISettings.AccountSettings.GetValue("lastViewedFeedTimestamp") as String;
         }
         return _loc1_;
      }
      
      public static function set LastViewedTimestamp(param1:String) : void
      {
         UISettings.SessionSettings.SetValue("lastViewedFeedTimestamp",param1,"share");
         UISettings.AccountSettings.SetValue("lastViewedFeedTimestamp",param1);
      }
      
      protected function AddListeners() : void
      {
         CommunicationManager.AddMessageListenerByName("SocialRequestFeedWallMessage",this.HandleFeedRequestResponse,FEED_DATAFEED_STRING);
         CommunicationManager.AddMessageListenerByName("InsertFeedWallMessage",this.HandleInsertFeedWallMessage,FEED_DATAFEED_STRING,FeedData);
         CommunicationManager.AddMessageListenerByName("DeleteExchangeItem",this.HandleDeleteExchangeItem,FEED_DATAFEED_STRING,ExchangeData);
         CommunicationManager.AddMessageListenerByName("AddUiDialogNotification",this.HandleAddUiDialogNotification,FEED_DATAFEED_STRING,UiDialogNotification);
         CommunicationManager.AddMessageListenerByName("ConnectionOnline",this.HandleConnectionOnline,FEED_DATAFEED_STRING);
         CommunicationManager.AddMessageListenerByName("ConnectionOffline",this.HandleConnectionOffline,FEED_DATAFEED_STRING);
      }
      
      protected function RemoveListeners() : void
      {
         CommunicationManager.RemoveWidgetFunctions(FEED_DATAFEED_STRING);
      }
      
      public function RequestData(param1:Boolean, param2:Boolean = true) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         if(this.mbRequestInProgress || !param2 && this.mbNoMoreDataAvailable)
         {
            return false;
         }
         this.mbNewSearch = param2;
         if(param1)
         {
            this.mbRequestInProgress = true;
            CommunityUtils.PostSocialServerOp(SocialOps.SOP_GET_FEED,SocialOps.COMMAND_GET_FEED_MSG,{});
            return true;
         }
         RemoveAllItems();
         _loc3_ = LastViewedTimestamp;
         _loc4_ = _loc3_ == null ? Number.MAX_VALUE : Number(_loc3_);
         AddItemsFromIterable(this.GetOfflineFeedList(_loc4_));
         return false;
      }
      
      public function HandleFeedRequestResponse(param1:Object) : void
      {
         var _loc8_:FeedData = null;
         if(this.mbNewSearch)
         {
            RemoveAllItems();
         }
         var _loc2_:String = LastViewedTimestamp;
         var _loc3_:Number = _loc2_ == null ? Number.MAX_VALUE : Number(_loc2_);
         var _loc4_:Array = param1.messages;
         var _loc5_:Array = new Array(_loc4_.length);
         var _loc6_:int = 0;
         var _loc7_:int = int(_loc4_.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = new FeedData(_loc4_[_loc6_]);
            _loc8_.isNew = Number(_loc8_.uuidTimestamp) > _loc3_;
            _loc5_[_loc6_] = _loc8_;
            _loc6_++;
         }
         _loc5_ = _loc5_.concat(this.GetOfflineFeedList(_loc3_));
         _loc5_.sortOn("uuidTimestamp",Array.NUMERIC | Array.DESCENDING);
         AddItemsFromIterable(_loc5_);
         this.mbRequestInProgress = false;
         this.mbNoMoreDataAvailable = true;
      }
      
      public function HandleInsertFeedWallMessage(param1:FeedData) : void
      {
         var _loc2_:String = LastViewedTimestamp;
         var _loc3_:Number = _loc2_ == null ? Number.MAX_VALUE : Number(_loc2_);
         param1.isNew = Number(param1.uuidTimestamp) > _loc3_;
         mDataArray.push(param1);
         mDataArray.sortOn("uuidTimestamp",Array.NUMERIC | Array.DESCENDING);
         MarkRangeDirty(0,mDataArray.length - 1);
      }
      
      public function HandleDeleteExchangeItem(param1:ExchangeData) : void
      {
         var _loc6_:FeedData = null;
         var _loc2_:Array = mDataArray;
         var _loc3_:String = param1.id;
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc2_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc2_[_loc4_] as FeedData;
            if(_loc6_.feed_type == FeedData.TYPE_LOCAL_SAVE && _loc6_.metadata.id == _loc3_)
            {
               _loc6_.isInvalid = true;
               _loc6_.isNew = false;
               MarkRangeDirty(_loc4_,_loc4_);
               break;
            }
            _loc4_++;
         }
      }
      
      public function HandleReportContentSubmitted(param1:String) : void
      {
         var _loc5_:FeedData = null;
         var _loc2_:Array = mDataArray;
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_[_loc3_] as FeedData;
            if(_loc5_.metadata.remote_id == param1)
            {
               _loc5_.isInvalid = true;
               MarkRangeDirty(_loc3_,_loc3_);
            }
            _loc3_++;
         }
      }
      
      protected function HandleConnectionOnline(param1:Object) : void
      {
         this.mbRequestInProgress = false;
         FeedDataFeed.Instance.RequestData(ConnectionManager.IsConnectedToOnlineServices,true);
      }
      
      protected function HandleConnectionOffline(param1:Object) : void
      {
         this.mbRequestInProgress = false;
      }
      
      protected function HandleAddUiDialogNotification(param1:UiDialogNotification) : void
      {
         var _loc2_:UiDialogChoiceMessage = null;
         var _loc3_:UiExchangeArgs = null;
         var _loc4_:Object = null;
         var _loc5_:FeedData = null;
         if(param1.information_level == UiDialogNotification.LEVEL_GALLERY && param1.choices.length > 0)
         {
            _loc2_ = param1.choices[0] as UiDialogChoiceMessage;
            if(!_loc2_)
            {
               return;
            }
            _loc3_ = _loc2_.exchange_args;
            if(_loc3_)
            {
               if(_loc3_.item_data)
               {
                  _loc4_ = CommunicationManager.CallGameService("ConvertTrayMetadataToExchangeData",_loc3_.item_data);
               }
               _loc5_ = new FeedData({
                  "feed_id":_loc3_.feed_id,
                  "feed_type":_loc3_.feed_type,
                  "metadata":_loc4_,
                  "nucleusid":_loc3_.creator_id,
                  "persona":_loc3_.creator_name,
                  "quantity":_loc3_.quantity,
                  "uuidTimestamp":_loc3_.timestamp,
                  "is_maxis_curated":_loc3_.is_maxis_curated
               });
               _loc5_.isNew = true;
               AddItemToFront(_loc5_);
            }
         }
      }
      
      protected function GetOfflineFeedList(param1:Number) : Array
      {
         var _loc6_:UiDialogNotification = null;
         var _loc7_:UiDialogChoiceMessage = null;
         var _loc8_:Object = null;
         var _loc9_:FeedData = null;
         var _loc2_:Array = CommunicationManager.CallGameService("GetUiDialogNotifications",{
            "start_index":0,
            "end_index":0,
            "bGallery":true
         }) as Array;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc2_.length);
         for(; _loc4_ < _loc5_; _loc4_++)
         {
            _loc6_ = new UiDialogNotification(_loc2_[_loc4_]);
            if(_loc6_.choices.length > 0)
            {
               _loc7_ = _loc6_.choices[0] as UiDialogChoiceMessage;
               _loc8_ = null;
               if(_loc7_.ui_request == UiDialogChoiceMessage.CHOICE_SHOW_GALLERY_ITEM)
               {
                  if(!_loc7_.exchange_args)
                  {
                     continue;
                  }
                  _loc8_ = CommunicationManager.CallGameService("ConvertTrayMetadataToExchangeData",_loc7_.exchange_args.item_data);
               }
               _loc9_ = new FeedData({
                  "feed_id":_loc6_.save_uid,
                  "feed_type":_loc7_.choice_id,
                  "metadata":_loc8_,
                  "uuidTimestamp":_loc6_.timestamp
               });
               _loc9_.isNew = Number(_loc9_.uuidTimestamp) > param1;
               _loc3_.push(_loc9_);
            }
         }
         return _loc3_;
      }
   }
}

