package gamedata.shared
{
   public final class SeasonTypes
   {
      
      public static const NONE:int = -1;
      
      public static const SUMMER:int = 0;
      
      public static const FALL:int = 1;
      
      public static const WINTER:int = 2;
      
      public static const SPRING:int = 3;
      
      public static const SEASON_LABELS:Array = ["summer","fall","winter","spring"];
      
      public function SeasonTypes()
      {
         super();
      }
      
      public static function GetSeasonLabel(param1:int) : String
      {
         if(param1 >= 0 && param1 < SEASON_LABELS.length)
         {
            return SEASON_LABELS[param1];
         }
         return null;
      }
      
      public static function GetNextSeason(param1:int) : int
      {
         return (param1 + 1) % 4;
      }
      
      public static function GetWeeksInYear(param1:int) : int
      {
         return param1 * 4 / 7;
      }
   }
}

