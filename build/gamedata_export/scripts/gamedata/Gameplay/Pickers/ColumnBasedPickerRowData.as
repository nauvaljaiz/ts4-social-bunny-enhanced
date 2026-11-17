package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class ColumnBasedPickerRowData extends OlympusObject
   {
      
      public var base_data:PickerBaseRowData = new PickerBaseRowData();
      
      public var customer_id:String;
      
      public var customer_description:LocKey = new LocKey();
      
      public var tip_title:LocKey = new LocKey();
      
      public var tip_icon:IconInfo = new IconInfo();
      
      public var customer_thumbnail_override:IconInfo = new IconInfo();
      
      public var customer_background:IconInfo = new IconInfo();
      
      public var customer_name:LocKey = new LocKey();
      
      public function ColumnBasedPickerRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.customer_description = FixupLocKey(this.customer_description);
         this.tip_title = FixupLocKey(this.tip_title);
         this.customer_name = FixupLocKey(this.customer_name);
         if(param1["customer_thumbnail_override"] == null)
         {
            this.customer_thumbnail_override = null;
         }
         if(param1["customer_background"] == null)
         {
            this.customer_background = null;
         }
      }
   }
}

