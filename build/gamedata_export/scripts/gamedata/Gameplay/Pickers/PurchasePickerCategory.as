package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class PurchasePickerCategory extends OlympusObject
   {
      
      public var tag_type:uint;
      
      public var icon_info:IconInfo;
      
      public var description:LocKey;
      
      public var disabled_tooltip:LocKey;
      
      public function PurchasePickerCategory(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.tag_type = param1.tag_type;
         this.icon_info = new IconInfo(param1.icon_info);
         this.description = LocKey.GetValidatedLocKey(param1.description);
         if(param1.disabled_tooltip != null)
         {
            this.disabled_tooltip = LocKey.GetValidatedLocKey(param1.disabled_tooltip);
         }
      }
   }
}

