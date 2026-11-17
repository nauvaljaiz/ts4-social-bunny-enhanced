package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class AgeVariantsMapData extends OlympusObject
   {
      
      public var age:int;
      
      public var age_variant_strings:AgeVariantData;
      
      public function AgeVariantsMapData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1["age"])
         {
            this.age = param1["age"];
         }
         if(param1["age_variant_strings"])
         {
            this.age_variant_strings = new AgeVariantData(param1["age_variant_strings"]);
         }
      }
   }
}

