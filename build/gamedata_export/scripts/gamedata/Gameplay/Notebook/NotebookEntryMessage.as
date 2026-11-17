package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.objects.ObjectMetadata;
   
   public class NotebookEntryMessage extends OlympusObject
   {
      
      public static const ENTRY_TYPE_NONE:uint = 0;
      
      public static const ENTRY_TYPE_MY_SECRET:uint = 1;
      
      public static const ENTRY_TYPE_MY_SCANDAL:uint = 2;
      
      public static const ENTRY_TYPE_OTHERS_SECRET:uint = 3;
      
      public static const ENTRY_TYPE_OTHERS_SCANDAL:uint = 4;
      
      public var entry_message:LocKey = new LocKey();
      
      public var entry_message_description:LocKey = new LocKey();
      
      public var entry_icon:IconInfo = new IconInfo();
      
      public var entry_metadata_hovertip:ObjectMetadata;
      
      public var entry_list_description:LocKey;
      
      public var entry_id:uint;
      
      public var entry_parent_id:uint;
      
      public var entry_list:Array = [NotebookEntryListMessage];
      
      public var new_entry:Boolean;
      
      public var is_sortable:Boolean;
      
      public var is_new_item_sortable:Boolean;
      
      public var entry_type:uint;
      
      public var secret_scandal_data:NotebookSecretScandalMessage;
      
      public function NotebookEntryMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if("entry_metadata_hovertip" in param1)
         {
            this.entry_metadata_hovertip = new ObjectMetadata();
         }
         if("entry_list_description" in param1)
         {
            this.entry_list_description = new LocKey();
         }
         if("entry_message_description" in param1)
         {
            this.entry_message_description = new LocKey();
         }
         if("secret_scandal_data" in param1)
         {
            this.secret_scandal_data = new NotebookSecretScandalMessage();
         }
         super.ParseObject(param1);
         FixupArray(this.entry_list);
         if(this.is_sortable && this.entry_list.length > 0)
         {
            this.entry_list.sort(this.SortingFunction);
         }
         if(!("entry_icon" in param1))
         {
            this.entry_icon = null;
         }
      }
      
      public function SortingFunction(param1:NotebookEntryListMessage, param2:NotebookEntryListMessage) : int
      {
         if(!this.is_new_item_sortable)
         {
            if(param1.new_item || param2.new_item)
            {
               return 0;
            }
         }
         return param1.item_message.toString().localeCompare(param2.item_message.toString());
      }
   }
}

