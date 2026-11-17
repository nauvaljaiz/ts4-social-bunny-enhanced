package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class UiDialogDropdownItem extends OlympusObject
   {
      
      public var id:uint = 0;
      
      public var text:LocKey = new LocKey();
      
      public var icon_info:IconInfo = new IconInfo();
      
      public function UiDialogDropdownItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.text = FixupLocKey(this.text);
      }
   }
}

