package olympus.controls
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import olympus.events.AssetLoaderEvent;
   import olympus.events.GenericEvent;
   import olympus.utils.ImageUtils;
   import olympus.utils.LibraryUtils;
   
   public class WebIconComponent extends IconComponent
   {
      
      public static const WEB_ICON_FINISHED_EVENT:String = "WebIconFinished";
      
      public static const LOADSTATE_NONE:int = 0;
      
      public static const LOADSTATE_LOADING_WEB_IMAGE:int = 1;
      
      public static const LOADSTATE_LOADING_LOCAL_IMAGE:int = 2;
      
      public static const LOADSTATE_LOADED_WEB_IMAGE:int = 3;
      
      public static const LOADSTATE_LOADED_LOCAL_IMAGE:int = 4;
      
      public static const LOADSTATE_FAILED:int = 5;
      
      public static const LOADSTATE_FAILED_TIMEOUT:int = 6;
      
      public static const LOADSTATE_LOADING_CUSTOM_IMAGE:int = 7;
      
      public static const LOADSTATE_LOADED_CUSTOM_IMAGE:int = 8;
      
      public static const DEFAULT_TIMEOUT_MS:int = 2000;
      
      protected static const QUEUED_IMAGE_TYPE_DEFAULT:int = 0;
      
      protected static const QUEUED_IMAGE_TYPE_STORE:int = 1;
      
      protected static const QUEUED_IMAGE_TYPE_BUNDLE:int = 2;
      
      protected static const QUEUED_IMAGE_TYPE_BUNDLE_BY_TYPE:int = 3;
      
      protected var mLoadState:int = 0;
      
      protected var mLoadTimer:Timer;
      
      protected var mLocalResourceId:String;
      
      protected var mbResourceLoadQueued:Boolean = false;
      
      protected var mQueuedImageType:int = 0;
      
      protected var mQueuedImageData:Object;
      
      public function WebIconComponent()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         if(this.mbResourceLoadQueued && Boolean(mLoader.imageRegion))
         {
            this.LoadQueuedImage();
         }
      }
      
      public function LoadUrlWithFailureImage(param1:String, param2:String, param3:int = 2000, param4:String = "olympus.controls.LoadingIndicator") : void
      {
         this.LocalResourceId = param2;
         this.LoadUrl(param1,param3,param4);
      }
      
      public function LoadUrl(param1:String, param2:int = 2000, param3:String = "olympus.controls.LoadingIndicator") : void
      {
         if(!this.ShouldLoadWebImage(param1))
         {
            return;
         }
         if(param3)
         {
            loadingIndicatorClass = LibraryUtils.GetLibraryClass(param3);
         }
         this.LoadWebImage(param1);
         if(param2 != 0)
         {
            this.mLoadTimer = new Timer(param2,1);
            this.mLoadTimer.addEventListener(TimerEvent.TIMER,this.HandleTimeOut,false,0,true);
            this.mLoadTimer.start();
         }
      }
      
      public function LoadBundleImageByTypeWithFailureImage(param1:String, param2:String, param3:String, param4:int = 2000, param5:String = "olympus.controls.LoadingIndicator", param6:String = null) : void
      {
         if(param6 == null)
         {
            param6 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         this.LocalResourceId = param3;
         this.LoadBundleImageByType(param1,param2,param4,param5,param6);
      }
      
      public function LoadBundleImageByType(param1:String, param2:String, param3:int = 2000, param4:String = "olympus.controls.LoadingIndicator", param5:String = null) : void
      {
         if(param5 == null)
         {
            param5 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         if(!this.ShouldLoadBundleImageByType(param1,param2,param5))
         {
            return;
         }
         if(param4)
         {
            loadingIndicatorClass = LibraryUtils.GetLibraryClass(param4);
         }
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
         this.mLoadState = LOADSTATE_LOADING_WEB_IMAGE;
         visible = true;
         ImageUtils.LoadStoreBundleImageByType(this,param1,param2,Number.MAX_VALUE,Number.MAX_VALUE,param5);
         if(param3 != 0)
         {
            this.mLoadTimer = new Timer(param3,1);
            this.mLoadTimer.addEventListener(TimerEvent.TIMER,this.HandleTimeOut,false,0,true);
            this.mLoadTimer.start();
         }
      }
      
      public function LoadBundleImageWithFailureImage(param1:String, param2:String, param3:String, param4:int = 2000, param5:String = "olympus.controls.LoadingIndicator", param6:String = null) : void
      {
         if(param6 == null)
         {
            param6 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         this.LocalResourceId = param3;
         this.LoadBundleImage(param1,param2,param4,param5,param6);
      }
      
      public function LoadBundleImage(param1:String, param2:String, param3:int = 2000, param4:String = "olympus.controls.LoadingIndicator", param5:String = null) : void
      {
         if(param5 == null)
         {
            param5 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         if(!this.ShouldLoadBundleImage(param1,param2,param5))
         {
            return;
         }
         if(param4)
         {
            loadingIndicatorClass = LibraryUtils.GetLibraryClass(param4);
         }
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
         this.mLoadState = LOADSTATE_LOADING_WEB_IMAGE;
         visible = true;
         ImageUtils.LoadStoreBundleImage(this,param1,param2,Number.MAX_VALUE,Number.MAX_VALUE,param5);
         if(param3 != 0)
         {
            this.mLoadTimer = new Timer(param3,1);
            this.mLoadTimer.addEventListener(TimerEvent.TIMER,this.HandleTimeOut,false,0,true);
            this.mLoadTimer.start();
         }
      }
      
      public function LoadStoreImageWithFailureImage(param1:String, param2:String, param3:int = 2000, param4:String = "olympus.controls.LoadingIndicator", param5:String = null) : void
      {
         if(param5 == null)
         {
            param5 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         this.LocalResourceId = param2;
         this.LoadStoreImage(param1,param3,param4,param5);
      }
      
      public function LoadStoreImage(param1:String, param2:int = 2000, param3:String = "olympus.controls.LoadingIndicator", param4:String = null) : void
      {
         if(param4 == null)
         {
            param4 = ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         }
         if(!this.ShouldLoadStoreImage(param1,param4))
         {
            return;
         }
         if(param3)
         {
            loadingIndicatorClass = LibraryUtils.GetLibraryClass(param3);
         }
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
         this.mLoadState = LOADSTATE_LOADING_WEB_IMAGE;
         visible = true;
         ImageUtils.LoadStoreImage(this,param1,Number.MAX_VALUE,Number.MAX_VALUE,param4);
         if(param2 != 0)
         {
            this.mLoadTimer = new Timer(param2,1);
            this.mLoadTimer.addEventListener(TimerEvent.TIMER,this.HandleTimeOut,false,0,true);
            this.mLoadTimer.start();
         }
      }
      
      public function set LocalResourceId(param1:String) : void
      {
         this.mLocalResourceId = param1;
      }
      
      public function get LoadState() : int
      {
         return this.mLoadState;
      }
      
      public function get Success() : Boolean
      {
         return this.LoadState == LOADSTATE_LOADED_WEB_IMAGE || this.LoadState == LOADSTATE_LOADED_LOCAL_IMAGE;
      }
      
      public function LoadWebImage(param1:String) : void
      {
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
         this.mLoadState = LOADSTATE_LOADING_WEB_IMAGE;
         visible = true;
         ImageUtils.LoadWebImage(this,param1);
      }
      
      public function LoadLocalImage(param1:String) : void
      {
         visible = true;
         this.mLoadState = LOADSTATE_LOADING_LOCAL_IMAGE;
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
         LoadImage(param1);
      }
      
      public function LoadCustomImageWithFailureImage(param1:String) : void
      {
         this.LocalResourceId = param1;
         this.mLoadState = LOADSTATE_LOADING_CUSTOM_IMAGE;
         addEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false,-1,true);
         addEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false,-1,true);
      }
      
      public function RestartTimeoutTimer() : void
      {
         if(this.mLoadTimer)
         {
            this.mLoadTimer.reset();
            this.mLoadTimer.start();
         }
      }
      
      protected function ShouldLoadWebImage(param1:String) : Boolean
      {
         if(this.ShouldAddImageToQueue({"url":param1},QUEUED_IMAGE_TYPE_DEFAULT))
         {
            return false;
         }
         var _loc2_:String = ImageUtils.GetWebImageUrl(param1,imageRegion.width,imageRegion.height);
         return mLoader.resourceId != _loc2_;
      }
      
      protected function ShouldLoadBundleImageByType(param1:String, param2:String, param3:String) : Boolean
      {
         var _loc4_:Object = {
            "bundleId":param1,
            "imageType":param2,
            "groupId":param3
         };
         if(this.ShouldAddImageToQueue(_loc4_,QUEUED_IMAGE_TYPE_BUNDLE_BY_TYPE))
         {
            return false;
         }
         var _loc5_:String = ImageUtils.GetStoreBundleImageByTypeUrl(param1,param2,imageRegion.width,imageRegion.height,param3);
         return mLoader.resourceId != _loc5_;
      }
      
      protected function ShouldLoadBundleImage(param1:String, param2:String, param3:String) : Boolean
      {
         var _loc4_:Object = {
            "bundleId":param1,
            "url":param2,
            "groupId":param3
         };
         if(this.ShouldAddImageToQueue(_loc4_,QUEUED_IMAGE_TYPE_BUNDLE))
         {
            return false;
         }
         var _loc5_:String = ImageUtils.GetStoreBundleImageUrl(param1,param2,imageRegion.width,imageRegion.height,param3);
         return mLoader.resourceId != _loc5_;
      }
      
      protected function ShouldLoadStoreImage(param1:String, param2:String) : Boolean
      {
         var _loc3_:Object = {
            "url":param1,
            "groupId":param2
         };
         if(this.ShouldAddImageToQueue(_loc3_,QUEUED_IMAGE_TYPE_STORE))
         {
            return false;
         }
         var _loc4_:String = ImageUtils.GetStoreImageUrl(param1,imageRegion.width,imageRegion.height,param2);
         return mLoader.resourceId != _loc4_;
      }
      
      protected function ShouldAddImageToQueue(param1:Object, param2:int) : Boolean
      {
         if(Boolean(mLoader) && Boolean(imageRegion))
         {
            return false;
         }
         this.mQueuedImageType = param2;
         this.mbResourceLoadQueued = true;
         this.mQueuedImageData = param1;
         return true;
      }
      
      protected function LoadQueuedImage() : void
      {
         if(!this.mQueuedImageData)
         {
            return;
         }
         this.mbResourceLoadQueued = false;
         switch(this.mQueuedImageType)
         {
            case QUEUED_IMAGE_TYPE_DEFAULT:
               if(this.mLocalResourceId)
               {
                  this.LoadUrlWithFailureImage(this.mQueuedImageData["url"],this.mLocalResourceId);
               }
               else
               {
                  this.LoadUrl(this.mQueuedImageData["url"]);
               }
               break;
            case QUEUED_IMAGE_TYPE_STORE:
               if(this.mLocalResourceId)
               {
                  this.LoadStoreImageWithFailureImage(this.mQueuedImageData["url"],this.mLocalResourceId,DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
               else
               {
                  this.LoadStoreImage(this.mQueuedImageData["url"],DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
               break;
            case QUEUED_IMAGE_TYPE_BUNDLE:
               if(this.mLocalResourceId)
               {
                  this.LoadBundleImageWithFailureImage(this.mQueuedImageData["bundleId"],this.mQueuedImageData["url"],this.mLocalResourceId,DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
               else
               {
                  this.LoadBundleImage(this.mQueuedImageData["bundleId"],this.mQueuedImageData["url"],DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
               break;
            case QUEUED_IMAGE_TYPE_BUNDLE_BY_TYPE:
               if(this.mLocalResourceId)
               {
                  this.LoadBundleImageByTypeWithFailureImage(this.mQueuedImageData["bundleId"],this.mQueuedImageData["imageType"],this.mLocalResourceId,DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
               else
               {
                  this.LoadBundleImageByType(this.mQueuedImageData["bundleId"],this.mQueuedImageData["imageType"],DEFAULT_TIMEOUT_MS,LibraryUtils.LOADING_INDICATOR,this.mQueuedImageData["groupId"]);
               }
         }
         this.mQueuedImageData = null;
         this.mQueuedImageType = QUEUED_IMAGE_TYPE_DEFAULT;
      }
      
      protected function OnImageLoadComplete(param1:Event) : void
      {
         removeEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false);
         removeEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false);
         if(this.mLoadTimer)
         {
            this.mLoadTimer.stop();
         }
         switch(this.mLoadState)
         {
            case LOADSTATE_LOADING_WEB_IMAGE:
               this.mLoadState = LOADSTATE_LOADED_WEB_IMAGE;
               break;
            case LOADSTATE_LOADING_LOCAL_IMAGE:
               this.mLoadState = LOADSTATE_LOADED_LOCAL_IMAGE;
               break;
            case LOADSTATE_LOADING_CUSTOM_IMAGE:
               this.mLoadState = LOADSTATE_LOADED_CUSTOM_IMAGE;
         }
         dispatchEvent(new GenericEvent(WEB_ICON_FINISHED_EVENT,false,false,this));
      }
      
      protected function OnImageLoadFail(param1:Event) : void
      {
         if(this.mLoadTimer)
         {
            this.mLoadTimer.stop();
         }
         removeEventListener(AssetLoaderEvent.COMPLETE,this.OnImageLoadComplete,false);
         removeEventListener(AssetLoaderEvent.FAIL,this.OnImageLoadFail,false);
         if((this.mLoadState == LOADSTATE_LOADING_WEB_IMAGE || this.mLoadState == LOADSTATE_LOADING_CUSTOM_IMAGE) && Boolean(this.mLocalResourceId))
         {
            this.LoadLocalImage(this.mLocalResourceId);
         }
         else
         {
            this.mLoadState = LOADSTATE_FAILED;
            visible = false;
            dispatchEvent(new GenericEvent(WEB_ICON_FINISHED_EVENT,false,false,this));
         }
      }
      
      protected function HandleTimeOut(param1:TimerEvent) : void
      {
         if(this.mLoadState != LOADSTATE_LOADING_WEB_IMAGE)
         {
            return;
         }
         if(this.mLocalResourceId)
         {
            this.LoadLocalImage(this.mLocalResourceId);
         }
         else
         {
            this.mLoadState = LOADSTATE_FAILED_TIMEOUT;
            LoadImage(null);
            visible = false;
            dispatchEvent(new GenericEvent(WEB_ICON_FINISHED_EVENT,false,false,this));
         }
      }
   }
}

