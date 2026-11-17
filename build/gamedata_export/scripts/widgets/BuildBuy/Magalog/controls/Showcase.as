package widgets.BuildBuy.Magalog.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import gamedata.BuildBuy.constants.CatalogResourceTypes;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductFilter;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.ResourceKey;
   import olympus.constants.InputActionPriorities;
   import olympus.constants.KeyCodes;
   import olympus.constants.WindowAnimation;
   import olympus.controls.GUIComponent;
   import olympus.controls.ImageResource;
   import olympus.core.Ticker;
   import olympus.core.cursors.Cursors;
   import olympus.events.DataFeedEvent;
   import olympus.events.GenericEvent;
   import olympus.events.GridEvent;
   import olympus.events.PushButtonEvent;
   import olympus.events.TweenEvent;
   import olympus.extensions.MouseKeyboardVisibilityExtension;
   import olympus.extensions.TooltipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.HighlightRequestEvent;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.Button;
   import olympus.gui.buttons.TextButton;
   import olympus.gui.grids.SelectionGrid;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.InputAdapterConfirmEvent;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.OmnidirectionalGroupAdapter;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.layout.GridLayout;
   import olympus.localization.Keys;
   import olympus.localization.KeysBB;
   import olympus.motion.Tween;
   import olympus.motion.TweenParams;
   import olympus.utils.SystemUtils;
   import scaleform.gfx.MouseEventEx;
   import widgets.BuildBuy.Magalog.constants.BuildBuyMagalogTunables;
   import widgets.BuildBuy.constants.Icons;
   import widgets.BuildBuy.constants.PlacementModes;
   import widgets.BuildBuy.controls.ProductInfoPanel;
   import widgets.BuildBuy.data.PurchaseAvailabilityData;
   import widgets.BuildBuy.data.VariationDataFeed;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterAdapterBase;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterProductSelectedAdapter;
   import widgets.shared.data.ColorSwatchData;
   
   public final class Showcase extends GUIComponent implements IInputAdapter
   {
      
      protected static const OVERLAY_IMAGE_URL:String = "img://magalog/ShowcaseAdditiveImage";
      
      protected static const DEFAULT_FRAME:String = "default";
      
      protected static const CANNOT_AFFORD_FRAME:String = "cannotAfford";
      
      public static const BACKGROUND_UP:String = "controller_up";
      
      public static const BACKGROUND_OVER:String = "controller_over";
      
      public static const BACKGROUND_IN:String = "controller_down";
      
      public var mcImage:ImageResource;
      
      public var mcImageOverlayAdd:ImageResource;
      
      public var mcImageOverlayNorm:ImageResource;
      
      public var mcName:ShowcaseRoomName;
      
      public var mcPrice:MovieClip;
      
      public var btnBuy:TextButton;
      
      public var btnClose:Button;
      
      public var mcLockIcon:ImageResource;
      
      public var mcProductInfoPanel:ProductInfoPanel;
      
      public var mcVariationBar:SelectionGrid;
      
      public var txtPurchaseFor:TextField;
      
      public var mcBackground:MovieClip;
      
      protected var mGridLayout:GridLayout;
      
      protected var mFeed:VariationDataFeed;
      
      protected var mProduct:CatalogProduct;
      
      protected var mImageProduct:CatalogProduct;
      
      protected var mPurchaseAvailability:PurchaseAvailabilityData;
      
      protected var mFilter:ProductFilter;
      
      protected var mEscapeKeyAction:InputAction;
      
      protected var mTweenIn:Tween;
      
      protected var mInputAdapter:OmnidirectionalGroupAdapter;
      
      protected var mRoomInput:VirtualCursorInputAdapter;
      
      protected var mPlaceModeInput:BuildBuyCenterAdapterBase;
      
      protected var mbGamepadTogglingToCursor:Boolean = false;
      
      protected var ConfirmFromPlaceModeTickerObj:Object = new Object();
      
      public function Showcase()
      {
         super();
         this.mImageProduct = null;
         this.mGridLayout = new GridLayout(false,true,5);
         this.mFeed = new VariationDataFeed();
         this.mcVariationBar.InitializeSelectionGrid(this.mFeed,getDefinitionByName("BBVariantSwatchCellView") as Class,true,null,this.mGridLayout);
         this.mcVariationBar.SetSelectionGridListener(PushButtonEvent.CLICK);
         this.mcVariationBar.addEventListener(GridEvent.SELECTION_UPDATE,this.OnVariationSelected,false,0,true);
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mInputAdapter = new OmnidirectionalGroupAdapter();
            this.mRoomInput = new VirtualCursorInputAdapter();
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         addChild(this.mcVariationBar);
         this.btnBuy.addEventListener(PushButtonEvent.CLICK,this.OnBuyClicked,false,0,true);
         this.btnBuy.AudioExt.ElementName = "BuyRoomButton";
         this.btnBuy.htmlText = KeysBB.BB_MAGALOG_BUY_ROOM.toString();
         this.btnClose.addEventListener(PushButtonEvent.CLICK,this.OnCloseClick,false,0,true);
         MouseKeyboardVisibilityExtension.Add(this.btnClose);
         this.mcImage.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMoveOverImage,false,0,true);
         this.mcImage.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOutImage,false,0,true);
         this.mcImage.addEventListener(MouseEvent.CLICK,this.OnClickImage,false,0,true);
         this.mcImage.doubleClickEnabled = true;
         this.mcImage.addEventListener(MouseEvent.DOUBLE_CLICK,this.OnDoubleClickImage,false,0,true);
         this.mcImage.scaleMode = "noScale";
         this.mcImageOverlayAdd.scaleMode = "noScale";
         this.mcImageOverlayAdd.mouseEnabled = false;
         this.mcImageOverlayNorm.scaleMode = "noScale";
         this.mcImageOverlayNorm.mouseEnabled = false;
         this.mcLockIcon.visible = false;
         this.txtPurchaseFor.htmlText = KeysBB.BB_MAGALOG_PURCHASE_FOR.toString();
         CommunicationManager.AddMessageListener(BuildBuyStateData.PURCHASE_AVAILABILITY_UPDATE,this.HandlePurchaseAvailabilityUpdate,this);
         this.mEscapeKeyAction = InputAction.WhenTriggered(InputTrigger.FromKeyBinding(KeyCodes.ESC)).CallFunction(this.OnCloseClick).SetPriority(InputActionPriorities.ESC_MAGALOG_SHOWCASE);
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
         if(SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.AddMessageListener("UsingControllerToggled",this.HandleUsingControllerToggled,this);
         }
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         super.OnRemovedFromStage(param1);
         if(visible)
         {
            this.OnCloseClick();
         }
      }
      
      public function get Product() : CatalogProduct
      {
         return this.mProduct;
      }
      
      public function set Product(param1:CatalogProduct) : void
      {
         this.mProduct = param1;
         if(!param1)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(!this.mPurchaseAvailability)
         {
            this.HandlePurchaseAvailabilityUpdate();
            _loc2_ = visible;
         }
         this.mcImage.LoadImage(param1.secondaryImage);
         this.mcImageOverlayAdd.LoadImage(OVERLAY_IMAGE_URL);
         this.mcImageOverlayNorm.LoadImage(OVERLAY_IMAGE_URL);
         this.mcName.Text = param1.Name;
         if(param1.mtxState == MTXState.LOCKED)
         {
            this.mcLockIcon.visible = true;
            this.mcLockIcon.LoadImage(Icons.ICON_MTX_LOCK);
            this.ProductPrice = Keys.GENERIC_CURRENCY.toString(param1.price);
         }
         else if(param1.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED)
         {
            this.mcLockIcon.visible = true;
            this.mcLockIcon.LoadImage(Icons.ICON_GAMEPLAY_LOCK);
         }
         else
         {
            this.mcLockIcon.visible = false;
         }
         if(Boolean(this.mPurchaseAvailability) && !_loc2_)
         {
            this.UpdateAvailability();
         }
      }
      
      public function HandlePurchaseAvailabilityUpdate() : void
      {
         this.mPurchaseAvailability = BuildBuyStateData.PurchaseAvailability;
         if(visible)
         {
            this.UpdateAvailability();
         }
      }
      
      public function Show() : void
      {
         var _loc1_:CatalogProduct = null;
         _loc1_ = this.mProduct;
         if(_loc1_)
         {
            this.mFeed.LoadProductVariations(_loc1_);
            this.mcVariationBar.visible = this.mFeed.length > 1;
            CommunicationManager.CallGameService("BBSetShowcaseProduct",_loc1_.resourceKey.ToObject());
            stage.focus = this;
            this.AnimateIn(0,null);
         }
         this.mcProductInfoPanel.Hide();
         InputActionManager.RegisterAction(this.mEscapeKeyAction);
      }
      
      public function Hide() : void
      {
         if(this.mTweenIn)
         {
            this.mTweenIn.Stop(true,true);
         }
         visible = false;
         InputActionManager.UnregisterAction(this.mEscapeKeyAction);
         if(SystemUtils.UsingController)
         {
            NavManager.Instance.TryFocusBack(this.mInputAdapter);
         }
      }
      
      protected function SelectProduct(param1:CatalogProduct, param2:CatalogProduct = null) : void
      {
         var _loc3_:Array = null;
         if(this.mFilter)
         {
            _loc3_ = this.mFilter.categoryTags;
         }
         var _loc4_:int = 0;
         if(param1.resourceKey.type == CatalogResourceTypes.FENCE)
         {
            _loc4_ = PlacementModes.PLACEMENT_FENCE_TOOL;
         }
         param1.Select(_loc3_,param2 ? param2.resourceKey : null,_loc4_);
      }
      
      protected function OnCloseClick(param1:PushButtonEvent = null) : void
      {
         this.Hide();
         dispatchEvent(new GenericEvent(GenericEvent.CLOSE));
      }
      
      protected function OnVariationSelected(param1:GridEvent) : void
      {
         this.Product = (param1.mData as ColorSwatchData).productBB;
         CommunicationManager.CallGameService("BBSetShowcaseProduct",this.mProduct.resourceKey.ToObject());
         dispatchEvent(new GenericEvent(GenericEvent.CHANGE));
      }
      
      protected function OnBuyClicked(param1:PushButtonEvent) : void
      {
         if(!SystemUtils.UsingController)
         {
            this.Hide();
         }
         this.SelectProduct(this.mProduct);
      }
      
      protected function PurchaseItem(param1:CatalogProduct) : void
      {
         if(param1)
         {
            this.SelectProduct(param1,this.mProduct);
            if(param1.resourceKey.type == CatalogResourceTypes.WALL_PATTERN || SystemUtils.UsingController && param1.resourceKey.type == CatalogResourceTypes.FLOOR_PATTERN)
            {
               CommunicationManager.SendUIMessage("BBAttachProductToCursor",param1);
            }
         }
      }
      
      protected function UpdateAvailability() : void
      {
         var _loc1_:PurchaseAvailabilityData = this.mPurchaseAvailability;
         var _loc2_:CatalogProduct = this.mProduct;
         if(!_loc2_ || !_loc1_)
         {
            return;
         }
         var _loc3_:String = _loc1_.GetItemPurchasabilityStatus(_loc2_);
         var _loc4_:TextButton = this.btnBuy;
         var _loc5_:TooltipExtension = this.btnBuy.GetExtension(TooltipExtension) as TooltipExtension;
         if(_loc3_ == PurchaseAvailabilityData.PURCHASABLE)
         {
            _loc4_.enabled = true;
            _loc5_.SetText(null);
            this.mcPrice.gotoAndStop(DEFAULT_FRAME);
            this.mcName.State = DEFAULT_FRAME;
         }
         else if(_loc3_ == PurchaseAvailabilityData.GAMEPLAY_LOCKED)
         {
            _loc4_.enabled = false;
            _loc5_.SetText(_loc2_.gameplayLockedDescription);
            this.mcPrice.gotoAndStop(DEFAULT_FRAME);
            this.mcName.State = DEFAULT_FRAME;
         }
         else
         {
            _loc4_.enabled = false;
            _loc5_.SetText(KeysBB.BB_CATALOG_TOOLTIP_CANNOTAFFORD);
            this.mcPrice.gotoAndStop(CANNOT_AFFORD_FRAME);
            this.mcName.State = CANNOT_AFFORD_FRAME;
         }
         this.ProductPrice = Keys.GENERIC_MONEY.toString(_loc2_.price);
         if(this.mImageProduct)
         {
            this.mcProductInfoPanel.RefreshAvailability();
         }
      }
      
      protected function OnMouseMoveOverImage(param1:MouseEvent) : void
      {
         var _loc5_:CatalogProduct = null;
         var _loc6_:ColorTransform = null;
         var _loc7_:String = null;
         var _loc2_:Number = Math.round(param1.localX);
         var _loc3_:Number = Math.round(param1.localY);
         var _loc4_:Object = CommunicationManager.CallGameService("BBMagalogMouseCommand",{
            "mouseX":_loc2_,
            "mouseY":_loc3_
         });
         Cursors.SetCursor(_loc4_ != null ? Cursors.BUTTON_OVER : null);
         if(_loc4_)
         {
            _loc5_ = new CatalogProduct(_loc4_);
            if(!this.mImageProduct || _loc5_.resourceKey.instance != this.mImageProduct.resourceKey.instance)
            {
               this.mImageProduct = _loc5_;
               if(_loc5_.wallHeightRequired)
               {
                  this.mFilter = new ProductFilter(CommunicationManager.CallGameService("BBGetProductFilter",_loc5_.resourceKey.ToObject()));
               }
               else
               {
                  this.mFilter = null;
               }
               this.mcProductInfoPanel.Hide();
               this.mcProductInfoPanel.Show(this.mImageProduct);
               _loc6_ = this.mcImageOverlayNorm.transform.colorTransform;
               if(_loc5_.gameplayUnlockState == CatalogProduct.GAMEPLAY_UNLOCK_LOCKED || _loc5_.mtxState == MTXState.LOCKED)
               {
                  _loc6_.color = BuildBuyMagalogTunables.SHOWCASE_HIGHLIGHT_LOCKED;
               }
               else
               {
                  _loc7_ = this.mPurchaseAvailability.GetItemPurchasabilityStatus(_loc5_);
                  switch(_loc7_)
                  {
                     case PurchaseAvailabilityData.PURCHASABLE:
                        _loc6_.color = BuildBuyMagalogTunables.SHOWCASE_HIGHLIGHT_DEFAULT;
                        break;
                     case PurchaseAvailabilityData.INSUFFICIENT_FUNDS:
                        _loc6_.color = BuildBuyMagalogTunables.SHOWCASE_HIGHLIGHT_CANNOT_AFFORD;
                        break;
                     case PurchaseAvailabilityData.LEVEL_RESTRICTED:
                     case PurchaseAvailabilityData.WALL_HEIGHT_RESTRICTED:
                     default:
                        _loc6_.color = BuildBuyMagalogTunables.SHOWCASE_HIGHLIGHT_CANNOT_PLACE;
                  }
               }
               this.mcImageOverlayNorm.transform.colorTransform = _loc6_;
            }
         }
         else
         {
            this.mImageProduct = null;
            this.mcProductInfoPanel.Hide();
         }
      }
      
      protected function OnMouseOutImage(param1:MouseEvent) : void
      {
         Cursors.SetCursor(null);
         CommunicationManager.CallGameService("BBMagalogMouseCommand",{
            "mouseX":this.mcImage.width + 1,
            "mouseY":0
         });
         this.mImageProduct = null;
         this.mcProductInfoPanel.Hide();
      }
      
      protected function OnClickImage(param1:MouseEvent) : void
      {
         var _loc3_:ProductFilter = null;
         var _loc4_:BuildBuyCenterAdapterBase = null;
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx != MouseEventEx.LEFT_BUTTON)
         {
            return;
         }
         if(Boolean(this.mImageProduct) && this.mPurchaseAvailability.IsItemPurchasable(this.mImageProduct))
         {
            this.PurchaseItem(this.mImageProduct);
            if(SystemUtils.UsingController)
            {
               _loc3_ = new ProductFilter(CommunicationManager.CallGameService("BBGetProductFilter",this.mImageProduct.resourceKey.ToObject()));
               _loc4_ = BuildBuyCenterAdapterBase.GetAdapterForProduct(_loc3_,true);
               this.EnterPlaceMode(_loc4_);
               this.mcBackground.gotoAndPlay(BACKGROUND_IN);
            }
         }
      }
      
      protected function OnDoubleClickImage(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx != MouseEventEx.LEFT_BUTTON)
         {
            return;
         }
         Ticker.Remove(this);
         if(this.mImageProduct)
         {
            if(this.mPurchaseAvailability.IsItemPurchasable(this.mImageProduct))
            {
               this.PurchaseItem(this.mImageProduct);
               this.mImageProduct = null;
            }
         }
      }
      
      protected function set ProductPrice(param1:String) : void
      {
         var _loc2_:TextField = this.mcPrice.getChildByName("txtPrice") as TextField;
         _loc2_.htmlText = param1;
      }
      
      override public function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         var _loc4_:TweenParams = null;
         var _loc5_:TweenParams = null;
         if(this.mTweenIn)
         {
            return 0;
         }
         _loc4_ = WindowAnimation.PANEL_LARGE_VERT_IN;
         this.mTweenIn = Tween.AnimateClip(0,_loc4_,this,GetRect(),new Point(0.5,1));
         this.mTweenIn.addEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenInComplete,false,0,true);
         _loc5_ = WindowAnimation.CONTENT_FADE_IN;
         var _loc6_:int = _loc4_.duration - _loc5_.duration;
         Tween.AnimateClip(_loc6_,_loc5_,this.mcImage,this.mcImage.getRect(this));
         return _loc4_.duration;
      }
      
      protected function OnTweenInComplete(param1:TweenEvent) : void
      {
         this.mTweenIn.removeEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenInComplete);
         this.mTweenIn = null;
         if(SystemUtils.UsingController)
         {
            this.SetupRoomVCRestraints();
         }
      }
      
      protected function InitGamepad() : void
      {
         this.mFeed.addEventListener(DataFeedEvent.ADD,this.HandleFeedPopulated,false,0,true);
         this.mInputAdapter.OnInputEventCall(InputAdapterEvent.CONFIRM,this.HandleConfirmInput);
         this.mcBackground.addEventListener(HighlightRequestEvent.HIGHLIGHT_REQUEST,this.HandleBackgroundHighlight);
         this.mRoomInput.SetMouseButtonActions(VirtualCursorInputAdapter.MOUSEACTION_CLICK).OnInputEventCall(InputAdapterEvent.BACK,NavManager.Instance.FocusBack);
         this.mRoomInput.SetUpdateRestraintsCallback(this.SetupRoomVCRestraints);
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return this.mInputAdapter.Enter(param1);
      }
      
      public function Exit() : void
      {
         this.mInputAdapter.Exit();
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         return this.mInputAdapter.OnInputEventCall(param1,param2);
      }
      
      protected function HandleFeedPopulated(param1:DataFeedEvent) : void
      {
         var _loc4_:IView = null;
         var _loc2_:Vector.<IView> = this.mGridLayout.GetAllCells();
         var _loc3_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         _loc3_.push(this.btnBuy);
         for each(_loc4_ in _loc2_)
         {
            _loc3_.push(_loc4_ as DisplayObject);
         }
         _loc3_.push(this.mcBackground);
         this.mInputAdapter.SetElements(_loc3_);
      }
      
      protected function HandleBackgroundHighlight(param1:HighlightRequestEvent) : void
      {
         if(param1.shouldHighlight)
         {
            this.mcBackground.gotoAndPlay(BACKGROUND_OVER);
         }
         else
         {
            this.mcBackground.gotoAndPlay(BACKGROUND_UP);
         }
      }
      
      protected function OnEnterPlaceMode() : void
      {
         this.mbGamepadTogglingToCursor = false;
         CommunicationManager.AddMessageListenerByName("BBArchitectureReleased",this.HandleConfirmFromPlaceModeCursor,"Showcase");
         CommunicationManager.AddMessageListenerByName("BBUserToolCanceled",this.HandleBackFromPlaceModeCursor,"Showcase");
         CommunicationManager.AddMessageListenerByName("CursorModeToggled",this.HandleCursorModeToggled,"Showcase");
         CommunicationManager.AddMessageListenerByName("BBShowProductInfo",this.HandleProductChangedInPlaceModeCursor,"Showcase");
      }
      
      protected function HandlePlaceModeExit() : void
      {
         CommunicationManager.RemoveMessageListenerByName("BBArchitectureReleased",this.HandleConfirmFromPlaceModeCursor,"Showcase");
         CommunicationManager.RemoveMessageListenerByName("BBUserToolCanceled",this.HandleBackFromPlaceModeCursor,"Showcase");
         CommunicationManager.RemoveMessageListenerByName("CursorModeToggled",this.HandleCursorModeToggled,"Showcase");
         CommunicationManager.RemoveMessageListenerByName("BBShowProductInfo",this.HandleProductChangedInPlaceModeCursor,"Showcase");
      }
      
      protected function HandleBackFromPlaceModeCursor() : void
      {
         if(Boolean(this.mPlaceModeInput) && this.mPlaceModeInput.mbShouldSwitchBackToMainAdapterWhenObjectDeselected)
         {
            return;
         }
         if(!this.mbGamepadTogglingToCursor)
         {
            CatalogProduct.ClearSelection();
         }
         CommunicationManager.SendUIMessage("ShowBuildBuyMagalog",{"restoreShowcase":!this.mbGamepadTogglingToCursor});
         if(this.mPlaceModeInput)
         {
            NavManager.Instance.TryFocusBack(this.mPlaceModeInput);
         }
      }
      
      protected function HandleCursorModeToggled() : void
      {
         this.mbGamepadTogglingToCursor = true;
         CommunicationManager.RemoveMessageListener("CursorModeToggled",this.HandleCursorModeToggled,this);
      }
      
      protected function HandleConfirmFromPlaceModeCursor() : void
      {
         if(this.mPlaceModeInput)
         {
            NavManager.Instance.TryFocusBack(this.mPlaceModeInput);
         }
         NavManager.Instance.TryFocusBack(this.mInputAdapter);
         Ticker.Add(this.ConfirmFromPlaceModeTickerObj,1,this.CancelUserTool);
      }
      
      protected function HandleProductChangedInPlaceModeCursor(param1:Object) : void
      {
         if(!param1)
         {
            this.HandleBackFromPlaceModeCursor();
         }
      }
      
      protected function CancelUserTool() : void
      {
         CommunicationManager.CallGameService("BBCancelUserTool");
      }
      
      protected function HandleConfirmInput(param1:InputAdapterConfirmEvent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.GetObjName() == this.btnBuy.name && this.btnBuy.enabled)
         {
            _loc2_ = false;
            this.EnterPlaceMode(new BuildBuyCenterProductSelectedAdapter(_loc2_));
         }
         else if(param1.GetObjName() == this.mcBackground.name)
         {
            this.SetupRoomVCRestraints();
            this.mRoomInput.CenterVirtualCursor();
            NavManager.Instance.FocusForward(this.mRoomInput);
            this.mcBackground.gotoAndPlay(BACKGROUND_IN);
         }
      }
      
      protected function SetupRoomVCRestraints() : void
      {
         var _loc1_:Rectangle = this.mcBackground.getBounds(stage);
         this.mRoomInput.SetRestraints(new Rectangle(_loc1_.x + 1,_loc1_.y + 1,_loc1_.width - 2,_loc1_.height - 2));
      }
      
      protected function EnterPlaceMode(param1:BuildBuyCenterAdapterBase) : void
      {
         this.mPlaceModeInput = param1;
         this.mPlaceModeInput.OnExitedCall(this.HandlePlaceModeExit);
         this.mPlaceModeInput.OnEnteredCall(this.OnEnterPlaceMode);
         NavManager.Instance.FocusForward(this.mPlaceModeInput,{"WidgetName":"BuildBuyMagalog"});
         this.mPlaceModeInput.CenterVirtualCursor();
         this.Hide();
      }
      
      public function ShouldRegisterSharedActions() : Boolean
      {
         return !(NavManager.Instance.CurrentFocusable == this.mInputAdapter || NavManager.Instance.CurrentFocusable == this.mRoomInput || NavManager.Instance.CurrentFocusable == this.mPlaceModeInput);
      }
      
      protected function HandleUsingControllerToggled(param1:Object) : void
      {
         if(SystemUtils.UsingController)
         {
            this.Hide();
         }
      }
   }
}

