package olympus.data
{
   import olympus.events.DataFeedEvent;
   
   public class SelectableArrayDataFeed extends ArrayDataFeed
   {
      
      protected var mSelections:Vector.<Boolean> = new Vector.<Boolean>();
      
      public function SelectableArrayDataFeed()
      {
         super();
      }
      
      public function GetSelectionState(param1:int) : Boolean
      {
         if(!CheckGoodIndex(param1))
         {
            return false;
         }
         return this.mSelections[param1];
      }
      
      public function SetSelectionState(param1:int, param2:Boolean) : Boolean
      {
         if(!CheckGoodIndex(param1))
         {
            return false;
         }
         this.mSelections[param1] = param2;
         var _loc3_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.UPDATE);
         _loc3_.mIndicesArray.push(param1);
         _loc3_.mDataArray.push(mDataArray[param1]);
         _loc3_.mUserDataArray.push({"isSelected":param2});
         dispatchEvent(_loc3_);
         return true;
      }
      
      public function SetSelectionStateMultiple(param1:Array, param2:Boolean) : Boolean
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:DataFeedEvent = null;
         var _loc3_:Vector.<Boolean> = this.mSelections;
         var _loc4_:Array = mDataArray;
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         _loc7_ = new Array();
         for each(_loc8_ in param1)
         {
            if(CheckGoodIndex(_loc8_))
            {
               _loc3_[_loc8_] = param2;
               _loc5_.push(_loc8_);
               _loc6_.push(_loc4_[_loc8_]);
               _loc7_.push({"isSelected":param2});
            }
         }
         if(_loc5_.length > 0)
         {
            _loc9_ = new DataFeedEvent(DataFeedEvent.UPDATE);
            _loc9_.mIndicesArray = _loc5_;
            _loc9_.mDataArray = _loc6_;
            _loc9_.mUserDataArray = _loc7_;
            dispatchEvent(_loc9_);
            return true;
         }
         return false;
      }
      
      public function GetSelectedItems() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Vector.<Boolean> = this.mSelections;
         var _loc3_:Array = mDataArray;
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc2_.length);
         while(_loc4_ < _loc5_)
         {
            if(_loc2_[_loc4_])
            {
               _loc1_.push(_loc3_[_loc4_]);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function GetSelectedIndices() : Array
      {
         var _loc1_:Vector.<Boolean> = this.mSelections;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc1_.length);
         while(_loc3_ < _loc4_)
         {
            if(_loc1_[_loc3_])
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function DeselectAll(param1:Boolean = false) : void
      {
         var _loc9_:DataFeedEvent = null;
         var _loc2_:Vector.<Boolean> = this.mSelections;
         var _loc3_:Array = mDataArray;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         var _loc8_:int = int(_loc2_.length);
         while(_loc7_ < _loc8_)
         {
            if(!(param1 && !_loc3_[_loc7_].enabled))
            {
               if(_loc2_[_loc7_])
               {
                  _loc4_.push(_loc7_);
                  _loc5_.push(_loc3_[_loc7_]);
                  _loc6_.push({"isSelected":false});
                  _loc2_[_loc7_] = false;
               }
            }
            _loc7_++;
         }
         if(_loc4_.length > 0)
         {
            _loc9_ = new DataFeedEvent(DataFeedEvent.UPDATE);
            _loc9_.mIndicesArray = _loc4_;
            _loc9_.mDataArray = _loc5_;
            _loc9_.mUserDataArray = _loc6_;
            dispatchEvent(_loc9_);
         }
      }
      
      public function SelectAll(param1:Boolean = false) : void
      {
         var _loc9_:DataFeedEvent = null;
         var _loc2_:Vector.<Boolean> = this.mSelections;
         var _loc3_:Array = mDataArray;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         var _loc8_:int = int(_loc2_.length);
         while(_loc7_ < _loc8_)
         {
            if(!(param1 && !_loc3_[_loc7_].enabled))
            {
               if(!_loc2_[_loc7_])
               {
                  _loc4_.push(_loc7_);
                  _loc5_.push(_loc3_[_loc7_]);
                  _loc6_.push({"isSelected":true});
                  _loc2_[_loc7_] = true;
               }
            }
            _loc7_++;
         }
         if(_loc4_.length > 0)
         {
            _loc9_ = new DataFeedEvent(DataFeedEvent.UPDATE);
            _loc9_.mIndicesArray = _loc4_;
            _loc9_.mDataArray = _loc5_;
            _loc9_.mUserDataArray = _loc6_;
            dispatchEvent(_loc9_);
         }
      }
      
      override public function AddItem(param1:Object) : void
      {
         this.mSelections.push(false);
         super.AddItem(param1);
      }
      
      override public function AddItemToFront(param1:Object) : void
      {
         this.mSelections.unshift(false);
         super.AddItemToFront(param1);
      }
      
      override public function AddItemsFromIterable(param1:Object, param2:Object = null) : void
      {
         this.mSelections.length = param1.length + (mDataArray == null ? 0 : mDataArray.length);
         super.AddItemsFromIterable(param1,param2);
      }
      
      override public function RemoveItemAt(param1:int) : void
      {
         this.mSelections.splice(param1,1);
         super.RemoveItemAt(param1);
      }
      
      override public function RemoveAllItems(param1:Boolean = false) : void
      {
         super.RemoveAllItems(param1);
         this.mSelections = new Vector.<Boolean>();
      }
      
      public function Clone() : SelectableArrayDataFeed
      {
         var _loc1_:SelectableArrayDataFeed = new SelectableArrayDataFeed();
         _loc1_.AddItemsFromIterable(mDataArray);
         _loc1_.mSelections = this.mSelections.concat();
         return _loc1_;
      }
   }
}

