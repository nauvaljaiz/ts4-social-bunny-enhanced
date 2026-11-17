package widgets.BuildBuy.data
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.BuildBuy.shared.ProductFilter;
   import gamedata.Exchange.ExchangeData;
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.ResourceKey;
   import olympus.core.ConnectionManager;
   import olympus.core.OlympusObject;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.DataFeedEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysBB;
   import olympus.localization.KeysConsole;
   import olympus.utils.SystemUtils;
   import widgets.shared.constants.ExchangeFiltersData;
   import widgets.shared.constants.ExchangeShareMode;
   import widgets.shared.data.ExchangeFilter;
   
   public class CatalogDataFeed extends SelectableArrayDataFeed
   {
      
      public var mFilterObject:ProductFilter;
      
      public var mExchangeFilter:ExchangeFilter;
      
      public function CatalogDataFeed(param1:uint = 2)
      {
         super();
         this.mFilterObject = new ProductFilter();
         this.mFilterObject.productType = param1;
      }
      
      override public function RequestItemAt(param1:int) : Object
      {
         if(param1 < 0 || param1 >= length)
         {
            return null;
         }
         var _loc2_:Object = mDataArray[param1];
         if(!(_loc2_ is CatalogProduct || _loc2_ is ExchangeData))
         {
            _loc2_ = new CatalogProduct(_loc2_);
            mDataArray[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      override public function RequestItemsAt(param1:int, param2:int = 1) : Array
      {
         if(param1 < 0 || param1 >= length)
         {
            return [];
         }
         var _loc3_:int = Math.min(param1 + param2,length) - param1;
         var _loc4_:Array = new Array(_loc3_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = this.RequestItemAt(param1 + _loc5_);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function IndexOfKey(param1:ResourceKey) : int
      {
         var _loc5_:Object = null;
         var _loc2_:Array = mDataArray;
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_[_loc3_];
            if(param1.IsEqual(_loc5_.resourceKey))
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function RequestItemByKey(param1:ResourceKey) : Object
      {
         var _loc5_:Object = null;
         var _loc2_:Array = mDataArray;
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_[_loc3_];
            if(param1.IsEqual(_loc5_.resourceKey))
            {
               return this.RequestItemAt(_loc3_);
            }
            _loc3_++;
         }
         return null;
      }
      
      public function RequestData() : void
      {
         var _loc2_:DataFeedEvent = null;
         RemoveAllItems();
         var _loc1_:Array = this.GetCatalog();
         if(!_loc1_)
         {
            return;
         }
         OlympusObject.ConstructArrayInPlace(_loc1_,CatalogProduct);
         AddItemsFromIterable(_loc1_);
         if(_loc1_.length == 0)
         {
            _loc2_ = new DataFeedEvent(DataFeedEvent.UPDATE);
            dispatchEvent(_loc2_);
         }
      }
      
      public function RequestExchangeRoomData() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:ExchangeData = null;
         var _loc6_:DataFeedEvent = null;
         RemoveAllItems();
         var _loc1_:ExchangeFilter = this.mExchangeFilter;
         if(!_loc1_)
         {
            _loc1_ = new ExchangeFilter(ExchangeShareMode.LIBRARY,{"type":ExchangeData.TYPE_ROOM});
            this.mExchangeFilter = _loc1_;
         }
         if(this.mFilterObject.categoryTags.length == 1)
         {
            _loc1_.roomType = this.mFilterObject.categoryTags[0];
         }
         else
         {
            _loc1_.roomType = ExchangeFiltersData.DEFAULT_ROOM_TYPE_VALUE;
         }
         var _loc2_:Array = CommunicationManager.CallGameService("GetTrayItems",_loc1_.ToObjectMySaves()) as Array;
         if(_loc2_)
         {
            _loc3_ = [];
            for each(_loc4_ in _loc2_)
            {
               _loc3_.push(new ExchangeData(_loc4_));
            }
            if(!ConnectionManager.IsOnlineAccessDisabled)
            {
               _loc5_ = new ExchangeData();
               _loc5_.type = ExchangeData.TYPE_INVALID;
               _loc5_.name = SystemUtils.IsConsole ? KeysConsole.BB_MAGALOG_VIEW_GALLERY.toString() : KeysBB.BB_MAGALOG_VIEW_GALLERY.toString();
               _loc3_.push(_loc5_);
            }
            AddItemsFromIterable(_loc3_);
            if(_loc3_.length == 0)
            {
               _loc6_ = new DataFeedEvent(DataFeedEvent.UPDATE);
               dispatchEvent(_loc6_);
            }
         }
      }
      
      public function ResetAllViews() : void
      {
         var _loc1_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.REMOVE_ALL);
         dispatchEvent(_loc1_);
      }
      
      protected function GetCatalog() : Array
      {
         return CommunicationManager.CallGameService("BBRequestProductCatalog",this.mFilterObject.ToObject()) as Array;
      }
      
      public function FlagNewProductsAsViewed() : void
      {
         var _loc3_:CatalogProduct = null;
         var _loc1_:Array = mDataArray;
         if(_loc1_.length == 0 || !(_loc1_[0] is CatalogProduct))
         {
            return;
         }
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(Boolean(_loc3_) && (_loc3_.isNew || _loc3_.mtxState == MTXState.UNLOCKED_NEW))
            {
               _loc2_.push(_loc3_.resourceKey);
            }
         }
         if(_loc2_.length > 0)
         {
            CommunicationManager.CallGameService("BBFlagProductsAsViewed",_loc2_);
         }
      }
   }
}

