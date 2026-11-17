package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MoodTraitOverridePair extends OlympusObject
   {
      
      public var trait:String;
      
      public var descriptions:Array = [LocKey];
      
      public function MoodTraitOverridePair(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.descriptions);
      }
   }
}

