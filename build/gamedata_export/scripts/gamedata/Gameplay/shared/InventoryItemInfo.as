package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   
   public class InventoryItemInfo extends OlympusObject
   {
      
      public static const INVENTORY_TYPE_OBJECT:int = 0;
      
      public static const INVENTORY_TYPE_SHARED:int = 1;
      
      public var sim_id:String;
      
      public var object_id:String;
      
      public var definition_id:String;
      
      public var value:uint;
      
      public var isLocked:Boolean;
      
      public var custom_name:String;
      
      public var recipe_name:LocKey;
      
      public var catalogName:LocKey;
      
      public var sort_data:Array;
      
      public var visual_state:String;
      
      public var visual_icon_state:String;
      
      public var is_sell_disabled_from_component:Boolean;
      
      public var count:uint;
      
      public var old_object_id:String;
      
      public var is_new:Boolean;
      
      public var is_sell_disabled:Boolean;
      
      public var stack_id:String;
      
      public var inventory_type:int;
      
      public var inventory_id:String;
      
      public var sort_order:uint;
      
      public var icon_info:IconInfo;
      
      public var catalogImage:String;
      
      public var inventoryFilterTags:Array;
      
      public function InventoryItemInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this.sim_id = param1.sim_id;
         this.object_id = param1.object_id;
         this.definition_id = param1.definition_id;
         this.stack_id = param1.stack_id;
         this.inventory_id = param1.inventory_id;
         this.inventory_type = param1.inventory_type;
         this.catalogImage = param1["catalogImage"];
         this.catalogName = LocKey.GetValidatedLocKey(param1["catalogName"]);
         if("inventoryFilterTags" in param1)
         {
            this.inventoryFilterTags = param1.inventoryFilterTags;
         }
         else
         {
            this.inventoryFilterTags = new Array();
         }
         this.is_sell_disabled = param1["is_sell_disabled"];
         this.value = param1["value"];
         this.count = param1["count"];
         this.is_new = param1["is_new"];
         this.sort_order = param1["sort_order"];
         this.custom_name = param1["custom_name"];
         this.visual_state = param1["visual_state"];
         this.visual_icon_state = param1["visual_icon_state"];
         this.is_sell_disabled_from_component = param1["is_sell_disabled_from_component"];
         this.sort_data = new Array();
         if("sort_data" in param1)
         {
            ConstructArrayFromArray(this.sort_data,param1.sort_data,InventoryItemSortData);
         }
         if("recipe_name" in param1)
         {
            this.recipe_name = FixupLocKey(new LocKey(param1["recipe_name"]));
         }
         if("icon_info" in param1)
         {
            this.icon_info = new IconInfo(param1["icon_info"]);
         }
         this.old_object_id = param1["old_object_id"];
      }
      
      public function get Name() : String
      {
         if(this.custom_name)
         {
            return this.custom_name;
         }
         if(this.recipe_name)
         {
            return this.recipe_name.toString();
         }
         if(this.catalogName)
         {
            return this.catalogName.toString();
         }
         return "";
      }
      
      public function get TotalValue() : int
      {
         return this.value * this.count;
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null) : void
      {
         if(this.icon_info)
         {
            ImageUtils.LoadFromIconInfo(param1,this.icon_info,param2);
            return;
         }
         if(!ImageUtils.IsBadImage(this.catalogImage))
         {
            param1.LoadImage(this.catalogImage);
            return;
         }
         ImageUtils.LoadObjectThumbnail(param1,this.definition_id,param2);
      }
   }
}

