package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   
   public class PickerFilterDataList extends OlympusObject
   {
      
      public var filter_data:Array;
      
      public var use_dropdown_filter:Boolean;
      
      public var sort_filter_categories:Boolean = false;
      
      public var remove_empty_filter_categories:Boolean = false;
      
      public var add_all_category:Boolean = true;
      
      public var use_sim_inventory_filter_categories:Boolean = false;
      
      public function PickerFilterDataList(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.use_dropdown_filter = param1.use_dropdown_filter;
         if("sort_filter_categories" in param1)
         {
            this.sort_filter_categories = param1.sort_filter_categories;
         }
         if("remove_empty_filter_categories" in param1)
         {
            this.remove_empty_filter_categories = param1.remove_empty_filter_categories;
         }
         if("add_all_category" in param1)
         {
            this.add_all_category = param1.add_all_category;
         }
         if("use_sim_inventory_filter_categories" in param1)
         {
            this.use_sim_inventory_filter_categories = param1.use_sim_inventory_filter_categories;
         }
         this.filter_data = new Array();
         if("filter_data" in param1)
         {
            ConstructArrayFromArray(this.filter_data,param1.filter_data,PickerFilterData);
         }
      }
   }
}

