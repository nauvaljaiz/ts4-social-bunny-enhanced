package olympus.resources
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public interface IImageContainer
   {
      
      function get scaleMode() : String;
      
      function set scaleMode(param1:String) : void;
      
      function get align() : String;
      
      function set align(param1:String) : void;
      
      function get smoothing() : Boolean;
      
      function set smoothing(param1:Boolean) : void;
      
      function get imageRegion() : Rectangle;
      
      function set imageRegion(param1:Rectangle) : void;
      
      function get resourceId() : String;
      
      function get loadingIndicatorClass() : Class;
      
      function set loadingIndicatorClass(param1:Class) : void;
      
      function LoadImage(param1:String, param2:Boolean = false, param3:Boolean = false) : void;
      
      function GetLoadedImage() : DisplayObject;
   }
}

