package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   
   public class RewardList extends OlympusObject
   {
      
      public var instance_ids:Array = [String];
      
      public var reward_ids:Array = [String];
      
      public var sim_ids:Array = [String];
      
      public function RewardList(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.instance_ids);
         FixupArray(this.reward_ids);
         FixupArray(this.sim_ids);
      }
   }
}

