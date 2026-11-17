package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class GenderStringsMapData extends OlympusObject
   {
      
      public var species:int;
      
      public var species_strings:SpeciesStringsData;
      
      public function GenderStringsMapData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1["species"])
         {
            this.species = param1["species"];
         }
         if(param1["species_strings"])
         {
            this.species_strings = new SpeciesStringsData(param1["species_strings"]);
         }
      }
   }
}

