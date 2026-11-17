package gamedata.shared
{
   import olympus.localization.Keys;
   
   public class LunarPhases
   {
      
      public static const NEW_MOON:int = 0;
      
      public static const WAXING_CRESCENT:int = 1;
      
      public static const FIRST_QUARTER:int = 2;
      
      public static const WAXING_GIBBOUS:int = 3;
      
      public static const FULL_MOON:int = 4;
      
      public static const WANING_GIBBOUS:int = 5;
      
      public static const THIRD_QUARTER:int = 6;
      
      public static const WANING_CRESCENT:int = 7;
      
      public static const PHASE_LABELS:Array = ["new_moon","waxing_crescent","first_quarter","waxing_gibbous","full_moon","waning_gibbous","third_quarter","waning_crescent"];
      
      public static const PHASE_NAMES:Array = [Keys.LUNAR_CYCLE_PHASE_NEW_MOON,Keys.LUNAR_CYCLE_PHASE_WAXING_CRESCENT,Keys.LUNAR_CYCLE_PHASE_FIRST_QUARTER,Keys.LUNAR_CYCLE_PHASE_WAXING_GIBBOUS,Keys.LUNAR_CYCLE_PHASE_FULL_MOON,Keys.LUNAR_CYCLE_PHASE_WANING_GIBBOUS,Keys.LUNAR_CYCLE_PHASE_THIRD_QUARTER,Keys.LUNAR_CYCLE_PHASE_WANING_CRESCENT];
      
      public function LunarPhases()
      {
         super();
      }
      
      public static function GetFrameLabel(param1:int) : String
      {
         if(param1 < 0 || param1 >= PHASE_LABELS.length)
         {
            throw new Error("Invalid value for lunarPhaseType: " + param1);
         }
         return PHASE_LABELS[param1];
      }
   }
}

