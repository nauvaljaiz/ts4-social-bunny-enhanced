package gamedata.Gameplay.HorseCompetition.StaticData
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HorseCompetitionCategoryData extends OlympusObject
   {
      
      public var group_id:Number;
      
      public var name:LocKey = new LocKey();
      
      public var competitions:Array = [HorseCompetitionData];
      
      public function HorseCompetitionCategoryData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.competitions);
      }
   }
}

