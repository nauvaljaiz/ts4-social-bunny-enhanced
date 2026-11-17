package gamedata.Gameplay.SocialMedia
{
   import olympus.core.OlympusObject;
   
   public class SocialMediaPostReaction extends OlympusObject
   {
      
      public var narrative_type:int;
      
      public var polarity_type:int;
      
      public var count:int;
      
      public var reacted_sims:Array = [String];
      
      public function SocialMediaPostReaction(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.reacted_sims);
      }
   }
}

