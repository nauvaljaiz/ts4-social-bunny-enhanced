package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BuckRewardsCategory extends OlympusObject
   {
      
      public var category_sort:int;
      
      public var category_name:LocKey = new LocKey();
      
      public var category_tooltip:LocKey = new LocKey();
      
      public var category_rewards:Array = [BuckRewardsReward];
      
      public var career_level_required:int;
      
      public function BuckRewardsCategory(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.category_rewards);
         this.category_rewards.sortOn("reward_sort",Array.NUMERIC);
      }
   }
}

