package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   
   public class SituationAssignJob extends OlympusObject
   {
      
      public var situation_session_id:uint;
      
      public var sim_ids:Array = [String];
      
      public var job_resource_ids:Array = [String];
      
      public function SituationAssignJob(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
         FixupArray(this.job_resource_ids);
      }
   }
}

