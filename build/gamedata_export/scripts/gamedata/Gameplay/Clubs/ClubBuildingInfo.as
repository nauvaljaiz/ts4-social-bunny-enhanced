package gamedata.Gameplay.Clubs
{
   import gamedata.Gameplay.shared.LotInfoItem;
   import olympus.core.OlympusObject;
   
   public class ClubBuildingInfo extends OlympusObject
   {
      
      public var criterias:Array = [ClubCriteria];
      
      public var available_lots:Array = [LotInfoItem];
      
      public function ClubBuildingInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.criterias);
         FixupArray(this.available_lots);
      }
   }
}

