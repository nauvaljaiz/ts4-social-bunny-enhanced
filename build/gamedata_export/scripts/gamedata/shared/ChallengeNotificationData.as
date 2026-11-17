package gamedata.shared
{
   import gamedata.TutorialTip.TutorialMode;
   import olympus.core.OlympusObject;
   import olympus.core.UISettings;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class ChallengeNotificationData extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var subtitle:LocKey = new LocKey();
      
      public var challengeName:String;
      
      public var challenges:Array = [ChallengeData];
      
      public function ChallengeNotificationData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function RefreshIgnoreChallengeSetting(param1:String) : void
      {
         var _loc2_:String = UISettings.AccountSettings.GetValue("challenges.ignore") as String;
         if(Boolean(_loc2_) && _loc2_ != param1)
         {
            UISettings.AccountSettings.SetValue("challenges.ignore","");
         }
      }
      
      public static function GetCurrentChallenge() : ChallengeNotificationData
      {
         var _loc1_:Object = CommunicationManager.CallGameService("GetEngagementChallengeData");
         return _loc1_ ? new ChallengeNotificationData(_loc1_) : null;
      }
      
      public static function TryShowChallengeDisplay(param1:ChallengeNotificationData = null) : void
      {
         if(TutorialMode.IsFTUE())
         {
            return;
         }
         if(CommunicationManager.CallGameService("GetAllActiveSituations",null,true))
         {
            return;
         }
         if(!param1)
         {
            param1 = GetCurrentChallenge();
            if(!param1)
            {
               return;
            }
         }
         if(param1.ShouldShowEventDisplay())
         {
            CommunicationManager.SendUIMessage("ShowChallengeEventDisplay",param1);
         }
      }
      
      public static function HideChallengeDisplay() : void
      {
         CommunicationManager.SendUIMessage("HideChallengeEventDisplay");
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.challenges);
      }
      
      public function SetIgnored(param1:Boolean) : void
      {
         if(!this.challengeName)
         {
            return;
         }
         UISettings.AccountSettings.SetValue("challenges.ignore",param1 ? this.challengeName : "");
         if(this.challenges.length > 0)
         {
            if(param1)
            {
               CommunicationManager.SendUIMessage("HideChallengeEventDisplay");
            }
            else
            {
               TryShowChallengeDisplay(this);
            }
         }
      }
      
      public function IsIgnored() : Boolean
      {
         if(this.challengeName)
         {
            return UISettings.AccountSettings.GetValue("challenges.ignore") == this.challengeName;
         }
         return false;
      }
      
      public function SetDisplayCollapsed(param1:Boolean) : void
      {
         if(!this.challengeName)
         {
            return;
         }
         UISettings.AccountSettings.SetValue("challenges.display_collapsed." + this.challengeName,param1);
      }
      
      public function ShouldDisplayCollapsed() : Boolean
      {
         if(this.challengeName)
         {
            return Boolean(UISettings.AccountSettings.GetValue("challenges.display_collapsed." + this.challengeName));
         }
         return false;
      }
      
      public function HasEventDisplay() : Boolean
      {
         return this.challenges.length > 0 && Boolean(this.challenges[0].eventDisplay) && Boolean(this.challenges[0].eventDisplay.eventTitle.IsValid());
      }
      
      public function ShouldShowEventDisplay() : Boolean
      {
         return !this.IsIgnored() && this.HasEventDisplay();
      }
   }
}

