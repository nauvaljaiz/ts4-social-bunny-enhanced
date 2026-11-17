package olympus.controllers
{
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import olympus.core.Ticker;
   import olympus.events.ScrollerEvent;
   import olympus.events.SmoothSliderEvent;
   import olympus.events.TickerEvent;
   import olympus.gui.sliders.Slider;
   import olympus.interfaces.IScrollerController;
   import olympus.motion.Easing;
   import olympus.utils.Clamp;
   
   public class SliderScrollerController extends EventDispatcher implements IScrollerController
   {
      
      protected var mStartValue:Number = 0;
      
      protected var mDestValue:Number = 0;
      
      protected var mSlider:Slider;
      
      protected var ease:Function = Easing.easeOutCubic;
      
      protected var startVal:Number = 0;
      
      protected var endVal:Number = 0;
      
      protected var val:Number = 0;
      
      protected var elapsed:Number = 0;
      
      protected var duration:Number = 0;
      
      public function SliderScrollerController(param1:Slider)
      {
         super(param1.stage);
         this.mSlider = param1;
         param1.addEventListener(SmoothSliderEvent.SNAP,this.OnSmoothSnap,false,0,true);
         param1.addEventListener(SmoothSliderEvent.SLIDE,this.OnSmoothSlide,false,0,true);
      }
      
      protected function OnSmoothSnap(param1:SmoothSliderEvent) : void
      {
         var _loc2_:Rectangle = new Rectangle(0,param1.mSliderValue);
         dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL,_loc2_));
         if(this.mSlider.MaxValue - this.mSlider.MinValue == 0)
         {
            return;
         }
         if(param1.mSliderValue >= this.mSlider.MaxValue)
         {
            dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL_END,_loc2_));
         }
         else if(param1.mSliderValue <= this.mSlider.MinValue)
         {
            dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL_BEGIN,_loc2_));
         }
      }
      
      protected function OnSmoothSlide(param1:SmoothSliderEvent) : void
      {
         if(param1.mPrevSliderValue == param1.mSliderValue)
         {
            return;
         }
         this.mStartValue = param1.mPrevSliderValue;
         this.mDestValue = param1.mSliderValue;
         if(!Ticker.Has(this))
         {
            Ticker.Add(this,0,this.Interpolate);
         }
         this.elapsed = 0;
         this.duration = 1000;
         this.startVal = this.mStartValue;
         this.endVal = this.mDestValue;
      }
      
      protected function Interpolate(param1:TickerEvent) : void
      {
         this.elapsed += param1.deltaTime;
         var _loc2_:Number = this.elapsed / this.duration;
         _loc2_ = Clamp.Num(_loc2_,0,1);
         if(this.ease != null)
         {
            _loc2_ = this.ease(_loc2_,0,1,1);
         }
         this.val = this.startVal + (this.endVal - this.startVal) * _loc2_;
         this.InterpolateValue(this.val);
         if(_loc2_ == 1)
         {
            Ticker.Remove(this);
            this.elapsed = 0;
         }
      }
      
      protected function InterpolateValue(param1:Number) : void
      {
         var _loc2_:Rectangle = new Rectangle(0,param1);
         dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL,_loc2_));
         if(this.mSlider.MaxValue - this.mSlider.MinValue == 0)
         {
            return;
         }
         if(param1 >= this.mSlider.MaxValue)
         {
            dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL_END,_loc2_));
         }
         else if(param1 <= this.mSlider.MinValue)
         {
            dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL_BEGIN,_loc2_));
         }
      }
   }
}

