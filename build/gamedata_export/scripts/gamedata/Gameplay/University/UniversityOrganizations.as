package gamedata.Gameplay.University
{
   import gamedata.Gameplay.Organizations.OrganizationData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UniversityOrganizations extends OlympusObject
   {
      
      public var univ_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var organizations:Array = [OrganizationData];
      
      public function UniversityOrganizations(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.organizations);
      }
   }
}

