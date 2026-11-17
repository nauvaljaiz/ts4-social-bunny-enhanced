package gamedata.Gameplay.HorseCompetition.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HorseCompetitionData extends OlympusObject
   {
      
      public var competition_id:Number;
      
      public var title:LocKey = new LocKey();
      
      public var show_title:Boolean;
      
      public var description:LocKey = new LocKey();
      
      public var entry_fee:Number;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var cropped_hero_image:ResourceKey = new ResourceKey();
      
      public var hero_image:ResourceKey = new ResourceKey();
      
      public var placements:Array = [HorseCompetitionPlacementData];
      
      public var sim_skill_requirements:Array = [HorseCompetitionSkillRequirementData];
      
      public var horse_skill_requirements:Array = [HorseCompetitionSkillRequirementData];
      
      public function HorseCompetitionData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.placements);
         FixupArray(this.sim_skill_requirements);
         FixupArray(this.horse_skill_requirements);
         FixupLocKey(this.title);
         FixupLocKey(this.description);
      }
   }
}

