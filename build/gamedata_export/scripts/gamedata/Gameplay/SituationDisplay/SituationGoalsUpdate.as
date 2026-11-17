package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationGoalsUpdate extends OlympusObject
   {
      
      private static const GOALSTATUS_COMPLETE:int = 0;
      
      private static const GOALSTATUS_CANCELED:int = 1;
      
      public var situation_id:String;
      
      public var sim_id:String;
      
      public var goals:Array = [SituationGoal];
      
      public var completed_goal_id:uint;
      
      public var major_goal:SituationGoal = new SituationGoal();
      
      public var goal_status:int;
      
      public var goal_sub_text:LocKey = new LocKey();
      
      public var goal_button_data:SituationGoalButtonData = new SituationGoalButtonData();
      
      public function SituationGoalsUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.goals);
         if(!this.goal_sub_text.IsValid())
         {
            this.goal_sub_text = null;
         }
         if(!("goal_button_data" in param1))
         {
            this.goal_button_data = null;
         }
      }
      
      public function IsCanceled() : Boolean
      {
         return this.goal_status == GOALSTATUS_CANCELED;
      }
   }
}

