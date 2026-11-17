package olympus.objects
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import widgets.shared.utils.FamilyTree.FamilyTreeUtils;
   
   public class RelationshipBitInfo extends OlympusObject
   {
      
      public static const GROUP_ID_INVALID:uint = 0;
      
      public static const GROUP_ID_NO_GROUP:uint = 1;
      
      public static const GROUP_ID_ROMANTIC:uint = 2;
      
      public static const GROUP_ID_UPSET_WITH:uint = 3;
      
      public static const GROUP_ID_FAMILY:uint = 4;
      
      public static const GROUP_ID_SIGNIFICANT_OTHER:uint = 5;
      
      public static const GROUP_ID_WRITING_JOURNALISM_INTERVIEW:uint = 6;
      
      public static const GROUP_ID_ACQUIRED_FAMILY:uint = 7;
      
      public static const GROUP_ID_PET_RELATIONSHIP:uint = 8;
      
      public static const GROUP_ID_SENTIMENT:uint = 9;
      
      public static const GROUP_ID_RELATIONSHIP_LABEL:uint = 10;
      
      protected static const ADOPTED_BY_REL_BIT_ID:String = "310896";
      
      protected static const ADOPTED_REL_BIT_ID:String = "310897";
      
      public var bitId:String;
      
      public var iconId:ResourceKey = new ResourceKey();
      
      public var simProfileBackground:ResourceKey = new ResourceKey();
      
      public var smallIconId:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var end_time:String;
      
      public var visible:Boolean;
      
      public var groupId:uint;
      
      protected var bTimeoutEnabled:Boolean;
      
      public function RelationshipBitInfo(param1:Object = null)
      {
         super(param1);
         this.bTimeoutEnabled = this.end_time != null;
      }
      
      public static function GetById(param1:String) : RelationshipBitInfo
      {
         var _loc2_:Object = CommunicationManager.CallGameService("GetRelationshipBitDataById",param1);
         return new RelationshipBitInfo(_loc2_);
      }
      
      public static function GetRelbitName(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:RelationshipBitInfo = GetById(param1);
         if(Boolean(CommunicationManager.CallGameService("DoesSimExist",param2)) && Boolean(CommunicationManager.CallGameService("DoesSimExist",param3)))
         {
            return _loc4_.name.toString({"simId":param2},{"simId":param3});
         }
         return FamilyTreeUtils.GetGenderlessNameForRelbit(_loc4_).toString();
      }
      
      public function get Adopted() : Boolean
      {
         return this.bitId == ADOPTED_BY_REL_BIT_ID || this.bitId == ADOPTED_REL_BIT_ID;
      }
      
      public function IsBitExpired() : Boolean
      {
         return this.bTimeoutEnabled && this.GetRemainingTicks() <= 0;
      }
      
      protected function GetRemainingTicks() : int
      {
         var _loc1_:int = 0;
         if(this.bTimeoutEnabled)
         {
            return int(CommunicationManager.CallGameService("ComputeRemainingTime",{"targetTime":this.end_time}));
         }
         return 0;
      }
   }
}

