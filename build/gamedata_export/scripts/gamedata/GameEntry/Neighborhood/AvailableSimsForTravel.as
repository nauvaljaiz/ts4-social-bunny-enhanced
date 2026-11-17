package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   
   public class AvailableSimsForTravel extends OlympusObject
   {
      
      public var actor_sim_id:String;
      
      public var sim_ids_for_travel:Array = [String];
      
      public var available_sims:Array = [SimTravelAvailability];
      
      public function AvailableSimsForTravel(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids_for_travel);
         FixupArray(this.available_sims);
      }
   }
}

