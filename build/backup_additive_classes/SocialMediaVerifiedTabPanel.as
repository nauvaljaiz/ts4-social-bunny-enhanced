package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gui.buttons.TextButton;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.InputAdapterEvent;

   /**
    * Additive Verified tab content. The visual backdrop is an unmodified native
    * SocialMediaFeedTabPanel; all Verified-specific controls are drawn above it.
    * The original Feed / Friends / Message panels are never replaced.
    */
   public class SocialMediaVerifiedTabPanel extends SocialMediaTabPanelBase
   {
      private var mBackdrop:SocialMediaFeedTabPanel;
      private var mViewport:Sprite;
      private var mMask:Sprite;
      private var mCanvas:Sprite;
      private var mScrollbar:Sprite;
      private var mOverlay:Sprite;
      private var mSimId:String = "";
      private var mState:Object = null;
      private var mScrollY:Number = 0;
      private var mContentH:Number = 0;
      private var mWidth:Number = 543;
      private var mHeight:Number = 316;
      private var mbConfirming:Boolean = false;
      private var mbRefreshPending:Boolean = false;

      public function SocialMediaVerifiedTabPanel()
      {
         super();
         this.mouseEnabled = true;

         // Exact native content-panel background, reused without the native list.
         this.mBackdrop = new SocialMediaFeedTabPanel();
         this.mBackdrop.mouseEnabled = false;
         this.mBackdrop.mouseChildren = false;
         this.mBackdrop.mcList.visible = false;
         this.mBackdrop.txtEmptyStateTitle.visible = false;
         this.mBackdrop.txtEmptyStateDescription.visible = false;
         this.mBackdrop.mcFeedPanelFTUE.visible = false;
         this.addChild(this.mBackdrop);

         this.mViewport = new Sprite();
         this.mViewport.mouseEnabled = true;
         this.addChild(this.mViewport);

         this.mMask = new Sprite();
         this.mMask.mouseEnabled = false;
         this.mMask.graphics.beginFill(0xFFFFFF,1.0);
         this.mMask.graphics.drawRect(0,0,this.mWidth,this.mHeight);
         this.mMask.graphics.endFill();
         this.mViewport.addChild(this.mMask);

         this.mCanvas = new Sprite();
         this.mCanvas.mask = this.mMask;
         this.mViewport.addChild(this.mCanvas);

         this.mScrollbar = new Sprite();
         this.mScrollbar.mouseEnabled = false;
         this.addChild(this.mScrollbar);

         this.mOverlay = new Sprite();
         this.mOverlay.visible = false;
         this.addChild(this.mOverlay);

         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnMouseWheel,false,0,true);
      }

      // --- Native tab panel contract ---

      override public function Initialize() : void
      {
         // The Verified panel does not use the native ScrollList.
      }

      override public function OnShow(param1:Array) : void
      {
         // State is supplied by SocialMediaPanel.SetVerifiedState().
      }

      override public function OnTabShow(param1:Array) : void
      {
         this.Render();
      }

      override public function OnTabHide() : void
      {
         this.HideConfirm();
      }

      override public function ResizePanel(param1:Number, param2:Number) : void
      {
         this.mWidth = param1;
         this.mHeight = param2;
         this.mBackdrop.mcBackground.width = param1;
         this.mBackdrop.mcBackground.height = param2;
         this.mBackdrop.mcList.visible = false;
         this.mMask.graphics.clear();
         this.mMask.graphics.beginFill(0xFFFFFF,1.0);
         this.mMask.graphics.drawRect(0,0,param1,param2);
         this.mMask.graphics.endFill();
         this.Render();
      }

      override public function GetTargetInputAdapter() : IInputAdapter
      {
         return this;
      }

      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return this;
      }

      override public function Exit() : void
      {
      }

      override public function IsFocused() : Boolean
      {
         return false;
      }

      override public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         if(param1 == InputAdapterEvent.LEAVE)
         {
            this.mLeaveCallback = param2;
         }
         return this;
      }

      // --- State / refresh ---

      public function SetVerifiedState(state:Object, simId:String) : void
      {
         var changedSim:Boolean = (this.mSimId != simId);
         this.mSimId = simId != null ? simId : "";
         this.mState = state;
         this.mbRefreshPending = state != null;
         if(changedSim || state == null)
         {
            this.mScrollY = 0;
         }
         this.HideConfirm();
         this.Render();
      }

      public function RequestRefresh() : void
      {
         if(this.mbRefreshPending || this.mSimId == "")
         {
            return;
         }
         this.mbRefreshPending = true;
         SocialMediaVerifiedUI.SendAction(this.mSimId,"refresh");
      }

      public function RefreshWithState() : void
      {
         this.Render();
      }

      // --- Scrolling ---

      private function OnMouseWheel(event:MouseEvent) : void
      {
         if(this.mbConfirming)
         {
            return;
         }
         var maxScroll:Number = Math.max(0,this.mContentH - this.mHeight);
         this.mScrollY = Math.max(0,Math.min(maxScroll,this.mScrollY - event.delta * 28));
         this.mCanvas.y = -this.mScrollY;
         this.DrawScrollbar();
      }

      private function DrawScrollbar() : void
      {
         this.mScrollbar.graphics.clear();
         if(this.mContentH <= this.mHeight)
         {
            return;
         }
         var trackY:Number = 8;
         var trackH:Number = this.mHeight - 16;
         var trackX:Number = this.mWidth - 8;
         this.mScrollbar.graphics.beginFill(0x000000,0.12);
         this.mScrollbar.graphics.drawRoundRect(trackX,trackY,5,trackH,3,3);
         this.mScrollbar.graphics.endFill();
         var maxScroll:Number = Math.max(1,this.mContentH - this.mHeight);
         var thumbH:Number = Math.max(24,(this.mHeight / this.mContentH) * trackH);
         var thumbY:Number = trackY + (this.mScrollY / maxScroll) * (trackH - thumbH);
         this.mScrollbar.graphics.beginFill(SocialMediaVerifiedUI.COL_HERO,0.55);
         this.mScrollbar.graphics.drawRoundRect(trackX,thumbY,5,thumbH,3,3);
         this.mScrollbar.graphics.endFill();
      }

      // --- Rendering ---

      private function Render() : void
      {
         while(this.mCanvas.numChildren > 0)
         {
            this.mCanvas.removeChildAt(0);
         }
         this.mContentH = this.mHeight;
         this.mScrollY = 0;
         this.mCanvas.y = 0;
         this.mScrollbar.graphics.clear();

         if(this.mState == null)
         {
            this.DrawLoading();
            return;
         }

         var plan:Object = this.mState.plan != null ? this.mState.plan : new Object();
         var sub:Object = this.mState.subscription != null ? this.mState.subscription : new Object();
         var eligibility:Object = this.mState.eligibility != null ? this.mState.eligibility : new Object();
         var perms:Object = this.mState.permissions != null ? this.mState.permissions : new Object();
         var status:String = String(sub.status != null ? sub.status : "not_subscribed");
         var statusLabel:String = String(sub.status_label != null ? sub.status_label : "Not Subscribed");
         var statusDetail:String = String(sub.status_detail != null ? sub.status_detail : "");

         var y:Number = 12;

         // ---- Hero -----------------------------------------------------
         this.AddCard(20,y,503,122,SocialMediaVerifiedUI.COL_HERO,0,12);
         this.AddLabel("Social Bunny Verified",18,0xFFFFFF,true,36,y + 14,330,26);
         var tagline:String = String(plan.tagline != null ? plan.tagline : "Get recognized with an official verification badge and unlock exclusive account benefits.");
         this.AddLabel(tagline,10,0xEBDDF1,false,36,y + 42,330,40,true);
         var badge:Sprite = SocialMediaVerifiedUI.CreateBadge(50);
         badge.x = 440;
         badge.y = y + 16;
         this.mCanvas.addChild(badge);
         var priceLabel:String = String(plan.price_label != null ? plan.price_label : SocialMediaVerifiedUI.FormatMoney(Number(plan.price != null ? plan.price : 250)));
         var intervalLabel:String = String(plan.billing_interval_label != null ? plan.billing_interval_label : "per Sim week");
         this.AddLabel(priceLabel + " " + intervalLabel,13,0xFFFFFF,true,36,y + 88,300,22);
         this.DrawStatusPill(statusLabel,352,y + 86,150,24,SocialMediaVerifiedUI.StatusColor(status));

         y += 134;

         // ---- Optional result banner ----------------------------------
         var result:Object = this.mState.last_result;
         if(result != null && result.message != null && String(result.message) != "")
         {
            var ok:Boolean = result.ok != false;
            var bannerColor:uint = ok ? 0xE7F5EA : 0xFBE9E9;
            var bannerBorder:uint = ok ? 0x9ED3A8 : 0xE6B4B4;
            var textColor:uint = ok ? SocialMediaVerifiedUI.COL_SUCCESS : SocialMediaVerifiedUI.COL_DANGER;
            this.AddCard(20,y,503,42,bannerColor,bannerBorder,8);
            this.AddLabel(String(result.message),10,textColor,false,34,y + 10,475,22,true);
            y += 50;
         }

         // ---- Status card ---------------------------------------------
         this.AddCard(20,y,503,86,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Subscription status",10,SocialMediaVerifiedUI.COL_MUTED,true,36,y + 10,200,16);
         this.AddLabel(statusLabel,16,SocialMediaVerifiedUI.StatusColor(status),true,36,y + 26,250,22);
         if(statusDetail == "")
         {
            statusDetail = eligibility.reason != null ? String(eligibility.reason) : "";
         }
         this.AddLabel(statusDetail,10,SocialMediaVerifiedUI.COL_TEXT,false,36,y + 50,290,30,true);

         var rightX:Number = 342;
         this.AddLabel("Next billing",10,SocialMediaVerifiedUI.COL_MUTED,true,rightX,y + 10,160,16);
         var nextBilling:String = String(sub.next_billing_label != null ? sub.next_billing_label : "\u2014");
         this.AddLabel(nextBilling,11,SocialMediaVerifiedUI.COL_TEXT,true,rightX,y + 26,160,20);
         var renewLabel:String = String(sub.auto_renew_label != null ? sub.auto_renew_label : (sub.auto_renew ? "Auto-renew: On" : "Auto-renew: Off"));
         this.AddLabel(renewLabel,10,SocialMediaVerifiedUI.COL_MUTED,false,rightX,y + 50,160,18);

         y += 98;

         // ---- Benefits -------------------------------------------------
         var benefits:Array = this.mState.benefits != null ? this.mState.benefits : (plan.benefits != null ? plan.benefits : new Array());
         var rows:int = Math.ceil(benefits.length / 2);
         var benefitsH:Number = 34 + rows * 40;
         this.AddCard(20,y,503,benefitsH,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Your Verified benefits",13,SocialMediaVerifiedUI.COL_TEXT,true,36,y + 10,300,20);
         var bi:int = 0;
         while(bi < benefits.length)
         {
            var benefit:Object = benefits[bi];
            var col:int = bi % 2;
            var row:int = int(bi / 2);
            var bx:Number = 36 + col * 238;
            var by:Number = y + 32 + row * 40;
            var check:Sprite = SocialMediaVerifiedUI.CreateBadge(14);
            check.x = bx;
            check.y = by + 2;
            this.mCanvas.addChild(check);
            this.AddLabel(String(benefit.title != null ? benefit.title : "Verified benefit"),10,SocialMediaVerifiedUI.COL_TEXT,true,bx + 22,by - 2,210,16);
            this.AddLabel(String(benefit.description != null ? benefit.description : ""),9,SocialMediaVerifiedUI.COL_MUTED,false,bx + 22,by + 14,210,22,true);
            bi++;
         }
         y += benefitsH + 12;

         // ---- Actions --------------------------------------------------
         var actions:Array = new Array();
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

         var actionRows:Array = this.SplitActions(actions);
         var actionsH:Number = 22 + actionRows.length * 34;
         this.AddCard(20,y,503,actionsH,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Manage subscription",11,SocialMediaVerifiedUI.COL_TEXT,true,36,y + 8,300,18);
         var ar:int = 0;
         while(ar < actionRows.length)
         {
            this.AddButtonRow(actionRows[ar],y + 28 + ar * 34);
            ar++;
         }
         y += actionsH + 12;

         // ---- Payment history -----------------------------------------
         var history:Array = sub.payment_history != null ? sub.payment_history : new Array();
         var histCount:int = Math.min(5,history.length);
         var historyH:Number = histCount > 0 ? 34 + histCount * 24 : 54;
         this.AddCard(20,y,503,historyH,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Payment history",13,SocialMediaVerifiedUI.COL_TEXT,true,36,y + 10,300,20);
         if(histCount == 0)
         {
            this.AddLabel("No payments recorded yet.",10,SocialMediaVerifiedUI.COL_MUTED,false,36,y + 30,400,18);
         }
         else
         {
            var hi:int = 0;
            while(hi < histCount)
            {
               var h:Object = history[hi];
               var hy:Number = y + 32 + hi * 24;
               this.AddLabel(String(h.date_label != null ? h.date_label : ""),9,SocialMediaVerifiedUI.COL_MUTED,false,36,hy,150,16);
               this.AddLabel(String(h.amount_label != null ? h.amount_label : ""),9,SocialMediaVerifiedUI.COL_TEXT,true,200,hy,90,16);
               this.AddLabel(String(h.status_label != null ? h.status_label : ""),9,SocialMediaVerifiedUI.StatusColor(String(h.status != null ? h.status : "")),true,300,hy,190,16);
               hi++;
            }
         }
         y += historyH + 12;

         // ---- Account activity ----------------------------------------
         var notices:Array = this.mState.notifications != null ? this.mState.notifications : new Array();
         var noticeCount:int = Math.min(4,notices.length);
         var noticeH:Number = 34 + Math.max(1,noticeCount) * 24;
         this.AddCard(20,y,503,noticeH,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Account activity",13,SocialMediaVerifiedUI.COL_TEXT,true,36,y + 10,300,20);
         if(noticeCount == 0)
         {
            this.AddLabel("Subscription notifications will appear here.",10,SocialMediaVerifiedUI.COL_MUTED,false,36,y + 30,430,18);
         }
         else
         {
            var ni:int = 0;
            while(ni < noticeCount)
            {
               var n:Object = notices[ni];
               var ny:Number = y + 32 + ni * 24;
               this.AddLabel(String(n.date_label != null ? n.date_label : ""),9,SocialMediaVerifiedUI.COL_MUTED,false,36,ny,116,16);
               this.AddLabel(SocialMediaVerifiedUI.Shorten(String(n.message != null ? n.message : ""),64),9,SocialMediaVerifiedUI.COL_TEXT,false,154,ny,340,16);
               ni++;
            }
         }
         y += noticeH + 16;

         this.mContentH = Math.max(this.mHeight,y);
         var maxScroll:Number = Math.max(0,this.mContentH - this.mHeight);
         if(this.mScrollY > maxScroll)
         {
            this.mScrollY = maxScroll;
         }
         this.mCanvas.y = -this.mScrollY;
         this.DrawScrollbar();
      }

      private function DrawLoading() : void
      {
         this.AddCard(20,12,503,122,SocialMediaVerifiedUI.COL_HERO,0,12);
         this.AddLabel("Social Bunny Verified",18,0xFFFFFF,true,36,26,330,26);
         this.AddLabel("Loading your subscription details\u2026",10,0xEBDDF1,false,36,58,330,30,true);
         var badge:Sprite = SocialMediaVerifiedUI.CreateBadge(50);
         badge.x = 440;
         badge.y = 28;
         this.mCanvas.addChild(badge);
         this.AddCard(20,146,503,86,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,10);
         this.AddLabel("Connecting to the subscription service\u2026",11,SocialMediaVerifiedUI.COL_TEXT,true,36,176,450,20);
         this.AddLabel("If this message remains, close and reopen Social Bunny.",10,SocialMediaVerifiedUI.COL_MUTED,false,36,198,450,20);
         this.RequestRefresh();
      }

      private function SplitActions(actions:Array) : Array
      {
         var rows:Array = new Array();
         var current:Array = new Array();
         var currentW:Number = 0;
         var i:int = 0;
         while(i < actions.length)
         {
            var width:Number = this.MeasureButton(actions[i]);
            if(current.length > 0 && currentW + 8 + width > 470)
            {
               rows.push(current);
               current = new Array();
               currentW = 0;
            }
            current.push(actions[i]);
            currentW += (current.length > 1 ? 8 : 0) + width;
            i++;
         }
         if(current.length > 0)
         {
            rows.push(current);
         }
         return rows;
      }

      private function MeasureButton(item:Object) : Number
      {
         var btn:PostButton_Tag = new PostButton_Tag();
         btn.htmlText = String(item.label);
         var width:Number = btn.width;
         if(width < 76)
         {
            width = 76;
         }
         if(width > 138)
         {
            width = 138;
         }
         return width;
      }

      private function AddButtonRow(items:Array, y:Number) : void
      {
         var widths:Array = new Array();
         var total:Number = 0;
         var i:int = 0;
         while(i < items.length)
         {
            var w:Number = this.MeasureButton(items[i]);
            widths.push(w);
            total += w + (i > 0 ? 8 : 0);
            i++;
         }
         var x:Number = Math.max(36,(this.mWidth - total) * 0.5);
         i = 0;
         while(i < items.length)
         {
            var item:Object = items[i];
            var btn:PostButton_Tag = new PostButton_Tag();
            btn.htmlText = String(item.label);
            btn.name = "sbv_" + String(item.action);
            btn["sbvAction"] = String(item.action);
            btn["sbvArg"] = String(item.arg != null ? item.arg : "");
            btn.width = Number(widths[i]);
            btn.x = x;
            btn.y = y;
            btn.addEventListener(PushButtonEvent.CLICK,this.OnButtonClick,false,0,true);
            this.mCanvas.addChild(btn);
            x += widths[i] + 8;
            i++;
         }
      }

      private function DrawStatusPill(label:String, x:Number, y:Number, w:Number, h:Number, color:uint) : void
      {
         var pill:Sprite = new Sprite();
         pill.graphics.beginFill(color,1.0);
         pill.graphics.drawRoundRect(0,0,w,h,h * 0.5,h * 0.5);
         pill.graphics.endFill();
         pill.x = x;
         pill.y = y;
         var tf:TextField = SocialMediaVerifiedUI.CreateLabel(label,10,0xFFFFFF,true,w - 8,h - 2,false,TextFormatAlign.CENTER);
         tf.x = 4;
         tf.y = 4;
         pill.addChild(tf);
         this.mCanvas.addChild(pill);
      }

      private function AddCard(x:Number, y:Number, w:Number, h:Number, fill:uint, border:uint, radius:Number) : void
      {
         var card:Sprite = SocialMediaVerifiedUI.CreateCard(w,h,fill,border,radius);
         card.x = x;
         card.y = y;
         this.mCanvas.addChild(card);
      }

      private function AddLabel(
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
         var tf:TextField = SocialMediaVerifiedUI.CreateLabel(text,size,color,bold,w,h,multiline,TextFormatAlign.LEFT);
         tf.x = x;
         tf.y = y;
         this.mCanvas.addChild(tf);
      }

      // --- Confirmation overlay ---------------------------------------

      private function OnButtonClick(event:PushButtonEvent) : void
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
            this.ShowConfirm();
            return;
         }
         if(action == "confirm_subscribe")
         {
            this.HideConfirm();
            SocialMediaVerifiedUI.SendAction(this.mSimId,"subscribe");
            return;
         }
         if(action == "dismiss")
         {
            this.HideConfirm();
            return;
         }
         SocialMediaVerifiedUI.SendAction(this.mSimId,action,arg);
      }

      private function ShowConfirm() : void
      {
         if(this.mState == null)
         {
            return;
         }
         var plan:Object = this.mState.plan != null ? this.mState.plan : new Object();
         var price:String = String(plan.price_label != null ? plan.price_label : SocialMediaVerifiedUI.FormatMoney(Number(plan.price != null ? plan.price : 250)));
         var interval:String = String(plan.billing_interval_label != null ? plan.billing_interval_label : "per Sim week");

         this.mOverlay.visible = true;
         this.mbConfirming = true;
         while(this.mOverlay.numChildren > 0)
         {
            this.mOverlay.removeChildAt(0);
         }

         var shade:Sprite = new Sprite();
         shade.graphics.beginFill(0x000000,0.55);
         shade.graphics.drawRect(0,0,this.mWidth,this.mHeight);
         shade.graphics.endFill();
         this.mOverlay.addChild(shade);

         var cardW:Number = 420;
         var cardH:Number = 206;
         var card:Sprite = SocialMediaVerifiedUI.CreateCard(cardW,cardH,SocialMediaVerifiedUI.COL_CARD,SocialMediaVerifiedUI.COL_BORDER,12);
         card.x = (this.mWidth - cardW) * 0.5;
         card.y = (this.mHeight - cardH) * 0.5;
         this.mOverlay.addChild(card);

         var title:TextField = SocialMediaVerifiedUI.CreateLabel("Confirm Social Bunny Verified",14,SocialMediaVerifiedUI.COL_TEXT,true,cardW - 32,22);
         title.x = 16;
         title.y = 14;
         card.addChild(title);

         var priceTf:TextField = SocialMediaVerifiedUI.CreateLabel(price + " " + interval,16,SocialMediaVerifiedUI.COL_HERO,true,cardW - 32,24);
         priceTf.x = 16;
         priceTf.y = 42;
         card.addChild(priceTf);

         var body:TextField = SocialMediaVerifiedUI.CreateLabel(
            "This will deduct " + price + " from household funds now. Your subscription renews automatically and can be cancelled from this tab at any time.",
            10,
            SocialMediaVerifiedUI.COL_TEXT,
            false,
            cardW - 32,
            54,
            true
         );
         body.x = 16;
         body.y = 74;
         card.addChild(body);

         var note:TextField = SocialMediaVerifiedUI.CreateLabel(
            "Simoleons only. No real-world payment is ever made.",
            9,
            SocialMediaVerifiedUI.COL_MUTED,
            false,
            cardW - 32,
            18
         );
         note.x = 16;
         note.y = 134;
         card.addChild(note);

         var confirm:PostButton_Tag = new PostButton_Tag();
         confirm.htmlText = "Confirm";
         confirm.name = "sbv_confirm";
         confirm["sbvAction"] = "confirm_subscribe";
         confirm["sbvArg"] = "";
         confirm.x = 118;
         confirm.y = 158;
         confirm.addEventListener(PushButtonEvent.CLICK,this.OnButtonClick,false,0,true);
         card.addChild(confirm);

         var back:PostButton_Tag = new PostButton_Tag();
         back.htmlText = "Back";
         back.name = "sbv_dismiss";
         back["sbvAction"] = "dismiss";
         back["sbvArg"] = "";
         back.x = 232;
         back.y = 158;
         back.addEventListener(PushButtonEvent.CLICK,this.OnButtonClick,false,0,true);
         card.addChild(back);
      }

      private function HideConfirm() : void
      {
         this.mbConfirming = false;
         if(this.mOverlay == null)
         {
            return;
         }
         this.mOverlay.visible = false;
         while(this.mOverlay.numChildren > 0)
         {
            this.mOverlay.removeChildAt(0);
         }
      }
   }
}
