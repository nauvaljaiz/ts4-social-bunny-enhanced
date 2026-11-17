package gamedata.restaurant
{
   import gamedata.shared.DefinitionGeoPair;
   import gamedata.shared.RecipeItemTuning;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.utils.ImageUtils;
   
   public class RestaurantRecipeItem extends OlympusObject
   {
      
      public static const RECIPE_ITEM_TYPE_NORMAL:int = 0;
      
      public static const RECIPE_ITEM_TYPE_SPECIAL:int = 1;
      
      public var recipe_id:String;
      
      public var item_type:int;
      
      public var price_override:int = -1;
      
      protected var mRecipeTuning:RecipeItemTuning;
      
      public function RestaurantRecipeItem(param1:Object = null)
      {
         if(param1 is RecipeItemTuning)
         {
            this.mRecipeTuning = param1 as RecipeItemTuning;
            this.recipe_id = this.mRecipeTuning.recipe_id;
         }
         else
         {
            this.mRecipeTuning = RecipeItemTuning.GetStaticData(param1.recipe_id);
            super(param1);
         }
      }
      
      public function get HasValidRecipeTuning() : Boolean
      {
         return this.mRecipeTuning != null;
      }
      
      public function get Tags() : Array
      {
         return this.mRecipeTuning.recipe_tags;
      }
      
      public function get Name() : LocKey
      {
         return this.mRecipeTuning.name;
      }
      
      public function get Description() : LocKey
      {
         return this.mRecipeTuning.recipe_description;
      }
      
      public function get IconURL() : String
      {
         var _loc1_:String = this.mRecipeTuning.icon_override.instance;
         if(Boolean(_loc1_) && _loc1_ != "0")
         {
            return ImageUtils.CreateResourceImageUrl(_loc1_);
         }
         var _loc2_:IconInfo = new IconInfo();
         var _loc3_:DefinitionGeoPair = new DefinitionGeoPair();
         _loc3_.definition_id = this.mRecipeTuning.final_product_definition.toString();
         _loc3_.geo_state_hash = this.mRecipeTuning.thumbnail_geo_state;
         _loc3_.material_hash = this.mRecipeTuning.thumbnail_material_state;
         _loc2_.icon_object_def = _loc3_;
         return ImageUtils.CreateIconInfoImageUrl(_loc2_,ImageUtils.THUMBNAIL_SIZE_FOOD,false);
      }
      
      public function get Price() : int
      {
         if(this.price_override >= 0)
         {
            return this.price_override;
         }
         return this.mRecipeTuning.restaurant_base_price * this.mRecipeTuning.multiplier;
      }
      
      public function get Difficulty() : uint
      {
         return this.mRecipeTuning.recipe_difficulty;
      }
      
      public function HasTag(param1:uint) : Boolean
      {
         return this.mRecipeTuning.recipe_tags.indexOf(param1) >= 0;
      }
   }
}

