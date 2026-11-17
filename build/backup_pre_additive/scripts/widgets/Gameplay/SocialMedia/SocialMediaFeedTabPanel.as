package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import olympus.controls.IconComponent;
   import olympus.data.ArrayDataFeed;
   import olympus.interfaces.IView;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import olympus.utils.ImageUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol59")]
   public class SocialMediaFeedTabPanel extends SocialMediaTabPanelBase
   {
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcFeedPanelFTUE:MovieClip;
      
      protected var mFeedData:ArrayDataFeed;

      private static var sComposeType:String = "text";
      
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

      // === SOCIAL BUNNY VERIFIED HOME FEED RENDERER ===
      public static function RenderSBVHome(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var y:Number = 8;
         var cardW:Number = 512;

         // 1. Sub-filter bar (For You / Following / Verified / Trending / Native)
         var curFilter:String = state && state.feed_filter ? String(state.feed_filter) : "for_you";
         var filters:Array = [
            {"id":"for_you","label":"For You"},
            {"id":"following","label":"Following"},
            {"id":"verified","label":"Verified"},
            {"id":"trending","label":"Trending"}
         ];
         var fx:Number = 8;
         var fIdx:int = 0;
         while(fIdx < filters.length)
         {
            var fObj:Object = filters[fIdx];
            var active:Boolean = (curFilter == fObj.id);
            var fBtn:Sprite = MakeFilterButton(simId,fObj.id,fObj.label,active);
            fBtn.x = fx;
            fBtn.y = y;
            canvas.addChild(fBtn);
            fx += 88;
            fIdx++;
         }
         var nativeBtn:Sprite = SocialMediaTunables.CreateButton(
            "Native Feed",
            92,
            26,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_TEXT_PRIMARY,
            OnFeedBtnClick,
            10,
            SocialMediaTunables.COL_BORDER,
            {"kind":"native","panel":panel}
         );
         nativeBtn.x = 428;
         nativeBtn.y = y;
         canvas.addChild(nativeBtn);
         y += 34;

         // 2. Quick Composer Card
         var compCard:Sprite = SocialMediaTunables.CreateCard(cardW,88,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         compCard.x = 8;
         compCard.y = y;
         canvas.addChild(compCard);

         var inp:Sprite = SocialMediaTunables.CreateInputBox("",cardW - 20,44,true,240);
         inp.x = 10;
         inp.y = 8;
         compCard.addChild(inp);

         var types:Array = [
            {"id":"text","label":"Text"},
            {"id":"mood","label":"Mood"},
            {"id":"milestone","label":"Milestone"},
            {"id":"controversial","label":"Hot Take"}
         ];
         var tx:Number = 10;
         var tIdx:int = 0;
         while(tIdx < types.length)
         {
            var tObj:Object = types[tIdx];
            var tBtn:Sprite = MakeTypeChip(panel,tObj.id,tObj.label,sComposeType == tObj.id);
            tBtn.x = tx;
            tBtn.y = 58;
            compCard.addChild(tBtn);
            tx += 76;
            tIdx++;
         }

         var postBtn:Sprite = SocialMediaTunables.CreateButton(
            "Post",
            84,
            24,
            SocialMediaTunables.COL_BRAND_BLUE,
            0xFFFFFF,
            OnFeedBtnClick,
            11,
            0,
            {"kind":"compose","simId":simId,"inp":inp}
         );
         postBtn.x = cardW - 94;
         postBtn.y = 57;
         compCard.addChild(postBtn);
         y += 96;

         // 3. Feed Post Cards
         var feed:Array = state && state.feed ? (state.feed as Array) : new Array();
         if(feed.length == 0)
         {
            var emptyCard:Sprite = SocialMediaTunables.CreateCard(cardW,80,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            emptyCard.x = 8;
            emptyCard.y = y;
            canvas.addChild(emptyCard);
            var e1:TextField = SocialMediaTunables.CreateLabel("No posts in this feed yet",13,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 24,20,false,"center");
            e1.x = 12;
            e1.y = 20;
            emptyCard.addChild(e1);
            var e2:TextField = SocialMediaTunables.CreateLabel("Write a post above or explore verified creators!",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 24,20,false,"center");
            e2.x = 12;
            e2.y = 44;
            emptyCard.addChild(e2);
            return y + 92;
         }

         var pIdx:int = 0;
         while(pIdx < feed.length)
         {
            y = RenderPostCard(panel,canvas,feed[pIdx],simId,y,cardW);
            pIdx++;
         }
         return y + 8;
      }

      private static function MakeFilterButton(simId:String, filterId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label,
            82,
            26,
            active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE,
            active ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            active ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"cmd","simId":simId,"cmd":"set_filter","arg1":filterId}
         );
      }

      private static function MakeTypeChip(panel:SocialMediaPanel, typeId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(
            label,
            70,
            22,
            active ? SocialMediaTunables.COL_BRAND_BLUE : SocialMediaTunables.COL_SURFACE_ALT,
            active ? 0xFFFFFF : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            active ? 0 : SocialMediaTunables.COL_BORDER,
            {"kind":"type","panel":panel,"typeId":typeId}
         );
      }

      public static function RenderPostCard(panel:SocialMediaPanel, canvas:Sprite, post:Object, simId:String, startY:Number, cardW:Number) : Number
      {
         var contentStr:String = String(post.content || "");
         var comments:Array = post.comments ? (post.comments as Array) : new Array();
         var textH:Number = contentStr.length > 110 ? 52 : (contentStr.length > 55 ? 38 : 24);
         var commentPreviewH:Number = comments.length > 0 ? 22 : 0;
         var sponsorH:Number = post.is_sponsored ? 18 : 0;
         var cardH:Number = 48 + sponsorH + textH + commentPreviewH + 34;

         var card:Sprite = SocialMediaTunables.CreateCard(cardW,cardH,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);

         // Author avatar
         var avatar:IconComponent = new IconComponent();
         avatar.x = 12;
         avatar.y = 10;
         avatar.mouseEnabled = false;
         avatar.mouseChildren = false;
         card.addChild(avatar);
         avatar.ResetImageSize(32,32);
         ImageUtils.LoadSimThumbnail(avatar,String(post.author_sim_id),ImageUtils.SIM_THUMBNAIL_TYPE_BUST);

         // Author name clickable -> open profile
         var authorBtn:Sprite = new Sprite();
         authorBtn.buttonMode = true;
         authorBtn.useHandCursor = true;
         authorBtn.mouseChildren = false;
         authorBtn.x = 52;
         authorBtn.y = 8;
         authorBtn["sbv"] = {"kind":"cmd","simId":simId,"cmd":"open_profile","arg1":String(post.author_sim_id)};
         var nameTf:TextField = SocialMediaTunables.CreateLabel(String(post.author_name || "Sim"),12,SocialMediaTunables.COL_TEXT_PRIMARY,true,240,18);
         authorBtn.addChild(nameTf);
         authorBtn.addEventListener(MouseEvent.CLICK,OnFeedBtnClick,false,0,true);
         card.addChild(authorBtn);

         // Verified badge right after display name
         var badgeKind:String = String(post.author_badge || "none");
         if(badgeKind != "none" && badgeKind != "")
         {
            var badge:Sprite = SocialMediaTunables.CreateBadgeSprite(15);
            SocialMediaTunables.UpdateBadgeSprite(badge,badgeKind);
            badge.x = 52 + Math.min(220,nameTf.textWidth + 6);
            badge.y = 10;
            card.addChild(badge);
         }

         var metaTf:TextField = SocialMediaTunables.CreateLabel(
            "@" + String(post.author_username || "sim") + "  ·  " + SocialMediaTunables.FormatAge(int(post.age_min)) + "  ·  " + String(post.post_type || "text").toUpperCase(),
            10,
            SocialMediaTunables.COL_TEXT_MUTED,
            false,
            cardW - 110,
            16
         );
         metaTf.x = 52;
         metaTf.y = 25;
         card.addChild(metaTf);

         var reachTf:TextField = SocialMediaTunables.CreateLabel(String(int(post.reach)) + " reach",10,SocialMediaTunables.COL_TEXT_MUTED,false,80,16,false,"right");
         reachTf.x = cardW - 92;
         reachTf.y = 10;
         card.addChild(reachTf);

         var bodyY:Number = 44;
         if(post.is_sponsored)
         {
            var spTf:TextField = SocialMediaTunables.CreateLabel("Paid partnership with " + String(post.brand_name || "Sponsor"),10,SocialMediaTunables.COL_BRAND_DARK,true,cardW - 64,16);
            spTf.x = 52;
            spTf.y = bodyY;
            card.addChild(spTf);
            bodyY += sponsorH;
         }

         var contentTf:TextField = SocialMediaTunables.CreateLabel(contentStr,12,SocialMediaTunables.COL_TEXT_PRIMARY,false,cardW - 66,textH,true);
         contentTf.x = 52;
         contentTf.y = bodyY;
         card.addChild(contentTf);
         bodyY += textH;

         if(comments.length > 0)
         {
            var lastC:Object = comments[comments.length - 1];
            var cPrev:TextField = SocialMediaTunables.CreateLabel(
               "@" + String(lastC.author_username) + ": " + String(lastC.text),
               10,
               SocialMediaTunables.COL_TEXT_SECONDARY,
               false,
               cardW - 66,
               18
            );
            cPrev.x = 52;
            cPrev.y = bodyY;
            card.addChild(cPrev);
            bodyY += commentPreviewH;
         }

         // Action Row: Like, Comment, Repost, Save, Report/Delete
         var postId:String = String(post.post_id);
         var authorId:String = String(post.author_sim_id);
         var liked:Boolean = Boolean(post.liked_by_me);
         var reposted:Boolean = Boolean(post.reposted_by_me);
         var saved:Boolean = Boolean(post.saved_by_me);

         var likeBtn:Sprite = SocialMediaTunables.CreateButton(
            (liked ? "Liked " : "Like ") + String(int(post.likes)),
            64,
            22,
            liked ? 0xFFE4E6 : SocialMediaTunables.COL_SURFACE_ALT,
            liked ? SocialMediaTunables.COL_LIKE_RED : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"like_post","arg1":postId}
         );
         likeBtn.x = 52;
         likeBtn.y = bodyY + 4;
         card.addChild(likeBtn);

         var cmtBtn:Sprite = SocialMediaTunables.CreateButton(
            "Reply " + String(int(post.comments_count)),
            64,
            22,
            SocialMediaTunables.COL_SURFACE_ALT,
            SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            0,
            {"kind":"comment","panel":panel,"post":post}
         );
         cmtBtn.x = 122;
         cmtBtn.y = bodyY + 4;
         card.addChild(cmtBtn);

         var repBtn:Sprite = SocialMediaTunables.CreateButton(
            "Repost " + String(int(post.reposts)),
            68,
            22,
            reposted ? 0xDCFCE7 : SocialMediaTunables.COL_SURFACE_ALT,
            reposted ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"repost","arg1":postId}
         );
         repBtn.x = 192;
         repBtn.y = bodyY + 4;
         card.addChild(repBtn);

         var saveBtn:Sprite = SocialMediaTunables.CreateButton(
            saved ? "Saved" : "Save",
            56,
            22,
            saved ? 0xDBEAFE : SocialMediaTunables.COL_SURFACE_ALT,
            saved ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_TEXT_SECONDARY,
            OnFeedBtnClick,
            10,
            0,
            {"kind":"cmd","simId":simId,"cmd":"save_post","arg1":postId}
         );
         saveBtn.x = 266;
         saveBtn.y = bodyY + 4;
         card.addChild(saveBtn);

         if(authorId == simId)
         {
            var delBtn:Sprite = SocialMediaTunables.CreateButton(
               "Delete",
               58,
               22,
               0xFEE2E2,
               SocialMediaTunables.COL_DANGER,
               OnFeedBtnClick,
               10,
               0,
               {"kind":"cmd","simId":simId,"cmd":"delete_post","arg1":postId}
            );
            delBtn.x = cardW - 68;
            delBtn.y = bodyY + 4;
            card.addChild(delBtn);
         }
         else
         {
            var rptBtn:Sprite = SocialMediaTunables.CreateButton(
               "Report",
               58,
               22,
               SocialMediaTunables.COL_SURFACE_ALT,
               SocialMediaTunables.COL_TEXT_MUTED,
               OnFeedBtnClick,
               10,
               0,
               {"kind":"report","panel":panel,"authorId":authorId,"postId":postId}
            );
            rptBtn.x = cardW - 68;
            rptBtn.y = bodyY + 4;
            card.addChild(rptBtn);
         }

         return startY + cardH + 8;
      }

      protected static function OnFeedBtnClick(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(!btn || !btn["sbv"])
         {
            return;
         }
         var d:Object = btn["sbv"];
         var k:String = String(d.kind || "");
         if(k == "native")
         {
            (d.panel as SocialMediaPanel).SwitchToNativeTab(SocialMediaPanel.PANEL_MODE_FEED);
         }
         else if(k == "type")
         {
            sComposeType = String(d.typeId);
            (d.panel as SocialMediaPanel).RefreshSBVView();
         }
         else if(k == "compose")
         {
            var inp:Sprite = d.inp as Sprite;
            var tf:TextField = inp ? (inp["tf"] as TextField) : null;
            var txt:String = tf ? tf.text : "";
            if(txt != "" && txt != null)
            {
               SocialMediaTunables.SendAction(String(d.simId),"create_post",txt,sComposeType);
               tf.text = "";
            }
         }
         else if(k == "comment")
         {
            (d.panel as SocialMediaPanel).OpenCommentModal(d.post);
         }
         else if(k == "report")
         {
            (d.panel as SocialMediaPanel).OpenReportModal(String(d.authorId),String(d.postId));
         }
         else if(k == "cmd")
         {
            SocialMediaTunables.SendAction(String(d.simId),String(d.cmd),String(d.arg1 || ""));
         }
      }
   }
}
