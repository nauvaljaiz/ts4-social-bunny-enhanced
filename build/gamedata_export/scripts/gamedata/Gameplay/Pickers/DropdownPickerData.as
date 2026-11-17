package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class DropdownPickerData extends OlympusObject
   {
      
      public static const OPTION_HIDE_ICON_IN_LIST:uint = 1 << 0;
      
      public var default_item:UiDialogDropdownItem = new UiDialogDropdownItem();
      
      public var items:Array = [UiDialogDropdownItem];
      
      public var invalid_tooltip:LocKey = new LocKey();
      
      public var selected_item_id:int = -1;
      
      public var options:uint = 0;
      
      public function DropdownPickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.items);
         this.invalid_tooltip = FixupLocKey(this.invalid_tooltip);
         if(!("default_item" in param1))
         {
            this.default_item = null;
         }
      }
   }
}

