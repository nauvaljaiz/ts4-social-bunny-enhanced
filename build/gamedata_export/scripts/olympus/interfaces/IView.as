package olympus.interfaces
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.motion.TweenParams;
   
   public interface IView
   {
      
      function Draw(param1:Object, param2:Object = null) : void;
      
      function UpdateViewport(param1:Rectangle) : void;
      
      function set mask(param1:DisplayObject) : void;
      
      function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int;
      
      function AnimateOut(param1:int, param2:TweenParams, param3:Point = null) : int;
   }
}

