package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   
   public class SituationEditJobData extends OlympusObject
   {
      
      public var job_id:String;
      
      public var sim_ids:Array = [String];
      
      public var hire_count:int;
      
      public function SituationEditJobData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
      }
   }
}

