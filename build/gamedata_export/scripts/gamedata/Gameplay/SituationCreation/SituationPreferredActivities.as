package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationPreferredActivities extends OlympusObject
   {
      
      public var activities:Array = [String];
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var footer:LocKey = new LocKey();
      
      public function SituationPreferredActivities(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if("footer" in param1)
         {
            this.footer = new LocKey(param1.footer);
         }
         FixupArray(this.activities);
      }
   }
}

