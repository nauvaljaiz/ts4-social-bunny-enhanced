package olympus.utils
{
   public class Clamp
   {
      
      public function Clamp()
      {
         super();
      }
      
      public static function Int(param1:int, param2:int, param3:int) : int
      {
         if(param3 < param2)
         {
            return param1;
         }
         if(param1 <= param2)
         {
            return param2;
         }
         if(param1 >= param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function Uint(param1:uint, param2:uint, param3:uint) : uint
      {
         if(param3 < param2)
         {
            return param1;
         }
         if(param1 <= param2)
         {
            return param2;
         }
         if(param1 >= param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function Num(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param3 < param2)
         {
            return param1;
         }
         if(param1 <= param2)
         {
            return param2;
         }
         if(param1 >= param3)
         {
            return param3;
         }
         return param1;
      }
   }
}

