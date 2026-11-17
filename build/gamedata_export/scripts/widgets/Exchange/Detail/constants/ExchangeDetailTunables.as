package widgets.Exchange.Detail.constants
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.widget.Margin;
   import olympus.localization.KeysEXCH;
   import olympus.motion.TweenParams;
   
   public final class ExchangeDetailTunables
   {
      
      public static const THUMBNAIL_LIST_CELL_PADDING:Margin = new Margin(-3,8,11,12);
      
      public static const BLUEPRINT_MAX_ROOMS:int = 9;
      
      public static const ROOM_NUM_THUMBNAIL_OPTIONS:int = 4;
      
      public static const INFO_PANEL_DATA_CLIP_PADDING:Number = 2;
      
      public static const INFO_PANEL_DATA_PADDING:Number = 6;
      
      public static const INFO_PANEL_VALUE_COLOR:uint = 608683;
      
      public static const INFO_PANEL_SCROLLBAR_PADDING:Margin = new Margin(5,20,5,5);
      
      public static const INFO_PANEL_SIM_REL_TOOLTIP_BORDER_PADDING:Number = 5;
      
      public static const INFO_PANEL_SIM_REL_TOOLTIP_CELL_PADDING:Margin = new Margin(0);
      
      public static const OPTION_BUTTON_PADDING:Number = 4;
      
      public static const BUY_APPLY_BUTTON_PADDING:Number = 7;
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_ADULT:Rectangle = new Rectangle(-131,-21,450,270);
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_ADULT_MERMAID:Rectangle = new Rectangle(-40,-20,272,148);
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_CHILD:Rectangle = new Rectangle(-154,-61,500,300);
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_SMALL_PET:Rectangle = new Rectangle(-159,-105,500,300);
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_DOG:Rectangle = new Rectangle(-169,-76,500,300);
      
      public static const SIM_THUMB_PREVIEW_IMAGE_REGION_BABY_PET:Rectangle = new Rectangle(-154,-118,500,300);
      
      public static const MTX_PACK_LIST_CELL_PADDING:Margin = new Margin(0,1,0,0);
      
      public static const MTX_PACK_LIST_SCROLLBAR_PADDING:Margin = new Margin(5,20,5,5);
      
      public static const MTX_PACK_LIST_MAX_VISIBLE:int = 14;
      
      public static const MTX_PACK_LIST_TWEEN_DURATION:int = 800;
      
      public static const MTX_PACK_DETAIL_LINK_CSS_STYLE:String = ".exchPackDetail { color:#F05A29 } a:hover { color:#199C2C }";
      
      public static const MTX_PACK_PRICE_COLOR_UNPURCHASED:uint = 1999334;
      
      public static const MTX_PACK_PRICE_COLOR_PURCHASED:uint = 1678380;
      
      public static const MTX_PACK_PRICE_COLOR_NOT_PURCHASABLE:uint = 8882055;
      
      public static const MTX_PACK_DISCOUNT_PRICE_PADDING:Number = 5;
      
      public static const IN_ANIMATION_REG_POINT:Point = new Point(0.5,0.5);
      
      public static const OUT_ANIMATION_REG_POINT:Point = new Point(0.5,0.2);
      
      public static const BED_DROPDOWN_MENU_OFFSET:Margin = new Margin(-3,4,0,8);
      
      public static const BATH_DROPDOWN_MENU_OFFSET:Margin = new Margin(-3,4,0,8);
      
      public static const BED_DROPDOWN_SCROLLBAR_MARGIN:Margin = new Margin(0,12,0,0);
      
      public static const BATH_DROPDOWN_SCROLLBAR_MARGIN:Margin = new Margin(0,12,0,0);
      
      public static const MODDED_ICON_TWEEN_IN:TweenParams = TweenParams.TweenParam().Duration(100).StartProps({"alpha":0}).EndProps({"alpha":1});
      
      public static const MODDED_ICON_TWEEN_OUT:TweenParams = TweenParams.TweenParam().Duration(100).StartProps({"alpha":1}).EndProps({"alpha":0});
      
      public static const CONTENT_SCROLL_SPEED:Number = 10;
      
      public static const SAVE_TO_LIBRARY_MINIMUM_ANIMATION_TIME:int = 3000;
      
      public static const SUBMISSION_CHECKBOX_WIDTH:Number = 200;
      
      public static const CG_VOTING_TIME_LEFT_REFRESH_INTERVAL:uint = 1000;
      
      public static const CG_VOTING_CANDIDATES_PER_SET:uint = 24;
      
      public static const CG_VOTING_LOADING_MINIMUM_WAIT_TIME:int = 3;
      
      public static const EXCHANGE_TIMEOUT_TIMER:int = 60000;
      
      public static const ALL_EXCHANGE_THUMBS_LOADED:String = "ExchangeAllThumbnailsLoaded";
      
      public static const EXCHANGE_DETAIL_CELL_THUMB_LOADED:String = "DetailCellThumbnailLoaded";
      
      public static const TAB_DATA_PACKS:Object = {
         "name":KeysEXCH.DETAIL_LABEL_MTX_PACK_TITLE.toString(),
         "className":"widgets.Exchange.Detail.controls.TabContentPanel.DetailTabContentPanelPacks"
      };
      
      public static const TAB_DATA_ITEMS:Object = {
         "name":KeysEXCH.PACK_DETAIL_LABEL_SHOW_USED_ITEMS.toString(),
         "className":"widgets.Exchange.Detail.controls.TabContentPanel.DetailTabContentPanelItemsUsed"
      };
      
      public static const TAB_DATA_INFO:Object = {
         "name":KeysEXCH.DETAIL_LABEL_TAB_INFO.toString(),
         "className":"widgets.Exchange.Detail.controls.TabContentPanel.DetailTabContentPanelInfo"
      };
      
      public static const TAB_DATA_COMMENTS:Object = {
         "name":KeysEXCH.DETAIL_LABEL_TAB_COMMENTS.toString(),
         "className":"widgets.Exchange.Detail.controls.TabContentPanel.DetailTabContentPanelComments"
      };
      
      public static const GALLERY_UNOWNED_PACK:int = 0;
      
      public static const GALLERY_UNOWNED_UCG_BUNDLE:int = 1;
      
      public static const GALLERY_OWNED_PACK:int = 2;
      
      public static const GALLERY_OWNED_UCG_BUNDLE:int = 3;
      
      public static const GALLERY_DETAIL_TAB_TXT_MESSAGE_TOP_PADDING:Number = 18;
      
      public static const GALLERY_DETAIL_TAB_CONTENT_TOP_PADDING:Number = 2;
      
      public static const GALLERY_DETAIL_INFO_CELL_VIEW_GROUP_PADDING:Number = 20;
      
      public static const GALLERY_DETAIL_TAB_TXT_MESSAGE_BOTTOM_PADDING:Number = 20;
      
      public static const GALLERY_DETAIL_TAB_SECTIONS_PADDING:Margin = new Margin(0,2,6,0);
      
      public static const GALLERY_DETAIL_SECTION_SCROLL_VIEW_CELL_PADDING:Margin = new Margin(4,6,6,0);
      
      public static const GALLERY_DETAIL_SECTION_SCROLL_VIEW_CELL_PADDING_NO_TEXT:Margin = new Margin(0,5,1,0);
      
      public static const GALLERY_DETAIL_SECTION_SCROLL_VIEW_X_PADDING:Number = 1;
      
      public static const GALLERY_DETAIL_SECTION_HEADER_Y_PADDING:Number = 2;
      
      public static const GALLERY_DETAIL_USED_ITEMS_PER_ROW:int = 6;
      
      public static const GALLERY_DETAIL_PACKS_PER_ROW:int = 4;
      
      public static const GALLERY_DETAIL_PACKS_PER_ROW_NO_TEXTFIELD:int = 14;
      
      public static const GALLERY_DETAIL_MARKETPLACE_PRODUCTS_RESPONSE_TIMEOUT:Number = 2000;
      
      public static const CATEGORY_BUMPER_HORIZONTAL_OFFSET:Point = new Point(12,5);
      
      public function ExchangeDetailTunables()
      {
         super();
      }
   }
}

