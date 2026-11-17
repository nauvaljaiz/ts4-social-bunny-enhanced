package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   
   public class SimOrder extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var recipe_id:String;
      
      public var locked:Boolean;
      
      public var course_tag:uint;
      
      public function SimOrder(param1:Object = null)
      {
         super(param1);
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["sim_id"] = this.sim_id;
         _loc1_["recipe_id"] = this.recipe_id;
         _loc1_["locked"] = this.locked;
         _loc1_["course_tag"] = this.course_tag;
         return _loc1_;
      }
   }
}

