package widgets.Exchange.constants
{
   import flash.text.StyleSheet;
   import olympus.core.widget.Margin;
   
   public final class ExchangeTunables
   {
      
      public static const EXCHANGE_FILTER_CHANGED:String = "exchange_filter_changed";
      
      public static const EXCHANGE_FILTER_CLEARED:String = "exchange_filter_cleared";
      
      public static const NOTIF_ICON_SAVED:String = "7103361010188844935";
      
      public static const NOTIF_ICON_SHARED:String = "18350330437680551017";
      
      public static const NOTIF_ICON_MOBILE_DOWNLOAD:String = "4563728546842383267";
      
      public static const FOLLOWING_ENABLED:uint = 0;
      
      public static const FOLLOWING_DISABLED_TEMPORARILY:uint = 1 << 0;
      
      public static const FOLLOWING_DISABLED_BLOCKED_BY_PLAYER:uint = 1 << 1;
      
      public static const FOLLOWING_DISABLED_BLOCKED_PLAYER:uint = 1 << 2;
      
      public static const ITEM_RENDERER_ICON_GAP:Number = 10;
      
      public static const BUTTON_BAR_ITEM_RENDERER_SPACING:Number = 10;
      
      public static const DOWNLOADS_AND_FAVORITES_ICON_TEXT_SPACING:Number = 0;
      
      public static const DOWNLOADS_FAVORITES_SPACING:Number = 10;
      
      public static const DOWNLOADS_FAVORITES_MAX_COUNT:Number = 9999999;
      
      public static const SHARE_PANEL_SIZE_TIERS:Array = [{
         "width":984,
         "height":561
      },{
         "width":1206,
         "height":688
      },{
         "width":1520,
         "height":867
      },{
         "width":1753,
         "height":1010
      }];
      
      public static const PLATFORM_HIGHLIGHT_COLOR_PS4:uint = 1710361;
      
      public static const PLATFORM_HIGHLIGHT_COLOR_XB1:uint = 1710361;
      
      public static const HASH_TAG_CSS_STYLE:String = ".hashTag { color:#F05A29; textDecoration:\'none\'; } a:hover {color:#199c2c}";
      
      public static const HASH_TAG_CSS_STYLE_GREY:String = ".hashTag { color:#7b7b7b; textDecoration:\'none\'; } a:hover {color:#199c2c}";
      
      public static const HASH_TAG_CSS_STYLE_BLUE:String = ".hashTag { color:#0949AB; textDecoration:\'none\'; } a:hover {color:#199c2c}";
      
      public static const HASH_TAG_NO_CLICK_CSS_STYLE:String = ".hashTagNoClick { color:#1E81E6 }";
      
      public static const AUTOCOMPLETE_MIN_STRING_LENGTH:int = 2;
      
      public static const COMMENTS_TEXT_INPUT_EDIT_COLOR:uint = 0;
      
      public static const COMMENTS_TEXT_INPUT_STATIC_COLOR:uint = 6710886;
      
      public static const COMMENTS_TEXT_INPUT_MAX_CHARS:int = 140;
      
      public static const COMMENT_TEXT_INPUT_EDIT_MIN_NUM_LINES:int = 2;
      
      public static const COMMENT_LIST_CELL_PADDING:Margin = new Margin(0,10,0,0);
      
      public static const COMMENT_LIST_SCROLLBAR_PADDING:Margin = new Margin(5,20,0,2);
      
      public static const COMMENT_NUM_REQUEST_ITEMS:uint = 30;
      
      public static const COMMENT_LINE_HEIGHT:String = "3px";
      
      public static const COMMENT_PANEL_DISABLED_ALPHA:Number = 0.45;
      
      public static const FILTERS_MOUSE_WHEEL_SCROLL:Number = 32;
      
      public static const FILTERS_CONTENT_BY_TABS_PADDING:Margin = new Margin(0,5);
      
      public static const FILTERS_RADIO_BUTTON_PADDING:Margin = new Margin(0,0,0,-9);
      
      public static const FILTERS_LIST_CELL_PADDING:Margin = new Margin(0);
      
      public static const FILTERS_LIST_SCROLLBAR_PADDING:Margin = new Margin(2,20,2,2);
      
      public static const SEARCH_FIELD_HASHTAG_DISPLACEMENT:Number = 12;
      
      public static const SEARCH_FIELD_DROPDOWN_MARGIN:Margin = new Margin(-4,7,-1,7);
      
      public static const FILTERS_CONTEXT_INFO_ICON_PADDING:Number = 10;
      
      public static const FILTERS_DROPDOWN_RIGHT_ARROW_MARGIN:Number = 12;
      
      public static const FILTERS_PACK_CHECKBOX_PADDING:Margin = new Margin(2);
      
      public static const FILTERS_RIGHT_MARGIN:Number = -11;
      
      public static const FILTER_SEARCH_BAR_CENTRE:Number = -2000;
      
      public static const FILTERS_SEARCH_BAR_X:Array = [FILTERS_RIGHT_MARGIN,FILTER_SEARCH_BAR_CENTRE,FILTER_SEARCH_BAR_CENTRE,FILTER_SEARCH_BAR_CENTRE,FILTER_SEARCH_BAR_CENTRE];
      
      public static const FILTERS_SEARCH_BAR_Y:Array = [32,32,32,74,32];
      
      public static const FILTERS_DROPDOWN_CELLVIEW_MARGIN:Margin = new Margin(0,0,0,-4);
      
      public static const FILTERS_DROPDOWN_WIDTH_OFFSET:Number = -1;
      
      public static const FILTERS_DROPDOWN_TEXT_RIGHT_PADDING:Number = 3;
      
      public static const FILTERS_CG_CHALLENGE_DROPDOWN_X:Number = 7;
      
      public static const EXCHANGE_CREATOR_TEXT_COLOR:uint = 608683;
      
      public static const CG_CREATOR_TEXT_COLOR:uint = 16777215;
      
      public function ExchangeTunables()
      {
         super();
      }
      
      public static function GetOriginNameStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".originLink",{"color":"#F05A29"});
         _loc1_.setStyle("a:hover",{"color":"#199C2C"});
         return _loc1_;
      }
      
      public static function GetOfflineOriginNameStyleSheet() : StyleSheet
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.setStyle(".originLink",{"color":"#009933"});
         return _loc1_;
      }
   }
}

