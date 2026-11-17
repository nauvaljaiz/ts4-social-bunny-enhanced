package widgets.shared.controls
{
   import flash.events.Event;
   import flash.geom.Point;
   import olympus.constants.WindowAnimation;
   import olympus.core.ExtendableComponent;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.events.TweenEvent;
   import olympus.extensions.AudioExtension;
   import olympus.motion.Tween;
   
   public class SharedProductInfoPanel extends ExtendableComponent
   {
      
      public static const SHOW_DELAY:Number = 300;
      
      protected var mProduct:Object;
      
      protected var mbDispatchAudioEventOnHide:Boolean = true;
      
      protected var mAudioExtension:AudioExtension;
      
      protected var mTweenIn:Tween;
      
      public function SharedProductInfoPanel()
      {
         super();
         this.mAudioExtension = GetExtension(AudioExtension) as AudioExtension;
         this.mAudioExtension.ElementName = "ProductInfoPanel";
         this.mAudioExtension.CategoryName = "PopUp";
         addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,false,0,true);
      }
      
      protected function OnAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
      }
      
      public function Show(param1:Object, param2:uint = 300, param3:Boolean = true) : Boolean
      {
         if(Ticker.Has(this))
         {
            Ticker.Remove(this);
         }
         if(Boolean(param2) && param3)
         {
            Ticker.Add(this,param2,this.AnimateIn);
         }
         else if(!visible)
         {
            if(param3)
            {
               this.AnimateIn();
            }
            else
            {
               if(this.mTweenIn)
               {
                  this.mTweenIn.Stop(false,true);
                  this.mTweenIn = null;
               }
               visible = true;
            }
         }
         else if(this.mTweenIn)
         {
            this.mTweenIn.Stop(false,true);
            this.mTweenIn = null;
         }
         return true;
      }
      
      public function Hide(param1:Boolean = true, param2:uint = 0) : void
      {
         this.mProduct = null;
         Ticker.Remove(this);
         this.mbDispatchAudioEventOnHide = param1;
         if(param2)
         {
            Ticker.Add(this,param2,this.AnimateOut);
         }
         else
         {
            this.AnimateOut();
         }
      }
      
      protected function AnimateIn(param1:TickerEvent = null) : void
      {
         if(!this.mTweenIn)
         {
            this.mTweenIn = Tween.AnimateClip(0,WindowAnimation.PANEL_SMALL_VERT_IN,this,getRect(parent),new Point(0.5,1));
            this.mTweenIn.addEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenInComplete,false,0,true);
            this.mAudioExtension.DispatchShow();
         }
      }
      
      protected function OnTweenInComplete(param1:TweenEvent) : void
      {
         this.mTweenIn.removeEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenInComplete);
         this.mTweenIn = null;
      }
      
      protected function AnimateOut(param1:TickerEvent = null) : void
      {
         if(this.mTweenIn)
         {
            this.mTweenIn.Stop(true,true);
         }
         if(visible)
         {
            visible = false;
            if(this.mbDispatchAudioEventOnHide)
            {
               this.mAudioExtension.DispatchHide();
            }
            this.mbDispatchAudioEventOnHide = true;
         }
      }
   }
}

