package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   
   public class GameplayPerkList extends OlympusObject
   {
      
      public var bucks_type:uint;
      
      public var perk_list:Array = [GameplayPerk];
      
      public function GameplayPerkList(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.perk_list);
      }
   }
}

