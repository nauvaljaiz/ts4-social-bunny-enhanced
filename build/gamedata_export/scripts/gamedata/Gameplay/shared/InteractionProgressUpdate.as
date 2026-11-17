package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class InteractionProgressUpdate extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var percent:Number = 0;
      
      public var rate_change:Number = 0;
      
      public var interaction_id:String;
      
      public var elapsedSeconds:int;
      
      public function InteractionProgressUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.elapsedSeconds = Math.max(this.elapsedSeconds,0);
      }
   }
}

