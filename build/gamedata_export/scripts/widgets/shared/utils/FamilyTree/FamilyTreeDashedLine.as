package widgets.shared.utils.FamilyTree
{
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.geom.Point;
   
   public class FamilyTreeDashedLine
   {
      
      protected static const DEFAULT_LENGTHS_ARRAY:Array = [5,5];
      
      protected var mLengthsArray:Array = [];
      
      protected var mLineColor:uint;
      
      protected var mLineWeight:Number;
      
      protected var mLineAlpha:Number = 1;
      
      protected var mCurrentX:Number = 0;
      
      protected var mCurrentY:Number = 0;
      
      protected var mRemainingDist:Number = 0;
      
      protected var mCurrentIndex:uint = 0;
      
      protected var mStartIndex:int = 0;
      
      protected var mGraphics:Graphics;
      
      public function FamilyTreeDashedLine(param1:Graphics, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Array = null)
      {
         super();
         this.mGraphics = param1;
         this.mLengthsArray = param5;
         if(this.mLengthsArray == null)
         {
            this.mLengthsArray = DEFAULT_LENGTHS_ARRAY;
         }
         this.mLineWeight = param2;
         this.mLineColor = param3;
         this.mLineAlpha = param4;
         this.mGraphics.lineStyle(this.mLineWeight,this.mLineColor,this.mLineAlpha,false,LineScaleMode.NONE,CapsStyle.NONE);
      }
      
      public function MoveTo(param1:Number, param2:Number) : void
      {
         this.mGraphics.moveTo(param1,param2);
         this.mCurrentX = param1;
         this.mCurrentY = param2;
         this.mRemainingDist = 0;
         this.mStartIndex = 0;
      }
      
      public function LineTo(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc3_:Number = (param2 - this.mCurrentY) / (param1 - this.mCurrentX);
         _loc4_ = this.mCurrentX;
         var _loc5_:Number = this.mCurrentY;
         var _loc6_:int = param1 < _loc4_ ? -1 : 1;
         var _loc7_:int = param2 < _loc5_ ? -1 : 1;
         var _loc8_:Boolean = false;
         while(!_loc8_ && (Math.abs(_loc4_ - this.mCurrentX) < Math.abs(_loc4_ - param1) || Math.abs(_loc5_ - this.mCurrentY) < Math.abs(_loc5_ - param2)))
         {
            _loc9_ = this.mStartIndex;
            while(_loc9_ < this.mLengthsArray.length)
            {
               _loc10_ = this.mRemainingDist == 0 ? Number(this.mLengthsArray[_loc9_]) : this.mRemainingDist;
               _loc11_ = this.GetCoords(_loc10_,_loc3_).x * _loc6_;
               _loc12_ = this.GetCoords(_loc10_,_loc3_).y * _loc7_;
               if(!(Math.abs(_loc4_ - this.mCurrentX) + Math.abs(_loc11_) < Math.abs(_loc4_ - param1) || Math.abs(_loc5_ - this.mCurrentY) + Math.abs(_loc12_) < Math.abs(_loc5_ - param2)))
               {
                  this.mRemainingDist = this.GetDistance(this.mCurrentX,this.mCurrentY,param1,param2);
                  this.mCurrentIndex = _loc9_;
                  _loc8_ = true;
                  break;
               }
               if(_loc9_ % 2 == 0)
               {
                  this.mGraphics.lineTo(this.mCurrentX + _loc11_,this.mCurrentY + _loc12_);
               }
               else
               {
                  this.mGraphics.moveTo(this.mCurrentX + _loc11_,this.mCurrentY + _loc12_);
               }
               this.mCurrentX += _loc11_;
               this.mCurrentY += _loc12_;
               this.mCurrentIndex = _loc9_;
               this.mStartIndex = 0;
               this.mRemainingDist = 0;
               _loc9_++;
            }
         }
         this.mStartIndex = this.mCurrentIndex;
         if(this.mRemainingDist != 0)
         {
            if(this.mCurrentIndex % 2 == 0)
            {
               this.mGraphics.lineTo(param1,param2);
            }
            else
            {
               this.mGraphics.moveTo(param1,param2);
            }
            this.mRemainingDist = this.mLengthsArray[this.mCurrentIndex] - this.mRemainingDist;
         }
         else
         {
            this.mStartIndex = this.mStartIndex == this.mLengthsArray.length - 1 ? 0 : int(this.mStartIndex + 1);
         }
         this.mCurrentX = param1;
         this.mCurrentY = param2;
      }
      
      public function CurveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.mGraphics.curveTo(param1,param2,param3,param4);
         this.mCurrentX = param3;
         this.mCurrentY = param4;
      }
      
      protected function GetCoords(param1:Number, param2:Number) : Point
      {
         var _loc3_:Number = NaN;
         _loc3_ = Math.atan(param2);
         var _loc4_:Number = Math.abs(Math.sin(_loc3_) * param1);
         var _loc5_:Number = Math.abs(Math.cos(_loc3_) * param1);
         return new Point(_loc5_,_loc4_);
      }
      
      protected function GetDistance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
      }
   }
}

