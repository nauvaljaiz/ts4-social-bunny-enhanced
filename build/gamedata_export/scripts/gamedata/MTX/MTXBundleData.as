package gamedata.MTX
{
   import gamedata.GameContent;
   import gamedata.shared.PackFilterData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.objects.UMBaseData;
   import olympus.utils.DateUtils;
   
   public class MTXBundleData extends OlympusObject
   {
      
      public static const STATUS_READY:int = 0;
      
      public static const STATUS_DOWNLOADING:int = 1;
      
      public static const STATUS_INSTALL_REQUIRED:int = 2;
      
      public static const STATUS_INSTALLING:int = 3;
      
      public static const STATUS_RESTART_REQUIRED:int = 4;
      
      public static const STATUS_UNKNOWN:int = 5;
      
      public static const STATUS_WAITING:int = 6;
      
      public static const STATUS_QUEUED:int = 7;
      
      public static const VIEWED_STATE_INVALID:int = 0;
      
      public static const VIEWED_STATE_NEW:int = 1;
      
      public static const VIEWED_STATE_CELEBRATED:int = 2;
      
      public static const VIEWED_STATE_USED:int = 4;
      
      public static const VIEWED_STATE_ALL:int = 255;
      
      public static const BUNDLE_TYPE_PREMIUM:int = 1;
      
      public static const BUNDLE_TYPE_EP:int = 100;
      
      public static const BUNDLE_TYPE_GP:int = 200;
      
      public static const BUNDLE_TYPE_SP:int = 300;
      
      public static const BUNDLE_TYPE_KIT:int = 350;
      
      public static const BUNDLE_TYPE_OTHER:int = 400;
      
      public static const BUNDLE_TYPE_UGC:int = 500;
      
      public static const BUNDLE_TYPE_CUSTOM:int = 10000;
      
      public static const TRIAL_STATUS_NONE:int = 0;
      
      public static const TRIAL_STATUS_NOT_SUPPORTED:int = 1;
      
      public static const TRIAL_STATUS_NOT_ENTITLED:int = 2;
      
      public static const TRIAL_STATUS_NOT_MOUNTED:int = 3;
      
      public static const TRIAL_STATUS_ACTIVE:int = 4;
      
      public var bundleId:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var creatorName:String;
      
      public var currentPrice:String;
      
      public var originalPrice:String;
      
      public var discountPercent:Number;
      
      public var isDiscounted:Boolean;
      
      public var isFree:Boolean;
      
      public var isPreorder:Boolean;
      
      public var isPurchasable:Boolean;
      
      public var isOwned:Boolean;
      
      public var isInstalled:Boolean;
      
      public var mbIsEpi:Boolean;
      
      public var usedItemIdList:Array = [String];
      
      public var piwUrl:String;
      
      public var packId:int = -1;
      
      public var downloadDate:Date = DateUtils.DateDST();
      
      public var downloadDateString:String;
      
      public var bundleType:int;
      
      public var bundleStatus:int = -1;
      
      public var isTrial:Boolean = false;
      
      public var trialTerminateDate:Date = DateUtils.DateDST();
      
      public var trialStatus:int;
      
      public var exchangeItemType:uint;
      
      public var isViewed:Boolean;
      
      public var sortOrder:int = -1;
      
      public var bannerText:String = null;
      
      public var umData:UMBaseData = new UMBaseData();
      
      public function MTXBundleData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function Sort(param1:MTXBundleData, param2:MTXBundleData) : int
      {
         if(param1.bundleType == param2.bundleType)
         {
            return param2.packId - param1.packId;
         }
         return param1.bundleType - param2.bundleType;
      }
      
      public static function GetBundleDataByPackId(param1:int) : MTXBundleData
      {
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc2_:Object = CommunicationManager.CallGameService("GetBundleData",{"packId":param1});
         if(_loc2_)
         {
            _loc4_ = Boolean(_loc2_["isMTXBundle"]);
            return _loc4_ ? new MTXBundleData(_loc2_) : MTXBundleData.FromBundleBaseData(_loc2_);
         }
         var _loc3_:PackFilterData = GameContent.GetPackData(param1);
         if(Boolean(_loc3_) && Boolean(_loc3_.bundleId))
         {
            _loc5_ = CommunicationManager.CallGameService("RequestBundleById",{"bundleId":_loc3_.bundleId});
            if((Boolean(_loc5_)) && Boolean(_loc5_.hasOwnProperty("bundleBaseData")) && Boolean(_loc5_["bundleBaseData"]))
            {
               _loc5_.bundleBaseData["packId"] = param1;
               return MTXBundleData.FromBundleBaseData(_loc5_.bundleBaseData);
            }
         }
         return null;
      }
      
      public static function FromBundleBaseData(param1:Object) : MTXBundleData
      {
         var _loc3_:Object = null;
         var _loc2_:MTXBundleData = new MTXBundleData();
         _loc2_.bundleId = param1["bundleId"];
         if("packId" in param1)
         {
            _loc2_.packId = param1["packId"];
         }
         _loc2_.name = LocKey.UntranslatedString(param1["title"]);
         _loc2_.description = LocKey.UntranslatedString(param1["description"]);
         _loc2_.creatorName = param1["creatorName"];
         _loc2_.bundleType = param1["bundleType"];
         if("bundlePurchaseData" in param1)
         {
            _loc3_ = param1["bundlePurchaseData"];
            _loc2_.currentPrice = _loc3_["currentPrice"];
            _loc2_.originalPrice = _loc3_["originalPrice"];
            _loc2_.discountPercent = _loc3_["discountPercent"];
            _loc2_.isDiscounted = _loc3_["isDiscounted"];
            _loc2_.isFree = _loc3_["isFree"];
            _loc2_.isPurchasable = _loc3_["isPurchasable"];
         }
         _loc2_.isPreorder = param1["isPreorder"];
         _loc2_.isOwned = param1["isOwned"];
         _loc2_.isInstalled = param1["isInstalled"];
         _loc2_.mbIsEpi = param1["mbIsEpi"];
         if("usedItemIdList" in param1)
         {
            _loc2_.usedItemIdList = param1["usedItemIdList"].concat();
         }
         else
         {
            _loc2_.usedItemIdList = [];
         }
         _loc2_.isTrial = param1["isTrial"];
         return _loc2_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.usedItemIdList);
      }
      
      public function get DiscountPercent() : int
      {
         return Math.round(this.discountPercent);
      }
      
      public function get IsDownloading() : Boolean
      {
         return this.bundleStatus == STATUS_DOWNLOADING;
      }
      
      public function get IsInstalling() : Boolean
      {
         return this.bundleStatus == STATUS_INSTALLING;
      }
      
      public function get NeedsRestart() : Boolean
      {
         return this.bundleStatus == STATUS_RESTART_REQUIRED;
      }
      
      public function get IsOwnedFull() : Boolean
      {
         if(this.isTrial)
         {
            return this.isOwned && this.trialStatus == TRIAL_STATUS_NOT_ENTITLED;
         }
         return this.isOwned;
      }
      
      public function get IsOwnedTrial() : Boolean
      {
         if(this.isTrial)
         {
            return this.isOwned && this.trialStatus >= TRIAL_STATUS_NOT_MOUNTED;
         }
         return false;
      }
      
      public function HasDiscountGreaterThanDefault() : Boolean
      {
         return this.isDiscounted && this.DiscountPercent > 10 || this.isFree && this.bundleType == MTXBundleData.BUNDLE_TYPE_OTHER;
      }
      
      public function GetDiscountPercentText() : String
      {
         return this.isDiscounted ? Keys.GENERIC_PERCENTAGE.toString(-this.DiscountPercent) : Keys.LAUNCHER_PACK_DISPLAY_FREE.toString();
      }
      
      public function Clone() : MTXBundleData
      {
         var _loc1_:MTXBundleData = new MTXBundleData();
         _loc1_.bundleId = this.bundleId;
         _loc1_.name = this.name;
         _loc1_.description = this.description;
         _loc1_.currentPrice = this.currentPrice;
         _loc1_.originalPrice = this.originalPrice;
         _loc1_.discountPercent = this.discountPercent;
         _loc1_.isDiscounted = this.isDiscounted;
         _loc1_.isFree = this.isFree;
         _loc1_.isPreorder = this.isPreorder;
         _loc1_.isPurchasable = this.isPurchasable;
         _loc1_.isOwned = this.isOwned;
         _loc1_.isInstalled = this.isInstalled;
         _loc1_.mbIsEpi = this.mbIsEpi;
         _loc1_.usedItemIdList = this.usedItemIdList.concat();
         _loc1_.piwUrl = this.piwUrl;
         _loc1_.packId = this.packId;
         _loc1_.downloadDate = this.downloadDate;
         _loc1_.downloadDateString = this.downloadDateString;
         _loc1_.bundleType = this.bundleType;
         _loc1_.bundleStatus = this.bundleStatus;
         _loc1_.isTrial = this.isTrial;
         _loc1_.trialTerminateDate = this.trialTerminateDate;
         _loc1_.trialStatus = this.trialStatus;
         return _loc1_;
      }
   }
}

