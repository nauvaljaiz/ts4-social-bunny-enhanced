package olympus.interfaces
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public interface ITooltip
   {
      
      function SetData(param1:Object) : void;
      
      function Show(param1:Number) : void;
      
      function Hide(param1:Boolean, param2:Number) : void;
      
      function GetBounds() : Rectangle;
      
      function GetDisplayObject() : DisplayObject;
      
      function OnUpdatePosition(param1:Rectangle, param2:Number = 0, param3:Number = 0) : void;
   }
}

