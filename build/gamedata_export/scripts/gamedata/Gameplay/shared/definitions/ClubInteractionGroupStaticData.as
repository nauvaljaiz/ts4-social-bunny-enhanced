package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class ClubInteractionGroupStaticData extends OlympusObject
   {
      
      protected static var sCategorizedInteractions:Object;
      
      public static var sGetAllStaticDataFunc:Function;
      
      public static const CATEGORY_OTHER:int = 0;
      
      public static const CATEGORY_SOCIAL:int = 1;
      
      public static const CATEGORY_SKILL:int = 2;
      
      public static const CATEGORY_OBJECT:int = 3;
      
      public static const CATEGORY_ART_AND_MUSIC:int = 4;
      
      public static const CATEGORY_FOOD_AND_DRINK:int = 5;
      
      public static const CATEGORY_FUN_AND_GAMES:int = 6;
      
      public static const CATEGORY_HOBBIES:int = 7;
      
      public static const CATEGORY_HOME_ACTIVITIES:int = 8;
      
      public static const CATEGORY_KID_ACTIVITIES:int = 9;
      
      public static const CATEGORY_MISCHIEF_AND_MAYHEM:int = 10;
      
      public static const CATEGORY_OUTDOOR:int = 11;
      
      public var uid:String;
      
      public var category:int;
      
      public var child_safe:Boolean;
      
      public var teen_safe:Boolean;
      
      public var name:LocKey = new LocKey();
      
      public var is_targeted:Boolean;
      
      public var category_icon:ResourceKey = new ResourceKey();
      
      public var tooltip_template:LocKey = new LocKey();
      
      public var tooltip_template_negative:LocKey = new LocKey();
      
      public var club_rule:Boolean;
      
      public var small_business_customer_rule:Boolean;
      
      public var small_business_employee_rule:Boolean;
      
      public var small_business_customer_tooltip:Array = [LocKey];
      
      public var small_business_employee_tooltip:Array = [LocKey];
      
      public var custom_schedule_activity:Boolean;
      
      public var custom_schedule_behavior:Boolean;
      
      public var custom_schedule_tooltip:Array = [LocKey];
      
      public function ClubInteractionGroupStaticData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.small_business_customer_tooltip);
         FixupArray(this.small_business_employee_tooltip);
         FixupArray(this.custom_schedule_tooltip);
      }
      
      public static function GetCategorizedInteractions() : Object
      {
         var _loc3_:Object = null;
         var _loc4_:ClubInteractionGroupStaticData = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(Boolean(sCategorizedInteractions) || sGetAllStaticDataFunc == null)
         {
            return sCategorizedInteractions;
         }
         var _loc1_:Object = new Object();
         var _loc2_:Array = sGetAllStaticDataFunc([]);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new ClubInteractionGroupStaticData(_loc3_);
            _loc5_ = _loc4_.category;
            _loc6_ = _loc1_[_loc5_];
            if(!_loc6_)
            {
               _loc1_[_loc5_] = new Array();
               _loc6_ = _loc1_[_loc5_];
            }
            _loc6_.push(_loc4_);
         }
         sCategorizedInteractions = _loc1_;
         return sCategorizedInteractions;
      }
      
      public static function GetInteractionGroupStaticDataByKey(param1:String) : ClubInteractionGroupStaticData
      {
         var _loc3_:Array = null;
         var _loc4_:ClubInteractionGroupStaticData = null;
         var _loc2_:Object = GetCategorizedInteractions();
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.uid == param1)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function GetInteractionGroupCategoryName(param1:int, param2:Boolean = false) : LocKey
      {
         switch(param1)
         {
            case CATEGORY_OTHER:
               break;
            case CATEGORY_SOCIAL:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_SOCIAL;
            case CATEGORY_SKILL:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_SKILL;
            case CATEGORY_OBJECT:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_OBJECT;
            case CATEGORY_ART_AND_MUSIC:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_ART_AND_MUSIC;
            case CATEGORY_FOOD_AND_DRINK:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_FOOD_AND_DRINK;
            case CATEGORY_FUN_AND_GAMES:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_FUN_AND_GAMES;
            case CATEGORY_HOBBIES:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_HOBBIES;
            case CATEGORY_HOME_ACTIVITIES:
               if(param2)
               {
                  return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_SMALL_BUSINESS_ACTIVITIES;
               }
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_HOME_ACTIVITIES;
               break;
            case CATEGORY_KID_ACTIVITIES:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_KID_ACTIVITIES;
            case CATEGORY_MISCHIEF_AND_MAYHEM:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_MISCHIEF_AND_MAYHEM;
            case CATEGORY_OUTDOOR:
               return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_OUTDOOR;
         }
         return KeysGP.CLUB_INTERACTION_GROUP_CATEGORY_OTHER;
      }
      
      public static function GetInteractionGroupCategoryIcon(param1:int, param2:Boolean = false) : String
      {
         switch(param1)
         {
            case CATEGORY_OTHER:
               break;
            case CATEGORY_SOCIAL:
               return "0xfa8f4f7d73add8df";
            case CATEGORY_SKILL:
               return "0xbba577a0719d8b75";
            case CATEGORY_OBJECT:
               return "0xfd18523dd3af8f17";
            case CATEGORY_ART_AND_MUSIC:
               return "0x7ef8c9586d5b235f";
            case CATEGORY_FOOD_AND_DRINK:
               return "0x303a9d6bbce5dcb1";
            case CATEGORY_FUN_AND_GAMES:
               return "0x922d2d04ad55138f";
            case CATEGORY_HOBBIES:
               return "0xeb13d7a69a04ef46";
            case CATEGORY_HOME_ACTIVITIES:
               if(param2)
               {
                  return "0x747190935af07c15";
               }
               return "0xedf0aed074396447";
               break;
            case CATEGORY_KID_ACTIVITIES:
               return "0xa2012b2c79944286";
            case CATEGORY_MISCHIEF_AND_MAYHEM:
               return "0x55fc4779bef040ae";
            case CATEGORY_OUTDOOR:
               return "0x27f17e4c39a87b92";
         }
         return "0x4e6e493075d0c772";
      }
   }
}

