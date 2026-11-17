package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class Course extends OlympusObject
   {
      
      public static var sCourseSorting:Array;
      
      public var course_tag:uint;
      
      public var course_name:LocKey = new LocKey();
      
      public var items:Array = [RestaurantRecipeItem];
      
      public var recipes:Array = [String];
      
      public function Course(param1:Object = null)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RestaurantRecipeItem = null;
         super(param1);
         if(Boolean(param1) && "recipes" in param1)
         {
            _loc2_ = int(this.recipes.length);
            this.items = new Array(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new RestaurantRecipeItem({"recipe_id":this.recipes[_loc3_]});
               this.items[_loc3_] = _loc4_;
               _loc3_++;
            }
         }
         else
         {
            this.recipes = null;
         }
         FixupArray(this.items);
         FixupArray(this.recipes);
         this.RemoveInvalidItems();
      }
      
      public static function SortCourses(param1:Array) : Array
      {
         var _loc6_:uint = 0;
         var _loc7_:Course = null;
         if(!sCourseSorting)
         {
            sCourseSorting = CommunicationManager.CallGameService("GetMenuCourseDisplayOrder") as Array;
         }
         var _loc2_:Array = sCourseSorting;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:Array = new Array(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = uint(_loc2_[_loc5_]);
            for each(_loc7_ in param1)
            {
               if(_loc7_.course_tag == _loc6_)
               {
                  _loc4_[_loc5_] = _loc7_;
                  break;
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function Clone() : Course
      {
         var _loc1_:Course = new Course();
         _loc1_.course_name = this.course_name;
         _loc1_.course_tag = this.course_tag;
         _loc1_.items = this.items.concat();
         return _loc1_;
      }
      
      protected function RemoveInvalidItems() : void
      {
         var _loc4_:RestaurantRecipeItem = null;
         var _loc1_:Array = this.items;
         var _loc2_:* = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_] as RestaurantRecipeItem;
            if(!_loc4_.HasValidRecipeTuning)
            {
               _loc1_.splice(_loc3_,1);
               _loc2_--;
            }
            else
            {
               _loc3_++;
            }
         }
      }
   }
}

