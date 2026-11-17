package olympus.views
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.events.GridEvent;
   import olympus.gui.lists.IScrollListView;
   
   public class GridView extends CellView implements IScrollListView
   {
      
      protected var mProxySize:Point = new Point(100,100);
      
      public function GridView()
      {
         super();
      }
      
      public function GetGridViewObject() : GridView
      {
         return this;
      }
      
      public function ModifyLayoutBounds(param1:Rectangle) : Rectangle
      {
         return param1;
      }
      
      override public function UpdateViewport(param1:Rectangle) : void
      {
         if(hasEventListener(GridEvent.UPDATE_LAYOUT))
         {
            dispatchEvent(new GridEvent(GridEvent.UPDATE_LAYOUT,param1));
         }
         else
         {
            x = param1.x;
            y = param1.y;
         }
      }
      
      override public function get width() : Number
      {
         return this.mProxySize.x;
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != this.mProxySize.x)
         {
            this.mProxySize.x = param1;
            dispatchEvent(new GridEvent(GridEvent.UPDATE_SIZE));
         }
      }
      
      override public function get height() : Number
      {
         return this.mProxySize.y;
      }
      
      override public function set height(param1:Number) : void
      {
         if(param1 != this.mProxySize.y)
         {
            this.mProxySize.y = param1;
            dispatchEvent(new GridEvent(GridEvent.UPDATE_SIZE));
         }
      }
   }
}

