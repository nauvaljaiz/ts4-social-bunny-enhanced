package gamedata.Gameplay.SimCompetition.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimCompetitionCategoryData extends OlympusObject
   {
      
      public var group_id:Number;
      
      public var name:LocKey = new LocKey();
      
      public var competitions:Array = [SimCompetitionData];
      
      public var tournament_category:Number;
      
      public var no_competition_selected_hero_image:ResourceKey = new ResourceKey();
      
      public var no_competition_selected_title:LocKey = new LocKey();
      
      public var no_competition_selected_description:LocKey = new LocKey();
      
      public function SimCompetitionCategoryData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.competitions);
         FixupLocKey(this.no_competition_selected_title);
         FixupLocKey(this.no_competition_selected_description);
      }
   }
}

