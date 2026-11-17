package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MarkupMultiplierTuning extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var markup_multiplier:Number;
      
      public function MarkupMultiplierTuning(param1:Object = null)
      {
         super(param1);
      }
   }
}

