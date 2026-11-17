package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   
   public class SimInfoLocationStatus extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var age:uint;
      
      public var is_at_home:Boolean;
      
      public var zone_id:String;
      
      public function SimInfoLocationStatus(param1:Object = null)
      {
         super(param1);
      }
   }
}

