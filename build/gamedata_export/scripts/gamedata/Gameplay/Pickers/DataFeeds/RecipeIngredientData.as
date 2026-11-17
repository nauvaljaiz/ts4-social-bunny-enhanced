package gamedata.Gameplay.Pickers.DataFeeds
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RecipeIngredientData extends OlympusObject
   {
      
      public var ingredient_name:LocKey = new LocKey();
      
      public var in_inventory:Boolean = false;
      
      public function RecipeIngredientData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("ingredient_name" in param1) || !param1.ingredient_name)
         {
            this.ingredient_name = null;
         }
      }
   }
}

