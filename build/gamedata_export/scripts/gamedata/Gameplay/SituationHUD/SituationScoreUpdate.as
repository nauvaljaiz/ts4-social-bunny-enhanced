package gamedata.Gameplay.SituationHUD
{
   import gamedata.Gameplay.SituationDisplay.SituationLevelUpdate;
   import olympus.core.OlympusObject;
   
   public class SituationScoreUpdate extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var score:uint;
      
      public var sim_id:String;
      
      public var current_level:SituationLevelUpdate = new SituationLevelUpdate();
      
      public function SituationScoreUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !param1.current_level)
         {
            this.current_level = null;
         }
      }
   }
}

