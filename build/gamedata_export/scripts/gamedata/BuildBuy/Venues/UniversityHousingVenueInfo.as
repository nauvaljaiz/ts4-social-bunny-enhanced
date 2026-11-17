package gamedata.BuildBuy.Venues
{
   import gamedata.Gameplay.Organizations.OrganizationData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class UniversityHousingVenueInfo extends OlympusObject
   {
      
      public var universityId:String;
      
      public var universityGender:uint;
      
      public var universityOrganizationId:String;
      
      public var universityClubId:String;
      
      public var universityClubName:String;
      
      public var universityRoommateBedCount:uint;
      
      public function UniversityHousingVenueInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function ConstructForCurrentZone() : UniversityHousingVenueInfo
      {
         return new UniversityHousingVenueInfo(CommunicationManager.CallGameService("BBGetUniversityHousingProperties"));
      }
      
      public function GetAffiliationName() : String
      {
         var _loc1_:OrganizationData = null;
         if(this.universityClubName)
         {
            return this.universityClubName;
         }
         if(this.universityOrganizationId)
         {
            _loc1_ = OrganizationData.GetStaticData(this.universityOrganizationId);
            if(_loc1_)
            {
               return _loc1_.name.toString();
            }
         }
         return null;
      }
   }
}

