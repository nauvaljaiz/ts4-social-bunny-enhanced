package gamedata.Gameplay.SituationCreation
{
   import gamedata.Gameplay.Pickers.SimPickerCustomFilter;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationJobSims extends OlympusObject
   {
      
      public var situation_session_id:uint;
      
      public var job_resource_id:String;
      
      public var lock_selection:Boolean;
      
      public var sims:Array = [SituationJobSim];
      
      public var requirements:LocKey = new LocKey();
      
      public var custom_filters:Array = [SimPickerCustomFilter];
      
      public function SituationJobSims(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sims);
         FixupArray(this.custom_filters);
      }
   }
}

