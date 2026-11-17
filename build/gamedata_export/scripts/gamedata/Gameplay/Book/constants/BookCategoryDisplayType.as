package gamedata.Gameplay.Book.constants
{
   public class BookCategoryDisplayType
   {
      
      public static const DEFAULT:int = 0;
      
      public static const WITCH_PRACTICAL_SPELL:int = 1;
      
      public static const WITCH_MISCHIEF_SPELL:int = 2;
      
      public static const WITCH_UNTAMED_SPELL:int = 3;
      
      public static const WITCH_POTION:int = 4;
      
      public function BookCategoryDisplayType()
      {
         super();
      }
      
      public static function GetLabelForDisplayType(param1:int) : String
      {
         switch(param1)
         {
            case WITCH_PRACTICAL_SPELL:
               return "witch_practical";
            case WITCH_MISCHIEF_SPELL:
               return "witch_mischief";
            case WITCH_UNTAMED_SPELL:
               return "witch_untamed";
            case WITCH_POTION:
               return "witch_potion";
            case DEFAULT:
         }
         return "default";
      }
   }
}

