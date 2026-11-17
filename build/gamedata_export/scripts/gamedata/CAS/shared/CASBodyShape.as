package gamedata.CAS.shared
{
   public final class CASBodyShape
   {
      
      public static const TOPLEFT:int = 0;
      
      public static const TOPRIGHT:int = 1;
      
      public static const BOTTOMLEFT:int = 2;
      
      public static const BOTTOMRIGHT:int = 3;
      
      public static const MAX:int = 4;
      
      public static const NONE:int = MAX;
      
      public static const MALE_TRIANGLE:int = TOPLEFT;
      
      public static const MALE_TRAPEZOIDAL:int = TOPRIGHT;
      
      public static const MALE_RECTANGLE:int = BOTTOMLEFT;
      
      public static const MALE_INVERTEDTRIANGLE:int = BOTTOMRIGHT;
      
      public static const FEMALE_INVERTEDTRIANGLE:int = TOPLEFT;
      
      public static const FEMALE_RECTANGLE:int = TOPRIGHT;
      
      public static const FEMALE_TRIANGLEPEAR:int = BOTTOMLEFT;
      
      public static const FEMALE_HOURGLASS:int = BOTTOMRIGHT;
      
      public function CASBodyShape()
      {
         super();
      }
   }
}

