package widgets.shared.constants
{
   public class PackStaticSharedData
   {
      
      public static var PACK_TYPE_EP:int = 0;
      
      public static var PACK_TYPE_GP:int = 1;
      
      public static var PACK_TYPE_SP:int = 2;
      
      public static var PACK_TYPE_KIT:int = 3;
      
      public static var PACK_TYPE_UGC:int = 4;
      
      public static var PACK_TYPE_FP:int = 5;
      
      public static var PACK_TYPE_SDX:int = 6;
      
      public static var CATEGORY_PACKS:int = 0;
      
      public static var CATEGORY_THEME:int = 1;
      
      public static var CATEGORY_MAKER_BUNDLE:int = 2;
      
      public static var CATEGORY_FRAME:int = 3;
      
      public static var CATEGORY_MODES:int = 4;
      
      public static var CATEGORY_PRICE:int = 5;
      
      public static var FILTER_ID_UGC:int = 5;
      
      public function PackStaticSharedData()
      {
         super();
      }
      
      public static function ConvertCategoryIdToLabel(param1:int) : String
      {
         switch(param1)
         {
            case CATEGORY_PACKS:
               return "packs";
            case CATEGORY_THEME:
               return "theme";
            case CATEGORY_MAKER_BUNDLE:
               return "makerBundle";
            case CATEGORY_FRAME:
               return "frame";
            case CATEGORY_MODES:
               return "modes";
            case CATEGORY_PRICE:
               return "price";
            default:
               return "invalid";
         }
      }
   }
}

