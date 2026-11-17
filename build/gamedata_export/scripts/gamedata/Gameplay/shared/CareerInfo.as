package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.Careers.GigInfo;
   import gamedata.Gameplay.Kingdom.KingdomStaticData;
   import gamedata.Gameplay.shared.definitions.AspirationCareerStaticData;
   import gamedata.Gameplay.shared.definitions.CareerBuildBuyInfo;
   import gamedata.Gameplay.shared.definitions.CareerLevelStaticData;
   import gamedata.Gameplay.shared.definitions.CareerSituationStaticData;
   import gamedata.Gameplay.shared.definitions.CareerStaticData;
   import gamedata.Gameplay.shared.definitions.CareerTrackStaticData;
   import gamedata.Gameplay.shared.definitions.PerformanceStaticData;
   import gamedata.Gameplay.shared.definitions.ReputationStaticData;
   import gamedata.Gameplay.shared.definitions.ScheduleEntryStaticData;
   import gamedata.Gameplay.shared.definitions.SmallBusinessCareerData;
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   import olympus.core.Time;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.math.TimeSpan;
   
   public class CareerInfo extends OlympusObject
   {
      
      public static const SELECTOR_TYPE_ALL:int = 0;
      
      public static const SELECTOR_TYPE_ACTIVE:int = 1;
      
      public static const SELECTOR_TYPE_WORK:int = 2;
      
      public static const SELECTOR_TYPE_VOLUNTEER:int = 3;
      
      public static const SELECTOR_TYPE_ADULT_PARTTIME:int = 4;
      
      public static const SELECTOR_TYPE_WORK_FROM_HOME:int = 5;
      
      public var uid:String;
      
      public var company:LocKey = new LocKey();
      
      public var conflicted_schedule:Boolean;
      
      public var career_track:String;
      
      public var career_level:uint;
      
      public var auto_work:Boolean;
      
      public var performance:int;
      
      public var performance_complete:Boolean;
      
      public var age:uint;
      
      public var career_situation:Object;
      
      public var work_state:int;
      
      public var user_career_level:uint;
      
      public var skip_next_shift:Boolean;
      
      public var performance_tooltip:LocKey = new LocKey();
      
      public var is_retired:Boolean;
      
      public var paid_time_off_available:uint;
      
      public var paid_time_off_disabled:Boolean;
      
      public var panel_string:LocKey = new LocKey();
      
      public var tooltip_string:LocKey = new LocKey();
      
      public var pay:uint;
      
      public var pay_raise_count:uint;
      
      public var work_schedule:Schedule = new Schedule();
      
      public var active_assignments:Array = [String];
      
      public var end_time_override:uint;
      
      public var enable_go_to_work:Boolean;
      
      public var enable_go_to_work_early:Boolean;
      
      public var gig_info:GigInfo;
      
      public var schedule_shift_type:int = 0;
      
      public var is_active:Boolean;
      
      public var is_selectable:Boolean = true;
      
      public var days_to_enroll:uint;
      
      public var enrollment_status:int = 2;
      
      public var additional_description:LocKey;
      
      public var course_skill_name:LocKey;
      
      public var course_description:LocKey;
      
      public var university_career_uid:String;
      
      public var university_uid:String;
      
      public var career_button_tooltip_description:LocKey;
      
      public var hourly_pay:uint;
      
      public var benefit_description:LocKey;
      
      public var preferred_region:String;
      
      public var reputation:int;
      
      public var career_display_name_override:LocKey;
      
      public var follow_enabled:Boolean;
      
      public var not_selectable_tooltip:LocKey;
      
      public var workplace_rival_id:String;
      
      public var burnout:Boolean;
      
      public var small_business_career_data:Array = [SmallBusinessCareerData];
      
      public var custom_level_title:String;
      
      public var work_from_home_description:LocKey;
      
      public var enable_infants_tray_button:Boolean = false;
      
      public var sim_id:String;
      
      public var situationStaticData:CareerSituationStaticData = null;
      
      public var mbIsActiveCareer:Boolean = false;
      
      public var mbHasBeenSeen:Boolean = false;
      
      public var uni_classes:Array = [CareerInfo];
      
      public var virtual_career:VirtualCareer = null;
      
      protected var mStaticData:CareerStaticData;
      
      protected var mTrackStaticData:CareerTrackStaticData;
      
      protected var mObjectiveInfos:Vector.<ObjectiveInfo>;
      
      protected var mAssignmentInfos:Vector.<ObjectiveInfo>;
      
      public function CareerInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function CategorySortingFunction(param1:CareerInfo, param2:CareerInfo) : Number
      {
         if(param1.preferred_region != "0")
         {
            return param1.preferred_region == GameplayStateData.CurrentRegionDescriptionId ? -1 : 1;
         }
         if(param2.preferred_region != "0")
         {
            return param2.preferred_region == GameplayStateData.CurrentRegionDescriptionId ? 1 : -1;
         }
         if(param1.mStaticData.career_category == CareerStaticData.CATEGORY_WORK && param2.mStaticData.career_panel_type == CareerStaticData.PANEL_TYPE_QUEST_CAREER)
         {
            return -1;
         }
         if(param2.mStaticData.career_category == CareerStaticData.CATEGORY_WORK && param1.mStaticData.career_panel_type == CareerStaticData.PANEL_TYPE_QUEST_CAREER)
         {
            return 1;
         }
         if(param1.mStaticData.career_panel_type == CareerStaticData.PANEL_TYPE_NOBLE_CAREER)
         {
            return -1;
         }
         if(param2.mStaticData.career_panel_type == CareerStaticData.PANEL_TYPE_NOBLE_CAREER)
         {
            return 1;
         }
         return param1.mStaticData.career_category.localeCompare(param2.mStaticData.career_category);
      }
      
      public function get CareerSelectorType() : int
      {
         switch(this.career_category)
         {
            case CareerStaticData.CATEGORY_WORK:
               return this.mbIsActiveCareer ? SELECTOR_TYPE_ACTIVE : SELECTOR_TYPE_WORK;
            case CareerStaticData.CATEGORY_VOLUNTEER:
               return SELECTOR_TYPE_VOLUNTEER;
            case CareerStaticData.CATEGORY_ADULT_PARTTIME:
               return SELECTOR_TYPE_ADULT_PARTTIME;
            case CareerStaticData.CATEGORY_WORK_FROM_HOME:
               return SELECTOR_TYPE_WORK_FROM_HOME;
            case CareerStaticData.CATEGORY_TEEN_CAREER:
            case CareerStaticData.CATEGORY_TEEN_SIDE_HUSTLE:
            case CareerStaticData.CATEGORY_SCHOOL:
         }
         return SELECTOR_TYPE_WORK;
      }
      
      public function GetCompanyName(param1:String) : String
      {
         if(this.uid == KingdomStaticData.GetStaticData().noble_career)
         {
            param1 = this.company.toString();
         }
         else
         {
            param1 = Keys.GENERIC_NEWLINE.toString(param1,KeysGP.RELATIONSHIP_PANEL_COMPANY_LABEL.toString(this.company.toString()));
         }
         return param1;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         if("uid" in param1)
         {
            this.uid = param1.uid;
         }
         if("virtual_career" in param1)
         {
            this.virtual_career = param1.virtual_career;
         }
         var _loc2_:Boolean = !this.virtual_career;
         if("career_uid" in param1)
         {
            this.uid = param1.career_uid;
            _loc2_ = false;
         }
         if("company" in param1)
         {
            this.company = new LocKey(param1["company"]);
         }
         if("conflicted_schedule" in param1)
         {
            this.conflicted_schedule = param1.conflicted_schedule;
         }
         if("career_track" in param1)
         {
            this.career_track = param1.career_track;
         }
         if("career_level" in param1)
         {
            this.career_level = param1.career_level;
         }
         if("auto_work" in param1)
         {
            this.auto_work = param1.auto_work;
         }
         if("performance" in param1)
         {
            this.performance = param1.performance;
         }
         if("performance_complete" in param1)
         {
            this.performance_complete = param1.performance_complete;
         }
         if("age" in param1)
         {
            this.age = param1.age;
         }
         if("career_situation" in param1)
         {
            this.career_situation = param1.career_situation;
         }
         if("work_state" in param1)
         {
            this.work_state = param1.work_state;
         }
         if("user_career_level" in param1)
         {
            this.user_career_level = param1.user_career_level;
         }
         if("skip_next_shift" in param1)
         {
            this.skip_next_shift = param1.skip_next_shift;
         }
         if("performance_tooltip" in param1)
         {
            this.performance_tooltip = new LocKey(param1["performance_tooltip"]);
         }
         if(!this.performance_tooltip.IsValid())
         {
            this.performance_tooltip = null;
         }
         if("is_retired" in param1)
         {
            this.is_retired = param1.is_retired;
         }
         if("paid_time_off_available" in param1)
         {
            this.paid_time_off_available = param1.paid_time_off_available;
         }
         if("paid_time_off_disabled" in param1)
         {
            this.paid_time_off_disabled = param1.paid_time_off_disabled;
         }
         if("panel_string" in param1)
         {
            this.panel_string = new LocKey(param1["panel_string"]);
         }
         if(!this.panel_string.IsValid())
         {
            this.panel_string = null;
         }
         if("tooltip_string" in param1)
         {
            this.tooltip_string = new LocKey(param1["tooltip_string"]);
         }
         if(!this.tooltip_string.IsValid())
         {
            this.tooltip_string = null;
         }
         if("pay" in param1)
         {
            this.pay = param1.pay;
         }
         if("pay_raise_count" in param1)
         {
            this.pay_raise_count = param1.pay_raise_count;
         }
         if("work_schedule" in param1)
         {
            this.work_schedule.ParseObject(param1.work_schedule);
         }
         else
         {
            this.work_schedule = null;
         }
         if("active_assignments" in param1)
         {
            ConstructArrayFromArray(this.active_assignments,param1.active_assignments,String);
         }
         if("end_time_override" in param1)
         {
            this.end_time_override = param1.end_time_override;
         }
         if("enable_go_to_work" in param1)
         {
            this.enable_go_to_work = param1.enable_go_to_work;
         }
         if("enable_go_to_work_early" in param1)
         {
            this.enable_go_to_work_early = param1.enable_go_to_work_early;
         }
         if("gig_info" in param1)
         {
            this.gig_info = new GigInfo(param1["gig_info"]);
         }
         if("schedule_shift_type" in param1)
         {
            this.schedule_shift_type = param1.schedule_shift_type;
         }
         if("is_active" in param1)
         {
            this.is_active = param1.is_active;
         }
         if("is_selectable" in param1)
         {
            this.is_selectable = param1.is_selectable;
         }
         if("days_to_enroll" in param1)
         {
            this.days_to_enroll = param1.days_to_enroll;
         }
         if("enrollment_status" in param1)
         {
            this.enrollment_status = param1.enrollment_status;
         }
         if("additional_description" in param1)
         {
            this.additional_description = new LocKey(param1["additional_description"]);
         }
         if("course_skill_name" in param1)
         {
            this.course_skill_name = new LocKey(param1["course_skill_name"]);
         }
         if("course_description" in param1)
         {
            this.course_description = new LocKey(param1["course_description"]);
         }
         if("university_career_uid" in param1)
         {
            this.university_career_uid = param1.university_career_uid;
         }
         if("university_uid" in param1)
         {
            this.university_uid = param1.university_uid;
         }
         if("career_button_tooltip_description" in param1)
         {
            this.career_button_tooltip_description = new LocKey(param1["career_button_tooltip_description"]);
         }
         if("hourly_pay" in param1)
         {
            this.hourly_pay = param1.hourly_pay;
         }
         if("benefit_description" in param1)
         {
            this.benefit_description = new LocKey(param1["benefit_description"]);
         }
         if("preferred_region" in param1)
         {
            this.preferred_region = param1.preferred_region;
         }
         if("reputation" in param1)
         {
            this.reputation = param1.reputation;
         }
         if("career_display_name_override" in param1)
         {
            this.career_display_name_override = new LocKey(param1["career_display_name_override"]);
         }
         if("follow_enabled" in param1)
         {
            this.follow_enabled = param1.follow_enabled;
         }
         if("not_selectable_tooltip" in param1)
         {
            this.not_selectable_tooltip = new LocKey(param1["not_selectable_tooltip"]);
         }
         if("workplace_rival_id" in param1)
         {
            this.workplace_rival_id = param1.workplace_rival_id;
         }
         if("burnout" in param1)
         {
            this.burnout = param1.burnout;
         }
         if("sim_id" in param1)
         {
            this.sim_id = param1.sim_id;
         }
         if("uni_classes" in param1)
         {
            ConstructArrayFromArray(this.uni_classes,param1.uni_classes,CareerInfo);
         }
         if("small_business_career_data" in param1)
         {
            ConstructArrayFromArray(this.small_business_career_data,param1.small_business_career_data,SmallBusinessCareerData);
         }
         if("custom_level_title" in param1)
         {
            this.custom_level_title = param1.custom_level_title;
         }
         FixupArray(this.active_assignments);
         FixupArray(this.uni_classes);
         FixupArray(this.small_business_career_data);
         this.mStaticData = CareerStaticData.GetStaticData(this.uid);
         this.mTrackStaticData = CareerTrackStaticData.GetStaticData(this.career_track);
         if(_loc2_)
         {
            this.mObjectiveInfos = GameplayStateData.GetAspirationObjectiveInfos(this.currentCareerLevel.aspiration.objectiveUids);
         }
         if(this.career_situation)
         {
            this.situationStaticData = CareerSituationStaticData.GetStaticData(this.career_situation.career_situation_id);
         }
         if(!this.virtual_career && this.pay == 0)
         {
            this.pay = this.currentCareerLevel.simoleons_per_hour;
         }
         if(this.active_assignments.length)
         {
            this.mAssignmentInfos = GameplayStateData.GetAspirationObjectiveInfos(this.active_assignments);
         }
         if("work_from_home_description" in param1)
         {
            this.work_from_home_description = new LocKey(param1["work_from_home_description"]);
         }
         if("enable_infants_tray_button" in param1)
         {
            this.enable_infants_tray_button = param1["enable_infants_tray_button"] as Boolean;
         }
      }
      
      public function get ObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mObjectiveInfos;
      }
      
      public function get AssignmentInfos() : Vector.<ObjectiveInfo>
      {
         return this.mAssignmentInfos;
      }
      
      public function get career_category() : String
      {
         return this.mStaticData.career_category;
      }
      
      public function get career_panel_type() : String
      {
         if(Boolean(this.virtual_career) && this.virtual_career.career_panel_type != "")
         {
            return this.virtual_career.career_panel_type;
         }
         return this.mStaticData.career_panel_type;
      }
      
      public function get show_ideal_mood() : Boolean
      {
         return this.mStaticData.show_ideal_mood;
      }
      
      public function get interaction_call_costar() : String
      {
         return this.mStaticData.interaction_call_costar;
      }
      
      public function get interaction_cancel_audition() : String
      {
         return this.mStaticData.interaction_cancel_audition;
      }
      
      public function get interaction_cancel_gig() : String
      {
         return this.mStaticData.interaction_cancel_gig;
      }
      
      public function get interaction_find_audition() : String
      {
         return this.mStaticData.interaction_find_audition;
      }
      
      public function get interaction_hire_agent() : String
      {
         return this.mStaticData.interaction_hire_agent;
      }
      
      public function get build_buy_info() : CareerBuildBuyInfo
      {
         return this.mStaticData.build_buy_info;
      }
      
      public function GetCurrentLevelName(param1:Object) : String
      {
         if(this.custom_level_title)
         {
            return this.custom_level_title;
         }
         return this.currentCareerLevel.name.toString(param1);
      }
      
      public function get currentLevelDescription() : LocKey
      {
         return this.currentCareerLevel.description;
      }
      
      public function get currentCareerLevel() : CareerLevelStaticData
      {
         return this.mTrackStaticData.career_levels[this.career_level] as CareerLevelStaticData;
      }
      
      public function get aspiration() : AspirationCareerStaticData
      {
         return this.currentCareerLevel.aspiration;
      }
      
      public function get idealMood() : String
      {
         return this.currentCareerLevel.ideal_mood;
      }
      
      public function get performanceData() : PerformanceStaticData
      {
         return this.currentCareerLevel.performance;
      }
      
      public function get PerformanceValue() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.performanceData.min_value;
         _loc2_ = this.performanceData.max_value;
         var _loc3_:int = _loc2_ - _loc1_;
         return (this.performance - _loc1_) / _loc3_;
      }
      
      public function get reputationData() : ReputationStaticData
      {
         return this.mStaticData.reputation;
      }
      
      public function get ReputationValue() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.reputationData == null)
         {
            return 0;
         }
         _loc1_ = this.reputationData.min_value;
         _loc2_ = this.reputationData.max_value;
         var _loc3_:int = _loc2_ - _loc1_;
         return (this.reputation - _loc1_) / _loc3_;
      }
      
      public function get trackStaticData() : CareerTrackStaticData
      {
         return this.mTrackStaticData;
      }
      
      public function get ShowNowHiringString() : Boolean
      {
         return this.mTrackStaticData.show_now_hiring_string;
      }
      
      public function get icon() : String
      {
         return this.mTrackStaticData.icon.instance;
      }
      
      public function get icon_high_res() : String
      {
         return this.mTrackStaticData.icon_high_res.instance;
      }
      
      public function get image() : String
      {
         return this.mTrackStaticData.image;
      }
      
      public function get name() : String
      {
         return this.mTrackStaticData.name.toString({"simId":this.sim_id});
      }
      
      public function get description() : LocKey
      {
         return this.mTrackStaticData.description;
      }
      
      public function GetNextJobTitle() : String
      {
         if(this.mTrackStaticData.career_levels.length == this.career_level + 1)
         {
            return null;
         }
         return (this.mTrackStaticData.career_levels[this.career_level + 1] as CareerLevelStaticData).name.toString({"simId":this.sim_id});
      }
      
      public function get EndTimeOverride() : TimeSpan
      {
         if(this.end_time_override == 0)
         {
            return null;
         }
         return new TimeSpan(Time.ConvertToSimTime(this.end_time_override));
      }
      
      public function GetScheduleEntries() : Array
      {
         if(this.work_schedule)
         {
            return this.work_schedule.ConvertToScheduleEntryStaticData();
         }
         return null;
      }
      
      public function HasBuildBuyDisplayData() : Boolean
      {
         return this.build_buy_info != null && this.gig_info != null;
      }
      
      public function IsHiddenGigCareer() : Boolean
      {
         if(this.career_panel_type == CareerStaticData.PANEL_TYPE_ODD_JOBS_CAREER || this.career_panel_type == CareerStaticData.PANEL_TYPE_MISSIONS_CAREER || this.career_panel_type == CareerStaticData.PANEL_TYPE_QUEST_CAREER)
         {
            return this.gig_info == null || !this.gig_info.gig_type;
         }
         return false;
      }
      
      public function GetWorkDays(param1:int = 0) : Array
      {
         var _loc6_:ScheduleEntryStaticData = null;
         var _loc7_:int = 0;
         if(this.work_schedule)
         {
            return this.work_schedule.GetWorkDays(param1);
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = int(this.currentCareerLevel.work_schedule.length);
         var _loc4_:int = 7;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this.currentCareerLevel.work_schedule[_loc5_];
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               if(_loc6_.days.IsDayAvailable(_loc7_) && _loc2_.indexOf(_loc7_) == -1)
               {
                  _loc2_.push(_loc7_);
               }
               _loc7_++;
            }
            _loc5_++;
         }
         _loc2_.sort();
         return _loc2_;
      }
      
      public function GetNextWorkTimes() : Object
      {
         var _loc1_:TimeSpan = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:CareerInfo = null;
         var _loc12_:Object = null;
         var _loc13_:TimeSpan = null;
         var _loc14_:GigInfo = null;
         var _loc15_:String = null;
         var _loc16_:GameClockTime = null;
         var _loc17_:GameClockTime = null;
         var _loc18_:Object = null;
         _loc1_ = Time.GetGameTime();
         var _loc2_:uint = _loc1_.DayOfWeek % 7;
         if(this.HasUniversityClasses())
         {
            _loc10_ = null;
            for each(_loc11_ in this.uni_classes)
            {
               _loc12_ = _loc11_.GetNextWorkTimes();
               if(_loc12_)
               {
                  if(!_loc10_)
                  {
                     _loc10_ = _loc12_;
                  }
                  else
                  {
                     _loc13_ = _loc10_.startTime.Clone();
                     if(_loc13_.Subtract(_loc12_.startTime))
                     {
                        _loc10_ = _loc12_;
                     }
                  }
               }
            }
            return _loc10_;
         }
         if(this.IsAgentRequired())
         {
            if(!this.sim_id)
            {
               return null;
            }
            _loc14_ = this.gig_info;
            if(!_loc14_ || !_loc14_.gig_type)
            {
               _loc18_ = CommunicationManager.CallGameService("GetAuditionInfo",{"simId":this.sim_id});
               if(_loc18_)
               {
                  _loc14_ = new GigInfo(_loc18_.audition_info);
               }
            }
            if(!_loc14_)
            {
               return null;
            }
            _loc15_ = _loc14_.audition_time ? _loc14_.audition_time : _loc14_.gig_time;
            if(!_loc15_)
            {
               return null;
            }
            _loc16_ = GameClockTime.TicksToDateTime(_loc15_);
            _loc17_ = GameClockTime.GetFullGameClockTime();
            if(_loc16_.week < _loc17_.week)
            {
               _loc16_.week += GameClockTime.NUM_DAYS_PER_MONTH / GameClockTime.NUM_DAYS_PER_WEEK;
            }
            _loc16_.week -= _loc17_.week;
            _loc16_.month = 0;
            _loc16_.year = 0;
            return {
               "startTime":_loc16_.ToTimeSpan(),
               "endTime":null
            };
         }
         var _loc3_:Object = null;
         if(this.work_schedule)
         {
            _loc3_ = this.work_schedule.GetNextDayInSchedule(_loc2_,this.schedule_shift_type,this.skip_next_shift);
         }
         if(Boolean(_loc3_) && (_loc3_.days == 0 || _loc3_.days == 1 && this.skip_next_shift))
         {
            _loc4_ = int(_loc3_.schedule.hour);
            _loc5_ = int(_loc3_.schedule.minute);
            if(_loc1_.Hours > _loc4_ || _loc1_.Hours == _loc4_ && _loc1_.Minutes >= _loc5_)
            {
               _loc3_ = this.work_schedule.GetNextDayInSchedule((_loc2_ + 1) % 7,this.schedule_shift_type,this.skip_next_shift);
               _loc3_.days += 1;
            }
         }
         if(!_loc3_)
         {
            return null;
         }
         _loc4_ = int(_loc3_.schedule.hour);
         _loc5_ = int(_loc3_.schedule.minute);
         var _loc6_:TimeSpan = new TimeSpan(0,0,_loc5_,_loc4_,_loc1_.Days + _loc3_.days,_loc1_.Months,_loc1_.Years);
         _loc7_ = _loc3_.schedule.duration % 1;
         _loc8_ = _loc7_ * 60;
         var _loc9_:TimeSpan = new TimeSpan(0,0,_loc5_ + _loc8_,_loc4_ + uint(_loc3_.schedule.duration),_loc1_.Days + _loc3_.days,_loc1_.Months,_loc1_.Years);
         return {
            "startTime":_loc6_,
            "endTime":_loc9_
         };
      }
      
      public function HasTrackInInfo(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(param1 == this.career_track)
         {
            return true;
         }
         for each(_loc2_ in this.mTrackStaticData.branch_ids)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         if(this.mStaticData.start_track_id == param1)
         {
            return true;
         }
         return false;
      }
      
      public function IsAgentRequired() : Boolean
      {
         return !this.virtual_career && this.currentCareerLevel && Boolean(this.currentCareerLevel.agents_available) && this.currentCareerLevel.agents_available.length > 0;
      }
      
      public function IsTwentyFourSeven() : Boolean
      {
         if(!this.work_schedule || this.GetWorkDays(ScheduleEntry.SCHEDULESHIFT_TWENTY_FOUR_HOURS).length != 7 || this.work_schedule.schedule_entries.length != 1)
         {
            return false;
         }
         var _loc1_:int = int(this.work_schedule.schedule_entries[0].duration);
         return _loc1_ == 24;
      }
      
      public function HasUniversityClasses() : Boolean
      {
         return this.uni_classes.length > 0;
      }
      
      public function HasReputationData() : Boolean
      {
         return this.mStaticData.reputation != null;
      }
   }
}

