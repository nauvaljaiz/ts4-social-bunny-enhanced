package gamedata.shared
{
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public final class Species
   {
      
      public static const TYPE_NONE:uint = 0;
      
      public static const TYPE_HUMAN:uint = 1;
      
      public static const TYPE_DOG:uint = 2;
      
      public static const TYPE_CAT:uint = 3;
      
      public static const TYPE_SMALLDOG:uint = 4;
      
      public static const TYPE_FOX:uint = 5;
      
      public static const TYPE_HORSE:uint = 6;
      
      public static const ICON_PET_MOLECULE_BG:String = "0x936437a8a5b43306";
      
      public function Species()
      {
         super();
      }
      
      public static function IsPet(param1:uint) : Boolean
      {
         if(param1 == TYPE_DOG || param1 == TYPE_CAT || param1 == TYPE_SMALLDOG || param1 == TYPE_HORSE)
         {
            return true;
         }
         return false;
      }
      
      public static function IsDog(param1:uint) : Boolean
      {
         return param1 == TYPE_DOG || param1 == TYPE_SMALLDOG;
      }
      
      public static function IsCat(param1:uint) : Boolean
      {
         return param1 == TYPE_CAT;
      }
      
      public static function IsHorse(param1:uint) : Boolean
      {
         return param1 == TYPE_HORSE;
      }
      
      public static function IsSmallPet(param1:uint) : Boolean
      {
         return param1 == TYPE_CAT || param1 == TYPE_SMALLDOG;
      }
      
      public static function IsFox(param1:uint) : Boolean
      {
         return param1 == TYPE_FOX;
      }
      
      public static function IsHuman(param1:uint) : Boolean
      {
         return param1 <= TYPE_HUMAN;
      }
      
      public static function ExtendedSpeciesToSpecies(param1:uint) : uint
      {
         switch(param1)
         {
            case TYPE_SMALLDOG:
               return TYPE_DOG;
            default:
               return param1;
         }
      }
      
      public static function GetSpeciesSortPriority(param1:uint) : int
      {
         switch(param1)
         {
            case TYPE_HUMAN:
               return 1;
            case TYPE_DOG:
               return 2;
            case TYPE_SMALLDOG:
               return 3;
            case TYPE_CAT:
               return 4;
            case TYPE_HORSE:
               return 0;
            default:
               return 5;
         }
      }
      
      public static function GetSpeciesLocKey(param1:uint) : LocKey
      {
         switch(param1)
         {
            case TYPE_CAT:
               return KeysGP.SPECIES_CAT;
            case TYPE_DOG:
            case TYPE_SMALLDOG:
               return KeysGP.SPECIES_DOG;
            default:
               return null;
         }
      }
   }
}

