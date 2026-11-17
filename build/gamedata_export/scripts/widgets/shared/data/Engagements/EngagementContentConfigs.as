package widgets.shared.data.Engagements
{
   import olympus.constants.Alignment;
   import olympus.core.widget.Margin;
   import widgets.Engagement.constants.EngagementMessageTypes;
   
   public class EngagementContentConfigs
   {
      
      public static const CONFIG_OFFER_HXS1_1:int = 0;
      
      public static const CONFIG_OFFER_HS1_1:int = 1;
      
      public static const CONFIG_OFFER_HM1_1:int = 2;
      
      public static const CONFIG_OFFER_HL1_1:int = 3;
      
      public static const CONFIG_OFFER_VXS1_1:int = 4;
      
      public static const CONFIG_SPOTLIGHT_HM1_1_MIXED_MESSAGES_VXS1_1:int = 5;
      
      public static const CONFIG_SPOTLIGHT_HL1_1:int = 6;
      
      public static const CONFIG_PROMO_VL1_1:int = 7;
      
      public static const CONFIG_PROMO_VL2_1:int = 8;
      
      public static const CONFIG_PROMO_HL1_1:int = 9;
      
      public static const CONFIG_PROMO_HL2_1:int = 10;
      
      public static const CONFIG_PROMO_HXL1_1:int = 11;
      
      public static const CONFIG_PROMO_HXL2_1:int = 12;
      
      public static const CONFIG_PROMO_HM1_1:int = 13;
      
      public static const CONFIG_CATEGORY_VS1_1:int = 14;
      
      public static const CONFIG_CATEGORY_HXS1_1:int = 15;
      
      public static const CONFIG_SELECTABLE_BUNDLE_HXS1_1:int = 16;
      
      public static const CONFIG_BANNER_HL1_1:int = 17;
      
      public static const CONFIG_STORE_OFFER_GRID_VXS1_1:int = 18;
      
      public static const CONFIG_STORE_VIRTUAL_CURRENCY_OFFER_VL1:int = 19;
      
      public static const CONFIG_COMMUNICATION_HM1_1:int = 20;
      
      protected static const ALL_CONFIGS:Array = [new EngagementContentConfigData({
         "configId":CONFIG_OFFER_HXS1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":false,
         "showBundleTypeTag":false,
         "showPackTypeText":true,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"H",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "messagePanePadding":9,
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_OFFER_HS1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":false,
         "showBundleTypeTag":false,
         "showPackTypeText":true,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"H",
         "messagePaneSize":"S",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_OFFER_HM1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":true,
         "showBundleTypeTag":true,
         "showPackTypeText":false,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"H",
         "messagePaneSize":"M",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_OFFER_HL1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":true,
         "showBundleTypeTag":true,
         "showPackTypeText":false,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"H",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_OFFER_VXS1_1,
         "showAffordanceTag":false,
         "showAffordanceBadge":false,
         "showBundleTags":false,
         "showBundleTypeTag":false,
         "showPackTypeText":true,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"V",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_SPOTLIGHT_HM1_1_MIXED_MESSAGES_VXS1_1,
         "showAffordanceTag":false,
         "showAffordanceBadge":false,
         "showBundleTags":true,
         "showBundleTypeTag":true,
         "showPackTypeText":false,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"V",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_SPOTLIGHT_HL1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":true,
         "showBundleTypeTag":true,
         "showPackTypeText":false,
         "messagePaneType":EngagementMessageTypes.TYPE_SPOTLIGHT,
         "messagePaneOrientation":"H",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_VL1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"V",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_VL2_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"V",
         "messagePaneSize":"L",
         "messagePaneLayout":"2",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_HL1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"H",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_HL2_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"H",
         "messagePaneSize":"L",
         "messagePaneLayout":"2",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_HXL1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"H",
         "messagePaneSize":"XL",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_PROMO_HXL2_1,
         "messagePaneType":EngagementMessageTypes.TYPE_PROMO,
         "messagePaneOrientation":"H",
         "messagePaneSize":"XL",
         "messagePaneLayout":"2",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_CATEGORY_VS1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_CATEGORY,
         "messagePaneOrientation":"V",
         "messagePaneSize":"S",
         "messagePaneLayout":"1",
         "layoutGridMaxColumns":6,
         "layoutGridAlignment":Alignment.CENTER,
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_CATEGORY_HXS1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_CATEGORY,
         "messagePaneOrientation":"H",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "layoutGridMaxColumns":5,
         "layoutGridAlignment":Alignment.CENTER,
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_SELECTABLE_BUNDLE_HXS1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_BUNDLE,
         "messagePaneOrientation":"H",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "layoutGridMaxColumns":5,
         "bUsesMessagePanes":true,
         "layoutInnerMargin":Margin.TopRightBottomLeft(0,0,0,24)
      }),new EngagementContentConfigData({
         "configId":CONFIG_BANNER_HL1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showBundleTags":true,
         "showBundleTypeTag":true,
         "messagePaneType":EngagementMessageTypes.TYPE_BANNER,
         "messagePaneOrientation":"H",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true,
         "layoutInnerMargin":Margin.Uniform(0)
      }),new EngagementContentConfigData({
         "configId":CONFIG_STORE_OFFER_GRID_VXS1_1,
         "showAffordanceTag":true,
         "showAffordanceBadge":true,
         "showPackTypeText":true,
         "messagePaneType":EngagementMessageTypes.TYPE_OFFER,
         "messagePaneOrientation":"V",
         "messagePaneSize":"XS",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_STORE_VIRTUAL_CURRENCY_OFFER_VL1,
         "messagePaneType":EngagementMessageTypes.TYPE_STORE_VIRTUAL_CURRENCY_OFFER,
         "messagePaneOrientation":"V",
         "messagePaneSize":"L",
         "messagePaneLayout":"1",
         "layoutGridMaxColumns":6,
         "layoutGridAlignment":Alignment.CENTER,
         "layoutInnerMargin":Margin.TopRightBottomLeft(0,24 + 13.9,0,24 + 19.5),
         "bUsesMessagePanes":true
      }),new EngagementContentConfigData({
         "configId":CONFIG_COMMUNICATION_HM1_1,
         "messagePaneType":EngagementMessageTypes.TYPE_COMMUNICATION,
         "messagePaneOrientation":"H",
         "messagePaneSize":"M",
         "messagePaneLayout":"1",
         "bUsesMessagePanes":true
      })];
      
      public function EngagementContentConfigs()
      {
         super();
      }
      
      public static function GetEngagementContentConfigDataById(param1:int) : EngagementContentConfigData
      {
         var _loc4_:EngagementContentConfigData = null;
         if(param1 == EngagementContentConfigData.CONFIG_ID_INVALID)
         {
            return null;
         }
         var _loc2_:int = int(ALL_CONFIGS.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = ALL_CONFIGS[_loc3_];
            if(_loc4_.configId == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

