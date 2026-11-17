package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class UnitRatingCategoryStaticData extends OlympusObject
   {
      
      public static const CATEGORY_TYPE_SIZE:int = 0;
      
      public static const CATEGORY_TYPE_AMENITY:int = 1;
      
      public static const CATEGORY_TYPE_ENVIRONMENT:int = 2;
      
      public static const CATEGORY_TYPE_MAINTENANCE:int = 3;
      
      protected static var sUnitRatingCategoryDataList:Array = null;
      
      public var categoryType:int;
      
      public var name:LocKey = new LocKey();
      
      public var subScores:Array = [UnitRatingCategorySubScore];
      
      public var tooltip:LocKey = new LocKey();
      
      public function UnitRatingCategoryStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetUnitRatingCategoryDataList() : Array
      {
         if(sUnitRatingCategoryDataList == null)
         {
            sUnitRatingCategoryDataList = CommunicationManager.CallGameService("GetUnitRatingCategoryData") as Array;
            if(sUnitRatingCategoryDataList)
            {
               ConstructArrayInPlace(sUnitRatingCategoryDataList,UnitRatingCategoryStaticData);
            }
         }
         return sUnitRatingCategoryDataList;
      }
      
      public static function GetStaticData(param1:int) : UnitRatingCategoryStaticData
      {
         var _loc2_:UnitRatingCategoryStaticData = null;
         if(sUnitRatingCategoryDataList == null)
         {
            sUnitRatingCategoryDataList = GetUnitRatingCategoryDataList();
         }
         if(sUnitRatingCategoryDataList != null)
         {
            for each(_loc2_ in sUnitRatingCategoryDataList)
            {
               if(_loc2_.categoryType == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         FixupArray(this.subScores);
         this.tooltip = FixupLocKey(this.tooltip);
      }
      
      public function GetUnitRatingSubScoreData(param1:int) : UnitRatingCategorySubScore
      {
         var _loc2_:UnitRatingCategorySubScore = null;
         for each(_loc2_ in this.subScores)
         {
            if(_loc2_.ratingScore == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

