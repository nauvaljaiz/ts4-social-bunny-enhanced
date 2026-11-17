package widgets.Gameplay.SocialMedia
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import gamedata.Gameplay.shared.definitions.SocialMediaStaticData;
   import olympus.constants.ActionCodes;
   import olympus.controls.IconComponent;
   import olympus.core.PopUpManager;
   import olympus.data.ArrayDataFeed;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.InputModeVisibilityExtension;
   import olympus.gui.buttons.Button;
   import olympus.io.CommunicationManager;
   import olympus.layout.GridLayout;
   import olympus.localization.Keys;
   import olympus.localization.KeysGP;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.ImageUtils;
   import olympus.views.GridView;
   import widgets.Gameplay.constants.SocialMediaTunables;
   import widgets.shared.controls.Console.LegendIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol241")]
   public class SocialMediaMessageDMCellView extends Button
   {
      
      public var mcBackground:MovieClip;
      
      public var mcSimPortrait:MovieClip;
      
      public var txtSimName:TextField;
      
      public var txtTime:TextField;
      
      public var txtPostContent:TextField;
      
      public var btnReaction:Button;
      
      public var mcReactionsGrid:GridView;
      
      public var mcControllerConfirmAction:LegendIcon;
      
      protected var mFeedData:ArrayDataFeed;
      
      protected var mGridLayout:GridLayout;
      
      protected var mcReactionPopUp:SocialMediaReactionPopUp;
      
      protected var mSocialMediaData:SocialMediaFeedItem;
      
      protected var mMinutesSincePost:uint;
      
      public function SocialMediaMessageDMCellView()
      {
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40,49,this.frame50,59,this.frame60,69,this.frame70,79,this.frame80,89,this.frame90);
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         mouseChildren = true;
         stage.addEventListener(MouseEvent.CLICK,this.OnMouseClick,false,0,true);
         var _loc1_:GridLayout = new GridLayout(false,true,SocialMediaTunables.REACTION_GRID_COLUMNS);
         _loc1_.SetCellView(SocialMediaReactionCellView,SocialMediaTunables.REACTION_CELL_MARGIN);
         _loc1_.SetGridView(this.mcReactionsGrid);
         this.mFeedData = new ArrayDataFeed();
         _loc1_.SetDataFeed(this.mFeedData);
         this.mGridLayout = _loc1_;
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         super.Draw(param1,param2);
         this.mSocialMediaData = param1 as SocialMediaFeedItem;
         this.mMinutesSincePost = SocialMediaMain.GetMinutesSincePostTime(uint(this.mSocialMediaData.post_time));
         this.RefreshLayout();
      }
      
      override public function SetState(param1:String) : void
      {
         super.SetState(param1);
         this.RefreshLayout();
      }
      
      protected function RefreshLayout() : void
      {
         var _loc2_:Object = null;
         if(this.mSocialMediaData == null)
         {
            return;
         }
         if(this.btnReaction)
         {
            this.btnReaction.visible = false;
         }
         var _loc1_:IconComponent = this.mcSimPortrait.mcSimIcon as IconComponent;
         ImageUtils.LoadSimThumbnail(_loc1_,this.mSocialMediaData.author_sim_id,ImageUtils.SIM_THUMBNAIL_TYPE_BUST);
         this.txtSimName.htmlText = KeysGP.SOCIAL_MEDIA_POST_SIM_NAME.toString({"simId":this.mSocialMediaData.author_sim_id});
         this.txtTime.htmlText = Keys.GENERIC_TIMESPAN.toString(this.mMinutesSincePost);
         if(this.mSocialMediaData.post_text)
         {
            _loc2_ = this.mSocialMediaData.target_sim_id != null ? {"simId":this.mSocialMediaData.target_sim_id} : new Object();
            this.txtPostContent.htmlText = this.mSocialMediaData.post_text.toString(_loc2_);
         }
         if(Boolean(this.btnReaction) && this.mSocialMediaData.post_type == SocialMediaFeedItem.POST_TYPE_DIRECT_MESSAGE)
         {
            if(!this.mSocialMediaData.HasSimReacted(this.mSocialMediaData.ownerSimId))
            {
               this.btnReaction.visible = true;
               this.btnReaction.addEventListener(PushButtonEvent.CLICK,this.OnReactionClick,false,0,true);
            }
         }
         if(this.mSocialMediaData.reactions.length > 0)
         {
            this.mcReactionsGrid.visible = true;
            this.mFeedData.RemoveAllItems();
            this.mFeedData.AddItemsFromIterable(this.mSocialMediaData.reactions);
         }
         if(this.mcControllerConfirmAction)
         {
            InputModeVisibilityExtension.ShowForController(this.mcControllerConfirmAction);
            this.mcControllerConfirmAction.ActionCode = ActionCodes.CONFIRM;
            if(!this.btnReaction.visible)
            {
               this.mcControllerConfirmAction.visible = false;
            }
         }
      }
      
      protected function OnReactionClick(param1:PushButtonEvent) : void
      {
         this.RemoveReactionPopUp();
         var _loc2_:SocialMediaReactionPopUp = this.mcReactionPopUp = new SocialMediaReactionPopUp();
         var _loc3_:Rectangle = this.btnReaction.getRect(this);
         var _loc4_:Number = _loc3_.left - _loc2_.width * 0.75;
         var _loc5_:Number = _loc3_.bottom + SocialMediaTunables.REACTIONS_POPUP_ARROW_HEIGHT;
         PopUpManager.RemoveAllOfClass(SocialMediaReactionPopUp);
         PopUpManager.Show(_loc2_,this,_loc4_,_loc5_);
         _loc2_.Show(SocialMediaTunables.REACTIONS_POPUP_ANIMATION_DELAY);
         _loc2_.SetData(SocialMediaStaticData.GetStaticData().social_media_post_reactions);
         _loc2_.ShowSelectionGrid();
         _loc2_.addEventListener(SocialMediaReactionPopUp.SOCIAL_MEDIA_REACTION_SELECTED,this.OnReactionSelected,false,0,true);
         _loc2_.addEventListener(SocialMediaReactionPopUp.SOCIAL_MEDIA_REACTION_CANCELLED,this.OnReactionCancelled,false,0,true);
      }
      
      protected function OnReactionSelected(param1:SocialMediaReactionEvent) : void
      {
         this.RemoveReactionPopUp();
         var _loc2_:SocialMediaReaction = param1.reactionData;
         CommunicationManager.PostServerCommand("social_media.add_reaction_to_post_ids",GameplayStateData.ActiveSimId,this.mSocialMediaData.author_sim_id,this.mSocialMediaData.post_id,this.mSocialMediaData.post_type.toString(),_loc2_.narrative.toString(),_loc2_.polarity.toString());
      }
      
      protected function OnReactionCancelled(param1:SocialMediaReactionEvent) : void
      {
         this.RemoveReactionPopUp();
      }
      
      public function RemoveReactionPopUp() : void
      {
         var _loc1_:SocialMediaReactionPopUp = null;
         _loc1_ = this.mcReactionPopUp;
         if(_loc1_)
         {
            _loc1_.visible = false;
            _loc1_.Remove();
            _loc1_.Hide(SocialMediaTunables.REACTIONS_POPUP_ANIMATION_DELAY);
            PopUpManager.Remove(_loc1_);
            this.mcReactionPopUp = null;
         }
      }
      
      protected function OnMouseClick(param1:MouseEvent = null) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(Boolean(_loc2_) && _loc2_ != this && !DisplayObjectUtils.IsParent(this.parent,_loc2_))
         {
            this.RemoveReactionPopUp();
         }
      }
      
      public function SendConfirm() : void
      {
         if(Boolean(this.btnReaction) && Boolean(this.btnReaction.visible))
         {
            this.OnReactionClick(null);
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

