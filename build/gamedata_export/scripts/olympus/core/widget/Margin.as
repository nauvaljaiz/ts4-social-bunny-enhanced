package olympus.core.widget
{
   import flash.geom.Rectangle;
   
   public final class Margin
   {
      
      public var mTop:Number = 0;
      
      public var mBot:Number = 0;
      
      public var mLeft:Number = 0;
      
      public var mRight:Number = 0;
      
      public function Margin(param1:Number = 0, param2:Number = NaN, param3:Number = NaN, param4:Number = NaN)
      {
         super();
         if(!isNaN(param2))
         {
            if(!isNaN(param3))
            {
               if(!isNaN(param4))
               {
                  this.mTop = param1;
                  this.mRight = param2;
                  this.mBot = param3;
                  this.mLeft = param4;
               }
               else
               {
                  this.mTop = param1;
                  this.mLeft = param2;
                  this.mRight = param2;
                  this.mBot = param3;
               }
            }
            else
            {
               this.mTop = param1;
               this.mBot = param1;
               this.mLeft = param2;
               this.mRight = param2;
            }
         }
         else
         {
            this.mTop = param1;
            this.mBot = param1;
            this.mLeft = param1;
            this.mRight = param1;
         }
      }
      
      public static function TopRightBottomLeft(param1:Number, param2:Number, param3:Number, param4:Number) : Margin
      {
         return new Margin(param1,param2,param3,param4);
      }
      
      public static function VerticalHorizontal(param1:Number, param2:Number) : Margin
      {
         return new Margin(param1,param2);
      }
      
      public static function Uniform(param1:Number) : Margin
      {
         return new Margin(param1);
      }
      
      public static function DeflateRectByInnerMargin(param1:Rectangle, param2:Margin) : void
      {
         param1.top += param2.mTop;
         param1.bottom -= param2.mBot;
         param1.left += param2.mLeft;
         param1.right -= param2.mRight;
      }
      
      public static function ComputeOffsetFromRect(param1:Rectangle, param2:Rectangle) : Margin
      {
         return new Margin(param1.y - param2.y,param1.x + param1.width - (param2.x + param2.width),param1.y + param1.height - (param2.y + param2.height),param1.x - param2.x);
      }
      
      public function get Horizontal() : Number
      {
         return this.mLeft + this.mRight;
      }
      
      public function get Vertical() : Number
      {
         return this.mTop + this.mBot;
      }
      
      public function Equals(param1:Margin) : Boolean
      {
         return this.mTop == param1.mTop && this.mBot == param1.mBot && this.mLeft == param1.mLeft && this.mRight == param1.mRight;
      }
      
      public function Copy() : Margin
      {
         return new Margin(this.mTop,this.mRight,this.mBot,this.mLeft);
      }
      
      public function toString() : String
      {
         return [" Margin - Top: ",this.mTop," Bot: ",this.mBot," Left: ",this.mLeft," Right: ",this.mRight].join("");
      }
   }
}

