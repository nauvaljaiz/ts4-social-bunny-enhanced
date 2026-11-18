package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gamedata.Gameplay.SocialMedia.SocialMediaDialog;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.controllers.SelectableGroup;
   import olympus.controls.GUIComponent;
   import olympus.controls.IconComponent;
   import olympus.events.GenericEvent;
   import olympus.events.PushButtonEvent;
   import olympus.events.ScrollerEvent;
   import olympus.events.SelectableGroupEvent;
   import olympus.events.SmoothSliderEvent;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.extensions.MouseKeyboardVisibilityExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.gamepad.NavManager;
   import olympus.gui.buttons.Button;
   import olympus.gui.buttons.TextButton;
   import olympus.gui.sliders.Slider;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.adapters.BidirectionalGroupAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.utils.ImageUtils;
   import olympus.utils.SystemUtils;
   import olympus.utils.TextUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   import widgets.shared.controls.Console.LegendIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public class SocialMediaPanel extends GUIComponent implements IInputFocusable
   {
      
      public static const PANEL_MODE_FEED:int = 0;
      
      public static const PANEL_MODE_FRIENDS:int = 1;
      
      public static const PANEL_MODE_MESSAGES:int = 2;
      
      public static const PANEL_MODE_VERIFIED:int = 3;
      
      protected static const PANEL_HEIGHT:Number = 316;
      
      protected static const VERIFIED_PANEL_HEIGHT:Number = SocialMediaTunables.FEED_TAB_PANEL_HEIGHT;
      
      protected static const VERIFIED_CARD_X:Number = 7;
      
      protected static const VERIFIED_CARD_W:Number = 492;
      
      protected static const VERIFIED_BTN_W:Number = 138;
      
      protected static const VERIFIED_BTN_GAP:Number = 18;
      
      protected static const VERIFIED_BTN_LEFT_OVERHANG:Number = 20;
      
      public var mcBackground:MovieClip;
      
      public var mcSimPortrait:MovieClip;
      
      public var mcSimName:MovieClip;
      
      public var mcFollowers:MovieClip;
      
      public var btnFeedTabButton:TextButton;
      
      public var btnFriendsTabButton:TextButton;
      
      public var btnMessagesTabButton:TextButton;
      
      public var btnVerifiedTabButton:FriendsTabTextButton;
      
      public var btnClose:Button;
      
      public var mcFeedPanel:SocialMediaTabPanelBase;
      
      public var mcFriendsPanel:SocialMediaTabPanelBase;
      
      public var mcMessagesPanel:SocialMediaTabPanelBase;
      
      public var mcVerifiedPanel:SocialMediaFeedTabPanel;
      
      public var btnNewPost:TextButton;
      
      public var btnNewEventPost:TextButton;
      
      public var mcControllerTabLeft:LegendIcon;
      
      public var mcControllerTabRight:LegendIcon;
      
      protected var mcPostsBadge:MovieClip;
      
      protected var mcMessagesBadge:MovieClip;
      
      protected var mNativeFeedItems:Array = new Array();
      
      protected var mVerifiedState:Object = null;
      
      protected var mcVerifiedBadge:Sprite;
      
      protected var mbVerifiedRefreshPending:Boolean = false;
      
      protected var mVerifiedCanvas:Sprite;
      
      protected var mVerifiedMask:Sprite;
      
      protected var mVerifiedScrollbar:Sprite;
      
      protected var mVerifiedOverlay:Sprite;
      
      protected var mVerifiedScrollY:Number = 0;
      
      protected var mVerifiedContentH:Number = 0;
      
      protected var mbVerifiedConfirming:Boolean = false;
      
      protected var mbVerifiedListDetached:Boolean = false;
      
      protected var mJsonStr:String = "";
      
      protected var mJsonPos:int = 0;
      
      protected var mSocialMediaDialogData:SocialMediaDialog;
      
      protected var mPanelTabGroup:SelectableGroup;
      
      protected var mTabPanelMap:Object;
      
      protected var mCurrentPanel:SocialMediaTabPanelBase;
      
      protected var mbInPanelTabSelected:Boolean = false;
      
      protected var mInShow:Boolean;
      
      protected var mTabbingAdapter:BidirectionalGroupAdapter;
      
      protected var mMainAdapter:BidirectionalGroupAdapter;
      
      protected var mbIsClosing:Boolean = false;
      
      public function SocialMediaPanel()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.btnClose.addEventListener(PushButtonEvent.CLICK,this.OnCloseClick,false,0,true);
         MouseKeyboardVisibilityExtension.Add(this.btnClose);
         this.btnNewPost.htmlText = KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON.toString();
         this.btnNewPost.addEventListener(PushButtonEvent.CLICK,this.OnNewPostClick,false,0,true);
         this.btnNewEventPost.htmlText = KeysGP.SOCIAL_MEDIA_NEW_POST_BUTTON.toString();
         this.btnNewEventPost.addEventListener(PushButtonEvent.CLICK,this.OnNewEventPostClick,false,0,true);
         InputModeVisibilityExtension.ShowForController(this.mcControllerTabLeft);
         InputModeVisibilityExtension.ShowForController(this.mcControllerTabRight);
         this.mcControllerTabLeft.ActionCode = ActionCodes.TAB_LEFT;
         this.mcControllerTabRight.ActionCode = ActionCodes.TAB_RIGHT;
         this.mTabPanelMap = new Object();
         var _loc1_:SelectableGroup = new SelectableGroup();
         this.btnFeedTabButton.htmlText = KeysGP.SOCIAL_MEDIA_FEED_TAB_LABEL.toString();
         _loc1_.Add(this.btnFeedTabButton,true);
         this.btnFriendsTabButton.htmlText = KeysGP.SOCIAL_MEDIA_FRIENDS_TAB_LABEL.toString();
         _loc1_.Add(this.btnFriendsTabButton,true);
         this.btnMessagesTabButton.htmlText = KeysGP.SOCIAL_MEDIA_MESSAGES_TAB_LABEL.toString();
         _loc1_.Add(this.btnMessagesTabButton,true);
         this.btnVerifiedTabButton = new FriendsTabTextButton();
         this.btnVerifiedTabButton.name = "btnVerifiedTabButton";
         this.btnVerifiedTabButton.htmlText = "Verified";
         this.addChild(this.btnVerifiedTabButton);
         _loc1_.Add(this.btnVerifiedTabButton,true);
         _loc1_.addEventListener(SelectableGroupEvent.SELECTION_CHANGED,this.OnPanelTabSelected,false,0,true);
         this.mPanelTabGroup = _loc1_;
         this.mcPostsBadge = this.btnFeedTabButton["mcPostsBadge"];
         this.mcPostsBadge.visible = false;
         this.mcMessagesBadge = this.btnMessagesTabButton["mcMessagesBadge"];
         this.mcMessagesBadge.visible = false;
         if(this.btnVerifiedTabButton["mcPostsBadge"] != null)
         {
            this.btnVerifiedTabButton["mcPostsBadge"].visible = false;
         }
         this.LayoutTabButtons();
         this.mcVerifiedBadge = this.CreateVerifiedBadge(22);
         this.mcVerifiedBadge.visible = false;
         this.addChild(this.mcVerifiedBadge);
         this.InitGamepad();
      }
      
      protected function LayoutTabButtons() : void
      {
         var tabW:Number = this.btnFriendsTabButton.x - this.btnFeedTabButton.x;
         if(tabW <= 0)
         {
            tabW = 135;
         }
         var totalW:Number = tabW * 4;
         var startX:Number = (this.mcBackground.width - totalW) * 0.5;
         if(startX < 0)
         {
            startX = 0;
         }
         var tabY:Number = this.btnMessagesTabButton.y;
         this.btnFeedTabButton.x = startX;
         this.btnFeedTabButton.y = tabY;
         this.btnFriendsTabButton.x = startX + tabW;
         this.btnFriendsTabButton.y = tabY;
         this.btnMessagesTabButton.x = startX + tabW * 2;
         this.btnMessagesTabButton.y = tabY;
         this.btnVerifiedTabButton.x = startX + tabW * 3;
         this.btnVerifiedTabButton.y = tabY;
         if(this.mcControllerTabLeft != null)
         {
            this.mcControllerTabLeft.x = 2;
            this.mcControllerTabLeft.y = tabY - 26;
         }
         if(this.mcControllerTabRight != null)
         {
            this.mcControllerTabRight.x = this.mcBackground.width - 24;
            this.mcControllerTabRight.y = tabY - 26;
         }
      }
      
      protected function ParseVerifiedState() : void
      {
         if(this.mSocialMediaDialogData == null)
         {
            this.mNativeFeedItems = new Array();
            this.mVerifiedState = null;
            return;
         }
         var parsed:Object = this.ExtractVerifiedState(this.mSocialMediaDialogData.feed_items);
         this.mNativeFeedItems = parsed["nativeItems"] as Array;
         if(this.mNativeFeedItems == null)
         {
            this.mNativeFeedItems = new Array();
         }
         this.mVerifiedState = parsed["state"] as Object;
         this.mbVerifiedRefreshPending = false;
      }
      
      protected function RefreshVerifiedHeader() : void
      {
         if(this.mcVerifiedBadge == null)
         {
            return;
         }
         var sub:Object = this.mVerifiedState != null ? this.mVerifiedState.subscription : null;
         var active:Boolean = sub != null && sub.benefits_active === true;
         this.mcVerifiedBadge.visible = active;
         if(active)
         {
            this.mcVerifiedBadge.x = this.mcSimName.x + this.mcSimName.txtSimName.textWidth * 0.5 + 10;
            this.mcVerifiedBadge.y = this.mcSimName.y + 8;
         }
      }
      
      protected function RefreshVerifiedTab() : void
      {
         if(this.mcVerifiedPanel == null)
         {
            return;
         }
         this.EnsureVerifiedChrome();
         this.RenderVerifiedTab();
         if(this.mVerifiedState == null && !this.mbVerifiedRefreshPending)
         {
            this.mbVerifiedRefreshPending = true;
            this.SendVerifiedAction("refresh");
         }
      }
      
      // =================================================================
      // Additive Verified tab implementation
      // =================================================================

      protected function GetVerifiedViewportHeight() : Number
      {
         if(this.mcVerifiedPanel != null && this.mcVerifiedPanel.mcList != null && this.mcVerifiedPanel.mcList.height > 0)
         {
            return Math.max(200,this.mcVerifiedPanel.mcList.height - SocialMediaTunables.FEED_SCROLLBAR_PADDING.Vertical);
         }
         return VERIFIED_PANEL_HEIGHT - SocialMediaTunables.FEED_TAB_PANEL_MARGINS.Vertical - SocialMediaTunables.FEED_SCROLLBAR_PADDING.Vertical;
      }

      protected function InitVerifiedChrome() : void
      {
         if(this.mcVerifiedPanel == null || this.mVerifiedCanvas != null)
         {
            return;
         }
         this.mcVerifiedPanel.txtEmptyStateTitle.visible = false;
         this.mcVerifiedPanel.txtEmptyStateDescription.visible = false;
         this.mcVerifiedPanel.mcFeedPanelFTUE.visible = false;
         this.mcVerifiedPanel.mcBackground.visible = true;

         this.mVerifiedMask = new Sprite();
         this.mVerifiedMask.visible = false;
         this.mVerifiedMask.mouseEnabled = false;
         this.mcVerifiedPanel.addChild(this.mVerifiedMask);

         this.mVerifiedCanvas = new Sprite();
         this.mcVerifiedPanel.addChild(this.mVerifiedCanvas);

         this.mVerifiedScrollbar = new Sprite();
         this.mVerifiedScrollbar.visible = false;
         this.mVerifiedScrollbar.mouseEnabled = false;
         this.mcVerifiedPanel.addChild(this.mVerifiedScrollbar);

         this.mVerifiedOverlay = new Sprite();
         this.mVerifiedOverlay.visible = false;
         this.mcVerifiedPanel.addChild(this.mVerifiedOverlay);

         this.ConfigureVerifiedNativeSlider();

         this.mcVerifiedPanel.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnVerifiedMouseWheel,false,0,true);
         this.ResizeVerifiedChrome();
      }

      protected function ConfigureVerifiedNativeSlider() : void
      {
         if(this.mcVerifiedPanel == null || this.mcVerifiedPanel.mcList == null)
         {
            return;
         }
         var list:* = this.mcVerifiedPanel.mcList;
         list.visible = true;
         list.mouseEnabled = false;
         list.ScrollerAmount = 28;
         if(list.mcBackground != null)
         {
            list.mcBackground.visible = false;
            list.mcBackground.mouseEnabled = false;
         }
         if(list.mSlider != null)
         {
            list.mSlider.AlwaysVisible = false;
         }
         if(list.mGridLayout != null && !this.mbVerifiedListDetached)
         {
            // Detach only after InitializeScrollList created mGridLayout so
            // GridView / empty ArrayDataFeed events never reset mSlider to 0.
            try
            {
               list.RemoveDataFeed();
               list.Reset();
            }
            catch(detachError:Error)
            {
            }
            this.mbVerifiedListDetached = true;
         }
         if(list.mScrollerView != null)
         {
            var sv:* = list.mScrollerView;
            sv.visible = true;
            sv.mouseEnabled = false;
            sv.mouseChildren = true;
            if(sv.mcBackground != null)
            {
               sv.mcBackground.visible = true;
               sv.mcBackground.alpha = 0;
               sv.mcBackground.mouseEnabled = true;
            }
            var gridDisp:DisplayObject = sv.mScrollableContent as DisplayObject;
            if(gridDisp != null)
            {
               gridDisp.visible = false;
               gridDisp.mask = null;
            }
            if(this.mVerifiedCanvas != null && sv.mcMask != null)
            {
               sv.mcMask.visible = true;
               if(this.mVerifiedCanvas.parent != sv)
               {
                  sv.addChild(this.mVerifiedCanvas);
               }
               this.mVerifiedCanvas.x = 0;
               this.mVerifiedCanvas.mask = sv.mcMask;
               if(this.mVerifiedMask != null)
               {
                  this.mVerifiedMask.visible = false;
                  this.mVerifiedMask.graphics.clear();
               }
            }
         }
         if(this.mVerifiedOverlay != null && this.mVerifiedOverlay.parent == this.mcVerifiedPanel)
         {
            this.mcVerifiedPanel.setChildIndex(this.mVerifiedOverlay,this.mcVerifiedPanel.numChildren - 1);
         }
         if(list.mSlider != null)
         {
            list.mSlider.removeEventListener(SmoothSliderEvent.SNAP,this.OnVerifiedSliderChanged);
            list.mSlider.removeEventListener(SmoothSliderEvent.SLIDE,this.OnVerifiedSliderChanged);
            list.mSlider.removeEventListener(SmoothSliderEvent.DRAG_CONTINUE,this.OnVerifiedSliderChanged);
            list.mSlider.addEventListener(SmoothSliderEvent.SNAP,this.OnVerifiedSliderChanged);
            list.mSlider.addEventListener(SmoothSliderEvent.SLIDE,this.OnVerifiedSliderChanged);
            list.mSlider.addEventListener(SmoothSliderEvent.DRAG_CONTINUE,this.OnVerifiedSliderChanged);
         }
         this.mcVerifiedPanel.removeEventListener(Event.ENTER_FRAME,this.OnVerifiedEnterFrame);
         this.mcVerifiedPanel.addEventListener(Event.ENTER_FRAME,this.OnVerifiedEnterFrame);
      }

      protected function SyncVerifiedScrollFromSlider() : void
      {
         if(this.mcVerifiedPanel == null || this.mVerifiedCanvas == null || this.mcVerifiedPanel.mcList == null)
         {
            return;
         }
         var slider:Slider = this.mcVerifiedPanel.mcList.mSlider;
         if(slider == null)
         {
            return;
         }
         var viewH:Number = this.GetVerifiedViewportHeight();
         var maxScroll:Number = Math.max(0,Math.round(this.mVerifiedContentH - viewH));
         var clamped:Number = Math.round(Math.max(0,Math.min(maxScroll,slider.Value)));
         var targetY:Number = -clamped;
         if(this.mVerifiedScrollY != clamped || Math.round(this.mVerifiedCanvas.y) != targetY)
         {
            this.mVerifiedScrollY = clamped;
            this.mVerifiedCanvas.y = targetY;
         }
      }

      protected function OnVerifiedSliderChanged(event:SmoothSliderEvent) : void
      {
         this.SyncVerifiedScrollFromSlider();
      }

      protected function OnVerifiedEnterFrame(event:Event) : void
      {
         if(this.mcVerifiedPanel == null || !this.mcVerifiedPanel.visible || this.mCurrentPanel != this.mcVerifiedPanel)
         {
            return;
         }
         this.SyncVerifiedScrollFromSlider();
      }

      protected function EnsureVerifiedChrome() : void
      {
         if(this.mcVerifiedPanel == null)
         {
            return;
         }
         this.InitVerifiedChrome();
         this.ConfigureVerifiedNativeSlider();
         this.mcVerifiedPanel.txtEmptyStateTitle.visible = false;
         this.mcVerifiedPanel.txtEmptyStateDescription.visible = false;
         this.mcVerifiedPanel.mcFeedPanelFTUE.visible = false;
         this.mcVerifiedPanel.mcBackground.visible = true;
      }

      protected function ResizeVerifiedChrome() : void
      {
         if(this.mcVerifiedPanel == null)
         {
            return;
         }
         var w:Number = this.mcVerifiedPanel.mcBackground.width;
         this.mcVerifiedPanel.mcBackground.height = VERIFIED_PANEL_HEIGHT;
         if(this.mcVerifiedPanel.mcList != null)
         {
            this.mcVerifiedPanel.mcList.width = w - SocialMediaTunables.FEED_TAB_PANEL_MARGINS.Horizontal;
            this.mcVerifiedPanel.mcList.height = VERIFIED_PANEL_HEIGHT - SocialMediaTunables.FEED_TAB_PANEL_MARGINS.Vertical;
         }
         this.RenderVerifiedTab();
      }

      protected function OnVerifiedMouseWheel(event:MouseEvent) : void
      {
         if(this.mbVerifiedConfirming || this.mVerifiedCanvas == null || this.mcVerifiedPanel == null)
         {
            return;
         }
         if(this.mcVerifiedPanel.mcList != null && event.target is DisplayObject && this.mcVerifiedPanel.mcList.contains(event.target as DisplayObject))
         {
            return;
         }
         var viewH:Number = this.GetVerifiedViewportHeight();
         var maxScroll:Number = Math.max(0,Math.round(this.mVerifiedContentH - viewH));
         var delta:Number = -event.delta * 28;
         var slider:Slider = this.mcVerifiedPanel.mcList != null ? this.mcVerifiedPanel.mcList.mSlider : null;
         if(slider != null && maxScroll > 0)
         {
            slider.SetCurrentValue(delta,false,false,true);
         }
         else
         {
            this.mVerifiedScrollY = Math.round(Math.max(0,Math.min(maxScroll,this.mVerifiedScrollY + delta)));
            this.mVerifiedCanvas.y = -this.mVerifiedScrollY;
         }
      }

      protected function DrawVerifiedMeter(x:Number,y:Number,w:Number,h:Number,pct:Number,color:uint) : void
      {
         var safePct:Number = Math.max(0,Math.min(100,pct));
         this.mVerifiedCanvas.graphics.beginFill(0xECE6F2,1);
         this.mVerifiedCanvas.graphics.drawRoundRect(x,y,w,h,4,4);
         this.mVerifiedCanvas.graphics.endFill();
         if(safePct > 0)
         {
            this.mVerifiedCanvas.graphics.beginFill(color,1);
            this.mVerifiedCanvas.graphics.drawRoundRect(x,y,Math.max(h,w * safePct / 100),h,4,4);
            this.mVerifiedCanvas.graphics.endFill();
         }
      }

      protected function DrawVerifiedAudienceBar(x:Number,y:Number,w:Number,h:Number,loyal:Number,casual:Number,drama:Number,anti:Number) : void
      {
         var total:Number = loyal + casual + drama + anti;
         if(total <= 0)
         {
            total = 100;
         }
         var lw:Number = w * loyal / total;
         var cw:Number = w * casual / total;
         var dw:Number = w * drama / total;
         var aw:Number = w - lw - cw - dw;
         this.mVerifiedCanvas.graphics.beginFill(0x2E7D32,1);
         this.mVerifiedCanvas.graphics.drawRect(x,y,Math.max(0,lw),h);
         this.mVerifiedCanvas.graphics.endFill();
         this.mVerifiedCanvas.graphics.beginFill(0x74A9D8,1);
         this.mVerifiedCanvas.graphics.drawRect(x + lw,y,Math.max(0,cw),h);
         this.mVerifiedCanvas.graphics.endFill();
         this.mVerifiedCanvas.graphics.beginFill(0xF5A623,1);
         this.mVerifiedCanvas.graphics.drawRect(x + lw + cw,y,Math.max(0,dw),h);
         this.mVerifiedCanvas.graphics.endFill();
         this.mVerifiedCanvas.graphics.beginFill(0xB3261E,1);
         this.mVerifiedCanvas.graphics.drawRect(x + lw + cw + dw,y,Math.max(0,aw),h);
         this.mVerifiedCanvas.graphics.endFill();
      }

      protected function DrawVerifiedScrollbar() : void
      {
         if(this.mcVerifiedPanel == null || this.mcVerifiedPanel.mcList == null || this.mcVerifiedPanel.mcList.mSlider == null)
         {
            return;
         }
         var slider:Slider = this.mcVerifiedPanel.mcList.mSlider;
         var viewH:Number = this.GetVerifiedViewportHeight();
         var maxScroll:Number = Math.max(0,Math.round(this.mVerifiedContentH - viewH));
         slider.AlwaysVisible = false;
         slider.SetThumbSize(this.mVerifiedContentH <= 0 ? 1 : Math.min(1,viewH / this.mVerifiedContentH));
         slider.SetValueRange(0,maxScroll);
         this.mVerifiedScrollY = Math.round(Math.max(0,Math.min(maxScroll,this.mVerifiedScrollY)));
         slider.SetCurrentValue(this.mVerifiedScrollY,false,true,false);
         if(this.mVerifiedCanvas != null)
         {
            this.mVerifiedCanvas.y = -this.mVerifiedScrollY;
         }
      }

      protected function RenderVerifiedTab() : void
      {
         if(this.mcVerifiedPanel == null || this.mVerifiedCanvas == null)
         {
            return;
         }
         this.EnsureVerifiedChrome();
         while(this.mVerifiedCanvas.numChildren > 0)
         {
            this.mVerifiedCanvas.removeChildAt(0);
         }
         var viewH:Number = this.GetVerifiedViewportHeight();
         this.mVerifiedContentH = viewH;
         this.mVerifiedCanvas.y = -this.mVerifiedScrollY;

         if(this.mVerifiedState == null)
         {
            this.DrawVerifiedLoading();
            this.DrawVerifiedScrollbar();
            return;
         }

         var plan:Object = this.mVerifiedState.plan != null ? this.mVerifiedState.plan : new Object();
         var sub:Object = this.mVerifiedState.subscription != null ? this.mVerifiedState.subscription : new Object();
         var eligibility:Object = this.mVerifiedState.eligibility != null ? this.mVerifiedState.eligibility : new Object();
         var perms:Object = this.mVerifiedState.permissions != null ? this.mVerifiedState.permissions : new Object();
         var status:String = String(sub.status != null ? sub.status : "not_subscribed");
         var statusLabel:String = String(sub.status_label != null ? sub.status_label : "Not Subscribed");
         var statusDetail:String = String(sub.status_detail != null ? sub.status_detail : "");

         var cardX:Number = VERIFIED_CARD_X;
         var cardW:Number = VERIFIED_CARD_W;
         var innerX:Number = cardX + 16;

         var y:Number = 4;
         this.AddVerifiedCard(cardX,y,cardW,136,0x5A2B6B,0,12);
         this.AddVerifiedLabel("Social Bunny Verified",18,0xFFFFFF,true,innerX,y + 14,320,26);
         var tagline:String = String(plan.tagline != null ? plan.tagline : "Get recognized with an official verification badge and unlock exclusive account benefits.");
         this.AddVerifiedLabel(tagline,12,0xEBDDF1,false,innerX,y + 42,324,48,true);
         var badge:Sprite = this.CreateVerifiedBadge(50);
         badge.x = cardX + cardW - 66;
         badge.y = y + 18;
         this.mVerifiedCanvas.addChild(badge);
         var priceLabel:String = String(plan.price_label != null ? plan.price_label : "\u00A7?");
         var intervalLabel:String = String(plan.billing_interval_label != null ? plan.billing_interval_label : "per Sim week");
         this.AddVerifiedLabel(priceLabel + " " + intervalLabel,14,0xFFFFFF,true,innerX,y + 98,284,24);
         this.DrawVerifiedStatusPill(statusLabel,cardX + cardW - 172,y + 96,156,26,this.VerifiedStatusColor(status));

         y += 148;

         var result:Object = this.mVerifiedState.last_result;
         if(result != null && result.message != null && String(result.message) != "")
         {
            var ok:Boolean = result.ok != false;
            var bannerColor:uint = ok ? 0xE7F5EA : 0xFBE9E9;
            var bannerBorder:uint = ok ? 0x9ED3A8 : 0xE6B4B4;
            var textColor:uint = ok ? 0x2E7D32 : 0xB3261E;
            this.AddVerifiedCard(cardX,y,cardW,56,bannerColor,bannerBorder,8);
            this.AddVerifiedLabel(String(result.message),12,textColor,false,cardX + 14,y + 10,cardW - 28,38,true);
            y += 66;
         }

         this.AddVerifiedCard(cardX,y,cardW,114,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Subscription status",12,0x6F5B79,true,innerX,y + 10,200,18);
         this.AddVerifiedLabel(statusLabel,16,this.VerifiedStatusColor(status),true,innerX,y + 30,260,24);
         if(statusDetail == "")
         {
            statusDetail = eligibility.reason != null ? String(eligibility.reason) : "";
         }
         this.AddVerifiedLabel(statusDetail,12,0x241A2B,false,innerX,y + 58,274,48,true);

         var rightX:Number = cardX + 304;
         var nextBillingHeading:String = "Next billing";
         if(status == "cancelled" || (status == "active" && sub.auto_renew !== true))
         {
            nextBillingHeading = "Benefits end";
         }
         else if(status == "payment_failed" || status == "grace_period")
         {
            nextBillingHeading = "Grace ends";
         }
         this.AddVerifiedLabel(nextBillingHeading,12,0x6F5B79,true,rightX,y + 10,174,18);
         var nextBilling:String = String(sub.next_billing_label != null ? sub.next_billing_label : "\u2014");
         this.AddVerifiedLabel(nextBilling,12,0x241A2B,true,rightX,y + 32,174,38,true);
         var renewLabel:String = String(sub.auto_renew_label != null ? sub.auto_renew_label : (sub.auto_renew ? "Auto-renew: On" : "Auto-renew: Off"));
         this.AddVerifiedLabel(renewLabel,12,0x6F5B79,false,rightX,y + 76,174,22);

         y += 126;

         var perks:Object = this.mVerifiedState.perks != null ? this.mVerifiedState.perks : new Object();
         var pendingLabel:String = String(perks.pending_payout_label != null ? perks.pending_payout_label : "\u00A70");
         var totalEarningsLabel:String = String(perks.total_earnings_label != null ? perks.total_earnings_label : "\u00A70");
         var bonusFollowers:int = int(perks.total_bonus_followers != null ? perks.total_bonus_followers : 0);
         var multLabel:String = String(perks.follower_multiplier_label != null ? perks.follower_multiplier_label : "2.5x");
         var boostLabel:String = String(perks.boost_cooldown_label != null ? perks.boost_cooldown_label : (sub.benefits_active === true ? "Ready (4h campaign)" : "Subscribe to unlock"));
         var pendingVal:int = int(perks.pending_payout != null ? perks.pending_payout : 0);
         var boostActive:Boolean = perks.boost_active === true;
         var boostProgress:int = int(perks.boost_progress != null ? perks.boost_progress : 0);
         var boostFlw:int = int(perks.boost_followers_gained != null ? perks.boost_followers_gained : 0);
         var boostPayLabel:String = String(perks.boost_payout_label != null ? perks.boost_payout_label : "\u00A70");
         var perksCardH:Number = boostActive ? 132 : 112;

         this.AddVerifiedCard(cardX,y,cardW,perksCardH,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Creator perks & earnings",14,0x241A2B,true,innerX,y + 10,280,22);
         this.AddVerifiedLabel("Algorithm: " + multLabel + " growth",12,0x5A2B6B,true,rightX,y + 12,174,20);
         this.AddVerifiedLabel("Pending payout",12,0x6F5B79,false,innerX,y + 38,140,18);
         this.AddVerifiedLabel(pendingLabel,14,pendingVal > 0 ? 0x2E7D32 : 0x241A2B,true,innerX,y + 56,140,22);
         this.AddVerifiedLabel("Total earned",12,0x6F5B79,false,innerX + 148,y + 38,136,18);
         this.AddVerifiedLabel(totalEarningsLabel,14,0x241A2B,true,innerX + 148,y + 56,136,22);
         this.AddVerifiedLabel("Bonus reach",12,0x6F5B79,false,rightX,y + 38,174,18);
         this.AddVerifiedLabel("+" + String(bonusFollowers) + " followers",14,0x1D9BF0,true,rightX,y + 56,174,22);
         if(boostActive)
         {
            this.AddVerifiedLabel("Campaign: " + boostLabel,12,0x1D9BF0,true,innerX,y + 84,230,20);
            this.AddVerifiedLabel("+" + String(boostFlw) + " flw \u00B7 +" + boostPayLabel,12,0x2E7D32,true,innerX + 236,y + 84,220,20);
            var barW:Number = cardW - 36;
            var pct:Number = Math.max(0,Math.min(100,boostProgress));
            var fillW:Number = Math.round(barW * pct / 100);
            this.mVerifiedCanvas.graphics.beginFill(0xECE6F2,1);
            this.mVerifiedCanvas.graphics.drawRoundRect(innerX,y + 108,barW,10,5,5);
            this.mVerifiedCanvas.graphics.endFill();
            if(fillW > 0)
            {
               this.mVerifiedCanvas.graphics.beginFill(0x1D9BF0,1);
               this.mVerifiedCanvas.graphics.drawRoundRect(innerX,y + 108,Math.max(8,fillW),10,5,5);
               this.mVerifiedCanvas.graphics.endFill();
            }
         }
         else
         {
            this.AddVerifiedLabel("Spotlight Boost: " + boostLabel,12,perks.boost_ready === true ? 0x2E7D32 : 0x6F5B79,true,innerX,y + 84,450,20);
         }

         y += perksCardH + 12;

         var prStudio:Object = this.mVerifiedState.pr_studio != null ? this.mVerifiedState.pr_studio : new Object();
         var prAudience:Object = prStudio.audience_segments != null ? prStudio.audience_segments : new Object();
         var prTier:String = String(prStudio.tier_label != null ? prStudio.tier_label : "No Tier");
         if(prTier == "creator_blue")
         {
            prTier = "Blue";
         }
         else if(prTier == "partner_gold")
         {
            prTier = "Gold";
         }
         else if(prTier == "mogul_obsidian")
         {
            prTier = "Obsidian";
         }
         var prCredibility:int = int(prStudio.credibility != null ? prStudio.credibility : 65);
         var prSafety:int = int(prStudio.brand_safety != null ? prStudio.brand_safety : 80);
         var prBattery:Number = Number(prStudio.social_battery != null ? prStudio.social_battery : 100);
         var prState:String = String(prStudio.cancelation_state != null ? prStudio.cancelation_state : "NORMAL");
         var studioH:Number = 188;
         this.AddVerifiedCard(cardX,y,cardW,studioH,0xFFF9FD,0xDCCFE3,12);
         this.AddVerifiedLabel("PR & Audience Studio",15,0x241A2B,true,innerX,y + 14,300,24);

         var tierColor:uint = prTier == "Obsidian" ? 0x2E2438 : (prTier == "Gold" ? 0xB68A20 : 0x1D9BF0);
         this.DrawVerifiedStatusPill(prTier + " Tier",cardX + cardW - 126,y + 12,110,28,tierColor);

         var metricY:Number = y + 52;
         var metricW:Number = 144;
         var metricGap:Number = 12;
         var metric1X:Number = innerX;
         var metric2X:Number = metric1X + metricW + metricGap;
         var metric3X:Number = metric2X + metricW + metricGap;
         this.AddVerifiedCard(metric1X,metricY,metricW,58,0xFFFFFF,0xE8DFEC,8);
         this.AddVerifiedCard(metric2X,metricY,metricW,58,0xFFFFFF,0xE8DFEC,8);
         this.AddVerifiedCard(metric3X,metricY,metricW,58,0xFFFFFF,0xE8DFEC,8);

         this.AddVerifiedLabel("CREDIBILITY",10,0x8A7893,true,metric1X + 10,metricY + 8,130,14);
         this.AddVerifiedLabel(String(prCredibility) + "/100",16,0x241A2B,true,metric1X + 10,metricY + 26,130,22);
         this.DrawVerifiedMeter(metric1X + 10,metricY + 48,130,5,prCredibility,0x1D9BF0);

         this.AddVerifiedLabel("BRAND SAFETY",10,0x8A7893,true,metric2X + 10,metricY + 8,130,14);
         this.AddVerifiedLabel(String(prSafety) + "/100",16,0x241A2B,true,metric2X + 10,metricY + 26,130,22);
         this.DrawVerifiedMeter(metric2X + 10,metricY + 48,130,5,prSafety,0x7CB342);

         var batteryW:Number = metricW;
         this.AddVerifiedLabel("SOCIAL BATTERY",10,0x8A7893,true,metric3X + 10,metricY + 8,batteryW - 20,14);
         this.AddVerifiedLabel(int(Math.max(0,prBattery)) + "%",16,0x241A2B,true,metric3X + 10,metricY + 26,batteryW - 20,22);
         this.DrawVerifiedMeter(metric3X + 10,metricY + 48,batteryW - 20,5,int(Math.max(0,Math.min(100,prBattery))),0xF5A623);

         var stateY:Number = y + 118;
         this.AddVerifiedCard(innerX,stateY,cardW - 32,58,0xFFFFFF,0xE8DFEC,8);
         this.AddVerifiedLabel("CANCELLATION STATE",10,0x8A7893,true,innerX + 10,stateY + 8,180,14);
         this.AddVerifiedLabel(prState.replace("_"," "),13,prState == "NORMAL" ? 0x2E7D32 : 0xB3261E,true,innerX + 10,stateY + 26,180,20);
         var loyal:Number = Number(prAudience.core_loyalists != null ? prAudience.core_loyalists : 40);
         var casual:Number = Number(prAudience.casual_browsers != null ? prAudience.casual_browsers : 35);
         var drama:Number = Number(prAudience.drama_vultures != null ? prAudience.drama_vultures : 15);
         var anti:Number = Number(prAudience.anti_fans != null ? prAudience.anti_fans : 10);
         var audienceX:Number = innerX + 202;
         var audienceW:Number = cardW - 218;
         this.DrawVerifiedAudienceBar(audienceX,stateY + 18,audienceW,10,loyal,casual,drama,anti);
         this.AddVerifiedLabel("Loyal " + int(loyal) + "%  ·  Casual " + int(casual) + "%",10,0x6F5B79,false,audienceX,stateY + 32,audienceW,14);
         this.AddVerifiedLabel("Drama " + int(drama) + "%  ·  Anti " + int(anti) + "%",10,0x6F5B79,false,audienceX,stateY + 46,audienceW,14);
         y += studioH + 12;

         var benefits:Array = this.mVerifiedState.benefits != null ? this.mVerifiedState.benefits : (plan.benefits != null ? plan.benefits : new Array());
         var rows:int = Math.ceil(benefits.length / 2);
         var benefitRowH:Number = 62;
         var benefitsH:Number = 42 + rows * benefitRowH;
         this.AddVerifiedCard(cardX,y,cardW,benefitsH,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Your Verified benefits",14,0x241A2B,true,innerX,y + 10,300,22);
         var bi:int = 0;
         while(bi < benefits.length)
         {
            var benefit:Object = benefits[bi];
            var col:int = bi % 2;
            var row:int = int(bi / 2);
            var bx:Number = innerX + col * 234;
            var by:Number = y + 38 + row * benefitRowH;
            var check:Sprite = this.CreateVerifiedBadge(14);
            check.x = bx;
            check.y = by + 3;
            this.mVerifiedCanvas.addChild(check);
            this.AddVerifiedLabel(String(benefit.title != null ? benefit.title : "Verified benefit"),12,0x241A2B,true,bx + 22,by - 1,202,20);
            this.AddVerifiedLabel(String(benefit.description != null ? benefit.description : ""),12,0x6F5B79,false,bx + 22,by + 19,202,40,true);
            bi++;
         }
         y += benefitsH + 12;

         var actions:Array = new Array();
         if(perms.can_boost_post === true)
         {
            actions.push({"label":"Boost Reach","action":"boost_post","arg":""});
         }
         if(perms.can_claim_payout === true)
         {
            actions.push({"label":"Claim " + pendingLabel,"action":"claim_payout","arg":""});
         }
         if(perms.can_subscribe === true)
         {
            actions.push({"label":"Subscribe","action":"subscribe_prompt","arg":""});
         }
         if(perms.can_reactivate === true)
         {
            actions.push({"label":"Reactivate","action":"reactivate","arg":""});
         }
         if(perms.can_retry_payment === true)
         {
            actions.push({"label":"Retry Payment","action":"retry_payment","arg":""});
         }
         if(perms.can_cancel === true)
         {
            actions.push({"label":"Cancel","action":"cancel","arg":""});
         }
         if(perms.can_toggle_auto_renew === true)
         {
            var renewOn:Boolean = sub.auto_renew === true;
            actions.push({
               "label":renewOn ? "Auto-Renew: On" : "Auto-Renew: Off",
               "action":"set_auto_renew",
               "arg":renewOn ? "0" : "1"
            });
         }
         actions.push({"label":"Refresh","action":"refresh","arg":""});

         var actionRows:Array = this.SplitVerifiedActions(actions);
         var actionRowH:Number = 42;
         var actionsH:Number = 42 + actionRows.length * actionRowH;
         this.AddVerifiedCard(cardX,y,cardW,actionsH,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Manage subscription",14,0x241A2B,true,innerX,y + 10,300,22);
         var ar:int = 0;
         while(ar < actionRows.length)
         {
            this.AddVerifiedButtonRow(actionRows[ar],y + 38 + ar * actionRowH);
            ar++;
         }
         y += actionsH + 12;

         var history:Array = sub.payment_history != null ? sub.payment_history : new Array();
         var histCount:int = Math.min(5,history.length);
         var histRowH:Number = 26;
         var historyH:Number = histCount > 0 ? 44 + histCount * histRowH : 68;
         this.AddVerifiedCard(cardX,y,cardW,historyH,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Payment history",14,0x241A2B,true,innerX,y + 10,210,22);
         var startLabel:String = String(sub.start_label != null ? sub.start_label : "");
         if(startLabel != "")
         {
            this.AddVerifiedLabel("Started " + startLabel,12,0x6F5B79,false,cardX + 244,y + 12,232,20);
         }
         if(histCount == 0)
         {
            this.AddVerifiedLabel("No payments recorded yet.",12,0x6F5B79,false,innerX,y + 38,440,22);
         }
         else
         {
            var hi:int = 0;
            while(hi < histCount)
            {
               var h:Object = history[hi];
               var hy:Number = y + 38 + hi * histRowH;
               this.AddVerifiedLabel(String(h.date_label != null ? h.date_label : ""),12,0x6F5B79,false,innerX,hy,178,20);
               this.AddVerifiedLabel(String(h.amount_label != null ? h.amount_label : ""),12,0x241A2B,true,innerX + 184,hy,84,20);
               this.AddVerifiedLabel(String(h.status_label != null ? h.status_label : ""),12,this.VerifiedStatusColor(String(h.status != null ? h.status : "")),true,innerX + 274,hy,186,20);
               hi++;
            }
         }
         y += historyH + 12;

         var notices:Array = this.mVerifiedState.notifications != null ? this.mVerifiedState.notifications : new Array();
         var noticeCount:int = Math.min(4,notices.length);
         var noticeRowH:Number = 26;
         var noticeH:Number = 44 + Math.max(1,noticeCount) * noticeRowH;
         this.AddVerifiedCard(cardX,y,cardW,noticeH,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Account activity",14,0x241A2B,true,innerX,y + 10,300,22);
         if(noticeCount == 0)
         {
            this.AddVerifiedLabel("Subscription notifications will appear here.",12,0x6F5B79,false,innerX,y + 38,440,22);
         }
         else
         {
            var ni:int = 0;
            while(ni < noticeCount)
            {
               var n:Object = notices[ni];
               var ny:Number = y + 38 + ni * noticeRowH;
               this.AddVerifiedLabel(String(n.date_label != null ? n.date_label : ""),12,0x6F5B79,false,innerX,ny,122,20);
               this.AddVerifiedLabel(this.ShortenVerified(String(n.message != null ? n.message : ""),46),12,0x241A2B,false,innerX + 128,ny,332,20);
               ni++;
            }
         }
         y += noticeH + 16;

         this.mVerifiedContentH = Math.max(viewH,y);
         this.DrawVerifiedScrollbar();
      }

      protected function DrawVerifiedLoading() : void
      {
         var cardX:Number = VERIFIED_CARD_X;
         var cardW:Number = VERIFIED_CARD_W;
         var innerX:Number = cardX + 16;
         this.AddVerifiedCard(cardX,4,cardW,136,0x5A2B6B,0,12);
         this.AddVerifiedLabel("Social Bunny Verified",18,0xFFFFFF,true,innerX,18,320,26);
         this.AddVerifiedLabel("Loading your subscription details\u2026",12,0xEBDDF1,false,innerX,50,324,36,true);
         var badge:Sprite = this.CreateVerifiedBadge(50);
         badge.x = cardX + cardW - 66;
         badge.y = 22;
         this.mVerifiedCanvas.addChild(badge);
         this.AddVerifiedCard(cardX,152,cardW,96,0xFFFFFF,0xDCCFE3,10);
         this.AddVerifiedLabel("Connecting to the subscription service\u2026",14,0x241A2B,true,innerX,174,450,24);
         this.AddVerifiedLabel("If this message remains, close and reopen Social Bunny.",12,0x6F5B79,false,innerX,202,450,22);
         if(!this.mbVerifiedRefreshPending)
         {
            this.mbVerifiedRefreshPending = true;
            this.SendVerifiedAction("refresh");
         }
      }

      protected function SplitVerifiedActions(actions:Array) : Array
      {
         var rows:Array = new Array();
         var current:Array = new Array();
         var currentW:Number = 0;
         var maxRowW:Number = VERIFIED_CARD_W - 24;
         var i:int = 0;
         while(i < actions.length)
         {
            var width:Number = this.MeasureVerifiedButton(actions[i]);
            if(current.length > 0 && (current.length >= 3 || currentW + VERIFIED_BTN_GAP + width > maxRowW))
            {
               rows.push(current);
               current = new Array();
               currentW = 0;
            }
            current.push(actions[i]);
            currentW += (current.length > 1 ? VERIFIED_BTN_GAP : 0) + width;
            i++;
         }
         if(current.length > 0)
         {
            rows.push(current);
         }
         return rows;
      }

      protected function MeasureVerifiedButton(item:Object) : Number
      {
         return VERIFIED_BTN_W;
      }

      protected function AddVerifiedButtonRow(items:Array, y:Number) : void
      {
         var total:Number = 0;
         var i:int = 0;
         while(i < items.length)
         {
            total += VERIFIED_BTN_W + (i > 0 ? VERIFIED_BTN_GAP : 0);
            i++;
         }
         var visualX:Number = VERIFIED_CARD_X + (VERIFIED_CARD_W - total) * 0.5;
         i = 0;
         while(i < items.length)
         {
            var item:Object = items[i];
            var btn:PostButton_Tag = new PostButton_Tag();
            btn.name = "sbv_" + String(item.action);
            btn["sbvAction"] = String(item.action);
            btn["sbvArg"] = String(item.arg != null ? item.arg : "");
            btn.x = visualX + VERIFIED_BTN_LEFT_OVERHANG;
            btn.y = y;
            btn.addEventListener(PushButtonEvent.CLICK,this.OnVerifiedButtonClick,false,0,true);
            this.mVerifiedCanvas.addChild(btn);
            btn.htmlText = this.ShortenVerified(String(item.label),14);
            visualX += VERIFIED_BTN_W + VERIFIED_BTN_GAP;
            i++;
         }
      }

      protected function DrawVerifiedStatusPill(label:String, x:Number, y:Number, w:Number, h:Number, color:uint) : void
      {
         var pill:Sprite = new Sprite();
         pill.graphics.beginFill(color,1.0);
         pill.graphics.drawRoundRect(0,0,w,h,h * 0.5,h * 0.5);
         pill.graphics.endFill();
         pill.x = x;
         pill.y = y;
         var tf:TextField = this.CreateVerifiedLabel(label,12,0xFFFFFF,true,w - 10,h - 2,false,TextFormatAlign.CENTER);
         tf.x = 5;
         tf.y = Math.max(2,Math.round((h - 18) * 0.5));
         pill.addChild(tf);
         this.mVerifiedCanvas.addChild(pill);
      }

      protected function AddVerifiedCard(x:Number, y:Number, w:Number, h:Number, fill:uint, border:uint, radius:Number) : void
      {
         var card:Sprite = new Sprite();
         if(border != 0)
         {
            card.graphics.lineStyle(1,border,1.0);
         }
         card.graphics.beginFill(fill,1.0);
         card.graphics.drawRoundRect(0,0,w,h,radius,radius);
         card.graphics.endFill();
         card.x = x;
         card.y = y;
         this.mVerifiedCanvas.addChild(card);
      }

      protected function AddVerifiedLabel(
         text:String,
         size:int,
         color:uint,
         bold:Boolean,
         x:Number,
         y:Number,
         w:Number,
         h:Number,
         multiline:Boolean = false
      ) : void
      {
         var tf:TextField = this.CreateVerifiedLabel(text,size,color,bold,w,h,multiline,TextFormatAlign.LEFT);
         tf.x = x;
         tf.y = y;
         this.mVerifiedCanvas.addChild(tf);
      }

      protected function CreateVerifiedLabel(
         text:String,
         size:int,
         color:uint,
         bold:Boolean,
         w:Number,
         h:Number,
         multiline:Boolean,
         align:String
      ) : TextField
      {
         var tf:TextField = new TextField();
         tf.width = w;
         tf.height = h;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.multiline = multiline;
         tf.wordWrap = multiline;
         tf.embedFonts = true;
         var fmt:TextFormat = new TextFormat(bold ? "$HeadlineFont" : "$TextFont",size,color,bold);
         fmt.align = align;
         tf.defaultTextFormat = fmt;
         tf.text = text != null ? text : "";
         tf.setTextFormat(fmt);
         this.FitVerifiedText(tf,w,h,multiline);
         return tf;
      }

      protected function FitVerifiedText(tf:TextField, w:Number, h:Number, multiline:Boolean) : void
      {
         if(tf == null)
         {
            return;
         }
         var fitted:String = String(tf.text != null ? tf.text : "");
         tf.width = w;
         tf.height = h;
         tf.text = fitted;
         tf.setTextFormat(tf.defaultTextFormat);

         if(!multiline)
         {
            while(fitted.length > 1 && tf.textWidth > w - 4)
            {
               fitted = fitted.substr(0,fitted.length - 1);
               tf.text = fitted + "\u2026";
               tf.setTextFormat(tf.defaultTextFormat);
            }
            return;
         }

         var maxChars:int = Math.max(8,int(w / 6));
         while(fitted.length > maxChars && tf.textHeight > h - 4)
         {
            fitted = fitted.substr(0,fitted.length - 1);
            tf.text = fitted + "\u2026";
            tf.setTextFormat(tf.defaultTextFormat);
         }
         while(fitted.length > 1 && (tf.textHeight > h - 2 || tf.textWidth > w - 4))
         {
            fitted = fitted.substr(0,fitted.length - 1);
            tf.text = fitted + "\u2026";
            tf.setTextFormat(tf.defaultTextFormat);
         }
      }

      protected function CreateVerifiedBadge(size:Number) : Sprite
      {
         var badge:Sprite = new Sprite();
         badge.mouseEnabled = false;
         badge.mouseChildren = false;
         this.DrawVerifiedBadge(badge,size);
         return badge;
      }

      protected function DrawVerifiedBadge(badge:Sprite, size:Number) : void
      {
         if(badge == null)
         {
            return;
         }
         badge.graphics.clear();
         if(size <= 0)
         {
            return;
         }
         var cx:Number = size * 0.5;
         var cy:Number = size * 0.5;
         var outer:Number = size * 0.48;
         var inner:Number = size * 0.39;
         var points:int = 12;
         badge.graphics.lineStyle(0,0,0);
         badge.graphics.beginFill(0x1D9BF0,1.0);
         var i:int = 0;
         while(i < points * 2)
         {
            var angle:Number = (Math.PI * 2 * i) / (points * 2) - Math.PI * 0.5;
            var radius:Number = (i % 2 == 0) ? outer : inner;
            var px:Number = cx + Math.cos(angle) * radius;
            var py:Number = cy + Math.sin(angle) * radius;
            if(i == 0)
            {
               badge.graphics.moveTo(px,py);
            }
            else
            {
               badge.graphics.lineTo(px,py);
            }
            i++;
         }
         badge.graphics.lineTo(cx,cy - outer);
         badge.graphics.endFill();
         badge.graphics.lineStyle(Math.max(1.5,size * 0.13),0xFFFFFF,1.0);
         badge.graphics.moveTo(size * 0.26,size * 0.52);
         badge.graphics.lineTo(size * 0.43,size * 0.68);
         badge.graphics.lineTo(size * 0.75,size * 0.34);
      }

      protected function FormatVerifiedMoney(amount:Number) : String
      {
         return "\u00A7" + String(int(Math.round(amount)));
      }

      protected function VerifiedStatusColor(status:String) : uint
      {
         if(status == "active" || status == "eligible" || status == "succeeded" || status == "paid")
         {
            return 0x2E7D32;
         }
         if(status == "payment_failed" || status == "suspended" || status == "failed")
         {
            return 0xB3261E;
         }
         if(status == "payment_pending" || status == "grace_period" || status == "cancelled")
         {
            return 0xB26A00;
         }
         return 0x6F5B79;
      }

      protected function ShortenVerified(src:String, maxChars:int) : String
      {
         if(src == null)
         {
            return "";
         }
         if(src.length <= maxChars)
         {
            return src;
         }
         return src.substr(0,Math.max(0,maxChars - 1)) + "\u2026";
      }

      // --- Verified actions (native PostServerCommand channel) ---------

      protected function SendVerifiedAction(action:String, arg1:String = "", arg2:String = "") : void
      {
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         var ownerId:* = this.mVerifiedState != null && this.mVerifiedState.owner_sim_id != null
            ? this.mVerifiedState.owner_sim_id
            : this.mSocialMediaDialogData.sim_id;
         CommunicationManager.PostServerCommand(
            "sbv.verified",
            String(ownerId),
            action,
            this.EncodeVerifiedArg(arg1),
            this.EncodeVerifiedArg(arg2)
         );
      }

      protected function EncodeVerifiedArg(src:String) : String
      {
         if(src == null || src.length == 0)
         {
            return "%.";
         }
         var hex:String = "0123456789ABCDEF";
         var safe:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~";
         var out:String = "";
         var i:int = 0;
         var len:int = src.length;
         while(i < len)
         {
            var c:int = int(src.charCodeAt(i));
            var ch:String = src.charAt(i);
            if(c < 128 && safe.indexOf(ch) >= 0)
            {
               out += ch;
            }
            else if(c < 128)
            {
               out += "%" + hex.charAt((c >> 4) & 15) + hex.charAt(c & 15);
            }
            else if(c < 2048)
            {
               var b1:int = 192 | (c >> 6);
               var b2:int = 128 | (c & 63);
               out += "%" + hex.charAt((b1 >> 4) & 15) + hex.charAt(b1 & 15) + "%" + hex.charAt((b2 >> 4) & 15) + hex.charAt(b2 & 15);
            }
            else
            {
               var e1:int = 224 | (c >> 12);
               var e2:int = 128 | ((c >> 6) & 63);
               var e3:int = 128 | (c & 63);
               out += "%" + hex.charAt((e1 >> 4) & 15) + hex.charAt(e1 & 15) + "%" + hex.charAt((e2 >> 4) & 15) + hex.charAt(e2 & 15) + "%" + hex.charAt((e3 >> 4) & 15) + hex.charAt(e3 & 15);
            }
            i++;
         }
         return out;
      }

      protected function OnVerifiedButtonClick(event:PushButtonEvent) : void
      {
         var btn:TextButton = event.currentTarget as TextButton;
         if(btn == null)
         {
            return;
         }
         var action:String = String(btn["sbvAction"]);
         var arg:String = String(btn["sbvArg"] != null ? btn["sbvArg"] : "");
         if(action == "subscribe_prompt")
         {
            this.ShowVerifiedConfirm();
            return;
         }
         if(action == "confirm_subscribe")
         {
            this.HideVerifiedConfirm();
            this.SendVerifiedAction("subscribe");
            return;
         }
         if(action == "dismiss")
         {
            this.HideVerifiedConfirm();
            return;
         }
         this.SendVerifiedAction(action,arg);
      }

      protected function ShowVerifiedConfirm() : void
      {
         if(this.mVerifiedState == null || this.mVerifiedOverlay == null)
         {
            return;
         }
         var plan:Object = this.mVerifiedState.plan != null ? this.mVerifiedState.plan : new Object();
         var price:String = String(plan.price_label != null ? plan.price_label : "\u00A7?");
         var interval:String = String(plan.billing_interval_label != null ? plan.billing_interval_label : "per Sim week");

         this.mVerifiedOverlay.visible = true;
         this.mbVerifiedConfirming = true;
         while(this.mVerifiedOverlay.numChildren > 0)
         {
            this.mVerifiedOverlay.removeChildAt(0);
         }

         var shade:Sprite = new Sprite();
         shade.graphics.beginFill(0x000000,0.55);
         shade.graphics.drawRect(0,0,this.mcVerifiedPanel.mcBackground.width,VERIFIED_PANEL_HEIGHT);
         shade.graphics.endFill();
         this.mVerifiedOverlay.addChild(shade);

         var cardW:Number = 432;
         var cardH:Number = 236;
         var card:Sprite = new Sprite();
         card.graphics.lineStyle(1,0xDCCFE3,1.0);
         card.graphics.beginFill(0xFFFFFF,1.0);
         card.graphics.drawRoundRect(0,0,cardW,cardH,12,12);
         card.graphics.endFill();
         card.x = (this.mcVerifiedPanel.mcBackground.width - cardW) * 0.5;
         card.y = (VERIFIED_PANEL_HEIGHT - cardH) * 0.5;
         this.mVerifiedOverlay.addChild(card);

         var title:TextField = this.CreateVerifiedLabel("Confirm Social Bunny Verified",16,0x241A2B,true,cardW - 32,24,false,TextFormatAlign.LEFT);
         title.x = 16;
         title.y = 14;
         card.addChild(title);

         var priceTf:TextField = this.CreateVerifiedLabel(price + " " + interval,16,0x5A2B6B,true,cardW - 32,24,false,TextFormatAlign.LEFT);
         priceTf.x = 16;
         priceTf.y = 44;
         card.addChild(priceTf);

         var body:TextField = this.CreateVerifiedLabel(
            "This will deduct " + price + " from household funds now. Your subscription renews automatically and can be cancelled from this tab at any time.",
            12,
            0x241A2B,
            false,
            cardW - 32,
            66,
            true,
            TextFormatAlign.LEFT
         );
         body.x = 16;
         body.y = 76;
         card.addChild(body);

         var note:TextField = this.CreateVerifiedLabel("Simoleons only. No real-world payment is ever made.",12,0x6F5B79,false,cardW - 32,22,false,TextFormatAlign.LEFT);
         note.x = 16;
         note.y = 146;
         card.addChild(note);

         var pairGap:Number = 24;
         var pairTotalW:Number = VERIFIED_BTN_W * 2 + pairGap;
         var pairStartVisualX:Number = (cardW - pairTotalW) * 0.5;

         var confirm:PostButton_Tag = new PostButton_Tag();
         confirm.name = "sbv_confirm";
         confirm["sbvAction"] = "confirm_subscribe";
         confirm["sbvArg"] = "";
         confirm.x = pairStartVisualX + VERIFIED_BTN_LEFT_OVERHANG;
         confirm.y = 180;
         confirm.addEventListener(PushButtonEvent.CLICK,this.OnVerifiedButtonClick,false,0,true);
         card.addChild(confirm);
         confirm.htmlText = "Confirm";

         var back:PostButton_Tag = new PostButton_Tag();
         back.name = "sbv_dismiss";
         back["sbvAction"] = "dismiss";
         back["sbvArg"] = "";
         back.x = pairStartVisualX + VERIFIED_BTN_W + pairGap + VERIFIED_BTN_LEFT_OVERHANG;
         back.y = 180;
         back.addEventListener(PushButtonEvent.CLICK,this.OnVerifiedButtonClick,false,0,true);
         card.addChild(back);
         back.htmlText = "Back";
      }

      protected function HideVerifiedConfirm() : void
      {
         this.mbVerifiedConfirming = false;
         if(this.mVerifiedOverlay == null)
         {
            return;
         }
         this.mVerifiedOverlay.visible = false;
         while(this.mVerifiedOverlay.numChildren > 0)
         {
            this.mVerifiedOverlay.removeChildAt(0);
         }
      }

      // --- Verified state packet decoding -----------------------------

      protected function ExtractVerifiedState(rawItems:Array) : Object
      {
         var nativeList:Array = new Array();
         var chunks:Array = new Array();
         var newestGeneration:Number = -1;
         if(rawItems != null)
         {
            var packetScan:int = 0;
            while(packetScan < rawItems.length)
            {
               var packetItem:SocialMediaFeedItem = rawItems[packetScan] as SocialMediaFeedItem;
               var scanId:Number = packetItem != null ? Number(packetItem.post_id) : -1;
               if(packetItem != null && scanId >= 9000000 && scanId <= 2147483647)
               {
                  newestGeneration = Math.max(newestGeneration,Math.floor((scanId - 9000000) / 100));
               }
               packetScan++;
            }
            var i:int = 0;
            while(i < rawItems.length)
            {
               var item:SocialMediaFeedItem = rawItems[i] as SocialMediaFeedItem;
               var packetId:Number = item != null ? Number(item.post_id) : -1;
               var packetGeneration:Number = item != null && packetId >= 9000000
                  ? Math.floor((packetId - 9000000) / 100)
                  : -1;
               if(item != null && packetId >= 9000000 && packetId <= 2147483647)
               {
                  if(packetGeneration == newestGeneration)
                  {
                     var idx:int = int(packetId - 9000000) % 100;
                     var chunkText:String = "";
                     if(item.post_text != null)
                     {
                        try
                        {
                           chunkText = item.post_text.toString();
                        }
                        catch(textError:Error)
                        {
                           chunkText = "";
                        }
                        if(chunkText == null || chunkText == "" || chunkText == "{0.String}")
                        {
                           var tokenList:Array = item.post_text.tokens as Array;
                           if(tokenList != null && tokenList.length > 0)
                           {
                              var firstToken:Object = tokenList[0];
                              if(firstToken != null)
                              {
                                 if(firstToken["raw_text"] != null)
                                 {
                                    chunkText = String(firstToken["raw_text"]);
                                 }
                                 else if(firstToken["rawText"] != null)
                                 {
                                    chunkText = String(firstToken["rawText"]);
                                 }
                                 else if(firstToken["string_value"] != null)
                                 {
                                    chunkText = String(firstToken["string_value"]);
                                 }
                                 else if(firstToken["stringValue"] != null)
                                 {
                                    chunkText = String(firstToken["stringValue"]);
                                 }
                                 else if(firstToken["text"] != null)
                                 {
                                    chunkText = String(firstToken["text"]);
                                 }
                              }
                           }
                        }
                     }
                     chunks[idx] = chunkText;
                  }
               }
               else if(item != null)
               {
                  nativeList.push(item);
               }
               i++;
            }
         }

         var parsed:Object = null;
         if(chunks.length > 0)
         {
            var joined:String = "";
            var c:int = 0;
            while(c < chunks.length)
            {
               if(chunks[c] != null)
               {
                  joined += String(chunks[c]);
               }
               c++;
            }
            if(joined.length > 0)
            {
               try
               {
                  parsed = this.ParseVerifiedJson(joined) as Object;
               }
               catch(e:Error)
               {
                  parsed = null;
               }
            }
         }
         return {
            "nativeItems":nativeList,
            "state":parsed
         };
      }

      protected function ParseVerifiedJson(src:String) : *
      {
         this.mJsonStr = src;
         this.mJsonPos = 0;
         return this.ReadVerifiedJsonValue();
      }

      protected function SkipVerifiedJsonWs() : void
      {
         var len:int = this.mJsonStr.length;
         while(this.mJsonPos < len)
         {
            var ch:String = this.mJsonStr.charAt(this.mJsonPos);
            if(ch == " " || ch == "\t" || ch == "\n" || ch == "\r")
            {
               this.mJsonPos++;
            }
            else
            {
               break;
            }
         }
      }

      protected function ReadVerifiedJsonValue() : *
      {
         this.SkipVerifiedJsonWs();
         if(this.mJsonPos >= this.mJsonStr.length)
         {
            return null;
         }
         var ch:String = this.mJsonStr.charAt(this.mJsonPos);
         if(ch == "{")
         {
            return this.ReadVerifiedJsonObject();
         }
         if(ch == "[")
         {
            return this.ReadVerifiedJsonArray();
         }
         if(ch == "\"")
         {
            return this.ReadVerifiedJsonString();
         }
         if(ch == "t")
         {
            this.mJsonPos += 4;
            return true;
         }
         if(ch == "f")
         {
            this.mJsonPos += 5;
            return false;
         }
         if(ch == "n")
         {
            this.mJsonPos += 4;
            return null;
         }
         return this.ReadVerifiedJsonNumber();
      }

      protected function ReadVerifiedJsonObject() : Object
      {
         var obj:Object = new Object();
         this.mJsonPos++;
         this.SkipVerifiedJsonWs();
         if(this.mJsonPos < this.mJsonStr.length && this.mJsonStr.charAt(this.mJsonPos) == "}")
         {
            this.mJsonPos++;
            return obj;
         }
         var len:int = this.mJsonStr.length;
         while(this.mJsonPos < len)
         {
            this.SkipVerifiedJsonWs();
            if(this.mJsonStr.charAt(this.mJsonPos) != "\"")
            {
               break;
            }
            var key:String = this.ReadVerifiedJsonString();
            this.SkipVerifiedJsonWs();
            if(this.mJsonPos < len && this.mJsonStr.charAt(this.mJsonPos) == ":")
            {
               this.mJsonPos++;
            }
            obj[key] = this.ReadVerifiedJsonValue();
            this.SkipVerifiedJsonWs();
            var sep:String = this.mJsonPos < len ? this.mJsonStr.charAt(this.mJsonPos) : "}";
            if(sep == ",")
            {
               this.mJsonPos++;
            }
            else
            {
               if(sep == "}")
               {
                  this.mJsonPos++;
               }
               break;
            }
         }
         return obj;
      }

      protected function ReadVerifiedJsonArray() : Array
      {
         var arr:Array = new Array();
         this.mJsonPos++;
         this.SkipVerifiedJsonWs();
         if(this.mJsonPos < this.mJsonStr.length && this.mJsonStr.charAt(this.mJsonPos) == "]")
         {
            this.mJsonPos++;
            return arr;
         }
         var len:int = this.mJsonStr.length;
         while(this.mJsonPos < len)
         {
            arr.push(this.ReadVerifiedJsonValue());
            this.SkipVerifiedJsonWs();
            var sep:String = this.mJsonPos < len ? this.mJsonStr.charAt(this.mJsonPos) : "]";
            if(sep == ",")
            {
               this.mJsonPos++;
            }
            else
            {
               if(sep == "]")
               {
                  this.mJsonPos++;
               }
               break;
            }
         }
         return arr;
      }

      protected function ReadVerifiedJsonString() : String
      {
         this.mJsonPos++;
         var out:String = "";
         var len:int = this.mJsonStr.length;
         while(this.mJsonPos < len)
         {
            var ch:String = this.mJsonStr.charAt(this.mJsonPos++);
            if(ch == "\"")
            {
               break;
            }
            if(ch == "\\")
            {
               if(this.mJsonPos >= len)
               {
                  break;
               }
               var esc:String = this.mJsonStr.charAt(this.mJsonPos++);
               if(esc == "\"" || esc == "\\" || esc == "/")
               {
                  out += esc;
               }
               else if(esc == "n")
               {
                  out += "\n";
               }
               else if(esc == "r")
               {
                  out += "\r";
               }
               else if(esc == "t")
               {
                  out += "\t";
               }
               else if(esc == "u" && this.mJsonPos + 4 <= len)
               {
                  var hex:String = this.mJsonStr.substr(this.mJsonPos,4);
                  this.mJsonPos += 4;
                  out += String.fromCharCode(parseInt(hex,16));
               }
               else
               {
                  out += esc;
               }
            }
            else
            {
               out += ch;
            }
         }
         return out;
      }

      protected function ReadVerifiedJsonNumber() : Number
      {
         var start:int = this.mJsonPos;
         var len:int = this.mJsonStr.length;
         while(this.mJsonPos < len)
         {
            var ch:String = this.mJsonStr.charAt(this.mJsonPos);
            if((ch >= "0" && ch <= "9") || ch == "-" || ch == "+" || ch == "." || ch == "e" || ch == "E")
            {
               this.mJsonPos++;
            }
            else
            {
               break;
            }
         }
         var numStr:String = this.mJsonStr.substring(start,this.mJsonPos);
         return Number(numStr);
      }

      protected function HandleSetModalVisible(param1:Object) : void
      {
         var _loc2_:int = CommunicationManager.CallUIService("NumberOfModals") as int;
         var _loc3_:Boolean = CommunicationManager.CallUIService("IsWidgetTopModal","SocialMedia") as Boolean;
         var _loc4_:Boolean = _loc2_ == 0 || _loc3_ && _loc2_ == 1;
         if(_loc4_ != visible)
         {
            visible = _loc4_;
            CommunicationManager.CallUIService("SetWidgetModality",{
               "widgetName":"SocialMedia",
               "bOn":_loc4_
            });
         }
      }
      
      public function Initialize() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.mTabPanelMap;
         for each(_loc2_ in _loc1_)
         {
            (_loc2_.panel as SocialMediaTabPanelBase).Initialize();
         }
      }
      
      public function OnMainShow(param1:Object = null) : void
      {
         var _loc4_:EnterParams = null;
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         CommunicationManager.AddMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         this.mSocialMediaDialogData = new SocialMediaDialog(param1);
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         this.mbIsClosing = false;
         this.mInShow = true;
         this.ParseVerifiedState();
         var _loc2_:IconComponent = this.mcSimPortrait.mcSimIcon as IconComponent;
         ImageUtils.LoadSimThumbnail(_loc2_,this.mSocialMediaDialogData.sim_id,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         TextUtils.ResizeTextToFit(this.mcSimName.txtSimName,Keys.GENERIC_SIM_NAME_WITH_PREFIX.toString({"simId":this.mSocialMediaDialogData.sim_id}));
         this.mcFollowers.txtFollowers.htmlText = KeysGP.SOCIAL_MEDIA_FOLLOWERS.toString(this.mSocialMediaDialogData.followers_count);
         this.btnNewEventPost.enabled = this.mSocialMediaDialogData.can_make_context_post;
         if(!this.btnNewEventPost.enabled)
         {
            this.btnNewEventPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_POST_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewEventPost.TooltipExt.Clear();
         }
         this.SetPanel(PANEL_MODE_FRIENDS);
         var _loc3_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc3_ == null)
         {
            this.mInShow = false;
            return;
         }
         _loc3_.removeEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout);
         _loc3_.addEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout,false,0,true);
         this.btnNewPost.enabled = _loc3_.FriendsCount > 0;
         if(!this.btnNewPost.enabled)
         {
            this.btnNewPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewPost.TooltipExt.Clear();
         }
         this.RefreshLayout();
         if(this.mNativeFeedItems.length > 0 && _loc3_.FriendsCount > 0)
         {
            this.SetPanel(PANEL_MODE_FEED);
         }
         this.UpdateBadges();
         this.RefreshVerifiedHeader();
         this.RefreshVerifiedTab();
         if(SystemUtils.UsingController)
         {
            if(this.btnFeedTabButton.visible)
            {
               _loc4_ = new EnterParams(NavDirection.FORWARD,null,{"skipConfirm":true});
               this.EnterTabbingAdapter(_loc4_);
            }
         }
         this.mInShow = false;
      }
      
      public function OnMainHide(param1:Object = null) : void
      {
         this.mbIsClosing = true;
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this);
         this.TeardownPanels();
      }
      
      public function UpdateData(param1:SocialMediaDialog) : void
      {
         if(this.mbIsClosing)
         {
            return;
         }
         this.mSocialMediaDialogData = param1 as SocialMediaDialog;
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         this.ParseVerifiedState();
         if(this.mcFeedPanel)
         {
            this.UpdateFriendsIds();
            this.mcFeedPanel.OnShow(this.mNativeFeedItems);
         }
         if(this.mcMessagesPanel)
         {
            this.mcMessagesPanel.OnShow(this.mSocialMediaDialogData.messages_items);
         }
         this.btnNewEventPost.enabled = this.mSocialMediaDialogData.can_make_context_post;
         if(!this.btnNewEventPost.enabled)
         {
            this.btnNewEventPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_NEW_POST_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewEventPost.TooltipExt.Clear();
         }
         this.RefreshLayout();
         this.RefreshVerifiedHeader();
         this.RefreshVerifiedTab();
      }
      
      protected function UpdateBadges() : void
      {
         if(this.mSocialMediaDialogData == null)
         {
            return;
         }
         this.mcPostsBadge.visible = Boolean(this.mSocialMediaDialogData.has_new_posts) && Boolean(this.btnFeedTabButton.visible);
         this.mcMessagesBadge.visible = Boolean(this.mSocialMediaDialogData.has_new_messages) && Boolean(this.btnMessagesTabButton.visible);
      }
      
      protected function RefreshLayout(param1:Event = null) : void
      {
         var _loc3_:EnterParams = null;
         if(this.mbIsClosing || this.mSocialMediaDialogData == null)
         {
            return;
         }
         var _loc2_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc2_ == null)
         {
            return;
         }
         if(this.mNativeFeedItems.length < 1 && _loc2_.FriendsCount < 1)
         {
            this.btnFeedTabButton.visible = false;
            this.btnFriendsTabButton.visible = false;
            this.btnMessagesTabButton.visible = false;
            this.btnVerifiedTabButton.visible = true;
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabLeft,true);
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabRight,true);
         }
         else
         {
            if(Boolean(SystemUtils.UsingController) && !this.btnFeedTabButton.visible && this.mCurrentPanel != null)
            {
               NavManager.Instance.FocusForward(this.mCurrentPanel.GetTargetInputAdapter());
               _loc3_ = new EnterParams(NavDirection.FORWARD);
               this.EnterTabbingAdapter(_loc3_);
            }
            this.btnFeedTabButton.visible = true;
            this.btnFriendsTabButton.visible = true;
            this.btnMessagesTabButton.visible = true;
            this.btnVerifiedTabButton.visible = true;
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabLeft,true);
            InputModeVisibilityExtension.SetVisible(this.mcControllerTabRight,true);
         }
         if(!this.mbInPanelTabSelected && this.mCurrentPanel != this.mcVerifiedPanel && this.mNativeFeedItems.length < 1 && _loc2_.FriendsCount > 0)
         {
            this.SetPanel(PANEL_MODE_FEED);
         }
         this.UpdateFriendsIds();
         this.btnNewPost.enabled = _loc2_.FriendsCount > 0;
         if(!this.btnNewPost.enabled)
         {
            this.btnNewPost.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_TAG_SIM_BUTTON_DISABLED_TOOLTIP);
         }
         else
         {
            this.btnNewPost.TooltipExt.Clear();
         }
         this.UpdateBadges();
      }
      
      protected function UpdateFriendsIds() : void
      {
         var _loc2_:SocialMediaFeedItem = null;
         if(this.mbIsClosing || this.mSocialMediaDialogData == null)
         {
            return;
         }
         var _loc1_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc1_ == null)
         {
            return;
         }
         for each(_loc2_ in this.mNativeFeedItems)
         {
            _loc2_.friendsIds = _loc1_.FriendsList;
         }
      }
      
      protected function TeardownPanels() : void
      {
         this.CloseReactionPopUps();
         var _loc1_:SocialMediaFriendsTabPanel = this.mcFriendsPanel as SocialMediaFriendsTabPanel;
         if(_loc1_)
         {
            _loc1_.removeEventListener(SocialMediaFriendsTabPanel.FRIENDS_UPDATED,this.RefreshLayout);
            _loc1_.Dispose();
         }
         if(Boolean(this.mcFeedPanel) && this.mcFeedPanel.parent == this)
         {
            this.removeChild(this.mcFeedPanel);
         }
         this.mcFeedPanel = null;
         if(Boolean(this.mcFriendsPanel) && this.mcFriendsPanel.parent == this)
         {
            this.removeChild(this.mcFriendsPanel);
         }
         this.mcFriendsPanel = null;
         if(Boolean(this.mcMessagesPanel) && this.mcMessagesPanel.parent == this)
         {
            this.removeChild(this.mcMessagesPanel);
         }
         this.mcMessagesPanel = null;
         if(this.mVerifiedCanvas != null)
         {
            this.mVerifiedCanvas.mask = null;
         }
         if(this.mcVerifiedPanel != null)
         {
            this.mcVerifiedPanel.removeEventListener(MouseEvent.MOUSE_WHEEL,this.OnVerifiedMouseWheel);
            this.mcVerifiedPanel.removeEventListener(Event.ENTER_FRAME,this.OnVerifiedEnterFrame);
            if(this.mcVerifiedPanel.mcList != null && this.mcVerifiedPanel.mcList.mSlider != null)
            {
               this.mcVerifiedPanel.mcList.mSlider.removeEventListener(SmoothSliderEvent.SNAP,this.OnVerifiedSliderChanged);
               this.mcVerifiedPanel.mcList.mSlider.removeEventListener(SmoothSliderEvent.SLIDE,this.OnVerifiedSliderChanged);
               this.mcVerifiedPanel.mcList.mSlider.removeEventListener(SmoothSliderEvent.DRAG_CONTINUE,this.OnVerifiedSliderChanged);
            }
            if(this.mcVerifiedPanel.parent == this)
            {
               this.removeChild(this.mcVerifiedPanel);
            }
         }
         this.mcVerifiedPanel = null;
         this.mVerifiedCanvas = null;
         this.mVerifiedMask = null;
         this.mVerifiedScrollbar = null;
         this.mVerifiedOverlay = null;
         this.mVerifiedContentH = 0;
         this.mVerifiedScrollY = 0;
         this.mbVerifiedConfirming = false;
         this.mbVerifiedListDetached = false;
         this.mbVerifiedRefreshPending = false;
         this.mVerifiedState = null;
         this.mNativeFeedItems = new Array();
         if(this.mcVerifiedBadge != null)
         {
            this.mcVerifiedBadge.visible = false;
         }
         this.mbInPanelTabSelected = false;
         this.mInShow = false;
         this.mCurrentPanel = null;
         this.mPanelTabGroup.ClearSelection();
         this.mTabPanelMap = new Object();
      }
      
      protected function SeenNewPosts() : void
      {
         if(!this.mSocialMediaDialogData.has_new_posts)
         {
            return;
         }
         CommunicationManager.PostServerCommand("social_media.social_media_mark_posts_seen",this.mSocialMediaDialogData.sim_id);
         this.mSocialMediaDialogData.has_new_posts = false;
         this.UpdateBadges();
      }
      
      protected function SeenNewMessages() : void
      {
         if(!this.mSocialMediaDialogData.has_new_messages)
         {
            return;
         }
         CommunicationManager.PostServerCommand("social_media.social_media_mark_messages_seen",this.mSocialMediaDialogData.sim_id);
         this.mSocialMediaDialogData.has_new_messages = false;
         this.UpdateBadges();
      }
      
      protected function OnCloseClick(param1:PushButtonEvent) : void
      {
         this.Close();
      }
      
      protected function Close() : void
      {
         if(this.mbIsClosing)
         {
            return;
         }
         this.mbIsClosing = true;
         var _loc1_:SocialMediaTabPanelBase = this.mCurrentPanel;
         this.TeardownPanels();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mTabbingAdapter.Exit();
         }
         if(Boolean(SystemUtils.UsingController) && (NavManager.Instance.CurrentFocusable == this.mTabbingAdapter || NavManager.Instance.CurrentFocusable == this.mMainAdapter || _loc1_ != null && _loc1_.IsFocused()))
         {
            NavManager.Instance.FocusBack();
         }
         dispatchEvent(new GenericEvent(GenericEvent.CLOSE));
      }
      
      protected function OnPanelTabSelected(param1:SelectableGroupEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:SocialMediaTabPanelBase = null;
         if(this.mbIsClosing)
         {
            return;
         }
         this.mbInPanelTabSelected = true;
         var _loc2_:Button = param1.deselectedComponent as Button;
         if(_loc2_)
         {
            _loc5_ = this.mTabPanelMap[_loc2_.name];
            if(_loc5_)
            {
               _loc6_ = _loc5_["panel"] as SocialMediaTabPanelBase;
               _loc6_.visible = false;
               _loc6_.OnTabHide();
            }
            if(_loc2_ == this.btnFeedTabButton)
            {
               this.SeenNewPosts();
            }
            if(_loc2_ == this.btnMessagesTabButton)
            {
               this.SeenNewMessages();
            }
            if(_loc2_ == this.btnVerifiedTabButton)
            {
               this.HideVerifiedConfirm();
            }
         }
         var _loc3_:Button = param1.selectedComponent as Button;
         var _loc4_:Object = this.FindOrCreateTabPanel(_loc3_.name);
         this.mCurrentPanel = _loc4_["panel"] as SocialMediaTabPanelBase;
         this.mCurrentPanel.visible = true;
         if(this.btnFriendsTabButton.name == _loc3_.name)
         {
            (this.mCurrentPanel as SocialMediaFriendsTabPanel).OwnerSimId = this.mSocialMediaDialogData.sim_id;
         }
         var _loc7_:Array = this.btnMessagesTabButton.name == _loc3_.name ? this.mSocialMediaDialogData.messages_items : this.mNativeFeedItems;
         if(this.mCurrentPanel == this.mcVerifiedPanel)
         {
            _loc7_ = new Array();
         }
         this.mCurrentPanel.OnTabShow(_loc7_);
         this.RefreshVerifiedTab();
         if(Boolean(SystemUtils.UsingConsoleInputMode) && !this.mInShow && this.mCurrentPanel != this.mcVerifiedPanel)
         {
            NavManager.Instance.FocusPan(this.mCurrentPanel.GetTargetInputAdapter());
         }
         this.mbInPanelTabSelected = false;
      }
      
      protected function FindOrCreateTabPanel(param1:String) : Object
      {
         var _loc3_:SocialMediaTabPanelBase = null;
         var _loc2_:Object = this.mTabPanelMap[param1];
         if(!_loc2_)
         {
            _loc2_ = this.CreateTabPanel(this.GetModeFromButtonName(param1));
            if(_loc2_)
            {
               _loc3_ = _loc2_.panel as SocialMediaTabPanelBase;
               _loc3_.y = this.mcBackground.height;
               _loc3_.Initialize();
               _loc3_.ResizePanel(this.mcBackground.width,PANEL_HEIGHT);
               if(_loc3_ == this.mcVerifiedPanel)
               {
                  this.ResizeVerifiedChrome();
               }
               if(_loc3_ != this.mcVerifiedPanel)
               {
                  _loc3_.OnShow(this.btnMessagesTabButton.name == param1 ? this.mSocialMediaDialogData.messages_items : this.mNativeFeedItems);
               }
               if(SystemUtils.UsingConsoleInputMode)
               {
                  _loc3_.OnInputEventCall(InputAdapterEvent.LEAVE,this.HandlePanelLeave);
                  _loc3_.OnInputEventCall(InputAdapterEvent.BACK,this.Close);
               }
            }
         }
         return _loc2_;
      }
      
      protected function CreateTabPanel(param1:int) : Object
      {
         var _loc2_:int = this.getChildIndex(this.mcBackground) + 1;
         switch(param1)
         {
            case PANEL_MODE_FEED:
               this.mcFeedPanel = new SocialMediaFeedTabPanel();
               this.addChildAt(this.mcFeedPanel,_loc2_);
               this.mTabPanelMap[this.btnFeedTabButton.name] = {
                  "panel":this.mcFeedPanel,
                  "mode":PANEL_MODE_FEED
               };
               return this.mTabPanelMap[this.btnFeedTabButton.name];
            case PANEL_MODE_FRIENDS:
               this.mcFriendsPanel = new SocialMediaFriendsTabPanel(this.mSocialMediaDialogData.sim_id);
               (this.mcFriendsPanel as SocialMediaFriendsTabPanel).mbCanAddNewContacts = this.mSocialMediaDialogData.can_add_contacts;
               this.addChildAt(this.mcFriendsPanel,_loc2_);
               this.mTabPanelMap[this.btnFriendsTabButton.name] = {
                  "panel":this.mcFriendsPanel,
                  "mode":PANEL_MODE_FRIENDS
               };
               return this.mTabPanelMap[this.btnFriendsTabButton.name];
            case PANEL_MODE_MESSAGES:
               this.mcMessagesPanel = new SocialMediaMessagesTabPanel();
               this.addChildAt(this.mcMessagesPanel,_loc2_);
               this.mTabPanelMap[this.btnMessagesTabButton.name] = {
                  "panel":this.mcMessagesPanel,
                  "mode":PANEL_MODE_MESSAGES
               };
               return this.mTabPanelMap[this.btnMessagesTabButton.name];
            case PANEL_MODE_VERIFIED:
               this.mcVerifiedPanel = new SocialMediaFeedTabPanel();
               this.addChildAt(this.mcVerifiedPanel,_loc2_);
               this.mTabPanelMap[this.btnVerifiedTabButton.name] = {
                  "panel":this.mcVerifiedPanel,
                  "mode":PANEL_MODE_VERIFIED
               };
               this.InitVerifiedChrome();
               return this.mTabPanelMap[this.btnVerifiedTabButton.name];
            default:
               return null;
         }
      }
      
      protected function GetModeFromButtonName(param1:String) : int
      {
         switch(param1)
         {
            case this.btnFeedTabButton.name:
               return PANEL_MODE_FEED;
            case this.btnFriendsTabButton.name:
               return PANEL_MODE_FRIENDS;
            case this.btnMessagesTabButton.name:
               return PANEL_MODE_MESSAGES;
            case this.btnVerifiedTabButton.name:
               return PANEL_MODE_VERIFIED;
            default:
               return -1;
         }
      }
      
      protected function SetPanel(param1:int) : void
      {
         var _loc2_:Button = null;
         switch(param1)
         {
            case PANEL_MODE_FRIENDS:
               _loc2_ = this.btnFriendsTabButton;
               break;
            case PANEL_MODE_MESSAGES:
               _loc2_ = this.btnMessagesTabButton;
               break;
            case PANEL_MODE_VERIFIED:
               _loc2_ = this.btnVerifiedTabButton;
               break;
            case PANEL_MODE_FEED:
            default:
               _loc2_ = this.btnFeedTabButton;
         }
         _loc2_.dispatchEvent(new PushButtonEvent(PushButtonEvent.CLICK));
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mTabbingAdapter.SetHighlightedObject(_loc2_);
         }
      }
      
      protected function OnNewPostClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_post_picker_interaction,this.mSocialMediaDialogData.sim_id,this.mSocialMediaDialogData.sim_id);
      }
      
      protected function OnNewEventPostClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push",_loc2_.new_event_post_picker_interaction,this.mSocialMediaDialogData.sim_id,this.mSocialMediaDialogData.sim_id);
      }
      
      protected function InitGamepad() : void
      {
         if(!SystemUtils.UsingConsoleInputMode)
         {
            return;
         }
         this.mMainAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnNewEventPost,this.btnNewPost],true);
         this.mMainAdapter.OnBackCall(this.Close);
         this.mMainAdapter.SetHighlightClosestOnEnter(true);
         this.mMainAdapter.OnLeaveCall(this.HandleMainLeave);
         this.mTabbingAdapter = new BidirectionalGroupAdapter(new <DisplayObject>[this.btnFeedTabButton,this.btnFriendsTabButton,this.btnMessagesTabButton,this.btnVerifiedTabButton]);
         this.mTabbingAdapter.SetTabbingSelectionMode(true);
      }
      
      protected function HandleMainLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.DOWN && this.mCurrentPanel != null)
         {
            NavManager.Instance.FocusPan(this.mCurrentPanel.GetTargetInputAdapter(),param1.CreateEnterParams());
         }
      }
      
      protected function HandlePanelLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(param1.GetDirection() == NavDirection.UP)
         {
            NavManager.Instance.FocusPan(this.mMainAdapter,param1.CreateEnterParams());
         }
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         if(this.mCurrentPanel == null)
         {
            return this;
         }
         return this.mCurrentPanel.Enter(param1);
      }
      
      public function Exit() : void
      {
         if(this.mMainAdapter != null)
         {
            this.mMainAdapter.Exit();
         }
         if(this.mCurrentPanel != null)
         {
            this.mCurrentPanel.Exit();
         }
      }
      
      protected function EnterTabbingAdapter(param1:EnterParams = null) : void
      {
         this.mTabbingAdapter.Enter(param1);
         var _loc2_:InputAction = this.mTabbingAdapter.GetFirstInputAction(ActionCodes.TAB_LEFT);
         _loc2_.SetValidCheck(this.TabbingValidCheck);
         var _loc3_:InputAction = this.mTabbingAdapter.GetFirstInputAction(ActionCodes.TAB_RIGHT);
         _loc3_.SetValidCheck(this.TabbingValidCheck);
      }
      
      protected function TabbingValidCheck() : Boolean
      {
         if(this.mCurrentPanel == null || NavManager.Instance.CurrentFocusable != this.mCurrentPanel.GetTargetInputAdapter())
         {
            return false;
         }
         if(Boolean(this.btnFeedTabButton) && Boolean(this.btnFeedTabButton.visible))
         {
            return true;
         }
         if(Boolean(this.btnFriendsTabButton) && Boolean(this.btnFriendsTabButton.visible))
         {
            return true;
         }
         if(Boolean(this.btnMessagesTabButton) && Boolean(this.btnMessagesTabButton.visible))
         {
            return true;
         }
         if(Boolean(this.btnVerifiedTabButton) && Boolean(this.btnVerifiedTabButton.visible))
         {
            return true;
         }
         return false;
      }
      
      public function CloseReactionPopUps() : void
      {
         if(this.mcFeedPanel is SocialMediaFeedTabPanel)
         {
            SocialMediaFeedTabPanel(this.mcFeedPanel).CloseReactionPopUps();
         }
         if(this.mcMessagesPanel is SocialMediaMessagesTabPanel)
         {
            SocialMediaMessagesTabPanel(this.mcMessagesPanel).CloseReactionPopUps();
         }
      }
   }
}
