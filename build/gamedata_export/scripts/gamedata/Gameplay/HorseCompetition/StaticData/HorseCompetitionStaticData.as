package gamedata.Gameplay.HorseCompetition.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class HorseCompetitionStaticData extends OlympusObject
   {
      
      protected static var sHorseCompetitionModuleData:HorseCompetitionStaticData;
      
      public var categories:Array = [HorseCompetitionCategoryData];
      
      public var hero_image:ResourceKey = new ResourceKey();
      
      public function HorseCompetitionStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : HorseCompetitionStaticData
      {
         if(!sHorseCompetitionModuleData)
         {
            sHorseCompetitionModuleData = new HorseCompetitionStaticData(CommunicationManager.CallGameService("GetHorseCompetitionsData"));
         }
         return sHorseCompetitionModuleData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.categories);
      }
      
      public function TryGetCompetitionById(param1:int) : HorseCompetitionData
      {
         var _loc2_:HorseCompetitionCategoryData = null;
         var _loc3_:HorseCompetitionData = null;
         for each(_loc2_ in this.categories)
         {
            for each(_loc3_ in _loc2_.competitions)
            {
               if(_loc3_.competition_id == param1)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function TryGetCategoryByCompetitionId(param1:int) : HorseCompetitionCategoryData
      {
         var _loc2_:HorseCompetitionCategoryData = null;
         var _loc3_:HorseCompetitionData = null;
         for each(_loc2_ in this.categories)
         {
            for each(_loc3_ in _loc2_.competitions)
            {
               if(_loc3_.competition_id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
   }
}

