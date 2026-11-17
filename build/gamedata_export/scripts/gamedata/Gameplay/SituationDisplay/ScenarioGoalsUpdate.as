package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   
   public class ScenarioGoalsUpdate extends OlympusObject
   {
      
      public var scenario_id:String;
      
      public var instance_id:String;
      
      public var goal_groups:Array = [ScenarioGoalGroup];
      
      public var completed_goal_id:uint = SituationGoal.INVALID_GOAL_ID;
      
      public function ScenarioGoalsUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.goal_groups);
      }
   }
}

