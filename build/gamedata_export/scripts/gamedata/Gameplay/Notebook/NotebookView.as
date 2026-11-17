package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   
   public class NotebookView extends OlympusObject
   {
      
      public var notes:String;
      
      public var open_page:Boolean;
      
      public var sim_id:String;
      
      public var categories:Array = [NotebookCategoryMessage];
      
      public var selected_category_index:uint;
      
      public var selected_subcategory_index:uint;
      
      public function NotebookView(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.categories);
      }
   }
}

