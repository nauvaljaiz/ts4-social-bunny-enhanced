package widgets.BuildBuy.data
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.io.CommunicationManager;
   import widgets.shared.data.ColorSwatchData;
   import widgets.shared.data.ColorSwatchDataArray;
   
   public class VariationDataFeed extends SelectableArrayDataFeed
   {
      
      public function VariationDataFeed()
      {
         super();
      }
      
      public function LoadProductVariations(param1:CatalogProduct, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc8_:ColorSwatchData = null;
         RemoveAllItems();
         if(!param1)
         {
            return;
         }
         if(param2)
         {
            _loc3_ = CommunicationManager.CallGameService("BBGetSwapableVariations",param1.resourceKey.ToObject(),true);
         }
         else
         {
            _loc3_ = CommunicationManager.CallGameService("BBGetProductVariations",param1.resourceKey.ToObject(),true);
         }
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:ColorSwatchDataArray = new ColorSwatchDataArray(_loc3_);
         var _loc5_:Array = _loc4_.mItems;
         AddItemsFromIterable(_loc5_);
         var _loc6_:String = param1.resourceKey.instance;
         var _loc7_:int = 0;
         for each(_loc8_ in _loc5_)
         {
            SetSelectionState(_loc7_,_loc8_.dataID == _loc6_);
            _loc7_++;
         }
      }
      
      override public function Clone() : SelectableArrayDataFeed
      {
         var _loc1_:VariationDataFeed = new VariationDataFeed();
         _loc1_.AddItemsFromIterable(mDataArray);
         _loc1_.mSelections = mSelections.concat();
         return _loc1_;
      }
   }
}

