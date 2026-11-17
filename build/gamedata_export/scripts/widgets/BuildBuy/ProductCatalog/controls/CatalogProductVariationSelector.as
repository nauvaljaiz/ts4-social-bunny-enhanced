package widgets.BuildBuy.ProductCatalog.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import olympus.constants.Alignment;
   import olympus.constants.InputActionPriorities;
   import olympus.constants.KeyCodes;
   import olympus.controllers.SelectableGroup;
   import olympus.controls.objects.MenuItem;
   import olympus.core.UISettings;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.AudioExtension;
   import olympus.extensions.DataExtension;
   import olympus.extensions.Selectability;
   import olympus.extensions.TooltipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.gui.buttons.Button;
   import olympus.input.IInputAdapter;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.DynamicOmnidirectionalAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysBB;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.SystemUtils;
   import widgets.BuildBuy.ProductCatalog.constants.BuildBuyProductCatalogTunables;
   import widgets.BuildBuy.constants.ActionModes;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.constants.ProductStateUsage;
   import widgets.BuildBuy.controls.ProductCatalogCellView;
   import widgets.BuildBuy.controls.ProductVariationSelector;
   import widgets.BuildBuy.data.CatalogData;
   import widgets.BuildBuy.data.VariationDataFeed;
   import widgets.shared.controls.VariationGrid;
   import widgets.shared.controls.VariationStackContainer;
   import widgets.shared.data.ColorSwatchData;
   import widgets.shared.events.ColorSwatchEvent;
   
   public class CatalogProductVariationSelector extends ProductVariationSelector
   {
      
      public var mcProductShapes:MovieClip;
      
      public var btnCounterMode:Button;
      
      protected var mTargetRenderer:ProductCatalogCellView;
      
      protected var mProductStateIndex:uint = 0;
      
      protected var mSwatchData:ColorSwatchData = new ColorSwatchData(null);
      
      protected var mShapeGroup:SelectableGroup;
      
      protected var mEnabledShapeButtons:Vector.<Button>;
      
      protected var mEscKeyAction:InputAction;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mCounterModeInput:BidirectionalGroupAdapter;
      
      protected var mProductShapesInput:DynamicOmnidirectionalAdapter;
      
      public function CatalogProductVariationSelector()
      {
         super();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mCounterModeInput = new BidirectionalGroupAdapter();
            this.mProductShapesInput = new DynamicOmnidirectionalAdapter(null);
         }
      }
      
      override protected function ConfigUI() : void
      {
         var _loc2_:VariationGrid = null;
         super.ConfigUI();
         this.mShapeGroup = new SelectableGroup();
         this.mEnabledShapeButtons = new Vector.<Button>();
         var _loc1_:Boolean = Boolean(UISettings.AccountSettings.GetValue("BBIsCounterSelectionManual"));
         this.btnCounterMode.Selected = !_loc1_;
         this.btnCounterMode.addEventListener(PushButtonEvent.CLICK,this.OnCounterModeClick,false,0,true);
         if(_loc1_)
         {
            this.btnCounterMode.TooltipExt.SetText(KeysBB.BB_COUNTER_TOOLTIP_COUNTER_MANUAL_PLACE);
         }
         else
         {
            this.btnCounterMode.TooltipExt.SetText(KeysBB.BB_COUNTER_TOOLTIP_COUNTER_AUTO_PLACE);
         }
         _loc2_ = mcColorGrid;
         _loc2_.mSecondaryExpandDirection = Alignment.BOTTOM;
         _loc2_.mNumThumbnailsInRow = BBTunables.VARIATION_GRID_EXPANDED_MAX_ROWS;
         _loc2_.mThumbnailMargin = BBTunables.VARIATION_GRID_EXPANDED_CATALOG_PADDING;
         _loc2_.mThumbnailGridMargin = BBTunables.VARIATION_GRID_EXPANDED_CATALOG_GRID_PADDING;
         _loc2_.mcBackground.visible = true;
         this.mEscKeyAction = InputAction.WhenTriggered(InputTrigger.FromKeyBinding(KeyCodes.ESC)).CallFunction(this.HandleEscapeKey).SetPriority(InputActionPriorities.ESC_DROPDOWN_MENU);
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mAudioExtension.ElementName = "ProductVariationSelector";
         this.mAudioExtension.CategoryName = "PopUp";
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepadInput();
         }
      }
      
      public function get TargetRenderer() : ProductCatalogCellView
      {
         return this.mTargetRenderer;
      }
      
      public function set TargetRenderer(param1:ProductCatalogCellView) : void
      {
         this.mTargetRenderer = param1;
      }
      
      public function get Product() : CatalogProduct
      {
         return mProduct;
      }
      
      public function set ColorDataFeed(param1:VariationDataFeed) : void
      {
         mColorDataFeed = param1;
      }
      
      override public function Show(param1:CatalogProduct) : void
      {
         var _loc3_:VariationGrid = null;
         var _loc7_:Button = null;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         var _loc10_:Vector.<Button> = null;
         var _loc11_:Array = null;
         var _loc12_:MenuItem = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:Button = null;
         var _loc2_:ProductCatalogCellView = this.mTargetRenderer;
         this.Hide();
         this.visible = true;
         mProduct = param1;
         this.mProductStateIndex = param1.stateIndex;
         this.mTargetRenderer = _loc2_;
         _loc3_ = mcColorGrid;
         mColorDataFeed.DeselectAll();
         _loc3_.SetDataFeed(mColorDataFeed,param1.resourceKey.instance);
         _loc3_.ShowSelectionGrid();
         var _loc4_:Array = mColorDataFeed.GetSelectedItems();
         this.mSwatchData = _loc4_.length ? _loc4_[0] : null;
         var _loc5_:ProductCatalogCellView = this.mTargetRenderer;
         var _loc6_:Rectangle = _loc5_.getRect(this);
         _loc3_.x = _loc6_.x - _loc3_.width - BuildBuyProductCatalogTunables.CATALOG_VARIATION_SELECTOR_COLOR_GRID_MARGIN.mRight;
         _loc3_.y = _loc6_.y;
         if(param1.HasStateUsageVariants())
         {
            _loc7_ = this.btnCounterMode;
            _loc7_.visible = true;
            _loc7_.x = _loc3_.x - _loc7_.mcHitArea.width;
            _loc7_.y = _loc3_.y - _loc3_.mThumbnailGridMargin.mTop;
            _loc8_ = this.mcProductShapes;
            _loc9_ = param1.stateUsage;
            _loc8_.gotoAndStop("state" + _loc9_);
            _loc8_.x = _loc7_.x - _loc8_.width - BuildBuyProductCatalogTunables.CATALOG_VARIATION_SELECTOR_AUTO_COUNTER_MARGIN.mLeft;
            _loc8_.y = _loc7_.y;
            _loc10_ = this.mEnabledShapeButtons;
            _loc11_ = this.GetProductStates(param1);
            for each(_loc12_ in _loc11_)
            {
               _loc14_ = _loc12_.data as int;
               _loc15_ = _loc8_.getChildByName("btn_" + _loc9_ + "_" + _loc14_) as Button;
               (_loc15_.GetExtension(TooltipExtension) as TooltipExtension).Text = _loc12_.tooltipText;
               _loc15_.enabled = _loc12_.enabled;
               if(_loc12_.enabled)
               {
                  (_loc15_.GetExtension(DataExtension) as DataExtension).Data = _loc14_;
                  this.mShapeGroup.Add(_loc15_,true);
                  if(_loc14_ == param1.stateIndex)
                  {
                     this.mShapeGroup.SetSelectionAs(_loc15_,true,false);
                  }
                  _loc10_.push(_loc15_);
                  _loc15_.addEventListener(MouseEvent.ROLL_OVER,this.OnProductShapeRollOver,false,0,true);
                  _loc15_.addEventListener(MouseEvent.ROLL_OUT,this.OnProductShapeRollOut,false,0,true);
                  _loc15_.addEventListener(PushButtonEvent.CLICK,this.OnProductShapeClick,false,0,true);
               }
            }
            _loc13_ = CatalogData.GetAutoShapeSetting(_loc9_).data;
            this.UpdateCounterDisplayMode(UISettings.AccountSettings.GetValue(_loc13_.settingsFlag));
         }
         else
         {
            this.btnCounterMode.visible = false;
         }
         InputActionManager.RegisterAction(this.mEscKeyAction);
         stage.focus = this;
         stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.OnFocusChange,false,0,false);
         this.mAudioExtension.DispatchShow();
         if(SystemUtils.UsingController)
         {
            mInputAdapter.SetGridLayout(mcColorGrid.Grid.mGridLayout as GridLayout);
         }
      }
      
      override public function Hide() : void
      {
         var _loc1_:VariationStackContainer = null;
         var _loc2_:Vector.<Button> = null;
         var _loc3_:Button = null;
         if(!mbInitialized)
         {
            return;
         }
         if(!this.visible)
         {
            return;
         }
         this.visible = this.mcProductShapes.visible = false;
         mProduct = null;
         if(this.mTargetRenderer)
         {
            _loc1_ = this.mTargetRenderer.btnSwatchContainer;
            if(stage == null || !this.mTargetRenderer.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               _loc1_.visible = false;
               _loc1_.VariationStack.HideGrid();
            }
            else
            {
               _loc1_.visible = true;
               _loc1_.VariationStack.ShowGrid();
               _loc1_.RefreshLayout();
            }
         }
         if(this.mShapeGroup)
         {
            _loc2_ = this.mEnabledShapeButtons;
            for each(_loc3_ in _loc2_)
            {
               _loc3_.removeEventListener(MouseEvent.ROLL_OVER,this.OnProductShapeRollOver);
               _loc3_.removeEventListener(MouseEvent.ROLL_OUT,this.OnProductShapeRollOut);
               _loc3_.removeEventListener(PushButtonEvent.CLICK,this.OnProductShapeClick);
            }
            _loc2_.length = 0;
            this.mShapeGroup.ClearSelection();
            this.mShapeGroup.RemoveAll();
         }
         this.mTargetRenderer = null;
         if(stage)
         {
            stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.OnFocusChange);
         }
         InputActionManager.UnregisterAction(this.mEscKeyAction);
         this.mAudioExtension.DispatchHide();
      }
      
      override protected function OnRollOverColorVariation(param1:ColorSwatchEvent) : void
      {
         var _loc3_:ColorSwatchEvent = null;
         var _loc2_:CatalogProduct = param1.swatchData.productBB;
         _loc2_.stateIndex = this.mProductStateIndex;
         if(Boolean(_loc2_) && Boolean(this.mTargetRenderer))
         {
            this.mTargetRenderer.Draw(_loc2_);
            _loc3_ = param1.clone() as ColorSwatchEvent;
            dispatchEvent(_loc3_);
         }
      }
      
      override protected function OnRollOutColorVariation(param1:ColorSwatchEvent) : void
      {
         var _loc2_:ColorSwatchEvent = null;
         if(Boolean(mProduct) && Boolean(this.mTargetRenderer))
         {
            this.mTargetRenderer.Draw(mProduct);
            _loc2_ = param1.clone() as ColorSwatchEvent;
            dispatchEvent(_loc2_);
         }
      }
      
      override protected function OnSelectColorVariation(param1:ColorSwatchEvent) : void
      {
         param1.stopPropagation();
         this.mSwatchData = param1.swatchData;
         var _loc2_:CatalogProduct = param1.swatchData.productBB;
         this.mTargetRenderer.Draw(_loc2_);
         var _loc3_:ColorSwatchEvent = param1.clone() as ColorSwatchEvent;
         if(SystemUtils.UsingController)
         {
            _loc3_.bCloseSelector = !param1.bShapeChanged;
         }
         else
         {
            _loc3_.bCloseSelector = !this.mcProductShapes.visible;
         }
         _loc3_.stateIndex = this.mProductStateIndex;
         dispatchEvent(_loc3_);
         if(mcColorGrid.GetSelectedIndices().length == 0)
         {
            mcColorGrid.SelectProductById(param1.dataID,false);
         }
         mProduct = _loc2_;
      }
      
      protected function OnProductShapeRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Button = param1.target as Button;
         mProduct.stateIndex = (_loc2_.GetExtension(DataExtension) as DataExtension).Data as uint;
         this.mTargetRenderer.Draw(mProduct);
         var _loc3_:ColorSwatchEvent = new ColorSwatchEvent(ColorSwatchEvent.VARIATION_ROLL_OVER,false,false,this.mSwatchData);
         _loc3_.swatchData.productBB = mProduct;
         dispatchEvent(_loc3_);
      }
      
      protected function OnProductShapeRollOut(param1:MouseEvent) : void
      {
         var _loc2_:Button = param1.target as Button;
         mProduct.stateIndex = this.mProductStateIndex;
         this.mTargetRenderer.Draw(mProduct);
         var _loc3_:ColorSwatchEvent = new ColorSwatchEvent(ColorSwatchEvent.VARIATION_ROLL_OUT,false,false,this.mSwatchData);
         _loc3_.swatchData.productBB = mProduct;
         dispatchEvent(_loc3_);
      }
      
      protected function OnProductShapeClick(param1:PushButtonEvent) : void
      {
         var _loc2_:Button = param1.target as Button;
         this.mProductStateIndex = (_loc2_.GetExtension(DataExtension) as DataExtension).Data as int;
         var _loc3_:ColorSwatchEvent = new ColorSwatchEvent(ColorSwatchEvent.VARIATION_SELECTED);
         var _loc4_:ColorSwatchData = this.mSwatchData;
         _loc3_.swatchData = _loc4_;
         _loc3_.stateIndex = this.mProductStateIndex;
         _loc3_.bShapeChanged = true;
         dispatchEvent(_loc3_);
      }
      
      protected function OnCounterModeClick(param1:PushButtonEvent) : void
      {
         var _loc2_:Selectability = null;
         _loc2_ = this.btnCounterMode.GetExtension(Selectability) as Selectability;
         var _loc3_:Boolean = !_loc2_.Selected;
         this.UpdateCounterDisplayMode(_loc3_);
         CommunicationManager.SendUIMessage("BBUpdateCounterMode",{
            "manualMode":_loc3_,
            "stateUsage":mProduct.stateUsage
         });
      }
      
      protected function UpdateCounterDisplayMode(param1:Boolean) : void
      {
         this.btnCounterMode.Selected = param1;
         this.mcProductShapes.visible = param1;
         var _loc2_:Object = CatalogData.GetAutoShapeSetting(mProduct.stateUsage).data;
         if(param1)
         {
            this.btnCounterMode.TooltipExt.SetText(_loc2_.tooltipManual);
         }
         else
         {
            this.btnCounterMode.TooltipExt.SetText(_loc2_.tooltipAuto);
            this.mProductStateIndex = 0;
         }
      }
      
      protected function OnFocusChange(param1:FocusEvent) : void
      {
         if(!DisplayObjectUtils.IsParent(this,param1.relatedObject) && !DisplayObjectUtils.IsParent(this.mTargetRenderer,param1.relatedObject))
         {
            this.Hide();
         }
      }
      
      protected function HandleEscapeKey() : Boolean
      {
         var _loc1_:int = CommunicationManager.CallUIService("BBGetActionMode") as int;
         if(_loc1_ == ActionModes.HIDDEN)
         {
            this.Hide();
            return false;
         }
         return true;
      }
      
      protected function GetProductStates(param1:CatalogProduct) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:MenuItem = null;
         var _loc2_:Array = CommunicationManager.CallGameService("BBGetProductStates",param1.resourceKey.ToObject()) as Array;
         if(!_loc2_)
         {
            return null;
         }
         switch(param1.stateUsage)
         {
            case ProductStateUsage.COUNTER:
               _loc3_ = CatalogData.COUNTER_SHAPES;
               break;
            case ProductStateUsage.ISLAND_COUNTER:
               _loc3_ = CatalogData.ISLAND_COUNTER_SHAPES;
               break;
            case ProductStateUsage.CABINET:
               _loc3_ = CatalogData.CABINET_SHAPES;
               break;
            case ProductStateUsage.SIT_SECTIONAL:
               _loc3_ = CatalogData.SIT_SECTIONAL_SHAPES;
               break;
            case ProductStateUsage.CHAISE_LOUNGE:
               _loc3_ = CatalogData.SIT_LOUNGE_CHAISE_SHAPES;
               break;
            case ProductStateUsage.BED_BUNK:
               _loc3_ = CatalogData.BED_BUNK_SHAPES;
               break;
            default:
               throw new Error("Product state usage is not mapped to any catalog menu item data! Product.stateUsage: " + param1.stateUsage);
         }
         for each(_loc4_ in _loc3_)
         {
            _loc4_.enabled = _loc2_.indexOf(_loc4_.data as int) != -1;
         }
         return _loc3_;
      }
      
      protected function InitGamepadInput() : void
      {
         mInputAdapter.OnLeaveCall(this.HandleLeaveVariation);
         this.mCounterModeInput.SetElements(new <DisplayObject>[this.btnCounterMode]);
         this.mCounterModeInput.OnInputEventCall(InputAdapterEvent.LEAVE,this.HandleLeaveCounterMode);
         this.mProductShapesInput.SetContainer(this.mcProductShapes);
         this.mProductShapesInput.OnInputEventCall(InputAdapterEvent.LEAVE,this.HandleLeaveProductShapes);
      }
      
      override public function Exit() : void
      {
         super.Exit();
         this.mCounterModeInput.Exit();
         this.mProductShapesInput.Exit();
      }
      
      override public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         super.OnInputEventCall(param1,param2);
         if(param1 == InputAdapterEvent.BACK)
         {
            this.mCounterModeInput.OnInputEventCall(param1,param2);
            this.mProductShapesInput.OnInputEventCall(param1,param2);
         }
         return this;
      }
      
      protected function HandleLeaveVariation(param1:InputAdapterLeaveEvent) : void
      {
         var _loc2_:EnterParams = new EnterParams(param1.GetDirection(),param1.GetFromPosition());
         if(param1.GetDirection() == NavDirection.LEFT && this.btnCounterMode.visible)
         {
            mInputAdapter.Exit();
            this.mCounterModeInput.Enter(_loc2_);
         }
      }
      
      protected function HandleLeaveCounterMode(param1:InputAdapterLeaveEvent) : void
      {
         var _loc2_:EnterParams = new EnterParams(param1.GetDirection(),param1.GetFromPosition());
         if(param1.GetDirection() == NavDirection.RIGHT)
         {
            this.mCounterModeInput.Exit();
            mInputAdapter.Enter(_loc2_);
         }
         else if(param1.GetDirection() == NavDirection.LEFT && this.mcProductShapes.visible)
         {
            this.mCounterModeInput.Exit();
            this.mProductShapesInput.Enter(_loc2_);
         }
      }
      
      protected function HandleLeaveProductShapes(param1:InputAdapterLeaveEvent) : void
      {
         var _loc2_:EnterParams = new EnterParams(param1.GetDirection(),param1.GetFromPosition());
         if(param1.GetDirection() == NavDirection.RIGHT)
         {
            this.mProductShapesInput.Exit();
            this.mCounterModeInput.Enter(_loc2_);
         }
      }
   }
}

