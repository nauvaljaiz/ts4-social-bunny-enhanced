package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   
   public class UniversityData extends OlympusObject
   {
      
      public var university_id:String;
      
      public var degrees:Array = new Array();
      
      public var electives:Array = new Array();
      
      protected var mbHasAcceptedDegree:Boolean = false;
      
      public function UniversityData(param1:Object = null)
      {
         super(param1);
      }
      
      public function get HasAcceptedDegree() : Boolean
      {
         return this.mbHasAcceptedDegree;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:UniversityMajorData = null;
         var _loc4_:String = null;
         var _loc5_:UniversityCourseStaticData = null;
         this.university_id = param1.university_id;
         _loc2_ = 0;
         while(_loc2_ < param1.degrees.length)
         {
            _loc3_ = new UniversityMajorData(param1.degrees[_loc2_]);
            _loc3_.UniversityId = this.university_id;
            this.degrees.push(_loc3_);
            if(!this.mbHasAcceptedDegree && _loc3_.status == UniversityMajorData.ACCEPTED)
            {
               this.mbHasAcceptedDegree = true;
            }
            _loc2_++;
         }
         this.degrees.sort(this.DegreeSortFunction);
         _loc2_ = 0;
         while(_loc2_ < param1.elective_class_ids.length)
         {
            _loc4_ = param1.elective_class_ids[_loc2_];
            _loc5_ = UniversityCourseStaticData.GetStaticData(_loc4_);
            if(_loc5_)
            {
               this.electives.push(_loc5_);
            }
            _loc2_++;
         }
         this.electives.sort(this.ElectiveSortFunction);
      }
      
      protected function DegreeSortFunction(param1:UniversityMajorData, param2:UniversityMajorData) : int
      {
         var _loc3_:UniversityMajorStaticData = UniversityMajorStaticData.GetStaticData(param1.major_id);
         var _loc4_:UniversityMajorStaticData = UniversityMajorStaticData.GetStaticData(param2.major_id);
         if(!_loc3_)
         {
            return -1;
         }
         if(!_loc4_)
         {
            return 1;
         }
         return _loc3_.name.toString().localeCompare(_loc4_.name.toString());
      }
      
      protected function ElectiveSortFunction(param1:UniversityCourseStaticData, param2:UniversityCourseStaticData) : int
      {
         return param1.GetName(this.university_id).toString().localeCompare(param2.GetName(this.university_id).toString());
      }
   }
}

