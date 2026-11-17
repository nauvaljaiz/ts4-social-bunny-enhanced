package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysEXCH;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   import olympus.utils.TextUtils;
   import widgets.shared.constants.ExchangeDetailStates;
   import widgets.shared.constants.ExchangeShareMode;
   import widgets.shared.data.ExchangeFilter;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public final class FeedData extends OlympusObject
   {
      
      public static const DELETE:String = "feed_item_delete";
      
      public static const LOAD_FAIL:String = "feed_item_load_fail";
      
      public static const TYPE_ITEM_DOWNLOAD:uint = 0;
      
      public static const TYPE_ITEM_UPLOAD:uint = 1;
      
      public static const TYPE_ITEM_FAVORITE:uint = 2;
      
      public static const TYPE_ITEM_COMMENT:uint = 3;
      
      public static const TYPE_ITEM_SHOWCASE:uint = 4;
      
      public static const TYPE_PROFILE_COMMENT:uint = 5;
      
      public static const TYPE_PROFILE_FOLLOWERS:uint = 6;
      
      public static const TYPE_LOCAL_SAVE:uint = 100;
      
      public static const TYPE_LOCAL_MOBILE:uint = 101;
      
      protected static const ICON_DOWNLOAD:String = "0x3a739f4c8bcf0dc6";
      
      protected static const ICON_FAVORITE:String = "0xb106057caf65596a";
      
      protected static const ICON_FOLLOWERS:String = "0x806281eda3822c37";
      
      protected static const ICON_SAVE:String = "0x6d2bef2118a6c015";
      
      protected static const ICON_SHARE:String = "0x7484c83d0defb9c3";
      
      protected static const ICON_INVALID:String = "0x3eb522395c5df213";
      
      protected static const ICON_MOBILE:String = "0x8bcfec146dc6131c";
      
      public var feed_id:String;
      
      public var feed_type:uint;
      
      public var metadata:ExchangeData = new ExchangeData();
      
      public var nucleusid:String;
      
      public var persona:String;
      
      public var quantity:int;
      
      public var uuidTimestamp:String;
      
      public var follower_nucleusid:String;
      
      public var follower_persona:String;
      
      public var is_maxis_curated:Boolean = false;
      
      public var isNew:Boolean;
      
      public var isInvalid:Boolean;
      
      public var displayText:String;
      
      public var timestamp:String;
      
      public function FeedData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.displayText = this.GetDisplayText();
         if(this.feed_type == TYPE_LOCAL_SAVE && !this.metadata.bIsSaved)
         {
            this.isInvalid = true;
         }
      }
      
      public function ViewDetails() : void
      {
         var _loc1_:String = null;
         switch(this.feed_type)
         {
            case TYPE_ITEM_DOWNLOAD:
            case TYPE_ITEM_FAVORITE:
            case TYPE_ITEM_COMMENT:
            case TYPE_ITEM_UPLOAD:
            case TYPE_ITEM_SHOWCASE:
            case TYPE_LOCAL_SAVE:
               _loc1_ = this.IsLocalEvent ? ExchangeDetailStates.MY_SAVES : ExchangeDetailStates.GALLERY;
               this.metadata.bIsFavorited = CommunicationManager.CallGameService("ExchangeIsItemFavorited",{
                  "remoteId":this.metadata.remote_id,
                  "itemType":this.metadata.type
               });
               this.metadata.bIsSaved = CommunicationManager.CallGameService("ExchangeIsItemDownloaded",{
                  "remoteId":this.metadata.remote_id,
                  "itemType":this.metadata.type
               });
               CommunicationManager.SendUIMessage("ShowExchangeDetail",{
                  "data":this.metadata,
                  "state":_loc1_,
                  "showComments":this.feed_type == TYPE_ITEM_COMMENT
               });
               break;
            case TYPE_PROFILE_COMMENT:
               SharedExchangeUtils.ShowPlayerProfile();
               break;
            case TYPE_PROFILE_FOLLOWERS:
               if(this.quantity > 1 || !this.follower_nucleusid || this.follower_nucleusid.length == 0)
               {
                  SharedExchangeUtils.ShowPlayerProfile();
                  CommunicationManager.SendUIMessage("ShowExchangeSubscriptions",{"bShowFollowers":true});
               }
               else
               {
                  SharedExchangeUtils.ShowPlayerProfile({
                     "playerId":this.follower_nucleusid,
                     "playerName":this.follower_persona
                  });
               }
               break;
            case TYPE_LOCAL_MOBILE:
               SharedExchangeUtils.ShowGalleryCatalog({
                  "mode":ExchangeShareMode.LIBRARY,
                  "filters":new ExchangeFilter(ExchangeShareMode.LIBRARY)
               });
         }
      }
      
      public function get IsLocalEvent() : Boolean
      {
         return this.feed_type == TYPE_LOCAL_SAVE || this.feed_type == TYPE_LOCAL_MOBILE;
      }
      
      public function LoadThumbnail(param1:IImageContainer) : void
      {
         if(this.isInvalid)
         {
            param1.LoadImage(ICON_INVALID);
            return;
         }
         switch(this.feed_type)
         {
            case TYPE_PROFILE_FOLLOWERS:
               if(this.quantity > 1 || !this.follower_nucleusid || this.follower_nucleusid.length == 0)
               {
                  param1.LoadImage(ICON_FOLLOWERS);
               }
               else
               {
                  param1.LoadImage(ImageUtils.CreatePlayerImageUrl(this.follower_nucleusid,ImageUtils.THUMBNAIL_SIZE_MEDIUM));
               }
               break;
            case TYPE_PROFILE_COMMENT:
               param1.LoadImage(ImageUtils.CreatePlayerImageUrl(this.nucleusid,ImageUtils.THUMBNAIL_SIZE_MEDIUM));
               break;
            case TYPE_LOCAL_MOBILE:
               param1.LoadImage(ICON_MOBILE);
               break;
            default:
               this.metadata.LoadThumbnail(param1,ImageUtils.THUMBNAIL_SIZE_LARGE);
         }
      }
      
      protected function GetDisplayText() : String
      {
         var _loc1_:int = int(this.metadata.type);
         var _loc2_:String = this.metadata.name != null ? TextUtils.EscapeHtml(this.metadata.name) : "";
         loop1:
         switch(this.feed_type)
         {
            case TYPE_ITEM_DOWNLOAD:
               return KeysEXCH.FEED_EVENT_TEXT_MY_ITEM_DOWNLOAD.toString(this.quantity,_loc2_);
            case TYPE_ITEM_FAVORITE:
               if(this.metadata.IsLastModifiedByMe)
               {
                  return KeysEXCH.FEED_EVENT_TEXT_MY_ITEM_FAVORITE.toString(this.quantity,_loc2_);
               }
               switch(_loc1_)
               {
                  case ExchangeData.TYPE_BLUEPRINT:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_FAVORITE_BP.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_HOUSEHOLD:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_FAVORITE_HH.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_ROOM:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_FAVORITE_RM.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_BODY_PART:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_FAVORITE_PART.toString(this.persona,_loc2_);
               }
            case TYPE_ITEM_COMMENT:
               return KeysEXCH.FEED_EVENT_TEXT_MY_ITEM_COMMENT.toString(this.persona,_loc2_);
            case TYPE_PROFILE_COMMENT:
               return KeysEXCH.FEED_EVENT_TEXT_MY_PROFILE_COMMENT.toString(this.persona);
            case TYPE_PROFILE_FOLLOWERS:
               if(this.quantity > 1 || !this.follower_nucleusid || this.follower_nucleusid.length == 0)
               {
                  return KeysEXCH.FEED_EVENT_TEXT_MY_PROFILE_NEW_FOLLOWER_MULTI.toString(this.quantity);
               }
               return KeysEXCH.FEED_EVENT_TEXT_MY_PROFILE_NEW_FOLLOWER.toString(this.follower_persona);
               break;
            case TYPE_ITEM_SHOWCASE:
               switch(_loc1_)
               {
                  case ExchangeData.TYPE_BLUEPRINT:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_SHOWCASE_BP.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_HOUSEHOLD:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_SHOWCASE_HH.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_ROOM:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_SHOWCASE_RM.toString(this.persona,_loc2_);
                  case ExchangeData.TYPE_BODY_PART:
                     return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_SHOWCASE_PART.toString(this.persona,_loc2_);
               }
            case TYPE_ITEM_UPLOAD:
               if(this.metadata.IsLastModifiedByMe)
               {
                  switch(_loc1_)
                  {
                     case ExchangeData.TYPE_BLUEPRINT:
                        if(this.metadata.bIsCGItem)
                        {
                           return KeysEXCH.FEED_EVENT_TEXT_CGSUBMIT_BP.toString(_loc2_);
                        }
                        return KeysEXCH.FEED_EVENT_TEXT_SHARED_BP.toString(_loc2_);
                        break;
                     case ExchangeData.TYPE_HOUSEHOLD:
                        if(this.metadata.bIsCGItem)
                        {
                           return KeysEXCH.FEED_EVENT_TEXT_CGSUBMIT_HH.toString(_loc2_);
                        }
                        return KeysEXCH.FEED_EVENT_TEXT_SHARED_HH.toString(_loc2_);
                        break;
                     case ExchangeData.TYPE_ROOM:
                        return KeysEXCH.FEED_EVENT_TEXT_SHARED_RM.toString(_loc2_);
                     case ExchangeData.TYPE_BODY_PART:
                        if(this.metadata.bIsCGItem)
                        {
                           return KeysEXCH.FEED_EVENT_TEXT_CGSUBMIT_PART.toString(_loc2_);
                        }
                        return KeysEXCH.FEED_EVENT_TEXT_SHARED_PART.toString(_loc2_);
                  }
               }
               else
               {
                  switch(_loc1_)
                  {
                     case ExchangeData.TYPE_BLUEPRINT:
                        return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_UPLOAD_BP.toString(this.persona,_loc2_);
                     case ExchangeData.TYPE_HOUSEHOLD:
                        return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_UPLOAD_HH.toString(this.persona,_loc2_);
                     case ExchangeData.TYPE_ROOM:
                        return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_UPLOAD_RM.toString(this.persona,_loc2_);
                     case ExchangeData.TYPE_BODY_PART:
                        return KeysEXCH.FEED_EVENT_TEXT_SUBSCRIPTION_UPLOAD_PART.toString(this.persona,_loc2_);
                  }
               }
            case TYPE_LOCAL_SAVE:
               switch(_loc1_)
               {
                  case ExchangeData.TYPE_BLUEPRINT:
                     return KeysEXCH.FEED_EVENT_TEXT_LOCAL_SAVE_BP.toString(_loc2_);
                  case ExchangeData.TYPE_HOUSEHOLD:
                     return KeysEXCH.FEED_EVENT_TEXT_LOCAL_SAVE_HH.toString(_loc2_);
                  case ExchangeData.TYPE_ROOM:
                     return KeysEXCH.FEED_EVENT_TEXT_LOCAL_SAVE_RM.toString(_loc2_);
                  case ExchangeData.TYPE_BODY_PART:
                     return KeysEXCH.FEED_EVENT_TEXT_LOCAL_SAVE_PART.toString(_loc2_);
                  default:
                     break loop1;
               }
            case TYPE_LOCAL_MOBILE:
               break;
            default:
               return "";
         }
         return KeysEXCH.FEED_EVENT_TEXT_LOCAL_MOBILE_DOWNLOAD.toString();
      }
   }
}

