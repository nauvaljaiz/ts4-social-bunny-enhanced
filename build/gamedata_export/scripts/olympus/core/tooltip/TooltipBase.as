package olympus.core.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.TooltipManager;
   import olympus.core.widget.Margin;
   import olympus.events.TooltipEvent;
   import olympus.events.TweenEvent;
   import olympus.interfaces.ITooltip;
   import olympus.motion.Animation;
   import olympus.motion.Tween;
   
   public class TooltipBase extends MovieClip implements ITooltip
   {
      
      protected static const TOOLTIP_PADDING:Margin = new Margin(9,10,10,10);
      
      protected static const SPACE_BETWEEN_TEXTFIELDS:Number = 1;
      
      protected static var BG_COLOR_ARRAY:Array = [16777215,15658734];
      
      protected static var BG_ALPHA_ARRAY:Array = [1,1];
      
      protected static var BG_RATIO_ARRAY:Array = [0,255];
      
      protected static const BG_BASE_HEIGHT:Number = 10;
      
      protected static const BG_LINE_HEIGHT:Number = 11;
      
      protected static const BG_DEFAULT_WIDTH:Number = 260;
      
      protected static const BG_MINIMUM_WIDTH:Number = 50;
      
      protected static const BG_MAX_WIDTH:Number = 400;
      
      protected static const TEXT_FIELD_PADDING:Number = 15;
      
      protected static const BG_ROUNDING:Number = 6;
      
      protected static const ARROW_LENGTH:Number = 8;
      
      protected static const ARROW_WIDTH:Number = 12;
      
      protected static const DIR_LEFT:String = "left";
      
      protected static const DIR_RIGHT:String = "right";
      
      protected static const DIR_CENTER:String = "center";
      
      protected static const DIR_UP:String = "up";
      
      protected static const DIR_DOWN:String = "down";
      
      protected var mBoxWidth:Number = 0;
      
      protected var mBoxHeight:Number = 0;
      
      protected var mFadeTween:Tween;
      
      protected var mBgColorArray:Array;
      
      protected var mBgAlphaArray:Array;
      
      protected var mBgRatioArray:Array;
      
      public function TooltipBase()
      {
         super();
         this.mBgColorArray = BG_COLOR_ARRAY;
         this.mBgAlphaArray = BG_ALPHA_ARRAY;
         this.mBgRatioArray = BG_RATIO_ARRAY;
      }
      
      public function SetData(param1:Object) : void
      {
      }
      
      public function OnUpdatePosition(param1:Rectangle, param2:Number = 0, param3:Number = 0) : void
      {
      }
      
      public function Show(param1:Number) : void
      {
         if(this.mFadeTween != null && this.mFadeTween.IsActive())
         {
            this.mFadeTween.Stop();
         }
         alpha = 0;
         visible = false;
         TooltipManager.getInstance().AddTooltip(this);
         Tween.StopAllTweens(this);
         var _loc2_:Tween = Tween.QuickAnimation(Animation.FADE_IN,0,this,param1);
         _loc2_.Start();
      }
      
      public function Hide(param1:Boolean, param2:Number) : void
      {
         if(TooltipManager.getInstance().IsTooltipShown(this))
         {
            Tween.StopAllTweens(this);
            if(param1)
            {
               this.OnTooltipTweenComplete(null);
            }
            else
            {
               this.mFadeTween = Tween.QuickAnimation(Animation.FADE_OUT,param2,this);
               this.mFadeTween.addEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTooltipTweenComplete,false,0,true);
               this.mFadeTween.Start();
            }
         }
      }
      
      protected function DrawBackground(param1:Number, param2:Number, param3:String, param4:String, param5:Number, param6:Number, param7:Sprite) : void
      {
         var _loc8_:Graphics = param7.graphics;
         var _loc9_:Number = this.mBoxWidth * 0.5 - param5;
         var _loc10_:Number = this.mBoxHeight * 0.5 - param6;
         var _loc11_:Number = ARROW_WIDTH * 0.5;
         var _loc12_:Number = BG_ROUNDING;
         _loc8_.clear();
         _loc8_.lineStyle(1,11184810,1);
         var _loc13_:Matrix = new Matrix();
         _loc13_.createGradientBox(param1,param2,Math.PI * 0.5);
         _loc8_.beginGradientFill(GradientType.LINEAR,this.mBgColorArray,this.mBgAlphaArray,this.mBgRatioArray,_loc13_);
         _loc8_.moveTo(_loc12_,0);
         if(param4 == DIR_UP)
         {
            _loc8_.lineTo(_loc9_ - _loc11_,0);
            _loc8_.lineTo(_loc9_,-ARROW_LENGTH);
            _loc8_.lineTo(_loc9_ + _loc11_,0);
         }
         _loc8_.lineTo(param1 - BG_ROUNDING,0);
         _loc8_.curveTo(param1,0,param1,_loc12_);
         if(param3 == DIR_RIGHT)
         {
            _loc8_.lineTo(param1,_loc10_ - _loc11_);
            _loc8_.lineTo(param1 + ARROW_LENGTH,_loc10_);
            _loc8_.lineTo(param1,_loc10_ + _loc11_);
         }
         _loc8_.lineTo(param1,param2 - _loc12_);
         _loc8_.curveTo(param1,param2,param1 - _loc12_,param2);
         if(param4 == DIR_DOWN)
         {
            _loc8_.lineTo(_loc9_ + _loc11_,param2);
            _loc8_.lineTo(_loc9_,param2 + ARROW_LENGTH);
            _loc8_.lineTo(_loc9_ - _loc11_,param2);
         }
         _loc8_.lineTo(_loc12_,param2);
         _loc8_.curveTo(0,param2,0,param2 - _loc12_);
         if(param3 == DIR_LEFT)
         {
            _loc8_.lineTo(0,_loc10_ + _loc11_);
            _loc8_.lineTo(-ARROW_LENGTH,_loc10_);
            _loc8_.lineTo(0,_loc10_ - _loc11_);
         }
         _loc8_.lineTo(0,_loc12_);
         _loc8_.curveTo(0,0,_loc12_,0);
      }
      
      protected function OnTooltipTweenComplete(param1:TweenEvent) : void
      {
         TooltipManager.getInstance().RemoveTooltip(this);
         dispatchEvent(new Event(TooltipEvent.HIDE_COMPLETE));
      }
      
      public function GetBounds() : Rectangle
      {
         if(this.mBoxWidth == 0 || this.mBoxHeight == 0)
         {
            return getBounds(this);
         }
         return new Rectangle(0,0,this.mBoxWidth,this.mBoxHeight);
      }
      
      public function GetDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function UpdatePositionHelper(param1:Rectangle, param2:Number, param3:Number, param4:Sprite) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         _loc7_ = this.GetBounds();
         _loc8_ = new Point(_loc7_.width,_loc7_.height);
         var _loc9_:Point = localToGlobal(_loc8_);
         var _loc10_:Rectangle = new Rectangle();
         _loc10_.top = _loc9_.y - _loc8_.y;
         _loc10_.bottom = _loc9_.y;
         _loc10_.left = _loc9_.x - _loc8_.x;
         _loc10_.right = _loc9_.x;
         if(_loc10_.right <= param1.left + 1)
         {
            _loc5_ = DIR_RIGHT;
            x -= ARROW_LENGTH;
         }
         else if(_loc10_.left >= param1.right - 1)
         {
            _loc5_ = DIR_LEFT;
            x += ARROW_LENGTH;
         }
         else
         {
            _loc5_ = DIR_CENTER;
         }
         if(_loc10_.bottom <= param1.top + 1)
         {
            _loc6_ = DIR_DOWN;
            y -= ARROW_LENGTH;
         }
         else if(_loc10_.top >= param1.bottom - 1)
         {
            _loc6_ = DIR_UP;
            y += ARROW_LENGTH;
         }
         else
         {
            _loc6_ = DIR_CENTER;
         }
         this.DrawBackground(this.mBoxWidth,this.mBoxHeight,_loc5_,_loc6_,param2,param3,param4);
      }
      
      protected function GetControllerHintText(param1:Object) : String
      {
         if(param1["controllerHints"] is String && param1["controllerHints"] != "")
         {
            return "<font color=\'#239f35\'>" + param1["controllerHints"] + "</font>";
         }
         return "";
      }
   }
}

