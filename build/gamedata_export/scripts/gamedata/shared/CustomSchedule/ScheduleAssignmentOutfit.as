package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class ScheduleAssignmentOutfit extends OlympusObject
   {
      
      public static const NO_OUTFIT:uint = 0;
      
      public static const CATEGORY:uint = 1;
      
      public static const STYLE_COLOR:uint = 2;
      
      public static const OUTFIT_OVERRIDE:uint = 3;
      
      public var outfit_setting:uint;
      
      public var outfit_color:uint;
      
      public var outfit_style:uint;
      
      public var outfit_category:uint;
      
      public var assignment_uniform_adult_male:Object;
      
      public var assignment_uniform_adult_female:Object;
      
      public var assignment_uniform_child_male:Object;
      
      public var assignment_uniform_child_female:Object;
      
      public var style_enabled:Boolean;
      
      public var color_enabled:Boolean;
      
      public function ScheduleAssignmentOutfit(param1:Object = null)
      {
         super(param1);
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["outfit_setting"] = this.outfit_setting;
         switch(this.outfit_setting)
         {
            case CATEGORY:
               _loc1_["outfit_category"] = this.outfit_category;
               break;
            case STYLE_COLOR:
               _loc1_["outfit_color"] = this.outfit_color;
               _loc1_["outfit_style"] = this.outfit_style;
               _loc1_["style_enabled"] = this.style_enabled;
               _loc1_["color_enabled"] = this.color_enabled;
               break;
            case OUTFIT_OVERRIDE:
               if(this.assignment_uniform_adult_male)
               {
                  _loc1_["assignment_uniform_adult_male"] = this.assignment_uniform_adult_male;
               }
               if(this.assignment_uniform_adult_female)
               {
                  _loc1_["assignment_uniform_adult_female"] = this.assignment_uniform_adult_female;
               }
               if(this.assignment_uniform_child_male)
               {
                  _loc1_["assignment_uniform_child_male"] = this.assignment_uniform_child_male;
               }
               if(this.assignment_uniform_child_female)
               {
                  _loc1_["assignment_uniform_child_female"] = this.assignment_uniform_child_female;
               }
         }
         return _loc1_;
      }
      
      public function Equals(param1:ScheduleAssignmentOutfit) : Boolean
      {
         if(this.outfit_setting != param1.outfit_setting)
         {
            return false;
         }
         switch(this.outfit_setting)
         {
            case CATEGORY:
               if(this.outfit_category != param1.outfit_category)
               {
                  return false;
               }
               break;
            case STYLE_COLOR:
               if(this.outfit_color != param1.outfit_color)
               {
                  return false;
               }
               if(this.outfit_style != param1.outfit_style)
               {
                  return false;
               }
               if(this.style_enabled != param1.style_enabled)
               {
                  return false;
               }
               if(this.color_enabled != param1.color_enabled)
               {
                  return false;
               }
               break;
            case OUTFIT_OVERRIDE:
               if(this.assignment_uniform_adult_male != param1.assignment_uniform_adult_male)
               {
                  return false;
               }
               if(this.assignment_uniform_adult_female != param1.assignment_uniform_adult_female)
               {
                  return false;
               }
               if(this.assignment_uniform_child_male != param1.assignment_uniform_child_male)
               {
                  return false;
               }
               if(this.assignment_uniform_child_female != param1.assignment_uniform_child_female)
               {
                  return false;
               }
         }
         return true;
      }
   }
}

