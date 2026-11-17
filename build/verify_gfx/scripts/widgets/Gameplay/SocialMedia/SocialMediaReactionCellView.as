package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import flash.text.TextField;
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
         gotoAndStop("reaction");
         this.txtCounter.htmlText = _loc3_.count.toString();
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

