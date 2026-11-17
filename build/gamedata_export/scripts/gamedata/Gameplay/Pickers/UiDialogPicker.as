package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogPicker extends OlympusObject
   {
      
      public static const OBJECTPICKERTYPE_RECIPE:int = 1;
      
      public static const OBJECTPICKERTYPE_INTERACTION:int = 2;
      
      public static const OBJECTPICKERTYPE_SIM:int = 3;
      
      public static const OBJECTPICKERTYPE_OBJECT:int = 4;
      
      public static const OBJECTPICKERTYPE_PIE_MENU:int = 5;
      
      public static const OBJECTPICKERTYPE_CAREER:int = 6;
      
      public static const OBJECTPICKERTYPE_OUTFIT:int = 7;
      
      public static const OBJECTPICKERTYPE_PURCHASE:int = 8;
      
      public static const OBJECTPICKERTYPE_LOT:int = 9;
      
      public static const OBJECTPICKERTYPE_SIM_CLUB:int = 10;
      
      public static const OBJECTPICKERTYPE_ITEM:int = 11;
      
      public static const OBJECTPICKERTYPE_OBJECT_LARGE:int = 12;
      
      public static const OBJECTPICKERTYPE_DROPDOWN:int = 13;
      
      public static const OBJECTPICKERTYPE_OBJECT_SQUARE:int = 14;
      
      public static const OBJECTPICKERTYPE_ODD_JOBS:int = 15;
      
      public static const OBJECTPICKERTYPE_MISSIONS:int = 16;
      
      public static const OBJECTPICKERTYPE_LARGE_TEXT_FLAIR:int = 17;
      
      public static const OBJECTPICKERTYPE_SELL:int = 18;
      
      public static const OBJECTPICKERTYPE_QUESTS:int = 19;
      
      public static const OBJECTPICKERTYPE_PHOTO:int = 20;
      
      public static const OBJECTPICKERTYPE_OBJECT_TEXT:int = 21;
      
      public static const OBJECTPICKERTYPE_OBJECT_TEXT_ADD:int = 22;
      
      public static const OBJECTPICKERTYPE_FASHION_PURCHASE:int = 23;
      
      public static const OBJECTPICKERTYPE_RELATIONSHIP:int = 24;
      
      public static const OBJECTPICKERTYPE_OBJECT_EXPANDED_INFO:int = 25;
      
      public static const OBJECTPICKERTYPE_OBJECT_CAS_ICON:int = 26;
      
      public static const OBJECTPICKERTYPE_OBJECT_ICON_TITLE:int = 27;
      
      public static const OBJECTPICKERTYPE_SATISFACTION_REWARDS:int = int.MAX_VALUE - 1;
      
      public static const OBJECTPICKERTYPE_SIM_SITUATION:int = int.MAX_VALUE - 2;
      
      public static const OBJECTPICKERTYPE_SIM_TRAVEL:int = int.MAX_VALUE - 3;
      
      public static const OBJECTPICKERTYPE_SIM_TRAVEL_LIVE:int = int.MAX_VALUE - 4;
      
      public static const OBJECTPICKERTYPE_RETAIL_PERKS:int = int.MAX_VALUE - 5;
      
      public static const OBJECTPICKERTYPE_FOOD:int = int.MAX_VALUE - 6;
      
      public static const OBJECTPICKERTYPE_EDIT_OUTFIT:int = int.MAX_VALUE - 7;
      
      public static const OBJECTPICKERTYPE_RESTAURANT_PERKS:int = int.MAX_VALUE - 8;
      
      public static const OBJECTPICKERTYPE_VET_PERKS:int = int.MAX_VALUE - 9;
      
      public static const OBJECTPICKERTYPE_BUSINESS_PERKS:int = int.MAX_VALUE - 10;
      
      public static const DESCRIPTIONDISPLAY_DEFAULT:int = 0;
      
      public static const DESCRIPTIONDISPLAY_NO_DESCRIPTION:int = 1;
      
      public static const DESCRIPTIONDISPLAY_FULL_DESCRIPTION:int = 2;
      
      public static const DESCRIPTIONDISPLAY_SINGLE_LINE:int = 3;
      
      public static const DIALOG_RESPONSE_CLOSED:int = -1;
      
      public static const DIALOG_RESPONSE_NO_RESPONSE:int = 10000;
      
      public static const DIALOG_RESPONSE_OK:int = 10001;
      
      public static const DIALOG_RESPONSE_CANCEL:int = 10002;
      
      public static const DIALOG_RESPONSE_OK_ALT:int = 10003;
      
      public static const DIALOG_RESPONSE_CUSTOM_1:int = 10004;
      
      public static const DIALOG_RESPONSE_CUSTOM_2:int = 10005;
      
      public static const DIALOG_RESPONSE_CUSTOM_3:int = 10006;
      
      public static const CONTROL_ID_UNUSED:int = 0;
      
      public static const CONTROL_ID_SELECTION_SEQUENCE:int = 1;
      
      public var type:int;
      
      public var title:LocKey;
      
      public var owner_sim_id:String;
      
      public var use_dropdown_filter:Boolean;
      
      public var description_display:int;
      
      public var help_tooltip:LocKey;
      
      public var is_sortable:Boolean;
      
      public var bubble_up_selected:Boolean;
      
      public var max_selectable:uint;
      
      public var min_selectable:uint;
      
      public var current_selectable:uint;
      
      public var force_done_button:Boolean;
      
      public var disable_non_selectable_items:Boolean;
      
      public var slot_types_max_selectable:Array = [SlotTypesMaxSelectable];
      
      public var target_sim_id:String;
      
      public var filter_data:Array;
      
      public var control_id_type:int;
      
      public var counter_label_text:LocKey;
      
      public var tooltip_text_cancel:LocKey;
      
      public var tooltip_text_ok:LocKey;
      
      public var recipe_picker_data:RecipePickerData;
      
      public var sim_picker_data:SimPickerData;
      
      public var object_picker_data:ObjectPickerData;
      
      public var outfit_picker_data:OutfitPickerData;
      
      public var shop_picker_data:PurchasePickerData;
      
      public var food_picker_data:FoodPickerData;
      
      public var row_picker_data:Array;
      
      public var dropdown_picker_data:DropdownPickerData;
      
      public var column_based_picker_data:ColumnBasedPickerData;
      
      public var max_selectable_subtitle:LocKey = new LocKey();
      
      public var subtitle:LocKey = new LocKey();
      
      public var mDynamicMaxSelectable:int = -1;
      
      public var mbFromDialog:Boolean;
      
      public function UiDialogPicker(param1:Object = null)
      {
         super(param1);
      }
      
      public static function RemapPickerPerkType(param1:int) : int
      {
         switch(param1)
         {
            case OBJECTPICKERTYPE_RESTAURANT_PERKS:
            case OBJECTPICKERTYPE_VET_PERKS:
            case OBJECTPICKERTYPE_RETAIL_PERKS:
               return OBJECTPICKERTYPE_BUSINESS_PERKS;
            default:
               return param1;
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.type = param1.type;
         this.title = new LocKey(param1.title);
         this.subtitle = new LocKey(param1.subtitle);
         this.owner_sim_id = param1.owner_sim_id;
         this.use_dropdown_filter = param1.use_dropdown_filter;
         this.description_display = param1.description_display;
         this.is_sortable = param1.is_sortable;
         this.bubble_up_selected = param1.bubble_up_selected;
         this.max_selectable = param1.max_selectable;
         this.min_selectable = param1.min_selectable;
         this.current_selectable = param1.current_selected;
         this.force_done_button = param1.force_done_button;
         this.disable_non_selectable_items = param1.disable_non_selectable_items;
         this.slot_types_max_selectable = param1.slot_types_max_selectable;
         this.target_sim_id = param1["target_sim_id"];
         this.control_id_type = param1["control_id_type"];
         this.mbFromDialog = param1.mbFromDialog;
         this.filter_data = new Array();
         if("filter_data" in param1)
         {
            ConstructArrayFromArray(this.filter_data,param1.filter_data,PickerFilterDataList);
         }
         if("counter_label_text" in param1)
         {
            this.counter_label_text = new LocKey(param1.counter_label_text);
         }
         if("tooltip_text_cancel" in param1)
         {
            this.tooltip_text_cancel = new LocKey(param1.tooltip_text_cancel);
         }
         if("tooltip_text_ok" in param1)
         {
            this.tooltip_text_ok = new LocKey(param1.tooltip_text_ok);
         }
         if("recipe_picker_data" in param1)
         {
            this.recipe_picker_data = new RecipePickerData(param1.recipe_picker_data);
         }
         if("sim_picker_data" in param1)
         {
            this.sim_picker_data = new SimPickerData(param1.sim_picker_data);
         }
         if("object_picker_data" in param1)
         {
            this.object_picker_data = new ObjectPickerData(param1.object_picker_data);
         }
         if("outfit_picker_data" in param1)
         {
            this.outfit_picker_data = new OutfitPickerData(param1.outfit_picker_data);
         }
         if("shop_picker_data" in param1)
         {
            this.shop_picker_data = new PurchasePickerData(param1.shop_picker_data);
         }
         if("row_picker_data" in param1)
         {
            this.row_picker_data = new Array();
            ConstructArrayFromArray(this.row_picker_data,param1.row_picker_data,PickerBaseRowData);
         }
         if("dropdown_picker_data" in param1)
         {
            this.dropdown_picker_data = new DropdownPickerData(param1.dropdown_picker_data);
         }
         if("food_picker_data" in param1)
         {
            this.food_picker_data = new FoodPickerData(param1.food_picker_data);
         }
         if("odd_job_picker_data" in param1)
         {
            this.column_based_picker_data = new ColumnBasedPickerData(param1.odd_job_picker_data);
         }
         if("help_tooltip" in param1)
         {
            this.help_tooltip = new LocKey(param1.help_tooltip);
         }
         FixupArray(this.slot_types_max_selectable);
         if("slot_types_max_selectable" in param1)
         {
            ConstructArrayFromArray(this.slot_types_max_selectable,param1.slot_types_max_selectable,SlotTypesMaxSelectable);
         }
         if("max_selectable_subtitle" in param1)
         {
            this.max_selectable_subtitle = new LocKey(param1.max_selectable_subtitle);
         }
      }
      
      public function IsMultiSelect() : Boolean
      {
         return this.min_selectable < 1 || this.max_selectable > 1 || this.max_selectable == 0 || this.force_done_button;
      }
      
      public function ShowFullDescription() : Boolean
      {
         return this.description_display == DESCRIPTIONDISPLAY_FULL_DESCRIPTION;
      }
      
      public function GetControlIds() : Array
      {
         var _loc1_:Array = [];
         if(this.control_id_type == CONTROL_ID_UNUSED)
         {
            return _loc1_;
         }
         if(this.control_id_type == CONTROL_ID_SELECTION_SEQUENCE && this.object_picker_data != null)
         {
            _loc1_ = this.object_picker_data.GetSelectionIndexArray();
         }
         return _loc1_;
      }
      
      public function GetMaxSelectable() : int
      {
         if(this.mDynamicMaxSelectable == -1)
         {
            return this.max_selectable == 0 ? -1 : int(this.max_selectable);
         }
         return this.mDynamicMaxSelectable;
      }
   }
}

