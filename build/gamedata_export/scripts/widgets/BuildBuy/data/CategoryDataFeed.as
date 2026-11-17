package widgets.BuildBuy.data
{
   import olympus.controls.objects.MenuItem;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.DataFeedEvent;
   
   public class CategoryDataFeed extends SelectableArrayDataFeed
   {
      
      protected var mCurrentSelectionIndex:int = -1;
      
      public function CategoryDataFeed()
      {
         super();
      }
      
      public function get SelectedIndex() : int
      {
         return this.mCurrentSelectionIndex;
      }
      
      public function ClearCurrentSelection() : void
      {
         this.SetSelectionState(this.mCurrentSelectionIndex,false);
      }
      
      override public function SetSelectionState(param1:int, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == this.mCurrentSelectionIndex && param2 == false)
         {
            this.mCurrentSelectionIndex = -1;
            return super.SetSelectionState(param1,param2);
         }
         _loc3_ = super.SetSelectionState(param1,param2);
         if(_loc3_ && param2)
         {
            this.mCurrentSelectionIndex = param1;
         }
         return _loc3_;
      }
      
      public function EnableFlairAtIndex(param1:int, param2:Boolean) : void
      {
         if(!CheckGoodIndex(param1))
         {
            return;
         }
         var _loc3_:MenuItem = mDataArray[param1];
         _loc3_.data["enableFlair"] = param2;
         var _loc4_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.UPDATE);
         _loc4_.mIndicesArray.push(param1);
         _loc4_.mDataArray.push(_loc3_);
         _loc4_.mUserDataArray.push({"isSelected":GetSelectionState(param1)});
         dispatchEvent(_loc4_);
      }
   }
}

