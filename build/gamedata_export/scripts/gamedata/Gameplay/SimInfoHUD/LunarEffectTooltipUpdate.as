package gamedata.Gameplay.SimInfoHUD
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class LunarEffectTooltipUpdate extends OlympusObject
   {
      
      public var current_moon_phase:uint;
      
      public var tooltip_text:LocKey = new LocKey();
      
      public function LunarEffectTooltipUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

