package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SpeciesStringsData extends OlympusObject
   {
      
      public var age_variants:Array = [AgeVariantsMapData];
      
      public var female_string:LocKey = new LocKey();
      
      public var male_string:LocKey = new LocKey();
      
      public function SpeciesStringsData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.age_variants);
      }
      
      public function TryGetGenderAgeVariantStringsByAge(param1:int) : AgeVariantData
      {
         var _loc2_:AgeVariantsMapData = null;
         for each(_loc2_ in this.age_variants)
         {
            if(_loc2_.age == param1)
            {
               return _loc2_.age_variant_strings;
            }
         }
         return null;
      }
   }
}

