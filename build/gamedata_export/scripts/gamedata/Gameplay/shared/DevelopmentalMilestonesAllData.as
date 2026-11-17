package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class DevelopmentalMilestonesAllData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var milestones:Array = [DevelopmentalMilestoneData];
      
      public function DevelopmentalMilestonesAllData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.milestones);
      }
   }
}

