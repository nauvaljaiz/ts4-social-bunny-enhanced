package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogMultiPicker extends OlympusObject
   {
      
      public static const MULTIPICKER_FILTER_NO_FILTER:int = 0;
      
      public static const MULTIPICKER_FILTER_RELBIT_FILTER:int = 1;
      
      public static const MULTIPICKER_FILTER_TOPIC_FILTER:int = 2;
      
      public var multi_picker_items:Array = [UiDialogMultiPickerItem];
      
      public var multi_picker_style:int = 0;
      
      public var multipicker_filter_type:int = 0;
      
      public var multi_picker_items_height:Number = -1;
      
      public var combined_limits_datas:Array = [UiDialogMultiPickerCombinedLimitsData];
      
      public var multi_picker_selection_equality:Boolean = false;
      
      public var multi_selection_inequality_tooltip:LocKey = new LocKey();
      
      protected var mDropdowns:Array;
      
      protected var mPickers:Array;
      
      public function UiDialogMultiPicker(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:UiDialogMultiPickerItem = null;
         super.ParseObject(param1);
         FixupArray(this.multi_picker_items);
         FixupArray(this.combined_limits_datas);
         this.mDropdowns = new Array();
         this.mPickers = new Array();
         for each(_loc2_ in this.multi_picker_items)
         {
            if(_loc2_.picker_data.type == UiDialogPicker.OBJECTPICKERTYPE_DROPDOWN)
            {
               this.mDropdowns.push(_loc2_);
            }
            else
            {
               this.mPickers.push(_loc2_);
            }
         }
         this.multi_selection_inequality_tooltip = FixupLocKey(this.multi_selection_inequality_tooltip);
      }
      
      public function GetDropdowns() : Array
      {
         return this.mDropdowns;
      }
      
      public function GetPickers() : Array
      {
         return this.mPickers;
      }
   }
}

