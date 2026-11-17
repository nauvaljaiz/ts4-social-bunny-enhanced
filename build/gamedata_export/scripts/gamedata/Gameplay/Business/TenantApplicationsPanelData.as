package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class TenantApplicationsPanelData extends OlympusObject
   {
      
      public var potential_households:Array = [TenantApplicationHouseholdData];
      
      public var num_households:Array = [TenantApplicationNumHouseholdData];
      
      public function TenantApplicationsPanelData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.potential_households);
         FixupArray(this.num_households);
      }
   }
}

