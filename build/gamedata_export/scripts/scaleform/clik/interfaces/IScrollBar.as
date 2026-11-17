package scaleform.clik.interfaces
{
   public interface IScrollBar extends IUIComponent
   {
      
      function get position() : Number;
      
      function set position(param1:Number) : void;
      
      function scrollUp() : void;
      
      function scrollDown() : void;
   }
}

