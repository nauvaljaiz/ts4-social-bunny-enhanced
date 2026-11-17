package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public final class BrowserResourceLoadError extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var resourceURL:String;
      
      public var loadErrorType:int;
      
      public function BrowserResourceLoadError(param1:Object = null)
      {
         super(param1);
      }
   }
}

