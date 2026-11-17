package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   
   public class SimTravelAvailability extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var is_active_household:Boolean;
      
      public var household_id:String;
      
      public var is_at_work:Boolean;
      
      public var zone_id:String;
      
      public var age:int;
      
      public var selected_by_default:Boolean;
      
      public function SimTravelAvailability(param1:Object = null)
      {
         super(param1);
      }
   }
}

