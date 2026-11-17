package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import olympus.gui.buttons.Button;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol268")]
   public class SocialMediaEmojiCellView extends Button
   {
      
      public var mcFriendly01:MovieClip;
      
      public var mcFriendly02:MovieClip;
      
      public var mcFlirty01:MovieClip;
      
      public var mcFlirty02:MovieClip;
      
      public var mcMean01:MovieClip;
      
      public var mcMean02:MovieClip;
      
      protected var mReactionData:SocialMediaReaction;
      
      public function SocialMediaEmojiCellView()
      {
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40,49,this.frame50,59,this.frame60,69,this.frame70,79,this.frame80,89,this.frame90);
         super();
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         this.mReactionData = param1 as SocialMediaReaction;
         this.RefreshLayout();
      }
      
      override public function SetState(param1:String) : void
      {
         super.SetState(param1);
         this.RefreshLayout();
      }
      
      protected function RefreshLayout() : void
      {
         this.mcFriendly01.visible = false;
         this.mcFriendly02.visible = false;
         this.mcFlirty01.visible = false;
         this.mcFlirty02.visible = false;
         this.mcMean01.visible = false;
         this.mcMean02.visible = false;
         if(!this.mReactionData)
         {
            return;
         }
         switch(this.mReactionData.narrative)
         {
            case SocialMediaReaction.NARRATIVE_FRIENDLY:
               this.mcFriendly01.visible = this.mReactionData.polarity == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcFriendly02.visible = this.mReactionData.polarity != SocialMediaReaction.POLARITY_POSITIVE;
               break;
            case SocialMediaReaction.NARRATIVE_FLIRTY:
               this.mcFlirty01.visible = this.mReactionData.polarity == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcFlirty02.visible = this.mReactionData.polarity != SocialMediaReaction.POLARITY_POSITIVE;
               break;
            case SocialMediaReaction.NARRATIVE_MEAN:
               this.mcMean01.visible = this.mReactionData.polarity == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcMean02.visible = this.mReactionData.polarity != SocialMediaReaction.POLARITY_POSITIVE;
         }
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

