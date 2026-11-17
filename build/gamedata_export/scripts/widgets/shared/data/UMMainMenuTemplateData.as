package widgets.shared.data
{
   import olympus.localization.KeysGE;
   import olympus.localization.LocKey;
   import olympus.utils.DateUtils;
   import widgets.shared.utils.UMUtils;
   
   public class UMMainMenuTemplateData extends EngagementSharedData
   {
      
      public var subTitle:String;
      
      public var subTitleKey:String;
      
      public var link:String;
      
      public var linkKey:String;
      
      public var linkCta:String;
      
      public var badgeStyle:String;
      
      public var badgeText:String;
      
      public var badgeTextKey:String;
      
      public var colorStyle:String;
      
      public var originalPrice:String;
      
      public var currentPrice:String;
      
      public var discountPercent:String;
      
      public var isFree:Boolean;
      
      public var isDiscounted:Boolean;
      
      public var discountBundleId:String;
      
      public var colorTheme:String;
      
      public var icon:String;
      
      public var timerPrefix:String;
      
      public var endTime:Date;
      
      public var autoScrollTime:String;
      
      public var buttonStyle:String;
      
      public function UMMainMenuTemplateData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:LocKey = null;
         if(Boolean(param1.endTime) && param1.endTime is Object)
         {
            this.endTime = DateUtils.DateDST();
         }
         super.ParseObject(param1);
         TranslateKeyFieldToStringField("subTitle");
         TranslateKeyFieldToStringField("link");
         TranslateKeyFieldToStringField("timerPrefix");
         if(this.badgeTextKey)
         {
            _loc2_ = new LocKey({"hash":this.badgeTextKey});
            if(Boolean(_loc2_) && _loc2_.IsValid())
            {
               if(Boolean(this.discountBundleId) && !this.discountPercent)
               {
                  this.badgeText = null;
               }
               else if(this.discountPercent)
               {
                  this.badgeText = _loc2_.toString(int(this.discountPercent));
               }
               else
               {
                  this.badgeText = _loc2_.toString();
               }
            }
         }
         else if(Boolean(!this.badgeText && this.isDiscounted && this.discountBundleId) && Boolean(this.discountPercent) && this.discountPercent != "0")
         {
            this.badgeText = KeysGE.LAUNCHER_CAROUSEL_BADGE_DISCOUNT.toString(int(this.discountPercent));
         }
         if(this.badgeStyle == null)
         {
            this.badgeStyle = "1";
         }
      }
      
      public function GetTimeRemaining() : Object
      {
         return UMUtils.GetTimeRemaining(this.endTime);
      }
      
      public function GetSecondsRemaining() : int
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = this.endTime.getTime();
         var _loc3_:Number = _loc1_.getTime();
         if(_loc2_ < _loc3_)
         {
            return 0;
         }
         var _loc4_:Number = _loc2_ - _loc3_;
         return _loc4_ / 1000;
      }
   }
}

