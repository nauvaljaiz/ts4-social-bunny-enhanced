package gamedata.Gameplay.Calendar
{
   import gamedata.GameEntry.shared.RegionDescription;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.objects.IconInfo;
   
   public final class CalendarEntry extends OlympusObject
   {
      
      public static const TYPE_NONE:uint = 0;
      
      public static const TYPE_EVENT:uint = 1;
      
      public static const TYPE_POPUP_HOLIDAY:uint = 2;
      
      public static const TYPE_HOLIDAY:uint = 3;
      
      public static const TYPE_VACATION:uint = 5;
      
      public static const TYPE_FESTIVAL:uint = 6;
      
      public static const TYPE_WEDDING:uint = 7;
      
      public static const TYPE_WORK_EVENT:uint = 8;
      
      public static const TYPE_STAYOVER:uint = 9;
      
      public static const TYPE_FUNERAL:uint = 10;
      
      public static const TYPE_GETAWAY:uint = 11;
      
      public var entry_type:uint;
      
      public var entry_id:String;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var start_time:String;
      
      public var end_time:String;
      
      public var scoring_enabled:Boolean;
      
      public var zone_id:String;
      
      public var household_sim_ids:Array;
      
      public var tradition_ids:Array;
      
      public var holiday_id:String;
      
      public var deletable:Boolean;
      
      public var festival_activities:Array = [FestivalActivityData];
      
      public var favorited:Boolean;
      
      public var entry_guid:String;
      
      public var show_go_to_event_button:Boolean;
      
      public var in_progress:Boolean;
      
      public var getaway_name:String;
      
      public var getaway_duration:uint;
      
      public var getaway_recurring_days:Array = [int];
      
      public var daysUntilStart:int;
      
      public var daysUntilEnd:int;
      
      public var regionData:RegionDescription;
      
      public var isNew:Boolean;
      
      public function CalendarEntry(param1:Object = null)
      {
         super(param1);
      }
      
      public static function SortEntries(param1:Object, param2:Object) : int
      {
         if(param1.mData.entry_type == param2.mData.entry_type)
         {
            return 0;
         }
         if(GetEntrySortOrder(param1.mData.entry_type) < GetEntrySortOrder(param2.mData.entry_type))
         {
            return -1;
         }
         return 1;
      }
      
      protected static function GetEntrySortOrder(param1:uint) : uint
      {
         switch(param1)
         {
            case TYPE_WEDDING:
               return 0;
            case TYPE_POPUP_HOLIDAY:
            case TYPE_HOLIDAY:
               return 1;
            case TYPE_STAYOVER:
               return 2;
            case TYPE_EVENT:
               return 3;
            case TYPE_FESTIVAL:
               return 4;
            default:
               return 5;
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:Object = null;
         super.ParseObject(param1);
         FixupArray(this.festival_activities);
         FixupArray(this.getaway_recurring_days);
         if("zone_id" in param1)
         {
            _loc2_ = CommunicationManager.CallGameService("GetNeighborhoodLotData",this.zone_id);
            if(_loc2_)
            {
               this.regionData = RegionDescription.GetRegionDescription(_loc2_.regionId);
            }
         }
      }
      
      public function get MultiDay() : Boolean
      {
         return this.entry_type == TYPE_VACATION || this.entry_type == TYPE_STAYOVER || this.entry_type == TYPE_GETAWAY;
      }
   }
}

