package gamedata.Gameplay.HorseCompetition
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HorseCompetitionAssigneeData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var mood_id:String;
      
      public var mood_intensity:Number;
      
      public var mood_tooltip:LocKey = new LocKey();
      
      public var skills:Array = [HorseCompetitionAssigneeSkillData];
      
      public function HorseCompetitionAssigneeData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.skills);
         FixupLocKey(this.mood_tooltip);
      }
   }
}

