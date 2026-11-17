package olympus.utils
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.constants.Alignment;
   import olympus.core.widget.Margin;
   
   public class DropShadowUtils
   {
      
      public static const MARGIN_PANEL_BASE:int = 0;
      
      public static const MARGIN_PANEL_SECOND_LAYER:int = 1;
      
      public static const MARGIN_PANEL_SECOND_LAYER_ROUNDED:int = 2;
      
      public static const MARGIN_DROPDOWN_BASE:int = 3;
      
      protected static const MARGIN_MAP:Array = [new Margin(3,5,7,5),new Margin(3,1,2,4),new Margin(1,2,3,2),new Margin(0,2,8,2)];
      
      protected static const MARGIN_COUNT:int = MARGIN_MAP.length;
      
      public function DropShadowUtils()
      {
         super();
      }
      
      public static function AdjustInitialPosition(param1:DisplayObject, param2:int = 0, param3:Boolean = false) : void
      {
         var _loc4_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         param1.x -= _loc4_.mLeft;
         param1.y -= param3 ? _loc4_.mBot : _loc4_.mTop;
      }
      
      public static function AdjustInitialSize(param1:DisplayObject, param2:int = 0) : void
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         param1.width += _loc3_.Horizontal;
         param1.height += _loc3_.Vertical;
      }
      
      public static function AdjustInitialSizeAndPosition(param1:DisplayObject, param2:int = 0) : void
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         param1.width += _loc3_.Horizontal;
         param1.height += _loc3_.Vertical;
         param1.x -= _loc3_.mLeft;
         param1.y -= _loc3_.mTop;
      }
      
      public static function SetAdjustedX(param1:DisplayObject, param2:Number, param3:int = 0) : void
      {
         var _loc4_:Margin = 0 <= param3 && param3 < MARGIN_COUNT ? MARGIN_MAP[param3] : new Margin(0);
         param1.x = param2 - _loc4_.mLeft;
      }
      
      public static function SetAdjustedY(param1:DisplayObject, param2:Number, param3:int = 0) : void
      {
         var _loc4_:Margin = 0 <= param3 && param3 < MARGIN_COUNT ? MARGIN_MAP[param3] : new Margin(0);
         param1.y = param2 - _loc4_.mTop;
      }
      
      public static function SetAdjustedPosition(param1:DisplayObject, param2:Number, param3:Number, param4:int = 0) : void
      {
         var _loc5_:Margin = 0 <= param4 && param4 < MARGIN_COUNT ? MARGIN_MAP[param4] : new Margin(0);
         param1.x = param2 - _loc5_.mLeft;
         param1.y = param3 - _loc5_.mTop;
      }
      
      public static function AlignXTo(param1:DisplayObject, param2:Number, param3:String, param4:int = 0) : void
      {
         var _loc5_:Margin = 0 <= param4 && param4 < MARGIN_COUNT ? MARGIN_MAP[param4] : new Margin(0);
         switch(param3)
         {
            case Alignment.LEFT:
               param1.x = param2 - _loc5_.mLeft;
               break;
            case Alignment.RIGHT:
               param1.x = param2 - param1.width + _loc5_.mRight;
               break;
            case Alignment.CENTER:
               param1.x = param2 - _loc5_.mLeft - (param1.width - _loc5_.Horizontal) * 0.5;
         }
      }
      
      public static function AlignYTo(param1:DisplayObject, param2:Number, param3:String, param4:int = 0) : void
      {
         var _loc5_:Margin = 0 <= param4 && param4 < MARGIN_COUNT ? MARGIN_MAP[param4] : new Margin(0);
         switch(param3)
         {
            case Alignment.TOP:
               param1.y = param2 - _loc5_.mTop;
               break;
            case Alignment.BOTTOM:
               param1.y = param2 - param1.height + _loc5_.mBot;
               break;
            case Alignment.CENTER:
               param1.y = param2 - _loc5_.mTop - (param1.height - _loc5_.Vertical) * 0.5;
         }
      }
      
      public static function GetAdjustedX(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.x + _loc3_.mLeft;
      }
      
      public static function GetAdjustedRightX(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.x + param1.width - _loc3_.mRight;
      }
      
      public static function GetAdjustedY(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.y + _loc3_.mTop;
      }
      
      public static function GetAdjustedBottomY(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.y + param1.height - _loc3_.mBot;
      }
      
      public static function GetAdjustedPosition(param1:DisplayObject, param2:int = 0) : Point
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return new Point(param1.x + _loc3_.mLeft,param1.y + _loc3_.mTop);
      }
      
      public static function SetAdjustedWidth(param1:DisplayObject, param2:Number, param3:int = 0) : void
      {
         var _loc4_:Margin = 0 <= param3 && param3 < MARGIN_COUNT ? MARGIN_MAP[param3] : new Margin(0);
         param1.width = param2 + _loc4_.Horizontal;
      }
      
      public static function SetAdjustedHeight(param1:DisplayObject, param2:Number, param3:int = 0) : void
      {
         var _loc4_:Margin = 0 <= param3 && param3 < MARGIN_COUNT ? MARGIN_MAP[param3] : new Margin(0);
         param1.height = param2 + _loc4_.Vertical;
      }
      
      public static function SetAdjustedSize(param1:DisplayObject, param2:Number, param3:Number, param4:int = 0) : void
      {
         var _loc5_:Margin = 0 <= param4 && param4 < MARGIN_COUNT ? MARGIN_MAP[param4] : new Margin(0);
         param1.width = param2 + _loc5_.Horizontal;
         param1.height = param3 + _loc5_.Vertical;
      }
      
      public static function GetAdjustedWidth(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.width - _loc3_.Horizontal;
      }
      
      public static function GetAdjustedHeight(param1:DisplayObject, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1.height - _loc3_.Vertical;
      }
      
      public static function GetInnerBounds(param1:DisplayObject, param2:int = 0) : Rectangle
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return new Rectangle(param1.x + _loc3_.mLeft,param1.y + _loc3_.mTop,param1.width - _loc3_.Horizontal,param1.height - _loc3_.Vertical);
      }
      
      public static function CalcAdjustedWidth(param1:Number, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1 + _loc3_.Horizontal;
      }
      
      public static function CalcAdjustedHeight(param1:Number, param2:int = 0) : Number
      {
         var _loc3_:Margin = 0 <= param2 && param2 < MARGIN_COUNT ? MARGIN_MAP[param2] : new Margin(0);
         return param1 + _loc3_.Horizontal;
      }
      
      public static function GetMargin(param1:int = 0) : Margin
      {
         return 0 <= param1 && param1 < MARGIN_COUNT ? MARGIN_MAP[param1] : new Margin(0);
      }
   }
}

