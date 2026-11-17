package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class NotebookEntryListMessage extends OlympusObject
   {
      
      public var item_message:LocKey = new LocKey();
      
      public var item_icon:IconInfo;
      
      public var item_count:uint;
      
      public var item_total:uint;
      
      public var item_tooltip:LocKey;
      
      public var new_item:Boolean;
      
      public function NotebookEntryListMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if("item_icon" in param1)
         {
            this.item_icon = new IconInfo();
         }
         if("item_tooltip" in param1)
         {
            this.item_tooltip = new LocKey();
         }
         super.ParseObject(param1);
      }
   }
}

