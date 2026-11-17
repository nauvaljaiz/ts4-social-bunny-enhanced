package widgets.shared.constants
{
   import gamedata.shared.Species;
   import olympus.localization.KeysCAS;
   import olympus.localization.LocKey;
   
   public class SimRelationship
   {
      
      public static const NONE:int = 6;
      
      public static const PARENT:int = 7;
      
      public static const SIBLING:int = 8;
      
      public static const SPOUSE:int = 9;
      
      public static const FIANCE:int = 10;
      
      public static const STEADY:int = 11;
      
      public static const DESCENDANT:int = 12;
      
      public static const GRANDPARENT:int = 13;
      
      public static const GRANDCHILD:int = 14;
      
      public static const SIBLINGS_CHILD:int = 15;
      
      public static const PARENTS_SIBLING:int = 16;
      
      public static const COUSIN:int = 17;
      
      public static const STEP_PARENT:int = 18;
      
      public static const STEP_SIBLING:int = 19;
      
      public static const STEP_CHILD:int = 21;
      
      public static const PARENT_IN_LAW:int = 22;
      
      public static const CHILD_IN_LAW:int = 23;
      
      public static const SIBLING_IN_LAW:int = 24;
      
      public static const DISTANT_RELATIVE:int = 25;
      
      public static const GREAT_GRANDPARENT:int = 26;
      
      public static const GREAT_GRANDCHILD:int = 27;
      
      public static const GRANDPARENT_SIBLING:int = 28;
      
      public static const PARENTS_COUSIN:int = 29;
      
      public static const SIBLINGS_GRANDCHILD:int = 30;
      
      public static const SIBLINGS_GREAT_GRANDCHILD:int = 31;
      
      public static const GREAT_GRANDPARENT_SIBLING:int = 32;
      
      public static const HALF_SIBLING:int = 33;
      
      public static const SECRET_PARENT:int = 34;
      
      public static const SECRET_CHILD:int = 35;
      
      public static const COUSINS_CHILD:int = 36;
      
      public static const END:int = 37;
      
      public static const FAMILY:int = 10;
      
      public static const PREMADE:int = 20;
      
      public function SimRelationship()
      {
         super();
      }
      
      public static function GetRelationshipName(param1:int, param2:int, param3:int) : LocKey
      {
         switch(param1)
         {
            case PARENT:
               return KeysCAS.PERSONALITY_RELATIONSHIP_PARENT;
            case SIBLING:
               return KeysCAS.PERSONALITY_RELATIONSHIP_SIBLING;
            case SPOUSE:
               return KeysCAS.PERSONALITY_RELATIONSHIP_SPOUSE;
            case DESCENDANT:
               return KeysCAS.PERSONALITY_RELATIONSHIP_DESCENDANT;
            case GRANDPARENT:
               return KeysCAS.PERSONALITY_RELATIONSHIP_GRANDPARENT;
            case GRANDCHILD:
               return KeysCAS.PERSONALITY_RELATIONSHIP_GRANDCHILD;
            case SIBLINGS_CHILD:
               return KeysCAS.PERSONALITY_RELATIONSHIP_SIBLINGS_CHILD;
            case PARENTS_SIBLING:
               return KeysCAS.PERSONALITY_RELATIONSHIP_PARENTS_SIBLING;
            case COUSIN:
               return KeysCAS.PERSONALITY_RELATIONSHIP_COUSIN;
            case FIANCE:
               return KeysCAS.PERSONALITY_RELATIONSHIP_FIANCE;
            case STEP_PARENT:
               return KeysCAS.PERSONALITY_RELATIONSHIP_STEP_PARENT;
            case STEP_SIBLING:
               return KeysCAS.PERSONALITY_RELATIONSHIP_STEP_SIBLING;
            case STEP_CHILD:
               return KeysCAS.PERSONALITY_RELATIONSHIP_STEP_CHILD;
            case STEADY:
               return KeysCAS.PERSONALITY_RELATIONSHIP_STEADY;
            case NONE:
               if(Species.IsPet(param3) && param2 == Species.TYPE_HUMAN)
               {
                  return KeysCAS.PERSONALITY_RELATIONSHIP_PET;
               }
               if(Species.IsPet(param2) && param3 == Species.TYPE_HUMAN)
               {
                  return KeysCAS.PERSONALITY_RELATIONSHIP_PET_OWNER;
               }
               return KeysCAS.PERSONALITY_RELATIONSHIP_NONE;
               break;
            default:
               return null;
         }
      }
      
      public static function IsRomanticRelationship(param1:int) : Boolean
      {
         switch(param1)
         {
            case SPOUSE:
            case STEADY:
            case FIANCE:
               return true;
            default:
               return false;
         }
      }
   }
}

