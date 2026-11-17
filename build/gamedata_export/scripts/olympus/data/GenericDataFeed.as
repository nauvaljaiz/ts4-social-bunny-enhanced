package olympus.data
{
   import flash.events.EventDispatcher;
   import olympus.interfaces.IDataFeed;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class GenericDataFeed extends EventDispatcher implements IDataFeed, IExtendable
   {
      
      protected var mDataArray:Array = new Array();
      
      protected var mExtensions:Object = new Object();
      
      public function GenericDataFeed()
      {
         super();
      }
      
      public function get length() : int
      {
         return this.mDataArray.length;
      }
      
      public function Destroy() : void
      {
         this.mDataArray.length = 0;
      }
      
      public function IterateWith(param1:Function) : Array
      {
         var _loc3_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc4_:int = 0;
         for each(_loc3_ in this.mDataArray)
         {
            _loc5_ = param1(_loc3_);
            if(_loc5_)
            {
               _loc2_.push({
                  "id":_loc4_,
                  "ret":_loc5_
               });
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function RequestItemsAt(param1:int, param2:int = 1) : Array
      {
         var _loc3_:int = param1 >= 0 ? int(param1 + param2) : int(this.mDataArray.length + param1 + param2);
         return this.mDataArray.slice(param1,_loc3_);
      }
      
      public function RequestItemAt(param1:int) : Object
      {
         if(param1 < 0 || param1 >= this.length)
         {
            return null;
         }
         return this.mDataArray[param1];
      }
      
      public function AddExtension(param1:Class) : IExtension
      {
         var _loc2_:Object = new param1();
         if(!(_loc2_ is IExtension))
         {
            throw new Error("Trying to use a class that is not an Extension!");
         }
         var _loc3_:IExtension = _loc2_ as IExtension;
         _loc3_.Extend(this);
         var _loc4_:Class = param1["SlotType"] as Class;
         if(!_loc4_)
         {
            _loc4_ = param1;
         }
         this.mExtensions[_loc4_] = _loc3_;
         return _loc3_;
      }
      
      public function GetExtension(param1:Class, param2:Boolean = true) : IExtension
      {
         var _loc3_:Class = param1["SlotType"] as Class;
         if(!_loc3_)
         {
            _loc3_ = param1;
         }
         var _loc4_:IExtension = this.mExtensions[_loc3_];
         if(!_loc4_ && param2)
         {
            _loc4_ = this.AddExtension(param1);
         }
         return _loc4_;
      }
      
      public function RemoveExtension(param1:Class) : Boolean
      {
         var _loc2_:Class = param1["SlotType"] as Class;
         if(!_loc2_)
         {
            _loc2_ = param1;
         }
         if(this.mExtensions[_loc2_])
         {
            this.mExtensions[_loc2_] = null;
            delete this.mExtensions[_loc2_];
            return true;
         }
         return false;
      }
   }
}

