package gamedata.Gameplay.HorseCompetition
{
   import olympus.core.OlympusObject;
   
   public class HorseCompetitionSelector extends OlympusObject
   {
      
      public var selected_sim:HorseCompetitionAssigneeData = new HorseCompetitionAssigneeData();
      
      public var selected_horse:HorseCompetitionAssigneeData = new HorseCompetitionAssigneeData();
      
      public var competition_metadatas:Array = [HorseCompetitionMetadata];
      
      public function HorseCompetitionSelector(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.competition_metadatas);
      }
      
      public function TryGetCompetitionById(param1:Number) : HorseCompetitionMetadata
      {
         var _loc2_:HorseCompetitionMetadata = null;
         for each(_loc2_ in this.competition_metadatas)
         {
            if(param1 == _loc2_.competition_id)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

