package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   
   public class SituationDataBatch extends OlympusObject
   {
      
      public var situation_session_id:uint;
      
      public var situations:Array = [SituationData];
      
      public function SituationDataBatch(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.situations);
      }
   }
}

