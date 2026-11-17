package gamedata.Gameplay.EmployeeManagement
{
   import olympus.core.OlympusObject;
   
   public class ManageEmployeesDialog extends OlympusObject
   {
      
      public var hiring_sim_id:String;
      
      public var jobs:Array = [ManageEmployeeJobData];
      
      public function ManageEmployeesDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.jobs);
      }
   }
}

