package widgets.BuildBuy.controls
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.SharedIcons;
   import olympus.audio.Audio;
   import olympus.constants.Alignment;
   import olympus.controls.ImageResource;
   import olympus.extensions.TooltipExtension;
   import olympus.gui.buttons.Button;
   
   public class CatalogImageCellView extends Button
   {
      
      public var mcImage:ImageResource;
      
      public var mcOverlayOne:ImageResource;
      
      public var mcOverlayTwo:ImageResource;
      
      public var mcOverlayThree:ImageResource;
      
      public var mcNewOverlay:Sprite;
      
      public var mcIconOverlayAnim:MovieClip;
      
      public var mcPackIcon:ImageResource;
      
      public var mcModdedIcon:MovieClip;
      
      public var mcAdditionalFeatureOverlay:MovieClip;
      
      public var mcHighPlatformOverlay:MovieClip;
      
      public var mcLowPlatformOverlay:MovieClip;
      
      protected var mData:CatalogProduct;
      
      protected var mInitModdedIconPosX:Number = 0;
      
      public function CatalogImageCellView()
      {
         super();
         mAudioExtension.CategoryName = "ThumbnailButton";
      }
      
      override public function get height() : Number
      {
         return mcHitArea.height;
      }
      
      override public function get width() : Number
      {
         return mcHitArea.width;
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.mouseChildren = true;
         if(this.mcIconOverlayAnim)
         {
            this.mcPackIcon = this.mcIconOverlayAnim.mcPackIcon;
            this.mcModdedIcon = this.mcIconOverlayAnim.mcModdedIcon;
            this.mInitModdedIconPosX = this.mcModdedIcon.x;
         }
         mAudioExtension.ElementName = "CatagalogCellView";
         (GetExtension(TooltipExtension) as TooltipExtension).VerticalAlignment = Alignment.CENTER;
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         var _loc3_:CatalogProduct = null;
         _loc3_ = this.mData = param1 as CatalogProduct;
         if(!_loc3_)
         {
            return;
         }
         _loc3_.LoadThumbnail(this.mcImage);
         if(this.mcPackIcon)
         {
            if(_loc3_.packId > 0)
            {
               this.mcPackIcon.visible = true;
               this.mcPackIcon.LoadImage(SharedIcons.GetPackIcon(_loc3_.packId,SharedIcons.SIZE_32));
            }
            else
            {
               this.mcPackIcon.visible = false;
            }
         }
         if(this.mcModdedIcon)
         {
            this.mcModdedIcon.visible = _loc3_.is_modded;
            this.mcModdedIcon.x = this.mcPackIcon.visible ? this.mInitModdedIconPosX : this.mcPackIcon.x;
         }
         if(this.mcNewOverlay)
         {
            this.mcNewOverlay.visible = _loc3_.isNew || _loc3_.mtxState == MTXState.UNLOCKED_NEW;
            if(this.mcNewOverlay.visible && Boolean(this.mcPackIcon))
            {
               this.mcPackIcon.visible = false;
            }
         }
         if(this.mcOverlayOne)
         {
            this.mcOverlayOne.visible = false;
            this.mcOverlayTwo.visible = false;
            this.mcOverlayThree.visible = false;
         }
         if(this.mcAdditionalFeatureOverlay)
         {
            this.mcAdditionalFeatureOverlay.visible = _loc3_.HasAdditionalGameplayFeature();
         }
         if(this.mcLowPlatformOverlay)
         {
            this.mcLowPlatformOverlay.visible = _loc3_.IsModularPlaygroundLowPlatform();
         }
         if(this.mcHighPlatformOverlay)
         {
            this.mcHighPlatformOverlay.visible = _loc3_.IsModularPlaygroundHighPlatform();
         }
         this.RefreshAvailabilityData();
      }
      
      override protected function OnMousePress(param1:MouseEvent) : void
      {
         super.OnMousePress(param1);
         if(!enabled)
         {
            mAudioExtension.Dispatch(Audio.CUSTOM);
         }
      }
      
      protected function RefreshAvailabilityData() : void
      {
         enabled = true;
      }
   }
}

