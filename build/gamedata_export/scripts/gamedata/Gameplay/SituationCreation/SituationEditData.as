package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class SituationEditData extends OlympusObject
   {
      
      public var drama_node_id:String;
      
      public var zone_id:String;
      
      public var selected_activity_ids:Array = [String];
      
      public var guest_attire_style:String;
      
      public var guest_attire_color:String;
      
      public var job_data:Array = [SituationEditJobData];
      
      public var special_object_icon_info:IconInfo;
      
      public var getaway_schedule:Object;
      
      public var duration_nights:uint;
      
      public var recurring_days:Array = [uint];
      
      public var end_time:String;
      
      public var has_valid_zone_schedule:Boolean;
      
      public var apply_appearance_modifier:Boolean;
      
      public var fromSituationEdit:Boolean;
      
      public var fromCasEdit:Boolean;
      
      public var selectedSituationId:String;
      
      public var fromCalendar:Boolean = true;
      
      public var mPanelToRestore:String;
      
      public var currentTime:GameClockTime;
      
      public function SituationEditData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.selected_activity_ids);
         FixupArray(this.job_data);
         FixupArray(this.recurring_days);
         if("special_object_icon_info" in param1)
         {
            this.special_object_icon_info = new IconInfo(param1.special_object_icon_info);
         }
      }
      
      public function get DramaNodeId() : String
      {
         return this.drama_node_id;
      }
   }
}

