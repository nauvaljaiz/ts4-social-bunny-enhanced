package gamedata.Gameplay.Book
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BookEntryMessage extends OlympusObject
   {
      
      public static const STATUS_FLAG_ENTRY_UNLOCKED:int = 1 << 0;
      
      public static const STATUS_FLAG_ENTRY_NEW:int = 1 << 1;
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var subtext_title:LocKey = new LocKey();
      
      public var subtext:LocKey = new LocKey();
      
      public var tooltip_text:LocKey = new LocKey();
      
      public var category_type:int = 0;
      
      public var status_flags:uint = 0;
      
      public function BookEntryMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.description = FixupLocKey(this.description);
         this.subtext_title = FixupLocKey(this.subtext_title);
         this.subtext = FixupLocKey(this.subtext);
         this.tooltip_text = FixupLocKey(this.tooltip_text);
      }
   }
}

