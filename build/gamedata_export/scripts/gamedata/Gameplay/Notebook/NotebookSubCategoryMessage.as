package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class NotebookSubCategoryMessage extends OlympusObject
   {
      
      public static const NOTEBOOK_EXPANDABLE:uint = 0;
      
      public static const NOTEBOOK_NUMBERED:uint = 1;
      
      public static const NOTEBOOK_ICON_DESCRIPTION:uint = 2;
      
      public static const NOTEBOOK_EXPANDABLE_SINGLE:uint = 3;
      
      public static const NOTEBOOK_EXPANDABLE_SECRET_SCANDAL:uint = 4;
      
      public var subcategory_name:LocKey = new LocKey();
      
      public var subcategory_icon:IconInfo = new IconInfo();
      
      public var subcategory_tooltip:LocKey = new LocKey();
      
      public var subcategory_id:uint;
      
      public var entry_type:uint;
      
      public var max_num_entries:uint;
      
      public var entries:Array = [NotebookEntryMessage];
      
      public var is_sortable:Boolean;
      
      public var is_new_entry_sortable:Boolean;
      
      public function NotebookSubCategoryMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:NotebookEntryMessage = null;
         super.ParseObject(param1);
         FixupArray(this.entries);
         if(this.is_sortable)
         {
            this.entries.sort(this.SortingFunction);
         }
         for each(_loc2_ in this.entries)
         {
            _loc2_.entry_parent_id = this.subcategory_id;
         }
         if(!("subcategory_name" in param1))
         {
            this.subcategory_name = null;
         }
      }
      
      public function SortingFunction(param1:NotebookEntryMessage, param2:NotebookEntryMessage) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this.is_new_entry_sortable)
         {
            if(param1.new_entry || param2.new_entry)
            {
               return 0;
            }
         }
         if(this.entry_type == NOTEBOOK_EXPANDABLE_SECRET_SCANDAL)
         {
            if(param1.entry_type == NotebookEntryMessage.ENTRY_TYPE_MY_SECRET || param1.entry_type == NotebookEntryMessage.ENTRY_TYPE_OTHERS_SECRET)
            {
               _loc3_ = param1.secret_scandal_data.severity.control_id;
               _loc4_ = param2.secret_scandal_data.severity.control_id;
               if(_loc3_ > _loc4_)
               {
                  return -1;
               }
               if(_loc3_ < _loc4_)
               {
                  return 1;
               }
            }
            else if(param1.entry_type == NotebookEntryMessage.ENTRY_TYPE_MY_SCANDAL || param1.entry_type == NotebookEntryMessage.ENTRY_TYPE_OTHERS_SCANDAL)
            {
               return param1.secret_scandal_data.expiration_seconds - param2.secret_scandal_data.expiration_seconds;
            }
         }
         return param1.entry_message.toString().localeCompare(param2.entry_message.toString());
      }
   }
}

