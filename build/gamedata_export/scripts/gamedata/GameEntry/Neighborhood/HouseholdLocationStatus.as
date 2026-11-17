package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   
   public class HouseholdLocationStatus extends OlympusObject
   {
      
      public var household_id:String;
      
      public var household_name:String;
      
      public var home_zone_id:String;
      
      public var sim_info_status:Array = [SimInfoLocationStatus];
      
      public var is_played:Boolean;
      
      public function HouseholdLocationStatus(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_info_status);
      }
   }
}

