package gamedata.Gameplay.Book
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BookCategoryMessage extends OlympusObject
   {
      
      public var first_page_index:uint = 0;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip_text:LocKey = new LocKey();
      
      public var progress:uint = 100;
      
      public var progress_title:LocKey = new LocKey();
      
      public var progress_text:LocKey = new LocKey();
      
      public var new_entries:Array = [String];
      
      public function BookCategoryMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.tooltip_text = FixupLocKey(this.tooltip_text);
         this.progress_title = FixupLocKey(this.progress_title);
         this.progress_text = FixupLocKey(this.progress_text);
         FixupArray(this.new_entries);
      }
      
      public function get HasNewEntries() : Boolean
      {
         return Boolean(this.new_entries) && this.new_entries.length != 0;
      }
      
      public function MarkEntrySeen(param1:String) : Boolean
      {
         var _loc2_:int = this.new_entries.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.new_entries.splice(_loc2_,1);
            return true;
         }
         return false;
      }
   }
}

