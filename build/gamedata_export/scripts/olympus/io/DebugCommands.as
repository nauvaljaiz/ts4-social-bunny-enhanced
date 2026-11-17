package olympus.io
{
   import flash.external.ExternalInterface;
   import olympus.utils.DebugUtils;
   
   public class DebugCommands
   {
      
      protected static var sInstance:DebugCommands;
      
      protected var mCommandMap:Object;
      
      public function DebugCommands()
      {
         super();
         if(sInstance != null)
         {
            return;
         }
         sInstance = this;
         this.mCommandMap = new Object();
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("InvokeDebugCommand",this.HandleInvokeDebugCommand);
         }
      }
      
      public static function Register(param1:String, param2:Function, param3:String, param4:String) : Boolean
      {
         if(param2 == null)
         {
            throw ArgumentError("Must provide a handling function when registering a debug command. Command: " + param1);
         }
         if(DebugUtils.IsGameClientDriven())
         {
            return sInstance.RegisterDebugCommand(param1,param2,param3,param4);
         }
         return false;
      }
      
      public static function Unregister(param1:String) : void
      {
         if(DebugUtils.IsGameClientDriven())
         {
            sInstance.UnregisterDebugCommand(param1);
         }
      }
      
      public static function Output(param1:String, param2:String) : void
      {
         if(DebugUtils.IsGameClientDriven())
         {
            ExternalInterface.call("DebugCommandOutput",param1,param2);
         }
      }
      
      public static function ExtractFlag(param1:Array, param2:String, param3:Boolean = false) : Boolean
      {
         if(!param1)
         {
            return param3;
         }
         var _loc4_:int = param1.indexOf(param2);
         if(_loc4_ < 0)
         {
            return param3;
         }
         param1.splice(_loc4_,1);
         return true;
      }
      
      public static function Yes(param1:String, param2:Boolean = false) : Boolean
      {
         if(param1)
         {
            param1 = param1.toLowerCase();
            if(["y","yes","on","true","1","enable"].indexOf(param1) >= 0)
            {
               return true;
            }
         }
         return param2;
      }
      
      public static function No(param1:String, param2:Boolean = false) : Boolean
      {
         if(param1)
         {
            param1 = param1.toLowerCase();
            if(["n","no","off","false","0","disable"].indexOf(param1) >= 0)
            {
               return true;
            }
         }
         return param2;
      }
      
      protected function RegisterDebugCommand(param1:String, param2:Function, param3:String, param4:String) : Boolean
      {
         if(param1.substr(0,3) != "ui." && param1.substr(0,6) != "qa.ui.")
         {
            throw ArgumentError("Cannot register debug commands outside of the ui or qa.ui namespace: " + param1);
         }
         if(ExternalInterface.available && Boolean(ExternalInterface.call("RegisterDebugCommand",param1,param3,param4)))
         {
            this.mCommandMap[param1] = param2;
            return true;
         }
         return false;
      }
      
      protected function UnregisterDebugCommand(param1:String) : void
      {
         delete this.mCommandMap[param1];
         if(ExternalInterface.available)
         {
            ExternalInterface.call("UnregisterDebugCommand",param1);
         }
      }
      
      protected function HandleInvokeDebugCommand(param1:String, param2:Array, param3:Object, param4:String) : Boolean
      {
         var _loc5_:Function = this.mCommandMap[param1];
         if(_loc5_ == null)
         {
            throw Error("Attempted to invoke a debug command that a handler does not exist for: " + param1);
         }
         _loc5_(param2,param3,param4);
         return true;
      }
   }
}

