package gamedata.Gameplay.Book
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class BookTabMessage extends OlympusObject
   {
      
      public var first_page_index:uint = 0;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public function BookTabMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("icon_info" in param1))
         {
            this.icon_info = null;
         }
      }
   }
}

