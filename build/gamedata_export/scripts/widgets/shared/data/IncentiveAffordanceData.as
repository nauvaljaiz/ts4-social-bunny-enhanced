package widgets.shared.data
{
   import olympus.constants.GameStates;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.objects.UMBaseData;
   import olympus.utils.DateUtils;
   import widgets.shared.constants.IncentiveAffordanceDataTunables;
   import widgets.shared.data.TimerTextConfig.TimerTextConfig;
   
   public class IncentiveAffordanceData extends UMBaseData implements ITagComponentData, IPopupToasterData, IBadgeComponentData
   {
      
      public static const AFFORDANCE_TYPE_UNKNOWN:int = 0;
      
      public static const AFFORDANCE_TYPE_NOTIFICATION:int = 1;
      
      public static const AFFORDANCE_TYPE_TOASTIE:int = 2;
      
      public static const AFFORDANCE_TYPE_AUTOSALETOASTIE:int = 3;
      
      public static const AFFORDANCE_TYPE_TAG:int = 4;
      
      public static const AFFORDANCE_TYPE_BADGE:int = 5;
      
      public static const AFFORDANCE_TYPE_CALLOUT:int = 6;
      
      public static const AFFORDANCE_PERSISTENCE_UNKNOWN:int = 0;
      
      public static const AFFORDANCE_PERSISTENCE_ONCE:int = 1;
      
      public static const AFFORDANCE_PERSISTENCE_SESSION:int = 2;
      
      public static const AFFORDANCE_PERSISTENCE_PERMANENT:int = 3;
      
      protected static const MINIMUM_DISCOUNT_FOR_SALE:int = 10;
      
      public var affordanceType:int = 0;
      
      public var id:String;
      
      public var style:String;
      
      public var styleLabel:String;
      
      public var maxWidth:Number = 0;
      
      public var layout:String;
      
      public var anchorAlignment:String;
      
      public var text:String;
      
      public var textKey:String;
      
      public var iconResource:String;
      
      public var iconUrl:String;
      
      public var timeTextConfigName:String;
      
      public var endTime:Date = DateUtils.DateDST();
      
      public var discountText:String;
      
      public var discountTextKey:String;
      
      public var discountBundleId:String;
      
      public var discountPercent:String;
      
      public var originalPrice:String;
      
      public var currentPrice:String;
      
      public var isFree:Boolean;
      
      public var isDiscounted:Boolean;
      
      public var duration:uint = 0;
      
      public var persistence:int = 0;
      
      public var gameStates:Array = [uint];
      
      public function IncentiveAffordanceData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.gameStates);
         TranslateKeyFieldToStringField("text");
         TranslateKeyFieldToStringField("discountText");
      }
      
      public function get SaleText() : String
      {
         var _loc3_:LocKey = null;
         if(this.discountTextKey == null || this.discountPercent == null)
         {
            return null;
         }
         var _loc1_:String = null;
         var _loc2_:int = int(this.discountPercent);
         if(_loc2_ > MINIMUM_DISCOUNT_FOR_SALE)
         {
            _loc3_ = new LocKey({"hash":this.discountTextKey});
            if(_loc3_.IsValid())
            {
               _loc1_ = _loc3_.toString(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get TimeText() : String
      {
         var _loc1_:TimerTextConfig = null;
         if(this.endTime == null || this.endTime.time == 0)
         {
            return null;
         }
         if(Boolean(this.timeTextConfigName) && IncentiveAffordanceDataTunables.TIMER_TEXT_CONFIGS.hasOwnProperty(this.timeTextConfigName))
         {
            _loc1_ = IncentiveAffordanceDataTunables.TIMER_TEXT_CONFIGS[this.timeTextConfigName];
         }
         if(_loc1_ == null)
         {
            _loc1_ = IncentiveAffordanceDataTunables.TIMER_TEXT_CONFIGS["default"];
         }
         var _loc2_:Object = _loc1_.ProcessTime(this.endTime);
         if(Boolean(_loc2_) && _loc2_.state != TimerTextConfig.DISPLAY_TYPE_ERROR)
         {
            return _loc2_.text;
         }
         return null;
      }
      
      public function get BasicText() : String
      {
         return this.text;
      }
      
      public function get Text() : String
      {
         var _loc4_:String = null;
         var _loc1_:String = this.TimeText;
         var _loc2_:String = this.SaleText;
         var _loc3_:String = this.text;
         if(Boolean(_loc2_) && Boolean(_loc1_))
         {
            _loc4_ = Keys.GENERIC_NEWLINE.toString(_loc2_,_loc1_);
         }
         else if(_loc2_)
         {
            _loc4_ = _loc2_;
         }
         else if(_loc1_)
         {
            _loc4_ = _loc1_;
         }
         if(_loc3_)
         {
            if(_loc4_)
            {
               _loc4_ = Keys.GENERIC_NEWLINE.toString(_loc3_,_loc4_);
            }
            else
            {
               _loc4_ = _loc3_;
            }
         }
         return _loc4_;
      }
      
      public function IsValidForGameState(param1:uint = 0) : Boolean
      {
         if(!this.gameStates || this.gameStates.length == 0)
         {
            return true;
         }
         if(param1 == GameStates.UNKNOWN)
         {
            param1 = CommunicationManager.CallGameService("GetGameState",null) as uint;
         }
         var _loc2_:int = this.gameStates.indexOf(param1);
         return _loc2_ != -1;
      }
      
      public function get Icon() : String
      {
         return this.iconResource;
      }
      
      public function get IconUrl() : String
      {
         return this.iconUrl;
      }
      
      public function get Duration() : uint
      {
         return this.duration;
      }
      
      public function get MaxTextWidth() : Number
      {
         return this.maxWidth;
      }
      
      public function get Style() : String
      {
         return this.style;
      }
      
      public function get Layout() : String
      {
         return this.layout;
      }
   }
}

