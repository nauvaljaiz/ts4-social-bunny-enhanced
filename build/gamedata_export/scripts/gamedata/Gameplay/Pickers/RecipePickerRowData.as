package gamedata.Gameplay.Pickers
{
   import gamedata.Gameplay.Pickers.DataFeeds.RecipeBucksCostData;
   import gamedata.Gameplay.Pickers.DataFeeds.RecipeGroupOverrideData;
   import gamedata.Gameplay.Pickers.DataFeeds.RecipeIngredientData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class RecipePickerRowData extends OlympusObject implements IComparableRow
   {
      
      public var base_data:PickerBaseRowData = new PickerBaseRowData();
      
      public var price:uint;
      
      public var skill_level:uint;
      
      public var linked_option_ids:Array = [uint];
      
      public var event_icon:ResourceKey = new ResourceKey();
      
      public var visible_as_subrow:Boolean = true;
      
      public var ingredients:Array = [RecipeIngredientData];
      
      public var only_prepped_ingredients:Array = [RecipeIngredientData];
      
      public var both_fresh_prepped_ingredients:Array = [RecipeIngredientData];
      
      public var price_with_ingredients:uint;
      
      public var price_with_only_prepped_ingredients:uint;
      
      public var price_with_both_fresh_prepped_ingredients:uint;
      
      public var mtx_id:String;
      
      public var serving_display_name:LocKey = new LocKey();
      
      public var discounted_price:uint;
      
      public var is_discounted:Boolean;
      
      public var show_full_subrows:Boolean = false;
      
      public var bucks_costs:Array = [RecipeBucksCostData];
      
      public var subrow_sort_id:int;
      
      public var locked_in_cas_icon_info:IconInfo = new IconInfo();
      
      public var group_override:RecipeGroupOverrideData = new RecipeGroupOverrideData();
      
      public var ingredients_list:LocKey = new LocKey();
      
      public var only_prepped_ingredients_list:LocKey = new LocKey();
      
      public var both_fresh_prepped_ingredients_list:LocKey = new LocKey();
      
      public var enable_speed_up_background:Boolean = false;
      
      public var cooking_time_reduced:Boolean = false;
      
      public var food_restriction_ingredients:Array = [String];
      
      public var recipe_id:int;
      
      public var buff_id:* = uint;
      
      public var mLinkedPickerRowData:Vector.<RecipePickerRowData> = new Vector.<RecipePickerRowData>();
      
      public var mLinkedRowIdPickerId:int = -1;
      
      public var mbUsingIngredients:Boolean = false;
      
      public var mbUsingPreppedIngredients:Boolean = false;
      
      public var mIsNewEntitlement:Boolean = false;
      
      public function RecipePickerRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("serving_display_name" in param1))
         {
            this.serving_display_name = null;
         }
         if(!("group_override" in param1))
         {
            this.group_override = null;
         }
         FixupArray(this.linked_option_ids);
         FixupArray(this.ingredients);
         FixupArray(this.only_prepped_ingredients);
         FixupArray(this.both_fresh_prepped_ingredients);
         FixupArray(this.bucks_costs);
         FixupArray(this.food_restriction_ingredients);
      }
      
      public function SetUsingIngredients(param1:Boolean, param2:Boolean) : void
      {
         this.mbUsingIngredients = param1;
         this.mbUsingPreppedIngredients = param2;
      }
      
      public function get name() : String
      {
         return this.base_data.name.toString();
      }
      
      public function get icon() : String
      {
         return this.base_data.icon ? this.base_data.icon.instance : null;
      }
      
      public function get option_id() : uint
      {
         return this.base_data.option_id;
      }
      
      public function get is_enable() : Boolean
      {
         if(this.mbUsingIngredients && this.mbUsingPreppedIngredients)
         {
            return this.base_data.is_enable_both_fresh_prepped;
         }
         if(this.mbUsingPreppedIngredients)
         {
            return this.base_data.is_enable_prepped;
         }
         if(this.mbUsingIngredients)
         {
            return this.base_data.is_enable_fresh;
         }
         return this.base_data.is_enable;
      }
      
      public function get description() : String
      {
         return this.base_data.description ? this.base_data.description.toString() : null;
      }
      
      public function get ServingName() : String
      {
         return this.serving_display_name ? this.serving_display_name.toString() : this.name;
      }
      
      public function CanCompareColumn(param1:PickerColumn) : Boolean
      {
         return param1.column_data_name == "locked_in_cas_icon_info";
      }
      
      public function CompareColumn(param1:PickerColumn, param2:IComparableRow) : Number
      {
         var _loc3_:RecipePickerRowData = param2 as RecipePickerRowData;
         var _loc4_:Number = param1.mSortType == PickerColumn.SORT_TYPE_DESCENDING ? 1 : -1;
         if(Boolean(param1.column_data_name == "locked_in_cas_icon_info") && Boolean(this.locked_in_cas_icon_info.icon) && Boolean(_loc3_.locked_in_cas_icon_info.icon))
         {
            return _loc4_ * this.locked_in_cas_icon_info.icon.instance.localeCompare(_loc3_.locked_in_cas_icon_info.icon.instance);
         }
         return 0;
      }
      
      public function HasEnabledLinkedRecipe() : Boolean
      {
         var _loc1_:RecipePickerRowData = null;
         for each(_loc1_ in this.mLinkedPickerRowData)
         {
            if(_loc1_.is_enable)
            {
               return true;
            }
         }
         return false;
      }
      
      public function AreLinkedRecipesSamePrice() : Boolean
      {
         var _loc1_:RecipePickerRowData = null;
         for each(_loc1_ in this.mLinkedPickerRowData)
         {
            if(_loc1_.price != this.price)
            {
               return false;
            }
         }
         return true;
      }
      
      public function GetDiscountedPrice() : uint
      {
         if(this.mbUsingIngredients && this.mbUsingPreppedIngredients)
         {
            return this.price_with_both_fresh_prepped_ingredients;
         }
         if(this.mbUsingIngredients)
         {
            return this.price_with_ingredients;
         }
         if(this.mbUsingPreppedIngredients)
         {
            return this.price_with_only_prepped_ingredients;
         }
         if(this.is_discounted)
         {
            return this.discounted_price;
         }
         return this.price;
      }
      
      public function GetPriceWithIngredients() : uint
      {
         if(this.mbUsingIngredients && this.mbUsingPreppedIngredients)
         {
            return this.price_with_both_fresh_prepped_ingredients;
         }
         if(this.mbUsingIngredients)
         {
            return this.price_with_ingredients;
         }
         if(this.mbUsingPreppedIngredients)
         {
            return this.price_with_only_prepped_ingredients;
         }
         return this.price;
      }
      
      public function HasLinkedIngredientsListString() : Boolean
      {
         var _loc2_:RecipePickerRowData = null;
         var _loc1_:Vector.<RecipePickerRowData> = this.mLinkedPickerRowData;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.ingredients_list.IsValid())
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetTooltipTextForExpandableButton(param1:String) : String
      {
         var _loc4_:RecipePickerRowData = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         if(this.mLinkedPickerRowData.length == 0)
         {
            return "";
         }
         var _loc2_:Vector.<RecipePickerRowData> = this.mLinkedPickerRowData;
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            _loc7_ = null;
            if(this.mbUsingIngredients && this.mbUsingPreppedIngredients)
            {
               _loc7_ = _loc4_.both_fresh_prepped_ingredients_list.toString();
            }
            else if(this.mbUsingIngredients)
            {
               _loc7_ = _loc4_.ingredients_list.toString();
            }
            else if(this.mbUsingPreppedIngredients)
            {
               _loc7_ = _loc4_.only_prepped_ingredients_list.toString();
            }
            if(!(_loc7_ == null || _loc7_.length == 0))
            {
               _loc8_ = false;
               for each(_loc9_ in _loc3_)
               {
                  if(_loc9_.toString() == _loc7_)
                  {
                     _loc8_ = true;
                     break;
                  }
               }
               if(!_loc8_)
               {
                  _loc3_.push(_loc7_);
               }
            }
         }
         if(_loc3_.length == 0)
         {
            return "";
         }
         var _loc5_:String = "";
         for each(_loc6_ in _loc3_)
         {
            _loc10_ = KeysGP.RECIPE_TOOLTIP_BULLET_POINT.toString(_loc6_);
            _loc5_ = _loc5_.length == 0 ? _loc10_ : Keys.GENERIC_NEWLINE.toString(_loc5_,_loc10_);
         }
         return Keys.GENERIC_NEWLINE.toString(param1,KeysGP.RECIPE_TOOLTIP_REQUIRED_INGREDIENTS.toString(_loc5_));
      }
   }
}

