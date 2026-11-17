package gamedata.Gameplay.SituationDisplay
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationJobAssignment extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var name:LocKey;
      
      public var desc:LocKey;
      
      public var tooltip:LocKey;
      
      public function SituationJobAssignment(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         this.name = new LocKey(param1.name);
         this.desc = new LocKey(param1.desc);
         this.tooltip = new LocKey(param1.tooltip);
      }
   }
}

