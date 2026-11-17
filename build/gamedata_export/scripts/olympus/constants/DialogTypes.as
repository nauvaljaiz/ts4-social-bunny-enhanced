package olympus.constants
{
   public class DialogTypes
   {
      
      public static const CUSTOM:int = 0;
      
      public static const SINGLE_BUTTON:int = 1;
      
      public static const TWO_BUTTON:int = 2;
      
      public static const TWO_BUTTON_INPUT:int = 3;
      
      public static const THREE_BUTTON:int = 4;
      
      public static const ONE_BUTTON_INPUT:int = 5;
      
      public static const YES_NO:int = 6;
      
      public static const YES:int = 7;
      
      public static const ONE_BUTTON_TWO_INPUT:int = 8;
      
      public static const ONE_BUTTON_MULTI_INPUT:int = 9;
      
      public static const STYLE_DEFAULT:int = 0;
      
      public static const STYLE_CHANCE_CARDS:int = 1;
      
      public static const STYLE_CELEBRATION:int = 2;
      
      public static const STYLE_ICON_WITH_BACKGROUND:int = 3;
      
      public static const STYLE_LARGE_ICON:int = 4;
      
      public static const STYLE_TRAIT_REASSIGNMENT:int = 5;
      
      public static const STYLE_LIFESTYLE_BRAND:int = 6;
      
      public static const STYLE_LARGE_ICON_TEXT_HORIZONTAL:int = 7;
      
      public static const STYLE_LIFESTYLE_TRAITS:int = 8;
      
      public static const STYLE_LARGE_ICON_WIDE:int = 9;
      
      public static const STYLE_NPC_DISPLAY:int = 10;
      
      public static const STYLE_GUIDANCE_WARNING:int = 11;
      
      public static const STYLE_ICON_SWAP:int = 12;
      
      public static const STYLE_DYNAMIC_SIGN:int = 13;
      
      public static const JEWELRY_CRAFTING:int = 14;
      
      public static const GEMSTONE_CUTTING:int = 15;
      
      public static const BG_STYLE_DEFAULT:int = 0;
      
      public static const BG_STYLE_CHANCE_CARDS:int = 1;
      
      public static const BG_STYLE_CELEBRATION:int = 2;
      
      public static const BG_STYLE_LIFESTYLE_BRAND:int = 3;
      
      public static const BG_STYLE_CELEBRATION_LARGE:int = 4;
      
      public static const BG_STYLE_UNIVERSITY:int = 5;
      
      public static const BG_STYLE_DROIDS:int = 6;
      
      public static const BG_STYLE_VENDORS:int = 7;
      
      public static const BG_STYLE_CHANCE_CARDS_HAUNTED:int = 8;
      
      public static const BG_STYLE_MUSIC_FESTIVAL:int = 9;
      
      public static const BG_STYLE_DYNAMIC_IMAGE:int = 10;
      
      public static const BG_STYLE_MANI_PEDI:int = 11;
      
      public static const BG_STYLE_CAKE_TOPPER:int = 12;
      
      public static const BG_STYLE_TRENDI:int = 13;
      
      public static const BG_STYLE_GUIDANCE:int = 14;
      
      public static const BG_STYLE_FOOD_RECIPE_PICKER_ONLY:int = 15;
      
      public static const BG_STYLE_DEATH:int = 16;
      
      public static const BG_STYLE_TAROT:int = 17;
      
      public static const FOOTER_TYPE_AUTOMATIC:* = 0;
      
      public static const FOOTER_TYPE_YES_BUTTONS_FOOTER:* = 1;
      
      public static const FOOTER_TYPE_YES_NO_FOOTER:* = 2;
      
      public static const LABEL_BG_STYLE_DEFAULT:String = "default";
      
      public static const LABEL_BG_STYLE_CELEBRATION:String = "celebration";
      
      public static const LABEL_BG_STYLE_CELEBRATION_LARGE:String = "celebrationLarge";
      
      public static const LABEL_BG_STYLE_CHANCE_CARDS:String = "chance_cards";
      
      public static const LABEL_BG_STYLE_LIFESTYLE_BRAND:String = "lifestyle_brand";
      
      public static const LABEL_BG_STYLE_UNIVERSITY:String = "degree";
      
      public static const LABEL_BG_STYLE_DROIDS:String = "droids";
      
      public static const LABEL_BG_STYLE_VENDORS:String = "vendors";
      
      public static const LABEL_BG_STYLE_TRENDI:String = "trendi";
      
      public static const LABEL_BG_STYLE_CHANCE_CARDS_HAUNTED:String = "haunted";
      
      public static const LABEL_BG_STYLE_MUSIC_FESTIVAL:String = "music_festival";
      
      public static const LABEL_BG_STYLE_DYNAMIC_IMAGE:String = "dynamic_img";
      
      public static const LABEL_BG_STYLE_DYNAMIC_BG:String = "dynamic_bg";
      
      public static const LABEL_BG_STYLE_MANI_PEDI:String = "mani_pedi";
      
      public static const LABEL_BG_STYLE_CAKE_TOPPER:String = "cake_topper";
      
      public static const LABEL_BG_STYLE_GUIDANCE:String = "emily_background";
      
      public static const LABEL_BG_STYLE_DEATH:String = "death";
      
      public static const LABEL_BG_STYLE_TAROT:String = "tarot";
      
      public static const BACKGROUND_FOOTER_NO_STRIP_LABEL:String = "no_strip";
      
      public static const LABEL_STYLE_DEFAULT:String = "default";
      
      public static const LABEL_STYLE_ICON_WITH_BACKGROUND:String = "iconwithbackground";
      
      public static const LABEL_STYLE_LARGE_ICON_TEXT_VERTICAL:String = "large_icon";
      
      public static const LABEL_STYLE_LARGE_ICON_TEXT_HORIZONTAL:String = "large_icon_and_text";
      
      public static const LABEL_STYLE_LARGE_ICON_TEXT_VERTICAL_WIDE:String = "large_icon_wide";
      
      public static const LABEL_STYLE_GUIDANCE_WARNING:String = "sim_image_";
      
      public function DialogTypes()
      {
         super();
      }
      
      public static function GetNumButtons(param1:int) : int
      {
         switch(param1)
         {
            case SINGLE_BUTTON:
            case ONE_BUTTON_INPUT:
            case YES_NO:
            case ONE_BUTTON_MULTI_INPUT:
            case YES:
               return 1;
            case TWO_BUTTON:
            case TWO_BUTTON_INPUT:
               return 2;
            case THREE_BUTTON:
               return 3;
            case CUSTOM:
               return 0;
            default:
               return 0;
         }
      }
      
      public static function GetNumInputFields(param1:int) : int
      {
         switch(param1)
         {
            case SINGLE_BUTTON:
            case TWO_BUTTON:
            case THREE_BUTTON:
            case CUSTOM:
            case YES_NO:
            case ONE_BUTTON_MULTI_INPUT:
               return 0;
            case TWO_BUTTON_INPUT:
            case ONE_BUTTON_INPUT:
               return 1;
            default:
               return 0;
         }
      }
      
      public static function GetLabelForBackgroundStyle(param1:int) : String
      {
         switch(param1)
         {
            case BG_STYLE_CELEBRATION:
               return LABEL_BG_STYLE_CELEBRATION;
            case BG_STYLE_CELEBRATION_LARGE:
               return LABEL_BG_STYLE_CELEBRATION_LARGE;
            case BG_STYLE_CHANCE_CARDS:
               return LABEL_BG_STYLE_CHANCE_CARDS;
            case BG_STYLE_LIFESTYLE_BRAND:
               return LABEL_BG_STYLE_LIFESTYLE_BRAND;
            case BG_STYLE_UNIVERSITY:
               return LABEL_BG_STYLE_UNIVERSITY;
            case BG_STYLE_DROIDS:
               return LABEL_BG_STYLE_DROIDS;
            case BG_STYLE_VENDORS:
               return LABEL_BG_STYLE_VENDORS;
            case BG_STYLE_TRENDI:
               return LABEL_BG_STYLE_TRENDI;
            case BG_STYLE_CHANCE_CARDS_HAUNTED:
               return LABEL_BG_STYLE_CHANCE_CARDS_HAUNTED;
            case BG_STYLE_MUSIC_FESTIVAL:
               return LABEL_BG_STYLE_MUSIC_FESTIVAL;
            case BG_STYLE_DYNAMIC_IMAGE:
               return LABEL_BG_STYLE_DYNAMIC_IMAGE;
            case BG_STYLE_MANI_PEDI:
               return LABEL_BG_STYLE_MANI_PEDI;
            case BG_STYLE_CAKE_TOPPER:
               return LABEL_BG_STYLE_CAKE_TOPPER;
            case BG_STYLE_GUIDANCE:
               return LABEL_BG_STYLE_GUIDANCE;
            case BG_STYLE_DEATH:
               return LABEL_BG_STYLE_DEATH;
            case BG_STYLE_TAROT:
               return LABEL_BG_STYLE_TAROT;
            case BG_STYLE_DEFAULT:
         }
         return LABEL_BG_STYLE_DEFAULT;
      }
      
      public static function GetLabelForFooterBackgroundStyle(param1:int) : String
      {
         switch(param1)
         {
            case BG_STYLE_CHANCE_CARDS_HAUNTED:
               return LABEL_BG_STYLE_CHANCE_CARDS_HAUNTED;
            case BG_STYLE_DEATH:
               return LABEL_BG_STYLE_DEATH;
            case BG_STYLE_TAROT:
               return LABEL_BG_STYLE_TAROT;
            case BG_STYLE_DEFAULT:
         }
         return LABEL_BG_STYLE_DEFAULT;
      }
      
      public static function GetLabelForStyle(param1:int) : String
      {
         switch(param1)
         {
            case STYLE_ICON_WITH_BACKGROUND:
               return LABEL_STYLE_ICON_WITH_BACKGROUND;
            case STYLE_LARGE_ICON:
               return LABEL_STYLE_LARGE_ICON_TEXT_VERTICAL;
            case STYLE_LARGE_ICON_TEXT_HORIZONTAL:
               return LABEL_STYLE_LARGE_ICON_TEXT_HORIZONTAL;
            case STYLE_LARGE_ICON_WIDE:
               return LABEL_STYLE_LARGE_ICON_TEXT_VERTICAL_WIDE;
            case STYLE_GUIDANCE_WARNING:
               return LABEL_STYLE_GUIDANCE_WARNING;
            case STYLE_CHANCE_CARDS:
            case STYLE_CELEBRATION:
            case STYLE_DEFAULT:
         }
         return LABEL_STYLE_DEFAULT;
      }
   }
}

