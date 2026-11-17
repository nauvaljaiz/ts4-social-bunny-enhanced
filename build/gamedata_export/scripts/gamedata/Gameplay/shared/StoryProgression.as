package gamedata.Gameplay.shared
{
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.Gameplay.shared.definitions.StoryProgressionStaticData;
   import olympus.io.CommunicationManager;
   import olympus.io.TelemetryManager;
   
   public class StoryProgression
   {
      
      public static const STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS:uint = 0;
      
      public static const STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS:uint = 1;
      
      public static const STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD:uint = uint.MAX_VALUE;
      
      public function StoryProgression()
      {
         super();
      }
      
      public static function IsDomainCustomized(param1:uint, param2:HouseholdData = null) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc3_:Object = GetDomainRules(param1,param2,false);
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            if(_loc3_ != null)
            {
               return true;
            }
         }
         else if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            if(_loc3_ != null)
            {
               _loc4_ = StoryProgressionStaticData.IsDomainEnabledByDefault(param1);
               if(GetDomainEnabled(param1,param2) != _loc4_)
               {
                  return true;
               }
               for(_loc5_ in _loc3_)
               {
                  if(!_loc3_[_loc5_])
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function GetDomainEnabled(param1:uint, param2:HouseholdData = null) : Boolean
      {
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            if(param2 == null)
            {
               return false;
            }
            if(IsDomainCustomized(param1,param2))
            {
               return CommunicationManager.CallGameService("GetHouseholdStoryProgressionEnabled",{"householdId":param2.familyId}) as Boolean;
            }
            param1 = param2.GetParentStoryProgressionDomain();
         }
         if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            return CommunicationManager.CallGameService("GetGlobalStoryProgressionDomainEnabled",{"domainType":param1.toString()}) as Boolean;
         }
         return false;
      }
      
      public static function SetDomainEnabled(param1:uint, param2:Boolean, param3:HouseholdData = null) : void
      {
         var _loc4_:Boolean = false;
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            if(param3 == null)
            {
               return;
            }
            if(!IsDomainCustomized(param1,param3))
            {
               CommunicationManager.CallGameService("InitializeStoryProgressionRules",{"householdId":param3.familyId});
            }
            CommunicationManager.CallGameService("SetHouseholdStoryProgressionEnabled",{
               "householdId":param3.familyId,
               "enabled":param2
            });
            _loc4_ = true;
         }
         else if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            CommunicationManager.CallGameService("SetGlobalStoryProgressionDomainEnabled",{
               "domainType":param1.toString(),
               "enabled":param2
            });
            _loc4_ = true;
         }
         if(_loc4_)
         {
            TelemetryManager.DispatchTelemetryEvent("GAME","STRY","OVRA",{
               "levl":GetDomainTelemetryName(param1),
               "hous":(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD ? param3.familyId : "0"),
               "newv":param2
            });
         }
      }
      
      public static function GetDomainRules(param1:uint, param2:HouseholdData = null, param3:Boolean = true) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc4_:Array = null;
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            if(param2 == null)
            {
               return null;
            }
            _loc4_ = CommunicationManager.CallGameService("GetHouseholdStoryProgressionRules",{"householdId":param2.familyId}) as Array;
            if(_loc4_ == null && param3)
            {
               param1 = param2.GetParentStoryProgressionDomain();
            }
         }
         if(_loc4_ == null)
         {
            if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
            {
               _loc4_ = CommunicationManager.CallGameService("GetGlobalStoryProgressionRules",{"domainType":param1.toString()}) as Array;
            }
         }
         if(_loc4_ == null)
         {
            return null;
         }
         _loc5_ = new Object();
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_[_loc4_[_loc6_].rule] = _loc4_[_loc6_].enabled;
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function SetDomainRules(param1:uint, param2:Array, param3:HouseholdData = null) : void
      {
         var _loc5_:int = 0;
         var _loc4_:Boolean = false;
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            if(param3 == null)
            {
               return;
            }
            CommunicationManager.CallGameService("SetHouseholdStoryProgressionRules",{
               "householdId":param3.familyId,
               "ruleList":param2
            });
            _loc4_ = true;
         }
         else if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            CommunicationManager.CallGameService("SetGlobalStoryProgressionRules",{
               "domainType":param1.toString(),
               "ruleList":param2
            });
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               TelemetryManager.DispatchTelemetryEvent("GAME","STRY","OPTS",{
                  "levl":GetDomainTelemetryName(param1),
                  "hous":(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD ? param3.familyId : "0"),
                  "rule":param2[_loc5_].rule,
                  "newv":param2[_loc5_].enabled
               });
               _loc5_++;
            }
         }
      }
      
      public static function ResetStoryProgressionSettings() : void
      {
         var _loc1_:Array = new Array();
         CommunicationManager.CallGameService("SetGlobalStoryProgressionRules",{
            "domainType":STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS.toString(),
            "ruleList":_loc1_
         });
         CommunicationManager.CallGameService("SetGlobalStoryProgressionRules",{
            "domainType":STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS.toString(),
            "ruleList":_loc1_
         });
         CommunicationManager.CallGameService("ClearHouseholdStoryProgressionRules");
         TelemetryManager.DispatchTelemetryEvent("GAME","STRY","RSET");
      }
      
      public static function GetDomainTelemetryName(param1:uint) : String
      {
         if(param1 == STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS)
         {
            return "my_households";
         }
         if(param1 == STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            return "other_households";
         }
         if(param1 == STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            return "individual_households";
         }
         return "";
      }
      
      public static function GetKillswitchEnabled() : Boolean
      {
         return CommunicationManager.CallGameService("GetStoryProgressionDisabled") as Boolean;
      }
   }
}

