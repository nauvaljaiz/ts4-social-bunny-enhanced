package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class VetClinicBusinessData extends OlympusObject
   {
      
      public var zone_id:String;
      
      public var advertising_chosen:uint;
      
      public var is_quality_unlocked:Boolean;
      
      public var quality_chosen:uint;
      
      public function VetClinicBusinessData(param1:Object = null)
      {
         super(param1);
      }
   }
}

