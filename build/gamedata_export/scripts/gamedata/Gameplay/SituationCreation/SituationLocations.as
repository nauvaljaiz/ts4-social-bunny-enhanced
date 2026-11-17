package gamedata.Gameplay.SituationCreation
{
   import gamedata.Gameplay.shared.LotInfoItem;
   import olympus.core.OlympusObject;
   
   public class SituationLocations extends OlympusObject
   {
      
      public var situation_locations:Array = [LotInfoItem];
      
      public function SituationLocations(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.situation_locations);
      }
   }
}

