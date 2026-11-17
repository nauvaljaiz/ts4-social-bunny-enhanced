package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   
   public class FoodPickerData extends OlympusObject
   {
      
      public var course_tag:int;
      
      public var selected_recipe_ids:Array = [String];
      
      public function FoodPickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.selected_recipe_ids);
      }
   }
}

