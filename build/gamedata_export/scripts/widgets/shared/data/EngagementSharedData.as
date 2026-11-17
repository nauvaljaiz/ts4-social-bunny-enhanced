package widgets.shared.data
{
   import flash.display.MovieClip;
   import gamedata.MTX.BundlePurchaseData;
   import olympus.controls.WebIconComponent;
   import olympus.objects.UMBaseData;
   import olympus.utils.ImageUtils;
   import olympus.utils.LibraryUtils;
   
   public class EngagementSharedData extends UMMainMenuTemplateBaseData
   {
      
      public var title:String;
      
      public var titleKey:String;
      
      public var description:String;
      
      public var descriptionKey:String;
      
      public var imageUrl:String;
      
      public var imageUrlKey:String;
      
      public var featureImageUrl:String;
      
      public var videoUrl:String;
      
      public var imageGroupId:String;
      
      public var buttonText:String;
      
      public var buttonTextKey:String;
      
      public var buttonCta:String;
      
      public var buttonCtaIconUrl:String;
      
      public var childFriendly:Boolean;
      
      public var incentiveAffordances:Array = [IncentiveAffordanceData];
      
      public var bundleId:String;
      
      public var bundlePurchaseData:BundlePurchaseData;
      
      public function EngagementSharedData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1.hasOwnProperty("bundlePurchaseData"))
         {
            this.bundlePurchaseData = new BundlePurchaseData();
         }
         super.ParseObject(param1);
         TranslateKeyFieldToStringField("title");
         TranslateKeyFieldToStringField("description");
         TranslateKeyFieldToStringField("buttonText");
         FixupArray(this.incentiveAffordances);
      }
      
      public function LoadImage(param1:MovieClip, param2:Function, param3:String, param4:int, param5:Boolean = true, param6:String = null, param7:String = null) : Boolean
      {
         var _loc13_:String = null;
         if(!param1)
         {
            return false;
         }
         var _loc8_:WebIconComponent = param1.mcImage as WebIconComponent;
         if(!_loc8_)
         {
            return false;
         }
         var _loc9_:String = param6 ? param6 : this.imageUrl;
         var _loc10_:String = param7 != null ? param7 : this.imageUrlKey;
         var _loc11_:String = param5 ? LibraryUtils.LOADING_INDICATOR : null;
         var _loc12_:String = this.imageGroupId ? this.imageGroupId : ImageUtils.URL_STORE_EMPTY_GROUP_ID;
         if(Boolean(param1.mcImage) && (!_loc9_ && !_loc10_ && !param3 && !this.bundleId))
         {
            param1.visible = false;
            return false;
         }
         if(Boolean(param2))
         {
            _loc8_.addEventListener(WebIconComponent.WEB_ICON_FINISHED_EVENT,param2,false,0,true);
         }
         if(this.bundleId != null)
         {
            if(param6 != null)
            {
               _loc8_.visible = true;
               if(param3)
               {
                  _loc8_.LoadBundleImageWithFailureImage(this.bundleId,param6,param3,param4,_loc11_,_loc12_);
               }
               else
               {
                  _loc8_.LoadBundleImage(this.bundleId,param6,param4,_loc11_,_loc12_);
               }
            }
            else
            {
               switch(layout_orientation)
               {
                  case "V":
                     _loc13_ = ImageUtils.STORE_THUMBNAIL_PORTRAIT;
                     break;
                  case "H":
                     _loc13_ = ImageUtils.STORE_THUMBNAIL_LANDSCAPE;
                     break;
                  default:
                     _loc13_ = ImageUtils.STORE_THUMBNAIL_FEATURE;
               }
               _loc8_.visible = true;
               if(param3)
               {
                  _loc8_.LoadBundleImageByTypeWithFailureImage(this.bundleId,_loc13_,param3,param4,_loc11_,_loc12_);
               }
               else
               {
                  _loc8_.LoadBundleImageByType(this.bundleId,_loc13_,param4,_loc11_,_loc12_);
               }
            }
            return true;
         }
         if(_loc9_)
         {
            if(_loc10_)
            {
               param3 = _loc10_;
            }
            _loc8_.visible = true;
            if(source == UMBaseData.DATA_SOURCE_AMP)
            {
               if(param3)
               {
                  _loc8_.LoadStoreImageWithFailureImage(_loc9_,param3,param4,_loc11_,_loc12_);
               }
               else
               {
                  _loc8_.LoadStoreImage(_loc9_,param4,_loc11_,_loc12_);
               }
            }
            else if(param3)
            {
               _loc8_.LoadUrlWithFailureImage(_loc9_,param3,param4,_loc11_);
            }
            else
            {
               _loc8_.LoadUrl(_loc9_,param4,_loc11_);
            }
            return true;
         }
         if(_loc10_)
         {
            _loc8_.visible = true;
            _loc8_.LoadImage(_loc10_);
            return true;
         }
         if(param3)
         {
            _loc8_.visible = true;
            _loc8_.LoadUrlWithFailureImage(_loc9_,param3,param4,_loc11_);
            return true;
         }
         _loc8_.visible = false;
         return false;
      }
   }
}

