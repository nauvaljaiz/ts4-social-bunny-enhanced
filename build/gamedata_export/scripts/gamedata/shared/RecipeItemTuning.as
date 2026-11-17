package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RecipeItemTuning extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      public var available_in_restaurant:Boolean;
      
      public var final_product_definition:uint;
      
      public var icon_override:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var recipe_tags:Array = [uint];
      
      public var recipe_id:String;
      
      public var price:int;
      
      public var thumbnail_geo_state:uint;
      
      public var thumbnail_material_state:uint;
      
      public var restaurant_base_price:int;
      
      public var recipe_difficulty:uint;
      
      public var recipe_description:LocKey = new LocKey();
      
      public var multiplier:Number = 1;
      
      public function RecipeItemTuning(param1:Object = null)
      {
         super(param1);
         FixupArray(this.recipe_tags);
      }
      
      public static function GetStaticData(param1:String) : RecipeItemTuning
      {
         var _loc2_:Object = sGetStaticDataFunc(param1);
         if(!_loc2_)
         {
            return null;
         }
         return new RecipeItemTuning(_loc2_);
      }
      
      public function HasTag(param1:uint) : Boolean
      {
         return this.recipe_tags.indexOf(param1) >= 0;
      }
   }
}

