package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import olympus.data.ArrayDataFeed;
   import olympus.interfaces.IView;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import olympus.utils.ImageUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol59")]
   public class SocialMediaFeedTabPanel extends SocialMediaTabPanelBase
   {
      
      private static var sComposeType:String = "text";
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcFeedPanelFTUE:MovieClip;
      
      protected var mFeedData:ArrayDataFeed;
      
      public function SocialMediaFeedTabPanel()
      {
         super();
      }
      
      public static function RenderSBVHome(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var fObj:Object;
         var active:Boolean;
         var fBtn:Sprite;
         var nativeBtn:Sprite;
         var compCard:Sprite;
         var inp:Sprite;
         var types:Array;
         var tx:Number;
         var tIdx:int;
         var tObj:Object;
         var tBtn:Sprite;
         var postBtn:Sprite;
         var feed:Array;
         var emptyCard:Sprite;
         var e1:TextField;
         var e2:TextField;
         var pIdx:int;
         var y:Number = 8;
         var cardW:Number = 512;
         var curFilter:String = state && state.feed_filter ? String(state.feed_filter) : "for_you";
         var filters:Array = [{
            "id":"for_you",
            "label":"For You"
         },{
            "id":"following",
            "label":"Following"
         },{
            "id":"verified",
            "label":"Verified"
         },{
            "id":"trending",
            "label":"Trending"
         }];
         var fx:Number = 8;
         var fIdx:int = 0;
         while(fIdx < filters.length)
         {
            fObj = filters[fIdx];
            active = curFilter == fObj.id;
            fBtn = MakeFilterButton(simId,fObj.id,fObj.label,active);
            fBtn.x = fx;
            fBtn.y = y;
            canvas.addChild(fBtn);
            fx += 88;
            fIdx++;
         }
         nativeBtn = SocialMediaTunables.CreateButton("Native Feed",92,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            panel.SwitchToNativeTab(SocialMediaPanel.PANEL_MODE_FEED);
         },10,SocialMediaTunables.COL_BORDER);
         nativeBtn.x = 428;
         nativeBtn.y = y;
         canvas.addChild(nativeBtn);
         y += 34;
         compCard = SocialMediaTunables.CreateCard(cardW,88,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         compCard.x = 8;
         compCard.y = y;
         canvas.addChild(compCard);
         inp = SocialMediaTunables.CreateInputBox("",cardW - 20,44,true,240);
         inp.x = 10;
         inp.y = 8;
         compCard.addChild(inp);
         types = [{
            "id":"text",
            "label":"Text"
         },{
            "id":"mood",
            "label":"Mood"
         },{
            "id":"milestone",
            "label":"Milestone"
         },{
            "id":"controversial",
            "label":"Hot Take"
         }];
         tx = 10;
         tIdx = 0;
         while(tIdx < types.length)
         {
            tObj = types[tIdx];
            tBtn = MakeTypeChip(panel,tObj.id,tObj.label,sComposeType == tObj.id);
            tBtn.x = tx;
            tBtn.y = 58;
            compCard.addChild(tBtn);
            tx += 76;
            tIdx++;
         }
         postBtn = SocialMediaTunables.CreateButton("Post",84,24,SocialMediaTunables.COL_BRAND_BLUE,16777215,function(e:MouseEvent):void
         {
            var tf:TextField = inp["tf"] as TextField;
            var txt:String = tf ? tf.text : "";
            if(txt != "" && txt != null)
            {
               SocialMediaTunables.SendAction(simId,"create_post",txt,sComposeType);
               tf.text = "";
            }
         },11);
         postBtn.x = cardW - 94;
         postBtn.y = 57;
         compCard.addChild(postBtn);
         y += 96;
         feed = state && state.feed ? state.feed as Array : new Array();
         if(feed.length == 0)
         {
            emptyCard = SocialMediaTunables.CreateCard(cardW,80,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            emptyCard.x = 8;
            emptyCard.y = y;
            canvas.addChild(emptyCard);
            e1 = SocialMediaTunables.CreateLabel("No posts in this feed yet",13,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 24,20,false,"center");
            e1.x = 12;
            e1.y = 20;
            emptyCard.addChild(e1);
            e2 = SocialMediaTunables.CreateLabel("Write a post above or explore verified creators!",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 24,20,false,"center");
            e2.x = 12;
            e2.y = 44;
            emptyCard.addChild(e2);
            return y + 92;
         }
         pIdx = 0;
         while(pIdx < feed.length)
         {
            y = RenderPostCard(panel,canvas,feed[pIdx],simId,y,cardW);
            pIdx++;
         }
         return y + 8;
      }
      
      private static function MakeFilterButton(simId:String, filterId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(label,82,26,active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE,active ? 16777215 : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"set_filter",filterId);
         },10,active ? 0 : SocialMediaTunables.COL_BORDER);
      }
      
      private static function MakeTypeChip(panel:SocialMediaPanel, typeId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(label,70,22,active ? SocialMediaTunables.COL_BRAND_BLUE : SocialMediaTunables.COL_SURFACE_ALT,active ? 16777215 : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            sComposeType = typeId;
            panel.RefreshSBVView();
         },10,active ? 0 : SocialMediaTunables.COL_BORDER);
      }
      
      public static function RenderPostCard(panel:SocialMediaPanel, canvas:Sprite, post:Object, simId:String, startY:Number, cardW:Number) : Number
      {
         var avatar:IconResource22x22;
         var authorBtn:Sprite;
         var nameTf:TextField;
         var badgeKind:String;
         var badge:Sprite;
         var metaTf:TextField;
         var reachTf:TextField;
         var bodyY:Number;
         var spTf:TextField;
         var contentTf:TextField;
         var lastC:Object;
         var cPrev:TextField;
         var postId:String;
         var authorId:String;
         var liked:Boolean;
         var reposted:Boolean;
         var saved:Boolean;
         var likeBtn:Sprite;
         var cmtBtn:Sprite;
         var repBtn:Sprite;
         var saveBtn:Sprite;
         var delBtn:Sprite;
         var rptBtn:Sprite;
         var contentStr:String = String(post.content || "");
         var comments:Array = post.comments ? post.comments as Array : new Array();
         var textH:Number = contentStr.length > 110 ? 52 : (contentStr.length > 55 ? 38 : 24);
         var commentPreviewH:Number = comments.length > 0 ? 22 : 0;
         var sponsorH:Number = post.is_sponsored ? 18 : 0;
         var cardH:Number = 48 + sponsorH + textH + commentPreviewH + 34;
         var card:Sprite = SocialMediaTunables.CreateCard(cardW,cardH,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);
         avatar = new IconResource22x22();
         avatar.x = 12;
         avatar.y = 10;
         avatar.width = 32;
         avatar.height = 32;
         card.addChild(avatar);
         ImageUtils.LoadSimThumbnail(avatar,String(post.author_sim_id),ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         authorBtn = new Sprite();
         authorBtn.buttonMode = true;
         authorBtn.useHandCursor = true;
         authorBtn.x = 52;
         authorBtn.y = 8;
         nameTf = SocialMediaTunables.CreateLabel(String(post.author_name || "Sim"),12,SocialMediaTunables.COL_TEXT_PRIMARY,true,240,18);
         authorBtn.addChild(nameTf);
         authorBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"open_profile",String(post.author_sim_id));
         },false,0,true);
         card.addChild(authorBtn);
         badgeKind = String(post.author_badge || "none");
         if(badgeKind != "none" && badgeKind != "")
         {
            badge = SocialMediaTunables.CreateBadgeSprite(15);
            SocialMediaTunables.UpdateBadgeSprite(badge,badgeKind);
            badge.x = 52 + Math.min(220,nameTf.textWidth + 6);
            badge.y = 10;
            card.addChild(badge);
         }
         metaTf = SocialMediaTunables.CreateLabel("@" + (String(post.author_username || "sim")) + "  ·  " + SocialMediaTunables.FormatAge(int(post.age_min)) + "  ·  " + (String(post.post_type || "text")).toUpperCase(),10,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 110,16);
         metaTf.x = 52;
         metaTf.y = 25;
         card.addChild(metaTf);
         reachTf = SocialMediaTunables.CreateLabel(String(int(post.reach)) + " reach",10,SocialMediaTunables.COL_TEXT_MUTED,false,80,16,false,"right");
         reachTf.x = cardW - 92;
         reachTf.y = 10;
         card.addChild(reachTf);
         bodyY = 44;
         if(post.is_sponsored)
         {
            spTf = SocialMediaTunables.CreateLabel("Paid partnership with " + (String(post.brand_name || "Sponsor")),10,SocialMediaTunables.COL_BRAND_DARK,true,cardW - 64,16);
            spTf.x = 52;
            spTf.y = bodyY;
            card.addChild(spTf);
            bodyY += sponsorH;
         }
         contentTf = SocialMediaTunables.CreateLabel(contentStr,12,SocialMediaTunables.COL_TEXT_PRIMARY,false,cardW - 66,textH,true);
         contentTf.x = 52;
         contentTf.y = bodyY;
         card.addChild(contentTf);
         bodyY += textH;
         if(comments.length > 0)
         {
            lastC = comments[comments.length - 1];
            cPrev = SocialMediaTunables.CreateLabel("@" + String(lastC.author_username) + ": " + String(lastC.text),10,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW - 66,18);
            cPrev.x = 52;
            cPrev.y = bodyY;
            card.addChild(cPrev);
            bodyY += commentPreviewH;
         }
         postId = String(post.post_id);
         authorId = String(post.author_sim_id);
         liked = Boolean(post.liked_by_me);
         reposted = Boolean(post.reposted_by_me);
         saved = Boolean(post.saved_by_me);
         likeBtn = SocialMediaTunables.CreateButton((liked ? "♥ " : "♡ ") + String(int(post.likes)),64,22,liked ? 16770278 : SocialMediaTunables.COL_SURFACE_ALT,liked ? SocialMediaTunables.COL_LIKE_RED : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"like_post",postId);
         },10);
         likeBtn.x = 52;
         likeBtn.y = bodyY + 4;
         card.addChild(likeBtn);
         cmtBtn = SocialMediaTunables.CreateButton("💬 " + String(int(post.comments_count)),64,22,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            panel.OpenCommentModal(post);
         },10);
         cmtBtn.x = 122;
         cmtBtn.y = bodyY + 4;
         card.addChild(cmtBtn);
         repBtn = SocialMediaTunables.CreateButton("↻ " + String(int(post.reposts)),60,22,reposted ? 14482663 : SocialMediaTunables.COL_SURFACE_ALT,reposted ? SocialMediaTunables.COL_GREEN : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"repost",postId);
         },10);
         repBtn.x = 192;
         repBtn.y = bodyY + 4;
         card.addChild(repBtn);
         saveBtn = SocialMediaTunables.CreateButton(saved ? "Saved" : "Save",56,22,saved ? 14412542 : SocialMediaTunables.COL_SURFACE_ALT,saved ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"save_post",postId);
         },10);
         saveBtn.x = 258;
         saveBtn.y = bodyY + 4;
         card.addChild(saveBtn);
         if(authorId == simId)
         {
            delBtn = SocialMediaTunables.CreateButton("Delete",58,22,16704226,SocialMediaTunables.COL_DANGER,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"delete_post",postId);
            },10);
            delBtn.x = cardW - 68;
            delBtn.y = bodyY + 4;
            card.addChild(delBtn);
         }
         else
         {
            rptBtn = SocialMediaTunables.CreateButton("Report",58,22,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_MUTED,function(e:MouseEvent):void
            {
               panel.OpenReportModal(authorId,postId);
            },10);
            rptBtn.x = cardW - 68;
            rptBtn.y = bodyY + 4;
            card.addChild(rptBtn);
         }
         return startY + cardH + 8;
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

