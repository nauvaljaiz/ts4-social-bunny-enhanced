package widgets.BuildBuy.controls
{
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.GridEvent;
   import olympus.gui.grids.SelectionGrid;
   
   public class CategoryGrid extends SelectionGrid
   {
      
      public function CategoryGrid()
      {
         super();
      }
      
      override public function OnSelectionUpdate(param1:GridEvent) : void
      {
         var _loc2_:GridEvent = new GridEvent(GridEvent.SELECTION_UPDATE);
         var _loc3_:Object = param1.mData;
         var _loc4_:SelectableArrayDataFeed = mDataFeed;
         var _loc5_:int = _loc4_.IndexOf(_loc3_);
         var _loc6_:Boolean = _loc4_.GetSelectionState(_loc5_);
         if(_loc4_.GetSelectionState(_loc5_))
         {
            return;
         }
         super.OnSelectionUpdate(param1);
      }
   }
}

