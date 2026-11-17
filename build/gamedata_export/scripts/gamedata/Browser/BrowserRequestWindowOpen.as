package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public final class BrowserRequestWindowOpen extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var newBrowserId:uint;
      
      public var newBrowserWidth:int;
      
      public var newBrowserHeight:int;
      
      public var bShowNavigation:Boolean;
      
      public function BrowserRequestWindowOpen(param1:Object = null)
      {
         super(param1);
      }
   }
}

