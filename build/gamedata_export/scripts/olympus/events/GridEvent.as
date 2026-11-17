package olympus.events
{
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class GridEvent extends Event
   {
      
      public static const UPDATE_LAYOUT:String = "updateLayout";
      
      public static const UPDATE_SIZE:String = "updateSize";
      
      public static const RESIZE:String = "gridResize";
      
      public static const CELLS_DRAWN:String = "gridCellsRedrawn";
      
      public static const CELL_EVENT:String = "cellEvent";
      
      public static const SELECTION_UPDATE:String = "selectionUpdate";
      
      public var mRect:Rectangle;
      
      public var mCellEvent:Event;
      
      public var mData:Object;
      
      public var mRectArray:Array;
      
      public var mDataIndex:int = -1;
      
      public var mCellIndex:int = -1;
      
      public function GridEvent(param1:String, param2:Rectangle = null, param3:Array = null, param4:Object = null, param5:Boolean = false, param6:int = -1, param7:int = -1)
      {
         super(param1,param5,false);
         this.mRect = param2;
         this.mRectArray = param3;
         this.mData = param4;
         this.mDataIndex = param6;
         this.mCellIndex = param7;
      }
   }
}

