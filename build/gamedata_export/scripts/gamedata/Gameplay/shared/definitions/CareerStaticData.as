package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   
   public class CareerStaticData extends OlympusObject
   {
      
      protected static var sCareerStaticData:Vector.<CareerStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      public static const CATEGORY_WORK:String = "1";
      
      public static const CATEGORY_SCHOOL:String = "2";
      
      public static const CATEGORY_TEEN_CAREER:String = "3";
      
      public static const CATEGORY_VOLUNTEER:String = "4";
      
      public static const CATEGORY_ADULT_PARTTIME:String = "5";
      
      public static const CATEGORY_UNIVERSITY_COURSE:String = "6";
      
      public static const CATEGORY_TEEN_SIDE_HUSTLE:String = "7";
      
      public static const CATEGORY_WORK_FROM_HOME:String = "8";
      
      public static const PANEL_TYPE_NORMAL_CAREER:String = "0";
      
      public static const PANEL_TYPE_AGENT_BASED_CAREER:String = "1";
      
      public static const PANEL_TYPE_FREELANCE_CAREER:String = "2";
      
      public static const PANEL_TYPE_ODD_JOBS_CAREER:String = "3";
      
      public static const PANEL_TYPE_UNIVERSITY_CAREER:String = "4";
      
      public static const PANEL_TYPE_MISSIONS_CAREER:String = "5";
      
      public static const PANEL_TYPE_PARANORMAL_INVESTIGATOR_CAREER:String = "6";
      
      public static const PANEL_TYPE_ACTIVE_GIG_BASED_CAREER:String = "7";
      
      public static const PANEL_TYPE_QUEST_CAREER:String = "8";
      
      public static const PANEL_TYPE_SMALL_BUSINESS_CAREER:String = "9";
      
      public static const PANEL_TYPE_NOBLE_CAREER:String = "10";
      
      public static const PANEL_TYPE_VIRTUAL_NOBLE_CAREER_TITLE:String = "11";
      
      public static const UNIVERSITY_ENROLLMENT_STATUS_ENROLLED:int = 1;
      
      public static const UNIVERSITY_ENROLLMENT_STATUS_NOT_ENROLLED:int = 2;
      
      public static const UNIVERSITY_ENROLLMENT_STATUS_PROBATION:int = 3;
      
      public static const UNIVERSITY_ENROLLMENT_STATUS_SUSPENDED:int = 4;
      
      protected static var sCareerMap:Object = new Object();
      
      public var uid:String;
      
      public var start_track_id:String;
      
      public var career_category:String;
      
      public var career_panel_type:String;
      
      public var show_ideal_mood:Boolean;
      
      public var interaction_call_costar:String;
      
      public var interaction_cancel_audition:String;
      
      public var interaction_cancel_gig:String;
      
      public var interaction_find_audition:String;
      
      public var interaction_hire_agent:String;
      
      public var build_buy_info:CareerBuildBuyInfo;
      
      public var reputation:ReputationStaticData;
      
      public var startTrackData:CareerTrackStaticData;
      
      public function CareerStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : CareerStaticData
      {
         var _loc2_:CareerStaticData = sCareerMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new CareerStaticData(_loc3_[0]);
            sCareerMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function IsSchool(param1:String) : Boolean
      {
         return param1 == CareerStaticData.CATEGORY_SCHOOL || param1 == CareerStaticData.CATEGORY_UNIVERSITY_COURSE;
      }
      
      public static function IsUniversityCourse(param1:String) : Boolean
      {
         return param1 == CareerStaticData.CATEGORY_UNIVERSITY_COURSE;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.startTrackData = CareerTrackStaticData.GetStaticData(this.start_track_id);
         if(Boolean(param1) && "build_buy_info" in param1)
         {
            this.build_buy_info = new CareerBuildBuyInfo(param1["build_buy_info"]);
         }
         if(Boolean(param1) && "reputation" in param1)
         {
            this.reputation = new ReputationStaticData(param1["reputation"]);
         }
      }
   }
}

