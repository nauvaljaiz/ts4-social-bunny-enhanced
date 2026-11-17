package gamedata.CAS.constants
{
   public final class RandomizeFlag
   {
      
      public static const NONE:int = 0;
      
      public static const PROFILE_GENDER:int = 1 << 0;
      
      public static const PROFILE_BODYSHAPE:int = 1 << 1;
      
      public static const PROFILE_BODYSIZE:int = 1 << 2;
      
      public static const PROFILE_FACE:int = 1 << 3;
      
      public static const PROFILE_SKINTONE:int = 1 << 4;
      
      public static const PROFILE_HAIR:int = 1 << 5;
      
      public static const PROFILE_FACIALHAIR:int = 1 << 6;
      
      public static const PROFILE_VOICE:int = 1 << 7;
      
      public static const PROFILE_CLOTHING:int = 1 << 8;
      
      public static const PROFILE_ASPIRATION:int = 1 << 9;
      
      public static const PROFILE_TATTOOS:int = 1 << 10;
      
      public static const PROFILE_TRAITS:int = 1 << 11;
      
      public static const PROFILE_SKINDETAIL:int = 1 << 12;
      
      public static const PROFILE_BREEDSIZE:int = 1 << 13;
      
      public static const PROFILE_PREFERENCES:int = 1 << 24;
      
      public static const PROFILE_ALL:int = PROFILE_BODYSHAPE | PROFILE_FACE | PROFILE_SKINTONE | PROFILE_HAIR | PROFILE_FACIALHAIR | PROFILE_VOICE | PROFILE_CLOTHING | PROFILE_BREEDSIZE;
      
      public static const PROFILE_VAMPIRE_ALTERNATE:int = PROFILE_FACE | PROFILE_SKINTONE | PROFILE_HAIR | PROFILE_FACIALHAIR | PROFILE_VOICE | PROFILE_CLOTHING;
      
      public static const CLOTHING_HAT:int = 1 << 15;
      
      public static const CLOTHING_TOP:int = 1 << 16;
      
      public static const CLOTHING_BOTTOM:int = 1 << 17;
      
      public static const CLOTHING_SHOES:int = 1 << 18;
      
      public static const CLOTHING_MAKEUP:int = 1 << 19;
      
      public static const CLOTHING_HAIR:int = 1 << 20;
      
      public static const CLOTHING_FACIAL_HAIR:int = 1 << 21;
      
      public static const HORSE_HAIR:* = 1 << 25;
      
      public static const HORSE_HOOVES:* = 1 << 26;
      
      public static const WINGS:int = 1 << 27;
      
      public static const CLOTHING_ALL:int = CLOTHING_HAT | CLOTHING_TOP | CLOTHING_BOTTOM | CLOTHING_SHOES | CLOTHING_MAKEUP | CLOTHING_HAIR | CLOTHING_FACIAL_HAIR;
      
      public static const CLOTHING_OUTFITS_ONLY:int = CLOTHING_HAT | CLOTHING_TOP | CLOTHING_BOTTOM | CLOTHING_SHOES;
      
      public static const BODYSHAPE_AND_CLOTHING_ONLY:int = PROFILE_BODYSHAPE | CLOTHING_OUTFITS_ONLY;
      
      public static const ALL_BUT_BODY_AND_VOICE:int = PROFILE_FACE | PROFILE_SKINTONE | PROFILE_HAIR | PROFILE_FACIALHAIR | PROFILE_CLOTHING;
      
      public static const RANDOMIZE_BY_MENUSTATE:int = 1 << 31;
      
      public function RandomizeFlag()
      {
         super();
      }
   }
}

