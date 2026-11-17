package olympus.views
{
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import olympus.controls.GUIComponent;
   import olympus.interfaces.IView;
   
   public class CellView extends GUIComponent implements IView
   {
      
      public var mcControllerHighlight:MovieClip;
      
      public function CellView()
      {
         super();
      }
      
      public function Draw(param1:Object, param2:Object = null) : void
      {
      }
      
      public function UpdateViewport(param1:Rectangle) : void
      {
      }
   }
}

