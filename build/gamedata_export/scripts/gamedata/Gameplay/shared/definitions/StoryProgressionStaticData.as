package gamedata.Gameplay.shared.definitions
{
   import gamedata.Gameplay.shared.StoryProgression;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class StoryProgressionStaticData extends OlympusObject
   {
      
      protected static var sStoryProgressionStaticData:StoryProgressionStaticData = null;
      
      protected var storyProgressionRules:Array;
      
      protected var storyProgressionDomainEnablementStates:Array;
      
      public function StoryProgressionStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStoryProgressionRuleStaticData() : Array
      {
         return GetStaticData().storyProgressionRules;
      }
      
      public static function IsDomainEnabledByDefault(param1:uint) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:StoryProgressionDomainEnablementData = null;
         if(param1 == StoryProgression.STORY_PROGRESSION_UI_DOMAIN_HOUSEHOLD)
         {
            return true;
         }
         if(param1 == StoryProgression.STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS || param1 == StoryProgression.STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS)
         {
            _loc2_ = GetStaticData().storyProgressionDomainEnablementStates;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_] as StoryProgressionDomainEnablementData;
               if(_loc4_ != null && _loc4_.domain == param1)
               {
                  return _loc4_.enabled;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      protected static function GetStaticData() : StoryProgressionStaticData
      {
         if(!sStoryProgressionStaticData)
         {
            sStoryProgressionStaticData = new StoryProgressionStaticData(CommunicationManager.CallGameService("GetStoryProgressionData"));
         }
         return sStoryProgressionStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.storyProgressionRules = new Array();
         ConstructArrayFromArray(this.storyProgressionRules,param1.storyProgressionRules,StoryProgressionRuleData);
         this.storyProgressionDomainEnablementStates = new Array();
         ConstructArrayFromArray(this.storyProgressionDomainEnablementStates,param1.storyProgressionDomainEnablementStates,StoryProgressionDomainEnablementData);
      }
   }
}

