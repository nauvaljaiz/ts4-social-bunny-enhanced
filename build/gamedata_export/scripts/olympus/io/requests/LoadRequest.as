package olympus.io.requests
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   
   public class LoadRequest
   {
      
      public var loader:Loader;
      
      public var target:DisplayObjectContainer;
      
      public function LoadRequest(param1:Loader, param2:DisplayObjectContainer)
      {
         super();
         this.loader = param1;
         this.target = param2;
      }
   }
}

