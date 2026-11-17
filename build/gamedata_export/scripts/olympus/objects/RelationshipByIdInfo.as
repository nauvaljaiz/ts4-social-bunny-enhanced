package olympus.objects
{
   import gamedata.shared.ManagerObjectId;
   import olympus.core.OlympusObject;
   
   public class RelationshipByIdInfo extends OlympusObject
   {
      
      public var managerObjectId:ManagerObjectId = new ManagerObjectId();
      
      public var relInfo:RelationshipInfo = new RelationshipInfo();
      
      public function RelationshipByIdInfo(param1:Object = null)
      {
         super(param1);
      }
   }
}

