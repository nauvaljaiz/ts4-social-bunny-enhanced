package olympus.extensions.datafeed
{
   import olympus.data.GenericDataFeed;
   import olympus.events.DataFeedEvent;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class SortFilterExtension implements IExtension
   {
      
      internal var mDataFeed:GenericDataFeed;
      
      public function SortFilterExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : SortFilterExtension
      {
         return param1.GetExtension(SortFilterExtension,param2) as SortFilterExtension;
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(!(param1 is GenericDataFeed))
         {
            throw new Error("Cannot apply SortFilterExtension to object which is not a GenericDataFeed!");
         }
         this.mDataFeed = param1 as GenericDataFeed;
      }
      
      public function SortFilterByFunction(param1:Function, param2:Object = null, param3:Object = null, param4:Boolean = true) : void
      {
         var _loc7_:Array = null;
         var _loc8_:DataFeedEvent = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc5_:Array = this.mDataFeed.RequestItemsAt(0,this.mDataFeed.length);
         var _loc6_:Array = this.DoSorting(param2,param3);
         if(param1 != null)
         {
            _loc7_ = new Array();
            for each(_loc9_ in _loc6_)
            {
               _loc10_ = _loc5_[_loc9_];
               if(param1(_loc10_))
               {
                  _loc7_.push(_loc9_);
               }
            }
         }
         else
         {
            _loc7_ = _loc6_;
         }
         _loc8_ = new DataFeedEvent(DataFeedEvent.SORT_FILTER);
         _loc8_.mIndicesArray = _loc7_;
         _loc8_.mDataArray = _loc5_;
         _loc8_.mbResetPosition = param4;
         this.mDataFeed.dispatchEvent(_loc8_);
      }
      
      protected function DoSorting(param1:Object = null, param2:Object = null) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Array = this.mDataFeed.RequestItemsAt(0,this.mDataFeed.length);
         if(Boolean(param1) && param1 is Array)
         {
            if(Boolean(param2) && param2 is Number)
            {
               _loc5_ = param2 as Number | Array.RETURNINDEXEDARRAY;
               _loc4_ = _loc3_.sortOn(param1 as Array,_loc5_);
            }
            else if(Boolean(param2) && param2 is Array)
            {
               _loc6_ = param2 as Array;
               if((Boolean(_loc6_)) && _loc6_.length > 0)
               {
                  _loc6_[0] |= Array.RETURNINDEXEDARRAY;
               }
               else
               {
                  _loc6_ = [Array.RETURNINDEXEDARRAY];
               }
               _loc4_ = _loc3_.sortOn(param1 as Array,_loc6_);
            }
            else
            {
               _loc4_ = _loc3_.sortOn(param1 as Array,Array.RETURNINDEXEDARRAY);
            }
         }
         else if(Boolean(param1) && param1 is Function)
         {
            _loc4_ = _loc3_.sort(param1 as Function,Array.RETURNINDEXEDARRAY);
         }
         else
         {
            _loc7_ = int(_loc3_.length);
            _loc4_ = new Array(_loc7_);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc4_[_loc8_] = _loc8_;
               _loc8_++;
            }
         }
         return _loc4_;
      }
   }
}

