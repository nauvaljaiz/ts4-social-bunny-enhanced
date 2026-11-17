package widgets.LiveEvent.data
{
   import olympus.objects.UMBaseData;
   import olympus.utils.DateUtils;
   import widgets.shared.constants.LiveEventSharedTunables;
   
   public class LiveEventPeriodData extends UMBaseData
   {
      
      public static const LIVE_EVENT_QUEST_PERIOD_STATE_INVALID:int = -1;
      
      public static const LIVE_EVENT_QUEST_PERIOD_STATE_ACTIVE:int = 0;
      
      public static const LIVE_EVENT_QUEST_PERIOD_STATE_LOCKED:int = 1;
      
      public static const LIVE_EVENT_QUEST_PERIOD_STATE_COMPLETED:int = 2;
      
      public var periodId:String;
      
      public var startDate:Date = DateUtils.DateDST();
      
      public var endDate:Date = DateUtils.DateDST();
      
      public var rewards:Array = [AccountRewardData];
      
      public var bIsActive:Boolean;
      
      public var bIsLocked:Boolean;
      
      public var quests:Array = [LiveEventQuestState];
      
      public var modifierData:Array = [LiveEventQuestModifierData];
      
      public var XPCap:int;
      
      public function LiveEventPeriodData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:LiveEventQuestState = null;
         super.ParseObject(param1);
         FixupArray(this.rewards);
         FixupArray(this.quests);
         FixupArray(this.modifierData);
         for each(_loc2_ in this.quests)
         {
            _loc2_.SetModifierType(this.modifierData);
         }
      }
      
      public function GetRewardsByState(param1:int) : Array
      {
         var _loc3_:AccountRewardData = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.rewards)
         {
            if(_loc3_.state == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function GetQuestsPeriodState() : int
      {
         var _loc2_:LiveEventQuestState = null;
         if(this.quests.length < 1)
         {
            return LIVE_EVENT_QUEST_PERIOD_STATE_INVALID;
         }
         if(this.bIsLocked)
         {
            return LIVE_EVENT_QUEST_PERIOD_STATE_LOCKED;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in this.quests)
         {
            if(_loc2_.questState == LiveEventSharedTunables.LIVE_EVENT_QUEST_STATE_IN_PROGRESS)
            {
               return LIVE_EVENT_QUEST_PERIOD_STATE_ACTIVE;
            }
            if(_loc2_.questState == LiveEventSharedTunables.LIVE_EVENT_QUEST_STATE_COMPLETE)
            {
               _loc1_++;
            }
         }
         if(_loc1_ == this.quests.length)
         {
            return LIVE_EVENT_QUEST_PERIOD_STATE_COMPLETED;
         }
         return LIVE_EVENT_QUEST_PERIOD_STATE_ACTIVE;
      }
   }
}

