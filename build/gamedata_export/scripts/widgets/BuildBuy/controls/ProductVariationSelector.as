package widgets.BuildBuy.controls
{
   import flash.display.MovieClip;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import olympus.constants.Alignment;
   import olympus.controls.GUIComponent;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.GridInputAdapter;
   import olympus.io.CommunicationManager;
   import olympus.layout.GridLayout;
   import olympus.utils.SystemUtils;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.data.VariationDataFeed;
   import widgets.shared.controls.VariationGrid;
   import widgets.shared.events.ColorSwatchEvent;
   
   public class ProductVariationSelector extends GUIComponent implements IInputAdapter
   {
      
      public var mcColorGrid:VariationGrid;
      
      public var mcBg:MovieClip;
      
      public var mcArrow:MovieClip;
      
      protected var mColorDataFeed:VariationDataFeed;
      
      protected var mOriginalVariantId:String;
      
      protected var mProduct:CatalogProduct;
      
      protected var mInputAdapter:GridInputAdapter;
      
      public function ProductVariationSelector()
      {
         super();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         var _loc1_:VariationGrid = this.mcColorGrid;
         _loc1_.mPrimaryExpandDirection = Alignment.RIGHT;
         _loc1_.mSecondaryExpandDirection = Alignment.RIGHT;
         _loc1_.mNumThumbnailsInRow = BBTunables.VARIATION_GRID_EXPANDED_MAX_COLUMNS;
         _loc1_.mThumbnailMargin = BBTunables.VARIATION_GRID_EXPANDED_IN_WORLD_PADDING;
         _loc1_.mThumbnailGridMargin = BBTunables.VARIATION_GRID_EXPANDED_IN_WORLD_GRID_PADDING;
         _loc1_.mcBackground.visible = false;
         this.mColorDataFeed = new VariationDataFeed();
         _loc1_.addEventListener(ColorSwatchEvent.VARIATION_SELECTED,this.OnSelectColorVariation,false,0,true);
         _loc1_.addEventListener(ColorSwatchEvent.VARIATION_ROLL_OVER,this.OnRollOverColorVariation,false,0,true);
         _loc1_.addEventListener(ColorSwatchEvent.VARIATION_ROLL_OUT,this.OnRollOutColorVariation,false,0,true);
      }
      
      public function Show(param1:CatalogProduct) : void
      {
         this.visible = true;
         this.mProduct = param1;
         this.mColorDataFeed.LoadProductVariations(param1,true);
         var _loc2_:String = param1.resourceKey.instance;
         this.mOriginalVariantId = _loc2_;
         var _loc3_:VariationGrid = this.mcColorGrid;
         _loc3_.SetDataFeed(this.mColorDataFeed,_loc2_);
         _loc3_.ShowSelectionGrid();
         var _loc4_:MovieClip = this.mcBg;
         _loc4_.width = _loc3_.width;
         _loc4_.height = _loc3_.height;
         this.mcArrow.x = Math.floor(_loc4_.x + 0.5 * (_loc4_.width - this.mcArrow.width));
         this.mcArrow.y = _loc4_.height;
         if(SystemUtils.UsingController)
         {
            this.mInputAdapter.SetGridLayout(this.mcColorGrid.Grid.mGridLayout as GridLayout);
         }
      }
      
      public function Hide() : void
      {
         this.visible = false;
         CommunicationManager.CallGameService("UnbindDisplayObject",{"displayObject":this});
         this.mOriginalVariantId = null;
         if(SystemUtils.UsingController)
         {
            this.Exit();
         }
      }
      
      protected function OnRollOverColorVariation(param1:ColorSwatchEvent) : void
      {
         Ticker.Remove(this);
         CommunicationManager.CallGameService("BBObjectSwap",{
            "variantId":param1.swatchData.dataID,
            "bFinalize":false
         });
      }
      
      protected function OnRollOutColorVariation(param1:ColorSwatchEvent) : void
      {
         if(visible)
         {
            Ticker.Add(this,BBTunables.VARIATION_GRID_IN_WORLD_ROLL_OUT_DELAY,this.RevertToOriginalProduct);
         }
      }
      
      protected function RevertToOriginalProduct(param1:TickerEvent) : void
      {
         if(this.mOriginalVariantId)
         {
            CommunicationManager.CallGameService("BBObjectSwap",{
               "variantId":this.mOriginalVariantId,
               "bFinalize":false
            });
         }
      }
      
      protected function OnSelectColorVariation(param1:ColorSwatchEvent) : void
      {
         param1.stopPropagation();
         CommunicationManager.CallGameService("BBObjectSwap",{
            "variantId":param1.swatchData.dataID,
            "bFinalize":true
         });
         param1.bCloseSelector = true;
         this.dispatchEvent(param1);
      }
      
      protected function InitGamepad() : void
      {
         this.mInputAdapter = new GridInputAdapter(null);
         this.mInputAdapter.OnEnteredCall(this.HandleAdapterEnter);
         this.mInputAdapter.OnExitedCall(this.HandleAdapterExit);
         this.mInputAdapter.OnConfirmCall(this.HandleAdapterConfirm);
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.mInputAdapter.Enter(param1);
         if(this.mProduct != null)
         {
            this.Show(this.mProduct);
         }
         if(this.mOriginalVariantId)
         {
            this.mInputAdapter.SetHighlightedIndex(this.mColorDataFeed.GetItemIndexByFieldName("dataID",this.mOriginalVariantId));
         }
         return this;
      }
      
      public function Exit() : void
      {
         this.mInputAdapter.Exit();
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         this.mInputAdapter.OnInputEventCall(param1,param2);
         return this;
      }
      
      protected function HandleAdapterEnter() : void
      {
         CommunicationManager.AddMessageListener("CursorModeToggled",this.HandleCursorModeToggled,this);
         NavManager.Instance.SetForceRotateZoomAllowed(true);
      }
      
      protected function HandleAdapterExit() : void
      {
         CommunicationManager.RemoveMessageListener("CursorModeToggled",this.HandleCursorModeToggled,this);
         NavManager.Instance.SetForceRotateZoomAllowed(false);
      }
      
      protected function HandleAdapterConfirm() : void
      {
         NavManager.Instance.TryFocusBack(this);
      }
      
      protected function HandleCursorModeToggled() : void
      {
         this.Hide();
      }
   }
}

