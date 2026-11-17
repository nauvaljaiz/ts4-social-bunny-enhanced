package gamedata.Browser
{
   import olympus.core.OlympusObject;
   
   public class BrowserNavUpdateLoadProgress extends OlympusObject
   {
      
      public var browserId:uint;
      
      public var loadProgress:Number = 0;
      
      public function BrowserNavUpdateLoadProgress(param1:Object = null)
      {
         super(param1);
      }
   }
}

