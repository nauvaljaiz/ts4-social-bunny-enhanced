package gamedata.shared
{
   import flash.utils.getDefinitionByName;
   import gamedata.GameEntry.shared.HouseholdData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.utils.DateUtils;
   
   public class ScenarioStaticData extends OlympusObject
   {
      
      protected static var sStaticData:Vector.<ScenarioStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      public static const COMPATIBLE_NEW_HOUSEHOLD:uint = 1 << 0;
      
      public static const COMPATIBLE_EXISTING_HOUSEHOLD:uint = 1 << 1;
      
      public static const ONBOARDING:uint = 1 << 0;
      
      protected static var sScenarioMap:Object = new Object();
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var tagline_text:LocKey = new LocKey();
      
      public var category:uint;
      
      public var difficulty:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var reward_icon:ResourceKey = new ResourceKey();
      
      public var reward_text:LocKey = new LocKey();
      
      public var has_bonus_reward:Boolean = false;
      
      public var tags:Array = [uint];
      
      public var goals:Array = [LocKey];
      
      public var requirements:Array = [LocKey];
      
      public var roles:Array = [String];
      
      public var endDate:Date = DateUtils.DateDST();
      
      public var compatibility_flags:uint;
      
      public var property_flags:uint;
      
      public var premade_households:Array = [HouseholdData];
      
      public var ui_sort_order:int;
      
      public function ScenarioStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetActiveScenariosStaticData() : Vector.<ScenarioStaticData>
      {
         var activeScenarios:Array = null;
         var scenarioDataList:Array = null;
         var len:int = 0;
         var i:int = 0;
         if(!sStaticData)
         {
            activeScenarios = CommunicationManager.CallGameService("GetActiveScenarioIds") as Array;
            scenarioDataList = sGetStaticDataFunc(activeScenarios.map(function(param1:Object):String
            {
               return param1["id"];
            }));
            sStaticData = new Vector.<ScenarioStaticData>(scenarioDataList.length,true);
            len = int(scenarioDataList.length);
            i = 0;
            while(i < len)
            {
               sStaticData[i] = new ScenarioStaticData(scenarioDataList[i]);
               if("endDate" in activeScenarios[i])
               {
                  DateUtils.DateTimeObjectToDate(activeScenarios[i]["endDate"],sStaticData[i].endDate);
               }
               if(!(sStaticData[i].id in sScenarioMap))
               {
                  sScenarioMap[sStaticData[i].id] = sStaticData[i];
               }
               i++;
            }
            sStaticData.sort(SortScenarios);
         }
         return sStaticData;
      }
      
      public static function GetStaticData(param1:String) : ScenarioStaticData
      {
         var _loc2_:ScenarioStaticData = sScenarioMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(Boolean(_loc3_) && Boolean(_loc3_[0]))
         {
            _loc2_ = new ScenarioStaticData(_loc3_[0]);
            _loc2_.AddEndDateData();
            sScenarioMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      protected static function SortScenarios(param1:ScenarioStaticData, param2:ScenarioStaticData) : Number
      {
         if(param1.endDate.valueOf() != 0 && param2.endDate.valueOf() == 0)
         {
            return -1;
         }
         if(param1.endDate.valueOf() == 0 && param2.endDate.valueOf() != 0)
         {
            return 1;
         }
         if(param1.ui_sort_order == param2.ui_sort_order)
         {
            return 0;
         }
         return param1.ui_sort_order < param2.ui_sort_order ? -1 : 1;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1)
         {
            super.ParseObject(param1);
            FixupArray(this.tags);
            FixupArray(this.goals);
            FixupArray(this.requirements);
            FixupArray(this.roles);
            FixupArray(this.premade_households);
         }
      }
      
      public function get AllowsNewHouseholds() : Boolean
      {
         return (this.compatibility_flags & COMPATIBLE_NEW_HOUSEHOLD) != 0;
      }
      
      public function get AllowsExistingHouseholds() : Boolean
      {
         return (this.compatibility_flags & COMPATIBLE_EXISTING_HOUSEHOLD) != 0;
      }
      
      public function get IsOnboarding() : Boolean
      {
         return (this.property_flags & ONBOARDING) != 0;
      }
      
      public function get HasPremadeHouseholds() : Boolean
      {
         return this.premade_households.length > 0;
      }
      
      public function GetFirstPremadeHouseholdName() : String
      {
         if(this.premade_households.length > 0)
         {
            return this.premade_households[0].familyName;
         }
         return null;
      }
      
      protected function AddEndDateData() : void
      {
         var _loc1_:Object = CommunicationManager.CallGameService("GetScenarioEndDate",this.id);
         if(_loc1_)
         {
            DateUtils.DateTimeObjectToDate(_loc1_,this.endDate);
         }
      }
   }
}

