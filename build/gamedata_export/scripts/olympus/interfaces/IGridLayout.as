package olympus.interfaces
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import olympus.core.widget.Margin;
   
   public interface IGridLayout
   {
      
      function SetCellView(param1:Class, param2:Margin = null, param3:Boolean = false) : void;
      
      function CreateCell(param1:Object = null) : IView;
      
      function PositionCells() : void;
      
      function RegisterCellEventListener(param1:String, param2:Boolean = true) : void;
      
      function UnregisterCellEventListener(param1:String, param2:Boolean = true) : void;
      
      function SetCellViewAudioElementName(param1:String) : void;
      
      function GetLayoutBounds() : Rectangle;
      
      function GetCellBounds() : Rectangle;
      
      function SetCellBounds(param1:Rectangle) : void;
      
      function GetCellPadding() : Margin;
      
      function SetCellPadding(param1:Margin) : void;
      
      function SetGridView(param1:IView) : void;
      
      function RemoveGridView() : void;
      
      function SetDataFeed(param1:IDataFeed) : void;
      
      function RemoveDataFeed() : void;
      
      function GetDataFeed() : IDataFeed;
      
      function GetVisibleCells(param1:Rectangle, param2:DisplayObject) : Vector.<IView>;
      
      function GetAllCells() : Vector.<IView>;
      
      function GetAllDisplayObjectCells() : Vector.<DisplayObject>;
      
      function GetGridDimensions() : Array;
      
      function GetViewAtIndex(param1:int) : IView;
      
      function GridCoordToIndex(param1:int, param2:int) : int;
      
      function IndexToGridCoord(param1:int) : Array;
      
      function GetNumItems() : int;
      
      function GetPositionOfIndex(param1:int) : Number;
      
      function GetGridIndexOfCell(param1:DisplayObject) : int;
      
      function get Horizontal() : Boolean;
   }
}

