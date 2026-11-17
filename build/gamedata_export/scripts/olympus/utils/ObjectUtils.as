package olympus.utils
{
   import olympus.io.DebugCommands;
   
   public class ObjectUtils
   {
      
      public function ObjectUtils()
      {
         super();
      }
      
      public static function Trace(param1:Object, param2:String = "") : void
      {
         if(param2 != null && param2 != "")
         {
         }
         TraceOutObject(param1);
      }
      
      public static function DebugOutput(param1:Object, param2:String) : void
      {
         TraceOutObject(param1,"",param2);
      }
      
      public static function Explode(param1:Object, param2:Array = null, param3:Array = null) : uint
      {
         var _loc5_:String = null;
         var _loc4_:uint = 0;
         for(_loc5_ in param1)
         {
            if(param2)
            {
               param2.push(_loc5_);
            }
            if(param3)
            {
               param3.push(param1[_loc5_]);
            }
            _loc4_++;
         }
         return _loc4_;
      }
      
      public static function DeepClone(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc2_:Object = new Object();
         for(_loc3_ in param1)
         {
            _loc4_ = param1[_loc3_];
            if(typeof _loc4_ == "object")
            {
               _loc2_[_loc3_] = DeepClone(_loc4_);
            }
            else
            {
               _loc2_[_loc3_] = _loc4_;
            }
         }
         return _loc2_;
      }
      
      public static function ShallowClone(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = new Object();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function IsEmpty(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         if(param1)
         {
            var _loc3_:int = 0;
            var _loc4_:* = param1;
            for(_loc2_ in _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      protected static function TraceOutObject(param1:Object, param2:String = "", param3:String = "") : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1 is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < (param1 as Array).length)
            {
               TraceOutObject(param1[_loc4_],param2 + "[" + _loc4_ + "]",param3);
               _loc4_++;
            }
         }
         else if(param1 is Number || param1 is String || param1 is int || param1 is uint || param1 is Boolean || param1 is Function)
         {
            if(param3)
            {
               DebugCommands.Output(param3,param2 + ": " + param1);
            }
         }
         else
         {
            for(_loc5_ in param1)
            {
               _loc6_ = param2;
               if(_loc6_ != "")
               {
                  _loc6_ += "[\"" + _loc5_ + "\"]";
               }
               else
               {
                  _loc6_ += _loc5_;
               }
               TraceOutObject(param1[_loc5_],_loc6_,param3);
            }
         }
      }
   }
}

