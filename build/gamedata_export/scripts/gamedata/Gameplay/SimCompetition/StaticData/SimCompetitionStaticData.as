package gamedata.Gameplay.SimCompetition.StaticData
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class SimCompetitionStaticData extends OlympusObject
   {
      
      protected static var sSimCompetitionModuleData:SimCompetitionStaticData;
      
      public var categories:Array = [SimCompetitionCategoryData];
      
      public function SimCompetitionStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : SimCompetitionStaticData
      {
         if(!sSimCompetitionModuleData)
         {
            sSimCompetitionModuleData = new SimCompetitionStaticData(CommunicationManager.CallGameService("GetSimCompetitionsData"));
         }
         return sSimCompetitionModuleData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.categories);
      }
      
      public function TryGetCompetitionById(param1:int) : SimCompetitionData
      {
         var _loc2_:SimCompetitionCategoryData = null;
         var _loc3_:SimCompetitionData = null;
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
      
      public function TryGetCategoryByCompetitionId(param1:int) : SimCompetitionCategoryData
      {
         var _loc2_:SimCompetitionCategoryData = null;
         var _loc3_:SimCompetitionData = null;
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

