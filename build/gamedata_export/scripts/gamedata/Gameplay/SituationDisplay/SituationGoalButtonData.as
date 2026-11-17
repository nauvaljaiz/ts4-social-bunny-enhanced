package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationGoalButtonData extends OlympusObject
   {
      
      public var button_text:LocKey = new LocKey();
      
      public var is_enabled:Boolean;
      
      public var required_packs:Array = [int];
      
      public function SituationGoalButtonData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.required_packs);
      }
   }
}

