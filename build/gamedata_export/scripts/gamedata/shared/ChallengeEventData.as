package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ChallengeEventData extends OlympusObject
   {
      
      public var eventTitle:LocKey = new LocKey();
      
      public var eventIcon:String;
      
      public var endTime:Date = new Date(0);
      
      public var activityIcon:String;
      
      public var activityGoalAmount:Number = 0;
      
      public var activityProgressAmount:Number = 0;
      
      public var activityProgressIcon:String;
      
      public var activityProgressText:LocKey = new LocKey();
      
      public var activityCompleteIcon:String;
      
      public var activityCompleteText:LocKey = new LocKey();
      
      public var communityProgressAmount:Number = 0;
      
      public var communityGoalAmount:Number = 0;
      
      public var communityProgressIcon:String;
      
      public var communityProgressText:LocKey = new LocKey();
      
      public var communityCompleteIcon:String;
      
      public var communityCompleteText:LocKey = new LocKey();
      
      public function ChallengeEventData(param1:Object = null)
      {
         super(param1);
      }
      
      public function HasActivityGoal() : Boolean
      {
         return this.activityGoalAmount > 0;
      }
      
      public function HasCompletedGoal() : Boolean
      {
         return this.activityProgressAmount >= this.activityGoalAmount;
      }
      
      public function HasCommunityGoal() : Boolean
      {
         return this.communityGoalAmount != 0;
      }
      
      public function HasCommunityCompletedGoal() : Boolean
      {
         return this.communityProgressAmount >= this.communityGoalAmount;
      }
      
      public function GetTooltipText() : String
      {
         var _loc1_:LocKey = this.activityProgressText;
         if(this.HasCompletedGoal() && this.activityCompleteText.IsValid())
         {
            _loc1_ = this.activityCompleteText;
         }
         var _loc2_:Object = this.GetTimeRemaining();
         return _loc1_.toString(this.activityProgressAmount,this.activityGoalAmount,_loc2_.hours,_loc2_.days);
      }
      
      public function GetTooltipIcon() : String
      {
         if(Boolean(this.HasCompletedGoal()) && Boolean(this.activityCompleteIcon) && this.activityCompleteIcon != "0")
         {
            return this.activityCompleteIcon;
         }
         return this.activityProgressIcon;
      }
      
      public function GetCommunityTooltipText() : String
      {
         var _loc1_:LocKey = this.communityProgressText;
         if(this.HasCommunityCompletedGoal() && this.communityCompleteText.IsValid())
         {
            _loc1_ = this.communityCompleteText;
         }
         return _loc1_.toString(this.communityProgressAmount,this.communityGoalAmount);
      }
      
      public function GetCommunityTooltipIcon() : String
      {
         if(Boolean(this.HasCommunityCompletedGoal()) && Boolean(this.communityCompleteIcon) && this.communityCompleteIcon != "0")
         {
            return this.communityCompleteIcon;
         }
         return this.communityProgressIcon;
      }
      
      public function GetTimeRemaining() : Object
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = this.endTime.getTime() - _loc1_.getTime();
         var _loc3_:Number = Math.max(1,Math.ceil(_loc2_ / (1000 * 60 * 60)));
         var _loc4_:Number = Math.floor(_loc3_ / 24);
         _loc3_ -= _loc4_ * 24;
         return {
            "hours":_loc3_,
            "days":_loc4_
         };
      }
   }
}

