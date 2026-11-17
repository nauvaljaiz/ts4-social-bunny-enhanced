package olympus.utils
{
   public class Functional
   {
      
      public function Functional()
      {
         super();
      }
      
      public static function NaryToUnary(param1:Function, param2:int = 0) : Function
      {
         var index:int = 0;
         var unary:Function = param1;
         var argIndex:int = param2;
         index = argIndex;
         return function(... rest):*
         {
            return unary(rest[index]);
         };
      }
      
      public static function ArgumentMatches(param1:int, param2:*) : Function
      {
         var index:int = 0;
         var argIndex:int = param1;
         var matchValue:* = param2;
         var value:* = matchValue;
         index = argIndex;
         return function(... rest):Boolean
         {
            return rest[index] == matchValue;
         };
      }
      
      public static function IsNull(param1:*) : Boolean
      {
         return param1 == null;
      }
      
      public static function IsNotNull(param1:*) : Boolean
      {
         return param1 != null;
      }
      
      public static function Not(param1:Function) : Function
      {
         var func:Function = param1;
         return function():*
         {
            return !func.apply(null,arguments);
         };
      }
   }
}

