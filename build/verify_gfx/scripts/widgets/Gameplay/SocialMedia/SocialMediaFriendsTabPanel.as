package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gamedata.Gameplay.SimInfoHUD.DataFeeds.RelationshipDataFeed;
   import gamedata.Gameplay.shared.definitions.RelationshipFilterTypes;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.events.DataFeedEvent;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.TextButton;
   import olympus.input.IInputAdapter;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.interfaces.IView;
   import olympus.io.CommunicationManager;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysGP;
   import olympus.objects.RelationshipByIdInfo;
   import olympus.objects.RelationshipDeleteById;
   import olympus.objects.RelationshipInfo;
   import olympus.utils.ImageUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol102")]
   public class SocialMediaFriendsTabPanel extends SocialMediaTabPanelBase
   {
      
      public static const FRIENDS_UPDATED:String = "friends_updated";
      
      private static var sProfileSubTab:String = "posts";
      
      public var btnAddToContactList:TextButton;
      
      public var txtEmptyStateTitle:TextField;
      
      public var txtEmptyStateDescription:TextField;
      
      public var mcEmptyStateBackground:MovieClip;
      
      public var mbCanAddNewContacts:Boolean;
      
      protected var mFriendsCount:int = 0;
      
      protected var mFriendsList:Array = new Array();
      
      protected var mData:RelationshipDataFeed = new RelationshipDataFeed();
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      protected var mSimId:String;
      
      public function SocialMediaFriendsTabPanel(param1:String)
      {
         super();
         this.mSimId = param1;
      }
      
      public static function RenderSBVExplore(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var sBtn:Sprite;
         var refBtn:Sprite;
         var tags:Array;
         var thTitle:TextField;
         var tx:Number;
         var tIdx:int;
         var tagObj:Object;
         var tagStr:String;
         var chip:Sprite;
         var searchRes:Array;
         var srHead:TextField;
         var noRes:TextField;
         var rIdx:int;
         var sugHead:TextField;
         var suggested:Array;
         var sIdx:int;
         var tPosts:Array;
         var tpHead:TextField;
         var tpIdx:int;
         var y:Number = 8;
         var cardW:Number = 512;
         var explore:Object = state && state.explore ? state.explore : new Object();
         var sBox:Sprite = SocialMediaTunables.CreateInputBox(explore.search_query ? String(explore.search_query) : "",330,28,false,48);
         sBox.x = 8;
         sBox.y = y;
         canvas.addChild(sBox);
         sBtn = SocialMediaTunables.CreateButton("Search",82,28,SocialMediaTunables.COL_BRAND_BLUE,16777215,function(e:MouseEvent):void
         {
            var tf:TextField = sBox["tf"] as TextField;
            SocialMediaTunables.SendAction(simId,"search",tf ? tf.text : "");
         },11);
         sBtn.x = 344;
         sBtn.y = y;
         canvas.addChild(sBtn);
         refBtn = SocialMediaTunables.CreateButton("Refresh",86,28,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"refresh_explore");
         },11,SocialMediaTunables.COL_BORDER);
         refBtn.x = 432;
         refBtn.y = y;
         canvas.addChild(refBtn);
         y += 38;
         tags = explore.trending_hashtags ? explore.trending_hashtags as Array : new Array();
         if(tags.length > 0)
         {
            thTitle = SocialMediaTunables.CreateLabel("TRENDING TAGS",10,SocialMediaTunables.COL_TEXT_MUTED,true,cardW,16);
            thTitle.x = 8;
            thTitle.y = y;
            canvas.addChild(thTitle);
            y += 18;
            tx = 8;
            tIdx = 0;
            while(tIdx < tags.length && tIdx < 5)
            {
               tagObj = tags[tIdx];
               tagStr = String(tagObj.tag || "#SocialBunny");
               chip = MakeTagChip(simId,tagStr);
               chip.x = tx;
               chip.y = y;
               canvas.addChild(chip);
               tx += 102;
               tIdx++;
            }
            y += 30;
         }
         searchRes = explore.search_results ? explore.search_results as Array : new Array();
         if(explore.search_query && String(explore.search_query).length > 0)
         {
            srHead = SocialMediaTunables.CreateLabel("SEARCH RESULTS (" + searchRes.length + ")",10,SocialMediaTunables.COL_TEXT_MUTED,true,cardW,16);
            srHead.x = 8;
            srHead.y = y;
            canvas.addChild(srHead);
            y += 18;
            if(searchRes.length == 0)
            {
               noRes = SocialMediaTunables.CreateLabel("No accounts matched your search.",11,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW,20);
               noRes.x = 8;
               noRes.y = y;
               canvas.addChild(noRes);
               y += 26;
            }
            else
            {
               rIdx = 0;
               while(rIdx < searchRes.length)
               {
                  y = RenderAccountRow(canvas,searchRes[rIdx],simId,y,cardW);
                  rIdx++;
               }
            }
         }
         sugHead = SocialMediaTunables.CreateLabel("SUGGESTED FOR YOU",10,SocialMediaTunables.COL_TEXT_MUTED,true,cardW,16);
         sugHead.x = 8;
         sugHead.y = y;
         canvas.addChild(sugHead);
         y += 18;
         suggested = explore.suggested ? explore.suggested as Array : new Array();
         sIdx = 0;
         while(sIdx < suggested.length)
         {
            y = RenderAccountRow(canvas,suggested[sIdx],simId,y,cardW);
            sIdx++;
         }
         tPosts = explore.trending_posts ? explore.trending_posts as Array : new Array();
         if(tPosts.length > 0)
         {
            y += 6;
            tpHead = SocialMediaTunables.CreateLabel("TRENDING POSTS",10,SocialMediaTunables.COL_TEXT_MUTED,true,cardW,16);
            tpHead.x = 8;
            tpHead.y = y;
            canvas.addChild(tpHead);
            y += 18;
            tpIdx = 0;
            while(tpIdx < tPosts.length && tpIdx < 4)
            {
               y = SocialMediaFeedTabPanel.RenderPostCard(panel,canvas,tPosts[tpIdx],simId,y,cardW);
               tpIdx++;
            }
         }
         return y + 8;
      }
      
      private static function MakeTagChip(simId:String, tagStr:String) : Sprite
      {
         return SocialMediaTunables.CreateButton(tagStr.substr(0,14),96,22,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BRAND_DARK,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(simId,"search",tagStr.replace("#",""));
         },10,SocialMediaTunables.COL_BORDER);
      }
      
      public static function RenderAccountRow(canvas:Sprite, acc:Object, viewerSimId:String, startY:Number, cardW:Number) : Number
      {
         var targetId:String;
         var av:IconResource22x22;
         var nameBtn:Sprite;
         var nameTf:TextField;
         var badgeKind:String;
         var b:Sprite;
         var subTf:TextField;
         var following:Boolean;
         var requested:Boolean;
         var fLabel:String;
         var fBg:uint;
         var fFg:uint;
         var fBtn:Sprite;
         var cardH:Number = 56;
         var card:Sprite = SocialMediaTunables.CreateCard(cardW,cardH,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
         card.x = 8;
         card.y = startY;
         canvas.addChild(card);
         targetId = String(acc.sim_id);
         av = new IconResource22x22();
         av.x = 10;
         av.y = 10;
         av.width = 36;
         av.height = 36;
         card.addChild(av);
         ImageUtils.LoadSimThumbnail(av,targetId,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         nameBtn = new Sprite();
         nameBtn.buttonMode = true;
         nameBtn.useHandCursor = true;
         nameBtn.x = 54;
         nameBtn.y = 8;
         nameTf = SocialMediaTunables.CreateLabel(String(acc.display_name || "Sim"),12,SocialMediaTunables.COL_TEXT_PRIMARY,true,220,18);
         nameBtn.addChild(nameTf);
         nameBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            SocialMediaTunables.SendAction(viewerSimId,"open_profile",targetId);
         },false,0,true);
         card.addChild(nameBtn);
         badgeKind = String(acc.badge || "none");
         if(badgeKind != "none" && badgeKind != "")
         {
            b = SocialMediaTunables.CreateBadgeSprite(15);
            SocialMediaTunables.UpdateBadgeSprite(b,badgeKind);
            b.x = 54 + Math.min(200,nameTf.textWidth + 6);
            b.y = 10;
            card.addChild(b);
         }
         subTf = SocialMediaTunables.CreateLabel("@" + (String(acc.username || "sim")) + "  ·  " + (String(acc.category_label || "Personal")) + "  ·  " + String(int(acc.followers)) + " followers",10,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 170,16);
         subTf.x = 54;
         subTf.y = 29;
         card.addChild(subTf);
         if(targetId != viewerSimId)
         {
            following = Boolean(acc.is_following);
            requested = Boolean(acc.is_requested);
            fLabel = following ? "Following" : (requested ? "Requested" : "Follow");
            fBg = following || requested ? SocialMediaTunables.COL_SURFACE_ALT : SocialMediaTunables.COL_BRAND_BLUE;
            fFg = following || requested ? SocialMediaTunables.COL_TEXT_PRIMARY : 16777215;
            fBtn = SocialMediaTunables.CreateButton(fLabel,86,26,fBg,fFg,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(viewerSimId,following || requested ? "unfollow" : "follow",targetId);
            },10,following || requested ? SocialMediaTunables.COL_BORDER : 0);
            fBtn.x = cardW - 96;
            fBtn.y = 15;
            card.addChild(fBtn);
         }
         return startY + cardH + 6;
      }
      
      public static function RenderSBVProfile(panel:SocialMediaPanel, canvas:Sprite, state:Object, simId:String) : Number
      {
         var av:IconResource22x22;
         var dNameTf:TextField;
         var badgeKind:String;
         var badge:Sprite;
         var handleTf:TextField;
         var bioStr:String;
         var bioTf:TextField;
         var statsStr:String;
         var statsTf:TextField;
         var verBtn:Sprite;
         var editBtn:Sprite;
         var proBtn:Sprite;
         var isF:Boolean;
         var isR:Boolean;
         var fBtn2:Sprite;
         var muteBtn:Sprite;
         var restBtn:Sprite;
         var blkBtn:Sprite;
         var backOwn:Sprite;
         var subTabs:Array;
         var sx:Number;
         var stIdx:int;
         var stObj:Object;
         var stBtn:Sprite;
         var privCard:Sprite;
         var p1:TextField;
         var p2:TextField;
         var flList:Array;
         var nfTf:TextField;
         var flIdx:int;
         var fgList:Array;
         var ngTf:TextField;
         var fgIdx:int;
         var posts:Array;
         var npTf:TextField;
         var pIdx:int;
         var y:Number = 8;
         var cardW:Number = 512;
         var prof:Object = state && state.profile ? state.profile : new Object();
         var acc:Object = prof.account ? prof.account : new Object();
         var targetId:String = String(acc.sim_id || simId);
         var isOwn:Boolean = Boolean(prof.is_own);
         var heroH:Number = 148;
         var hero:Sprite = SocialMediaTunables.CreateCard(cardW,heroH,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,12);
         hero.x = 8;
         hero.y = y;
         canvas.addChild(hero);
         av = new IconResource22x22();
         av.x = 14;
         av.y = 14;
         av.width = 58;
         av.height = 58;
         hero.addChild(av);
         ImageUtils.LoadSimThumbnail(av,targetId,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         dNameTf = SocialMediaTunables.CreateLabel(String(acc.display_name || "Sim"),15,SocialMediaTunables.COL_TEXT_PRIMARY,true,260,22);
         dNameTf.x = 84;
         dNameTf.y = 12;
         hero.addChild(dNameTf);
         badgeKind = String(acc.badge || "none");
         if(badgeKind != "none" && badgeKind != "")
         {
            badge = SocialMediaTunables.CreateBadgeSprite(18,true);
            SocialMediaTunables.UpdateBadgeSprite(badge,badgeKind,String(acc.category_label) + " · " + badgeKind.toUpperCase());
            badge.x = 84 + Math.min(230,dNameTf.textWidth + 8);
            badge.y = 14;
            hero.addChild(badge);
         }
         handleTf = SocialMediaTunables.CreateLabel("@" + (String(acc.username || "sim")) + "  ·  " + (String(acc.category_label || "Personal")) + (acc.privacy == "private" ? "  ·  🔒 Private" : ""),11,SocialMediaTunables.COL_TEXT_MUTED,false,320,18);
         handleTf.x = 84;
         handleTf.y = 33;
         hero.addChild(handleTf);
         bioStr = acc.bio && String(acc.bio).length > 0 ? String(acc.bio) : "No bio added yet.";
         bioTf = SocialMediaTunables.CreateLabel(bioStr,11,SocialMediaTunables.COL_TEXT_SECONDARY,false,cardW - 100,32,true);
         bioTf.x = 84;
         bioTf.y = 52;
         hero.addChild(bioTf);
         statsStr = String(int(acc.posts_count)) + " Posts    " + String(int(acc.followers)) + " Followers    " + String(int(acc.following)) + " Following    Rep " + String(int(acc.reputation)) + " (" + (String(acc.standing || "Neutral")) + ")";
         statsTf = SocialMediaTunables.CreateLabel(statsStr,11,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 28,18);
         statsTf.x = 14;
         statsTf.y = 90;
         hero.addChild(statsTf);
         if(isOwn)
         {
            verBtn = SocialMediaTunables.CreateButton("Verification Center",138,26,SocialMediaTunables.COL_BRAND_BLUE,16777215,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"set_tab","verify");
            },11);
            verBtn.x = 14;
            verBtn.y = 114;
            hero.addChild(verBtn);
            editBtn = SocialMediaTunables.CreateButton("Edit Profile / Settings",148,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_PRIMARY,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"set_tab","settings");
            },11,SocialMediaTunables.COL_BORDER);
            editBtn.x = 160;
            editBtn.y = 114;
            hero.addChild(editBtn);
            proBtn = SocialMediaTunables.CreateButton("Pro Analytics",112,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_BRAND_DARK,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"set_tab","dashboard");
            },11,SocialMediaTunables.COL_BORDER);
            proBtn.x = 316;
            proBtn.y = 114;
            hero.addChild(proBtn);
         }
         else
         {
            isF = Boolean(acc.is_following);
            isR = Boolean(acc.is_requested);
            fBtn2 = SocialMediaTunables.CreateButton(isF ? "Following" : (isR ? "Requested" : "Follow"),96,26,isF || isR ? SocialMediaTunables.COL_SURFACE_ALT : SocialMediaTunables.COL_BRAND_BLUE,isF || isR ? SocialMediaTunables.COL_TEXT_PRIMARY : 16777215,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,isF || isR ? "unfollow" : "follow",targetId);
            },11,isF || isR ? SocialMediaTunables.COL_BORDER : 0);
            fBtn2.x = 14;
            fBtn2.y = 114;
            hero.addChild(fBtn2);
            muteBtn = SocialMediaTunables.CreateButton(acc.is_muted ? "Unmute" : "Mute",72,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"mute",targetId);
            },10,SocialMediaTunables.COL_BORDER);
            muteBtn.x = 118;
            muteBtn.y = 114;
            hero.addChild(muteBtn);
            restBtn = SocialMediaTunables.CreateButton(acc.is_restricted ? "Unrestrict" : "Restrict",80,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"restrict",targetId);
            },10,SocialMediaTunables.COL_BORDER);
            restBtn.x = 196;
            restBtn.y = 114;
            hero.addChild(restBtn);
            blkBtn = SocialMediaTunables.CreateButton(acc.is_blocked ? "Unblock" : "Block",72,26,16704226,SocialMediaTunables.COL_DANGER,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,acc.is_blocked ? "unblock" : "block",targetId);
            },10);
            blkBtn.x = 284;
            blkBtn.y = 114;
            hero.addChild(blkBtn);
            backOwn = SocialMediaTunables.CreateButton("My Profile",84,26,SocialMediaTunables.COL_SURFACE_ALT,SocialMediaTunables.COL_BRAND_DARK,function(e:MouseEvent):void
            {
               SocialMediaTunables.SendAction(simId,"open_profile",simId);
            },10,SocialMediaTunables.COL_BORDER);
            backOwn.x = cardW - 96;
            backOwn.y = 114;
            hero.addChild(backOwn);
         }
         y += heroH + 10;
         subTabs = [{
            "id":"posts",
            "label":"Posts"
         },{
            "id":"followers",
            "label":"Followers (" + String(int(acc.followers)) + ")"
         },{
            "id":"following",
            "label":"Following (" + String(int(acc.following)) + ")"
         }];
         sx = 8;
         stIdx = 0;
         while(stIdx < subTabs.length)
         {
            stObj = subTabs[stIdx];
            stBtn = MakeProfileSubTab(panel,stObj.id,stObj.label,sProfileSubTab == stObj.id);
            stBtn.x = sx;
            stBtn.y = y;
            canvas.addChild(stBtn);
            sx += 120;
            stIdx++;
         }
         y += 32;
         if(!prof.can_view)
         {
            privCard = SocialMediaTunables.CreateCard(cardW,76,SocialMediaTunables.COL_SURFACE,SocialMediaTunables.COL_BORDER,10);
            privCard.x = 8;
            privCard.y = y;
            canvas.addChild(privCard);
            p1 = SocialMediaTunables.CreateLabel("This Account is Private",13,SocialMediaTunables.COL_TEXT_PRIMARY,true,cardW - 24,20,false,"center");
            p1.x = 12;
            p1.y = 18;
            privCard.addChild(p1);
            p2 = SocialMediaTunables.CreateLabel("Follow this Sim to view their posts and followers.",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW - 24,20,false,"center");
            p2.x = 12;
            p2.y = 42;
            privCard.addChild(p2);
            return y + 86;
         }
         if(sProfileSubTab == "followers")
         {
            flList = prof.followers_list ? prof.followers_list as Array : new Array();
            if(flList.length == 0)
            {
               nfTf = SocialMediaTunables.CreateLabel("No followers yet.",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW,24);
               nfTf.x = 12;
               nfTf.y = y;
               canvas.addChild(nfTf);
               return y + 32;
            }
            flIdx = 0;
            while(flIdx < flList.length)
            {
               y = RenderAccountRow(canvas,flList[flIdx],simId,y,cardW);
               flIdx++;
            }
            return y + 8;
         }
         if(sProfileSubTab == "following")
         {
            fgList = prof.following_list ? prof.following_list as Array : new Array();
            if(fgList.length == 0)
            {
               ngTf = SocialMediaTunables.CreateLabel("Not following any Sims yet.",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW,24);
               ngTf.x = 12;
               ngTf.y = y;
               canvas.addChild(ngTf);
               return y + 32;
            }
            fgIdx = 0;
            while(fgIdx < fgList.length)
            {
               y = RenderAccountRow(canvas,fgList[fgIdx],simId,y,cardW);
               fgIdx++;
            }
            return y + 8;
         }
         posts = prof.posts ? prof.posts as Array : new Array();
         if(posts.length == 0)
         {
            npTf = SocialMediaTunables.CreateLabel("No posts published yet.",11,SocialMediaTunables.COL_TEXT_MUTED,false,cardW,24);
            npTf.x = 12;
            npTf.y = y;
            canvas.addChild(npTf);
            return y + 32;
         }
         pIdx = 0;
         while(pIdx < posts.length)
         {
            y = SocialMediaFeedTabPanel.RenderPostCard(panel,canvas,posts[pIdx],simId,y,cardW);
            pIdx++;
         }
         return y + 8;
      }
      
      private static function MakeProfileSubTab(panel:SocialMediaPanel, subId:String, label:String, active:Boolean) : Sprite
      {
         return SocialMediaTunables.CreateButton(label,114,24,active ? SocialMediaTunables.COL_BRAND_DARK : SocialMediaTunables.COL_SURFACE,active ? 16777215 : SocialMediaTunables.COL_TEXT_SECONDARY,function(e:MouseEvent):void
         {
            sProfileSubTab = subId;
            panel.RefreshSBVView();
         },10,active ? 0 : SocialMediaTunables.COL_BORDER);
      }
      
      public function get FriendsCount() : int
      {
         return this.mFriendsCount;
      }
      
      public function get FriendsList() : Array
      {
         return this.mFriendsList;
      }
      
      public function set OwnerSimId(param1:String) : void
      {
         this.mSimId = param1;
         this.LoadFriends();
         this.RefreshLayout();
      }
      
      override public function Initialize() : void
      {
         this.btnAddToContactList.htmlText = KeysGP.SOCIAL_MEDIA_NEW_FRIEND_BUTTON_LABEL.toString();
         this.btnAddToContactList.addEventListener(PushButtonEvent.CLICK,this.OnAddToContactListClick,false,0,true);
         var _loc1_:GridLayout = new GridLayout(false,true,1);
         mcList.mSlider.AlwaysVisible = false;
         mcList.InitializeScrollList(this.mData,SocialMediaFriendCellView,SocialMediaTunables.FRIENDS_LIST_CELL_PADDING,SocialMediaTunables.FRIENDS_SCROLLBAR_PADDING,_loc1_);
         this.txtEmptyStateTitle.htmlText = KeysGP.SOCIAL_MEDIA_EMPTY_STATE_TITLE.toString();
         this.txtEmptyStateTitle.visible = false;
         this.txtEmptyStateDescription.htmlText = KeysGP.SOCIAL_MEDIA_EMPTY_STATE_DESCRIPTION.toString();
         this.txtEmptyStateDescription.visible = false;
         this.mcEmptyStateBackground.visible = false;
         this.mData.addEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false,0,true);
         CommunicationManager.AddMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationshipData,this,RelationshipByIdInfo);
         CommunicationManager.AddMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationshipData,this,RelationshipDeleteById);
         CommunicationManager.AddMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationship,this,RelationshipByIdInfo);
         CommunicationManager.AddMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationship,this,RelationshipDeleteById);
         CommunicationManager.AddMessageListener("NoMoreContactsToAdd",this.HandleNoMoreContactsToAdd,this);
         CommunicationManager.AddMessageListener("MoreContactsToAdd",this.HandleMoreContactsToAdd,this);
         super.Initialize();
      }
      
      public function Dispose() : void
      {
         this.btnAddToContactList.removeEventListener(PushButtonEvent.CLICK,this.OnAddToContactListClick);
         CommunicationManager.RemoveMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationshipData,this);
         CommunicationManager.RemoveMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationshipData,this);
         CommunicationManager.RemoveMessageListener("UpdateSimRelationshipById",this.HandleUpdateSimRelationship,this);
         CommunicationManager.RemoveMessageListener("DeleteSimRelationshipById",this.HandleDeleteSimRelationship,this);
         CommunicationManager.RemoveMessageListener("NoMoreContactsToAdd",this.HandleNoMoreContactsToAdd,this);
         CommunicationManager.RemoveMessageListener("MoreContactsToAdd",this.HandleMoreContactsToAdd,this);
         mcList.RemoveDataFeed();
         this.mData.removeEventListener(DataFeedEvent.SORT_FILTER,this.OnFeedSortFilter,false);
         this.mData.Destroy();
         this.mFriendsCount = 0;
         this.mFriendsList = new Array();
         this.mSimId = null;
      }
      
      override public function OnShow(param1:Array) : void
      {
         super.OnShow(param1);
      }
      
      protected function HandleUpdateSimRelationship(param1:RelationshipByIdInfo) : void
      {
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
         this.RefreshLayout();
         dispatchEvent(new Event(FRIENDS_UPDATED));
      }
      
      protected function HandleNoMoreContactsToAdd() : void
      {
         this.mbCanAddNewContacts = false;
         this.RefreshLayout();
      }
      
      protected function HandleMoreContactsToAdd() : void
      {
         this.mbCanAddNewContacts = true;
         this.RefreshLayout();
      }
      
      protected function LoadFriends() : void
      {
         this.mData.HandleSimActivated(this.mSimId);
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
      }
      
      protected function HandleDeleteSimRelationshipData(param1:RelationshipDeleteById) : void
      {
         this.mData.HandleSimDeleteRelationship(param1);
      }
      
      protected function HandleUpdateSimRelationshipData(param1:RelationshipByIdInfo) : void
      {
         this.mData.HandleUpdateSimRelationship(param1);
      }
      
      protected function HandleDeleteSimRelationship(param1:RelationshipDeleteById) : void
      {
         this.mData.FilterOnRelationship(RelationshipFilterTypes.SOCIAL_MEDIA_FRIEND);
         this.RefreshLayout();
         dispatchEvent(new Event(FRIENDS_UPDATED));
      }
      
      protected function RefreshLayout() : void
      {
         if(this.mFriendsCount < 1)
         {
            this.txtEmptyStateTitle.visible = true;
            this.txtEmptyStateDescription.visible = true;
            this.mcEmptyStateBackground.visible = true;
         }
         else
         {
            this.txtEmptyStateTitle.visible = false;
            this.txtEmptyStateDescription.visible = false;
            this.mcEmptyStateBackground.visible = false;
            mcBackground.height = SocialMediaTunables.FRIENDS_TAB_PANEL_HEIGHT;
            this.btnAddToContactList.y = mcBackground.height - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.mBot - this.btnAddToContactList.height;
            mcList.height = this.btnAddToContactList.y - SocialMediaTunables.FRIENDS_TAB_PANEL_PADDING - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.mTop;
            mcList.width = mcBackground.width - SocialMediaTunables.FRIENDS_TAB_PANEL_MARGINS.Horizontal;
         }
         if(!this.mbCanAddNewContacts)
         {
            this.btnAddToContactList.enabled = false;
            this.btnAddToContactList.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_FRIEND_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnAddToContactList.TooltipExt.SetText(null);
            this.btnAddToContactList.enabled = true;
         }
      }
      
      protected function OnFeedSortFilter(param1:DataFeedEvent) : void
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:RelationshipInfo = null;
         this.mFriendsCount = param1.mIndicesArray.length;
         this.mFriendsList = new Array();
         for each(_loc2_ in param1.mIndicesArray)
         {
            _loc3_ = param1.mDataArray[_loc2_];
            this.mFriendsList.push(_loc3_.targetId);
         }
      }
      
      protected function OnAddToContactListClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_friend_picker_interaction,this.mSimId,this.mSimId);
      }
      
      override protected function InitializeGamepadInput() : void
      {
         super.InitializeGamepadInput();
         var _loc1_:* = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.DELETE)).AllowWhileModalOpen(true).SetValidCheck(null).CallFunction(this.RemoveFriend);
         mListAdapter.AddInputAction(_loc1_);
         this.mMainAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnAddToContactList],true);
         this.mMainAdapter.SetDefaultHighlight(this.btnAddToContactList);
         this.mMainAdapter.OnLeaveCall(this.HandleMainLeave);
      }
      
      override public function IsFocused() : Boolean
      {
         return Boolean(super.IsFocused()) || NavManager.Instance.CurrentFocusable == this.mMainAdapter;
      }
      
      override protected function HandleListLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.DOWN)
         {
            NavManager.Instance.FocusPan(this.mMainAdapter,param1.CreateEnterParams());
         }
         else if(Boolean(mLeaveCallback))
         {
            mLeaveCallback(param1);
         }
      }
      
      protected function HandleMainLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.UP && this.mFriendsCount > 0 && Boolean(mListAdapter))
         {
            NavManager.Instance.FocusPan(mListAdapter,param1.CreateEnterParams());
         }
         else if(Boolean(mLeaveCallback))
         {
            mLeaveCallback(param1);
         }
      }
      
      override public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         super.OnInputEventCall(param1,param2);
         if(param1 != InputAdapterEvent.LEAVE)
         {
            this.mMainAdapter.OnInputEventCall(param1,param2);
         }
         return this;
      }
      
      override public function Exit() : void
      {
         super.Exit();
         this.mMainAdapter.Exit();
      }
      
      override public function GetTargetInputAdapter() : IInputAdapter
      {
         if(this.mFriendsCount > 0)
         {
            return mListAdapter;
         }
         return this.mMainAdapter;
      }
      
      protected function RemoveFriend() : void
      {
         var _loc3_:SocialMediaFriendCellView = null;
         var _loc1_:Vector.<IView> = mcList.mGridLayout.GetAllCells();
         var _loc2_:int = int(mListAdapter.GetHighlightedIndex());
         if(_loc1_.length > _loc2_)
         {
            _loc3_ = _loc1_[_loc2_] as SocialMediaFriendCellView;
            if(_loc3_)
            {
               _loc3_.RemoveFriend();
            }
         }
      }
   }
}

