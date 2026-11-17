package olympus.utils
{
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.GameContent;
   import gamedata.Gameplay.shared.AgeUpdate;
   import gamedata.shared.DefinitionGeoPair;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.PackFilterData;
   import gamedata.shared.ResourceKey;
   import gamedata.shared.SharedIcons;
   import gamedata.shared.SimAgeTypes;
   import olympus.io.CommunicationManager;
   import olympus.objects.IconInfo;
   import olympus.resources.IImageContainer;
   
   public final class ImageUtils
   {
      
      public static var sSetActiveHttpDownloadGroup:Function;
      
      protected static var sSimThumbnailSizeMaps:Object;
      
      public static const INVALID_IMAGE:String = "0";
      
      public static const THUMBNAIL_SIZE_SMALL:String = "_s";
      
      public static const THUMBNAIL_SIZE_MEDIUM:String = "_m";
      
      public static const THUMBNAIL_SIZE_LARGE:String = "_l";
      
      public static const THUMBNAIL_SIZE_XLARGE:String = "_x";
      
      public static const THUMBNAIL_SIZE_FOOD:String = "_f";
      
      public static const THUMBNAIL_SIZE_ENORMOUS:String = "_e";
      
      public static const THUMBNAIL_SIZE_CUSTOM:String = "_c";
      
      public static const OBJECT_THUMBNAIL_TYPE_PAINTING:String = "_p";
      
      public static const OBJECT_THUMBNAIL_TYPE_CANVAS_EFFECT:String = "_e";
      
      public static const OBJECT_THUMBNAIL_TYPE_PUZZLE:String = "_z";
      
      public static const OBJECT_THUMBNAIL_TYPE_STATE_INDEX:String = "_c";
      
      public static const OBJECT_THUMBNAIL_TYPE_GEO_STATE:String = "_g";
      
      public static const OBJECT_THUMBNAIL_TYPE_MATERIAL_STATE:String = "_m";
      
      public static const OBJECT_THUMBNAIL_TYPE_MULTICOLOR_SHIFT:String = "_s";
      
      public static const SIM_THUMBNAIL_TYPE_FACE:String = "f_";
      
      public static const SIM_THUMBNAIL_TYPE_BUST:String = "b_";
      
      public static const SIM_THUMBNAIL_TYPE_WHOLEBODY:String = "w_";
      
      public static const SIM_THUMBNAIL_TYPE_MANNEQUIN:String = "m_";
      
      public static const SIM_THUMBNAIL_TYPE_FEATURED_LOOK:String = "l_";
      
      public static const SIM_THUMBNAIL_TYPE_PORTRAIT_CAS:String = "p_";
      
      public static const SIM_THUMBNAIL_TYPE_CAS_FACE:String = "s_";
      
      public static const SIM_THUMBNAIL_TYPE_PHOTOBOOTH_FAMILY:String = "o_";
      
      public static const SIM_THUMBNAIL_TYPE_LINEUP:String = "t_";
      
      public static const SIM_THUMBNAIL_TYPE_GALLERY:String = "g_";
      
      public static const SIM_THUMBNAIL_TYPE_PART:String = "p_";
      
      public static const SIM_THUMBNAIL_TYPE_HOUSEHOLD:String = "h_";
      
      public static const SIM_THUMBNAIL_TYPE_MATCHMAKING_PROFILE:String = "k_";
      
      public static const SIM_THUMBNAIL_TYPE_DYNASTY_MEMBER_PROFILE:String = "v_";
      
      public static const SIM_THUMBNAIL_POSTFIX_GALLERY:String = "_g";
      
      public static const SIM_THUMBNAIL_POSTFIX_MAIN_MENU:String = "_m";
      
      public static const SIM_THUMBNAIL_OUTFIT_EVERYDAY:String = "_e";
      
      public static const SIM_THUMBNAIL_OUTFIT_DEFAULT:String = "_c";
      
      public static const SIM_THUMBNAIL_DEFAULT:String = "DEF";
      
      public static const SIM_THUMBNAIL_BABY:String = "BABY";
      
      public static const STORE_THUMBNAIL_FEATURE:String = "_h";
      
      public static const STORE_THUMBNAIL_LANDSCAPE:String = "_l";
      
      public static const STORE_THUMBNAIL_PORTRAIT:String = "_p";
      
      public static const MAKER_ICON_DEFAULT_IMAGE_32:String = "0xa81c0d8a0eaa3e32";
      
      public static const MAKER_ICON_DEFAULT_IMAGE_64:String = "0xa81c128a0eaa464b";
      
      public static const MAKER_ICON_DEFAULT_IMAGE_128:String = "0x51efbb96eb4d0184";
      
      public static const MAKER_ICON_DEFAULT_UNOWNED:String = "0x5bba5bc7a489f103";
      
      public static const MAKER_ICON_DEFAULT_OWNED:String = "0xca75a588c600bbf3";
      
      public static const PACK_ICON_DEFAULT_IMAGE:String = "0xe89efa376c6285eb";
      
      public static const PACK_ICON_DEFAULT_UNOWNED:String = "0x1d5789db9f72702e";
      
      public static const PACK_ICON_DEFAULT_OWNED:String = "0x73339ffb0d6ffbb9";
      
      public static const MTX_BUNDLE_THUMBNAIL_TYPE_CARD:String = "card";
      
      public static const MISSING_SIM_URL:String = "0x97b44f47b80f9715";
      
      public static const URL_STORE_EMPTY_GROUP_ID:String = "0x0";
      
      public static const URL_STORE_FEATURE_PAGE_GROUP_ID:String = "0xe611b56389852655";
      
      public static const URL_STORE_BROWSE_PAGE_GROUP_ID:String = "0x18e6a196fd0dc7a7";
      
      public static const URL_STORE_COLLECTION_PAGE_GROUP_ID:String = "0x6077250145a5baa9";
      
      public static const URL_STORE_VIRTUAL_CURRENCY_PAGE_GROUP_ID:String = "0x5344200121d1d836";
      
      public static const URL_STORE_PACK_DETAIL_PAGE_GROUP_ID:String = "0xe153e44fa7e521d8";
      
      protected static const CATALOG_MAX_SIZE_SMALL:Number = 48;
      
      protected static const CATALOG_MAX_SIZE_MEDIUM:Number = 72;
      
      protected static const CATALOG_MAX_SIZE_LARGE:Number = 90;
      
      protected static const SIM_DEFAULT_POSE:String = "0";
      
      protected static const VIDEO_URL:String = "img://videos/channels/";
      
      protected static const THUMBNAIL_URL_OBJECT:String = "img://thumbs/objects/";
      
      protected static const THUMBNAIL_URL_WALL_PATTERNS:String = "img://thumbs/walls/";
      
      protected static const THUMBNAIL_URL_FLOOR_PATTERNS:String = "img://thumbs/floors/";
      
      protected static const THUMBNAIL_URL_TERRAIN_PAINT:String = "img://thumbs/lot_paints/";
      
      protected static const THUMBNAIL_URL_ROOF_PATTERNS:String = "img://thumbs/roof_pattern/";
      
      protected static const THUMBNAIL_URL_SIM:String = "img://thumbs/sims/";
      
      protected static const THUMBNAIL_URL_PART:String = "img://thumbs/exchange_part/";
      
      protected static const THUMBNAIL_URL_BABIES:String = "img://thumbs/babies/";
      
      protected static const THUMBNAIL_URL_CAS:String = "img://thumbs/cas/";
      
      protected static const THUMBNAIL_URL_AVATAR:String = "img://thumbs/avatars/";
      
      protected static const THUMBNAIL_URL_GALLERY:String = "img://thumbs/gallery/";
      
      protected static const THUMBNAIL_URL_BLUEPRINT:String = "img://thumbs/lot_blueprints/";
      
      protected static const THUMBNAIL_URL_ROOM:String = "img://thumbs/room_blueprints/";
      
      protected static const THUMBNAIL_URL_LOTS:String = "img://thumbs/worldmap_lots/";
      
      protected static const THUMBNAIL_URL_LOT_PREVIEW:String = "img://thumbs/lot_previews/";
      
      protected static const THUMBNAIL_URL_LOT_PURCHASE_PREVIEW:String = "img://thumbs/lot_purchase_previews/";
      
      protected static const THUMBNAIL_URL_PLEX_PREVIEW:String = "img://thumbs/plex_previews/";
      
      protected static const THUMBNAIL_URL_SCREENSHOT:String = "img://screenshots/";
      
      protected static const THUMBNAIL_URL_MEMORIES:String = "img://thumbs/memories/";
      
      protected static const THUMBNAIL_URL_MTX_BUNDLE:String = "img://bundle/";
      
      protected static const THUMBNAIL_URL_PREVIEW:String = "img://thumbs/previews/";
      
      protected static const THUMBNAIL_URL_WEB:String = "img://web/";
      
      protected static const THUMBNAIL_URL_STORE_BUNDLE_TYPE:String = "img://store/bundle/type/";
      
      protected static const THUMBNAIL_URL_STORE_BUNDLE_URL:String = "img://store/bundle/url/";
      
      protected static const THUMBNAIL_URL_STORE_BUNDLE_THUMBNAIL_URL:String = "img://store/bundle/thumbnail/";
      
      protected static const THUMBNAIL_URL_STORE_URL:String = "img://store/url/";
      
      protected static const THUMBNAIL_URL_SAVE_HOUSEHOLD:String = "img://thumbs/savegame_household/";
      
      protected static const IMAGE_SIZE_32:Number = 32 + 16;
      
      protected static const IMAGE_SIZE_48:Number = 48 + 16;
      
      protected static const IMAGE_SIZE_64:Number = 64 + 16;
      
      protected static const IMAGE_SIZE_70:Number = 70 + 16;
      
      protected static const IMAGE_SIZE_78:Number = 78 + 16;
      
      protected static const IMAGE_SIZE_90:Number = 90 + 16;
      
      protected static const IMAGE_SIZE_96:Number = 96 + 16;
      
      protected static const IMAGE_SIZE_128:Number = 128 + 16;
      
      protected static const IMAGE_SIZE_256:Number = 256 + 16;
      
      protected static const IMAGE_SIZE_300:Number = 300 + 16;
      
      protected static const PHOTO_URL:String = "img://photo/";
      
      public function ImageUtils()
      {
         super();
      }
      
      public static function LoadObjectThumbnail(param1:IImageContainer, param2:String, param3:String = null, param4:String = null, param5:Object = null) : void
      {
         var _loc6_:String = CreateObjectImageUrl(param2,param3 || CalculateCatalogThumbnailSize(param1),param4,param5);
         param1.LoadImage(_loc6_);
      }
      
      public static function LoadCatalogThumbnail(param1:IImageContainer, param2:ResourceKey, param3:String = null) : void
      {
         var _loc4_:String = CreateCatalogThumbnailUrl(param2,param3 || CalculateCatalogThumbnailSize(param1));
         param1.LoadImage(_loc4_);
      }
      
      public static function LoadLotPurchasePreviewThumbnail(param1:IImageContainer, param2:String, param3:String = null, param4:int = 0) : void
      {
         var _loc5_:String = param2;
         if(Boolean(param3) && param3.length > 0)
         {
            _loc5_ += "_" + param3;
         }
         LoadThumbnail(THUMBNAIL_URL_LOT_PURCHASE_PREVIEW,param1,_loc5_,"_" + param4.toString());
      }
      
      public static function LoadLotPreviewThumbnail(param1:IImageContainer, param2:String, param3:String = null, param4:int = 0) : void
      {
         var _loc5_:String = param2;
         if(Boolean(param3) && param3.length > 0)
         {
            _loc5_ += "_" + param3;
         }
         LoadThumbnail(THUMBNAIL_URL_LOT_PREVIEW,param1,_loc5_,"_" + param4.toString());
      }
      
      public static function LoadPlexPreviewThumbnail(param1:IImageContainer, param2:String, param3:String, param4:int = 0) : void
      {
         var _loc5_:String = param2;
         if(Boolean(param3) && param3.length > 0)
         {
            _loc5_ += "_" + param3;
         }
         LoadThumbnail(THUMBNAIL_URL_PLEX_PREVIEW,param1,_loc5_,"_" + param4.toString());
      }
      
      public static function GetLotThumbnailUrl(param1:String, param2:String, param3:String = null) : String
      {
         var _loc4_:String = param1;
         if(Boolean(param3) && param3.length > 0)
         {
            _loc4_ += "_" + param3;
         }
         var _loc5_:String = param2 ? "_" + param2 : "";
         return THUMBNAIL_URL_LOTS + _loc4_ + _loc5_;
      }
      
      public static function LoadLotThumbnail(param1:IImageContainer, param2:String, param3:String, param4:String = null) : void
      {
         param1.LoadImage(GetLotThumbnailUrl(param2,param3,param4));
      }
      
      public static function LoadBlueprintThumbnail(param1:IImageContainer, param2:String, param3:int, param4:String, param5:Boolean = false) : Boolean
      {
         var _loc6_:String = GetBlueprintThumbnailUrl(param1,param2,param3,param4);
         if(!param5 && param1.resourceId == _loc6_)
         {
            return false;
         }
         param1.LoadImage(_loc6_,param5);
         return true;
      }
      
      public static function GetBlueprintThumbnailUrl(param1:IImageContainer, param2:String, param3:int = 0, param4:String = null) : String
      {
         if(!param4)
         {
            param4 = CalculateSimThumbnailSize(param1);
         }
         return THUMBNAIL_URL_BLUEPRINT + param2 + "_" + param3 + param4;
      }
      
      public static function LoadRoomThumbnail(param1:IImageContainer, param2:String, param3:int, param4:String, param5:Boolean = false) : Boolean
      {
         var _loc6_:String = GetRoomThumbnailUrl(param1,param2,param3,param4);
         if(!param5 && param1.resourceId == _loc6_)
         {
            return false;
         }
         param1.LoadImage(_loc6_,param5);
         return true;
      }
      
      public static function GetRoomThumbnailUrl(param1:IImageContainer, param2:String, param3:int = 0, param4:String = null) : String
      {
         if(!param4)
         {
            param4 = CalculateSimThumbnailSize(param1);
         }
         return THUMBNAIL_URL_ROOM + param2 + "_" + param3 + param4;
      }
      
      public static function GetBodyPartThumbnailUrl(param1:IImageContainer, param2:String, param3:int, param4:int = 0, param5:String = null) : String
      {
         if(!param5)
         {
            param5 = CalculateSimThumbnailSize(param1);
         }
         return CreateBodyPartImageUrl("p",param2,param3,param5,param4);
      }
      
      public static function GetBodyPartLocalThumbnailUrl(param1:IImageContainer, param2:String, param3:int = 0, param4:String = null) : String
      {
         if(!param4)
         {
            param4 = CalculateSimThumbnailSize(param1);
         }
         return CreateBodyPartLocalImageUrl(ImageUtils.SIM_THUMBNAIL_TYPE_GALLERY,param2,param4,param3);
      }
      
      public static function LoadGalleryThumbnail(param1:IImageContainer, param2:String, param3:String, param4:String, param5:int = -1) : Boolean
      {
         var _loc6_:String = GetGalleryThumbnailUrl(param1,param2,param3,param4,param5);
         if(param1.resourceId == _loc6_)
         {
            return false;
         }
         param1.LoadImage(_loc6_);
         return true;
      }
      
      public static function GetGalleryThumbnailUrl(param1:IImageContainer, param2:String, param3:String, param4:String = null, param5:int = -1) : String
      {
         if(!param4)
         {
            param4 = CalculateSimThumbnailSize(param1);
         }
         var _loc6_:String = THUMBNAIL_URL_GALLERY + param3 + param4;
         if(param5 != -1)
         {
            _loc6_ += "_" + param5;
         }
         return _loc6_ + ("x" + param2);
      }
      
      public static function LoadSimThumbnail(param1:IImageContainer, param2:String, param3:String, param4:String = null, param5:int = -1, param6:Boolean = true, param7:String = null, param8:String = null, param9:Boolean = false, param10:Boolean = false) : Boolean
      {
         var _loc12_:Object = null;
         if(!param2)
         {
            return false;
         }
         if(param10)
         {
            _loc12_ = CommunicationManager.CallGameService("GetSimAge",param2);
            if(SimAgeTypes.IsBaby(_loc12_["age"]))
            {
               return ImageUtils.LoadBabyThumbnail(param1,param2,param4,param6);
            }
         }
         if(!param4)
         {
            param4 = CalculateSimThumbnailSize(param1,param3);
         }
         var _loc11_:String = CreateSimImageUrl(param3,param2,param4,param5);
         if(!param6 && param1.resourceId == _loc11_)
         {
            return false;
         }
         if(param7)
         {
            _loc11_ += param7;
         }
         else
         {
            _loc11_ += SIM_THUMBNAIL_OUTFIT_DEFAULT;
         }
         if(param8)
         {
            _loc11_ += "_" + param8;
         }
         if(param9)
         {
            _loc11_ += "_o";
         }
         param1.LoadImage(_loc11_,param6);
         return true;
      }
      
      public static function LoadPartThumbnail(param1:IImageContainer, param2:String, param3:int, param4:String, param5:String = null, param6:int = 0, param7:Boolean = true) : Boolean
      {
         if(!param4)
         {
            return false;
         }
         var _loc8_:String = CreateBodyPartImageUrl(param2,param4,param3,param5,param6);
         if(!param7 && param1.resourceId == _loc8_)
         {
            return false;
         }
         param1.LoadImage(_loc8_,param7);
         return true;
      }
      
      public static function LoadPartLocalThumbnail(param1:IImageContainer, param2:String, param3:String, param4:String = null, param5:int = 0, param6:Boolean = true) : Boolean
      {
         var _loc7_:String = CreateBodyPartLocalImageUrl(param2,param3,param4,param5);
         if(!param6 && param1.resourceId == _loc7_)
         {
            return false;
         }
         param1.LoadImage(_loc7_,param6);
         return true;
      }
      
      public static function LoadLocalPackIcon(param1:IImageContainer, param2:int, param3:String = "") : void
      {
         var _loc4_:PackFilterData = GameContent.GetPackData(param2);
         if((Boolean(_loc4_)) && _loc4_.packType == GameContent.PACKTYPE_UGC)
         {
            param1.LoadImage(ImageUtils.MAKER_ICON_DEFAULT_IMAGE_32);
         }
         else if(!_loc4_.icon)
         {
            param1.LoadImage(ImageUtils.PACK_ICON_DEFAULT_IMAGE);
         }
         else
         {
            if(!param3 || param3 == "")
            {
               param3 = SharedIcons.SIZE_32;
            }
            param1.LoadImage(SharedIcons.GetPackIcon(param2,param3));
         }
      }
      
      public static function LoadBabyThumbnail(param1:IImageContainer, param2:String, param3:String = null, param4:Boolean = true) : Boolean
      {
         if(!param3)
         {
            param3 = CalculateSimThumbnailSize(param1,SIM_THUMBNAIL_BABY);
         }
         var _loc5_:String = CreateBabyImageUrl(param2,param3);
         if(!param4 && param1.resourceId == _loc5_)
         {
            return false;
         }
         param1.LoadImage(_loc5_,param4);
         return true;
      }
      
      public static function LoadHouseholdThumbnail(param1:IImageContainer, param2:String, param3:String, param4:Boolean = false, param5:String = null) : Boolean
      {
         var _loc6_:String = GetHouseholdThumbnailUrl(param1,param2,param3,param5);
         if(!param4 && param1.resourceId == _loc6_)
         {
            return false;
         }
         param1.LoadImage(_loc6_,param4);
         return true;
      }
      
      public static function GetHouseholdThumbnailUrl(param1:IImageContainer, param2:String, param3:String = null, param4:String = null) : String
      {
         if(!param3)
         {
            param3 = CalculateSimThumbnailSize(param1);
         }
         return THUMBNAIL_URL_SIM + SIM_THUMBNAIL_TYPE_HOUSEHOLD + param2 + param3 + (param4 ? param4 : "");
      }
      
      public static function LoadScreenshotImage(param1:IImageContainer, param2:String, param3:uint = 0, param4:uint = 0, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc7_:String = THUMBNAIL_URL_SCREENSHOT + param2;
         if(param3 != 0 && param4 != 0)
         {
            _loc7_ += "_" + param3 + "x" + param4;
            if(param5)
            {
               _loc7_ += "_n";
            }
         }
         param1.LoadImage(_loc7_,param6);
      }
      
      public static function LoadPhotoboothImage(param1:IImageContainer, param2:String, param3:String) : void
      {
         var _loc4_:String = THUMBNAIL_URL_SIM + SIM_THUMBNAIL_TYPE_PHOTOBOOTH_FAMILY + param2 + param3;
         param1.LoadImage(_loc4_);
      }
      
      public static function LoadPhotoImage(param1:IImageContainer, param2:ResourceKey, param3:Boolean = false, param4:Number = 256) : void
      {
         var _loc5_:uint = param2.group;
         var _loc6_:String = param2.instance;
         var _loc7_:uint = param2.type;
         var _loc8_:String = PHOTO_URL + _loc6_;
         if(param3)
         {
            _loc8_ += "_p";
         }
         if(param4 != 0)
         {
            _loc8_ += "_d" + param4;
         }
         _loc8_ += "_g" + _loc5_;
         _loc8_ = _loc8_ + ("_t" + _loc7_);
         param1.LoadImage(_loc8_);
      }
      
      public static function LoadMTXBundleImage(param1:IImageContainer, param2:String, param3:String = null) : void
      {
         var _loc4_:String = GenerateUrlWithBundleId(param2,param3);
         param1.LoadImage(_loc4_);
      }
      
      public static function GenerateUrlWithBundleId(param1:String, param2:String = null) : String
      {
         var _loc3_:String = THUMBNAIL_URL_MTX_BUNDLE + param1 + "_";
         if(param2)
         {
            _loc3_ += param2;
         }
         return _loc3_;
      }
      
      public static function LoadObjectPreviewImage(param1:IImageContainer, param2:String, param3:String = null, param4:uint = 0) : void
      {
         if(!param3)
         {
            param3 = CalculateSimThumbnailSize(param1);
         }
         var _loc5_:String = THUMBNAIL_URL_PREVIEW + param2 + param3;
         if(param4)
         {
            _loc5_ += "_0x" + param4.toString(16);
         }
         param1.LoadImage(_loc5_);
      }
      
      public static function LoadWebImage(param1:IImageContainer, param2:String, param3:Number = 1.7976931348623157e+308, param4:Number = 1.7976931348623157e+308) : void
      {
         var _loc5_:Number = param3 != Number.MAX_VALUE ? param3 : param1.imageRegion.width;
         var _loc6_:Number = param4 != Number.MAX_VALUE ? param4 : param1.imageRegion.height;
         var _loc7_:String = GetWebImageUrl(param2,_loc5_,_loc6_);
         param1.LoadImage(_loc7_);
      }
      
      public static function GetWebImageUrl(param1:String, param2:Number, param3:Number) : String
      {
         return THUMBNAIL_URL_WEB + param1 + "?size=" + param2 + "x" + param3;
      }
      
      public static function GetStoreBundleImageByTypeUrl(param1:String, param2:String, param3:Number, param4:Number, param5:String) : String
      {
         return THUMBNAIL_URL_STORE_BUNDLE_TYPE + param3 + "_" + param4 + "_" + param1 + "_" + param5 + param2;
      }
      
      public static function LoadStoreBundleImageByType(param1:IImageContainer, param2:String, param3:String, param4:Number = 1.7976931348623157e+308, param5:Number = 1.7976931348623157e+308, param6:String = "0x0") : void
      {
         var _loc7_:Number = param4 != Number.MAX_VALUE ? param4 : param1.imageRegion.width;
         var _loc8_:Number = param5 != Number.MAX_VALUE ? param5 : param1.imageRegion.height;
         var _loc9_:String = GetStoreBundleImageByTypeUrl(param2,param3,_loc7_,_loc8_,param6);
         param1.LoadImage(_loc9_);
      }
      
      public static function GetStoreBundleImageUrl(param1:String, param2:String, param3:Number, param4:Number, param5:String) : String
      {
         return THUMBNAIL_URL_STORE_BUNDLE_URL + param3 + "_" + param4 + "_" + param1 + "_" + param5 + "_" + param2;
      }
      
      public static function LoadStoreBundleImage(param1:IImageContainer, param2:String, param3:String, param4:Number = 1.7976931348623157e+308, param5:Number = 1.7976931348623157e+308, param6:String = "0x0") : void
      {
         var _loc7_:Number = param4 != Number.MAX_VALUE ? param4 : param1.imageRegion.width;
         var _loc8_:Number = param5 != Number.MAX_VALUE ? param5 : param1.imageRegion.height;
         var _loc9_:String = GetStoreBundleImageUrl(param2,param3,_loc7_,_loc8_,param6);
         param1.LoadImage(_loc9_);
      }
      
      public static function GetStoreBundleThumbnailUrl(param1:String, param2:String, param3:Number, param4:Number, param5:String) : String
      {
         return THUMBNAIL_URL_STORE_BUNDLE_THUMBNAIL_URL + param3 + "_" + param4 + "_" + param1 + "_" + param5 + "_" + param2;
      }
      
      public static function LoadStoreBundleThumbnailImage(param1:IImageContainer, param2:String, param3:String, param4:Number = 1.7976931348623157e+308, param5:Number = 1.7976931348623157e+308, param6:String = "0x0") : void
      {
         var _loc7_:Number = param4 != Number.MAX_VALUE ? param4 : param1.imageRegion.width;
         var _loc8_:Number = param5 != Number.MAX_VALUE ? param5 : param1.imageRegion.height;
         var _loc9_:String = GetStoreBundleThumbnailUrl(param2,param3,_loc7_,_loc8_,param6);
         param1.LoadImage(_loc9_);
      }
      
      public static function GetStoreImageUrl(param1:String, param2:Number, param3:Number, param4:String) : String
      {
         return THUMBNAIL_URL_STORE_URL + param2 + "_" + param3 + "_" + param4 + "_" + param1;
      }
      
      public static function LoadStoreImage(param1:IImageContainer, param2:String, param3:Number = 1.7976931348623157e+308, param4:Number = 1.7976931348623157e+308, param5:String = "0x0") : void
      {
         var _loc6_:Number = param3 != Number.MAX_VALUE ? param3 : param1.imageRegion.width;
         var _loc7_:Number = param4 != Number.MAX_VALUE ? param4 : param1.imageRegion.height;
         var _loc8_:String = GetStoreImageUrl(param2,_loc6_,_loc7_,param5);
         param1.LoadImage(_loc8_);
      }
      
      public static function LoadSaveGameHouseholdImage(param1:IImageContainer, param2:uint, param3:String) : void
      {
         var _loc4_:String = THUMBNAIL_URL_SAVE_HOUSEHOLD + param2 + param3;
         param1.LoadImage(_loc4_);
      }
      
      public static function IsBadImage(param1:String) : Boolean
      {
         return param1 == null || param1.length == 0 || param1 == INVALID_IMAGE;
      }
      
      public static function LoadFromManagerObjectId(param1:IImageContainer, param2:ManagerObjectId, param3:String) : Boolean
      {
         switch(param2.manager_id)
         {
            case ManagerObjectId.MGR_OBJECT:
               LoadObjectThumbnail(param1,param2.object_id,param3);
               break;
            case ManagerObjectId.MGR_SIM_INFO:
               LoadSimThumbnail(param1,param2.object_id,SIM_THUMBNAIL_TYPE_FACE,param3);
               break;
            default:
               return false;
         }
         return true;
      }
      
      public static function LoadFromIconInfo(param1:IImageContainer, param2:IconInfo, param3:String = null, param4:Boolean = false) : Boolean
      {
         var _loc7_:ManagerObjectId = null;
         var _loc5_:String = param3;
         if(!_loc5_)
         {
            _loc7_ = param2.icon_object;
            if((Boolean(_loc7_)) && _loc7_.manager_id == ManagerObjectId.MGR_SIM_INFO)
            {
               _loc5_ = CalculateSimThumbnailSize(param1);
            }
            else
            {
               _loc5_ = CalculateCatalogThumbnailSize(param1);
            }
         }
         var _loc6_:String = CreateIconInfoImageUrl(param2,_loc5_,param4);
         if(IsBadImage(_loc6_))
         {
            return false;
         }
         param1.LoadImage(_loc6_);
         return true;
      }
      
      public static function LoadVideo(param1:Number, param2:IImageContainer, param3:Number, param4:Number) : void
      {
         param2.LoadImage(VIDEO_URL + param1 + "_" + param3 + "x" + param4);
      }
      
      public static function CreateSimImageUrl(param1:String, param2:String, param3:String, param4:int = -1) : String
      {
         var _loc5_:String = param4 < 0 ? SIM_DEFAULT_POSE : param4.toString();
         return THUMBNAIL_URL_SIM + param1 + param2 + param3 + "_" + _loc5_;
      }
      
      public static function CreateBodyPartImageUrl(param1:String, param2:String, param3:int, param4:String, param5:int) : String
      {
         return THUMBNAIL_URL_PART + param1 + param2 + "_" + param3 + param4 + "_" + param5;
      }
      
      public static function CreateBodyPartLocalImageUrl(param1:String, param2:String, param3:String, param4:int) : String
      {
         return THUMBNAIL_URL_PART + param1 + param2 + param3 + "_" + param4;
      }
      
      public static function CreateBabyImageUrl(param1:String, param2:String) : String
      {
         return THUMBNAIL_URL_BABIES + param1 + param2;
      }
      
      public static function CreateObjectImageUrl(param1:String, param2:String, param3:String = null, param4:Object = null) : String
      {
         return THUMBNAIL_URL_OBJECT + param1 + param2 + (Boolean(param3) && Boolean(param4) ? param3 + param4.toString() : "");
      }
      
      public static function CreateCatalogThumbnailUrl(param1:ResourceKey, param2:String) : String
      {
         var _loc3_:String = THUMBNAIL_URL_OBJECT;
         switch(param1.type)
         {
            case CatalogResourceTypes.WALL_PATTERN:
               _loc3_ = THUMBNAIL_URL_WALL_PATTERNS;
               break;
            case CatalogResourceTypes.FLOOR_PATTERN:
               _loc3_ = THUMBNAIL_URL_FLOOR_PATTERNS;
               break;
            case CatalogResourceTypes.ROOF_PATTERN:
               _loc3_ = THUMBNAIL_URL_ROOF_PATTERNS;
               break;
            case CatalogResourceTypes.TERRAIN_PAINT:
               _loc3_ = THUMBNAIL_URL_TERRAIN_PAINT;
         }
         return _loc3_ + param1.instance + param2;
      }
      
      public static function CreatePlayerImageUrl(param1:String, param2:String) : String
      {
         return THUMBNAIL_URL_AVATAR + param2 + param1;
      }
      
      public static function CreateMemoryImageUrl(param1:String, param2:String) : String
      {
         return THUMBNAIL_URL_MEMORIES + param1 + param2;
      }
      
      public static function CreateResourceImageUrl(param1:String) : String
      {
         return "img://" + param1;
      }
      
      public static function CreateIconInfoImageUrl(param1:IconInfo, param2:String, param3:Boolean) : String
      {
         var _loc4_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:AgeUpdate = null;
         var _loc5_:ManagerObjectId = param1.icon_object;
         var _loc6_:DefinitionGeoPair = param1.icon_object_def;
         if(!IsBadImage(param1.icon.instance))
         {
            return CreateResourceImageUrl(param1.icon.instance);
         }
         if(Boolean(_loc5_) && _loc5_.manager_id == ManagerObjectId.MGR_OBJECT)
         {
            _loc4_ = THUMBNAIL_URL_OBJECT;
            _loc4_ = _loc4_ + (_loc5_.object_id + param2);
            if(param1.texture_id)
            {
               if(param1.canvas_state_type == IconInfo.CANVAS_STATE_PAINTING_CROSSSTITCH)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_PAINTING + param1.texture_id;
               }
               else if(param1.canvas_state_type == IconInfo.CANVAS_STATE_PUZZLE)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_PUZZLE + param1.texture_id;
               }
            }
            if(param1.texture_effect)
            {
               _loc4_ += OBJECT_THUMBNAIL_TYPE_CANVAS_EFFECT + param1.texture_effect;
            }
            if(_loc6_)
            {
               if(_loc6_.GeoState)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_GEO_STATE + _loc6_.GeoState;
               }
               if(_loc6_.MaterialState)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_MATERIAL_STATE + _loc6_.MaterialState;
               }
            }
            if(param1.multicolor != null)
            {
               _loc4_ += OBJECT_THUMBNAIL_TYPE_MULTICOLOR_SHIFT;
               _loc7_ = 0;
               while(_loc7_ < param1.multicolor.length)
               {
                  _loc8_ = param1.multicolor[_loc7_];
                  _loc9_ = new Array(Math.floor(_loc8_.x * 255),Math.floor(_loc8_.y * 255),Math.floor(_loc8_.z * 255));
                  _loc4_ += _loc7_ + 1 + ":" + _loc9_.join("-");
                  _loc7_++;
               }
            }
            return _loc4_;
         }
         if(Boolean(_loc6_) && Boolean(_loc6_.definition_id))
         {
            _loc4_ = THUMBNAIL_URL_OBJECT;
            _loc4_ = _loc4_ + (_loc6_.definition_id + param2);
            if(param1.texture_id)
            {
               if(param1.canvas_state_type == IconInfo.CANVAS_STATE_PAINTING_CROSSSTITCH)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_PAINTING + param1.texture_id;
               }
               else if(param1.canvas_state_type == IconInfo.CANVAS_STATE_PUZZLE)
               {
                  _loc4_ += OBJECT_THUMBNAIL_TYPE_PUZZLE + param1.texture_id;
               }
            }
            if(param1.texture_effect)
            {
               _loc4_ += OBJECT_THUMBNAIL_TYPE_CANVAS_EFFECT + param1.texture_effect;
            }
            if(_loc6_.GeoState)
            {
               _loc4_ += OBJECT_THUMBNAIL_TYPE_GEO_STATE + _loc6_.GeoState;
            }
            if(_loc6_.MaterialState)
            {
               _loc4_ += OBJECT_THUMBNAIL_TYPE_MATERIAL_STATE + _loc6_.MaterialState;
            }
            return _loc4_;
         }
         if(Boolean(_loc5_) && _loc5_.manager_id == ManagerObjectId.MGR_SIM_INFO)
         {
            if(param3)
            {
               _loc10_ = new AgeUpdate(CommunicationManager.CallGameService("GetSimAge",_loc5_.object_id));
               if(SimAgeTypes.IsBaby(_loc10_.age))
               {
                  return CreateBabyImageUrl(_loc5_.object_id,param2);
               }
            }
            return CreateSimImageUrl(SIM_THUMBNAIL_TYPE_FACE,_loc5_.object_id,param2);
         }
         return null;
      }
      
      public static function CreateOutfitImageUrl(param1:Boolean, param2:String, param3:String, param4:int, param5:int) : String
      {
         return THUMBNAIL_URL_SIM + (param1 ? SIM_THUMBNAIL_TYPE_MANNEQUIN : SIM_THUMBNAIL_TYPE_WHOLEBODY) + param2 + param3 + "_" + param4 + "_" + param5;
      }
      
      public static function QueryThumbnailAlpha(param1:IImageContainer, param2:Number, param3:Number) : Number
      {
         var _loc4_:Bitmap = param1.GetLoadedImage() as Bitmap;
         if(!_loc4_)
         {
            return -1;
         }
         return Number(CommunicationManager.CallGameService("QueryThumbnailAlpha",{
            "thumbnail":_loc4_,
            "x":Math.round(param2),
            "y":Math.round(param3)
         }));
      }
      
      protected static function LoadThumbnail(param1:String, param2:IImageContainer, param3:String, param4:String, param5:String = null) : void
      {
         var _loc6_:String = param5 ? "_" + param5 : "";
         var _loc7_:String = param1 + param3 + _loc6_ + param4;
         param2.LoadImage(_loc7_);
      }
      
      protected static function CalculateSimThumbnailSize(param1:IImageContainer, param2:String = "DEF") : String
      {
         var _loc3_:Number = GetRegionWidth(param1);
         if(!sSimThumbnailSizeMaps)
         {
            BuildSimThumbnailSizeMaps();
         }
         var _loc4_:Object = sSimThumbnailSizeMaps[param2];
         if(!_loc4_)
         {
            param2 = SIM_THUMBNAIL_DEFAULT;
            _loc4_ = sSimThumbnailSizeMaps[param2];
         }
         if(_loc3_ <= _loc4_[THUMBNAIL_SIZE_SMALL])
         {
            return THUMBNAIL_SIZE_SMALL;
         }
         if(_loc3_ <= _loc4_[THUMBNAIL_SIZE_MEDIUM])
         {
            return THUMBNAIL_SIZE_MEDIUM;
         }
         if(_loc3_ <= _loc4_[THUMBNAIL_SIZE_LARGE])
         {
            return THUMBNAIL_SIZE_LARGE;
         }
         return THUMBNAIL_SIZE_XLARGE;
      }
      
      public static function CalculateCatalogThumbnailSize(param1:IImageContainer) : String
      {
         var _loc2_:Number = GetRegionWidth(param1);
         if(_loc2_ <= CATALOG_MAX_SIZE_SMALL)
         {
            return THUMBNAIL_SIZE_SMALL;
         }
         if(_loc2_ <= CATALOG_MAX_SIZE_MEDIUM)
         {
            return THUMBNAIL_SIZE_MEDIUM;
         }
         if(_loc2_ <= CATALOG_MAX_SIZE_LARGE)
         {
            return THUMBNAIL_SIZE_LARGE;
         }
         return THUMBNAIL_SIZE_XLARGE;
      }
      
      protected static function GetRegionWidth(param1:IImageContainer) : Number
      {
         var _loc2_:Rectangle = param1.imageRegion;
         if(_loc2_)
         {
            return _loc2_.width;
         }
         return 0;
      }
      
      protected static function BuildSimThumbnailSizeMaps() : void
      {
         var _loc1_:Object = null;
         sSimThumbnailSizeMaps = new Object();
         _loc1_ = sSimThumbnailSizeMaps[SIM_THUMBNAIL_DEFAULT] = new Object();
         _loc1_[THUMBNAIL_SIZE_SMALL] = IMAGE_SIZE_64;
         _loc1_[THUMBNAIL_SIZE_MEDIUM] = IMAGE_SIZE_128;
         _loc1_[THUMBNAIL_SIZE_LARGE] = IMAGE_SIZE_256;
         _loc1_ = sSimThumbnailSizeMaps[SIM_THUMBNAIL_TYPE_FACE] = new Object();
         _loc1_[THUMBNAIL_SIZE_SMALL] = IMAGE_SIZE_48;
         _loc1_[THUMBNAIL_SIZE_MEDIUM] = IMAGE_SIZE_96;
         _loc1_[THUMBNAIL_SIZE_LARGE] = IMAGE_SIZE_256;
         _loc1_ = sSimThumbnailSizeMaps[SIM_THUMBNAIL_TYPE_CAS_FACE] = new Object();
         _loc1_[THUMBNAIL_SIZE_SMALL] = IMAGE_SIZE_32;
         _loc1_[THUMBNAIL_SIZE_MEDIUM] = IMAGE_SIZE_70;
         _loc1_[THUMBNAIL_SIZE_LARGE] = IMAGE_SIZE_256;
         _loc1_ = sSimThumbnailSizeMaps[SIM_THUMBNAIL_TYPE_GALLERY] = new Object();
         _loc1_[THUMBNAIL_SIZE_SMALL] = IMAGE_SIZE_32;
         _loc1_[THUMBNAIL_SIZE_MEDIUM] = IMAGE_SIZE_90;
         _loc1_[THUMBNAIL_SIZE_LARGE] = IMAGE_SIZE_300;
         _loc1_ = sSimThumbnailSizeMaps[SIM_THUMBNAIL_BABY] = new Object();
         _loc1_[THUMBNAIL_SIZE_SMALL] = IMAGE_SIZE_32;
         _loc1_[THUMBNAIL_SIZE_MEDIUM] = IMAGE_SIZE_64;
         _loc1_[THUMBNAIL_SIZE_LARGE] = IMAGE_SIZE_78;
      }
   }
}

