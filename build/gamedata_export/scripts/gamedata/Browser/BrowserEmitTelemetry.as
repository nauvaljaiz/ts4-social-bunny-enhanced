package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public final class BrowserEmitTelemetry extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var module:String;
      
      public var group:String;
      
      public var name:String;
      
      public var attributes:Object;
      
      public function BrowserEmitTelemetry(param1:Object = null)
      {
         super(param1);
      }
   }
}

