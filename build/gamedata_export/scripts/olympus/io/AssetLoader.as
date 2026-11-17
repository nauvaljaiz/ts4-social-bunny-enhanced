package olympus.io
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import olympus.events.AssetLoaderEvent;
   import olympus.io.requests.LoadRequest;
   
   public class AssetLoader
   {
      
      protected static var mPendingLoads:Object = new Object();
      
      protected static var mLastRequestId:uint = 0;
      
      public function AssetLoader()
      {
         super();
      }
      
      public static function Load(param1:String, param2:DisplayObjectContainer, param3:Boolean = true) : String
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         if(!param1 || param1 == "null" || param1 == "0" || !param2)
         {
            return null;
         }
         if(param1 == "[object Object]" || param1.indexOf("[object Object]") != -1)
         {
            return null;
         }
         var _loc4_:Loader = new Loader();
         if(!param3)
         {
            param2.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.BEGIN));
            _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,LoadComplete);
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadFail);
         }
         else
         {
            ++mLastRequestId;
            if(mLastRequestId == 0)
            {
               ++mLastRequestId;
            }
            _loc5_ = [["rid",mLastRequestId].join("=")];
            _loc6_ = param1.indexOf("?");
            if(_loc6_ >= 0)
            {
               _loc7_ = param1.substr(_loc6_ + 1).split("&");
               for each(_loc8_ in _loc7_)
               {
                  if(_loc8_.length > 0)
                  {
                     _loc5_.push(_loc8_);
                  }
               }
               param1 = param1.substring(0,_loc6_);
            }
            param1 = param1.concat("?",_loc5_.join("&"));
            _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,LoadCompleteImage,false,0,true);
         }
         mPendingLoads[param1] = new LoadRequest(_loc4_,param2);
         _loc4_.load(new URLRequest(param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         return param1;
      }
      
      public static function FinishLoad(param1:String, param2:Boolean) : void
      {
         var _loc3_:LoadRequest = mPendingLoads[param1];
         if(_loc3_)
         {
            delete mPendingLoads[param1];
            if(_loc3_.loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
            {
               return;
            }
            if(param2)
            {
               _loc3_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.COMPLETE));
            }
            else
            {
               _loc3_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.FAIL));
            }
         }
      }
      
      public static function CancelLoad(param1:String) : Boolean
      {
         var _loc3_:LoaderInfo = null;
         var _loc2_:LoadRequest = mPendingLoads[param1];
         if(_loc2_)
         {
            delete mPendingLoads[param1];
            _loc2_.loader.close();
            _loc3_ = _loc2_.loader.contentLoaderInfo;
            _loc3_.removeEventListener(Event.COMPLETE,LoadCompleteImage);
            _loc3_.removeEventListener(IOErrorEvent.IO_ERROR,LoadFail);
            _loc2_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.CANCELLED));
            return true;
         }
         return false;
      }
      
      protected static function LoadComplete(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,LoadComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,LoadFail);
         _loc3_ = _loc2_.url.replace(".gfx",".swf");
         var _loc4_:LoadRequest = mPendingLoads[_loc3_];
         if(_loc4_ == null)
         {
            return;
         }
         delete mPendingLoads[_loc3_];
         var _loc5_:DisplayObject = _loc4_.loader.content;
         _loc4_.loader.removeChild(_loc5_);
         _loc4_.target.addChild(_loc5_);
         _loc4_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.COMPLETE));
      }
      
      protected static function LoadCompleteImage(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         _loc2_ = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,LoadCompleteImage);
         var _loc3_:DisplayObject = _loc2_.loader.content;
         var _loc4_:LoadRequest = mPendingLoads[_loc2_.url];
         if(_loc4_)
         {
            _loc2_.loader.removeChild(_loc3_);
            _loc4_.target.addChild(_loc3_);
            _loc4_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.BEGIN));
         }
      }
      
      protected static function LoadFail(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         _loc2_ = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,LoadComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,LoadFail);
         var _loc3_:LoadRequest = mPendingLoads[_loc2_.url];
         if(_loc3_ == null)
         {
            return;
         }
         delete mPendingLoads[_loc2_.url];
         _loc3_.target.removeChild(_loc3_.loader);
         _loc3_.target.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.FAIL));
      }
      
      protected static function CenterAsset(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target.content as DisplayObject;
         _loc2_.x = _loc2_.parent.width * 0.5 - _loc2_.width * 0.5;
         _loc2_.y = _loc2_.parent.height * 0.5 - _loc2_.height * 0.5;
      }
   }
}

