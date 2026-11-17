package gamedata.Gameplay.EmployeeManagement
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ManageEmployeeRowData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var satisfaction_string:LocKey = new LocKey();
      
      public var pay:uint;
      
      public var skill_data:Array = [ManageEmployeeSkillData];
      
      public var current_career_level:uint;
      
      public var max_career_level:uint;
      
      public var mbLocked:Boolean = false;
      
      public var mbCurrentEmployee:Boolean = false;
      
      public function ManageEmployeeRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.satisfaction_string.IsValid())
         {
            this.satisfaction_string = null;
         }
         FixupArray(this.skill_data);
      }
   }
}

