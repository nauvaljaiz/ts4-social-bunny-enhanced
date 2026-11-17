package gamedata.Gameplay.SituationDisplay
{
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   
   public class SituationTimeUpdate extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var end_time:GameClockTime = new GameClockTime();
      
      public var has_stayed_late:Boolean;
      
      public var current_time:GameClockTime = new GameClockTime();
      
      public function SituationTimeUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("end_time" in param1))
         {
            this.end_time = null;
         }
         if(!param1 || !("current_time" in param1))
         {
            this.current_time = null;
         }
      }
   }
}

