package widgets.BuildBuy.controls
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductGameplayInfo;
   import gamedata.Exchange.ExchangeData;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.ResourceKey;
   import gamedata.shared.SharedIcons;
   import olympus.controls.ImageResource;
   import olympus.localization.Keys;
   import olympus.utils.TextUtils;
   import widgets.BuildBuy.constants.Icons;
   import widgets.BuildBuy.constants.LotLevelHeights;
   import widgets.BuildBuy.data.PurchaseAvailabilityData;
   import widgets.shared.constants.ProductInfoPanelTunables;
   import widgets.shared.controls.SharedProductInfoPanel;
   
   public class ProductInfoPanel extends SharedProductInfoPanel
   {
      
      public var mcImage:ImageResource;
      
      public var mcLockIcon:ImageResource;
      
      public var mcPackIcon:ImageResource;
      
      public var mcModdedIcon:MovieClip;
      
      public var mcName:MovieClip;
      
      public var mcPrice:MovieClip;
      
      public var txtDescription:TextField;
      
      public var mcUnlockReason:MovieClip;
      
      public var txtGameData:TextField;
      
      public var mcDividingLine:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var mcHeightRequired:ImageResource;
      
      public var mcInventoryCount:MovieClip;
      
      protected var mMinBackgroundHeight:Number = -1;
      
      protected var mNameToDescriptionPadding:Number = 0;
      
      protected var mNameMaxWidth:Number = 0;
      
      protected var mGamedataTextBottom:Number = 0;
      
      protected var mbInitialized:Boolean = false;
      
      protected var mInitModdedIconPosX:Number = 0;
      
      protected var mShowProductAvailability:Boolean = true;
      
      public function ProductInfoPanel()
      {
         super();
         this.mNameMaxWidth = this.mcName.width;
      }
      
      override protected function OnAddedToStage(param1:Event) : void
      {
         super.OnAddedToStage(param1);
         if(this.mcModdedIcon)
         {
            this.mInitModdedIconPosX = this.mcModdedIcon.x;
         }
         this.mMinBackgroundHeight = Math.ceil(this.mcBackground.height);
         if(Boolean(this.mcName) && Boolean(this.txtDescription))
         {
            this.mNameToDescriptionPadding = this.txtDescription.y - (this.mcName.y + this.mcName.height);
         }
         if(this.txtDescription)
         {
            this.txtDescription.autoSize = TextFieldAutoSize.LEFT;
         }
         if(this.txtGameData)
         {
            this.txtGameData.autoSize = TextFieldAutoSize.LEFT;
         }
         Hide(false);
         this.mbInitialized = true;
      }
      
      public function get Product() : CatalogProduct
      {
         return mProduct as CatalogProduct;
      }
      
      public function set ShowProductAvailability(param1:Boolean) : void
      {
         this.mShowProductAvailability = param1;
      }
      
      override public function Show(param1:Object, param2:uint = 300, param3:Boolean = true) : Boolean
      {
         var _loc4_:CatalogProduct = null;
         var _loc5_:ExchangeData = null;
         if(param1 is CatalogProduct)
         {
            _loc4_ = param1 as CatalogProduct;
         }
         else if(param1 is ExchangeData)
         {
            _loc5_ = param1 as ExchangeData;
            _loc4_ = new CatalogProduct(null);
            _loc4_.customName = _loc5_.name;
            _loc4_.customDesc = _loc5_.description;
            _loc4_.creatorName = _loc5_.creator_name;
            _loc4_.gameplayInfo = [];
            _loc4_.mtxState = Boolean(_loc5_.mtx_ids) && _loc5_.mtx_ids.length > 0 ? MTXState.LOCKED : MTXState.FREE;
            _loc4_.price = _loc5_.priceValue;
            _loc4_.resourceKey = new ResourceKey();
            _loc4_.resourceKey.type = CatalogResourceTypes.SHARED_ROOM;
            _loc4_.resourceKey.instance = _loc5_.id;
            _loc4_.wallHeightRequired = 0;
         }
         if(!_loc4_ || _loc4_.resourceKey.instance == null)
         {
            Hide();
            return false;
         }
         if(_loc4_ == mProduct)
         {
            return false;
         }
         mProduct = _loc4_;
         this.LoadProductData();
         param3 &&= !this.visible;
         super.Show(param1,param2,param3);
         return true;
      }
      
      public function RefreshAvailability() : void
      {
         if(mProduct == null || !visible)
         {
            return;
         }
         this.UpdateBackgroundColor();
      }
      
      protected function LoadProductData() : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:ProductGameplayInfo = null;
         var _loc1_:CatalogProduct = mProduct as CatalogProduct;
         if(!_loc1_)
         {
            return;
         }
         this.SetNameText(_loc1_.Name);
         if(this.txtDescription)
         {
            this.txtDescription.htmlText = _loc1_.Description;
         }
         if(this.txtGameData)
         {
            _loc2_ = _loc1_.gameplayInfo;
            if(_loc2_.length)
            {
               this.txtGameData.visible = true;
               if(this.mcDividingLine)
               {
                  this.mcDividingLine.visible = true;
               }
               _loc3_ = int(_loc2_.length);
               _loc4_ = new Array(_loc3_);
               _loc5_ = 0;
               while(_loc5_ < _loc3_)
               {
                  _loc6_ = _loc2_[_loc5_] as ProductGameplayInfo;
                  _loc4_[_loc5_] = _loc6_.name.toString();
                  if(_loc6_.value)
                  {
                     _loc4_[_loc5_] += " " + _loc6_.value;
                  }
                  _loc5_++;
               }
               this.txtGameData.htmlText = _loc4_.join("\n");
            }
            else
            {
               this.txtGameData.height = 0;
               this.txtGameData.htmlText = "";
               this.txtGameData.visible = false;
               if(this.mcDividingLine)
               {
                  this.mcDividingLine.visible = false;
               }
            }
         }
         if(this.mcLockIcon)
         {
            if(_loc1_.mtxState == MTXState.LOCKED)
            {
               this.mcLockIcon.visible = true;
               this.mcLockIcon.LoadImage(Icons.ICON_MTX_LOCK);
            }
            else if(_loc1_.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED)
            {
               this.mcLockIcon.visible = true;
               this.mcLockIcon.LoadImage(Icons.ICON_GAMEPLAY_LOCK);
            }
            else
            {
               this.mcLockIcon.visible = false;
            }
         }
         if(this.mcImage)
         {
            _loc1_.LoadThumbnail(this.mcImage);
         }
         if(this.mcPackIcon)
         {
            if(_loc1_.packId > 0)
            {
               this.mcPackIcon.visible = true;
               this.mcPackIcon.LoadImage(SharedIcons.GetPackIcon(_loc1_.packId,SharedIcons.SIZE_32));
            }
            else
            {
               this.mcPackIcon.visible = false;
            }
         }
         if(this.mcModdedIcon)
         {
            this.mcModdedIcon.visible = _loc1_.is_modded;
            this.mcModdedIcon.x = this.mcPackIcon.visible ? this.mInitModdedIconPosX : this.mcPackIcon.x;
         }
         if(this.mcHeightRequired)
         {
            if(_loc1_.wallHeightRequired > 0)
            {
               this.mcHeightRequired.visible = true;
               if(_loc1_.wallHeightRequired <= LotLevelHeights.SHORT)
               {
                  this.mcHeightRequired.LoadImage(Icons.ICON_WALLHEIGHT_SHORT);
               }
               else if(_loc1_.wallHeightRequired <= LotLevelHeights.MEDIUM)
               {
                  this.mcHeightRequired.LoadImage(Icons.ICON_WALLHEIGHT_MEDIUM);
               }
               else
               {
                  this.mcHeightRequired.LoadImage(Icons.ICON_WALLHEIGHT_TALL);
               }
            }
            else
            {
               this.mcHeightRequired.visible = false;
            }
         }
         if(this.mcInventoryCount)
         {
            if(_loc1_.count)
            {
               (this.mcInventoryCount.getChildByName("textField") as TextField).htmlText = _loc1_.count.toString();
               (this.mcInventoryCount.getChildByName("mcImage") as ImageResource).LoadImage(Icons.ICON_NAVMODE_INVENTORY);
               this.mcInventoryCount.visible = true;
            }
            else
            {
               this.mcInventoryCount.visible = false;
            }
         }
         this.UpdateBackgroundColor();
         this.PositionElements();
      }
      
      protected function PositionElements() : void
      {
         var _loc1_:Number = 0;
         if(this.mcName)
         {
            _loc1_ += this.mcName.y + this.mcName.height + ProductInfoPanelTunables.NAME_TEXT_BOTTOM_PADDING;
            if(this.txtDescription)
            {
               this.txtDescription.y = this.mcName.y + this.mcName.height + this.mNameToDescriptionPadding;
            }
         }
         else if(this.txtDescription)
         {
            _loc1_ += this.txtDescription.y;
         }
         if(this.txtDescription)
         {
            _loc1_ += this.txtDescription.height;
         }
         if(Boolean(this.mcUnlockReason) && this.mcUnlockReason.visible)
         {
            _loc1_ += this.mcUnlockReason.height;
         }
         if(this.mcPrice)
         {
            _loc1_ += this.mcPrice.height;
            if(this.mcName)
            {
               this.mcPrice.y = this.mcName.y + this.mcName.height + ProductInfoPanelTunables.NAME_TEXT_BOTTOM_PADDING;
            }
         }
         if(Boolean(this.txtGameData) && this.txtGameData.visible)
         {
            _loc1_ += ProductInfoPanelTunables.GAMEDATA_TEXT_PADDING.Vertical;
            _loc1_ += this.txtGameData.height;
            if(this.mcDividingLine)
            {
               _loc1_ += this.mcDividingLine.height;
            }
         }
         _loc1_ += ProductInfoPanelTunables.BOTTOM_MARGIN;
         if(_loc1_ < this.mMinBackgroundHeight)
         {
            _loc1_ = this.mMinBackgroundHeight;
         }
         else
         {
            _loc1_ = Math.ceil(_loc1_);
         }
         this.mcBackground.height = _loc1_;
         var _loc2_:Number = _loc1_ - ProductInfoPanelTunables.BOTTOM_MARGIN;
         if(this.txtGameData)
         {
            if(this.txtGameData.visible)
            {
               _loc2_ = this.txtGameData.y = _loc2_ - this.txtGameData.height - ProductInfoPanelTunables.GAMEDATA_TEXT_PADDING.mBot;
               if(this.mcDividingLine)
               {
                  _loc2_ = this.mcDividingLine.y = _loc2_ - this.mcDividingLine.height;
               }
            }
            else
            {
               this.txtGameData.y = 0;
               this.txtGameData.htmlText = "";
            }
         }
         if(this.mcUnlockReason)
         {
            this.mcUnlockReason.y = _loc2_ - this.mcUnlockReason.height;
         }
      }
      
      protected function UpdateBackgroundColor() : void
      {
         var _loc2_:PurchaseAvailabilityData = null;
         var _loc4_:String = null;
         var _loc5_:TextField = null;
         if(!this.mcName)
         {
            return;
         }
         var _loc1_:CatalogProduct = mProduct as CatalogProduct;
         if(this.mShowProductAvailability)
         {
            _loc2_ = BuildBuyStateData.PurchaseAvailability;
         }
         if(Boolean(_loc2_) && Boolean(_loc1_))
         {
            _loc4_ = _loc2_.GetItemPurchasabilityStatus(_loc1_);
            if(_loc4_ == PurchaseAvailabilityData.PURCHASABLE)
            {
               this.mcName.gotoAndStop("default");
               this.mcPrice.gotoAndStop("default");
            }
            else if(_loc4_ == PurchaseAvailabilityData.WALL_HEIGHT_RESTRICTED || _loc4_ == PurchaseAvailabilityData.LEVEL_RESTRICTED)
            {
               this.mcName.gotoAndStop("cannotPlace");
               this.mcPrice.gotoAndStop("cannotPlace");
            }
            else if(_loc1_.price <= BuildBuyStateData.PurchaseAvailability.availableFunds)
            {
               this.mcName.gotoAndStop("default");
               this.mcPrice.gotoAndStop("default");
            }
            else
            {
               this.mcName.gotoAndStop("cannotAfford");
               this.mcPrice.gotoAndStop("cannotAfford");
            }
         }
         else
         {
            this.mcName.gotoAndStop("default");
            this.mcPrice.gotoAndStop("default");
         }
         this.SetNameText(_loc1_.Name);
         var _loc3_:TextField = this.mcPrice.getChildByName("txtPrice") as TextField;
         if(_loc1_.mtxState == MTXState.LOCKED)
         {
            _loc3_.htmlText = Keys.GENERIC_CURRENCY.toString(_loc1_.price);
         }
         else
         {
            _loc3_.htmlText = Keys.GENERIC_MONEY.toString(_loc1_.price);
         }
         if(this.mcUnlockReason)
         {
            if(_loc1_.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED && Boolean(_loc1_.gameplayLockedDescription))
            {
               this.mcUnlockReason.visible = true;
               this.mcUnlockReason.gotoAndStop("locked");
               _loc5_ = this.mcUnlockReason.getChildByName("txtGameplayUnlockReason") as TextField;
               _loc5_.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.htmlText = _loc1_.gameplayLockedDescription.toString();
            }
            else if(_loc1_.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_UNLOCKED && Boolean(_loc1_.gameplayUnlockedDescription))
            {
               this.mcUnlockReason.visible = true;
               this.mcUnlockReason.gotoAndStop("unlocked");
               _loc5_ = this.mcUnlockReason.getChildByName("txtGameplayUnlockReason") as TextField;
               _loc5_.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.htmlText = _loc1_.gameplayUnlockedDescription.toString();
            }
            else
            {
               _loc5_ = this.mcUnlockReason.getChildByName("txtGameplayUnlockReason") as TextField;
               _loc5_.htmlText = "";
               this.mcUnlockReason.visible = false;
            }
         }
      }
      
      protected function SetNameText(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(this.mcName)
         {
            _loc2_ = this.mcName.getChildByName("txtName") as TextField;
            _loc2_.htmlText = param1;
            _loc2_.height = _loc2_.textHeight + 2 * (_loc2_.getTextFormat().leading as int);
            TextUtils.ResizeTextToFit(_loc2_,param1,this.mNameMaxWidth,_loc2_.height,ProductInfoPanelTunables.NAME_MIN_FONT_SIZE);
            if(_loc2_.textWidth > this.mNameMaxWidth)
            {
               _loc2_.width = this.mNameMaxWidth;
               TextUtils.SetAndEllipsizeText(_loc2_,param1);
            }
         }
      }
   }
}

