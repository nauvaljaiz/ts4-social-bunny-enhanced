package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class NotebookCategoryMessage extends OlympusObject
   {
      
      public var category_name:LocKey = new LocKey();
      
      public var category_description:LocKey = new LocKey();
      
      public var category_icon:IconInfo = new IconInfo();
      
      public var category_large_icon:IconInfo = new IconInfo();
      
      public var subcategories:Array = [NotebookSubCategoryMessage];
      
      public var enum_name:String;
      
      public var display_subcategory_title:Boolean;
      
      public function NotebookCategoryMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.subcategories);
         if(!("category_description" in param1))
         {
            this.category_description = null;
         }
      }
   }
}

