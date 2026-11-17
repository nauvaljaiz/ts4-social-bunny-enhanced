package widgets.shared.constants
{
   import flash.geom.Point;
   import flash.text.StyleSheet;
   import flash.text.TextFormatAlign;
   import olympus.audio.Audio;
   import olympus.core.widget.Margin;
   import olympus.motion.Easing;
   import olympus.motion.TweenParams;
   
   public final class GlobalTunables
   {
      
      public static const SHARING_TEXT_CHARS_MAX:int = 140;
      
      public static const GAMETRAY_HEADER_HEIGHT:Number = 0;
      
      public static const GAMETRAY_HEADER_CONFIG_PANEL_HEIGHT:Number = 33;
      
      public static const GAMETRAY_FOOTER_HEIGHT:Number = 0;
      
      public static const GAME_SPEED_PAUSE:int = 0;
      
      public static const GAME_SPEED_ONE:int = 1;
      
      public static const GAME_SPEED_TWO:int = 2;
      
      public static const GAME_SPEED_THREE:int = 3;
      
      public static const WALLET_FLY_AWAY_TEXT_X_OFFSET:Number = 50;
      
      public static const WALLET_FLY_AWAY_TEXT_Y_OFFSET:Number = -10;
      
      public static const ARCMENU_FADE_OUT_DELAY:Number = 250;
      
      public static const ARCMENU_FADE_IN_DELAY:Number = 500;
      
      public static const PANEL_DROP_SHADOW_MARGIN:Margin = new Margin(3,6,8,6);
      
      public static const FADE_OUT_TWEEN:TweenParams = TweenParams.TweenParam().AudioStyleName(Audio.PANEL_SLIDE_OUT).Duration(400).Ease(Easing.easeOutCubic).GameSpeedDependent(true);
      
      public static const FADE_IN_TWEEN:TweenParams = TweenParams.TweenParam().AudioStyleName(Audio.PANEL_SLIDE_IN).Duration(400).Ease(Easing.easeOutCubic).GameSpeedDependent(true);
      
      public static const FADE_OUT_MARGIN:Margin = new Margin(4);
      
      public static const DICE_FADE_OUT_DELAY:int = 100;
      
      public static const STYLE_SHEET_GENERIC:Object = {
         ".default":{
            "color":"#0949AB",
            "fontFamily":"$TextFont",
            "fontSize":12
         },
         ".title":{
            "fontFamily":"$BoldHeadlineFont",
            "color":"#0949AB",
            "fontSize":26
         },
         ".header":{
            "color":"#0949AB",
            "fontFamily":"$SubtitleFont",
            "fontSize":12,
            "fontWeight":"bold"
         },
         ".money":{
            "color":"#199C2C",
            "fontFamily":"$TextFont",
            "fontSize":12
         },
         ".time":{
            "color":"#199C2C",
            "fontFamily":"$TextFont",
            "fontSize":12
         },
         ".rarity":{
            "color":"#AE3CDE",
            "fontFamily":"$TextFont",
            "fontSize":12
         },
         ".warning":{
            "color":"#EC262E",
            "fontFamily":"$TextFont",
            "fontSize":12
         }
      };
      
      public static const ITEMS_PER_ROW:int = 7;
      
      public static const ITEM_MARGIN:Margin = new Margin(3,3);
      
      public static const COLLECTION_ITEMS_PER_ROW:int = 7;
      
      public static const COLLECTION_LEGEND_LABEL_MAX_WIDTH:int = 300;
      
      public static const COLLECTION_LEGEND_X_OFFSET:Number = 30;
      
      public static const COLLECTION_LEGEND_Y_OFFSET:Number = 30;
      
      public static const MAX_NUMBER_COLOR_VARIATIONS:int = 23;
      
      public static const VARIATION_GRID_SCROLLER_VIEW_MARGIN:Margin = Margin.TopRightBottomLeft(0,1,0,0);
      
      public static const VARIATION_GRID_MASK_MARGIN:int = 5;
      
      public static const ASPIRATION_TOOLTIP_TOP_MARGIN:Number = 10;
      
      public static const ASPIRATION_TOOLTIP_BOTTOM_MARGIN:Number = 15;
      
      public static const ASPIRATION_TOOLTIP_TEXT_SPACING:Number = 3;
      
      public static const ASPIRATION_TOOLTIP_BLOCK_SPACING:Number = 5;
      
      public static const RESOLUTION_MED:Point = new Point(1366,768);
      
      public static const RESOLUTION_LARGE:Point = new Point(1530,900);
      
      public static const RESOLUTION_XLARGE:Point = new Point(1920,1080);
      
      public static const RESOLUTION_INDEX_SMALL:int = 0;
      
      public static const RESOLUTION_INDEX_MED:int = 1;
      
      public static const RESOLUTION_INDEX_LARGE:int = 2;
      
      public static const RESOLUTION_INDEX_XLARGE:int = 3;
      
      public static const MAXIMUM_FUNDS:uint = 9999999;
      
      public static const FUNDS_NEGATIVE_COLOR:uint = 15476270;
      
      public static const FUNDS_POSITIVE_COLOR:uint = 1678380;
      
      public static const MAX_NUM_SAVE_SLOTS_CONSOLE:uint = 10;
      
      public static const COLOR_SELECTOR_NUM_COLORS_PER_ROW:int = 6;
      
      public static const COLOR_SELECTOR_CELL_MARGIN:Margin = new Margin(1,1,3,2);
      
      public static const COLOR_SELECTOR_GRID_MARGIN:Margin = new Margin(4,6,5,2);
      
      public static const COLOR_SELECTOR_COLORS:Array = [6590463,14427775,15787074,8078018,9882702,16750592,5059830,16711680,16449280,9240831,65419,16758784,11858682,16303353,16316566,11963882,11860168,15716262,2328212,8670541,8681268,0,5280350,11309432];
      
      public static const KINGDOM_TITLES_MAX_TITLE_LENGTH:int = 18;
      
      public function GlobalTunables()
      {
         super();
      }
      
      public static function GetGenericLabelStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#0949AB"});
         _loc1_.setStyle(".value",{"color":"#1e81e6"});
         _loc1_.setStyle(".bonus",{"color":"#ec1c24"});
         return _loc1_;
      }
      
      public static function GetGenericLabelOverStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#0949AB"});
         _loc1_.setStyle(".value",{"color":"#1E81E6"});
         _loc1_.setStyle(".bonus",{"color":"#ec1c24"});
         return _loc1_;
      }
      
      public static function GetGenericLabelSelectedStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#FFFFFF"});
         _loc1_.setStyle(".value",{"color":"#d6f9c1"});
         _loc1_.setStyle(".bonus",{"color":"#ec1c24"});
         return _loc1_;
      }
      
      public static function GetGenericLinkStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".link",{"color":"#F05A29"});
         _loc1_.setStyle("a:hover",{"color":"#199C2C"});
         return _loc1_;
      }
      
      public static function GetMainMenuTextLinkStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".link",{"color":"#1400b4"});
         _loc1_.setStyle("a:hover",{"color":"#199C2C"});
         _loc1_.setStyle("textAlign",TextFormatAlign.CENTER);
         return _loc1_;
      }
      
      public static function GetCompletedLabelUpStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#967101"});
         _loc1_.setStyle(".value",{"color":"#B08B1C"});
         _loc1_.setStyle(".bonus",{"color":"#CC6666"});
         return _loc1_;
      }
      
      public static function GetCompletedLabelOverStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#c29713"});
         _loc1_.setStyle(".value",{"color":"#cda52b"});
         _loc1_.setStyle(".bonus",{"color":"#CC6666"});
         return _loc1_;
      }
      
      public static function GetCompletedLabelSelectedStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".label",{"color":"#967101"});
         _loc1_.setStyle(".value",{"color":"#B08B1C"});
         _loc1_.setStyle(".bonus",{"color":"#CC6666"});
         return _loc1_;
      }
      
      public static function GetGenericPositiveNegativeStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".positive",{"color":"#199C2C"});
         _loc1_.setStyle(".negative",{"color":"#EC262E"});
         return _loc1_;
      }
      
      public static function GetBatuuFactionStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".firstorder",{"color":"#7E0D0E"});
         _loc1_.setStyle(".resistance",{"color":"#165F69"});
         _loc1_.setStyle(".scoundrel",{"color":"#6C571B"});
         _loc1_.setStyle(".batuuan",{"color":"#7426AD"});
         return _loc1_;
      }
      
      public static function DetermineSizeTier(param1:Number, param2:Number) : int
      {
         if(param1 >= RESOLUTION_XLARGE.x && param2 >= RESOLUTION_XLARGE.y)
         {
            return RESOLUTION_INDEX_XLARGE;
         }
         if(param1 >= RESOLUTION_LARGE.x && param2 >= RESOLUTION_LARGE.y)
         {
            return RESOLUTION_INDEX_LARGE;
         }
         if(param1 >= RESOLUTION_MED.x && param2 >= RESOLUTION_MED.y)
         {
            return RESOLUTION_INDEX_MED;
         }
         return RESOLUTION_INDEX_SMALL;
      }
   }
}

