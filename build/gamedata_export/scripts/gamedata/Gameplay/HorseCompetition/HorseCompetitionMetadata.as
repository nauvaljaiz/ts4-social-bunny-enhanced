package gamedata.Gameplay.HorseCompetition
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HorseCompetitionMetadata extends OlympusObject
   {
      
      public var competition_id:Number;
      
      public var eligible_to_compete:Boolean;
      
      public var not_eligible_reason:LocKey = new LocKey();
      
      public var has_placed_previously:Boolean;
      
      public var highest_placement:Number;
      
      public function HorseCompetitionMetadata(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupLocKey(this.not_eligible_reason);
      }
   }
}

