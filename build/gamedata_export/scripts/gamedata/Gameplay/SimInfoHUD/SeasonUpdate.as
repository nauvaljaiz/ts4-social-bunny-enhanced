package gamedata.Gameplay.SimInfoHUD
{
   import olympus.core.OlympusObject;
   
   public class SeasonUpdate extends OlympusObject
   {
      
      public var season_type:int;
      
      public var season_start_time:String;
      
      public var season_length:int;
      
      public var season_week:int;
      
      public var season_day:int;
      
      public function SeasonUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

