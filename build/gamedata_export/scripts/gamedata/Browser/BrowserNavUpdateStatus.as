package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public class BrowserNavUpdateStatus extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var canGoForward:Boolean;
      
      public var canGoBackward:Boolean;
      
      public var canRefresh:Boolean;
      
      public var canStop:Boolean;
      
      public function BrowserNavUpdateStatus(param1:Object = null)
      {
         super(param1);
      }
   }
}

