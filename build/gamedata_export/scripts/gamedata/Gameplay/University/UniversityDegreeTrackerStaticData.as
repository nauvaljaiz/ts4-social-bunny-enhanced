package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class UniversityDegreeTrackerStaticData extends OlympusObject
   {
      
      protected static var sData:UniversityDegreeTrackerStaticData;
      
      public var credits_required:int;
      
      public var max_term_course_count:int;
      
      public function UniversityDegreeTrackerStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : UniversityDegreeTrackerStaticData
      {
         if(!sData)
         {
            sData = new UniversityDegreeTrackerStaticData(CommunicationManager.CallGameService("GetDegreeTrackerTuning"));
         }
         return sData;
      }
   }
}

