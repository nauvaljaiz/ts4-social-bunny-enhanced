package gamedata.Gameplay.Book
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BookPageMessage extends OlympusObject
   {
      
      public static const BOOK_PAGE_TYPE_BLANK:int = 0;
      
      public static const BOOK_PAGE_TYPE_FRONT:int = 1;
      
      public static const BOOK_PAGE_TYPE_CATEGORY_LIST:int = 2;
      
      public static const BOOK_PAGE_TYPE_CATEGORY_FRONT:int = 3;
      
      public static const BOOK_PAGE_TYPE_CATEGORY:int = 4;
      
      public var type:int = 0;
      
      public var title:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var category_type:int = 0;
      
      public var categories:Array = [BookCategoryMessage];
      
      public var entries:Array = [BookEntryMessage];
      
      public function BookPageMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.categories);
         FixupArray(this.entries);
         this.title = FixupLocKey(this.title);
         this.description = FixupLocKey(this.description);
         if(!("icon" in param1) || !param1.icon)
         {
            this.icon = null;
         }
      }
   }
}

