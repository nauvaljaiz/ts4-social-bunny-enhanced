package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class TenantApplicationHouseholdOccupantData extends OlympusObject
   {
      
      public var occupant_age:int;
      
      public var occupant_species:int;
      
      public function TenantApplicationHouseholdOccupantData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

