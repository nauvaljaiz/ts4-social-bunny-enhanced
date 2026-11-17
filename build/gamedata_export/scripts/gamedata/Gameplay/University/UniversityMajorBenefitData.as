package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UniversityMajorBenefitData extends OlympusObject
   {
      
      public var university_id:String;
      
      public var benefit:LocKey = new LocKey();
      
      public function UniversityMajorBenefitData(param1:Object = null)
      {
         super(param1);
      }
   }
}

