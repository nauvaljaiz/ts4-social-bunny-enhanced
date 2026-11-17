package widgets.LiveEvent.data
{
   import olympus.localization.KeysGE;
   import olympus.localization.LocKey;
   import olympus.objects.UMBaseData;
   import olympus.utils.DateUtils;
   import widgets.Engagement.constants.EngagementMessageTypes;
   import widgets.Engagement.data.EngagementMessageIconData;
   import widgets.shared.constants.LiveEventSharedTunables;
   import widgets.shared.data.UMMainMenuTemplateData;
   
   public class LiveEventData extends UMBaseData
   {
      
      public var eventId:String;
      
      public var eventType:int;
      
      public var eventState:int;
      
      public var name:String;
      
      public var description:String;
      
      public var periods:Array = [LiveEventPeriodData];
      
      public var periodLengthType:int;
      
      public var eventStyle:String;
      
      public var startDate:Date = DateUtils.DateDST();
      
      public var endDate:Date = DateUtils.DateDST();
      
      public var currentDate:Date = DateUtils.DateDST();
      
      public var nextDayDate:Date = DateUtils.DateDST();
      
      public var notificationDialogData:UMMainMenuTemplateData;
      
      public var numClaimedRewards:int;
      
      public var numTotalRewards:int;
      
      public var sessionCount:int;
      
      public var questData:LiveEventQuestData = new LiveEventQuestData();
      
      public function LiveEventData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAllActivePeriods(param1:Array) : Array
      {
         var eventPeriods:Array = param1;
         return eventPeriods.filter(function(param1:LiveEventPeriodData):Boolean
         {
            return param1.bIsActive;
         });
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = param1["notificationDialogData"];
         if(_loc2_)
         {
            _loc3_ = _loc2_["type"];
            switch(_loc3_)
            {
               case EngagementMessageTypes.TYPE_MESSAGE_WITH_ICONS:
                  this.notificationDialogData = new EngagementMessageIconData();
                  break;
               case EngagementMessageTypes.TYPE_NAME:
                  this.notificationDialogData = new UMMainMenuTemplateData();
            }
         }
         super.ParseObject(param1);
         FixupArray(this.periods);
         if(this.notificationDialogData)
         {
            this.SetBagdeText();
         }
      }
      
      public function get StyleLabel() : String
      {
         if(this.eventStyle == null || this.eventStyle == "")
         {
            return LiveEventSharedTunables.LIVE_EVENT_DEFAULT_LABEL;
         }
         return this.eventStyle;
      }
      
      public function GetAllRewardsByState(param1:int) : Array
      {
         var _loc3_:LiveEventPeriodData = null;
         var _loc4_:Array = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.periods)
         {
            _loc4_ = _loc3_.GetRewardsByState(param1);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         return _loc2_;
      }
      
      public function GetAllActivePeriodIndices() : Array
      {
         var _loc3_:LiveEventPeriodData = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.periods.length)
         {
            _loc3_ = this.periods[_loc2_];
            if(_loc3_.bIsActive)
            {
               _loc1_.push({
                  "index":_loc2_,
                  "periodId":_loc3_.periodId
               });
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function GetUIAccountSettingsValue() : String
      {
         var _loc2_:Array = null;
         var _loc1_:int = LiveEventSharedTunables.LIVE_EVENT_STATE_AFTER_LAST_PERIOD;
         if(this.eventState != LiveEventSharedTunables.LIVE_EVENT_STATE_AFTER_LAST_PERIOD)
         {
            _loc2_ = this.GetAllActivePeriodIndices();
            if(_loc2_.length != 0)
            {
               _loc1_ = int(_loc2_[0].index);
            }
         }
         return this.eventId + "_period_" + String(_loc1_);
      }
      
      public function GetBaseTelemetryAttributes() : Object
      {
         var _loc1_:Array = this.GetAllActivePeriodIndices();
         var _loc2_:Array = this.GetAllRewardsByState(LiveEventSharedTunables.REWARD_STATE_AVAILABLE);
         return {
            "evnt":this.eventId,
            "perd":(_loc1_.length > 0 ? _loc1_[0].periodId : this.eventState),
            "step":this.GetTelemetryStepValue(),
            "mesg":(messageId ? messageId : 0),
            "eday":int((this.currentDate.getTime() - this.startDate.getTime()) / 86400000) + 1,
            "uclm":_loc2_.length
         };
      }
      
      protected function SetBagdeText() : void
      {
         var _loc1_:LocKey = null;
         if(this.notificationDialogData.badgeTextKey)
         {
            _loc1_ = new LocKey({"hash":this.notificationDialogData.badgeTextKey});
            if(Boolean(_loc1_) && _loc1_.IsValid())
            {
               this.notificationDialogData.badgeText = _loc1_.toString({"date":DateUtils.DateToLocalizationToken(this.endDate)});
            }
         }
         else if(!this.notificationDialogData.badgeText)
         {
            this.notificationDialogData.badgeText = KeysGE.LIVE_EVENT_NOTIFICATION_DEFAULT_BADGE_TEXT.toString({"date":DateUtils.DateToLocalizationToken(this.endDate)});
         }
      }
      
      protected function GetTelemetryStepValue() : int
      {
         switch(this.eventType)
         {
            case LiveEventSharedTunables.LIVE_EVENT_TYPE_LOGIN:
               return this.sessionCount;
            case LiveEventSharedTunables.LIVE_EVENT_TYPE_QUEST:
               return this.questData.XP;
            default:
               return 0;
         }
      }
   }
}

