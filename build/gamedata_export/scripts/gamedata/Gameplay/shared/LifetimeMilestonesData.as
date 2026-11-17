package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class LifetimeMilestonesData extends OlympusObject
   {
      
      public var category_id:int;
      
      public var milestones:Array = [DevelopmentalMilestoneData];
      
      public function LifetimeMilestonesData(param1:Object = null)
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

