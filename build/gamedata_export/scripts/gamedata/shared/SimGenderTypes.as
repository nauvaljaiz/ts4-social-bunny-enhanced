package gamedata.shared
{
   import gamedata.Gameplay.shared.definitions.AgeVariantData;
   import gamedata.Gameplay.shared.definitions.GenderStringsStaticData;
   import gamedata.Gameplay.shared.definitions.SpeciesStringsData;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   
   public final class SimGenderTypes
   {
      
      public static const MALE:int = 4096 << 0;
      
      public static const FEMALE:int = 4096 << 1;
      
      public static const UNIVERSAL:int = MALE | FEMALE;
      
      public static const ALL_GENDERS:Array = [MALE,FEMALE];
      
      protected static const FRAME_LABEL_FEMALE:String = "female";
      
      protected static const FRAME_LABEL_MALE:String = "male";
      
      public static const MALE_IMAGE:String = "0xae93c6bea12333ea";
      
      public static const FEMALE_IMAGE:String = "0xadc9c02cf9ac156b";
      
      public function SimGenderTypes()
      {
         super();
      }
      
      public static function IsFemale(param1:int) : Boolean
      {
         return param1 == FEMALE;
      }
      
      public static function IsMale(param1:int) : Boolean
      {
         return param1 == MALE;
      }
      
      public static function IsValidGender(param1:int) : Boolean
      {
         return param1 == FEMALE || param1 == MALE;
      }
      
      public static function GetIconFrameLabel(param1:int) : String
      {
         return IsFemale(param1) ? FRAME_LABEL_FEMALE : FRAME_LABEL_MALE;
      }
      
      public static function GetImage(param1:int) : String
      {
         return IsFemale(param1) ? FEMALE_IMAGE : MALE_IMAGE;
      }
      
      public static function GetGenderStringKey(param1:int, param2:uint, param3:uint = 0, param4:Boolean = false) : LocKey
      {
         var _loc8_:AgeVariantData = null;
         var _loc5_:Object = GenderStringsStaticData.GetStaticData();
         if(param2 == Species.TYPE_NONE)
         {
            param2 = Species.TYPE_HUMAN;
         }
         var _loc6_:SpeciesStringsData = _loc5_.TryGetGenderStringKeysBySpecies(Species.ExtendedSpeciesToSpecies(param2));
         var _loc7_:Array = _loc6_ ? _loc6_.age_variants : null;
         if(_loc6_)
         {
            if(param1 == FEMALE)
            {
               if(param4)
               {
                  return Keys.CUSTOM_FEMALE;
               }
               if(Boolean(_loc7_) && _loc7_.length > 0)
               {
                  _loc8_ = _loc6_.TryGetGenderAgeVariantStringsByAge(param3);
                  if(_loc8_)
                  {
                     return _loc8_.female_string;
                  }
               }
               return _loc6_.female_string;
            }
            if(param1 == MALE)
            {
               if(param4)
               {
                  return Keys.CUSTOM_MALE;
               }
               if(Boolean(_loc7_) && _loc7_.length > 0)
               {
                  _loc8_ = _loc6_.TryGetGenderAgeVariantStringsByAge(param3);
                  if(_loc8_)
                  {
                     return _loc8_.male_string;
                  }
               }
               return _loc6_.male_string;
            }
            if(param1 == UNIVERSAL)
            {
               return Keys.GENERIC_GENDER_UNIVERSAL;
            }
         }
         return null;
      }
   }
}

