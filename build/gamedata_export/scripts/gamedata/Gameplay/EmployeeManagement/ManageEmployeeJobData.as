package gamedata.Gameplay.EmployeeManagement
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class ManageEmployeeJobData extends OlympusObject
   {
      
      public var employees:Array = [ManageEmployeeRowData];
      
      public var available_sims:Array = [ManageEmployeeRowData];
      
      public var open_slots:uint;
      
      public var locked_slots:uint;
      
      public var job_type:uint;
      
      public var job_name:LocKey = new LocKey();
      
      public var job_icon:IconInfo = new IconInfo();
      
      public function ManageEmployeeJobData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.employees);
         FixupArray(this.available_sims);
      }
   }
}

