package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.constants.Alignment;
   import olympus.controls.IconComponent;
   import olympus.controls.ImageResource;
   import olympus.core.tooltip.Tooltip;
   import olympus.core.tooltip.TooltipObject;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.gui.buttons.Button;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.objects.RelationshipInfo;
   import olympus.utils.ImageUtils;
   import olympus.utils.SystemUtils;
   import widgets.Gameplay.constants.SocialMediaTunables;
   import widgets.Gameplay.controls.RelationshipComponents.RelationshipTracksDisplay;
   import widgets.shared.controls.Console.LegendIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol42")]
   public class SocialMediaFriendCellView extends Button implements ISocialMediaCellView
   {
      
      public var mcBackground:MovieClip;
      
      public var mcRelBackground:MovieClip;
      
      public var mcSimPortrait:MovieClip;
      
      public var txtSimName:TextField;
      
      public var btnRemoveFriend:Button;
      
      public var btnSendMessage:Button;
      
      public var mcTracksDisplay:RelationshipTracksDisplay;
      
      public var mcUnifiedIcon:ImageResource;
      
      public var mcControllerChatAction:LegendIcon;
      
      public var mcControllerRemoveFriendAction:LegendIcon;
      
      protected var mUnifiedIconToolTip:TooltipObject;
      
      protected var mRelInfo:RelationshipInfo;
      
      protected var mcVerifiedBadge:Sprite;
      
      public function SocialMediaFriendCellView()
      {
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40,49,this.frame50,59,this.frame60,69,this.frame70,79,this.frame80,89,this.frame90);
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.btnSendMessage.addEventListener(PushButtonEvent.CLICK,this.OnSendMessageClick,false,0,true);
         this.btnSendMessage.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_MESSAGE_CONTACT_BUTTON_TOOLTIP);
         this.btnRemoveFriend.addEventListener(PushButtonEvent.CLICK,this.OnRemoveFriendClick,false,0,true);
         this.btnRemoveFriend.TooltipExt.SetText(KeysGP.SOCIAL_MEDIA_REMOVE_CONTACT_BUTTON_TOOLTIP);
         this.mUnifiedIconToolTip = new TooltipObject(this.mcUnifiedIcon,Tooltip);
         this.mUnifiedIconToolTip.VerticalAlignment = Alignment.TOP;
         this.mUnifiedIconToolTip.HorizontalAlignment = Alignment.CENTER;
         this.mUnifiedIconToolTip.FallbackDirection = Alignment.LEFT;
         this.mUnifiedIconToolTip.Initialize(new Object());
         this.mcTracksDisplay.mcUnifiedIcon = this.mcUnifiedIcon;
         this.mcTracksDisplay.mUnifiedIconToolTip = this.mUnifiedIconToolTip;
         this.mcVerifiedBadge = SocialMediaTunables.CreateBadgeSprite(14);
         this.addChild(this.mcVerifiedBadge);
         mouseChildren = true;
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         this.mRelInfo = param1 as RelationshipInfo;
         this.RefreshLayout();
      }
      
      override public function SetState(param1:String) : void
      {
         super.SetState(param1);
         this.RefreshLayout();
      }
      
      public function SendConfirm() : void
      {
         if(SystemUtils.UsingConsoleInputMode)
         {
            if(Boolean(this.btnSendMessage) && Boolean(this.btnSendMessage.visible))
            {
               this.OnSendMessageClick(null);
            }
         }
      }
      
      public function RemoveFriend() : void
      {
         if(SystemUtils.UsingConsoleInputMode)
         {
            if(Boolean(this.btnRemoveFriend) && Boolean(this.btnRemoveFriend.visible))
            {
               this.OnRemoveFriendClick(null);
            }
         }
      }
      
      protected function RefreshLayout() : void
      {
         if(!this.mRelInfo)
         {
            return;
         }
         this.btnRemoveFriend.visible = true;
         this.btnSendMessage.visible = true;
         var _loc1_:IconComponent = this.mcSimPortrait.mcSimIcon as IconComponent;
         ImageUtils.LoadSimThumbnail(_loc1_,this.mRelInfo.targetId,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         this.txtSimName.htmlText = Keys.GENERIC_SIM_NAME.toString({"simId":this.mRelInfo.targetId});
         if(this.mcVerifiedBadge)
         {
            var bKind:String = SocialMediaTunables.GetBadgeForSim(this.mRelInfo.targetId);
            SocialMediaTunables.UpdateBadgeSprite(this.mcVerifiedBadge,bKind);
            this.mcVerifiedBadge.x = this.txtSimName.x + Math.min(this.txtSimName.width - 16,this.txtSimName.textWidth + 6);
            this.mcVerifiedBadge.y = this.txtSimName.y + 3;
         }
         var _loc2_:int = int(this.mRelInfo.targetManagerId);
         if(this.mRelInfo.relTracks.length == 1)
         {
            this.mcRelBackground.gotoAndStop("one_bar");
         }
         else
         {
            this.mcRelBackground.gotoAndStop("two_bar");
         }
         this.mcTracksDisplay.Draw(this.mRelInfo,_loc2_);
         InputModeVisibilityExtension.ShowForController(this.mcControllerChatAction);
         this.mcControllerChatAction.ActionCode = ActionCodes.CONFIRM;
         InputModeVisibilityExtension.ShowForController(this.mcControllerRemoveFriendAction);
         this.mcControllerRemoveFriendAction.ActionCode = ActionCodes.DELETE;
      }
      
      protected function OnSendMessageClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("interactions.push_targeting_sim_info",_loc2_.new_message_type_picker_interaction,this.mRelInfo.targetId,this.mRelInfo.actorId);
      }
      
      protected function OnRemoveFriendClick(param1:PushButtonEvent) : void
      {
         var _loc2_:SocialMediaStaticData = SocialMediaStaticData.GetStaticData();
         CommunicationManager.PostServerCommand("social_media.social_media_remove_friend",this.mRelInfo.actorId,this.mRelInfo.targetId);
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
      
      internal function frame40() : *
      {
         stop();
      }
      
      internal function frame50() : *
      {
         stop();
      }
      
      internal function frame60() : *
      {
         stop();
      }
      
      internal function frame70() : *
      {
         stop();
      }
      
      internal function frame80() : *
      {
         stop();
      }
      
      internal function frame90() : *
      {
         stop();
      }
   }
}

