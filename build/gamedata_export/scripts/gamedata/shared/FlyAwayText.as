package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class FlyAwayText extends OlympusObject
   {
      
      public static const FLYAWAY_LOCATION_ASPIRATION_PANEL_BUTTON:int = 0;
      
      public static const SIMOLEON_WALLET_BUCKS_FLYAWAY_SOURCE:String = "bucks_wallet";
      
      public static const MOUSE_OFFSET_X:Number = 0;
      
      public static const MOUSE_OFFSET_Y:Number = -50;
      
      public static const FLYAWAY_TEXT_GOOD:String = "good";
      
      public static const FLYAWAY_TEXT_BAD:String = "bad";
      
      public var key:LocKey = new LocKey();
      
      public var text:String;
      
      public var x:Number = NaN;
      
      public var y:Number = NaN;
      
      public var type:String = "good";
      
      public var audioKey:String;
      
      public var audioEventStrings:Array;
      
      public var source:String = null;
      
      public var resizeTextToFitStageWidth:Boolean = false;
      
      public function FlyAwayText(param1:Object = null)
      {
         super(param1);
      }
   }
}

