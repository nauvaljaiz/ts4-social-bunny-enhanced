package olympus.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   import olympus.constants.Alignment;
   import olympus.core.Ticker;
   import olympus.core.widget.Margin;
   import olympus.errors.Assert;
   import olympus.events.TickerEvent;
   import olympus.interfaces.IBoundsOverride;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.math.Geometry;
   import widgets.UIContainer.controls.InputBlocker;
   
   public final class DisplayObjectUtils
   {
      
      public static const INPUT_BLOCKER_REMOVED:String = "inputBlockerRemoved";
      
      public static const MODALITY_GRADIENT_COLOR_ARRAY:Array = [1449274,1185071];
      
      public static const MODALITY_GRADIENT_ALPHA_ARRAY:Array = [0.55,0.85];
      
      public static const MODALITY_GRADIENT_RATIOS_ARRAY:Array = [0,255];
      
      public static const MODALITY_COLOR:uint = 0;
      
      public static const MODALITY_ALPHA:Number = 0.5;
      
      public static const MODALITY_BLEED:Number = 4;
      
      public static const MODALITY_BLEED_NEG_HALF:Number = -2;
      
      public function DisplayObjectUtils()
      {
         super();
      }
      
      public static function GetParentClass(param1:DisplayObject, param2:Class) : DisplayObject
      {
         var _loc3_:DisplayObject = param1;
         while(_loc3_ != null && !(_loc3_ is param2))
         {
            _loc3_ = _loc3_.parent;
         }
         return _loc3_;
      }
      
      public static function GetParentClassByString(param1:DisplayObject, param2:String) : DisplayObject
      {
         var _loc3_:DisplayObject = param1;
         while(_loc3_ != null && getQualifiedClassName(_loc3_) != param2)
         {
            _loc3_ = _loc3_.parent;
         }
         return _loc3_;
      }
      
      public static function IsParent(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var _loc3_:DisplayObject = param2;
         while(_loc3_ != null && _loc3_ != param1)
         {
            _loc3_ = _loc3_.parent;
         }
         return _loc3_ != null;
      }
      
      public static function GetChildrenByClass(param1:DisplayObjectContainer, param2:Class, param3:Array, param4:Boolean = false) : void
      {
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc5_:int = param1.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            if(!(!_loc7_.visible || !_loc7_.stage))
            {
               if(_loc7_ is param2)
               {
                  param3.push(_loc7_);
                  if(param4)
                  {
                     return;
                  }
               }
               if(_loc7_ is DisplayObjectContainer)
               {
                  GetChildrenByClass(_loc7_ as DisplayObjectContainer,param2,param3,param4);
               }
            }
            _loc6_++;
         }
      }
      
      public static function DrawModality(param1:Graphics, param2:Number, param3:Number) : void
      {
         var _loc4_:Matrix = new Matrix();
         _loc4_.rotate(Math.PI * 0.5);
         param1.clear();
         param1.beginGradientFill(GradientType.LINEAR,MODALITY_GRADIENT_COLOR_ARRAY,MODALITY_GRADIENT_ALPHA_ARRAY,MODALITY_GRADIENT_RATIOS_ARRAY,_loc4_);
         param1.drawRect(0,0,param2 + MODALITY_BLEED,param3 + MODALITY_BLEED);
         param1.endFill();
      }
      
      public static function CreateInputBlocker(param1:DisplayObjectContainer, param2:int, param3:Rectangle = null, param4:Function = null) : void
      {
         var length:int;
         var inputBlocker:Sprite = null;
         var target:DisplayObjectContainer = param1;
         var time:int = param2;
         var rect:Rectangle = param3;
         var callbackFunction:Function = param4;
         if(time == 0)
         {
            return;
         }
         length = target.numChildren;
         if(length > 0)
         {
            if(target.getChildAt(length - 1) is InputBlocker)
            {
               target.removeChildAt(length - 1);
            }
         }
         if(Ticker.Has(target))
         {
            Ticker.Remove(target);
         }
         if(!rect)
         {
            rect = target.getRect(target);
         }
         inputBlocker = new InputBlocker();
         inputBlocker.width = rect.width;
         inputBlocker.height = rect.height;
         inputBlocker.x = rect.x;
         inputBlocker.y = rect.y;
         inputBlocker.alpha = 0;
         inputBlocker.addEventListener(Event.ADDED_TO_STAGE,OnInputBlockerAddedToStage,false,0,true);
         inputBlocker.addEventListener(Event.REMOVED_FROM_STAGE,OnInputBlockerRemovedFromStage,false,0,true);
         target.addChild(inputBlocker);
         if(callbackFunction != null)
         {
            target.addEventListener(INPUT_BLOCKER_REMOVED,callbackFunction,false,0,true);
         }
         Ticker.Add(target,time,function(param1:TickerEvent):void
         {
            if(target)
            {
               target.removeChild(inputBlocker);
            }
            if(target.hasEventListener(INPUT_BLOCKER_REMOVED))
            {
               target.dispatchEvent(new Event(INPUT_BLOCKER_REMOVED));
               target.removeEventListener(INPUT_BLOCKER_REMOVED,callbackFunction);
            }
         },false,false);
      }
      
      protected static function OnInputBlockerAddedToStage(param1:Event = null) : void
      {
         InputActionManager.IgnoreAllInputActions = true;
      }
      
      protected static function OnInputBlockerRemovedFromStage(param1:Event = null) : void
      {
         InputActionManager.IgnoreAllInputActions = false;
      }
      
      public static function OutlineActiveObjectsWithin(param1:DisplayObjectContainer, param2:Graphics, param3:Number, param4:uint, param5:Number) : void
      {
         var _loc8_:DisplayObject = null;
         var _loc9_:DisplayObjectContainer = null;
         var _loc10_:InteractiveObject = null;
         var _loc11_:Rectangle = null;
         var _loc6_:int = param1.numChildren;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param1.getChildAt(_loc7_);
            if(_loc8_ is DisplayObjectContainer)
            {
               _loc9_ = _loc8_ as DisplayObjectContainer;
               if(_loc9_.visible)
               {
                  if(_loc9_.mouseChildren)
                  {
                     OutlineActiveObjectsWithin(_loc9_,param2,param3,param4,param5);
                  }
               }
            }
            if(_loc8_ is InteractiveObject)
            {
               _loc10_ = _loc8_ as InteractiveObject;
               if(_loc10_.mouseEnabled && _loc10_.visible)
               {
                  _loc11_ = _loc10_.getRect(param1.stage);
                  param2.lineStyle(2,16711935,0.6);
                  param2.drawRect(_loc11_.x,_loc11_.y,_loc11_.width,_loc11_.height);
               }
            }
            _loc7_++;
         }
      }
      
      public static function CenterHorizontallyWithinObject(param1:Array, param2:DisplayObject, param3:Number) : void
      {
         if(!param1 || param1.length == 0 || !param2)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         var _loc6_:int = int(param1.length);
         while(_loc5_ < _loc6_)
         {
            _loc4_ += param1[_loc5_].width;
            _loc5_++;
         }
         _loc4_ += param3 * (_loc6_ - 1);
         param1[0].x = param2.x + 0.5 * (param2.width - _loc4_);
         _loc5_ = 1;
         while(_loc5_ < _loc6_)
         {
            param1[_loc5_].x = param1[_loc5_ - 1].x + param1[_loc5_ - 1].width + param3;
            _loc5_++;
         }
      }
      
      public static function CenterVerticallyAndStackWithinObject(param1:Array, param2:DisplayObject, param3:Number) : void
      {
         if(!param1 || param1.length == 0 || !param2)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         var _loc6_:int = int(param1.length);
         while(_loc5_ < _loc6_)
         {
            _loc4_ += param1[_loc5_].height;
            _loc5_++;
         }
         _loc4_ += param3 * (_loc6_ - 1);
         param1[0].y = param2.y + 0.5 * (param2.height - _loc4_);
         _loc5_ = 1;
         while(_loc5_ < _loc6_)
         {
            param1[_loc5_].y = param1[_loc5_ - 1].y + param1[_loc5_ - 1].height + param3;
            _loc5_++;
         }
      }
      
      public static function CenterVerticallyWithinObject(param1:Array, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         if(!param1 || param1.length == 0 || !param2)
         {
            return;
         }
         for each(_loc3_ in param1)
         {
            _loc3_.y = param2.y + 0.5 * (param2.height - _loc3_.height);
         }
      }
      
      public static function CenterVisibleObjectsHorizontally(param1:Array, param2:Number, param3:Number = 0) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         for each(_loc7_ in param1)
         {
            if(_loc7_.visible)
            {
               _loc4_++;
               _loc5_ += _loc7_.width;
            }
            _loc6_ += _loc7_.width;
         }
         if(_loc4_ == 0)
         {
            return;
         }
         _loc5_ += (_loc4_ - 1) * param2;
         _loc6_ += (param1.length - 1) * param2;
         var _loc8_:Number = param3 + (_loc6_ - _loc5_) * 0.5;
         for each(_loc7_ in param1)
         {
            if(_loc7_.visible)
            {
               _loc7_.x = _loc8_;
               _loc8_ += _loc7_.width + param2;
            }
         }
      }
      
      public static function GetZoomToPointProps(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Object
      {
         var _loc7_:Number = param1.scaleX * param6;
         var _loc8_:Number = param1.scaleY * param6;
         var _loc9_:Number = param2 * _loc7_;
         var _loc10_:Number = param3 * _loc8_;
         return {
            "x":param4 - _loc9_,
            "y":param5 - _loc10_,
            "scaleX":_loc7_,
            "scaleY":_loc8_
         };
      }
      
      public static function CounterScale(param1:DisplayObject) : void
      {
         if(param1.scaleX != 1)
         {
            param1.width *= param1.scaleX;
            param1.scaleX = 1;
         }
         if(param1.scaleY != 1)
         {
            param1.height *= param1.scaleY;
            param1.scaleY = 1;
         }
      }
      
      public static function PrintAllNamesWithin(param1:DisplayObjectContainer, param2:String = "") : void
      {
         var _loc5_:DisplayObject = null;
         var _loc3_:int = param1.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.getChildAt(_loc4_);
            if(_loc5_ is DisplayObjectContainer)
            {
               PrintAllNamesWithin(_loc5_ as DisplayObjectContainer,param2 + "->");
            }
            _loc4_++;
         }
      }
      
      public static function IsPointWithinDisplayObject(param1:DisplayObject, param2:Point) : Boolean
      {
         if(!param1.stage || !param1.visible)
         {
            return false;
         }
         var _loc3_:Rectangle = param1.getBounds(param1.stage);
         return _loc3_.containsPoint(param2);
      }
      
      public static function ComputeRelativeMargin(param1:DisplayObject, param2:DisplayObject) : Margin
      {
         var _loc3_:Margin = new Margin();
         _loc3_.mLeft = param1.x - param2.x;
         _loc3_.mRight = param2.x + param2.width - (param1.x + param1.width);
         _loc3_.mTop = param1.y - param2.y;
         _loc3_.mBot = param2.y + param2.height - (param1.y + param1.height);
         return _loc3_;
      }
      
      public static function AnchorRight(param1:DisplayObject, param2:DisplayObject, param3:Margin) : void
      {
         param1.x = param2.x + param2.width - (param3.mRight + param1.width);
      }
      
      public static function StretchHorizontally(param1:DisplayObject, param2:DisplayObject, param3:Margin) : void
      {
         param1.x = param2.x + param3.mLeft;
         param1.width = param2.x + param2.width - param3.mRight - param3.mLeft;
      }
      
      public static function StretchVertically(param1:DisplayObject, param2:DisplayObject, param3:Margin) : void
      {
         param1.y = param2.y + param3.mTop;
         param1.height = param2.y + param2.height - param3.mBot - param3.mTop;
      }
      
      public static function StackVertically(param1:DisplayObject, param2:Margin, param3:Point, param4:Boolean = false) : Point
      {
         if(param4)
         {
            param1.x = param3.x + param2.mLeft;
         }
         param1.y = param3.y + param2.mTop;
         return new Point(param3.x,param1.y + param1.height + param2.mBot);
      }
      
      public static function StackMultiple(param1:Array, param2:Margin, param3:Boolean = false, param4:uint = 0, param5:DisplayObjectContainer = null, param6:Point = null, param7:Point = null) : Rectangle
      {
         var _loc14_:DisplayObject = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         if(param6)
         {
            _loc10_ = _loc8_ = param6.x;
            _loc11_ = _loc9_ = param6.y;
         }
         var _loc12_:Rectangle = new Rectangle();
         _loc12_.x = _loc10_;
         _loc12_.y = _loc11_;
         var _loc13_:uint = 0;
         for each(_loc14_ in param1)
         {
            if(param5)
            {
               param5.addChild(_loc14_);
            }
            _loc14_.x = _loc8_ + param2.mLeft;
            _loc14_.y = _loc9_ + param2.mTop;
            _loc13_++;
            _loc15_ = _loc14_.width;
            _loc16_ = _loc14_.height;
            if(param7)
            {
               _loc15_ = param7.x;
               _loc16_ = param7.y;
            }
            if(param3)
            {
               if(param4 > 0 && _loc13_ >= param4)
               {
                  _loc13_ = 0;
                  _loc8_ += param2.Horizontal + _loc15_;
                  _loc9_ = _loc11_;
               }
               else
               {
                  _loc9_ += param2.Vertical + _loc16_;
               }
            }
            else if(param4 > 0 && _loc13_ >= param4)
            {
               _loc13_ = 0;
               _loc8_ = _loc10_;
               _loc9_ += param2.Vertical + _loc16_;
            }
            else
            {
               _loc8_ += param2.Horizontal + _loc15_;
            }
            _loc12_.right = Math.max(_loc12_.right,_loc14_.x + _loc15_ + param2.mRight);
            _loc12_.bottom = Math.max(_loc12_.bottom,_loc14_.y + _loc16_ + param2.mBot);
         }
         return _loc12_;
      }
      
      public static function FindClosestToPoint(param1:Vector.<DisplayObject>, param2:Point) : DisplayObject
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Rectangle = null;
         var _loc7_:IBoundsOverride = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc3_:Number = Number.MAX_VALUE;
         var _loc4_:DisplayObject = null;
         for each(_loc5_ in param1)
         {
            _loc7_ = _loc5_ as IBoundsOverride;
            if(_loc7_)
            {
               _loc6_ = _loc7_.GetBoundsOverride(_loc5_.stage);
            }
            else
            {
               _loc6_ = _loc5_.getBounds(_loc5_.stage);
            }
            _loc8_ = new Point(0,0);
            _loc8_.x = Clamp.Num(param2.x,_loc6_.left,_loc6_.right);
            _loc8_.y = Clamp.Num(param2.y,_loc6_.top,_loc6_.bottom);
            _loc9_ = Geometry.GetLengthSquared(_loc8_.x - param2.x,_loc8_.y - param2.y);
            if(_loc9_ < _loc3_)
            {
               _loc3_ = _loc9_;
               _loc4_ = _loc5_;
            }
         }
         return _loc4_;
      }
      
      public static function IsVisibleInHeirarchy(param1:DisplayObject) : Boolean
      {
         if(param1.stage == null)
         {
            return false;
         }
         var _loc2_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         while(Boolean(_loc2_) && !(_loc2_ is Stage))
         {
            if(!_loc2_.visible)
            {
               return false;
            }
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ != null;
      }
      
      public static function BindDisplayObject(param1:DisplayObject, param2:Vector3D, param3:Point = null, param4:Margin = null) : void
      {
         var _loc6_:Rectangle = null;
         if(param3 == null)
         {
            param3 = new Point();
         }
         var _loc5_:Object = {
            "displayObject":param1,
            "worldOffset":{
               "x":param2.x,
               "y":param2.y,
               "z":param2.z
            },
            "screenOffset":{
               "x":param3.x,
               "y":param3.y
            }
         };
         if(param4)
         {
            _loc6_ = param1.getBounds(param1);
            _loc5_.clampX = {
               "min":param4.mLeft - _loc6_.x,
               "max":param1.stage.stageWidth - _loc6_.x - _loc6_.width - param4.mRight
            };
            _loc5_.clampY = {
               "min":param4.mTop - _loc6_.y,
               "max":param1.stage.stageHeight - _loc6_.y - _loc6_.height - param4.mBot
            };
         }
         CommunicationManager.CallGameService("BindDisplayObject",_loc5_);
      }
      
      public static function UnbindDisplayObject(param1:DisplayObject) : void
      {
         CommunicationManager.CallGameService("UnbindDisplayObject",{"displayObject":param1});
      }
      
      public static function GetVisibleBounds(param1:DisplayObjectContainer) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc4_:DisplayObject = null;
         var _loc6_:Rectangle = null;
         var _loc3_:int = param1.numChildren;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1.getChildAt(_loc5_);
            if(_loc4_.visible)
            {
               _loc6_ = _loc4_.getBounds(param1.stage);
               if(_loc2_)
               {
                  _loc2_ = _loc2_.union(_loc6_);
               }
               else
               {
                  _loc2_ = _loc6_;
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function BestFitToRectangle(param1:DisplayObject, param2:Rectangle, param3:String = "center", param4:String = "center", param5:Number = -Infinity, param6:Number = Infinity) : void
      {
         var _loc7_:Rectangle = new Rectangle(0,0,param1.width / param1.scaleX,param1.height / param1.scaleY);
         var _loc8_:Number = CalculateScaleToFitRectangleToRectangle(_loc7_,param2,param5,param6);
         param1.scaleX = _loc8_;
         param1.scaleY = _loc8_;
         AlignPositionToRectangle(param1,param2,param3,param4);
      }
      
      public static function BestFitObjectInnerAreaToRectangle(param1:DisplayObject, param2:Rectangle, param3:Rectangle, param4:String = "center", param5:String = "center", param6:Number = -Infinity, param7:Number = Infinity) : void
      {
         var _loc12_:Rectangle = null;
         var _loc8_:Rectangle = new Rectangle(param2.x / param1.scaleX,param2.y / param1.scaleY,param2.width / param1.scaleX,param2.height / param1.scaleY);
         var _loc9_:Number = CalculateScaleToFitRectangleToRectangle(_loc8_,param3,param6,param7);
         param1.scaleX = _loc9_;
         param1.scaleY = _loc9_;
         var _loc10_:Number = _loc8_.x * _loc9_;
         var _loc11_:Number = _loc8_.y * _loc9_;
         if(param4 != null && param5 != null)
         {
            _loc12_ = AlignRectangleToRectangle(new Rectangle(_loc10_,_loc11_,_loc8_.width * _loc9_,_loc8_.height * _loc9_),param3,param4,param5);
            param1.x = _loc12_.x - _loc10_;
            param1.y = _loc12_.y - _loc11_;
         }
      }
      
      public static function CalculateScaleToFitRectangleToRectangle(param1:Rectangle, param2:Rectangle, param3:Number = -Infinity, param4:Number = Infinity) : Number
      {
         var _loc5_:Number = param1.width / param1.height;
         var _loc6_:Number = param2.width / param2.height;
         var _loc7_:Number = _loc6_ < _loc5_ ? param2.width / param1.width : param2.height / param1.height;
         if(param3 != Number.NEGATIVE_INFINITY)
         {
            _loc7_ = Math.max(_loc7_,param3);
         }
         if(param4 != Number.POSITIVE_INFINITY)
         {
            _loc7_ = Math.min(_loc7_,param4);
         }
         return _loc7_;
      }
      
      public static function AlignPositionToRectangle(param1:DisplayObject, param2:Rectangle, param3:String, param4:String, param5:Point = null) : void
      {
         var _loc6_:Rectangle = AlignRectangleToRectangle(new Rectangle(param1.x,param1.y,param1.width,param1.height),param2,param3,param4,param5);
         param1.x = _loc6_.x;
         param1.y = _loc6_.y;
      }
      
      public static function AlignRectangleToRectangle(param1:Rectangle, param2:Rectangle, param3:String, param4:String, param5:Point = null) : Rectangle
      {
         switch(param3)
         {
            case Alignment.NONE:
               break;
            case Alignment.LEFT:
               param1.x = param2.left;
               break;
            case Alignment.CENTER:
               param1.x = param2.left + (param2.width - param1.width) * 0.5;
               break;
            case Alignment.RIGHT:
               param1.x = param2.right - param1.width;
               break;
            default:
               Assert.Throw("AlignRectangleToRectange: given xAlignment is not supported");
         }
         switch(param4)
         {
            case Alignment.NONE:
               break;
            case Alignment.TOP:
               param1.y = param2.top;
               break;
            case Alignment.CENTER:
               param1.y = param2.top + (param2.height - param1.height) * 0.5;
               break;
            case Alignment.BOTTOM:
               param1.y = param2.bottom - param1.height;
               break;
            default:
               Assert.Throw("AlignRectangleToRectange: given yAlignment is not supported");
         }
         if(param5)
         {
            param1.x += param5.x;
            param1.y += param5.y;
         }
         return param1;
      }
      
      public static function GetPointOnRectEdge(param1:String, param2:Rectangle) : Point
      {
         switch(param1)
         {
            case Alignment.TOP:
               return new Point(param2.left + param2.width * 0.5,param2.top);
            case Alignment.BOTTOM:
               return new Point(param2.left + param2.width * 0.5,param2.bottom);
            case Alignment.LEFT:
               return new Point(param2.left,param2.top + param2.height * 0.5);
            case Alignment.RIGHT:
               return new Point(param2.right,param2.top + param2.height * 0.5);
            case Alignment.TOP_LEFT:
               return param2.topLeft;
            case Alignment.TOP_RIGHT:
               return new Point(param2.right,param2.top);
            case Alignment.BOTTOM_LEFT:
               return new Point(param2.left,param2.bottom);
            case Alignment:
               return param2.bottomRight;
            case Alignment:
               return new Point(param2.left + param2.width * 0.5,param2.top + param2.height * 0.5);
            default:
               return null;
         }
      }
      
      public static function GetHorizontalPositionOfRectEdge(param1:String, param2:Rectangle) : Number
      {
         switch(param1)
         {
            case Alignment.LEFT:
            case Alignment.TOP_LEFT:
            case Alignment.BOTTOM_LEFT:
               return param2.left;
            case Alignment.RIGHT:
            case Alignment.TOP_RIGHT:
            case Alignment.BOTTOM_RIGHT:
               return param2.right;
            case Alignment.CENTER:
               return param2.left + param2.width * 0.5;
            default:
               return 0;
         }
      }
      
      public static function GetVerticalPositionOfRectEdge(param1:String, param2:Rectangle) : Number
      {
         switch(param1)
         {
            case Alignment.TOP:
            case Alignment.TOP_LEFT:
            case Alignment.TOP_RIGHT:
               return param2.top;
            case Alignment.BOTTOM:
            case Alignment.BOTTOM_LEFT:
            case Alignment:
               return param2.bottom;
            case Alignment.CENTER:
               return param2.top + param2.height * 0.5;
            default:
               return 0;
         }
      }
      
      public static function RemoveAllShapes(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:* = int(param1.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is Shape)
            {
               param1.removeChild(_loc3_);
            }
            _loc2_--;
         }
      }
      
      public static function RemoveChildrenFromParents(param1:Array) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      public static function RemoveAllChildren(param1:DisplayObjectContainer) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function GetChildren(param1:DisplayObjectContainer) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_.push(param1.getChildAt(_loc3_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function SwapOutChild(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:DisplayObjectContainer = param1.parent;
         if(!_loc3_)
         {
            return;
         }
         _loc3_.addChild(param2);
         _loc3_.swapChildren(param1,param2);
         _loc3_.removeChild(param1);
      }
      
      public static function Replicate(param1:DisplayObject, param2:int, param3:Boolean = false) : Array
      {
         var _loc8_:DisplayObject = null;
         var _loc4_:Array = new Array();
         if(param2 > 0)
         {
            _loc4_.push(param1);
         }
         var _loc5_:Class = Object(param1).constructor as Class;
         var _loc6_:Boolean = param1.name.charAt(param1.name.length - 1) != "0";
         var _loc7_:int = 1;
         while(_loc7_ < param2)
         {
            _loc8_ = new _loc5_() as DisplayObject;
            _loc8_.name = _loc6_ ? param1.name + _loc7_.toString() : param1.name.replace("0",_loc7_.toString());
            _loc8_.scaleX = param1.scaleX;
            _loc8_.scaleY = param1.scaleY;
            _loc4_.push(_loc8_);
            if(param3)
            {
               param1.parent.addChild(_loc8_);
            }
            _loc7_++;
         }
         return _loc4_;
      }
   }
}

