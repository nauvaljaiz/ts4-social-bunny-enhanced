package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import olympus.data.ArrayDataFeed;
   import olympus.interfaces.IView;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol59")]
   public class SocialMediaFeedTabPanel extends SocialMediaTabPanelBase
   {
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcFeedPanelFTUE:MovieClip;
      
      protected var mFeedData:ArrayDataFeed;
      
      public function SocialMediaFeedTabPanel()
      {
         super();
      }
      
      override public function Initialize() : void
      {
         this.mFeedData = new ArrayDataFeed();
         var _loc1_:GridLayout = new GridLayout(false,true,1);
         mcList.mSlider.AlwaysVisible = false;
         mcList.InitializeScrollList(this.mFeedData,SocialMediaFeedCellView,SocialMediaTunables.FEED_LIST_CELL_PADDING,SocialMediaTunables.FEED_SCROLLBAR_PADDING,_loc1_);
         this.txtEmptyStateTitle.htmlText = KeysGP.SOCIAL_MEDIA_FEED_EMPTY_STATE_TITLE.toString();
         this.txtEmptyStateTitle.visible = false;
         this.txtEmptyStateDescription.htmlText = KeysGP.SOCIAL_MEDIA_FEED_EMPTY_STATE_DESCRIPTION.toString();
         this.txtEmptyStateDescription.visible = false;
         this.mcFeedPanelFTUE.visible = false;
         super.Initialize();
      }
      
      override public function OnShow(param1:Array) : void
      {
         this.mFeedData.RemoveAllItems();
         var _loc2_:Array = param1.concat();
         this.mFeedData.AddItemsFromIterable(_loc2_.reverse());
         this.RefreshLayout();
      }
      
      override public function OnTabShow(param1:Array) : void
      {
         this.mFeedData.RemoveAllItems();
         var _loc2_:Array = param1.concat();
         this.mFeedData.AddItemsFromIterable(_loc2_.reverse());
         this.RefreshLayout();
      }
      
      override public function OnTabHide() : void
      {
         this.CloseReactionPopUps();
      }
      
      protected function RefreshLayout() : void
      {
         if(this.mFeedData.length < 1)
         {
            this.txtEmptyStateTitle.visible = true;
            this.txtEmptyStateDescription.visible = true;
            this.mcFeedPanelFTUE.visible = true;
         }
         else
         {
            this.txtEmptyStateTitle.visible = false;
            this.txtEmptyStateDescription.visible = false;
            this.mcFeedPanelFTUE.visible = false;
            mcBackground.height = SocialMediaTunables.FEED_TAB_PANEL_HEIGHT;
            mcList.height = mcBackground.height - SocialMediaTunables.FEED_TAB_PANEL_MARGINS.Vertical;
            mcList.width = mcBackground.width - SocialMediaTunables.FEED_TAB_PANEL_MARGINS.Horizontal;
         }
      }
      
      public function CloseReactionPopUps() : void
      {
         var _loc2_:IView = null;
         var _loc3_:SocialMediaFeedCellView = null;
         if(!mcList || !mcList.mGridLayout)
         {
            return;
         }
         var _loc1_:Vector.<IView> = mcList.mGridLayout.GetAllCells();
         if(!_loc1_)
         {
            return;
         }
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = _loc2_ as SocialMediaFeedCellView;
            if(_loc3_)
            {
               _loc3_.RemoveReactionPopUp();
            }
         }
      }
   }
}

