package olympus.core.data
{
   public class Multimap
   {
      
      protected var mStorage:Object;
      
      public function Multimap()
      {
         super();
         this.mStorage = new Object();
      }
      
      public static function KeyMatches(param1:String) : Function
      {
         var k:String = null;
         var matchKey:String = param1;
         k = matchKey;
         return function(param1:String, param2:Object):Boolean
         {
            return param1 == k;
         };
      }
      
      public static function ValueMatches(param1:Object) : Function
      {
         var val:Object = null;
         var matchValue:Object = param1;
         val = matchValue;
         return function(param1:String, param2:Object):Boolean
         {
            return param2 == val;
         };
      }
      
      public static function KeyValueMatches(param1:String, param2:Object) : Function
      {
         var k:String = null;
         var val:Object = null;
         var matchKey:String = param1;
         var matchValue:Object = param2;
         k = matchKey;
         val = matchValue;
         return function(param1:String, param2:Object):Boolean
         {
            return param1 == k && param2 == val;
         };
      }
      
      public function Insert(param1:String, param2:Object) : void
      {
         var _loc3_:Array = this.mStorage[param1] as Array;
         if(_loc3_ == null)
         {
            _loc3_ = new Array();
            this.mStorage[param1] = _loc3_;
         }
         _loc3_.push(param2);
      }
      
      public function Remove(param1:String, param2:Object) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = this.mStorage[param1] as Array;
         if(_loc3_)
         {
            _loc4_ = _loc3_.indexOf(param2);
            if(_loc4_ >= 0)
            {
               _loc3_.splice(_loc4_,1);
               if(_loc3_.length == 0)
               {
                  delete this.mStorage[param1];
               }
            }
         }
      }
      
      public function RemoveAll(param1:String) : void
      {
         if(this.mStorage[param1])
         {
            delete this.mStorage[param1];
         }
      }
      
      public function RemoveAt(param1:String, param2:int) : Object
      {
         var _loc3_:Array = this.mStorage[param1] as Array;
         if(_loc3_ == null)
         {
            return null;
         }
         if(param2 < 0)
         {
            param2 = _loc3_.length + param2;
         }
         if(param2 < 0 || param2 >= _loc3_.length)
         {
            return null;
         }
         var _loc4_:Object = _loc3_.splice(param2,1)[0];
         if(_loc3_.length == 0)
         {
            delete this.mStorage[param1];
         }
         return _loc4_;
      }
      
      public function RemoveIf(param1:Function, param2:Array = null, param3:Vector.<String> = null) : uint
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc5_:uint = 0;
         for(_loc6_ in this.mStorage)
         {
            _loc7_ = this.mStorage[_loc6_] as Array;
            if(_loc7_)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = _loc7_[_loc8_];
                  if(param1(_loc6_,_loc9_))
                  {
                     _loc7_.splice(_loc8_,1);
                     _loc5_++;
                     if(param2)
                     {
                        param2.push(_loc9_);
                     }
                  }
                  else
                  {
                     _loc8_++;
                  }
               }
               if(_loc7_.length == 0)
               {
                  _loc4_.push(_loc6_);
               }
            }
            else
            {
               _loc4_.push(_loc6_);
            }
         }
         for each(_loc6_ in _loc4_)
         {
            delete this.mStorage[_loc6_];
            if(param3)
            {
               param3.push(_loc6_);
            }
         }
         return _loc5_;
      }
      
      public function Clear() : void
      {
         this.mStorage = new Object();
      }
      
      public function KeyHasValue(param1:String, param2:Object) : Boolean
      {
         var _loc3_:Array = this.mStorage[param1] as Array;
         if(_loc3_)
         {
            return _loc3_.indexOf(param2) >= 0;
         }
         return false;
      }
      
      public function Enumerate(param1:Function) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in this.mStorage)
         {
            for each(_loc3_ in this.mStorage[_loc2_])
            {
               param1(_loc2_,_loc3_);
            }
         }
      }
      
      public function EnumerateUserData(param1:Function, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         for(_loc3_ in this.mStorage)
         {
            for each(_loc4_ in this.mStorage[_loc3_])
            {
               if(param1(_loc3_,_loc4_,param2))
               {
                  return;
               }
            }
         }
      }
      
      public function IterateValues(param1:String = null) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc2_:Array = new Array();
         if(param1)
         {
            _loc3_ = this.mStorage[param1] as Array;
            if(_loc3_)
            {
               _loc2_ = _loc2_.concat(_loc3_);
            }
         }
         else
         {
            for each(_loc4_ in this.mStorage)
            {
               _loc2_ = _loc2_.concat(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function IterateKeys() : Vector.<String>
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for(_loc2_ in this.mStorage)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function IterateKeyValues() : Vector.<KeyValue>
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<KeyValue> = new Vector.<KeyValue>();
         for(_loc2_ in this.mStorage)
         {
            for each(_loc3_ in this.mStorage[_loc2_])
            {
               _loc1_.push(new KeyValue(_loc2_,_loc3_));
            }
         }
         return _loc1_;
      }
      
      public function Count(param1:String) : uint
      {
         var _loc2_:Array = this.mStorage[param1] as Array;
         if(_loc2_)
         {
            return _loc2_.length;
         }
         return 0;
      }
      
      public function CountKeys() : uint
      {
         var _loc2_:String = null;
         var _loc1_:uint = 0;
         for(_loc2_ in this.mStorage)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function Size() : uint
      {
         var _loc2_:Array = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.mStorage)
         {
            _loc1_ += _loc2_.length;
         }
         return _loc1_;
      }
      
      public function Empty() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.mStorage;
         for each(_loc1_ in _loc3_)
         {
            return false;
         }
         return true;
      }
   }
}

