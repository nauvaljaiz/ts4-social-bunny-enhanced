package gamedata.CAS.shared
{
   import gamedata.TutorialTip.TutorialMode;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysCAS;
   import olympus.localization.LocKey;
   
   public class CASConfiguration
   {
      
      public static const CASEDITMODE_DEFAULT:int = 0;
      
      public static const CASEDITMODE_MANNEQUIN:int = 1;
      
      public static const CASEDITMODE_MANNEQUIN_APPLY_OUTFIT:int = 2;
      
      public static const CASEDITMODE_MANNEQUIN_CAREER:int = 3;
      
      public static const CASEDITMODE_DISGUISE:int = 4;
      
      public static const CASEDITMODE_CAREER:int = 5;
      
      public static const CASEDITMODE_MANNEQUIN_CLUB:int = 6;
      
      public static const CASEDITMODE_SINGLE_SIM:int = 7;
      
      public static const CASEDITMODE_GENDER:int = 8;
      
      public static const CASEDITMODE_FTUE:int = 9;
      
      public static const CASEDITMODE_BATUU:int = 10;
      
      public static const CASEDITMODE_FASHION:int = 11;
      
      public static const CASEDITMODE_PREFERENCES:int = 12;
      
      public static const CASEDITMODE_SIM_CUSTOMIZATION:int = 13;
      
      public static const CASEDITMODE_REINCARNATION:int = 14;
      
      public static const CASEDITMODE_TATTOO:int = 15;
      
      public static const CASEDITMODE_SMALL_BUSINESS:int = 16;
      
      public static const CASEDITMODE_MANNEQUIN_SMALL_BUSINESS:int = 17;
      
      public static const DEFAULT:int = 0;
      
      public static const CANNOT_ADD_SIMS:int = 1 << 0;
      
      public static const CANNOT_USE_GALLERY:int = 1 << 1;
      
      public static const CANNOT_SAVE:int = 1 << 2;
      
      public static const CANNOT_MODIFY_FIT_FAT:int = 1 << 3;
      
      public static const CANNOT_ACCESS_FACIAL_HAIR:int = 1 << 4;
      
      public static const CANNOT_TATTOO:int = 1 << 5;
      
      public static const CANNOT_MODIFY_PERSONALITY:int = 1 << 6;
      
      public static const SHOW_CAREER_LOOKS_ONLY:int = 1 << 7;
      
      public static const HIDE_SIM_SELECTOR:int = 1 << 8;
      
      public static const CANNOT_MODIFY_HEAD_FEATURES:int = 1 << 9;
      
      public static const CAN_REMOVE_SELECTED_OUTFIT:int = 1 << 10;
      
      public static const CAN_MODIFY_GENDER:int = 1 << 11;
      
      public static const SHOW_BATUU_LOOKS_ONLY:int = 1 << 12;
      
      public static const SHOW_FASHION:int = 1 << 13;
      
      public static const SHOW_PREFERENCES:int = 1 << 14;
      
      public static const SHOW_SIM_CUSTOMIZATION:int = 1 << 15;
      
      public static const CANNOT_REMOVE_OUTFITS:int = 1 << 16;
      
      public static const SHOW_SMALL_BUSINESS_LOOKS_ONLY:int = 1 << 17;
      
      public static const CONFIG_DEFAULT_CAS:int = DEFAULT;
      
      public static const CONFIG_EDIT_GENDER:int = CAN_MODIFY_GENDER;
      
      public static const CONFIG_ALIEN:int = CANNOT_ADD_SIMS | CANNOT_USE_GALLERY | CANNOT_SAVE | CANNOT_ACCESS_FACIAL_HAIR | CANNOT_MODIFY_PERSONALITY;
      
      public static const CONFIG_MANNEQUIN:int = CANNOT_ADD_SIMS | CANNOT_USE_GALLERY | CANNOT_SAVE | CANNOT_TATTOO | CANNOT_ACCESS_FACIAL_HAIR | HIDE_SIM_SELECTOR | CANNOT_MODIFY_PERSONALITY | CANNOT_MODIFY_HEAD_FEATURES;
      
      public static const CONFIG_UNIFORM:int = CONFIG_MANNEQUIN | SHOW_CAREER_LOOKS_ONLY;
      
      public static const CONFIG_SMALL_BUSINESS_UNIFORM:int = CONFIG_MANNEQUIN | SHOW_SMALL_BUSINESS_LOOKS_ONLY;
      
      public static const CONFIG_CLUB:int = CONFIG_MANNEQUIN | CAN_REMOVE_SELECTED_OUTFIT;
      
      public static const CONFIG_FASHION:int = CONFIG_MANNEQUIN | SHOW_FASHION;
      
      public static const CONFIG_SINGLE_SIM:int = CANNOT_ADD_SIMS | CANNOT_USE_GALLERY | CANNOT_SAVE | HIDE_SIM_SELECTOR | CANNOT_MODIFY_PERSONALITY;
      
      public static const CONFIG_BATUU_PLAN_OUTFIT:int = CONFIG_SINGLE_SIM | SHOW_BATUU_LOOKS_ONLY;
      
      public static const CONFIG_PREFERENCES:int = CANNOT_ADD_SIMS | SHOW_PREFERENCES;
      
      public static const CONFIG_SIM_CUSTOMIZATION:int = CANNOT_ADD_SIMS | CAN_MODIFY_GENDER | SHOW_SIM_CUSTOMIZATION;
      
      public static const CONFIG_REINCARNATION:int = CANNOT_SAVE;
      
      public static const CONFIG_CAREER:int = CANNOT_ADD_SIMS | CANNOT_USE_GALLERY | CANNOT_REMOVE_OUTFITS;
      
      public static const CONFIG_TATTOO:int = CANNOT_ADD_SIMS | CANNOT_MODIFY_FIT_FAT | CANNOT_ACCESS_FACIAL_HAIR | CANNOT_MODIFY_PERSONALITY | HIDE_SIM_SELECTOR | CANNOT_MODIFY_HEAD_FEATURES | CANNOT_SAVE;
      
      protected static var sCASEditMode:int = -1;
      
      protected static var sCurrentConfiguration:int = -1;
      
      public static const PAINTMODE_PELT:int = 1;
      
      public static const PAINTMODE_TATTOO:int = 2;
      
      public static const PAINTMODE_WING:int = 3;
      
      public function CASConfiguration()
      {
         super();
      }
      
      public static function DetermineConfiguration() : void
      {
         sCASEditMode = CommunicationManager.CallGameService("CasGetCASEditMode") as int;
         switch(sCASEditMode)
         {
            case CASEDITMODE_DISGUISE:
               sCurrentConfiguration = CONFIG_ALIEN;
               return;
            case CASEDITMODE_MANNEQUIN_CAREER:
               sCurrentConfiguration = CONFIG_UNIFORM;
               return;
            case CASEDITMODE_MANNEQUIN_CLUB:
               sCurrentConfiguration = CONFIG_CLUB;
               return;
            case CASEDITMODE_MANNEQUIN:
            case CASEDITMODE_MANNEQUIN_APPLY_OUTFIT:
               sCurrentConfiguration = CONFIG_MANNEQUIN;
               return;
            case CASEDITMODE_MANNEQUIN_SMALL_BUSINESS:
               sCurrentConfiguration = CONFIG_SMALL_BUSINESS_UNIFORM;
               return;
            case CASEDITMODE_FASHION:
               sCurrentConfiguration = CONFIG_FASHION;
               return;
            case CASEDITMODE_SINGLE_SIM:
               sCurrentConfiguration = CONFIG_SINGLE_SIM;
               return;
            case CASEDITMODE_GENDER:
               sCurrentConfiguration = CONFIG_EDIT_GENDER;
               return;
            case CASEDITMODE_BATUU:
               sCurrentConfiguration = CONFIG_BATUU_PLAN_OUTFIT;
               return;
            case CASEDITMODE_PREFERENCES:
               sCurrentConfiguration = CONFIG_PREFERENCES;
               return;
            case CASEDITMODE_SIM_CUSTOMIZATION:
               sCurrentConfiguration = CONFIG_SIM_CUSTOMIZATION;
               return;
            case CASEDITMODE_REINCARNATION:
               sCurrentConfiguration = CONFIG_REINCARNATION;
               return;
            case CASEDITMODE_CAREER:
               sCurrentConfiguration = CONFIG_CAREER;
               return;
            case CASEDITMODE_TATTOO:
               sCurrentConfiguration = CONFIG_TATTOO;
               return;
            default:
               sCurrentConfiguration = CONFIG_DEFAULT_CAS;
               if(TutorialMode.IsFTUE())
               {
                  sCurrentConfiguration |= CANNOT_ADD_SIMS;
               }
               return;
         }
      }
      
      public static function ResetConfiguration() : void
      {
         sCurrentConfiguration = -1;
      }
      
      public static function get CurrentConfiguration() : int
      {
         if(sCurrentConfiguration == -1)
         {
            DetermineConfiguration();
         }
         return sCurrentConfiguration;
      }
      
      public static function get CurrentMode() : int
      {
         if(sCurrentConfiguration == -1)
         {
            DetermineConfiguration();
         }
         return sCASEditMode;
      }
      
      public static function IsConfigured(param1:int) : Boolean
      {
         return Boolean(CurrentConfiguration & param1);
      }
      
      public static function get IsSimNew() : Boolean
      {
         var _loc1_:SimInfo = new SimInfo(CommunicationManager.CallGameService("CASGetSimInfo"));
         return _loc1_.SimIsNew;
      }
      
      public static function get IsAlienMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_ALIEN;
      }
      
      public static function get IsMannequinMode() : Boolean
      {
         return (CurrentConfiguration & CONFIG_MANNEQUIN) == CONFIG_MANNEQUIN;
      }
      
      public static function get IsFashionMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_FASHION;
      }
      
      public static function get IsUniformMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_UNIFORM;
      }
      
      public static function get IsClubMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_CLUB;
      }
      
      public static function get IsSingleSimMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_SINGLE_SIM;
      }
      
      public static function get IsEditGenderMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_EDIT_GENDER;
      }
      
      public static function get IsBatuuPlanOutfitMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_BATUU_PLAN_OUTFIT;
      }
      
      public static function get IsPreferencesMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_PREFERENCES;
      }
      
      public static function get IsReincarnationMode() : Boolean
      {
         return CurrentMode == CASEDITMODE_REINCARNATION;
      }
      
      public static function get IsSimCustomizationMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_SIM_CUSTOMIZATION;
      }
      
      public static function get IsTattooOnlyMode() : Boolean
      {
         return CurrentConfiguration == CONFIG_TATTOO;
      }
      
      public static function get HasProhibitedTags() : Boolean
      {
         return IsBatuuPlanOutfitMode || IsTattooOnlyMode;
      }
      
      public static function GetProhibitedTags() : Array
      {
         return CommunicationManager.CallGameService("CasProhibitedTagsByMode",sCASEditMode) as Array;
      }
      
      public static function GetRandomizePanelDisableTooltip() : LocKey
      {
         if(CASConfiguration.IsTattooOnlyMode)
         {
            return KeysCAS.NAV_RANDOMIZE_ROBOT_DISABLED_TOOLTIP;
         }
         return null;
      }
   }
}

