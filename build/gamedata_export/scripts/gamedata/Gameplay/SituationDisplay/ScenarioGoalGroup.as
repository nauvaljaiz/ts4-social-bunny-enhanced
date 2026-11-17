package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class ScenarioGoalGroup extends OlympusObject
   {
      
      public var header_icon:IconInfo = new IconInfo();
      
      public var header_name:LocKey = new LocKey();
      
      public var goals:Array = [SituationGoal];
      
      public function ScenarioGoalGroup(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.goals);
      }
   }
}

