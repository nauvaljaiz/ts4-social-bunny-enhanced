package olympus.utils
{
   public final class Reflection
   {
      
      public static var sGetMembersOfType:Function;
      
      public function Reflection()
      {
         super();
      }
      
      public static function GetMembersOfType(param1:Object, param2:Object, param3:uint = 0) : Array
      {
         return sGetMembersOfType(param1,param2,param3);
      }
   }
}

