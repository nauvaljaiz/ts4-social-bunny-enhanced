package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogMultiPickerItem extends OlympusObject
   {
      
      public var picker_data:UiDialogPicker = new UiDialogPicker();
      
      public var picker_id:uint;
      
      public var disabled_tooltip:LocKey = new LocKey();
      
      public var max_selected_tooltip:LocKey = new LocKey();
      
      public var show_header:Boolean = true;
      
      public var bShowWarning:Boolean = false;
      
      public var bDirtyForFullUpdate:Boolean = false;
      
      public var mPickerHeight:Number = 340;
      
      public function UiDialogMultiPickerItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.disabled_tooltip = FixupLocKey(this.disabled_tooltip);
         this.max_selected_tooltip = FixupLocKey(this.max_selected_tooltip);
      }
      
      public function GetControlIds() : Array
      {
         return this.picker_data.GetControlIds();
      }
   }
}

