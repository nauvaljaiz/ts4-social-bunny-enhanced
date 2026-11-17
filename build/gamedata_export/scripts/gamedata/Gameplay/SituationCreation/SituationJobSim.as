package gamedata.Gameplay.SituationCreation
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationJobSim extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var account_id:String;
      
      public var career_track_id:String;
      
      public var cell_disabled_tooltip:LocKey = new LocKey();
      
      public var cell_disabled:Boolean = false;
      
      public var tag_list:Array = [uint];
      
      public function SituationJobSim(param1:Object = null)
      {
         super(param1);
         FixupArray(this.tag_list);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.tag_list);
      }
   }
}

