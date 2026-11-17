package olympus.interfaces
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.motion.TweenParams;
   
   public interface IAnimation
   {
      
      function GetRect() : Rectangle;
      
      function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int;
      
      function AnimateOut(param1:int, param2:TweenParams, param3:Point = null) : int;
   }
}

