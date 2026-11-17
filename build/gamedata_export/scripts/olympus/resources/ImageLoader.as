package olympus.resources
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import olympus.constants.Alignment;
   import olympus.constants.ScaleMode;
   import olympus.core.Ticker;
   import olympus.errors.Assert;
   import olympus.events.AssetLoaderEvent;
   import olympus.io.AssetLoader;
   
   public class ImageLoader implements IImageContainer
   {
      
      protected static const INDICATOR_FRAME_NAME_LOADING:String = "loading";
      
      protected static const INDICATOR_FRAME_NAME_FAILED:String = "failed";
      
      protected static const LOADING_INDICATOR_CREATE_WAIT_TIME:Number = 100;
      
      protected var mContainer:Sprite;
      
      protected var mImageRegion:Rectangle;
      
      protected var mScaleMode:String = "showAll";
      
      protected var mAlignment:String = "center";
      
      protected var mbSmoothing:Boolean = true;
      
      protected var mResourceId:String;
      
      protected var mLoadUrl:String;
      
      protected var mbQueuedResourceLoad:Boolean = false;
      
      protected var mLoadingIndicatorClass:Class = null;
      
      protected var mLoadingIndicator:DisplayObject;
      
      protected var mbIgnoreStageEvents:* = false;
      
      public function ImageLoader(param1:Sprite)
      {
         super();
         Assert.NotNull(param1);
         this.mContainer = param1;
      }
      
      public function Initialize(param1:Rectangle) : void
      {
         this.mImageRegion = param1;
         if(this.mImageRegion != null)
         {
            if(this.mbQueuedResourceLoad)
            {
               this.LoadImage(this.mResourceId,true);
               this.mbQueuedResourceLoad = false;
            }
         }
         this.mContainer.addEventListener(Event.ADDED_TO_STAGE,this.OnContainerAddedToStage,false,0,true);
         this.mContainer.addEventListener(Event.REMOVED_FROM_STAGE,this.OnContainerRemovedFromStage,false,0,true);
      }
      
      public function get scaleMode() : String
      {
         return this.mScaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(this.mScaleMode == param1)
         {
            return;
         }
         this.mScaleMode = param1;
         this.RefitImage();
      }
      
      public function get align() : String
      {
         return this.mAlignment;
      }
      
      public function set align(param1:String) : void
      {
         if(this.mAlignment == param1)
         {
            return;
         }
         this.mAlignment = param1;
         this.RefitImage();
      }
      
      public function get smoothing() : Boolean
      {
         return this.mbSmoothing;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         this.mbSmoothing = param1;
         var _loc2_:Bitmap = this.GetLoadedImage() as Bitmap;
         if(_loc2_)
         {
            _loc2_.smoothing = this.mbSmoothing;
         }
      }
      
      public function get imageRegion() : Rectangle
      {
         if(this.mImageRegion)
         {
            return this.mImageRegion.clone();
         }
         return null;
      }
      
      public function set imageRegion(param1:Rectangle) : void
      {
         this.mImageRegion = param1;
         this.RefitImage();
      }
      
      public function get resourceId() : String
      {
         return this.mResourceId;
      }
      
      public function get loadingIndicatorClass() : Class
      {
         return this.mLoadingIndicatorClass;
      }
      
      public function set loadingIndicatorClass(param1:Class) : void
      {
         this.mLoadingIndicatorClass = param1;
      }
      
      public function get ignoreStageEvents() : Boolean
      {
         return this.mbIgnoreStageEvents;
      }
      
      public function set ignoreStageEvents(param1:Boolean) : void
      {
         this.mbIgnoreStageEvents = param1;
      }
      
      public function LoadImage(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:Sprite = this.mContainer;
         if(!this.mImageRegion)
         {
            this.mResourceId = param1;
            this.mbQueuedResourceLoad = true;
            return;
         }
         if(!_loc4_.stage)
         {
            this.mResourceId = param1;
            return;
         }
         if(this.mResourceId == param1 && !param2)
         {
            if(param1 == null)
            {
               this.UnloadChildren();
            }
            return;
         }
         var _loc5_:Boolean = this.CancelLoad();
         if((_loc5_) || !param3)
         {
            this.UnloadChildren();
         }
         this.mResourceId = param1;
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         if(_loc5_ || !param3)
         {
            this.ScheduleCreateLoadingIndicator();
         }
         if(param1.substr(0,6) != "img://")
         {
            param1 = "img://" + param1;
         }
         _loc4_.addEventListener(AssetLoaderEvent.BEGIN,this.OnAssetLoaderBegin,false,0,true);
         this.mLoadUrl = AssetLoader.Load(param1,_loc4_);
         if(this.mLoadUrl)
         {
            _loc4_.addEventListener(AssetLoaderEvent.COMPLETE,this.OnAssetLoaderComplete,false,0,true);
            _loc4_.addEventListener(AssetLoaderEvent.FAIL,this.OnAssetLoaderFail,false,0,true);
         }
         else
         {
            _loc4_.removeEventListener(AssetLoaderEvent.BEGIN,this.OnAssetLoaderBegin);
         }
      }
      
      public function GetLoadedImage() : DisplayObject
      {
         var _loc1_:Sprite = null;
         var _loc4_:DisplayObject = null;
         _loc1_ = this.mContainer;
         var _loc2_:int = _loc1_.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_.getChildAt(_loc3_);
            if(_loc4_ != this.mLoadingIndicator)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function RefitImage() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mContainer.numChildren < 1)
         {
            return;
         }
         if(this.mImageRegion == null)
         {
            return;
         }
         var _loc1_:DisplayObject = this.GetLoadedImage();
         if(!_loc1_)
         {
            return;
         }
         var _loc4_:Number = 0;
         _loc1_.x = this.mImageRegion.x;
         _loc1_.y = this.mImageRegion.y;
         switch(this.mScaleMode)
         {
            case ScaleMode.SHOW_ALL:
               _loc2_ = this.mImageRegion.width / _loc1_.width;
               _loc3_ = this.mImageRegion.height / _loc1_.height;
               _loc4_ = _loc2_ < _loc3_ ? _loc2_ : _loc3_;
               _loc1_.width *= _loc4_;
               _loc1_.height *= _loc4_;
               this.RealignImage(_loc1_);
               break;
            case ScaleMode.NO_SCALE:
               this.RealignImage(_loc1_);
               break;
            case ScaleMode.EXACT_FIT:
               _loc1_.width = this.mImageRegion.width;
               _loc1_.height = this.mImageRegion.height;
               break;
            case ScaleMode.NO_BORDER:
               _loc2_ = this.mImageRegion.width / _loc1_.width;
               _loc3_ = this.mImageRegion.height / _loc1_.height;
               _loc4_ = _loc2_ > _loc3_ ? _loc2_ : _loc3_;
               _loc1_.width *= _loc4_;
               _loc1_.height *= _loc4_;
               this.RealignImage(_loc1_);
         }
      }
      
      protected function RealignImage(param1:DisplayObject = null) : void
      {
         if(this.mImageRegion == null)
         {
            return;
         }
         param1 = param1 == null ? this.GetLoadedImage() : param1;
         if(!param1)
         {
            return;
         }
         param1.x = this.mImageRegion.x;
         param1.y = this.mImageRegion.y;
         switch(this.mAlignment)
         {
            case Alignment.CENTER:
               param1.x += (this.mImageRegion.width - param1.width) * 0.5;
               param1.y += (this.mImageRegion.height - param1.height) * 0.5;
               break;
            case Alignment.BOTTOM:
               param1.y += this.mImageRegion.height - param1.height;
            case Alignment.TOP:
               param1.x += (this.mImageRegion.width - param1.width) * 0.5;
               break;
            case Alignment.RIGHT:
               param1.x += this.mImageRegion.width - param1.width;
            case Alignment.LEFT:
               param1.y += (this.mImageRegion.height - param1.height) * 0.5;
               break;
            case Alignment.TOP_RIGHT:
               param1.x += this.mImageRegion.width - param1.width;
            case Alignment.TOP_LEFT:
               break;
            case Alignment.BOTTOM_RIGHT:
               param1.x += this.mImageRegion.width - param1.width;
            case Alignment.BOTTOM_LEFT:
               param1.y += this.mImageRegion.height - param1.height;
         }
      }
      
      protected function OnAssetLoaderBegin(param1:AssetLoaderEvent) : void
      {
         this.RefitImage();
         this.mContainer.removeEventListener(AssetLoaderEvent.BEGIN,this.OnAssetLoaderBegin);
      }
      
      protected function OnAssetLoaderComplete(param1:AssetLoaderEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Loader = null;
         var _loc2_:DisplayObjectContainer = this.mContainer;
         this.mLoadUrl = null;
         _loc2_.removeEventListener(AssetLoaderEvent.COMPLETE,this.OnAssetLoaderComplete);
         _loc2_.removeEventListener(AssetLoaderEvent.FAIL,this.OnAssetLoaderFail);
         this.RemoveLoadingIndicator();
         while(_loc2_.numChildren > 1)
         {
            _loc3_ = _loc2_.removeChildAt(0);
            _loc4_ = _loc3_.loaderInfo ? _loc3_.loaderInfo.loader : null;
            if(_loc4_)
            {
               _loc4_.addChild(_loc3_);
               _loc4_.unload();
            }
         }
         this.smoothing = this.mbSmoothing;
      }
      
      protected function OnAssetLoaderFail(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         Ticker.Remove(this);
         var _loc2_:Sprite = this.mContainer;
         this.mLoadUrl = null;
         _loc2_.removeEventListener(AssetLoaderEvent.COMPLETE,this.OnAssetLoaderComplete);
         _loc2_.removeEventListener(AssetLoaderEvent.FAIL,this.OnAssetLoaderFail);
         if(this.mLoadingIndicator)
         {
            _loc3_ = this.mLoadingIndicator as MovieClip;
            if(_loc3_)
            {
               _loc3_.gotoAndStop(INDICATOR_FRAME_NAME_FAILED);
            }
            else
            {
               this.RemoveLoadingIndicator();
            }
         }
         this.mResourceId = null;
      }
      
      protected function OnContainerAddedToStage(param1:Event) : void
      {
         if(this.mbIgnoreStageEvents)
         {
            return;
         }
         if(this.mResourceId != null && this.mResourceId.length > 0)
         {
            this.LoadImage(this.mResourceId,true);
         }
      }
      
      protected function OnContainerRemovedFromStage(param1:Event) : void
      {
         if(this.mbIgnoreStageEvents)
         {
            return;
         }
         this.CancelLoad();
         this.UnloadChildren();
      }
      
      protected function UnloadChildren() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Loader = null;
         this.RemoveLoadingIndicator();
         var _loc1_:Sprite = this.mContainer;
         _loc1_.graphics.clear();
         while(_loc1_.numChildren > 0)
         {
            _loc2_ = _loc1_.removeChildAt(0);
            if(Boolean(_loc2_) && Boolean(_loc2_.loaderInfo))
            {
               _loc3_ = _loc2_.loaderInfo.loader;
               if(_loc3_)
               {
                  _loc3_.addChild(_loc2_);
                  _loc3_.unload();
               }
            }
         }
      }
      
      protected function CancelLoad() : Boolean
      {
         if(this.mLoadUrl)
         {
            this.mContainer.removeEventListener(AssetLoaderEvent.COMPLETE,this.OnAssetLoaderComplete);
            this.mContainer.removeEventListener(AssetLoaderEvent.FAIL,this.OnAssetLoaderFail);
            if(AssetLoader.CancelLoad(this.mLoadUrl))
            {
               this.mLoadUrl = null;
               return true;
            }
            this.mLoadUrl = null;
         }
         return false;
      }
      
      protected function ScheduleCreateLoadingIndicator() : void
      {
         Ticker.Add(this,LOADING_INDICATOR_CREATE_WAIT_TIME,this.CreateLoadingIndicator);
      }
      
      protected function CreateLoadingIndicator() : void
      {
         var _loc1_:DisplayObject = null;
         Ticker.Remove(this);
         if(Boolean(this.mLoadingIndicator) || this.mLoadingIndicatorClass == null)
         {
            return;
         }
         _loc1_ = new this.mLoadingIndicatorClass() as DisplayObject;
         this.mContainer.addChild(_loc1_);
         if(this.mImageRegion != null)
         {
            _loc1_.x += (this.mImageRegion.width - _loc1_.width) * 0.5;
            _loc1_.y += (this.mImageRegion.height - _loc1_.height) * 0.5;
         }
         var _loc2_:MovieClip = _loc1_ as MovieClip;
         if(_loc2_)
         {
            _loc2_.gotoAndPlay(INDICATOR_FRAME_NAME_LOADING);
         }
         this.mLoadingIndicator = _loc1_;
      }
      
      protected function RemoveLoadingIndicator() : void
      {
         Ticker.Remove(this);
         if(this.mLoadingIndicator != null)
         {
            this.mLoadingIndicator.parent.removeChild(this.mLoadingIndicator);
            this.mLoadingIndicator = null;
         }
      }
   }
}

