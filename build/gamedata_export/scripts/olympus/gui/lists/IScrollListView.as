package olympus.gui.lists
{
   import flash.geom.Rectangle;
   import olympus.views.GridView;
   
   public interface IScrollListView
   {
      
      function GetGridViewObject() : GridView;
      
      function ModifyLayoutBounds(param1:Rectangle) : Rectangle;
   }
}

