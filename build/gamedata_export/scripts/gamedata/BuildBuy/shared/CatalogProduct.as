package gamedata.BuildBuy.shared
{
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.BuildBuy.constants.PlacementFlags;
   import gamedata.BuildBuy.constants.ProductObjectFlags;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.objects.ObjectMetadata;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   import widgets.BuildBuy.constants.ProductStateUsage;
   
   public class CatalogProduct extends OlympusObject
   {
      
      public static const GAMEPLAY_UNLOCK_NONE:int = 0;
      
      public static const GAMEPLAY_UNLOCK_LOCKED:int = 1;
      
      public static const GAMEPLAY_UNLOCK_UNLOCKED:int = 2;
      
      public static const WALL_HEIGHT_REQUIRED_SHORT:int = 3;
      
      public static const WALL_HEIGHT_REQUIRED_MEDIUM:int = 4;
      
      public static const WALL_HEIGHT_REQUIRED_TALL:int = 5;
      
      public static const SWATCH_COLOR_COUNT:int = 3;
      
      public var resourceKey:ResourceKey;
      
      public var image:String;
      
      public var price:Number = 0;
      
      public var name:LocKey;
      
      public var desc:LocKey;
      
      public var customName:String;
      
      public var customDesc:String;
      
      public var creatorName:String;
      
      public var devFlags:uint;
      
      public var variationCount:uint;
      
      public var packId:int;
      
      public var is_modded:Boolean = false;
      
      public var mtxState:int;
      
      public var gameplayInfo:Array;
      
      public var gameplayUnlockState:uint;
      
      public var gameplayLockedDescription:LocKey;
      
      public var gameplayUnlockedDescription:LocKey;
      
      public var wallHeightRequired:int;
      
      public var stateUsage:int;
      
      public var stateIndex:uint = 0;
      
      public var secondaryImage:String;
      
      public var count:uint;
      
      public var isNew:Boolean;
      
      public var objectId:String;
      
      public var metadata:ObjectMetadata;
      
      public var placementFlagsLow:uint;
      
      public var placementFlagsHigh:uint;
      
      public var iconInfo:IconInfo;
      
      public var sculptType:int;
      
      public var pondType:int;
      
      public var productObjectFlags:uint;
      
      public var heightRangeSmall:Boolean;
      
      public function CatalogProduct(param1:Object)
      {
         super(param1);
      }
      
      public static function ClearSelection() : void
      {
         CommunicationManager.CallGameService("BBCancelUserTool",null,true);
      }
      
      public static function SelectProductByKey(param1:ResourceKey, param2:Array = null, param3:ResourceKey = null, param4:int = 0, param5:int = 2, param6:int = 0, param7:Number = NaN) : void
      {
         var _loc8_:int = CommunicationManager.CallUIService("GetBBNavigationMode") as int;
         CommunicationManager.CallGameService("BBSelectProduct",{
            "resourceKey":param1.ToObject(),
            "sourceResourceKey":(param3 ? param3.ToObject() : null),
            "categoryTags":param2,
            "navigationMode":_loc8_,
            "placementMode":param4,
            "floorPlacementLocation":param5,
            "stateIndex":param6,
            "scaleOverride":param7,
            "useScaleOverride":!isNaN(param7)
         });
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.resourceKey = new ResourceKey(param1.resourceKey);
         this.image = param1.image;
         this.name = new LocKey(param1.name);
         this.desc = new LocKey(param1.desc);
         this.devFlags = param1.devFlags;
         this.stateUsage = param1.stateUsage;
         this.variationCount = param1.variationCount;
         this.packId = param1.packId;
         this.is_modded = param1.is_modded;
         this.mtxState = param1.mtxState;
         this.price = param1.price;
         this.gameplayUnlockState = param1.gameplayUnlockState;
         this.gameplayInfo = new Array();
         ConstructArrayFromArray(this.gameplayInfo,param1.gameplayInfo,ProductGameplayInfo);
         if("secondaryImage" in param1)
         {
            this.secondaryImage = param1.secondaryImage;
         }
         this.wallHeightRequired = param1["wallHeightRequired"];
         this.placementFlagsLow = param1["placementFlagsLow"];
         this.placementFlagsHigh = param1["placementFlagsHigh"];
         this.count = param1["count"];
         this.productObjectFlags = param1["productObjectFlags"];
         this.sculptType = param1["sculptType"];
         this.pondType = param1["pondType"];
         this.heightRangeSmall = param1["heightRangeSmall"];
         this.customName = param1["customName"];
         this.customDesc = param1["customDesc"];
         this.gameplayLockedDescription = LocKey.GetValidatedLocKey(param1["gameplayLockedDescription"]);
         this.gameplayUnlockedDescription = LocKey.GetValidatedLocKey(param1["gameplayUnlockedDescription"]);
         this.creatorName = param1["creatorName"];
         this.stateIndex = param1["stateIndex"];
         this.isNew = param1["isNew"];
         this.objectId = param1["objectId"];
         if("metadata" in param1 && ("custom_name" in param1.metadata || "recipe_name" in param1.metadata))
         {
            this.metadata = new ObjectMetadata(param1.metadata);
         }
         if("iconInfo" in param1)
         {
            this.iconInfo = new IconInfo(param1.iconInfo);
         }
      }
      
      public function get Name() : String
      {
         var _loc1_:Object = null;
         if(this.customName)
         {
            return this.customName;
         }
         if(Boolean(this.name.tokens) && Boolean(this.name.tokens.length))
         {
            _loc1_ = this.name.tokens[0];
            if(_loc1_.catalog_name_key)
            {
               return this.name.toString();
            }
         }
         return "";
      }
      
      public function get Description() : String
      {
         var _loc1_:Object = null;
         if(this.customDesc)
         {
            return this.customDesc;
         }
         if(Boolean(this.desc.tokens) && Boolean(this.desc.tokens.length))
         {
            _loc1_ = this.desc.tokens[0];
            if(_loc1_.catalog_description_key)
            {
               return this.desc.toString();
            }
         }
         return "";
      }
      
      public function Select(param1:Array, param2:ResourceKey = null, param3:int = 0, param4:int = 2, param5:int = 0, param6:Number = NaN) : void
      {
         SelectProductByKey(this.resourceKey,param1,param2,param3,param4,param5,param6);
         CommunicationManager.SendUIMessage("BBProductSelected",{"product":this});
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null) : void
      {
         if(!ImageUtils.IsBadImage(this.image))
         {
            param1.LoadImage(this.image);
            return;
         }
         switch(this.resourceKey.type)
         {
            case CatalogResourceTypes.WALL_PATTERN:
            case CatalogResourceTypes.FLOOR_PATTERN:
            case CatalogResourceTypes.ROOF_PATTERN:
            case CatalogResourceTypes.TERRAIN_PAINT:
               ImageUtils.LoadCatalogThumbnail(param1,this.resourceKey,param2);
               break;
            case CatalogResourceTypes.SHARED_ROOM:
               if(param2 == null)
               {
                  param2 = ImageUtils.THUMBNAIL_SIZE_LARGE;
               }
               ImageUtils.LoadRoomThumbnail(param1,this.resourceKey.instance,0,param2);
               break;
            default:
               if(this.HasStateUsageVariants() && this.stateIndex != 0)
               {
                  ImageUtils.LoadObjectThumbnail(param1,this.resourceKey.instance,param2,ImageUtils.OBJECT_THUMBNAIL_TYPE_STATE_INDEX,this.stateIndex);
               }
               else if(this.iconInfo != null)
               {
                  ImageUtils.LoadFromIconInfo(param1,this.iconInfo,ImageUtils.THUMBNAIL_SIZE_MEDIUM);
               }
               else
               {
                  ImageUtils.LoadObjectThumbnail(param1,this.resourceKey.instance,param2);
               }
         }
      }
      
      public function IsSellable() : Boolean
      {
         return (this.placementFlagsLow & (PlacementFlags.kPFLowNonDeleteable | PlacementFlags.kPFLowNonDeletableByUser)) == 0;
      }
      
      public function IsInventoryable() : Boolean
      {
         return (this.placementFlagsLow & (PlacementFlags.kPFLowNonInventoryable | PlacementFlags.kPFLowNonInventoryableByUser)) == 0;
      }
      
      public function IsPropertyProduct() : Boolean
      {
         var _loc1_:uint = this.resourceKey.type;
         if(_loc1_ == CatalogResourceTypes.WALL_PATTERN || _loc1_ == CatalogResourceTypes.FLOOR_PATTERN || _loc1_ == CatalogResourceTypes.ROOF_PATTERN || _loc1_ == CatalogResourceTypes.FENCE || _loc1_ == CatalogResourceTypes.RAILING || _loc1_ == CatalogResourceTypes.ROOF_TRIM || _loc1_ == CatalogResourceTypes.FOUNDATION || _loc1_ == CatalogResourceTypes.FRIEZE || _loc1_ == CatalogResourceTypes.CEILING_RAIL || _loc1_ == CatalogResourceTypes.FLOOR_TRIM || _loc1_ == CatalogResourceTypes.PLATFORM_TRIM)
         {
            return true;
         }
         return false;
      }
      
      public function IsAllowedForApartment() : Boolean
      {
         var _loc1_:uint = this.resourceKey.type;
         if(_loc1_ == CatalogResourceTypes.ROOF || _loc1_ == CatalogResourceTypes.ROOF_TRIM || _loc1_ == CatalogResourceTypes.FOUNDATION || _loc1_ == CatalogResourceTypes.FRIEZE || _loc1_ == CatalogResourceTypes.FLOOR_TRIM || _loc1_ == CatalogResourceTypes.TERRAIN_PAINT)
         {
            return false;
         }
         return true;
      }
      
      public function IsAllowedForPenthouse() : Boolean
      {
         var _loc1_:uint = this.resourceKey.type;
         if(_loc1_ == CatalogResourceTypes.FOUNDATION || _loc1_ == CatalogResourceTypes.TERRAIN_PAINT)
         {
            return false;
         }
         return true;
      }
      
      public function HasStateUsageVariants() : Boolean
      {
         return this.stateUsage == ProductStateUsage.COUNTER || this.stateUsage == ProductStateUsage.ISLAND_COUNTER || this.stateUsage == ProductStateUsage.CABINET || this.stateUsage == ProductStateUsage.SIT_SECTIONAL || this.stateUsage == ProductStateUsage.CHAISE_LOUNGE || this.stateUsage == ProductStateUsage.BED_BUNK;
      }
      
      public function IsHeightRestrictedColumn() : Boolean
      {
         var _loc1_:uint = this.resourceKey.type;
         if(_loc1_ != CatalogResourceTypes.COLUMN || !this.heightRangeSmall)
         {
            return false;
         }
         return true;
      }
      
      public function RequiresWaterLot() : Boolean
      {
         return (this.productObjectFlags & ProductObjectFlags.kRequiresOceanLot) != 0;
      }
      
      public function HasAdditionalGameplayFeature() : Boolean
      {
         return (this.productObjectFlags & ProductObjectFlags.kBuildObjHasAdditionalGameplay) != 0;
      }
      
      public function IsModularPlaygroundLowPlatform() : Boolean
      {
         return (this.productObjectFlags & ProductObjectFlags.kModularPlaygroundLowPlatform) != 0;
      }
      
      public function IsModularPlaygroundHighPlatform() : Boolean
      {
         return (this.productObjectFlags & ProductObjectFlags.kModularPlaygroundHighPlatform) != 0;
      }
   }
}

