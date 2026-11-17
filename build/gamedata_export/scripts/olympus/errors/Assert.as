package olympus.errors
{
   public class Assert extends Error
   {
      
      public function Assert(param1:String)
      {
         super(param1);
      }
      
      public static function True(param1:*) : Boolean
      {
         if(param1)
         {
            return true;
         }
         Throw("Expected: True: " + param1);
         return false;
      }
      
      public static function False(param1:*) : Boolean
      {
         if(!param1)
         {
            return true;
         }
         Throw("Expected: False: " + param1);
         return false;
      }
      
      public static function Equals(param1:*, param2:*) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         Throw("Expected: " + param1 + " == " + param2);
         return false;
      }
      
      public static function NotEquals(param1:*, param2:*) : Boolean
      {
         if(param1 != param2)
         {
            return true;
         }
         Throw("Expected: " + param1 + " != " + param2);
         return false;
      }
      
      public static function Null(param1:*) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         Throw("Expected null: " + param1);
         return false;
      }
      
      public static function NotNull(param1:*) : Boolean
      {
         if(param1 != null)
         {
            return true;
         }
         Throw("Expected not null: " + param1);
         return false;
      }
      
      public static function Throw(param1:String) : void
      {
      }
   }
}

