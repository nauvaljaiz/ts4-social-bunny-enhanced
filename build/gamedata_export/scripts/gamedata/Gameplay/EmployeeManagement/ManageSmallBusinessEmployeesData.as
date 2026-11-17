package gamedata.Gameplay.EmployeeManagement
{
   import olympus.core.OlympusObject;
   
   public class ManageSmallBusinessEmployeesData extends OlympusObject
   {
      
      public var hiring_sim_id:String;
      
      public var employees:Array = [ManageSmallBusinessEmployeeRowData];
      
      public var has_no_potential_employees:Boolean;
      
      public function ManageSmallBusinessEmployeesData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.employees);
      }
   }
}

