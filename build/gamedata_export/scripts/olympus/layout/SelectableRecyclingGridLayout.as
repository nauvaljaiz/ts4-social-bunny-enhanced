package olympus.layout
{
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.DataFeedEvent;
   import olympus.events.GridEvent;
   import olympus.extensions.Selectability;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IView;
   
   public class SelectableRecyclingGridLayout extends RecyclingGridLayout
   {
      
      public function SelectableRecyclingGridLayout(param1:Boolean = true, param2:Boolean = true, param3:int = 4)
      {
         super(param1,param2,param3);
      }
      
      override protected function CycleCells(param1:GridEvent) : Boolean
      {
         if(super.CycleCells(param1))
         {
            this.UpdateSelectionInCells();
            return true;
         }
         return false;
      }
      
      override public function PositionCells() : void
      {
         super.PositionCells();
         this.UpdateSelectionInCells();
      }
      
      override protected function OnFeedUpdate(param1:DataFeedEvent) : void
      {
         super.OnFeedUpdate(param1);
         this.UpdateSelectionInCells();
      }
      
      override protected function OnFeedAdd(param1:DataFeedEvent) : void
      {
         super.OnFeedAdd(param1);
         this.UpdateSelectionInCells();
      }
      
      override protected function OnFeedSortFilter(param1:DataFeedEvent) : void
      {
         super.OnFeedSortFilter(param1);
         this.UpdateSelectionInCells();
      }
      
      protected function UpdateSelectionInCells() : void
      {
         var _loc6_:IExtendable = null;
         var _loc7_:Selectability = null;
         var _loc8_:int = 0;
         var _loc1_:Vector.<IView> = mCells;
         var _loc2_:Vector.<int> = mCellIndexToDataIndexMap;
         var _loc3_:SelectableArrayDataFeed = mGridData as SelectableArrayDataFeed;
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc1_.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc1_[_loc4_] as IExtendable;
            _loc7_ = _loc6_.GetExtension(Selectability) as Selectability;
            _loc8_ = GetDataIndexOfSortedIndex(_loc2_[_loc4_]);
            _loc7_.Selected = _loc3_.GetSelectionState(_loc8_);
            _loc4_++;
         }
      }
   }
}

