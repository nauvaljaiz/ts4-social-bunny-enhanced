package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import olympus.controls.GUIComponent;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.events.GridEvent;
   import olympus.events.PushButtonEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.gui.grids.SelectionGrid;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.GridInputAdapter;
   import olympus.layout.GridLayout;
   import olympus.motion.Animation;
   import olympus.motion.Tween;
   import olympus.utils.SystemUtils;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol264")]
   public class SocialMediaReactionPopUp extends GUIComponent implements IInputFocusable
   {
      
      public static const SOCIAL_MEDIA_REACTION_SELECTED:String = "social_media_reaction_selected";
      
      public static const SOCIAL_MEDIA_REACTION_CANCELLED:String = "social_media_reaction_cancelled";
      
      public var mcBackground:MovieClip;
      
      public var mSelectionGrid:SelectionGrid;
      
      public var mcArrow:MovieClip;
      
      protected var mListAdapter:GridInputAdapter;
      
      protected var mFadeTween:Tween;
      
      protected var mDataFeed:SelectableArrayDataFeed = new SelectableArrayDataFeed();
      
      protected var mbGridInitialized:Boolean = false;
      
      public function SocialMediaReactionPopUp()
      {
         super();
      }
      
      public function Show(param1:Number) : void
      {
         if(this.mFadeTween != null && Boolean(this.mFadeTween.IsActive()))
         {
            this.mFadeTween.Stop();
         }
         alpha = 0;
         visible = false;
         Tween.StopAllTweens(this);
         var _loc2_:Tween = Tween.QuickAnimation(Animation.FADE_IN,param1,this);
         _loc2_.Start();
      }
      
      public function Hide(param1:Number) : void
      {
         Tween.StopAllTweens(this);
         this.mFadeTween = Tween.QuickAnimation(Animation.FADE_OUT,param1,this);
         this.mFadeTween.Start();
      }
      
      public function ShowSelectionGrid() : void
      {
         this.mSelectionGrid.visible = true;
         if(!this.mbGridInitialized)
         {
            this.InitializeSelectionGrid();
         }
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusForward(this.mListAdapter);
            this.HighlightSelectedItem();
         }
      }
      
      protected function InitializeSelectionGrid() : void
      {
         var _loc1_:GridLayout = new GridLayout(false,true,6);
         var _loc2_:SelectionGrid = this.mSelectionGrid;
         _loc2_.InitializeSelectionGrid(this.mDataFeed,SocialMediaEmojiCellView,true,null,_loc1_,false,false);
         _loc2_.SetSelectionGridListener(PushButtonEvent.CLICK);
         _loc2_.addEventListener(GridEvent.SELECTION_UPDATE,this.OnClickVariation,false,0,true);
         this.mbGridInitialized = true;
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitializeGamepadInput();
         }
      }
      
      public function SetData(param1:Array) : void
      {
         this.mDataFeed.RemoveAllItems();
         this.mDataFeed.AddItemsFromIterable(param1);
         if(this.mbGridInitialized)
         {
            this.mSelectionGrid.SetDataFeed(this.mDataFeed);
         }
      }
      
      protected function OnClickVariation(param1:GridEvent) : void
      {
         var _loc2_:SocialMediaReaction = param1.mData as SocialMediaReaction;
         dispatchEvent(new SocialMediaReactionEvent(SOCIAL_MEDIA_REACTION_SELECTED,true,false,_loc2_));
      }
      
      public function Remove() : void
      {
         if(SystemUtils.UsingConsoleInputMode)
         {
            NavManager.Instance.FocusBack();
         }
      }
      
      protected function InitializeGamepadInput() : void
      {
         this.mListAdapter = new GridInputAdapter(this.mSelectionGrid.mGridLayout as GridLayout);
         this.mListAdapter.OnBackCall(this.BackHandler);
      }
      
      protected function BackHandler() : void
      {
         dispatchEvent(new SocialMediaReactionEvent(SOCIAL_MEDIA_REACTION_CANCELLED,true,false));
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.mListAdapter.Enter();
         return this;
      }
      
      public function Exit() : void
      {
         this.mListAdapter.Exit();
      }
      
      public function HighlightSelectedItem() : void
      {
         var _loc1_:Array = this.mDataFeed.GetSelectedIndices();
         if(_loc1_.length > 0)
         {
            this.mListAdapter.SetHighlightedIndex(_loc1_[0]);
         }
      }
   }
}

