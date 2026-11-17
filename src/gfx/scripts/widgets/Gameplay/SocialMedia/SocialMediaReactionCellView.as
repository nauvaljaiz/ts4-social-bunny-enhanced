package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import gamedata.Gameplay.SocialMedia.SocialMediaPostReaction;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.views.CellView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol227")]
   public class SocialMediaReactionCellView extends CellView
   {
      
      public var txtCounter:TextField;
      
      public var mcFriendly01:MovieClip;
      
      public var mcFriendly02:MovieClip;
      
      public var mcFlirty01:MovieClip;
      
      public var mcFlirty02:MovieClip;
      
      public var mcMean01:MovieClip;
      
      public var mcMean02:MovieClip;
      
      public function SocialMediaReactionCellView()
      {
         super();
         this.addFrameScript(0,this.OnReactionFrame,1,this.OnReactionFrame);
         this.stop();
         this.gotoAndStop("reaction");
      }
      
      private function OnReactionFrame() : void
      {
         this.stop();
         if(this.currentFrame != 1)
         {
            this.gotoAndStop("reaction");
         }
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         var _loc3_:SocialMediaPostReaction = param1 as SocialMediaPostReaction;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:SocialMediaReaction = SocialMediaStaticData.GetPostReaction(_loc3_.narrative_type,_loc3_.polarity_type);
         if(_loc4_ == null)
         {
            return;
         }
         this.stop();
         if(this.currentFrame != 1 || this.txtCounter == null)
         {
            this.gotoAndStop("reaction");
            this.stop();
         }
         var _loc5_:int = _loc3_.count;
         var _loc6_:String = _loc5_ >= 1000 ? String(Math.floor(_loc5_ / 1000)) + "k" : _loc5_.toString();
         if(this.txtCounter != null)
         {
            this.txtCounter.wordWrap = false;
            this.txtCounter.multiline = false;
            this.txtCounter.autoSize = TextFieldAutoSize.NONE;
            this.txtCounter.x = 25;
            this.txtCounter.width = 23;
            this.txtCounter.scrollH = 0;
            var _loc7_:String = _loc5_ >= 99 ? "<p align=\"left\"><font size=\"10\" color=\"#0949ab\">" + _loc6_ + "</font></p>" : "<p align=\"left\"><font size=\"12\" color=\"#0949ab\">" + _loc6_ + "</font></p>";
            if(this.txtCounter.htmlText != _loc7_)
            {
               this.txtCounter.htmlText = _loc7_;
            }
         }
         this.mcFriendly01.visible = false;
         this.mcFriendly02.visible = false;
         this.mcFlirty01.visible = false;
         this.mcFlirty02.visible = false;
         this.mcMean01.visible = false;
         this.mcMean02.visible = false;
         switch(_loc3_.narrative_type)
         {
            case SocialMediaReaction.NARRATIVE_FRIENDLY:
               this.mcFriendly01.visible = _loc3_.polarity_type == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcFriendly02.visible = _loc3_.polarity_type != SocialMediaReaction.POLARITY_POSITIVE;
               break;
            case SocialMediaReaction.NARRATIVE_FLIRTY:
               this.mcFlirty01.visible = _loc3_.polarity_type == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcFlirty02.visible = _loc3_.polarity_type != SocialMediaReaction.POLARITY_POSITIVE;
               break;
            case SocialMediaReaction.NARRATIVE_MEAN:
               this.mcMean01.visible = _loc3_.polarity_type == SocialMediaReaction.POLARITY_POSITIVE;
               this.mcMean02.visible = _loc3_.polarity_type != SocialMediaReaction.POLARITY_POSITIVE;
         }
      }
   }
}

