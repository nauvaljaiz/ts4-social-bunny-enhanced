package olympus.controls
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import olympus.resources.IImageContainer;
   import olympus.resources.ImageLoader;
   
   public class ImageResource extends Sprite implements IImageContainer
   {
      
      protected var mLoader:ImageLoader;
      
      public function ImageResource()
      {
         super();
         this.mLoader = new ImageLoader(this);
         addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,false,int.MAX_VALUE,true);
      }
      
      public function get scaleMode() : String
      {
         return this.mLoader.scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         this.mLoader.scaleMode = param1;
      }
      
      public function get align() : String
      {
         return this.mLoader.align;
      }
      
      public function set align(param1:String) : void
      {
         this.mLoader.align = param1;
      }
      
      public function get smoothing() : Boolean
      {
         return this.mLoader.smoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         this.mLoader.smoothing = param1;
      }
      
      public function get imageRegion() : Rectangle
      {
         return this.mLoader.imageRegion;
      }
      
      public function set imageRegion(param1:Rectangle) : void
      {
         this.mLoader.imageRegion = param1;
      }
      
      public function get resourceId() : String
      {
         return this.mLoader.resourceId;
      }
      
      public function get loadingIndicatorClass() : Class
      {
         return this.mLoader.loadingIndicatorClass;
      }
      
      public function set loadingIndicatorClass(param1:Class) : void
      {
         this.mLoader.loadingIndicatorClass = param1;
      }
      
      public function LoadImage(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         this.mLoader.LoadImage(param1,param2,param3);
      }
      
      public function GetLoadedImage() : DisplayObject
      {
         return this.mLoader.GetLoadedImage();
      }
      
      protected function OnAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
         this.mLoader.Initialize(getRect(this));
      }
   }
}

