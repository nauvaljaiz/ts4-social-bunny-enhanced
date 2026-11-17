package olympus.data
{
   import olympus.events.DataFeedEvent;
   import olympus.utils.ArrayUtils;
   
   public class ArrayDataFeed extends GenericDataFeed
   {
      
      public function ArrayDataFeed()
      {
         super();
      }
      
      public function AddItem(param1:Object) : void
      {
         mDataArray.push(param1);
         var _loc2_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.ADD);
         _loc2_.mDataArray.push(param1);
         _loc2_.mIndicesArray.push(mDataArray.length - 1);
         dispatchEvent(_loc2_);
      }
      
      public function AddItemsFromIterable(param1:Object, param2:Object = null) : void
      {
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         if(param1 is GenericDataFeed)
         {
            param1 = param1.mDataArray;
         }
         var _loc3_:int = int(param1.length);
         if(_loc3_ == 0)
         {
            return;
         }
         var _loc4_:Boolean = Boolean(param2) && param2.length == _loc3_;
         var _loc5_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.ADD);
         var _loc6_:Array = _loc5_.mDataArray;
         var _loc7_:Array = _loc5_.mIndicesArray;
         var _loc8_:Array = _loc5_.mUserDataArray;
         var _loc9_:* = int(mDataArray.length);
         _loc10_ = 0;
         while(_loc10_ < _loc3_)
         {
            _loc11_ = param1[_loc10_];
            mDataArray.push(_loc11_);
            _loc7_.push(_loc9_++);
            _loc6_.push(_loc11_);
            _loc10_++;
         }
         if(_loc4_)
         {
            _loc10_ = 0;
            while(_loc10_ < _loc3_)
            {
               _loc8_.push(param2[_loc10_]);
               _loc10_++;
            }
         }
         dispatchEvent(_loc5_);
      }
      
      public function AddGuaranteedNumberOfItemsFromIterable(param1:Number, param2:Object, param3:Object, param4:Object = null) : void
      {
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         if(param2 is GenericDataFeed)
         {
            param2 = param2.mDataArray;
         }
         var _loc5_:Boolean = Boolean(param4);
         var _loc6_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.ADD);
         var _loc7_:Array = _loc6_.mDataArray;
         var _loc8_:Array = _loc6_.mIndicesArray;
         var _loc9_:Array = _loc6_.mUserDataArray;
         var _loc10_:* = int(mDataArray.length);
         var _loc11_:int = 0;
         while(_loc11_ < param2.length)
         {
            _loc12_ = param2[_loc11_];
            mDataArray.push(_loc12_);
            _loc8_.push(_loc10_++);
            _loc7_.push(_loc12_);
            _loc11_++;
         }
         if(_loc5_)
         {
            _loc13_ = 0;
            while(_loc13_ < param4.length)
            {
               _loc9_.push(param4[_loc13_]);
               _loc13_++;
            }
         }
         while(_loc11_ < param1)
         {
            mDataArray.push(param3);
            _loc8_.push(_loc10_++);
            _loc7_.push(param3);
            _loc11_++;
         }
         dispatchEvent(_loc6_);
      }
      
      public function AddItemsFromIterableConditional(param1:Object, param2:Function, param3:Object = null) : void
      {
         var _loc12_:Object = null;
         if(param1 is GenericDataFeed)
         {
            param1 = param1.mDataArray;
         }
         var _loc4_:Boolean = Boolean(param3) && param3.length == param1.length;
         var _loc5_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.ADD);
         var _loc6_:Array = _loc5_.mUserDataArray;
         var _loc7_:Array = _loc5_.mIndicesArray;
         var _loc8_:Array = _loc5_.mDataArray;
         var _loc9_:* = int(mDataArray.length);
         var _loc10_:int = int(param1.length);
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc12_ = param1[_loc11_];
            if(param2(_loc12_))
            {
               mDataArray.push(_loc12_);
               _loc7_.push(_loc9_++);
               _loc8_.push(_loc12_);
               if(_loc4_)
               {
                  _loc6_.push(param3[_loc11_]);
               }
            }
            _loc11_++;
         }
         if(_loc8_.length > 0)
         {
            dispatchEvent(_loc5_);
         }
      }
      
      public function AddItemToFront(param1:Object) : void
      {
         var _loc2_:Array = [0];
         var _loc3_:Array = [param1];
         mDataArray.unshift(param1);
         var _loc4_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.ADD_TO_FRONT);
         _loc4_.mDataArray = _loc3_;
         _loc4_.mIndicesArray = _loc2_;
         dispatchEvent(_loc4_);
      }
      
      public function ReplaceItemAt(param1:int, param2:Object) : void
      {
         if(!this.CheckGoodIndex(param1))
         {
            return;
         }
         mDataArray[param1] = param2;
         var _loc3_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.UPDATE);
         _loc3_.mIndicesArray.push(param1);
         _loc3_.mDataArray.push(param2);
         dispatchEvent(_loc3_);
      }
      
      public function MarkRangeDirty(param1:int, param2:int) : void
      {
         var _loc5_:Object = null;
         if(!this.CheckGoodIndex(param1) || !this.CheckGoodIndex(param2))
         {
            return;
         }
         var _loc3_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.UPDATE);
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            _loc5_ = mDataArray[_loc4_];
            _loc3_.mIndicesArray.push(_loc4_);
            _loc3_.mDataArray.push(_loc5_);
            _loc4_++;
         }
         if(_loc3_.mDataArray.length > 0)
         {
            dispatchEvent(_loc3_);
         }
      }
      
      public function MarkItemsDirtyByFieldName(param1:String, param2:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(!param2 || param2.length == 0)
         {
            return;
         }
         var _loc3_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.UPDATE);
         for each(_loc4_ in param2)
         {
            _loc5_ = ArrayUtils.IndexOfByFieldName(mDataArray,param1,_loc4_);
            if(_loc5_ >= 0)
            {
               _loc6_ = mDataArray[_loc5_];
               _loc3_.mIndicesArray.push(_loc5_);
               _loc3_.mDataArray.push(_loc6_);
            }
         }
         if(_loc3_.mDataArray.length > 0)
         {
            dispatchEvent(_loc3_);
         }
      }
      
      public function ReplaceItemByFieldName(param1:String, param2:Object) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:DataFeedEvent = null;
         var _loc3_:int = 0;
         while(_loc3_ < length)
         {
            _loc4_ = mDataArray[_loc3_];
            if(_loc4_[param1] == param2[param1])
            {
               mDataArray[_loc3_] = param2;
               _loc5_ = new DataFeedEvent(DataFeedEvent.UPDATE);
               _loc5_.mIndicesArray.push(_loc3_);
               _loc5_.mDataArray.push(param2);
               dispatchEvent(_loc5_);
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function RemoveItemAt(param1:int) : void
      {
         if(!this.CheckGoodIndex(param1))
         {
            return;
         }
         mDataArray.splice(param1,1);
         var _loc2_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.REMOVE);
         _loc2_.mIndicesArray.push(param1);
         dispatchEvent(_loc2_);
      }
      
      public function RemoveAllItems(param1:Boolean = false) : void
      {
         if(!param1 && length == 0)
         {
            return;
         }
         Destroy();
         var _loc2_:DataFeedEvent = new DataFeedEvent(DataFeedEvent.REMOVE_ALL);
         dispatchEvent(_loc2_);
      }
      
      public function IndexOf(param1:Object) : int
      {
         return mDataArray.indexOf(param1);
      }
      
      public function GetItemIndexByFieldName(param1:String, param2:Object) : int
      {
         return ArrayUtils.IndexOfByFieldName(mDataArray,param1,param2);
      }
      
      public function CheckGoodIndex(param1:int) : Boolean
      {
         return param1 < mDataArray.length && param1 > -1;
      }
   }
}

