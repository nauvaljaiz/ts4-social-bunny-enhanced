package widgets.shared.controls
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.gui.buttons.Button;
   
   public class VariationStackContainer extends Button
   {
      
      public var mcStack:MovieClip;
      
      public var btnBg:Button;
      
      public var mcArrow:MovieClip;
      
      protected var mStartingBounds:Rectangle;
      
      protected var mStartingPoint:Point;
      
      protected var mBgOffsetX:Number;
      
      protected var mBgOffsetY:Number;
      
      protected var mHitAreaOffsetX:Number;
      
      protected var mHitAreaOffsetY:Number;
      
      protected var mArrowOriginalX:Number;
      
      protected var mArrowOriginalY:Number;
      
      public function VariationStackContainer()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         var _loc1_:VariationGrid = this.VariationStack;
         this.mStartingBounds = this.mcStack.getBounds(this);
         this.mStartingPoint = new Point(this.x,this.y);
         this.mBgOffsetX = _loc1_.x - this.btnBg.x;
         this.mBgOffsetY = _loc1_.y - this.btnBg.y;
         this.mHitAreaOffsetX = _loc1_.x - mcHitArea.x;
         this.mHitAreaOffsetY = _loc1_.y - mcHitArea.y;
         this.btnBg.mouseEnabled = false;
         this.mcArrow = this.btnBg.getChildByName("mcArrow") as MovieClip;
         if(this.mcArrow)
         {
            this.mArrowOriginalX = this.mcArrow.x;
            this.mArrowOriginalY = this.mcArrow.y;
         }
      }
      
      public function RefreshLayout() : void
      {
         var _loc1_:Rectangle = this.mStartingBounds;
         var _loc2_:VariationGrid = this.VariationStack;
         _loc2_.x = (_loc1_.x + _loc1_.width - _loc2_.width) * 0.5;
         _loc2_.y = (_loc1_.y + _loc1_.height - _loc2_.height) * 0.5;
         this.btnBg.x = _loc2_.x - this.mBgOffsetX;
         this.btnBg.y = _loc2_.y - this.mBgOffsetY;
         mcHitArea.x = _loc2_.x - this.mHitAreaOffsetX;
         mcHitArea.y = _loc2_.y - this.mHitAreaOffsetY;
         this.x = _loc1_.x - _loc2_.x + this.mStartingPoint.x;
         this.y = _loc1_.y - _loc2_.y + this.mStartingPoint.y;
      }
      
      override public function SetState(param1:String) : void
      {
         super.SetState(param1);
         this.btnBg.SetState(param1);
      }
      
      override public function set Selected(param1:Boolean) : void
      {
         super.Selected = param1;
         this.btnBg.Selected = param1;
      }
      
      public function get VariationStack() : VariationGrid
      {
         return this.mcStack.getChildByName("btnVariationStack") as VariationGrid;
      }
      
      public function SetArrowPosition(param1:Boolean) : void
      {
         if(this.mcArrow)
         {
            if(param1)
            {
               this.mcArrow.x = 0;
               this.mcArrow.y = this.mcStack.height * 0.5;
               this.mcArrow.rotation = 90;
            }
            else
            {
               this.mcArrow.x = this.mArrowOriginalX;
               this.mcArrow.y = this.mArrowOriginalY;
               this.mcArrow.rotation = 0;
            }
         }
      }
   }
}

