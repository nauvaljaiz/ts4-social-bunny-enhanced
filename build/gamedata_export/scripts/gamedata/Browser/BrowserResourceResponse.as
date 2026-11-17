package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public final class BrowserResourceResponse extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var resourceURL:String;
      
      public var statusCode:int;
      
      public function BrowserResourceResponse(param1:Object = null)
      {
         super(param1);
      }
   }
}

