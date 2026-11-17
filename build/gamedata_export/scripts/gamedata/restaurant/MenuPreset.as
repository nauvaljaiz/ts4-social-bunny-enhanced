package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MenuPreset extends OlympusObject
   {
      
      public static const CUSTOM_ENUM:int = 0;
      
      public var preset_enum:int;
      
      public var preset_name:LocKey = new LocKey();
      
      public var recipe_map:Array = [Course];
      
      public var show:Boolean;
      
      public function MenuPreset(param1:Object = null)
      {
         super(param1);
         FixupArray(this.recipe_map);
         this.recipe_map = Course.SortCourses(this.recipe_map);
      }
   }
}

