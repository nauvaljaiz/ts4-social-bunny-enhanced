package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class SimRelativeLotLocation extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var on_active_lot:Boolean;
      
      public var home_zone_active:Boolean;
      
      public var is_on_vacation:Boolean;
      
      public function SimRelativeLotLocation(param1:Object = null)
      {
         super(param1);
      }
   }
}

