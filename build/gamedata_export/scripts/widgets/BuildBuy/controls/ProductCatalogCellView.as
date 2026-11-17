package widgets.BuildBuy.controls
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.BrandedLogo;
   import gamedata.shared.BrandedTagData;
   import olympus.constants.Alignment;
   import olympus.controls.ImageResource;
   import olympus.extensions.TooltipExtension;
   import olympus.localization.KeysBB;
   import olympus.utils.InputUtils;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.constants.Icons;
   import widgets.BuildBuy.data.PurchaseAvailabilityData;
   import widgets.BuildBuy.events.CatalogEvent;
   import widgets.shared.controls.VariationGrid;
   import widgets.shared.controls.VariationStackContainer;
   
   public class ProductCatalogCellView extends CatalogImageCellView
   {
      
      public var mcLockOverlay:ImageResource;
      
      public var mcHeightRestrictionColumnOverlay:ImageResource;
      
      public var mcBkgOverlay:MovieClip;
      
      public var mcBrandedLogo:BrandedLogo;
      
      public var mcBackground:MovieClip;
      
      public var btnSwatchContainer:VariationStackContainer;
      
      public function ProductCatalogCellView()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         var _loc2_:VariationGrid = null;
         super.ConfigUI();
         var _loc1_:VariationStackContainer = this.btnSwatchContainer;
         if(_loc1_)
         {
            _loc2_ = _loc1_.VariationStack;
            _loc1_.visible = false;
            _loc2_.mPrimaryExpandDirection = Alignment.TOP;
            _loc2_.mColorStackPadding = BBTunables.VARIATION_GRID_STACK_OFFSET;
            _loc2_.mMaxStackSize = BBTunables.VARIATION_GRID_STACK_MAX_COLORS;
            _loc1_.addEventListener(MouseEvent.CLICK,this.OnSwatchClick,false,0,true);
         }
         this.mcBrandedLogo.visible = false;
      }
      
      public function get ShowSwatchOnRollover() : Boolean
      {
         var _loc1_:CatalogProduct = mData;
         return Boolean(_loc1_) && (_loc1_.variationCount > 1 || _loc1_.HasStateUsageVariants());
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         var _loc3_:CatalogProduct = mData;
         if(!_loc3_)
         {
            return;
         }
         this.mcLockOverlay.visible = false;
         if(this.mcHeightRestrictionColumnOverlay != null)
         {
            this.mcHeightRestrictionColumnOverlay.visible = false;
         }
         if(_loc3_.gameplayUnlockState)
         {
            this.mcBkgOverlay.gotoAndStop("gameplay_unlock");
            if(_loc3_.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED)
            {
               this.mcLockOverlay.visible = true;
               this.mcLockOverlay.LoadImage(Icons.ICON_GAMEPLAY_LOCK);
            }
         }
         else if(_loc3_.mtxState == MTXState.LOCKED || _loc3_.mtxState == MTXState.UNLOCKED_NEW)
         {
            this.mcBkgOverlay.gotoAndStop("mtx_unlock");
            if(_loc3_.mtxState == MTXState.LOCKED)
            {
               this.mcLockOverlay.visible = true;
               this.mcLockOverlay.LoadImage(Icons.ICON_MTX_LOCK);
            }
         }
         else
         {
            this.mcBkgOverlay.gotoAndStop("default");
            if(_loc3_.IsHeightRestrictedColumn() && this.mcHeightRestrictionColumnOverlay != null)
            {
               this.mcHeightRestrictionColumnOverlay.visible = true;
               this.mcHeightRestrictionColumnOverlay.LoadImage(Icons.ICON_COLUMN_HEIGHT_RESTRICTION);
            }
         }
         var _loc4_:BrandedTagData = BrandedTagData.GetBuildBuyBrandedProduct(_loc3_.resourceKey.instance);
         if((Boolean(_loc4_)) && !mcNewOverlay.visible)
         {
            this.mcBrandedLogo.SetTag(_loc4_);
            this.mcBrandedLogo.visible = true;
         }
         else
         {
            this.mcBrandedLogo.visible = false;
         }
      }
      
      override protected function RefreshAvailabilityData() : void
      {
         var _loc1_:PurchaseAvailabilityData = null;
         var _loc2_:String = null;
         var _loc3_:TooltipExtension = null;
         if(Boolean(mData) && Boolean(this.mcBackground))
         {
            _loc1_ = BuildBuyStateData.PurchaseAvailability;
            _loc2_ = _loc1_.GetItemPurchasabilityStatus(mData);
            _loc3_ = TooltipExt as TooltipExtension;
            if(_loc2_ == PurchaseAvailabilityData.PURCHASABLE)
            {
               _loc3_.Text = null;
               enabled = true;
               this.mcBackground.gotoAndStop("default");
            }
            else if(_loc2_ == PurchaseAvailabilityData.INSUFFICIENT_FUNDS)
            {
               _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_CANNOTAFFORD);
               this.mcBackground.gotoAndStop("cannot_afford");
               _loc3_.VerticalAlignment = Alignment.CENTER;
               enabled = false;
            }
            else
            {
               switch(_loc2_)
               {
                  case PurchaseAvailabilityData.GAMEPLAY_LOCKED:
                  case PurchaseAvailabilityData.MTX_LOCKED:
                  default:
                     _loc3_.Text = null;
                     break;
                  case PurchaseAvailabilityData.LEVEL_RESTRICTED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_LEVEL_RESTRICTED);
                     break;
                  case PurchaseAvailabilityData.FOUNDATION_RESTRICTED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_FOUNDATION_RESTRICTED);
                     break;
                  case PurchaseAvailabilityData.WALL_HEIGHT_RESTRICTED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_HEIGHT_RESTRICTED);
                     break;
                  case PurchaseAvailabilityData.MANNEQUIN_LIMIT_EXCEEDED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_MANNEQUIN_RESTRICTED,_loc1_.mannequinExcessCount);
                     break;
                  case PurchaseAvailabilityData.APARTMENT_RESTRICTED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_APARTMENT_RESTRICTED);
                     break;
                  case PurchaseAvailabilityData.PENTHOUSE_RESTRICTED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_PENTHOUSE_RESTRICTED);
                     break;
                  case PurchaseAvailabilityData.WATER_LOT_REQUIRED:
                     _loc3_.SetText(KeysBB.BB_CATALOG_TOOLTIP_WATER_LOT_REQUIRED);
               }
               _loc3_.VerticalAlignment = Alignment.CENTER;
               enabled = false;
               this.mcBackground.gotoAndStop("cannot_place");
            }
         }
         else
         {
            enabled = true;
         }
      }
      
      protected function OnSwatchClick(param1:MouseEvent) : void
      {
         if(!InputUtils.IsLeftMouseButton(param1))
         {
            return;
         }
         var _loc2_:CatalogEvent = new CatalogEvent(CatalogEvent.SWATCH_SELECTED,true);
         _loc2_.product = mData;
         dispatchEvent(_loc2_);
      }
   }
}

