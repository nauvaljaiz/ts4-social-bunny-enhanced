package gamedata.Gameplay.SimCompetition
{
   import olympus.core.OlympusObject;
   
   public class SimCompetitionSelector extends OlympusObject
   {
      
      public var selected_sim:SimCompetitionAssigneeData = new SimCompetitionAssigneeData();
      
      public var selected_object:SimCompetitionObjectData = new SimCompetitionObjectData();
      
      public var competition_metadatas:Array = [SimCompetitionMetadata];
      
      public var category:uint;
      
      public function SimCompetitionSelector(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.competition_metadatas);
      }
      
      public function TryGetCompetitionById(param1:Number) : SimCompetitionMetadata
      {
         var _loc2_:SimCompetitionMetadata = null;
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

