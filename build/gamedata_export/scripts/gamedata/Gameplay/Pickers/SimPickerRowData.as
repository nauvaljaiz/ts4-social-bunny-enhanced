package gamedata.Gameplay.Pickers
{
   import gamedata.Gameplay.Clubs.ClubBuildingInfo;
   import gamedata.Gameplay.shared.AgeUpdate;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.objects.RelationshipInfo;
   
   public class SimPickerRowData extends OlympusObject
   {
      
      public var base_data:PickerBaseRowData = new PickerBaseRowData();
      
      public var sim_id:String;
      
      public var select_default:Boolean;
      
      public var failed_criteria:Array = [uint];
      
      public var skills:Array = [SimPickerSkillRowData];
      
      public var mood_id:String;
      
      public var household_id:String;
      
      public var account_id:String;
      
      public var career_track_id:String;
      
      public var relTracks:Array;
      
      public var nonTrackedBitIcons:Array;
      
      public var ownerId:String;
      
      public var isLocked:Boolean = false;
      
      public var roleData:Object;
      
      public var situationData:Object;
      
      public var sim_location:String;
      
      protected var mAge:uint;
      
      protected var mSimName:String;
      
      protected var mClubBuildingInfo:ClubBuildingInfo;
      
      protected var mRelInfo:RelationshipInfo;
      
      public function SimPickerRowData(param1:Object = null)
      {
         var _loc2_:AgeUpdate = null;
         super(param1);
         if(this.sim_id != null)
         {
            _loc2_ = new AgeUpdate(CommunicationManager.CallGameService("GetSimAge",this.sim_id));
            this.mAge = _loc2_.age;
         }
         FixupArray(this.failed_criteria);
         FixupArray(this.skills);
      }
      
      public function get SimName() : String
      {
         return this.mSimName;
      }
      
      public function set SimName(param1:String) : void
      {
         this.mSimName = param1;
      }
      
      public function get Age() : uint
      {
         return this.mAge;
      }
      
      public function get ClubInfo() : ClubBuildingInfo
      {
         return this.mClubBuildingInfo;
      }
      
      public function set ClubInfo(param1:ClubBuildingInfo) : *
      {
         this.mClubBuildingInfo = param1;
      }
      
      public function get RelInfo() : RelationshipInfo
      {
         return this.mRelInfo;
      }
      
      public function set RelInfo(param1:RelationshipInfo) : *
      {
         this.mRelInfo = param1;
      }
      
      public function get SimLocation() : String
      {
         return this.sim_location;
      }
      
      public function set SimLocation(param1:String) : *
      {
         this.sim_location = param1;
      }
   }
}

