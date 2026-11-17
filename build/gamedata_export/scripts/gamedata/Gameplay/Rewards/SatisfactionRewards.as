package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   
   public class SatisfactionRewards extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var rewards:Array = [SatisfactionReward];
      
      public function SatisfactionRewards(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.rewards);
      }
   }
}

