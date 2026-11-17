package widgets.BuildBuy.data
{
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.BuildBuy.constants.ProductObjectFlags;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.BuildingType;
   
   public class PurchaseAvailabilityData
   {
      
      public static const PURCHASABLE:String = "Purchasable";
      
      public static const INSUFFICIENT_FUNDS:String = "NotPurchasable-InsufficientFunds";
      
      public static const LEVEL_RESTRICTED:String = "NotPurchasable-BlockLevelTooLow";
      
      public static const FOUNDATION_RESTRICTED:String = "NotPurchasable-NoFoundation";
      
      public static const WALL_HEIGHT_RESTRICTED:String = "NotPurchasable-WallHeightTooLow";
      
      public static const MTX_LOCKED:String = "NotPurchasable-MTXLock";
      
      public static const GAMEPLAY_LOCKED:String = "NotPurchasable-GameplayLocked";
      
      public static const MANNEQUIN_LIMIT_EXCEEDED:String = "NotPurchasable-MannequinLimitExceeded";
      
      public static const APARTMENT_RESTRICTED:String = "NotPurchasable-Apartment";
      
      public static const PENTHOUSE_RESTRICTED:String = "NotPurchasable-Penthouse";
      
      public static const WATER_LOT_REQUIRED:String = "NotPurchasable-RequiresOcean";
      
      public static const DEFAULT_WALL_HEIGHT:int = 3;
      
      public var availableFunds:uint;
      
      public var bWorldBuilder:Boolean = false;
      
      public var bFreeBuild:Boolean = false;
      
      public var highestWallHeight:int;
      
      public var highestLevelWithBlocks:int;
      
      public var foundationHeight:Number = 0;
      
      public var highestLeveLHeight:int;
      
      public var mannequinExcessCount:int = -1;
      
      public function PurchaseAvailabilityData()
      {
         super();
      }
      
      public function IsItemPurchasable(param1:CatalogProduct) : Boolean
      {
         return this.GetItemPurchasabilityStatus(param1) == PURCHASABLE;
      }
      
      public function GetItemPurchasabilityStatus(param1:CatalogProduct) : String
      {
         if(param1.mtxState == MTXState.LOCKED)
         {
            return MTX_LOCKED;
         }
         if(param1.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED)
         {
            return GAMEPLAY_LOCKED;
         }
         if(BuildBuyStateData.CurrentBuildingType == BuildingType.FULLY_CONTAINED_PLEX && !param1.IsAllowedForApartment())
         {
            return APARTMENT_RESTRICTED;
         }
         if((BuildBuyStateData.CurrentBuildingType == BuildingType.PENTHOUSE_PLEX || BuildBuyStateData.CurrentBuildingType == BuildingType.BT_PENTHOUSE_RENTAL) && !param1.IsAllowedForPenthouse())
         {
            return PENTHOUSE_RESTRICTED;
         }
         if(param1.RequiresWaterLot() && BuildBuyStateData.CurrentBuildingType != BuildingType.COASTAL)
         {
            return WATER_LOT_REQUIRED;
         }
         if(this.availableFunds >= param1.price || this.bWorldBuilder || this.bFreeBuild)
         {
            if(param1.resourceKey.type == CatalogResourceTypes.FLOOR_TRIM && this.highestLevelWithBlocks == 0)
            {
               return LEVEL_RESTRICTED;
            }
            if(param1.resourceKey.type == CatalogResourceTypes.FOUNDATION)
            {
               if(this.highestLeveLHeight == 0)
               {
                  return FOUNDATION_RESTRICTED;
               }
               return PURCHASABLE;
            }
            if(param1.resourceKey.type == CatalogResourceTypes.FRIEZE && this.highestLeveLHeight < param1.wallHeightRequired)
            {
               return WALL_HEIGHT_RESTRICTED;
            }
            if(param1.resourceKey.type == CatalogResourceTypes.WALL && Math.max(DEFAULT_WALL_HEIGHT,this.highestLeveLHeight) < param1.wallHeightRequired)
            {
               return WALL_HEIGHT_RESTRICTED;
            }
            if(param1.resourceKey.type == CatalogResourceTypes.OBJECT && this.highestWallHeight < param1.wallHeightRequired)
            {
               if(this.highestWallHeight == 0)
               {
                  if(param1.wallHeightRequired < CatalogProduct.WALL_HEIGHT_REQUIRED_MEDIUM)
                  {
                     return PURCHASABLE;
                  }
                  return WALL_HEIGHT_RESTRICTED;
               }
               return WALL_HEIGHT_RESTRICTED;
            }
            if(param1.productObjectFlags & ProductObjectFlags.kIsMannequin)
            {
               if(this.mannequinExcessCount > 0)
               {
                  return MANNEQUIN_LIMIT_EXCEEDED;
               }
               return PURCHASABLE;
            }
            return PURCHASABLE;
         }
         return INSUFFICIENT_FUNDS;
      }
   }
}

