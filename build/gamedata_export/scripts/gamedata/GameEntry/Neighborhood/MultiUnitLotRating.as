package gamedata.GameEntry.Neighborhood
{
   import gamedata.Gameplay.shared.definitions.UnitRatingCategoryStaticData;
   import olympus.core.OlympusObject;
   
   public class MultiUnitLotRating extends OlympusObject
   {
      
      public static const RATING_ALERT_STATE_CLEAR:int = 0;
      
      public static const RATING_ALERT_STATE_INCREASE:int = 1;
      
      public static const RATING_ALERT_STATE_DECREASE:int = 2;
      
      public var amenityScore:uint = 0;
      
      public var environmentScore:uint = 0;
      
      public var sizeScore:uint = 0;
      
      public var maintenanceScore:uint = 0;
      
      public var stars:uint = 0;
      
      public function MultiUnitLotRating(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetUnitRatingCategorySubScore(param1:int) : int
      {
         switch(param1)
         {
            case UnitRatingCategoryStaticData.CATEGORY_TYPE_AMENITY:
               return int(this.amenityScore);
            case UnitRatingCategoryStaticData.CATEGORY_TYPE_ENVIRONMENT:
               return int(this.environmentScore);
            case UnitRatingCategoryStaticData.CATEGORY_TYPE_MAINTENANCE:
               return int(this.maintenanceScore);
            case UnitRatingCategoryStaticData.CATEGORY_TYPE_SIZE:
               return int(this.sizeScore);
            default:
               return -1;
         }
      }
      
      public function GetUIStarRating() : int
      {
         return int(this.stars) + 1;
      }
   }
}

