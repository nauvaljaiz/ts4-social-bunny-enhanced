package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class TraitApperanceOverrideCriterionData extends OlympusObject
   {
      
      public var age:Array = [String];
      
      public var occult_type:Array = [String];
      
      public var traits:Array = [String];
      
      public function TraitApperanceOverrideCriterionData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.age);
         FixupArray(this.occult_type);
         FixupArray(this.traits);
      }
   }
}

