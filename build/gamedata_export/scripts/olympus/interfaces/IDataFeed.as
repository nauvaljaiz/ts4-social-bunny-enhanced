package olympus.interfaces
{
   import flash.events.Event;
   
   public interface IDataFeed
   {
      
      function get length() : int;
      
      function Destroy() : void;
      
      function IterateWith(param1:Function) : Array;
      
      function RequestItemsAt(param1:int, param2:int = 1) : Array;
      
      function RequestItemAt(param1:int) : Object;
      
      function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function dispatchEvent(param1:Event) : Boolean;
      
      function hasEventListener(param1:String) : Boolean;
      
      function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function willTrigger(param1:String) : Boolean;
   }
}

