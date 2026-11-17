package olympus.controls
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import olympus.resources.IImageContainer;
   import olympus.resources.ImageLoader;
   
   public class IconComponent extends GUIComponent implements IImageContainer
   {
      
      protected var mLoader:ImageLoader;
      
      public function IconComponent()
      {
         super();
         this.mLoader = new ImageLoader(this);
      }
      
      public function LoadImage(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         this.mLoader.LoadImage(param1,param2,param3);
      }
      
      public function GetLoadedImage() : DisplayObject
      {
         return this.mLoader.GetLoadedImage();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.SetupImageRegion(width,height);
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
      
      public function get ignoreStageEvents() : Boolean
      {
         return this.mLoader.ignoreStageEvents;
      }
      
      public function set ignoreStageEvents(param1:Boolean) : void
      {
         this.mLoader.ignoreStageEvents = param1;
      }
      
      public function ResetImageSize(param1:Number, param2:Number) : void
      {
         this.SetupImageRegion(param1,param2);
      }
      
      protected function SetupImageRegion(param1:Number, param2:Number) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:Rectangle = new Rectangle(0,0,param1,param2);
         scaleX = scaleY = 1;
         if(numChildren == 1)
         {
            _loc4_ = getChildAt(0);
            _loc4_.width = _loc3_.width;
            _loc4_.height = _loc3_.height;
         }
         this.mLoader.Initialize(_loc3_);
      }
   }
}

