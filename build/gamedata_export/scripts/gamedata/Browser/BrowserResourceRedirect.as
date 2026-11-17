package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public final class BrowserResourceRedirect extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var resourceURL:String;
      
      public var redirectedURL:String;
      
      public var statusCode:int;
      
      public function BrowserResourceRedirect(param1:Object = null)
      {
         super(param1);
      }
   }
}

