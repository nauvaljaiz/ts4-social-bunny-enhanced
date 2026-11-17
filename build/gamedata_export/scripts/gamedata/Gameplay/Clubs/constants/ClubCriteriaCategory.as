package gamedata.Gameplay.Clubs.constants
{
   import gamedata.GameContent;
   import olympus.controls.objects.MenuItem;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class ClubCriteriaCategory
   {
      
      public static const SKILL:uint = 0;
      
      public static const TRAIT:uint = 1;
      
      public static const RELATIONSHIP:uint = 2;
      
      public static const CAREER:uint = 3;
      
      public static const HOUSEHOLD_VALUE:uint = 4;
      
      public static const AGE:uint = 5;
      
      public static const CLUB_MEMBERSHIP:uint = 6;
      
      public static const FAME_RANK:uint = 7;
      
      public static const CARE_SIM_TYPE_SUPERVISED:uint = 8;
      
      public static const OCCULT:uint = 9;
      
      public static const GENDER:uint = 10;
      
      public static const REGION:uint = 11;
      
      public static const EVERYONE:uint = uint.MAX_VALUE - 1;
      
      public static const ROMANTIC_ATTRACTION:uint = 12;
      
      public static const RELATIONSHIP_STATUS:uint = 13;
      
      public static const ICON_DEFAULT:String = "0x91258c3a36f1dda7";
      
      public static const ICON_RULES_DEFAULT:String = "0xffbeeca058178d7e";
      
      protected static const ICON_SKILL:String = "0x7f04e7fccff0e2f7";
      
      protected static const ICON_TRAIT:String = "0xd7d62a08641d1eb4";
      
      protected static const ICON_RELATIONSHIP:String = "0x8661e30727264cb2";
      
      protected static const ICON_CAREER:String = "0x798fa2c519896ec6";
      
      protected static const ICON_HOUSEHOLD_VALUE:String = "0x18ce0d66c8df2891";
      
      protected static const ICON_AGE:String = "0x209877f65215b6a1";
      
      protected static const ICON_CLUB_MEMBERSHIP:String = "0x3eb1bee99229d3cf";
      
      protected static const ICON_FAME_RANK:String = "0xa875d56ec15a93ae";
      
      protected static const ICON_SUPERVISED:String = "0x248b303bf92a6296";
      
      protected static const ICON_OCCULT:String = "0x50c9b6036b50f6fe";
      
      protected static const ICON_GENDER:String = "0x0ff2793f3e3e637c";
      
      protected static const ICON_REGION:String = "0x388bf1413e367103";
      
      protected static const ICON_EVERYONE:String = "0x0aa8db0027bffba3";
      
      protected static const ICON_ATTRACTION:String = "0xde861435b79e0c91";
      
      protected static const ICON_RELATIONSHIP_STATUS:String = "0x2c972af397eeed8f";
      
      public static const ADMISSION_CATEGORY_AGE:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_AGE.toString(),AGE,true,ICON_AGE);
      
      public static const ADMISSION_CATEGORY_TRAIT:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_TRAIT.toString(),TRAIT,true,ICON_TRAIT);
      
      public static const ADMISSION_CATEGORY_SKILL:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_SKILL.toString(),SKILL,true,ICON_SKILL);
      
      public static const ADMISSION_CATEGORY_OCCULT:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_OCCULT.toString(),OCCULT,true,ICON_OCCULT);
      
      public static const ADMISSION_CATEGORY_CAREER:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_CAREER.toString(),CAREER,true,ICON_CAREER);
      
      public static const ADMISSION_CATEGORY_RELATIONSHIP_STATUS:* = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_RELATIONSHIP_STATUS.toString(),RELATIONSHIP_STATUS,true,ICON_RELATIONSHIP_STATUS);
      
      public static const ADMISSION_CATEGORIES:Array = [ADMISSION_CATEGORY_AGE,ADMISSION_CATEGORY_CAREER,new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_RELATIONSHIP.toString(),RELATIONSHIP,true,ICON_RELATIONSHIP),new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_HOUSEHOLD_VALUE.toString(),HOUSEHOLD_VALUE,true,ICON_HOUSEHOLD_VALUE),ADMISSION_CATEGORY_TRAIT,ADMISSION_CATEGORY_SKILL,ADMISSION_CATEGORY_OCCULT];
      
      public static const CUSTOM_SCHEDULE_CATEGORIES:Array = [ADMISSION_CATEGORY_AGE,ADMISSION_CATEGORY_SKILL,new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_GENDER.toString(),GENDER,true,ICON_GENDER),new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_ATTRACTION.toString(),ROMANTIC_ATTRACTION,true,ICON_ATTRACTION),new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_REGION.toString(),REGION,true,ICON_REGION),ADMISSION_CATEGORY_TRAIT,ADMISSION_CATEGORY_OCCULT,ADMISSION_CATEGORY_CAREER,ADMISSION_CATEGORY_RELATIONSHIP_STATUS];
      
      public static const ADMISSION_CATEGORY_FAME:MenuItem = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_FAME_RANK.toString(),FAME_RANK,true,ICON_FAME_RANK);
      
      public static const ADMISSION_CATEGORY_SUPERVISED:MenuItem = new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_SUPERVISED.toString(),CARE_SIM_TYPE_SUPERVISED,true,ICON_SUPERVISED);
      
      public static const CONDUCT_RULE_CATEGORIES:Array = [new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_EVERYONE.toString(),EVERYONE,true,ICON_EVERYONE),new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_CLUB.toString(),CLUB_MEMBERSHIP,true,ICON_CLUB_MEMBERSHIP),new MenuItem(KeysGP.CLUB_CRITERIA_CATEGORY_AGE.toString(),AGE,true,ICON_AGE)];
      
      public static const CATEGORY_DO_THIS:Boolean = true;
      
      public static const CATEGORY_DONT_DO_THIS:Boolean = false;
      
      public static const ICON_DO_THIS:String = "0x7d6ce658c6cde7a9";
      
      public static const ICON_DONT_DO_THIS:String = "0xde4080c27f5e8b6b";
      
      public static const DOS_DONTS_CATEGORIES:Array = [new MenuItem(KeysGP.CLUB_CRITERIA_CONDUCT_DO_THIS.toString(),CATEGORY_DO_THIS,true,ICON_DO_THIS),new MenuItem(KeysGP.CLUB_CRITERIA_CONDUCT_DONT_DO_THIS.toString(),CATEGORY_DONT_DO_THIS,true,ICON_DONT_DO_THIS)];
      
      public static const CRITERIA_SET_CUSTOM_SCHEDULE:uint = 1;
      
      public function ClubCriteriaCategory()
      {
         super();
      }
      
      public static function GetAdmissionCategories() : Array
      {
         if(GameContent.HAS_EP06)
         {
            return ADMISSION_CATEGORIES.concat(ADMISSION_CATEGORY_FAME);
         }
         return ADMISSION_CATEGORIES;
      }
      
      public static function GetSmallBusinessAdmissionCategories() : Array
      {
         var _loc1_:Array = ADMISSION_CATEGORIES.concat();
         if(GameContent.HAS_EP06)
         {
            _loc1_.push(ADMISSION_CATEGORY_FAME);
         }
         if(GameContent.HAS_EP18)
         {
            _loc1_.push(ADMISSION_CATEGORY_SUPERVISED);
         }
         return _loc1_;
      }
      
      public static function GetAlternateCategories(param1:uint) : Array
      {
         switch(param1)
         {
            case CRITERIA_SET_CUSTOM_SCHEDULE:
               if(GameContent.HAS_EP06)
               {
                  return CUSTOM_SCHEDULE_CATEGORIES.concat(ADMISSION_CATEGORY_FAME);
               }
               return CUSTOM_SCHEDULE_CATEGORIES;
               break;
            default:
               return ADMISSION_CATEGORIES;
         }
      }
      
      public static function CanSupportRequired(param1:uint) : Boolean
      {
         switch(param1)
         {
            case REGION:
               return false;
            default:
               return true;
         }
      }
      
      public static function GetCategoryIcon(param1:uint) : String
      {
         switch(param1)
         {
            case SKILL:
               return ICON_SKILL;
            case TRAIT:
               return ICON_TRAIT;
            case RELATIONSHIP:
               return ICON_RELATIONSHIP;
            case CAREER:
               return ICON_CAREER;
            case HOUSEHOLD_VALUE:
               return ICON_HOUSEHOLD_VALUE;
            case AGE:
               return ICON_AGE;
            case CLUB_MEMBERSHIP:
               return ICON_CLUB_MEMBERSHIP;
            case FAME_RANK:
               return ICON_FAME_RANK;
            case CARE_SIM_TYPE_SUPERVISED:
               return ICON_SUPERVISED;
            case OCCULT:
               return ICON_OCCULT;
            case GENDER:
               return ICON_GENDER;
            case REGION:
               return ICON_REGION;
            case ROMANTIC_ATTRACTION:
               return ICON_ATTRACTION;
            case RELATIONSHIP_STATUS:
               return ICON_RELATIONSHIP_STATUS;
            case EVERYONE:
               return ICON_EVERYONE;
            default:
               return ICON_DEFAULT;
         }
      }
      
      public static function GetCategoryTooltipLocKey(param1:uint, param2:Boolean = false, param3:Boolean = true) : LocKey
      {
         switch(param1)
         {
            case SKILL:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_SKILL;
            case TRAIT:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_TRAIT;
            case RELATIONSHIP:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_REL;
            case CAREER:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_CAREER;
            case HOUSEHOLD_VALUE:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_HH_VALUE;
            case AGE:
               return param2 ? KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_AGE_TARGETED : KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_AGE;
            case CLUB_MEMBERSHIP:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_CLUB_TARGETED;
            case FAME_RANK:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_FAME_RANK;
            case OCCULT:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_OCCULT;
            case GENDER:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_GENDER;
            case REGION:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_REGION;
            case ROMANTIC_ATTRACTION:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_ROMANTIC_ATTRACTION;
            case RELATIONSHIP_STATUS:
               return KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_RELATIONSHIP_STATUS;
            case EVERYONE:
               return param3 ? KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_EVERYONE : KeysGP.CLUB_RULES_TOOLTIP_CATEGORY_ANYONE;
            default:
               return null;
         }
      }
   }
}

