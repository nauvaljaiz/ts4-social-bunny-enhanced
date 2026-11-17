package gamedata.Gameplay.Pickers.DataFeeds
{
   import gamedata.Gameplay.Pickers.PurchasePickerData;
   import gamedata.Gameplay.Pickers.PurchasePickerRowData;
   import gamedata.Gameplay.Pickers.UiDialogPicker;
   import olympus.data.ArrayDataFeed;
   import olympus.events.DataFeedEvent;
   
   public class PurchasePickerDataFeed extends ArrayDataFeed
   {
      
      protected var mbShowDescription:Boolean;
      
      protected var mbShowDescriptionTooltip:Boolean;
      
      protected var mbShowCost:Boolean;
      
      protected var mNameColumnWidth:Number;
      
      protected var mMaxSelectableInRow:uint;
      
      public function PurchasePickerDataFeed()
      {
         super();
      }
      
      public function InitializeDataFeed(param1:UiDialogPicker, param2:Number = 0) : void
      {
         var _loc3_:PurchasePickerData = param1.shop_picker_data;
         if(_loc3_)
         {
            this.mbShowDescription = _loc3_.show_description;
            this.mbShowDescriptionTooltip = _loc3_.show_description_tooltip;
            this.mbShowCost = _loc3_.show_cost;
            this.mNameColumnWidth = param2;
            this.mMaxSelectableInRow = _loc3_.max_selectable_in_row;
            this.AddItemsFromIterable(_loc3_.row_data);
         }
      }
      
      override public function AddItemsFromIterable(param1:Object, param2:Object = null) : void
      {
         var _loc6_:Object = null;
         var _loc7_:DataFeedEvent = null;
         var _loc8_:PurchasePickerRowData = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = int(mDataArray.length);
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1)
         {
            _loc8_ = _loc6_ as PurchasePickerRowData;
            _loc8_.showDescription = this.mbShowDescription;
            _loc8_.showDescriptionTooltip = this.mbShowDescriptionTooltip;
            _loc8_.showCost = this.mbShowCost;
            _loc8_.nameColumnWidth = this.mNameColumnWidth;
            _loc8_.maxSelectableInRow = this.mMaxSelectableInRow;
            mDataArray.push(_loc6_);
            _loc3_.push(_loc4_++);
            _loc5_.push(_loc6_);
         }
         _loc7_ = new DataFeedEvent(DataFeedEvent.ADD);
         _loc7_.mDataArray = _loc5_;
         _loc7_.mIndicesArray = _loc3_;
         dispatchEvent(_loc7_);
      }
   }
}

