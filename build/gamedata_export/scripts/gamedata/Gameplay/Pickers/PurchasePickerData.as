package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PurchasePickerData extends OlympusObject
   {
      
      public var row_data:Array;
      
      public var object_id:String;
      
      public var inventory_object_id:String;
      
      public var show_description:Boolean;
      
      public var delivery_method:uint;
      
      public var show_cost:Boolean;
      
      public var max_selectable_in_row:Number;
      
      public var max_selectable_rows:Number;
      
      public var show_description_tooltip:Boolean;
      
      public var use_dialog_pick_response:Boolean;
      
      public var right_custom_text:LocKey;
      
      public var sub_total_text:LocKey;
      
      public var sub_total_cost:Number;
      
      public var categories:Array;
      
      public function PurchasePickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.row_data = new Array();
         ConstructArrayFromArray(this.row_data,param1.row_data,PurchasePickerRowData);
         this.object_id = param1.object_id;
         this.inventory_object_id = param1.inventory_object_id;
         this.show_description = param1.show_description;
         this.delivery_method = param1.delivery_method;
         this.show_description_tooltip = param1.show_description_tooltip;
         this.use_dialog_pick_response = param1.use_dialog_pick_response;
         this.right_custom_text = param1.right_custom_text != null ? new LocKey(param1.right_custom_text) : null;
         this.sub_total_text = param1.sub_total_text != null ? new LocKey(param1.sub_total_text) : null;
         this.sub_total_cost = param1.sub_total_cost != null ? Number(param1.sub_total_cost) : 0;
         this.show_cost = param1.show_cost;
         this.max_selectable_in_row = param1.max_selectable_in_row;
         this.max_selectable_rows = param1.max_selectable_rows;
         this.categories = new Array();
         ConstructArrayFromArray(this.categories,param1.categories,PurchasePickerCategory);
      }
   }
}

