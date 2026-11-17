package gamedata.Gameplay.Business
{
   import gamedata.Gameplay.EmployeeManagement.ManageEmployeeRowData;
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BusinessSummaryDialog extends OlympusObject
   {
      
      public var business_data:BusinessData = new BusinessData();
      
      public var lines_entries:Array = [BusinessSummaryEntry];
      
      public var employees:Array = [ManageEmployeeRowData];
      
      public var is_global_overview:Boolean = false;
      
      public var hide_review_stars:Boolean = false;
      
      public var show_sim_bubble:Boolean = false;
      
      public var show_staff_report:Boolean = true;
      
      public var default_highlight_finances_help:Boolean = false;
      
      public var show_custom_stats_container:Boolean = false;
      
      public var stats_custom_background:String;
      
      public var stats_custom_tooltip:LocKey = new LocKey();
      
      public var timeOpened:GameClockTime = new GameClockTime();
      
      public function BusinessSummaryDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lines_entries);
         FixupArray(this.employees);
         if(!("timeOpened" in param1))
         {
            this.timeOpened = null;
         }
      }
   }
}

