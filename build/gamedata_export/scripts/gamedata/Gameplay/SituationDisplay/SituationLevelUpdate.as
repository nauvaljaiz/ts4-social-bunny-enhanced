package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class SituationLevelUpdate extends OlympusObject
   {
      
      public var score_lower_bound:uint;
      
      public var score_upper_bound:uint;
      
      public var current_level:uint;
      
      public var level_icon:IconInfo = new IconInfo();
      
      public function SituationLevelUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("level_icon" in param1) || !param1.level_icon)
         {
            this.level_icon = null;
         }
      }
   }
}

