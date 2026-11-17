package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   
   public class UniversityEnrollmentData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var household_id:String;
      
      public var is_pregnant:Boolean;
      
      public var universities:Array = [UniversityData];
      
      public var scholarships:Array = [UniversityScholarship];
      
      public var housing_zone_ids:Array = [String];
      
      public var current_enrollment:UniversityEnrollmentSimData = new UniversityEnrollmentSimData();
      
      public function UniversityEnrollmentData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.universities);
         FixupArray(this.scholarships);
         FixupArray(this.housing_zone_ids);
         if(!("current_enrollment" in param1))
         {
            this.current_enrollment = null;
         }
      }
   }
}

