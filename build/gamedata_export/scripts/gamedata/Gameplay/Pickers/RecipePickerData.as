package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RecipePickerData extends OlympusObject
   {
      
      public var column_list:Array = [PickerColumn];
      
      public var row_data:Array = [RecipePickerRowData];
      
      public var skill_id:String;
      
      public var column_sort_list:Array = [uint];
      
      public var display_ingredient_check:Boolean;
      
      public var display_prepped_ingredient_check:Boolean;
      
      public var display_funds:Boolean;
      
      public var use_ingredients_text_override:LocKey;
      
      public function RecipePickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.column_sort_list);
         FixupArray(this.column_list);
         FixupArray(this.row_data);
         if("use_ingredients_text_override" in param1)
         {
            this.use_ingredients_text_override = LocKey.GetValidatedLocKey(param1.use_ingredients_text_override);
         }
      }
   }
}

