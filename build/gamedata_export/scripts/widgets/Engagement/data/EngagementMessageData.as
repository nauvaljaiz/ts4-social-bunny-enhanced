package widgets.Engagement.data
{
   import olympus.localization.Keys;
   import widgets.Engagement.constants.EngagementMessageTypes;
   import widgets.shared.data.UMMainMenuTemplateData;
   
   public class EngagementMessageData extends UMMainMenuTemplateData
   {
      
      public var preventAutoOpen:String;
      
      public function EngagementMessageData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(type == EngagementMessageTypes.TYPE_DLC_TRIAL_NAME)
         {
            badgeStyle = "2";
            timerPrefix = Keys.DLCTRIALS_TIMER_ENDS_IN.toString();
         }
      }
      
      public function PreventAutoOpen() : Boolean
      {
         return this.preventAutoOpen != null && this.preventAutoOpen.toLowerCase() == "true";
      }
   }
}

