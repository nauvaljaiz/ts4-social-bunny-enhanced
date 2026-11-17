package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class SimTraitsInfo extends OlympusObject
   {
      
      public static const TRAIT_PERSONALITY:String = "0";
      
      public static const TRAIT_GAMEPLAY:String = "1";
      
      public static const TRAIT_WALKSTYLE:String = "2";
      
      public static const TRAIT_HIDDEN:String = "4";
      
      public static const TRAIT_GHOST:String = "5";
      
      public static const TRAIT_ASPIRATION:String = "6";
      
      public static const TRAIT_TAILSTYLE:String = "7";
      
      public static const TRAIT_GENDER_OPTIONS:String = "8";
      
      public static const TRAIT_SIM_PHONE:String = "9";
      
      public static const TRAIT_PHASE:String = "10";
      
      public static const TRAIT_AGENT:String = "11";
      
      public static const TRAIT_INFECTION:String = "12";
      
      public static const TRAIT_CURSE:String = "13";
      
      public static const TRAIT_ROOMMATE:String = "14";
      
      public static const TRAIT_ROBOT_MODULE:String = "15";
      
      public static const TRAIT_ROBOT:String = "16";
      
      public static const TRAIT_PROFESSOR:String = "17";
      
      public static const TRAIT_UNIVERSITY_DEGREE:String = "18";
      
      public static const TRAIT_ROBOT_MODULE_LOCKED:String = "19";
      
      public static const TRAIT_BATUU_ALIEN:String = "20";
      
      public static const TRAIT_LIFESTYLE:String = "21";
      
      public static const TRAIT_LIKE:String = "22";
      
      public static const TRAIT_DISLIKE:String = "23";
      
      public static const TRAIT_FOOD_RESTRICTION:String = "24";
      
      public static const TRAIT_TRADITION:String = "25";
      
      public static const TRAIT_TEMPERAMENT:String = "26";
      
      public static const TRAIT_PACK_MEMBER:String = "27";
      
      public static const TRAIT_PACK_FRIEND:String = "28";
      
      public static const TRAIT_FEAR:String = "29";
      
      public static const TRAIT_HIGH_SCHOOL:* = "30";
      
      public static const TRAIT_GAMEPLAY_OBJECT_PREFERENCE:String = "31";
      
      public static const TRAIT_INFANT_CARRIER:String = "32";
      
      public static const TRAIT_GAMEPLAY_GENERIC:String = "33";
      
      public static const TRAIT_HORSE_ACCOLADE:String = "34";
      
      public static const TRAIT_MASTERY_PERK:String = "35";
      
      public static const TRAIT_CHILD_REWARD:String = "36";
      
      public static const TRAIT_UI_CATEGORY_PERSONALITY:String = "0";
      
      public static const TRAIT_UI_CATEGORY_GENDER:String = "1";
      
      public static const TRAIT_UI_CATEGORY_IDENTITY:String = "2";
      
      public static const TRAIT_UI_CATEGORY_BREEDABLE:String = "3";
      
      public static const TRAIT_UI_CATEGORY_SPECIAL:String = "4";
      
      public static const TRAIT_UI_CATEGORY_RELATIONSHIP_EXPECTATIONS:String = "5";
      
      public static const TRAIT_UI_CATEGORY_EXPLORING_RELATIONSHIP_EXPECTATIONS:String = "6";
      
      public static const TRAIT_UI_CATEGORY_SEXUAL_ORIENTATION_WOOHOO_ATTRACTED:String = "7";
      
      public static const TRAIT_UI_CATEGORY_SEXUAL_ORIENTATION_WOOHOO_NOT_ATTRACTED:String = "8";
      
      public static const TRAIT_UI_CATEGORY_SEXUAL_ORIENTATION_ROMANCE_ATTRACTED:String = "9";
      
      public static const TRAIT_UI_CATEGORY_SEXUAL_ORIENTATION_ROMANCE_NOT_ATTRACTED:String = "10";
      
      public static const TRAIT_UI_CATEGORY_EXPLORING_SEXUAL_ORIENTATION:String = "11";
      
      public var trait_id:String;
      
      public var sim_id:String;
      
      public var at_risk:Boolean;
      
      protected var staticData:TraitsStaticData;
      
      protected var mTypeLocKey:LocKey = null;
      
      protected var mbJustAdded:Boolean = false;
      
      public function SimTraitsInfo(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.staticData = TraitsStaticData.GetStaticData(this.trait_id);
         if(!this.staticData)
         {
            this.staticData = new TraitsStaticData();
         }
         switch(this.staticData.type)
         {
            case TRAIT_PERSONALITY:
               this.mTypeLocKey = KeysGP.SUMMARY_PANEL_TRAIT_TYPE_PERSONALITY;
               break;
            case TRAIT_GAMEPLAY:
               this.mTypeLocKey = KeysGP.SUMMARY_PANEL_TRAIT_TYPE_REWARD;
               break;
            case TRAIT_WALKSTYLE:
               this.mTypeLocKey = KeysGP.SUMMARY_PANEL_TRAIT_TYPE_WALKSTYLE;
         }
      }
      
      public function get IsJustAdded() : Boolean
      {
         return this.mbJustAdded;
      }
      
      public function set IsJustAdded(param1:Boolean) : void
      {
         this.mbJustAdded = param1;
      }
      
      public function GetTraitTitleLocKeyBySimIdToken(param1:Object = null) : LocKey
      {
         return this.staticData.GetTitleLocKeyBySimIdToken(param1);
      }
      
      public function GetTraitTitleStringBySimIdToken(param1:Object) : String
      {
         return this.staticData.GetTitleLocKeyBySimIdToken(param1).toString(param1);
      }
      
      public function GetTraitDescriptionLocKeyBySimIdToken(param1:Object = null) : LocKey
      {
         return this.staticData.GetDescriptionLocKeyBySimIdToken(param1);
      }
      
      public function GetTraitDescriptionStringBySimIdToken(param1:Object) : String
      {
         return this.staticData.GetDescriptionLocKeyBySimIdToken(param1).toString(param1);
      }
      
      public function GetTraitOriginDescriptionLocKeyBySimIdToken(param1:Object = null) : LocKey
      {
         return this.staticData.GetTraitOriginDescriptionLocKeyBySimIdToken(param1);
      }
      
      public function GetTraitOriginDescriptionStringBySimIdToken(param1:Object) : String
      {
         return this.staticData.GetTraitOriginDescriptionLocKeyBySimIdToken(param1).toString(param1);
      }
      
      public function GetTraitIconBySimIdToken(param1:Object = null) : String
      {
         return this.staticData.GetIconBySimIdToken(param1);
      }
      
      public function get TraitType() : String
      {
         return this.staticData.type;
      }
      
      public function get TraitCategory() : String
      {
         return this.staticData.ui_category;
      }
      
      public function get TypeLocKey() : LocKey
      {
         return this.mTypeLocKey;
      }
      
      public function get StaticData() : TraitsStaticData
      {
         return this.staticData;
      }
   }
}

