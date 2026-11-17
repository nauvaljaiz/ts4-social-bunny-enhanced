package gamedata.Gameplay.Dynasty
{
   import gamedata.Gameplay.shared.CareerInfo;
   import gamedata.shared.ManagerObjectId;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.objects.RelationshipInfo;
   
   public class FilteredMemberData extends OlympusObject
   {
      
      public var member:DynastyMemberData;
      
      public var simCareers:Array = [CareerInfo];
      
      public var simRelationshipInfo:RelationshipInfo;
      
      public function FilteredMemberData(param1:Object = null)
      {
         super(param1);
         if(param1)
         {
            this.member = param1.member;
            this.simCareers = CommunicationManager.CallGameService("GetSimCareerInfo",this.member.member_id) as Array;
            this.simRelationshipInfo = new RelationshipInfo(CommunicationManager.CallGameService("GetSimRelationshipInfo",{
               "targetId":this.member.member_id,
               "targetManagerId":ManagerObjectId.MGR_SIM_INFO
            }));
         }
      }
   }
}

