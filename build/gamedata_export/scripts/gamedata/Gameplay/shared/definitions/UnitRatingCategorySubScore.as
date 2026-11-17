package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UnitRatingCategorySubScore extends OlympusObject
   {
      
      public static const RATING_SUB_SCORE_LOW:int = 0;
      
      public static const RATING_SUB_SCORE_MEDIUM:int = 1;
      
      public static const RATING_SUB_SCORE_HIGH:int = 2;
      
      public var ratingScore:uint;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public function UnitRatingCategorySubScore(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
      }
   }
}

