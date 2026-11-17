package gamedata.Gameplay.HorseCompetition
{
   import olympus.core.OlympusObject;
   
   public class HorseCompetitionResults extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var horse_id:String;
      
      public var competition_id:Number;
      
      public var placement:Number;
      
      public var unlocked_new_competition:Boolean;
      
      public var unlocked_competition_id:Number;
      
      public function HorseCompetitionResults(param1:Object = null)
      {
         super(param1);
      }
   }
}

