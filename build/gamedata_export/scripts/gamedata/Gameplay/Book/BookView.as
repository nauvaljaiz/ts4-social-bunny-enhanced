package gamedata.Gameplay.Book
{
   import olympus.core.OlympusObject;
   
   public class BookView extends OlympusObject
   {
      
      public static const BOOK_DISPLAY_STYLE_DEFAULT:int = 0;
      
      public static const BOOK_DISPLAY_STYLE_WITCH:int = 1;
      
      public var sim_id:String;
      
      public var pages:Array = [BookPageMessage];
      
      public var style:int = 0;
      
      public var context:String;
      
      public var tabs:Array = [BookTabMessage];
      
      public function BookView(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAudioElementForStyle(param1:int) : String
      {
         switch(param1)
         {
            case BOOK_DISPLAY_STYLE_WITCH:
               return "Spellbook";
            case BOOK_DISPLAY_STYLE_DEFAULT:
         }
         return "Book";
      }
      
      public static function GetLabelForStyle(param1:int) : String
      {
         switch(param1)
         {
            case BOOK_DISPLAY_STYLE_WITCH:
               return "witch";
            case BOOK_DISPLAY_STYLE_DEFAULT:
         }
         return "default";
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.pages);
         FixupArray(this.tabs);
      }
   }
}

