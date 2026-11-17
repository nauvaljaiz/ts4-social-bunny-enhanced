package olympus.io
{
   public final class CommunicationObject
   {
      
      protected var mFunctions:Array;
      
      protected var mbDispatching:Boolean = false;
      
      protected var mPendingRemoval:Array;
      
      public function CommunicationObject(param1:String, param2:Function)
      {
         super();
         this.mFunctions = new Array();
         this.mFunctions.push(new WidgetFunction(param1,param2));
      }
      
      public function GetFunctions() : Array
      {
         return this.mFunctions;
      }
      
      public function Dispatch(param1:Object) : Object
      {
         var _loc3_:WidgetFunction = null;
         var _loc4_:WidgetFunction = null;
         var _loc2_:Object = null;
         this.mbDispatching = true;
         for each(_loc3_ in this.mFunctions)
         {
            _loc2_ = _loc3_.mFunction(param1);
         }
         this.mbDispatching = false;
         if(this.mPendingRemoval)
         {
            for each(_loc4_ in this.mPendingRemoval)
            {
               this.RemoveFunction(_loc4_.mWidgetName,_loc4_.mFunction);
            }
            this.mPendingRemoval = null;
         }
         return _loc2_;
      }
      
      public function DispatchToWidget(param1:String, param2:Object) : Object
      {
         var _loc4_:WidgetFunction = null;
         var _loc5_:WidgetFunction = null;
         var _loc3_:Object = null;
         this.mbDispatching = true;
         for each(_loc4_ in this.mFunctions)
         {
            if(_loc4_.mWidgetName == param1)
            {
               _loc3_ = _loc4_.mFunction(param2);
            }
         }
         this.mbDispatching = false;
         if(this.mPendingRemoval)
         {
            for each(_loc5_ in this.mPendingRemoval)
            {
               this.RemoveFunction(_loc5_.mWidgetName,_loc5_.mFunction);
            }
            this.mPendingRemoval = null;
         }
         return _loc3_;
      }
      
      public function IsEmpty() : Boolean
      {
         return this.mFunctions.length == 0;
      }
      
      public function HasFunction(param1:Function) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.mFunctions.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.mFunctions[_loc2_].mFunction == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function HasWidget(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this.mFunctions.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.mFunctions[_loc2_].mWidgetName == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function AddFunction(param1:String, param2:Function) : Boolean
      {
         if(Boolean(this.mFunctions.fixed) || this.HasFunction(param2))
         {
            return false;
         }
         this.mFunctions.push(new WidgetFunction(param1,param2));
         return true;
      }
      
      public function RemoveFunction(param1:String, param2:Function) : Boolean
      {
         var _loc3_:* = 0;
         var _loc4_:WidgetFunction = null;
         if(this.mbDispatching)
         {
            if(!this.mPendingRemoval)
            {
               this.mPendingRemoval = new Array();
            }
            this.mPendingRemoval.push(new WidgetFunction(param1,param2));
            return true;
         }
         _loc3_ = int(this.mFunctions.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this.mFunctions[_loc3_];
            if(_loc4_.mWidgetName == param1 && _loc4_.mFunction == param2)
            {
               this.mFunctions.splice(_loc3_,1);
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public function RemoveWidgetsFunctions(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:WidgetFunction = null;
         if(this.mbDispatching && !this.mPendingRemoval)
         {
            this.mPendingRemoval = new Array();
         }
         _loc2_ = int(this.mFunctions.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.mFunctions[_loc2_];
            if(_loc3_.mWidgetName == param1)
            {
               if(this.mbDispatching)
               {
                  this.mPendingRemoval.push(_loc3_);
               }
               else
               {
                  this.mFunctions.splice(_loc2_,1);
               }
            }
            _loc2_--;
         }
      }
   }
}

