package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   
   public class SituationSimJoined extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var sim_id:String;
      
      public var job_assignment:SituationJobAssignment = new SituationJobAssignment();
      
      public function SituationSimJoined(param1:Object = null)
      {
         super(param1);
      }
   }
}

