package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UniversityCourseDisplayStaticData extends OlympusObject
   {
      
      public var university_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public function UniversityCourseDisplayStaticData(param1:Object = null)
      {
         super(param1);
      }
   }
}

