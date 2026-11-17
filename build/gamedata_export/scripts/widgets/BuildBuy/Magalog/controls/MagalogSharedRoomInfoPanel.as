package widgets.BuildBuy.Magalog.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.MTX.constants.MTXState;
   import olympus.localization.Keys;
   import olympus.localization.KeysEXCH;
   import olympus.utils.ImageUtils;
   import widgets.BuildBuy.controls.ProductInfoPanel;
   
   public final class MagalogSharedRoomInfoPanel extends ProductInfoPanel
   {
      
      public var txtPlayerName:TextField;
      
      public var mcLock:MovieClip;
      
      public function MagalogSharedRoomInfoPanel()
      {
         super();
      }
      
      override protected function LoadProductData() : void
      {
         var _loc1_:CatalogProduct = mProduct as CatalogProduct;
         var _loc2_:TextField = mcPrice.getChildByName("txtPrice") as TextField;
         _loc2_.htmlText = Keys.GENERIC_MONEY.toString(_loc1_.price);
         this.txtPlayerName.htmlText = KeysEXCH.CREATED_OR_MODIFIED_BY_OFFLINE.toString(_loc1_.creatorName);
         _loc1_.LoadThumbnail(mcImage,ImageUtils.THUMBNAIL_SIZE_XLARGE);
         if(_loc1_.mtxState == MTXState.LOCKED)
         {
            this.mcLock.visible = true;
         }
         else
         {
            this.mcLock.visible = false;
         }
         this.UpdateBackgroundColor();
      }
      
      override protected function UpdateBackgroundColor() : void
      {
         super.UpdateBackgroundColor();
         var _loc1_:TextField = mcPrice.getChildByName("txtPrice") as TextField;
         var _loc2_:CatalogProduct = mProduct as CatalogProduct;
         _loc1_.htmlText = Keys.GENERIC_MONEY.toString(_loc2_.price);
      }
   }
}

