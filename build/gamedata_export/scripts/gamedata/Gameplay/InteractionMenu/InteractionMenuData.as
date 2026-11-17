package gamedata.Gameplay.InteractionMenu
{
   import flash.geom.Vector3D;
   import gamedata.Gameplay.InteractionMenu.definitions.InteractionCategoryInfo;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class InteractionMenuData extends OlympusObject
   {
      
      public var sim:String;
      
      public var client_reference_id:uint;
      
      public var server_reference_id:uint;
      
      public var supress_social_front_page:Boolean;
      
      public var items:Array;
      
      public var category_tokens:Array;
      
      public var disabled_tooltip:LocKey;
      
      public var selected_affordance_id:String;
      
      public var worldPos:Vector3D = new Vector3D();
      
      public function InteractionMenuData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GenerateTree(param1:InteractionMenuData, param2:uint, param3:Boolean = false, param4:String = "", param5:Boolean = true) : InteractionCategory
      {
         var _loc7_:InteractionCategory = null;
         var _loc6_:Object = new Object();
         var _loc8_:InteractionCategoryInfo = new InteractionCategoryInfo();
         var _loc9_:InteractionCategory = new InteractionCategory(_loc8_);
         var _loc10_:Array = param1.items;
         _loc6_[_loc9_.CategoryInfo.key] = _loc9_;
         PopulateMap(_loc6_,_loc10_);
         if(param3 && param4 != param1.sim && _loc9_.items.length > 0 && param5)
         {
            ProcessSocialFrontPage(_loc9_,_loc10_,param2 - 1);
         }
         PostProcessCategory(_loc9_,param2,_loc9_,_loc9_.CategoryInfo.key);
         _loc9_.DetermineDisabledText();
         for each(_loc7_ in _loc6_)
         {
            ProcessCategoryTextTokens(_loc7_,param1.category_tokens);
         }
         return _loc9_;
      }
      
      protected static function PopulateMap(param1:Object, param2:Array) : void
      {
         var _loc3_:InteractionCategory = null;
         var _loc4_:InteractionMenuItem = null;
         for each(_loc4_ in param2)
         {
            _loc3_ = FetchCategory(param1,_loc4_.category_key);
            _loc3_.AddItem(_loc4_);
         }
      }
      
      protected static function PostProcessCategory(param1:InteractionCategory, param2:uint, param3:InteractionCategory, param4:String) : void
      {
         var _loc7_:Object = null;
         var _loc8_:InteractionMenuItem = null;
         var _loc9_:InteractionCategory = null;
         var _loc10_:InteractionCategory = null;
         var _loc11_:InteractionCategory = null;
         var _loc12_:InteractionMenuItem = null;
         if(!param1.IsMoreChoicesCategory())
         {
            param1.items.sort(OptionsSortingFunction);
         }
         CheckOverflow(param1,param2,param3,param4);
         var _loc5_:int = int(param1.items.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1.items[_loc6_];
            _loc8_ = _loc7_ as InteractionMenuItem;
            if(_loc8_ == null)
            {
               _loc9_ = _loc7_ as InteractionCategory;
               while(Boolean(_loc9_) && Boolean(_loc9_.items.length == 1) && _loc9_.CategoryInfo.collapsible)
               {
                  _loc11_ = _loc9_.items[0] as InteractionCategory;
                  if(_loc11_)
                  {
                     _loc11_.CategoryInfo.display_priority = _loc9_.CategoryInfo.display_priority;
                  }
                  else
                  {
                     _loc12_ = _loc9_.items[0] as InteractionMenuItem;
                     _loc12_.pie_menu_priority = _loc9_.CategoryInfo.display_priority;
                  }
                  param1.items[_loc6_] = _loc9_.items[0];
                  _loc9_ = param1.items[_loc6_] as InteractionCategory;
               }
               _loc10_ = param1.items[_loc6_] as InteractionCategory;
               if(_loc10_)
               {
                  if(_loc10_.IsMoreChoicesCategory())
                  {
                     if(!_loc10_.LoopCategory)
                     {
                        PostProcessCategory(_loc10_,param2,param3,param4);
                     }
                  }
                  else
                  {
                     PostProcessCategory(_loc10_,param2,_loc10_,param4);
                  }
               }
            }
            _loc6_++;
         }
      }
      
      protected static function FetchCategory(param1:Object, param2:String) : InteractionCategory
      {
         var _loc4_:InteractionCategory = null;
         var _loc5_:InteractionCategory = null;
         var _loc3_:String = param2;
         while(true)
         {
            _loc5_ = param1[param2];
            if(_loc5_ != null)
            {
               break;
            }
            _loc5_ = InteractionCategory.Create(param2);
            param1[param2] = _loc5_;
            if(_loc4_)
            {
               _loc5_.AddItem(_loc4_);
            }
            _loc4_ = _loc5_;
            param2 = _loc5_.CategoryInfo.parent_key;
         }
         if(_loc4_)
         {
            _loc5_.AddItem(_loc4_);
         }
         return param1[_loc3_];
      }
      
      protected static function CheckOverflow(param1:InteractionCategory, param2:uint, param3:InteractionCategory, param4:String) : void
      {
         var _loc5_:uint = 0;
         var _loc8_:Array = null;
         var _loc10_:InteractionCategory = null;
         var _loc12_:InteractionCategory = null;
         _loc5_ = param2;
         var _loc6_:uint = _loc5_ - 1;
         var _loc7_:uint = param1.items.length;
         var _loc9_:InteractionCategoryInfo = InteractionCategoryInfo.GetMore();
         var _loc11_:InteractionCategory = param1;
         while(_loc7_ > _loc5_)
         {
            _loc8_ = _loc11_.items.splice(_loc6_,_loc7_ - _loc6_);
            _loc10_ = new InteractionCategory(_loc9_);
            _loc10_.items = _loc8_;
            if(param3.CategoryInfo.key != param4)
            {
               _loc10_.RootCategory = param3;
            }
            _loc11_.AddItemToFront(_loc10_);
            _loc11_ = _loc10_;
            _loc7_ -= _loc6_;
         }
         if(!_loc11_.IsMoreChoicesCategory() || _loc11_ == param1)
         {
            return;
         }
         if(_loc7_ == _loc5_)
         {
            _loc8_ = _loc11_.items.splice(_loc6_,1);
            _loc10_ = new InteractionCategory(_loc9_);
            _loc10_.items = _loc8_;
            if(param3.CategoryInfo.key != param4)
            {
               _loc10_.RootCategory = param3;
            }
            _loc11_.AddItemToFront(_loc10_);
            _loc12_ = new InteractionCategory(_loc9_);
            _loc12_.items = param3.items;
            _loc12_.LoopCategory = param3;
            _loc10_.AddItemToFront(_loc12_);
         }
         else
         {
            _loc10_ = new InteractionCategory(_loc9_);
            _loc10_.items = param3.items;
            _loc10_.LoopCategory = param3;
            _loc11_.AddItemToFront(_loc10_);
         }
      }
      
      protected static function ProcessCategoryTextTokens(param1:InteractionCategory, param2:Array) : void
      {
         var _loc3_:LocKey = param1.displayText;
         _loc3_["tokens"] = param2;
         param1.displayText = _loc3_;
      }
      
      protected static function ProcessSocialFrontPage(param1:InteractionCategory, param2:Array, param3:int) : void
      {
         var _loc7_:InteractionCategoryInfo = null;
         var _loc8_:InteractionCategory = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:Array = new Array(param3 + 1);
         var _loc5_:Array = param1.items;
         var _loc6_:* = 0;
         _loc6_ = ParseOptionItems(_loc5_,_loc4_,_loc6_);
         param2.sort(ScoreSortingFunction);
         _loc6_ = FillFrontPage(_loc4_,_loc6_,param3,param2);
         if(_loc5_.length > 0)
         {
            _loc7_ = InteractionCategoryInfo.GetMore();
            _loc8_ = new InteractionCategory(_loc7_);
            _loc8_.items = _loc5_;
            var _loc9_:Number;
            _loc4_[_loc9_ = _loc6_++] = _loc8_;
         }
         _loc4_.length = _loc6_;
         param1.items = _loc4_;
      }
      
      protected static function ParseOptionItems(param1:Array, param2:Array, param3:int) : int
      {
         var _loc6_:InteractionMenuItem = null;
         var _loc4_:* = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_] as InteractionMenuItem;
            if(_loc6_)
            {
               var _loc7_:Number;
               param2[_loc7_ = param3++] = _loc6_;
               param1.splice(_loc5_,1);
               _loc4_--;
            }
            else
            {
               _loc5_++;
            }
         }
         return param3;
      }
      
      protected static function GetTotalScore(param1:Array) : Number
      {
         var _loc3_:InteractionMenuItem = null;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1)
         {
            if(Boolean(_loc3_.category_key) && _loc3_.score > 0)
            {
               _loc2_ += _loc3_.score;
            }
         }
         return _loc2_;
      }
      
      protected static function FillFrontPage(param1:Array, param2:int, param3:int, param4:Array) : int
      {
         var _loc6_:Number = NaN;
         var _loc8_:InteractionMenuItem = null;
         var _loc9_:InteractionMenuItem = null;
         var _loc5_:Array = CullItems(param4);
         _loc6_ = GetTotalScore(_loc5_);
         var _loc7_:Number = _loc6_ == 0 ? 1 : 100 / _loc6_;
         for each(_loc8_ in param4)
         {
            _loc8_.mNormalizedScore = _loc8_.score * _loc7_;
         }
         while(_loc5_.length > 0 && param2 < param3)
         {
            _loc9_ = GetOptionInSelection(_loc5_,_loc6_);
            var _loc10_:Number;
            param1[_loc10_ = param2++] = _loc9_;
            _loc6_ -= _loc9_.score;
         }
         return param2;
      }
      
      protected static function CullItems(param1:Array) : Array
      {
         var _loc3_:InteractionMenuItem = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(Boolean(_loc3_.category_key) && _loc3_.score > 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      protected static function GetOptionInSelection(param1:Array, param2:Number) : InteractionMenuItem
      {
         var _loc6_:InteractionMenuItem = null;
         var _loc8_:int = 0;
         var _loc9_:InteractionMenuItem = null;
         var _loc10_:Number = NaN;
         var _loc3_:Number = Math.random();
         var _loc4_:int = int(param1.length);
         if(param2 == 0)
         {
            _loc8_ = _loc3_ * _loc4_ as int;
            _loc9_ = param1[_loc8_];
            param1.splice(_loc8_,1);
            return _loc9_;
         }
         var _loc5_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc6_ = param1[_loc7_] as InteractionMenuItem;
            _loc10_ = _loc6_.score / param2;
            _loc5_ += _loc10_;
            if(_loc3_ < _loc5_)
            {
               param1.splice(_loc7_,1);
               return _loc6_;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function OptionsSortingFunction(param1:Object, param2:Object) : int
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:InteractionMenuItem = null;
         var _loc3_:InteractionCategory = param1 as InteractionCategory;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(_loc3_)
         {
            if(_loc3_.IsMoreChoicesCategory())
            {
               return -1;
            }
            _loc6_ = _loc3_.displayText.toString();
            _loc4_ = uint(_loc3_.CategoryInfo.display_priority);
         }
         else
         {
            _loc8_ = param1 as InteractionMenuItem;
            _loc6_ = _loc8_.loc_string.toString();
            _loc4_ = _loc8_.pie_menu_priority;
         }
         _loc3_ = param2 as InteractionCategory;
         if(_loc3_)
         {
            if(_loc3_.IsMoreChoicesCategory())
            {
               return 1;
            }
            _loc7_ = _loc3_.displayText.toString();
            _loc5_ = uint(_loc3_.CategoryInfo.display_priority);
         }
         else
         {
            _loc8_ = param2 as InteractionMenuItem;
            _loc7_ = _loc8_.loc_string.toString();
            _loc5_ = _loc8_.pie_menu_priority;
         }
         if(_loc4_ == _loc5_)
         {
            return _loc6_.localeCompare(_loc7_);
         }
         return _loc5_ - _loc4_;
      }
      
      protected static function ScoreSortingFunction(param1:Object, param2:Object) : Number
      {
         var _loc3_:InteractionMenuItem = param1 as InteractionMenuItem;
         var _loc4_:InteractionMenuItem = param2 as InteractionMenuItem;
         return _loc3_.score - _loc4_.score;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim = param1.sim;
         this.client_reference_id = param1.client_reference_id;
         this.server_reference_id = param1.server_reference_id;
         this.supress_social_front_page = param1.supress_social_front_page;
         this.items = new Array();
         if("items" in param1)
         {
            ConstructArrayFromArray(this.items,param1.items,InteractionMenuItem);
         }
         if("category_tokens" in param1)
         {
            this.category_tokens = param1.category_tokens;
         }
         if("disabled_tooltip" in param1)
         {
            this.disabled_tooltip = new LocKey(param1.disabled_tooltip);
         }
         if("selected_affordance_id" in param1)
         {
            this.selected_affordance_id = param1.selected_affordance_id;
         }
      }
   }
}

