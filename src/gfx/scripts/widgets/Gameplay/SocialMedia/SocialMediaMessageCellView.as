package widgets.Gameplay.SocialMedia
{
   import gamedata.Gameplay.SocialMedia.SocialMediaMessageItem;
   import olympus.gamepad.HighlightRequestEvent;
   import olympus.utils.SystemUtils;
   import olympus.views.CellView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol246")]
   public class SocialMediaMessageCellView extends CellView implements ISocialMediaCellView
   {
      
      protected static const THEM_MESSAGE_LABEL:String = "them_dm";
      
      protected static const ME_MESSAGE_LABEL:String = "me_dm";
      
      public var mcDirectMessage:SocialMediaMessageDMCellView;
      
      protected var mSocialMediaData:SocialMediaMessageItem;
      
      public function SocialMediaMessageCellView()
      {
         addFrameScript(1,this.frame2);
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.addEventListener(HighlightRequestEvent.HIGHLIGHT_REQUEST,this.HandleHighlightRequest,false,0,true);
         }
         mouseChildren = true;
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         this.mSocialMediaData = param1 as SocialMediaMessageItem;
         if(this.mSocialMediaData == null)
         {
            return;
         }
         if(this.mSocialMediaData.message_post.author_sim_id == this.mSocialMediaData.ownerSimId)
         {
            gotoAndStop(ME_MESSAGE_LABEL);
         }
         else
         {
            gotoAndStop(THEM_MESSAGE_LABEL);
         }
         this.mcDirectMessage.Draw(this.mSocialMediaData.message_post);
      }
      
      public function SendConfirm() : void
      {
         this.mcDirectMessage.SendConfirm();
      }
      
      public function RemoveReactionPopUp() : void
      {
         this.mcDirectMessage.RemoveReactionPopUp();
      }
      
      protected function HandleHighlightRequest(param1:HighlightRequestEvent) : void
      {
         if(param1.shouldHighlight)
         {
            if(this.mcDirectMessage.enabled)
            {
               this.mcDirectMessage.SetState("over");
            }
         }
         else if(this.mcDirectMessage.enabled)
         {
            this.mcDirectMessage.SetState("up");
         }
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

