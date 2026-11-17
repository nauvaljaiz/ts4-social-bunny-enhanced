package widgets.BuildBuy.Magalog
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import gamedata.BuildBuy.constants.FilterCategories;
   import gamedata.BuildBuy.constants.ProductTypes;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductFilter;
   import gamedata.Exchange.ExchangeData;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.ResourceKey;
   import olympus.constants.ActionCodes;
   import olympus.constants.GameStateFlags;
   import olympus.constants.GameStates;
   import olympus.controllers.SelectableGroup;
   import olympus.controls.objects.MenuItem;
   import olympus.core.ExtendableComponent;
   import olympus.core.PopUpManager;
   import olympus.core.Ticker;
   import olympus.core.UISettings;
   import olympus.core.widget.WidgetBase;
   import olympus.events.GenericEvent;
   import olympus.events.GridEvent;
   import olympus.events.PushButtonEvent;
   import olympus.events.SelectableGroupEvent;
   import olympus.events.TickerEvent;
   import olympus.extensions.TutorialTipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.Button;
   import olympus.gui.grids.SelectionGrid;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterFactory;
   import olympus.io.CommunicationManager;
   import olympus.io.TelemetryManager;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysBB;
   import olympus.localization.KeysConsole;
   import olympus.utils.SystemUtils;
   import olympus.utils.TuningTagsUtils;
   import olympus.views.GridView;
   import widgets.BuildBuy.Magalog.constants.BuildBuyMagalogTunables;
   import widgets.BuildBuy.Magalog.controls.MagalogPanel;
   import widgets.BuildBuy.Magalog.controls.MagalogSharedRoomInfoPanel;
   import widgets.BuildBuy.Magalog.controls.Showcase;
   import widgets.BuildBuy.constants.ActionModes;
   import widgets.BuildBuy.constants.BBTunables;
   import widgets.BuildBuy.controls.CategoryGrid;
   import widgets.BuildBuy.controls.ProductInfoPanel;
   import widgets.BuildBuy.data.CatalogData;
   import widgets.BuildBuy.data.CatalogDataFeed;
   import widgets.BuildBuy.data.CategoryDataFeed;
   import widgets.BuildBuy.data.PurchaseAvailabilityData;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterProductSelectedAdapter;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterWallAdapter;
   import widgets.shared.constants.ClientTutorialTrigger;
   import widgets.shared.constants.ExchangeShareMode;
   import widgets.shared.constants.TutorialTipUIElement;
   import widgets.shared.data.ExchangeFilter;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public class BuildBuyMagalogMain extends WidgetBase
   {
      
      protected static const UI_DRIVEN:Boolean = true;
      
      protected static const CLIENT_DRIVEN:Boolean = false;
      
      protected static const ROOM_MODE:int = 1;
      
      protected static const BLOCK_MODE:int = 2;
      
      protected static const SHARED_ROOM_MODE:int = 3;
      
      public var mcRoomBackground:Sprite;
      
      public var mcBlockBackground:Sprite;
      
      public var mcTypesBackground:Sprite;
      
      public var mcMagalogPanel:MagalogPanel;
      
      public var btnBlockCategory:Button;
      
      public var btnRoomCategory:Button;
      
      public var btnSharedCategory:Button;
      
      public var mcInfoPanel:ProductInfoPanel;
      
      public var mcShowcase:Showcase;
      
      protected var mcCategoryBar:CategoryGrid;
      
      protected var mSelectModeTabGroup:SelectableGroup;
      
      protected var mCategoryFeed:CategoryDataFeed;
      
      protected var mRoomFeed:CatalogDataFeed;
      
      protected var mSelectedRoom:CatalogProduct;
      
      protected var mHeldRoom:Object;
      
      protected var mTabInput:BidirectionalGroupAdapter;
      
      protected var mCategoryBarInput:BidirectionalGroupAdapter;
      
      protected var mCurrentMode:int = 1;
      
      protected var mbRestoreShowcase:Boolean = false;
      
      protected var mShowcasePosition:Point = new Point();
      
      protected var mCatalogItemRendererClass:Class;
      
      protected var mMagalogItemRendererClass:Class;
      
      protected var mSharedRoomRendererClass:Class;
      
      protected var mMagalogInfoPanelClass:Class;
      
      protected var mSelectedObject:Object;
      
      protected var mTutorialTipsVector:Vector.<Object> = new Vector.<Object>();
      
      protected var mWallAdapter:BuildBuyCenterWallAdapter;
      
      protected var mSharedRoomCursorAdapter:BuildBuyCenterProductSelectedAdapter;
      
      public function BuildBuyMagalogMain()
      {
         super();
         this.mcCategoryBar = new CategoryGrid();
         var _loc1_:GridView = new GridView();
         this.mcCategoryBar.addChild(_loc1_);
         this.mcCategoryBar.mcGridView = _loc1_;
      }
      
      override public function Initialize() : void
      {
         var _loc1_:TutorialTipExtension = null;
         var _loc9_:int = 0;
         var _loc11_:Object = null;
         super.Initialize();
         this.mMagalogItemRendererClass = getDefinitionByName("MagalogRoomCellView") as Class;
         this.mCatalogItemRendererClass = getDefinitionByName("BBProductCatalogCellView") as Class;
         this.mSharedRoomRendererClass = getDefinitionByName("BBSharedRoomCellView") as Class;
         this.mMagalogInfoPanelClass = getDefinitionByName("BBProductInfoPanelNoImage") as Class;
         this.mSelectedObject = new Object();
         this.mSelectedObject["isSelected"] = true;
         this.mCategoryFeed = new CategoryDataFeed();
         var _loc2_:CategoryDataFeed = this.mCategoryFeed;
         _loc2_.AddItemsFromIterable(CatalogData.MAGALOG_ROOM_CATEGORIES);
         var _loc3_:SelectionGrid = this.mcCategoryBar;
         _loc3_.x = this.mcRoomBackground.x + BuildBuyMagalogTunables.MAGALOG_CATEGORYBAR_OFFSET.x;
         _loc3_.y = this.mcRoomBackground.y + BuildBuyMagalogTunables.MAGALOG_CATEGORYBAR_OFFSET.y;
         this.mRoomFeed = new CatalogDataFeed(ProductTypes.MAGAZINECOLLECTION);
         var _loc4_:MenuItem = _loc2_.RequestItemAt(0) as MenuItem;
         this.mRoomFeed.mFilterObject.categoryTags = _loc4_.data["categoryTags"];
         var _loc5_:MagalogPanel = this.mcMagalogPanel;
         _loc5_.InitializeScrollList(this.mRoomFeed,this.mMagalogItemRendererClass,BuildBuyMagalogTunables.MAGALOG_ROOM_LIST_PADDING,BuildBuyMagalogTunables.MAGALOG_LIST_DEFAULT_RENDERER_WIDTH);
         _loc5_.SetListItemListener(PushButtonEvent.CLICK,this.OnSelectRoom);
         _loc5_.SetListItemListener(PushButtonEvent.ROLL_OVER,this.OnRollOverRoom);
         _loc5_.SetListItemListener(PushButtonEvent.ROLL_OUT,this.OnRollOutRoom);
         _loc5_.SetListItemListener(MouseEvent.DOUBLE_CLICK,this.OnDoubleClickRoom);
         var _loc6_:Showcase = this.mcShowcase;
         _loc6_.addEventListener(GenericEvent.CHANGE,this.OnShowcaseChange,false,0,true);
         _loc6_.addEventListener(GenericEvent.CLOSE,this.OnShowcaseClose,false,0,true);
         _loc6_.Hide();
         this.mSelectModeTabGroup = new SelectableGroup();
         var _loc7_:SelectableGroup = this.mSelectModeTabGroup;
         _loc7_.Add(this.btnBlockCategory,true);
         _loc7_.Add(this.btnRoomCategory,true);
         _loc7_.Add(this.btnSharedCategory,true);
         _loc7_.addEventListener(SelectableGroupEvent.SELECTION_CHANGED,this.OnTabSelect,false,0,true);
         _loc7_.SetSelectionAs(this.btnRoomCategory,true,CLIENT_DRIVEN);
         this.btnBlockCategory.TooltipExt.SetText(KeysBB.BB_MAGALOG_EMPTY_ROOMS);
         _loc1_ = this.btnBlockCategory.GetExtension(TutorialTipExtension) as TutorialTipExtension;
         _loc1_.ControlEnum = TutorialTipUIElement.BB_EMPTY_ROOM;
         _loc1_.AddSatisfactionEvent(PushButtonEvent.CLICK);
         _loc1_.MarkVisibility(false);
         this.btnRoomCategory.TooltipExt.SetText(KeysBB.BB_MAGALOG_FURNISHED_ROOMS);
         _loc1_ = this.btnRoomCategory.GetExtension(TutorialTipExtension) as TutorialTipExtension;
         _loc1_.ControlEnum = TutorialTipUIElement.BB_MAGALOG_FURNISHED_ROOMS;
         _loc1_.AddSatisfactionEvent(PushButtonEvent.CLICK);
         this.mTutorialTipsVector.push({
            "extension":_loc1_,
            "control":this.btnRoomCategory
         });
         this.btnSharedCategory.TooltipExt.SetText(KeysBB.BB_MAGALOG_SHARED_ROOMS);
         _loc3_.InitializeSelectionGrid(_loc2_,getDefinitionByName("BBRoomCategoryCellView") as Class,true,BuildBuyMagalogTunables.MAGALOG_CATEGORYBAR_CELLMARGIN,new GridLayout(false,true,0),false);
         _loc3_.SetSelectionGridListener(PushButtonEvent.CLICK);
         _loc3_.addEventListener(GridEvent.SELECTION_UPDATE,this.OnCategoryClick,false,0,true);
         _loc3_.SetCellViewAudioElementName("RoomButton");
         _loc1_ = _loc3_.GetExtension(TutorialTipExtension) as TutorialTipExtension;
         _loc1_.ControlEnum = TutorialTipUIElement.BB_MAGALOG_CATEGORY;
         _loc1_.AddSatisfactionEvent(GridEvent.SELECTION_UPDATE);
         this.mTutorialTipsVector.push({
            "extension":_loc1_,
            "control":_loc3_
         });
         UISettings.SessionSettings.ActiveId = GameStates.ConvertStateIdToName(GameStates.BUILD);
         if(!SystemUtils.UsingController && UISettings.SessionSettings.GetValue("buildCategoryIndex") == null)
         {
            _loc3_.SetSelection(0,true);
         }
         addChild(_loc3_);
         AddMessageListener("BBMagalogSelectCategory",this.HandleSelectCategory);
         AddMessageListener("BBHighlightProductInCatalog",this.HandleHighlightProduct);
         AddMessageListener("BBArchitectureReleased",this.HandleRoomPlaced);
         AddMessageListener("BBActionModeChanged",this.HandleActionModeChanged);
         AddMessageListener("BBFiltersChanged",this.HandleFiltersChanged,ProductFilter);
         AddMessageListener(BuildBuyStateData.PURCHASE_AVAILABILITY_UPDATE,this.HandlePurchaseAvailabilityUpdate);
         AddMessageListener("BBMagalogResetRestore",this.HandleMagalogResetRestore);
         AddMessageListener("OnlineAccessStateChanged",this.HandleOnlineAccessStateChanged);
         AddMessageListener("DeleteExchangeItem",this.HandleUpdateExchangeItem);
         AddMessageListener("ExchangeItemDownloaded",this.HandleExchangeItemDownloaded);
         AddMessageListener("ExchangeItemSaved",this.HandleCreateExchangeItem);
         var _loc8_:Vector.<Object> = this.mTutorialTipsVector;
         var _loc10_:int = int(_loc8_.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc11_ = _loc8_[_loc9_];
            (_loc11_.extension as TutorialTipExtension).MarkVisibility(false);
            _loc9_++;
         }
         this.mcMagalogPanel.MarkVisibility(false);
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
         if(SystemUtils.UsingMouseKeyboard)
         {
            AddMessageListener("UsingControllerToggled",this.HandleUsingControllerToggled);
         }
      }
      
      override public function Show(param1:Object = null) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ProductFilter = null;
         if(GameStateFlags.IsBetweenStates)
         {
            return;
         }
         if(!visible && !SystemUtils.UsingController)
         {
            super.Show(param1);
            _loc2_ = this.mTutorialTipsVector;
            _loc4_ = int(_loc2_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_[_loc3_];
               (_loc5_.extension as TutorialTipExtension).MarkVisibility(_loc5_.control.visible);
               _loc3_++;
            }
            (this.btnBlockCategory.GetExtension(TutorialTipExtension) as TutorialTipExtension).MarkVisibility(this.btnBlockCategory.visible);
         }
         if(Boolean(param1) && Boolean(param1.xPos))
         {
            this.mcTypesBackground.x = param1.xPos;
            this.mcBlockBackground.x = this.mcRoomBackground.x = this.mcTypesBackground.x + this.mcTypesBackground.width;
            this.HandleStageResized(LayoutAPI.StageWidth,LayoutAPI.StageHeight);
         }
         if(Boolean(param1) && Boolean(param1.restoreShowcase))
         {
            if(this.mbRestoreShowcase)
            {
               this.ShowShowcase();
            }
         }
         else
         {
            if(Boolean(param1) && Boolean(param1.filter))
            {
               _loc8_ = param1.filter as ProductFilter;
               if(_loc8_.categoryTags[0] == TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK))
               {
                  _loc6_ = BLOCK_MODE;
               }
               else
               {
                  _loc6_ = ROOM_MODE;
               }
               this.mRoomFeed.mFilterObject.searchResult = _loc8_.searchResult;
            }
            else
            {
               _loc6_ = ROOM_MODE;
               this.mRoomFeed.mFilterObject.searchResult = null;
            }
            _loc7_ = UISettings.SessionSettings.GetValue("buildCategoryIndex") as int;
            if(_loc6_ == BLOCK_MODE)
            {
               this.mSelectModeTabGroup.SetSelectionAs(this.btnBlockCategory,false);
               this.mSelectModeTabGroup.SetSelectionAs(this.btnBlockCategory);
            }
            else if(_loc6_ == SHARED_ROOM_MODE)
            {
               this.mSelectModeTabGroup.SetSelectionAs(this.btnSharedCategory);
            }
            else
            {
               this.mSelectModeTabGroup.SetSelectionAs(this.btnRoomCategory);
            }
            this.mcCategoryBar.SetSelection(_loc7_);
         }
         this.mcInfoPanel.Hide();
         if(!SystemUtils.UsingController)
         {
            this.mcMagalogPanel.visible = true;
            this.mcMagalogPanel.MarkVisibility(true);
         }
         if(this.mCurrentMode == BLOCK_MODE)
         {
            this.mcBlockBackground.visible = true;
            this.mcRoomBackground.visible = false;
         }
         else
         {
            this.mcBlockBackground.visible = false;
            this.mcRoomBackground.visible = true;
         }
         this.mRoomFeed.mFilterObject.searchResult = null;
         CommunicationManager.CallGameService("TriggerClientTutorial",ClientTutorialTrigger.BB_MAGALOG,true);
      }
      
      override public function Hide(param1:Object = null) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(visible)
         {
            (this.btnBlockCategory.GetExtension(TutorialTipExtension) as TutorialTipExtension).MarkVisibility(this.btnBlockCategory.visible);
            if(Boolean(param1) && Boolean(param1.keepShowcase))
            {
               this.mcMagalogPanel.visible = this.mcCategoryBar.visible = this.mcTypesBackground.visible = this.mcRoomBackground.visible = this.mcBlockBackground.visible = false;
               this.mcMagalogPanel.MarkVisibility(false);
               this.mcInfoPanel.Hide(false);
               this.mcMagalogPanel.DeselectCurrentProduct();
            }
            else if(Boolean(param1) && Boolean(param1.minimizeShowcase))
            {
               this.mbRestoreShowcase = this.mcShowcase.visible;
               this.mcShowcase.Hide();
               this.mcInfoPanel.Hide(false);
            }
            else
            {
               super.Hide(param1);
               this.mcShowcase.Hide();
               this.mcInfoPanel.Hide();
               this.mcMagalogPanel.DeselectCurrentProduct();
               this.mcMagalogPanel.MarkVisibility(false);
               (this.btnBlockCategory.GetExtension(TutorialTipExtension) as TutorialTipExtension).MarkVisibility(false);
               if(SystemUtils.UsingController)
               {
                  this.mcMagalogPanel.GamepadHighlightFirstItem();
               }
            }
            _loc2_ = this.mTutorialTipsVector;
            _loc4_ = int(_loc2_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_[_loc3_];
               (_loc5_.extension as TutorialTipExtension).MarkVisibility(false);
               _loc3_++;
            }
            PopUpManager.Remove(this.mcShowcase);
            PopUpManager.Remove(this.mcInfoPanel);
         }
         if(SystemUtils.UsingController)
         {
            CommunicationManager.SendUIMessage("HideBuildBuyFilter");
         }
      }
      
      protected function ShowInfoPanel(param1:Sprite, param2:Object) : void
      {
         var _loc3_:ProductInfoPanel = this.mcInfoPanel;
         PopUpManager.Show(_loc3_,this);
         _loc3_.Show(param2);
         PopUpManager.Show(_loc3_,this,Math.min(this.mcMagalogPanel.x + param1.x + BuildBuyMagalogTunables.MAGALOG_INFO_PANEL_X_MARGIN,this.mcRoomBackground.x + this.mcRoomBackground.width - _loc3_.width),this.mcRoomBackground.y - this.mcInfoPanel.height);
      }
      
      protected function ShowShowcase() : void
      {
         PopUpManager.Show(this.mcShowcase,this,this.mShowcasePosition.x,this.mShowcasePosition.y);
         this.mcShowcase.Show();
         this.mbRestoreShowcase = true;
      }
      
      protected function ShowCategory(param1:int, param2:Array = null, param3:Array = null) : void
      {
         var _loc4_:Showcase = this.mcShowcase;
         var _loc5_:CatalogDataFeed = this.mRoomFeed;
         _loc5_.mFilterObject.styleResourceKeys = [];
         _loc5_.mFilterObject.productType = param1;
         _loc5_.mFilterObject.categoryTags = param2 ? param2 : [];
         _loc5_.mFilterObject.categoryPriorityTags = param3 ? param3 : [];
         if(param1 == ProductTypes.MAGAZINECOLLECTION)
         {
            if(this.mCurrentMode != ROOM_MODE)
            {
               if(this.mCurrentMode == SHARED_ROOM_MODE)
               {
                  PopUpManager.Remove(this.mcInfoPanel);
                  this.mcInfoPanel = new this.mMagalogInfoPanelClass();
                  this.mcInfoPanel.visible = false;
               }
               this.mCurrentMode = ROOM_MODE;
               this.mcMagalogPanel.ReinitializeCellView(this.mMagalogItemRendererClass,BuildBuyMagalogTunables.MAGALOG_ROOM_LIST_PADDING,BuildBuyMagalogTunables.MAGALOG_LIST_DEFAULT_RENDERER_WIDTH);
               this.mcCategoryBar.visible = true;
               this.ResizeMagalogPanel();
            }
            this.mcRoomBackground.visible = true;
            this.mcBlockBackground.visible = false;
            UISettings.SessionSettings.SetValue("buildCategoryIndex",this.mCategoryFeed.SelectedIndex);
         }
         else if(this.mCurrentMode != BLOCK_MODE)
         {
            if(this.mCurrentMode == SHARED_ROOM_MODE)
            {
               PopUpManager.Remove(this.mcInfoPanel);
               this.mcInfoPanel = new this.mMagalogInfoPanelClass();
               this.mcInfoPanel.visible = false;
            }
            this.mCurrentMode = BLOCK_MODE;
            this.mcMagalogPanel.ReinitializeCellView(this.mCatalogItemRendererClass,BuildBuyMagalogTunables.MAGALOG_BLOCK_LIST_PADDING,BBTunables.CATALOG_RENDERER_WIDTH);
            this.mcCategoryBar.visible = false;
            this.mcRoomBackground.visible = false;
            this.mcBlockBackground.visible = true;
            this.ResizeMagalogPanel();
         }
         (this.mcCategoryBar.GetExtension(TutorialTipExtension) as TutorialTipExtension).MarkVisibility(this.mcCategoryBar.visible);
         this.RequestFilteredData();
         this.mcMagalogPanel.DeselectCurrentProduct();
         _loc4_.Hide();
      }
      
      protected function ShowSharedRooms() : void
      {
         var _loc1_:MenuItem = null;
         if(this.mCurrentMode != SHARED_ROOM_MODE)
         {
            this.mCurrentMode = SHARED_ROOM_MODE;
            PopUpManager.Remove(this.mcInfoPanel);
            this.mcInfoPanel = new MagalogSharedRoomInfoPanel();
            this.mcInfoPanel.visible = false;
            this.mcMagalogPanel.ReinitializeCellView(this.mSharedRoomRendererClass,BuildBuyMagalogTunables.MAGALOG_ROOM_LIST_PADDING,BuildBuyMagalogTunables.MAGALOG_SHARED_ROOM_RENDERER_WIDTH);
            this.mcCategoryBar.visible = true;
            _loc1_ = this.mCategoryFeed.RequestItemAt(this.mCategoryFeed.SelectedIndex) as MenuItem;
            if(_loc1_)
            {
               this.mRoomFeed.mFilterObject.categoryTags = _loc1_.data["categoryTags"];
            }
            this.ResizeMagalogPanel();
            this.mcRoomBackground.visible = true;
            this.mcBlockBackground.visible = false;
         }
         this.RequestFilteredData();
         this.mcMagalogPanel.DeselectCurrentProduct();
         this.mcShowcase.Hide();
      }
      
      protected function RequestFilteredData(param1:ProductFilter = null) : void
      {
         var _loc2_:ProductFilter = null;
         if(!param1)
         {
            param1 = CommunicationManager.CallUIService("BBGetFilters",null) as ProductFilter;
         }
         if(param1)
         {
            _loc2_ = this.mRoomFeed.mFilterObject;
            _loc2_.styleResourceKeys = param1.styleResourceKeys;
            _loc2_.colorTags = param1.colorTags;
            _loc2_.specialTags = param1.specialTags;
            _loc2_.filterByGameplayUnlocks = param1.filterByGameplayUnlocks;
            _loc2_.filterPurchasedProducts = param1.filterPurchasedProducts;
            _loc2_.filterModdedContent = param1.filterModdedContent;
            _loc2_.filterHiddenObjects = param1.filterHiddenObjects;
            _loc2_.packIds = param1.packIds;
            _loc2_.filterUGC = param1.filterUGC;
         }
         if(this.mCurrentMode != SHARED_ROOM_MODE)
         {
            this.mRoomFeed.RequestData();
         }
         else
         {
            this.mRoomFeed.RequestExchangeRoomData();
         }
      }
      
      protected function OnSelectRoom(param1:GridEvent) : void
      {
         var _loc2_:CatalogProduct = null;
         var _loc3_:ExtendableComponent = null;
         var _loc4_:ExchangeData = null;
         if(this.mCurrentMode == BLOCK_MODE)
         {
            _loc2_ = param1.mData as CatalogProduct;
            this.SelectBlock(_loc2_);
            this.mcMagalogPanel.TriggerTutorialMessage();
            return;
         }
         if(this.mCurrentMode == ROOM_MODE)
         {
            _loc3_ = param1.mCellEvent.target as ExtendableComponent;
            _loc2_ = param1.mData as CatalogProduct;
            this.mSelectedRoom = _loc2_;
            if(!this.mcShowcase.visible || this.mcShowcase.Product != _loc2_)
            {
               Ticker.Add(this,BuildBuyMagalogTunables.MAGALOG_SINGLE_CLICK_DELAY,this.SelectRoom);
               this.mcMagalogPanel.HighlightProductByKey(_loc2_.resourceKey);
               this.mcMagalogPanel.TriggerTutorialMessage();
            }
            else
            {
               this.mcShowcase.Hide();
               this.mcMagalogPanel.DeselectCurrentProduct();
               this.ShowInfoPanel(_loc3_,_loc2_);
            }
         }
         else if(this.mCurrentMode == SHARED_ROOM_MODE)
         {
            _loc4_ = param1.mData as ExchangeData;
            this.SelectSharedRoom(_loc4_);
         }
      }
      
      protected function OnRollOverRoom(param1:GridEvent) : void
      {
         this.ShowInfoPanel(param1.mCellEvent.target as Sprite,param1.mData);
      }
      
      protected function OnRollOutRoom(param1:GridEvent) : void
      {
         this.mcInfoPanel.Hide(true,BBTunables.PRODUCT_INFO_PANEL_HIDE_DELAY);
      }
      
      protected function SelectRoom(param1:TickerEvent = null) : void
      {
         if(this.mHeldRoom)
         {
            this.mHeldRoom = null;
            CatalogProduct.ClearSelection();
         }
         this.mcShowcase.Product = this.mSelectedRoom;
         this.ShowShowcase();
         this.FlagProductAsViewed(this.mSelectedRoom);
         this.mcMagalogPanel.HighlightProductByKey(this.mSelectedRoom.resourceKey);
         this.mcInfoPanel.Hide();
         if(SystemUtils.UsingController)
         {
            if(NavManager.Instance.CurrentWidgetName == "BuildBuyFilter")
            {
               NavManager.Instance.FocusBack();
            }
            NavManager.Instance.FocusForward(this.mcShowcase,{"WidgetName":WidgetName});
         }
      }
      
      protected function SelectProduct(param1:CatalogProduct) : void
      {
         var _loc2_:ProductFilter = this.mRoomFeed.mFilterObject;
         param1.Select(_loc2_.categoryTags);
         if(SystemUtils.UsingController)
         {
            this.mWallAdapter = new BuildBuyCenterWallAdapter();
            this.mWallAdapter.OnBackCall(this.OnWallAdapterBack);
            this.mWallAdapter.SetAllowDeleteMode(true);
            this.mWallAdapter.SetAllowRotate(true);
            NavManager.Instance.FocusForward(this.mWallAdapter);
            this.mWallAdapter.EnsureCursorIsInBounds();
         }
      }
      
      protected function SelectBlock(param1:CatalogProduct) : void
      {
         if(this.mCurrentMode == BLOCK_MODE)
         {
            this.mSelectedRoom = param1;
            this.mHeldRoom = param1;
            this.SelectProduct(param1);
            this.mcMagalogPanel.HighlightProductByKey(param1.resourceKey);
         }
      }
      
      protected function SelectSharedRoom(param1:ExchangeData) : void
      {
         var _loc3_:ExchangeFilter = null;
         if(param1.type == ExchangeData.TYPE_INVALID)
         {
            TelemetryManager.DispatchTelemetryEvent("EXCH","BBUY","ROOM");
            _loc3_ = new ExchangeFilter(ExchangeShareMode.COMMUNITY,{
               "type":this.mRoomFeed.mExchangeFilter.type,
               "roomType":this.mRoomFeed.mExchangeFilter.roomType
            });
            SharedExchangeUtils.ShowGalleryCatalog({
               "mode":ExchangeShareMode.COMMUNITY,
               "filters":_loc3_
            });
            return;
         }
         var _loc2_:PurchaseAvailabilityData = BuildBuyStateData.PurchaseAvailability;
         if(_loc2_.bWorldBuilder || _loc2_.bFreeBuild || _loc2_.availableFunds >= param1.priceValue)
         {
            CommunicationManager.CallGameService("BBApplyRoom",param1.id);
            this.mcMagalogPanel.HighlightProduct(param1);
            this.mHeldRoom = param1;
            if(SystemUtils.UsingController)
            {
               NavManager.Instance.FocusForward(this.mSharedRoomCursorAdapter);
            }
         }
      }
      
      protected function OnDoubleClickRoom(param1:GridEvent) : void
      {
         Ticker.Remove(this);
         var _loc2_:CatalogProduct = this.mSelectedRoom;
         if(_loc2_)
         {
            this.FlagProductAsViewed(_loc2_);
            if(BuildBuyStateData.PurchaseAvailability.IsItemPurchasable(_loc2_))
            {
               this.mcShowcase.Hide();
               this.mcMagalogPanel.HighlightProductByKey(this.mSelectedRoom.resourceKey);
               this.mHeldRoom = _loc2_;
               this.SelectProduct(this.mSelectedRoom);
            }
            else if(this.mCurrentMode == ROOM_MODE)
            {
               this.SelectRoom(null);
            }
         }
      }
      
      protected function OnTabSelect(param1:SelectableGroupEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:CatalogProduct = null;
         var _loc2_:Button = param1.selectedComponent as Button;
         if(this.mHeldRoom)
         {
            CatalogProduct.ClearSelection();
         }
         if(_loc2_ == this.btnBlockCategory)
         {
            _loc3_ = CatalogData.EMPTY_BLOCK_CATEGORY;
            _loc4_ = _loc3_.data;
            this.ShowCategory(_loc4_["productType"],_loc4_["categoryTags"],_loc4_["categoryPriorityTags"]);
            if(this.mRoomFeed.mFilterObject.searchResult == null)
            {
               _loc5_ = this.mRoomFeed.RequestItemAt(0) as CatalogProduct;
            }
            if(Boolean(_loc5_) && !SystemUtils.UsingController)
            {
               this.SelectBlock(_loc5_);
            }
         }
         else if(_loc2_ == this.btnRoomCategory)
         {
            _loc3_ = this.mCategoryFeed.RequestItemAt(this.mCategoryFeed.SelectedIndex);
            _loc4_ = (_loc3_ as MenuItem).data;
            this.ShowCategory(_loc4_["productType"],_loc4_["categoryTags"],_loc4_["categoryPriorityTags"]);
         }
         else if(_loc2_ == this.btnSharedCategory)
         {
            this.ShowSharedRooms();
         }
      }
      
      protected function OnCategoryClick(param1:GridEvent) : void
      {
         var _loc3_:CatalogDataFeed = null;
         var _loc2_:Object = (param1.mData as MenuItem).data;
         if(this.mCurrentMode == ROOM_MODE)
         {
            this.ShowCategory(_loc2_["productType"],_loc2_["categoryTags"],_loc2_["categoryPriorityTags"]);
         }
         else if(this.mCurrentMode == SHARED_ROOM_MODE)
         {
            _loc3_ = this.mRoomFeed;
            _loc3_.mFilterObject.productType = _loc2_["productType"];
            _loc3_.mFilterObject.categoryTags = _loc2_["categoryTags"] ? _loc2_["categoryTags"] : [];
            _loc3_.mFilterObject.categoryPriorityTags = _loc2_["categoryPriorityTags"] ? _loc2_["categoryPriorityTags"] : [];
            this.ShowSharedRooms();
         }
      }
      
      protected function OnShowcaseClose(param1:GenericEvent) : void
      {
         if(this.mcMagalogPanel)
         {
            this.mcMagalogPanel.DeselectCurrentProduct();
         }
      }
      
      protected function OnShowcaseChange(param1:GenericEvent) : void
      {
         var _loc2_:int = this.mRoomFeed.IndexOf(this.mSelectedRoom);
         this.mSelectedRoom = this.mcShowcase.Product;
         this.FlagProductAsViewed(this.mSelectedRoom);
         this.mRoomFeed.ReplaceItemAt(_loc2_,this.mSelectedRoom);
      }
      
      public function HandleSelectCategory(param1:uint) : void
      {
         var _loc3_:Object = null;
         var _loc6_:MenuItem = null;
         var _loc2_:CategoryDataFeed = this.mCategoryFeed;
         var _loc4_:int = 0;
         var _loc5_:int = _loc2_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc2_.RequestItemAt(_loc4_) as MenuItem;
            if((_loc6_.data["categoryTags"] as Array).indexOf(param1) > -1)
            {
               this.mSelectModeTabGroup.SetSelectionAs(this.btnRoomCategory);
               this.mcCategoryBar.SetSelection(_loc4_);
               _loc3_ = _loc6_.data;
               break;
            }
            _loc4_++;
         }
         if(_loc3_ == null)
         {
            this.mSelectModeTabGroup.SetSelectionAs(this.btnBlockCategory);
            _loc3_ = CatalogData.EMPTY_BLOCK_CATEGORY.data;
         }
         this.ShowCategory(_loc3_["productType"],_loc3_["categoryTags"],_loc3_["categoryPriorityTags"]);
      }
      
      protected function HandleHighlightProduct(param1:Object) : void
      {
         var _loc2_:ResourceKey = null;
         var _loc3_:CatalogProduct = null;
         if(visible && this.mcMagalogPanel.visible)
         {
            if(param1 is ResourceKey)
            {
               _loc2_ = param1 as ResourceKey;
            }
            else
            {
               _loc2_ = param1["baseProductKey"] as ResourceKey;
            }
            _loc3_ = this.mcMagalogPanel.HighlightProductByKey(_loc2_);
            if(Boolean(_loc3_) && this.mCurrentMode == ROOM_MODE)
            {
               this.mSelectedRoom = _loc3_;
               this.SelectRoom();
            }
         }
      }
      
      protected function HandleRoomPlaced() : void
      {
         if(this.mCurrentMode == ROOM_MODE)
         {
            this.mcMagalogPanel.DeselectCurrentProduct();
         }
      }
      
      protected function HandleActionModeChanged(param1:int) : void
      {
         if(param1 == ActionModes.HIDDEN && this.mcShowcase.visible == false)
         {
            this.mcMagalogPanel.DeselectCurrentProduct();
         }
      }
      
      protected function HandleFiltersChanged(param1:ProductFilter) : void
      {
         if(!visible)
         {
            return;
         }
         this.RequestFilteredData(param1);
      }
      
      protected function HandlePurchaseAvailabilityUpdate() : void
      {
         if(visible)
         {
            this.mcMagalogPanel.PurchaseAvailabilityUpdate();
            if(this.mcInfoPanel.visible)
            {
               this.mcInfoPanel.RefreshAvailability();
            }
         }
      }
      
      protected function HandleMagalogResetRestore(param1:Object) : void
      {
         this.mbRestoreShowcase = false;
      }
      
      protected function HandleOnlineAccessStateChanged(param1:Object) : void
      {
         if(this.mCurrentMode == SHARED_ROOM_MODE)
         {
            this.mRoomFeed.RequestExchangeRoomData();
         }
      }
      
      protected function HandleUpdateExchangeItem(param1:ExchangeData = null) : void
      {
         if(this.mCurrentMode != SHARED_ROOM_MODE)
         {
            return;
         }
         this.RequestFilteredData();
      }
      
      protected function HandleExchangeItemDownloaded(param1:Object) : void
      {
         if(Boolean(param1) && Boolean(param1.bSucceeded))
         {
            this.RequestFilteredData();
         }
      }
      
      protected function HandleCreateExchangeItem(param1:Object) : void
      {
         if(this.mCurrentMode != SHARED_ROOM_MODE)
         {
            return;
         }
         var _loc2_:String = param1["itemId"];
         if(_loc2_ != "0")
         {
            this.RequestFilteredData();
         }
      }
      
      override public function HandleStageResized(param1:Number, param2:Number) : void
      {
         var _loc6_:Point = null;
         super.HandleStageResized(param1,param2);
         var _loc3_:Sprite = this.mcRoomBackground;
         var _loc4_:Sprite = this.mcTypesBackground;
         var _loc5_:Showcase = this.mcShowcase;
         _loc4_.y = _loc3_.y = this.mcBlockBackground.y = param2 - _loc3_.height;
         _loc3_.width = param1 - _loc3_.x;
         this.mcBlockBackground.width = _loc3_.width;
         this.btnBlockCategory.x = _loc4_.x + BuildBuyMagalogTunables.MAGALOG_TAB_BUTTON_HEIGHT_OFFSET.mLeft;
         this.btnBlockCategory.y = _loc4_.y + BuildBuyMagalogTunables.MAGALOG_TAB_BUTTON_HEIGHT_OFFSET.mTop;
         this.btnRoomCategory.x = this.btnBlockCategory.x;
         this.btnRoomCategory.y = this.btnBlockCategory.y + this.btnBlockCategory.height + BuildBuyMagalogTunables.MAGALOG_TAB_BUTTON_HEIGHT_OFFSET.Vertical;
         this.btnSharedCategory.x = this.btnBlockCategory.x;
         this.btnSharedCategory.y = this.btnRoomCategory.y + this.btnBlockCategory.height + BuildBuyMagalogTunables.MAGALOG_TAB_BUTTON_HEIGHT_OFFSET.Vertical;
         this.mcCategoryBar.x = _loc3_.x + BuildBuyMagalogTunables.MAGALOG_CATEGORYBAR_OFFSET.x;
         this.mcCategoryBar.y = _loc3_.y + BuildBuyMagalogTunables.MAGALOG_CATEGORYBAR_OFFSET.y;
         this.ResizeMagalogPanel();
         this.mShowcasePosition.x = param1 - _loc5_.width + _loc5_.mcProductInfoPanel.width - BuildBuyMagalogTunables.MAGALOG_PADDING_RIGHT;
         this.mShowcasePosition.y = param2 - _loc5_.height - BuildBuyMagalogTunables.MAGALOG_PADDING_BOTTOM;
         if(SystemUtils.UsingController && _loc5_.visible)
         {
            _loc6_ = new Point(this.mShowcasePosition.x,this.mShowcasePosition.y);
            _loc6_ = this.localToGlobal(_loc6_);
            _loc5_.x = _loc6_.x;
            _loc5_.y = _loc6_.y;
         }
      }
      
      protected function ResizeMagalogPanel() : void
      {
         var _loc1_:Sprite = this.mcRoomBackground;
         this.mcMagalogPanel.x = _loc1_.x + BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.mLeft;
         if(this.mCurrentMode != BLOCK_MODE)
         {
            this.mcMagalogPanel.y = _loc1_.y + BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.mTop + this.mcCategoryBar.height;
            this.mcMagalogPanel.Resize(_loc1_.width - BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.Horizontal - BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN.mRight,_loc1_.height - BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.Vertical - this.mcCategoryBar.height);
         }
         else
         {
            this.mcMagalogPanel.y = _loc1_.y + BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.mTop;
            this.mcMagalogPanel.Resize(_loc1_.width - BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.Horizontal - BuildBuyMagalogTunables.MAGALOG_LIST_MARGIN.mRight,_loc1_.height - BuildBuyMagalogTunables.MAGALOG_LIST_OFFSET.Vertical);
         }
      }
      
      protected function InitGamepad() : void
      {
         var inputAction:InputAction;
         var bCycleVariantEnabled:Boolean;
         this.GamepadSetVisible(false);
         AddMessageListener("CursorModeToggled",this.HandleCursorModeToggled);
         this.mTabInput = InputAdapterFactory.BidirectionalFromSelectableGroup(this.mSelectModeTabGroup);
         this.mTabInput.OnInputEventCall(InputAdapterEvent.CONFIRM,function(param1:*):*
         {
            NavManager.Instance.FocusForward(mcMagalogPanel);
         });
         this.mTabInput.OnInputEventCall(InputAdapterEvent.BACK,this.HandleTabBack);
         this.mcMagalogPanel.OnInputEventCall(InputAdapterEvent.BACK,this.HandleMagalogPanelBack);
         this.mcMagalogPanel.OnInputEventCall(InputAdapterEvent.ENTERED,function():*
         {
            mCategoryBarInput.Enter(null);
         });
         this.mcMagalogPanel.OnInputEventCall(InputAdapterEvent.EXITED,function():*
         {
            mCategoryBarInput.Exit();
         });
         this.mCategoryBarInput = InputAdapterFactory.BidirectionalFromGridLayout(this.mcCategoryBar.mGridLayout as GridLayout);
         this.mCategoryBarInput.SetTabbingSelectionMode(true);
         this.mCategoryBarInput.OnInputEventCall(InputAdapterEvent.TAB,this.mcMagalogPanel.RefreshHighlight);
         this.mCategoryBarInput.TryInitializeInputs();
         inputAction = this.mCategoryBarInput.GetFirstInputAction(ActionCodes.TAB_LEFT).SetQuickLegendKey(KeysConsole.GENERIC_CHANGE_CATEGORY).SetLinkedInLegend(true).SetLegendKey(KeysConsole.LIVE_CATEGORY_LEFT).SetValidCheck(this.CanShowCategoryLegends);
         inputAction = this.mCategoryBarInput.GetFirstInputAction(ActionCodes.TAB_RIGHT).SetLegendKey(KeysConsole.LIVE_CATEGORY_RIGHT).SetLinkedInLegend(true).SetValidCheck(this.CanShowCategoryLegends);
         this.mcShowcase.OnInputEventCall(InputAdapterEvent.BACK,this.HandleBackFromShowcase);
         bCycleVariantEnabled = false;
         this.mSharedRoomCursorAdapter = new BuildBuyCenterProductSelectedAdapter(bCycleVariantEnabled);
         this.mSharedRoomCursorAdapter.OnEnteredCall(this.HandleSharedRoomCursorAdapterEntered);
         this.mSharedRoomCursorAdapter.OnExitedCall(this.HandleSharedRoomCursorAdapterExited);
      }
      
      protected function HandleCursorModeToggled() : void
      {
         if(visible)
         {
            this.Hide();
         }
      }
      
      protected function HandleUsingControllerToggled() : void
      {
         if(SystemUtils.UsingController)
         {
            this.GamepadSetVisible(false);
         }
      }
      
      protected function HandleMagalogPanelBack() : void
      {
         this.mcMagalogPanel.RefreshHighlight();
         NavManager.Instance.FocusBack();
      }
      
      protected function OnSharedRoomPlacementFinished(param1:Object) : void
      {
         NavManager.Instance.TryFocusBack(this.mSharedRoomCursorAdapter);
      }
      
      public function GamepadSetVisible(param1:Boolean) : void
      {
         if(SystemUtils.UsingController)
         {
            this.visible = param1;
            this.mcMagalogPanel.visible = true;
            CommunicationManager.SendUIMessage((param1 ? "Show" : "Hide") + "BuildBuyFilter");
         }
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         if(Boolean(param1) && Boolean(param1.mArgs) && Boolean(param1.mArgs.search))
         {
            return this.mcShowcase.Enter(param1);
         }
         return this.mTabInput.Enter(param1);
      }
      
      override public function OnEntered(param1:EnterParams = null) : void
      {
         this.GamepadSetVisible(true);
      }
      
      protected function OnWallAdapterBack() : void
      {
         CatalogProduct.ClearSelection();
         NavManager.Instance.TryFocusBack(this.mWallAdapter);
      }
      
      protected function HandleTabBack() : void
      {
         NavManager.Instance.FocusBack();
         this.GamepadSetVisible(false);
      }
      
      protected function HandleBackFromShowcase() : void
      {
         this.Hide({"minimizeShowcase":true});
         CommunicationManager.SendUIMessage("ShowBuildBuyFilter");
      }
      
      protected function HandleSharedRoomCursorAdapterEntered() : void
      {
         AddMessageListener("BBArchitectureReleased",this.OnSharedRoomPlacementFinished);
         AddMessageListener("BBUserToolCanceled",this.OnSharedRoomPlacementFinished);
      }
      
      protected function HandleSharedRoomCursorAdapterExited() : void
      {
         RemoveMessageListener("BBUserToolCanceled",this.OnSharedRoomPlacementFinished);
         RemoveMessageListener("BBArchitectureReleased",this.OnSharedRoomPlacementFinished);
      }
      
      public function ShouldRegisterSharedActions() : Boolean
      {
         return this.mcShowcase.ShouldRegisterSharedActions();
      }
      
      protected function CanShowCategoryLegends() : Boolean
      {
         return Boolean(this.mcCategoryBar) && this.mcCategoryBar.visible;
      }
      
      private function FlagProductAsViewed(param1:CatalogProduct) : void
      {
         var _loc2_:Array = null;
         if(param1.mtxState == MTXState.UNLOCKED_NEW)
         {
            param1.mtxState = MTXState.UNLOCKED;
            _loc2_ = new Array();
            _loc2_.push(param1.resourceKey);
            CommunicationManager.CallGameService("BBFlagProductsAsViewed",_loc2_);
         }
      }
   }
}

