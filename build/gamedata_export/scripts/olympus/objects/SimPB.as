package olympus.objects
{
   import gamedata.Gameplay.shared.MoodUpdate;
   import olympus.core.OlympusObject;
   
   public class SimPB extends OlympusObject
   {
      
      public static const VISUAL_TYPE_NORMAL:uint = 0;
      
      public static const VISUAL_TYPE_OTHER:uint = 1;
      
      public static const VISUAL_TYPE_BABY:uint = 2;
      
      public static const VISUAL_TYPE_AT_WORK:uint = 3;
      
      public static const VISUAL_TYPE_LATE_FOR_WORK:uint = 4;
      
      public static const VISUAL_TYPE_MISSING_ACTIVE_WORK:uint = 5;
      
      public static const VISUAL_TYPE_AT_DAYCARE:uint = 6;
      
      public static const VISUAL_TYPE_PET_MISSING:uint = 7;
      
      public static const ZONE_VISUAL_TYPE_OFF_LOT:uint = 8;
      
      public static const ALERT_TYPE_NONE:uint = 0;
      
      public static const ALERT_TYPE_PET_DISTRESS:uint = 1;
      
      public var id:String;
      
      public var instance_info:GameInstanceInfoPB = new GameInstanceInfoPB();
      
      public var firstname:String;
      
      public var lastname:String;
      
      public var at_work:Boolean;
      
      public var is_selectable:Boolean = true;
      
      public var selector_visual_type:uint;
      
      public var career_category:String;
      
      public var can_care_for_toddler_at_home:Boolean;
      
      public var isPregnant:Boolean;
      
      public var species:uint;
      
      public var alertType:uint;
      
      public var mood:MoodUpdate = new MoodUpdate();
      
      public function SimPB(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.id = param1.id;
         this.instance_info.ParseObject(param1.instance_info);
         this.firstname = param1.firstname;
         this.lastname = param1.lastname;
         this.at_work = param1.at_work;
         this.is_selectable = param1.is_selectable;
         this.selector_visual_type = param1.selector_visual_type;
         this.career_category = param1.career_category;
         this.can_care_for_toddler_at_home = param1.can_care_for_toddler_at_home;
         this.isPregnant = param1.isPregnant;
         this.species = param1.species;
         this.alertType = param1.alertType;
         this.mood.ParseObject(param1.mood);
      }
      
      public function get InZone() : Boolean
      {
         return !this.instance_info.zone_id;
      }
      
      public function get IsBaby() : Boolean
      {
         return this.selector_visual_type == VISUAL_TYPE_BABY;
      }
      
      public function get IsSimAvailable() : Boolean
      {
         return this.InZone && !this.at_work && this.selector_visual_type != VISUAL_TYPE_OTHER && this.selector_visual_type != VISUAL_TYPE_AT_DAYCARE;
      }
   }
}

