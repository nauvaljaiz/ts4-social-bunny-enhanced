package gamedata.Gameplay.University
{
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UniversityHousingLotData extends OlympusObject
   {
      
      public var zoneId:String;
      
      public var houseDescriptionId:String;
      
      public var enabled:Boolean = true;
      
      public var name:String;
      
      public var subText:String;
      
      public var description:String;
      
      public var imageTitle:String;
      
      public var tooltip:LocKey;
      
      public var cost:int = 0;
      
      public var nhdLotData:NeighborhoodLotData;
      
      public var otherSimsCount:uint = 0;
      
      public function UniversityHousingLotData(param1:Object = null)
      {
         super(param1);
      }
   }
}

