package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MoodAgePair extends OlympusObject
   {
      
      public var Age:String;
      
      public var description_text:Array = [LocKey];
      
      public function MoodAgePair(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.description_text);
      }
   }
}

