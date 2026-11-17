package olympus.utils
{
   public class ArrayUtils
   {
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function Equals(param1:Array, param2:Array) : Boolean
      {
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            if(param1[_loc3_] !== param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function ContainsAny(param1:Array, param2:Array) : Boolean
      {
         if(param1.length == 0 || param2.length == 0)
         {
            return false;
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param2.length);
         while(_loc3_ < _loc4_)
         {
            if(param1.indexOf(param2[_loc3_]) != -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function IndexOfFirst(param1:Array, param2:Array) : int
      {
         var _loc5_:int = 0;
         if(param1.length == 0 || param2.length == 0)
         {
            return -1;
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param2.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.indexOf(param2[_loc3_]);
            if(_loc5_ != -1)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public static function IndexOfByFieldName(param1:Array, param2:String, param3:Object) : int
      {
         var _loc6_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = int(param1.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1[_loc4_];
            if((Boolean(_loc6_)) && _loc6_[param2] == param3)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function Reduce(param1:Array, param2:Function, param3:* = undefined) : *
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(!param1 || param1.length == 0)
         {
            return 0;
         }
         if(param3 !== undefined)
         {
            _loc4_ = 0;
            _loc5_ = int(param1.length);
            _loc6_ = param3;
         }
         else
         {
            _loc4_ = 1;
            _loc5_ = param1.length - 1;
            _loc6_ = param1[0];
         }
         var _loc7_:int = _loc4_;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = param2(_loc6_,param1[_loc7_],_loc7_,param1);
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function Generate(param1:uint, param2:Function) : Array
      {
         var _loc3_:Array = new Array();
         _loc3_.length = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_[_loc4_] = param2(_loc4_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function GenerateFill(param1:uint, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         _loc3_.length = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_[_loc4_] = param2;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function GenerateNumericSequence(param1:Number, param2:int, param3:Number = 1) : Array
      {
         var _loc5_:int = 0;
         var _loc4_:Array = new Array();
         if(param2 > 0)
         {
            _loc4_.length = param2;
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc4_[_loc5_] = param1;
               param1 += param3;
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public static function RandomizeArray(param1:Array) : Array
      {
         var _loc5_:int = 0;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Array = new Array(param1.length);
         var _loc3_:int = 0;
         var _loc4_:* = param1.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = Random.Int(0,param1.length - 1);
            _loc2_[_loc3_] = param1[_loc5_];
            param1.splice(_loc5_,1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function SortByIncrementingText(param1:String, param2:String) : int
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:RegExp = / \d+$/;
         var _loc4_:String = param1.replace(_loc3_,"");
         if(_loc4_ != param1)
         {
            _loc5_ = param2.replace(_loc3_,"");
            if(_loc5_ != param2)
            {
               _loc6_ = _loc4_.localeCompare(_loc5_);
               if(_loc6_)
               {
                  return _loc6_;
               }
               _loc7_ = parseInt(param1.match(_loc3_)[0]);
               _loc8_ = parseInt(param2.match(_loc3_)[0]);
               if(_loc7_ > _loc8_)
               {
                  return 1;
               }
               if(_loc7_ < _loc8_)
               {
                  return -1;
               }
               return 0;
            }
         }
         return param1.localeCompare(param2);
      }
   }
}

