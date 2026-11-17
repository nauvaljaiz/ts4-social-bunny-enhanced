package widgets.shared.constants
{
   public final class SituationSharedTunables
   {
      
      public static const PIVOTAL_MOMENT_DETAILS_SOURCE_SITUATION_PANEL:int = 0;
      
      public static const PIVOTAL_MOMENT_DETAILS_SOURCE_OUTCOME:int = 1;
      
      public static const SITUATION_DISPLAY_STYLE_DEFAULT:uint = 0;
      
      public static const SITUATION_DISPLAY_STYLE_HAUNTED:uint = 1;
      
      public static const SITUATION_DISPLAY_STYLE_ROMANCE:uint = 2;
      
      public static const SITUATION_DISPLAY_STYLE_GRIM:uint = 3;
      
      public static const SITUATION_DISPLAY_STYLE_ANNIVERSARY:uint = 4;
      
      public static const SITUATION_DISPLAY_STYLE_DECEMBER:uint = 5;
      
      public static const SITUATION_DISPLAY_STYLE_NATURE:uint = 6;
      
      public static const SITUATION_DISPLAY_STYLE_IMAGINATION:uint = 7;
      
      public static const SITUATION_DISPLAY_STYLE_PALMS:uint = 8;
      
      public static const SITUATION_DISPLAY_STYLE_EV008:uint = 9;
      
      public static const SITUATION_DISPLAY_STYLE_EV009:uint = 10;
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_DEFAULT:String = "default";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_HAUNTED:String = "haunted";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_ROMANCE:String = "romance";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_GRIM:String = "grim_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_ANNIVERSARY:String = "anniversary_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_DECEMBER:String = "december_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_NATURE:String = "nature_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_IMAGINATION:String = "imagination_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_PALMS:String = "palms_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_EV008:String = "ev008_event";
      
      public static const LABEL_SITUATION_DISPLAY_STYLE_EV009:String = "ev009_event";
      
      public static const SITUATION_PERSIST_CONTEXT:String = "situationPersistSelection";
      
      public function SituationSharedTunables()
      {
         super();
      }
      
      public static function GetSituationDisplayStyleLabel(param1:int) : String
      {
         switch(param1)
         {
            case SITUATION_DISPLAY_STYLE_HAUNTED:
               return LABEL_SITUATION_DISPLAY_STYLE_HAUNTED;
            case SITUATION_DISPLAY_STYLE_ROMANCE:
               return LABEL_SITUATION_DISPLAY_STYLE_ROMANCE;
            case SITUATION_DISPLAY_STYLE_GRIM:
               return LABEL_SITUATION_DISPLAY_STYLE_GRIM;
            case SITUATION_DISPLAY_STYLE_ANNIVERSARY:
               return LABEL_SITUATION_DISPLAY_STYLE_ANNIVERSARY;
            case SITUATION_DISPLAY_STYLE_DECEMBER:
               return LABEL_SITUATION_DISPLAY_STYLE_DECEMBER;
            case SITUATION_DISPLAY_STYLE_NATURE:
               return LABEL_SITUATION_DISPLAY_STYLE_NATURE;
            case SITUATION_DISPLAY_STYLE_IMAGINATION:
               return LABEL_SITUATION_DISPLAY_STYLE_IMAGINATION;
            case SITUATION_DISPLAY_STYLE_PALMS:
               return LABEL_SITUATION_DISPLAY_STYLE_PALMS;
            case SITUATION_DISPLAY_STYLE_EV008:
               return LABEL_SITUATION_DISPLAY_STYLE_EV008;
            case SITUATION_DISPLAY_STYLE_EV009:
               return LABEL_SITUATION_DISPLAY_STYLE_EV009;
            default:
               return LABEL_SITUATION_DISPLAY_STYLE_DEFAULT;
         }
      }
   }
}

