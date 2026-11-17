package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   
   public class SituationMeterUpdate extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var meter_id:uint;
      
      public var update_value:Number;
      
      public function SituationMeterUpdate(param1:Object = null)
      {
         super(param1);
      }
   }
}

