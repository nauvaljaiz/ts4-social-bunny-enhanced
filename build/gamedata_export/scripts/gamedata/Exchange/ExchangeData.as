package gamedata.Exchange
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import gamedata.BuildBuy.Venues.VenueTypes;
   import gamedata.GameContent;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.SimGenderTypes;
   import gamedata.shared.Species;
   import gamedata.shared.ZoneModifier;
   import olympus.core.ConnectionManager;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysEXCH;
   import olympus.localization.LocKey;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   import olympus.utils.SystemUtils;
   import widgets.Exchange.constants.ExchangeItemPlatform;
   import widgets.Exchange.constants.ExchangeTunables;
   import widgets.shared.constants.ExchangeDetailStates;
   
   public final class ExchangeData extends OlympusObject
   {
      
      protected static var sLocalOriginId:String;
      
      protected static var sLocalOriginName:String;
      
      protected static var sLocalExchangePlatformType:uint;
      
      public static const TYPE_INVALID:uint = 0;
      
      public static const TYPE_HOUSEHOLD:uint = 1;
      
      public static const TYPE_BLUEPRINT:uint = 2;
      
      public static const TYPE_ROOM:uint = 3;
      
      public static const TYPE_ALL:uint = 4;
      
      public static const TYPE_BODY_PART:uint = 5;
      
      public static const BB_LRT_CUSTOM_IMAGES:uint = 0;
      
      public static const BB_LRT_MANNEQUINS:uint = 1;
      
      public static const BB_LRT_ELEVATORS:uint = 2;
      
      public static const BB_LRT_COUNT:uint = 3;
      
      public static const EXCHANGE_METADATA_VERSION_V000:int = 0;
      
      protected static var sUploadFileSizeLimit:Number = 0;
      
      protected static var sBBObjectLimits:Array = null;
      
      protected static var sCGEnabled:Boolean = false;
      
      protected static var sCGEnabledSet:Boolean = false;
      
      protected static var sChallengesDataList:Array = null;
      
      protected static var sChallengeDataListPendingUpdate:Boolean = false;
      
      public static const DEFAULT_ITEM_PAYLOAD_SIZE:Array = [0,100000,300000,200000];
      
      protected static const BLUEPRINT_THUMBNAIL_FLOOR_START_INDEX:uint = 2;
      
      public static const PLATFORM_ICON_FRAMELABEL_PS4:String = "PS4";
      
      public static const PLATFORM_ICON_FRAMELABEL_XB1:String = "XB1";
      
      public static const PLATFORM_ICON_FRAMELABLE_MAXIS:String = "Maxis";
      
      public static const PLATFORM_ICON_FRAMELABEL_DEFAULT:String = "default";
      
      public var type:uint;
      
      public var id:String;
      
      public var remote_id:String = "";
      
      public var is_casdemo:Boolean;
      
      public var name:String;
      
      public var description:String = "";
      
      public var creator_id:String;
      
      public var creator_name:String;
      
      public var modifier_id:String;
      
      public var modifier_name:String;
      
      public var downloads:uint;
      
      public var favorites:uint;
      
      public var savedDate:String;
      
      public var isPrepopulated:Boolean;
      
      public var isMaxis:Boolean;
      
      public var mtx_ids:Array;
      
      public var bHasLockedContent:Boolean;
      
      public var bIsModded:Boolean;
      
      public var bIsCGItem:Boolean;
      
      public var bIsCGInterested:Boolean;
      
      public var bIsShowcase:Boolean;
      
      public var bIsFavorited:Boolean;
      
      public var bIsSaved:Boolean;
      
      public var bIsRecommendedItem:Boolean;
      
      public var verify_code:uint;
      
      public var payloadSize:Number = 0;
      
      public var sizeX:uint;
      
      public var sizeZ:uint;
      
      public var priceValue:uint;
      
      public var customImageCount:uint;
      
      public var mannequinCount:uint;
      
      public var itemMetadataVersion:int = 0;
      
      public var familyId:String;
      
      public var familySize:uint;
      
      public var pendingBabies:uint;
      
      public var sim_data:Array = [ExchangeSimData];
      
      public var venueKey:String;
      
      public var venueName:LocKey;
      
      public var venueFlags:uint;
      
      public var venueType:uint;
      
      public var bCanBeOccupied:Boolean;
      
      public var numBedrooms:uint;
      
      public var numBathrooms:uint;
      
      public var unfurnishedPrice:uint;
      
      public var priceLevel:uint;
      
      public var numThumbnails:uint;
      
      public var groundFloorThumbIndex:uint = 2;
      
      public var lotTraits:Array = [ZoneModifier];
      
      public var unitCount:uint;
      
      public var dynamicAreaTypeList:Array = [int];
      
      public var roomType:uint;
      
      public var bodyType:uint;
      
      public var bodyPartSimId:String;
      
      public var thumbIndex:int;
      
      public var highlightable:Boolean;
      
      public var bIsForGallery:Boolean;
      
      public var template_id:String;
      
      public var bIsModEditable:Boolean;
      
      public var mFavoriteOpRef:String;
      
      public var mSubscribeOpRef:String;
      
      public var creator_platform_id:String;
      
      public var creator_platform_name:String;
      
      public var modifier_platform_id:String;
      
      public var modifier_platform_name:String;
      
      public var creator_platform:uint;
      
      public var modifier_platform:uint;
      
      public var cds_patch_base_changelists:Array = [];
      
      public var cds_content_patch_mounted:Boolean;
      
      public var occultTypes:uint;
      
      public function ExchangeData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get UploadFileSizeLimit() : Number
      {
         if(sUploadFileSizeLimit == 0)
         {
            sUploadFileSizeLimit = CommunicationManager.CallGameService("GetUploadFileSizeLimit") as Number;
         }
         return sUploadFileSizeLimit;
      }
      
      public static function get BBObjectLimits() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(sBBObjectLimits == null)
         {
            _loc1_ = new Array(BB_LRT_COUNT);
            _loc2_ = 0;
            _loc3_ = int(BB_LRT_COUNT);
            while(_loc2_ < _loc3_)
            {
               _loc1_[_loc2_] = CommunicationManager.CallGameService("GetResourceLimit",_loc2_) as uint;
               _loc2_++;
            }
            sBBObjectLimits = _loc1_;
         }
         return sBBObjectLimits;
      }
      
      public static function get IsCGEnabled() : Boolean
      {
         if(!sCGEnabledSet)
         {
            sCGEnabled = CommunicationManager.CallGameService("GetIsCGEnabled");
            sCGEnabledSet = true;
         }
         return sCGEnabled;
      }
      
      public static function get CGChallengesData() : Array
      {
         if(!sChallengesDataList)
         {
            sChallengesDataList = new Array();
            CommunicationManager.AddMessageListenerByName("CGChallengeResponse",CGChallengeDataResponse,"ExchangeData");
            sChallengeDataListPendingUpdate = true;
            CommunicationManager.CallGameService("RequestCGChallengeMessages");
         }
         return sChallengesDataList;
      }
      
      public static function GetStartedCGChallengesData() : Array
      {
         var _loc3_:CGChallengeData = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = CGChallengesData;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Started)
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public static function GetActiveChallengeMenuItem(param1:Array) : CGChallengeData
      {
         var _loc2_:CGChallengeData = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.Active)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function get CGChallengesDataPendingUpdate() : Boolean
      {
         return sChallengeDataListPendingUpdate;
      }
      
      protected static function CGChallengeDataResponse(param1:Object) : void
      {
         var _loc5_:CGChallengeData = null;
         if(!param1)
         {
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("CGChallengeResponse",CGChallengeDataResponse,"ExchangeData");
         sChallengeDataListPendingUpdate = false;
         var _loc2_:Array = param1["CGChallengeData"];
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new CGChallengeData(_loc2_[_loc4_]);
            sChallengesDataList[_loc4_] = _loc5_;
            _loc4_++;
         }
         CommunicationManager.SendMessage("CGChallengeDataUpdated",sChallengesDataList);
      }
      
      public static function get CGCurrentChallenge() : CGChallengeData
      {
         var _loc2_:CGChallengeData = null;
         var _loc1_:Array = CGChallengesData;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.Active)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function GetCGChallengeByHashTag(param1:String) : CGChallengeData
      {
         var _loc3_:CGChallengeData = null;
         var _loc2_:Array = CGChallengesData;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.HashTag.toLowerCase() == param1.toLowerCase())
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function get LocalExchangeItemPlatformType() : uint
      {
         if(!sLocalExchangePlatformType)
         {
            if(SystemUtils.IsXB1)
            {
               sLocalExchangePlatformType = ExchangeItemPlatform.EXCHANGE_PLATFORM_XB1;
            }
            else if(SystemUtils.IsPS4)
            {
               sLocalExchangePlatformType = ExchangeItemPlatform.EXCHANGE_PLATFORM_PS4;
            }
            else if(SystemUtils.IsMac)
            {
               sLocalExchangePlatformType = ExchangeItemPlatform.EXCHANGE_PLATFORM_OSX;
            }
            else if(SystemUtils.IsPC)
            {
               sLocalExchangePlatformType = ExchangeItemPlatform.EXCHANGE_PLATFORM_WINDOWS;
            }
            else
            {
               sLocalExchangePlatformType = ExchangeItemPlatform.EXCHANGE_PLATFORM_UNKNOWN;
            }
         }
         return sLocalExchangePlatformType;
      }
      
      public static function SetPlatformHighlightState(param1:DisplayObject, param2:int = -1, param3:int = -1) : void
      {
         var _loc5_:ColorTransform = null;
         if(!param1)
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = int(LocalExchangeItemPlatformType);
         }
         var _loc4_:int = param3;
         switch(param2)
         {
            case ExchangeItemPlatform.EXCHANGE_PLATFORM_PS4:
               _loc4_ = int(ExchangeTunables.PLATFORM_HIGHLIGHT_COLOR_PS4);
               break;
            case ExchangeItemPlatform.EXCHANGE_PLATFORM_XB1:
               _loc4_ = int(ExchangeTunables.PLATFORM_HIGHLIGHT_COLOR_XB1);
         }
         if(_loc4_ == -1)
         {
            return;
         }
         if(_loc4_ == 0)
         {
            param1.transform.colorTransform = null;
         }
         else
         {
            _loc5_ = param1.transform.colorTransform;
            _loc5_.color = _loc4_;
            param1.transform.colorTransform = _loc5_;
         }
      }
      
      public static function SetPlatformDisplayState(param1:MovieClip, param2:int = -1) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param2 == -1)
         {
            param2 = int(LocalExchangeItemPlatformType);
         }
         switch(param2)
         {
            case ExchangeItemPlatform.EXCHANGE_PLATFORM_PS4:
               param1.gotoAndStop(PLATFORM_ICON_FRAMELABEL_PS4);
               return true;
            case ExchangeItemPlatform.EXCHANGE_PLATFORM_XB1:
               param1.gotoAndStop(PLATFORM_ICON_FRAMELABEL_XB1);
               return true;
            default:
               param1.gotoAndStop(PLATFORM_ICON_FRAMELABEL_DEFAULT);
               return false;
         }
      }
      
      public static function SetMaxisIconDisplayState(param1:MovieClip) : void
      {
         if(!param1)
         {
            return;
         }
         param1.gotoAndStop(PLATFORM_ICON_FRAMELABLE_MAXIS);
      }
      
      public static function get LocalOriginId() : String
      {
         if(!sLocalOriginId)
         {
            sLocalOriginId = CommunicationManager.CallGameService("GetLocalOriginId") as String;
         }
         return sLocalOriginId;
      }
      
      public static function get LocalOriginName() : String
      {
         if(!sLocalOriginName)
         {
            sLocalOriginName = CommunicationManager.CallGameService("GetLocalOriginName") as String;
         }
         return sLocalOriginName;
      }
      
      public static function TypeToLocalizedString(param1:uint) : String
      {
         switch(param1)
         {
            case TYPE_HOUSEHOLD:
               return KeysEXCH.ITEM_TYPE_HOUSEHOLD.toString();
            case TYPE_BLUEPRINT:
               return KeysEXCH.ITEM_TYPE_BLUEPRINT.toString();
            case TYPE_ROOM:
               return KeysEXCH.ITEM_TYPE_ROOM.toString();
            case TYPE_BODY_PART:
               return KeysEXCH.ITEM_TYPE_PART.toString();
            default:
               return "";
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.type = param1.type;
         this.id = param1.id;
         this.remote_id = param1.remote_id;
         this.is_casdemo = param1.is_casdemo;
         this.name = param1.name;
         this.description = param1.description;
         this.creator_id = param1.creator_id;
         this.creator_name = param1.creator_name;
         this.modifier_id = param1.modifier_id;
         this.modifier_name = param1.modifier_name;
         this.downloads = param1.downloads;
         this.favorites = param1.favorites;
         this.savedDate = param1.savedDate;
         this.isPrepopulated = param1.isPrepopulated;
         this.isMaxis = param1.isMaxis;
         this.mtx_ids = param1.mtx_ids || new Array();
         this.bHasLockedContent = param1.bHasLockedContent;
         this.bIsModded = param1.bIsModded;
         this.bIsCGItem = param1.bIsCGItem;
         this.bIsCGInterested = param1.bIsCGInterested;
         this.bIsShowcase = param1.bIsShowcase;
         this.bIsFavorited = param1.bIsFavorited;
         this.bIsSaved = param1.bIsSaved;
         this.bIsRecommendedItem = param1.bIsRecommendedItem;
         this.verify_code = param1.verify_code;
         this.payloadSize = param1.payloadSize ? Number(param1.payloadSize) : 0;
         this.sizeX = param1.sizeX;
         this.sizeZ = param1.sizeZ;
         this.priceValue = param1.priceValue;
         this.customImageCount = param1.customImageCount;
         this.mannequinCount = param1.mannequinCount;
         this.itemMetadataVersion = param1.itemMetadataVersion;
         this.familyId = param1.familyId;
         this.familySize = param1.familySize;
         this.pendingBabies = param1.pendingBabies;
         this.venueKey = param1.venueKey;
         this.venueFlags = param1.venueFlags;
         this.venueType = param1.venueType;
         this.bCanBeOccupied = param1.bCanBeOccupied;
         this.numBedrooms = param1.numBedrooms;
         this.numBathrooms = param1.numBathrooms;
         this.unfurnishedPrice = param1.unfurnishedPrice;
         this.priceLevel = param1.priceLevel;
         this.unitCount = param1.unitCount;
         this.dynamicAreaTypeList = param1.dynamicAreaTypeList || [];
         this.numThumbnails = param1.numThumbnails;
         this.groundFloorThumbIndex = param1.groundFloorThumbIndex;
         this.roomType = param1.roomType;
         this.bodyType = param1.bodyType;
         this.bodyPartSimId = param1.bodyPartSimId;
         this.thumbIndex = param1.thumbIndex;
         this.highlightable = param1.highlightable;
         this.bIsForGallery = param1.bIsForGallery;
         this.template_id = param1.template_id;
         this.bIsModEditable = param1.bIsModEditable;
         this.creator_platform_id = param1.creator_platform_id;
         this.creator_platform_name = param1.creator_platform_name;
         this.modifier_platform_id = param1.modifier_platform_id;
         this.modifier_platform_name = param1.modifier_platform_name;
         this.creator_platform = param1.creator_platform;
         this.modifier_platform = param1.modifier_platform;
         this.cds_patch_base_changelists = param1.cds_patch_base_changelists;
         this.cds_content_patch_mounted = param1.cds_content_patch_mounted;
         this.occultTypes = param1.occultTypes;
         if("venueName" in param1 && Boolean(param1.venueName))
         {
            this.venueName = new LocKey(param1.venueName);
         }
         OlympusObject.ConstructArrayFromArray(this.sim_data,param1["sim_data"]);
         OlympusObject.ConstructArrayFromArray(this.lotTraits,param1["lotTraits"]);
         this.bIsModEditable = !this.bIsModded;
         this.ParseSpecializedFields();
      }
      
      public function get IsLocal() : Boolean
      {
         return Boolean(this.id) && this.id.length > 0 && this.id != "0";
      }
      
      public function get IsLocalTemplate() : Boolean
      {
         return Boolean(this.template_id) && this.template_id.length > 0 && this.template_id != "0";
      }
      
      public function get IsShared() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Boolean = this.remote_id == null || this.remote_id.length == 0;
         if(!_loc1_)
         {
            if(this.remote_id.length == 32)
            {
               _loc2_ = 0;
               while(_loc2_ < 32)
               {
                  if(this.remote_id.charAt(_loc2_) != "0")
                  {
                     break;
                  }
                  _loc2_++;
               }
               _loc1_ = _loc2_ == 32;
            }
         }
         return !_loc1_;
      }
      
      public function get IsModified() : Boolean
      {
         return !this.isPrepopulated && Boolean(this.modifier_name) && this.modifier_name.length > 0;
      }
      
      public function get IsSelfCreated() : Boolean
      {
         return this.creator_id == LocalOriginId || this.creator_id == "0";
      }
      
      public function get IsSelfModified() : Boolean
      {
         return !this.isPrepopulated && this.modifier_id == LocalOriginId || this.modifier_id == "0";
      }
      
      public function get IsLastModifiedByMe() : Boolean
      {
         if(this.isPrepopulated)
         {
            return false;
         }
         return this.IsModified ? this.IsSelfModified : this.IsSelfCreated;
      }
      
      public function get PriceLevel() : String
      {
         return "§§§§§".substr(0,this.priceLevel);
      }
      
      public function get CreatorOrSharerOriginId() : String
      {
         return this.IsModified ? this.modifier_id : this.creator_id;
      }
      
      public function get CreatorOrSharerOriginName() : String
      {
         return this.IsModified ? this.modifier_name : this.creator_name;
      }
      
      public function GetCreatorPlatformName(param1:Boolean, param2:Boolean) : String
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = !ConnectionManager.IsOnlineAccessDisabled;
         if(param1 && param2 && this.IsSelfCreated)
         {
            _loc3_ = KeysEXCH.CREATED_SELF.toString();
         }
         else if(Boolean(_loc4_ && LocalExchangeItemPlatformType == this.creator_platform) && Boolean(this.creator_platform_name) && this.creator_platform_name.length > 0)
         {
            _loc3_ = this.creator_platform_name;
         }
         else
         {
            _loc3_ = this.creator_name;
         }
         return _loc3_;
      }
      
      public function GetModifierPlatformName(param1:Boolean, param2:Boolean) : String
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = !ConnectionManager.IsOnlineAccessDisabled;
         if(param1 && param2 && this.IsSelfModified)
         {
            _loc3_ = KeysEXCH.CREATED_SELF.toString();
         }
         else if(Boolean(_loc4_ && LocalExchangeItemPlatformType == this.modifier_platform) && Boolean(this.modifier_platform_name) && this.modifier_platform_name.length > 0)
         {
            _loc3_ = this.modifier_platform_name;
         }
         else
         {
            _loc3_ = this.modifier_name;
         }
         return _loc3_;
      }
      
      public function GetCreatorOrSharerPlatformName(param1:Boolean, param2:Boolean) : String
      {
         if(this.IsModified)
         {
            return this.GetModifierPlatformName(param1,param2);
         }
         return this.GetCreatorPlatformName(param1,param2);
      }
      
      public function GetCreatorPlatformType() : uint
      {
         var _loc1_:uint = uint(ExchangeItemPlatform.EXCHANGE_PLATFORM_UNKNOWN);
         var _loc2_:Boolean = !ConnectionManager.IsOnlineAccessDisabled;
         if(Boolean(_loc2_ && LocalExchangeItemPlatformType == this.creator_platform) && Boolean(this.creator_platform_name) && this.creator_platform_name.length > 0)
         {
            _loc1_ = this.creator_platform;
         }
         return _loc1_;
      }
      
      public function GetModifierPlatformType() : uint
      {
         var _loc1_:uint = uint(ExchangeItemPlatform.EXCHANGE_PLATFORM_UNKNOWN);
         var _loc2_:Boolean = !ConnectionManager.IsOnlineAccessDisabled;
         if(Boolean(_loc2_ && LocalExchangeItemPlatformType == this.modifier_platform) && Boolean(this.modifier_platform_name) && this.modifier_platform_name.length > 0)
         {
            _loc1_ = this.modifier_platform;
         }
         return _loc1_;
      }
      
      public function GetCreatorOrSharerPlatformType() : uint
      {
         if(this.IsModified)
         {
            return this.GetModifierPlatformType();
         }
         return this.GetCreatorPlatformType();
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null, param3:int = 0, param4:Boolean = false) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc5_:Boolean = !this.IsLocal && this.IsShared || param4;
         if(this.type == TYPE_HOUSEHOLD)
         {
            if(_loc5_)
            {
               return ImageUtils.LoadGalleryThumbnail(param1,this.remote_id,"h",param2);
            }
            return ImageUtils.LoadHouseholdThumbnail(param1,this.familyId ? this.familyId : this.id,param2,true,ImageUtils.SIM_THUMBNAIL_POSTFIX_GALLERY);
         }
         if(this.type == TYPE_BLUEPRINT)
         {
            if(_loc5_)
            {
               return ImageUtils.LoadGalleryThumbnail(param1,this.remote_id,"b",param2,param3);
            }
            return ImageUtils.LoadBlueprintThumbnail(param1,this.id,param3,param2,!this.IsLocal);
         }
         if(this.type == TYPE_ROOM)
         {
            if(_loc5_)
            {
               return ImageUtils.LoadGalleryThumbnail(param1,this.remote_id,"r",param2,param3);
            }
            return ImageUtils.LoadRoomThumbnail(param1,this.id,param3,param2,!this.IsLocal);
         }
         if(this.type == TYPE_BODY_PART)
         {
            if(_loc5_)
            {
               return ImageUtils.LoadGalleryThumbnail(param1,this.remote_id,"p",param2,param3);
            }
            if(this.IsLocal)
            {
               return ImageUtils.LoadPartLocalThumbnail(param1,ImageUtils.SIM_THUMBNAIL_TYPE_GALLERY,this.id,param2,param3);
            }
            return ImageUtils.LoadPartThumbnail(param1,ImageUtils.SIM_THUMBNAIL_TYPE_PART,this.bodyType,this.bodyPartSimId,param2,param3);
         }
         return false;
      }
      
      public function GetGalleryThumbnailUrl(param1:IImageContainer, param2:String = null, param3:int = 0, param4:Boolean = false) : String
      {
         var _loc5_:Boolean = !this.IsLocal && this.IsShared || param4;
         if(this.type == TYPE_HOUSEHOLD)
         {
            if(_loc5_)
            {
               return ImageUtils.GetGalleryThumbnailUrl(param1,this.remote_id,"h",param2,param3);
            }
            return ImageUtils.GetHouseholdThumbnailUrl(param1,this.familyId ? this.familyId : this.id,param2,ImageUtils.SIM_THUMBNAIL_POSTFIX_GALLERY);
         }
         if(this.type == TYPE_BLUEPRINT)
         {
            if(_loc5_)
            {
               return ImageUtils.GetGalleryThumbnailUrl(param1,this.remote_id,"b",param2,param3);
            }
            return ImageUtils.GetBlueprintThumbnailUrl(param1,this.id,param3,param2);
         }
         if(this.type == TYPE_ROOM)
         {
            if(_loc5_)
            {
               return ImageUtils.GetGalleryThumbnailUrl(param1,this.remote_id,"r",param2,param3);
            }
            return ImageUtils.GetRoomThumbnailUrl(param1,this.id,param3,param2);
         }
         if(this.type == TYPE_BODY_PART)
         {
            if(_loc5_)
            {
               return ImageUtils.GetGalleryThumbnailUrl(param1,this.remote_id,"r",param2,param3);
            }
            if(this.IsLocal)
            {
               return ImageUtils.GetBodyPartLocalThumbnailUrl(param1,this.id,param3,param2);
            }
            return ImageUtils.GetBodyPartThumbnailUrl(param1,this.bodyPartSimId,this.bodyType,param3,param2);
         }
         return "";
      }
      
      public function GetThumbnailDescription(param1:int) : String
      {
         var _loc2_:int = 0;
         if(this.type == TYPE_BLUEPRINT && param1 >= BLUEPRINT_THUMBNAIL_FLOOR_START_INDEX)
         {
            if(param1 < this.groundFloorThumbIndex)
            {
               _loc2_ = this.groundFloorThumbIndex - param1;
               return KeysEXCH.DETAIL_LABEL_BP_THUMB_SUBFLOOR.toString(_loc2_);
            }
            _loc2_ = param1 - this.groundFloorThumbIndex;
            return KeysEXCH.DETAIL_LABEL_BP_THUMB_UPPERFLOOR.toString(_loc2_ + 1);
         }
         return "";
      }
      
      public function HouseholdContainsAdults() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:ExchangeSimData = null;
         if(this.type == TYPE_HOUSEHOLD)
         {
            if(this.isPrepopulated)
            {
               return true;
            }
            _loc1_ = this.sim_data;
            for each(_loc2_ in _loc1_)
            {
               if(!Species.IsPet(_loc2_.species))
               {
                  if(SimAgeTypes.IsTeenOrOlder(_loc2_.age))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function GetNumHouseholdBabies() : int
      {
         var _loc2_:Array = null;
         var _loc3_:ExchangeSimData = null;
         var _loc1_:int = 0;
         if(this.type == TYPE_HOUSEHOLD)
         {
            _loc2_ = this.sim_data;
            for each(_loc3_ in _loc2_)
            {
               if(SimAgeTypes.IsBaby(_loc3_.age))
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function GetNumSimsWithPendingBabies() : uint
      {
         return this.familySize + this.pendingBabies;
      }
      
      public function CheckObjectCountLimit() : String
      {
         if(this.type == TYPE_BLUEPRINT || this.type == TYPE_ROOM)
         {
            if(this.customImageCount > BBObjectLimits[BB_LRT_CUSTOM_IMAGES])
            {
               return KeysEXCH.DETAIL_TOOLTIP_SHARE_DISABLED_LIMIT_CUSTOM_IMG.toString();
            }
            if(this.mannequinCount > BBObjectLimits[BB_LRT_MANNEQUINS])
            {
               return KeysEXCH.DETAIL_TOOLTIP_SHARE_DISABLED_LIMIT_MANNEQUIN.toString(this.mannequinCount - BBObjectLimits[BB_LRT_MANNEQUINS]);
            }
         }
         return null;
      }
      
      public function CheckSizeLimit() : String
      {
         if(this.type == TYPE_BLUEPRINT || this.type == TYPE_ROOM)
         {
            if(this.payloadSize > UploadFileSizeLimit)
            {
               return KeysEXCH.TOOLTIP_TOO_LARGE.toString();
            }
         }
         return null;
      }
      
      public function IsNewerVersionThanClient() : Boolean
      {
         if(this.itemMetadataVersion == EXCHANGE_METADATA_VERSION_V000)
         {
            return false;
         }
         return this.itemMetadataVersion > GameContent.GetCurrentExchangeMetadataVersion();
      }
      
      public function ShouldShowVenueSelection(param1:NeighborhoodLotData) : Boolean
      {
         if(this.venueKey == param1.venueData.tagKey)
         {
            return false;
         }
         if(param1.lotDescriptionData.isVenueLocked)
         {
            return false;
         }
         if(this.venueType == VenueTypes.RESIDENTIAL && param1.IsVacationRentalLot)
         {
            return false;
         }
         return param1.occupantId == null;
      }
      
      public function Update(param1:ExchangeData) : void
      {
         this.id = param1.id;
         this.remote_id = param1.remote_id;
         this.name = param1.name;
         this.description = param1.description;
         this.creator_id = param1.creator_id;
         this.creator_name = param1.creator_name;
         this.modifier_id = param1.modifier_id;
         this.modifier_name = param1.modifier_name;
         this.downloads = param1.downloads;
         this.favorites = param1.favorites;
         this.savedDate = param1.savedDate;
         this.bIsModded = param1.bIsModded;
         this.bIsShowcase = param1.bIsShowcase;
         this.bIsFavorited = param1.bIsFavorited;
         this.bIsSaved = param1.bIsSaved;
         this.verify_code = param1.verify_code;
         this.payloadSize = param1.payloadSize;
         this.itemMetadataVersion = param1.itemMetadataVersion;
         this.creator_platform = param1.creator_platform;
         this.modifier_platform = param1.modifier_platform;
         this.creator_platform_id = param1.creator_platform_id;
         this.creator_platform_name = param1.creator_platform_name;
         this.modifier_platform_id = param1.modifier_platform_id;
         this.modifier_platform_name = param1.modifier_platform_name;
      }
      
      protected function ParseSpecializedFields() : void
      {
         var _loc8_:ExchangeSimData = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc1_:String = ExchangeDetailStates.SAVE_SUMMARY;
         var _loc2_:Boolean = !this.IsLocal && this.IsShared;
         if(_loc2_)
         {
            _loc1_ = ExchangeDetailStates.GALLERY;
         }
         else if(this.IsLocal)
         {
            _loc1_ = ExchangeDetailStates.MY_SAVES;
         }
         var _loc3_:Array = this.sim_data;
         var _loc4_:Object = new Object();
         var _loc5_:* = 1;
         var _loc6_:int = 0;
         var _loc7_:int = int(_loc3_.length);
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc3_[_loc6_] as ExchangeSimData;
            if(!SimAgeTypes.IsBaby(_loc8_.age))
            {
               _loc8_.index = _loc6_ + 1;
               _loc8_.thumbnailContext = _loc1_;
               _loc8_.itemRemoteId = this.remote_id;
               _loc4_[_loc8_.id] = {
                  "thumbIndex":_loc5_++,
                  "isFemale":SimGenderTypes.IsFemale(_loc8_.gender)
               };
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = _loc3_[_loc6_].sim_relationships;
            _loc10_ = 0;
            _loc11_ = int(_loc9_.length);
            while(_loc10_ < _loc11_)
            {
               _loc12_ = _loc9_[_loc10_];
               if(_loc4_[_loc12_.sim_id])
               {
                  _loc12_.thumb_index = _loc4_[_loc12_.sim_id].thumbIndex;
                  _loc12_.is_female = _loc4_[_loc12_.sim_id].isFemale;
               }
               _loc10_++;
            }
            _loc6_++;
         }
      }
   }
}

