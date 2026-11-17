package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationLevelReward extends OlympusObject
   {
      
      public var level:uint;
      
      public var display_name:Array = [LocKey];
      
      public function SituationLevelReward(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.display_name);
      }
   }
}

