package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class RentalUnitBusinessData extends OlympusObject
   {
      
      public var zone_id:String;
      
      public var overdue_rent:int;
      
      public var max_rent:int;
      
      public var tenant_alert_visible:Boolean;
      
      public var is_grace_period:Boolean;
      
      public var unit_rating_alert_state:int;
      
      public var house_description_id:String;
      
      public function RentalUnitBusinessData(param1:Object = null)
      {
         super(param1);
      }
   }
}

