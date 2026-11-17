package olympus.utils
{
   import flash.display.DisplayObject;
   
   public class DebugUtils
   {
      
      protected static var mbGameClientDriven:Boolean = false;
      
      protected static var mbUIManagerLoaded:Boolean = false;
      
      protected static var mbDebugMode:Boolean = false;
      
      public function DebugUtils()
      {
         super();
      }
      
      public static function SetGameClientDriven(param1:Boolean) : void
      {
         mbGameClientDriven = param1;
      }
      
      public static function IsGameClientDriven() : Boolean
      {
         return mbGameClientDriven;
      }
      
      public static function SetIsUIManagerLoaded(param1:Boolean) : void
      {
         mbUIManagerLoaded = param1;
      }
      
      public static function IsUIManagerLoaded() : Boolean
      {
         return mbUIManagerLoaded;
      }
      
      public static function SetDebugMode(param1:Boolean) : void
      {
         mbDebugMode = param1;
      }
      
      public static function IsDebug() : Boolean
      {
         return mbDebugMode;
      }
      
      public static function GetDisplayObjectPath(param1:DisplayObject, param2:uint = 4294967295) : String
      {
         if(param1 == null)
         {
            return "";
         }
         if(param2 > 0 && param1.parent != null)
         {
            return GetDisplayObjectPath(param1.parent,param2 - 1) + "." + param1.name;
         }
         return param1.name;
      }
   }
}

