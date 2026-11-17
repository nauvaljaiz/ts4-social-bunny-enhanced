package olympus.motion
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.audio.Audio;
   import olympus.core.Ticker;
   import olympus.core.interfaces.IBase;
   import olympus.events.TickerEvent;
   import olympus.events.TweenEvent;
   import olympus.utils.DisplayObjectUtils;
   
   public class Tween extends EventDispatcher
   {
      
      protected static var firstTween:Tween;
      
      protected static var lastTween:Tween;
      
      protected static var ticker:Shape = new Shape();
      
      Ticker.Add(ticker,0,Tween.Tick);
      
      public var loop:Boolean = false;
      
      public var registeredLabel:String;
      
      public var mbGameSpeedDependent:Boolean;
      
      public var mbAllowZeroGameSpeed:Boolean;
      
      protected var target:DisplayObject;
      
      protected var next:Tween;
      
      protected var prev:Tween;
      
      protected var _position:Number = 0;
      
      protected var _paused:Boolean = true;
      
      protected var curStep:int = 0;
      
      protected var steps:Vector.<TweenStep> = new Vector.<TweenStep>();
      
      protected var eventType:String = "Unknown";
      
      protected var mCurStep:TweenStep;
      
      protected var mDeltaMatrix:Matrix;
      
      protected var mStartMatrix:Matrix;
      
      protected var mbUseScale:Boolean = true;
      
      protected var mTweenAudio:TweenAudio;
      
      public function Tween(param1:Number, param2:DisplayObject, param3:Object = null, param4:Number = 0, param5:Function = null, param6:Boolean = false, param7:Boolean = false)
      {
         super();
         this.target = param2;
         this.mbGameSpeedDependent = param6;
         this.mbAllowZeroGameSpeed = param7;
         this.steps.push(new TweenStep(param1,param3,param4,param5));
      }
      
      protected static function Tick(param1:TickerEvent) : void
      {
         var _loc2_:Tween = firstTween;
         while(_loc2_)
         {
            if(_loc2_.mbGameSpeedDependent)
            {
               if(!_loc2_.mbAllowZeroGameSpeed && param1.deltaTimeGameSpeed == 0)
               {
                  _loc2_.updatePosition(param1.deltaTime);
               }
               else
               {
                  _loc2_.updatePosition(param1.deltaTimeGameSpeed);
               }
            }
            else
            {
               _loc2_.updatePosition(param1.deltaTime);
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      protected static function RemoveTween(param1:Tween) : void
      {
         if(param1.prev)
         {
            param1.prev.next = param1.next;
         }
         if(param1.next)
         {
            param1.next.prev = param1.prev;
         }
         if(param1 == firstTween)
         {
            firstTween = param1.next;
         }
         if(param1 == lastTween)
         {
            lastTween = param1.prev;
         }
         param1.next = null;
         param1.prev = null;
      }
      
      public static function CreateFromParams(param1:TweenParams, param2:DisplayObject, param3:Object = null, param4:Number = NaN) : Tween
      {
         if(!param1.duration)
         {
            throw ArgumentError("TweenParams must contain a duration");
         }
         if(param1.prevStep)
         {
            throw ArgumentError("TweenParams provided has a previous step defined!\n" + "Did you forget to call Done after defining all the steps?");
         }
         if(Boolean(param3) && Boolean(param1.nextStep))
         {
            throw ArgumentError("overrideProps cannot be used with multi-step tweens!");
         }
         var _loc5_:Tween = new Tween(param1.duration,param2,param3 ? param3 : param1.endProps,isNaN(param4) ? param1.delay : param4,param1.ease,param1.gameSpeedDependent,param1.allowZeroGameSpeed);
         var _loc6_:TweenParams = param1;
         while(true)
         {
            _loc6_ = _loc6_.nextStep;
            if(!_loc6_)
            {
               break;
            }
            _loc5_.AddStep(_loc6_.duration,_loc6_.endProps,_loc6_.duration,_loc6_.ease);
         }
         _loc5_.mTweenAudio = param1.audio;
         return _loc5_;
      }
      
      public static function AnimateClip(param1:int, param2:TweenParams, param3:DisplayObject, param4:Rectangle = null, param5:Point = null) : Tween
      {
         var _loc6_:Tween = null;
         var _loc16_:Point = null;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:TweenParams = param2;
         var _loc9_:Number = param3.scaleX;
         var _loc10_:Number = param3.scaleY;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Point = new Point();
         var _loc14_:Point = new Point();
         var _loc15_:Point = new Point();
         var _loc17_:Object = _loc8_.startProps;
         if(param4)
         {
            if(!param5)
            {
               param5 = new Point(0.5,0.5);
            }
            _loc13_.x = param4.topLeft.x + param4.width * param5.x;
            _loc13_.y = param4.topLeft.y + param4.height * param5.y;
            if(_loc17_["scaleX"] != null)
            {
               _loc11_ = Number(_loc17_["scaleX"]);
               _loc14_.x = _loc13_.x - (_loc13_.x - param3.x) * _loc11_;
            }
            if(_loc17_["scaleY"] != null)
            {
               _loc12_ = Number(_loc17_["scaleY"]);
               _loc14_.y = _loc13_.y - (_loc13_.y - param3.y) * _loc12_;
            }
         }
         do
         {
            _loc18_ = _loc8_.endProps;
            _loc9_ = _loc18_["scaleX"] ? Number(_loc18_["scaleX"]) : NaN;
            _loc10_ = _loc18_["scaleY"] ? Number(_loc18_["scaleY"]) : NaN;
            if(param4)
            {
               if(!isNaN(_loc9_))
               {
                  _loc15_.x = _loc13_.x - (_loc13_.x - param3.x) * _loc9_;
               }
               else if(_loc16_)
               {
                  _loc15_.x = _loc16_.x;
               }
               else
               {
                  _loc15_.x = _loc14_.x;
               }
               if(!isNaN(_loc10_))
               {
                  _loc15_.y = _loc13_.y - (_loc13_.y - param3.y) * _loc10_;
               }
               else if(_loc16_)
               {
                  _loc15_.y = _loc16_.y;
               }
               else
               {
                  _loc15_.y = _loc14_.y;
               }
            }
            _loc19_ = {
               "x":_loc15_.x,
               "y":_loc15_.y,
               "scaleX":_loc9_,
               "scaleY":_loc10_,
               "alpha":_loc18_["alpha"],
               "rotation":_loc18_["rotation"]
            };
            if(_loc7_ == 0)
            {
               _loc6_ = new Tween(_loc8_.duration,param3,_loc19_,param1 + param2.delay,param2.ease,param2.gameSpeedDependent);
            }
            else
            {
               _loc6_.AddStep(_loc8_.duration,_loc19_,_loc8_.duration,_loc8_.ease);
            }
            _loc16_ = _loc15_.clone();
            _loc7_++;
         }
         while(_loc8_ = _loc8_.nextStep, _loc8_);
         _loc6_.mTweenAudio = param2.audio;
         _loc6_.Start({
            "x":_loc14_.x,
            "y":_loc14_.y,
            "alpha":_loc17_["alpha"],
            "scaleX":(isNaN(_loc11_) ? null : _loc11_),
            "scaleY":(isNaN(_loc12_) ? null : _loc12_),
            "rotation":_loc17_["rotation"]
         });
         return _loc6_;
      }
      
      public static function removeAllTweens() : void
      {
         firstTween = null;
         lastTween = null;
      }
      
      public static function QuickAnimation(param1:int, param2:Number, param3:DisplayObject, param4:Number = 0, param5:Function = null) : Tween
      {
         var _loc6_:String = null;
         var _loc7_:Object = new Object();
         switch(param1)
         {
            case Animation.FADE_IN:
               _loc7_.alpha = 1;
               _loc6_ = Audio.TWEEN_FADE_IN;
               break;
            case Animation.FADE_OUT:
               _loc7_.alpha = 0;
               _loc6_ = Audio.TWEEN_FADE_OUT;
               break;
            case Animation.FADE_OUT_SCALE_DOWN:
               _loc7_.alpha = 0;
               _loc7_.scaleX = 0;
               _loc7_.scaleY = 0;
               _loc6_ = Audio.TWEEN_FADE_OUT_SCALE_DOWN;
               break;
            case Animation.SCALE_DOWN:
               _loc7_.scaleX = 0;
               _loc7_.scaleY = 0;
               _loc6_ = Audio.TWEEN_SCALE_DOWN;
               break;
            case Animation.FADE_IN_SCALE_UP:
               _loc7_.alpha = 1;
               _loc7_.scaleX = 1;
               _loc7_.scaleY = 1;
               _loc6_ = Audio.TWEEN_FADE_IN_SCALE_UP;
               break;
            case Animation.SCALE_UP:
               _loc7_.scaleX = 1;
               _loc7_.scaleY = 1;
               _loc6_ = Audio.TWEEN_SCALE_UP;
               break;
            default:
               return null;
         }
         var _loc8_:Tween = new Tween(param2,param3,_loc7_,param4,param5);
         _loc8_.audio.styleName = _loc6_;
         return _loc8_;
      }
      
      public static function StopAllTweens(param1:Object, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:Tween = null;
         var _loc4_:Tween = firstTween;
         while(_loc4_)
         {
            _loc5_ = _loc4_.next;
            if(_loc4_.target == param1)
            {
               _loc4_.Stop(param2,param3);
               if(param2 && !param3)
               {
                  _loc4_.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_COMPLETE));
               }
               RemoveTween(_loc4_);
            }
            _loc4_ = _loc5_;
         }
      }
      
      public static function KillAllTweensForLabel(param1:String) : void
      {
         var _loc3_:Tween = null;
         var _loc2_:Tween = firstTween;
         while(_loc2_)
         {
            _loc3_ = _loc2_.next;
            if(_loc2_.registeredLabel == param1)
            {
               RemoveTween(_loc2_);
            }
            _loc2_ = _loc3_;
         }
      }
      
      public function get Target() : DisplayObject
      {
         return this.target;
      }
      
      public function set Target(param1:DisplayObject) : void
      {
         this.target = param1;
      }
      
      public function get audio() : TweenAudio
      {
         if(!this.mTweenAudio)
         {
            this.mTweenAudio = new TweenAudio();
         }
         return this.mTweenAudio;
      }
      
      public function set EventType(param1:String) : void
      {
         this.eventType = param1;
      }
      
      public function set position(param1:Number) : void
      {
         this.updatePosition(param1 + this.mCurStep.delay - this._position);
      }
      
      public function get position() : Number
      {
         return this._position - this.steps[this.curStep].delay;
      }
      
      public function IsActive() : Boolean
      {
         return !this.paused;
      }
      
      public function ChangeDelay(param1:int, param2:int = 0) : void
      {
         if(this.steps.length <= param2)
         {
            return;
         }
         this.steps[param2].delay = param1;
      }
      
      public function ChangeStepProps(param1:Object, param2:int = 0) : void
      {
         if(this.steps.length <= param2)
         {
            return;
         }
         this.steps[param2].props = param1;
      }
      
      protected function get paused() : Boolean
      {
         return this._paused;
      }
      
      protected function set paused(param1:Boolean) : void
      {
         if(param1 == this._paused)
         {
            return;
         }
         this._paused = param1;
         if(param1)
         {
            RemoveTween(this);
         }
         else
         {
            if(lastTween)
            {
               lastTween.next = this;
               this.prev = lastTween;
            }
            else
            {
               firstTween = this;
            }
            lastTween = this;
         }
      }
      
      protected function init(param1:Object = null, param2:Object = null) : void
      {
         var _loc7_:IBase = null;
         if(!this.registeredLabel)
         {
            _loc7_ = DisplayObjectUtils.GetParentClass(this.target,IBase) as IBase;
            if(_loc7_)
            {
               this.registeredLabel = _loc7_.BaseName;
            }
            else
            {
               this.registeredLabel = "UNKNOWN";
            }
         }
         this._position = 0;
         this.mCurStep = this.steps[this.curStep];
         var _loc3_:Object = param2 ? param2 : this.mCurStep.props;
         var _loc4_:DisplayObject = this.target;
         this.mbUseScale = !("width" in _loc3_ || "height" in _loc3_);
         var _loc5_:Matrix = param1 ? new Matrix(this.mbUseScale ? (isNaN(param1.scaleX) ? _loc4_.scaleX : Number(param1.scaleX)) : (isNaN(param1.width) ? _loc4_.width : Number(param1.width)),isNaN(param1.rotation) ? _loc4_.rotation : Number(param1.rotation),isNaN(param1.alpha) ? _loc4_.alpha : Number(param1.alpha),this.mbUseScale ? (isNaN(param1.scaleY) ? _loc4_.scaleY : Number(param1.scaleY)) : (isNaN(param1.height) ? _loc4_.height : Number(param1.height)),isNaN(param1.x) ? _loc4_.x : Number(param1.x),isNaN(param1.y) ? _loc4_.y : Number(param1.y)) : new Matrix(this.mbUseScale ? _loc4_.scaleX : _loc4_.width,_loc4_.rotation,_loc4_.alpha,this.mbUseScale ? _loc4_.scaleY : _loc4_.height,_loc4_.x,_loc4_.y);
         var _loc6_:Matrix = new Matrix(this.mbUseScale ? (isNaN(_loc3_.scaleX) ? 0 : _loc3_.scaleX - _loc5_.a) : (isNaN(_loc3_.width) ? 0 : _loc3_.width - _loc5_.a),isNaN(_loc3_.rotation) ? 0 : _loc3_.rotation - _loc5_.b,isNaN(_loc3_.alpha) ? 0 : _loc3_.alpha - _loc5_.c,this.mbUseScale ? (isNaN(_loc3_.scaleY) ? 0 : _loc3_.scaleY - _loc5_.d) : (isNaN(_loc3_.height) ? 0 : _loc3_.height - _loc5_.d),isNaN(_loc3_.x) ? 0 : _loc3_.x - _loc5_.tx,isNaN(_loc3_.y) ? 0 : _loc3_.y - _loc5_.ty);
         if(_loc6_.a != 0)
         {
            if(this.mbUseScale)
            {
               _loc4_.scaleX = _loc5_.a;
            }
            else
            {
               _loc4_.width = _loc5_.a;
            }
         }
         if(_loc6_.d != 0)
         {
            if(this.mbUseScale)
            {
               _loc4_.scaleY = _loc5_.d;
            }
            else
            {
               _loc4_.height = _loc5_.d;
            }
         }
         if(_loc6_.b != 0)
         {
            _loc4_.rotation = _loc5_.b;
         }
         if(_loc6_.c != 0)
         {
            _loc4_.alpha = _loc5_.c;
            _loc4_.visible = true;
         }
         if(_loc6_.tx != 0)
         {
            _loc4_.x = _loc5_.tx;
         }
         if(_loc6_.ty != 0)
         {
            _loc4_.y = _loc5_.ty;
         }
         this.mStartMatrix = _loc5_;
         this.mDeltaMatrix = _loc6_;
      }
      
      protected function updatePosition(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         this._position += param1;
         var _loc2_:TweenStep = this.mCurStep;
         if(this._position <= _loc2_.delay)
         {
            return;
         }
         var _loc3_:Number = 0;
         _loc4_ = (this._position - _loc2_.delay) / _loc2_.duration;
         var _loc5_:Boolean = _loc4_ >= 1;
         if(_loc5_)
         {
            _loc3_ = this._position - _loc2_.delay - _loc2_.duration;
            _loc4_ = 1;
         }
         else if(_loc2_.ease != null)
         {
            _loc4_ = _loc2_.ease(_loc4_,0,1,1);
         }
         else if(_loc4_ > 1)
         {
            _loc4_ = 1;
         }
         var _loc6_:Matrix = this.mDeltaMatrix;
         var _loc7_:Matrix = this.mStartMatrix;
         var _loc8_:DisplayObject = this.target;
         if(_loc6_.a != 0)
         {
            if(this.mbUseScale)
            {
               _loc8_.scaleX = _loc7_.a + _loc6_.a * _loc4_;
            }
            else
            {
               _loc8_.width = _loc7_.a + _loc6_.a * _loc4_;
            }
         }
         if(_loc6_.d != 0)
         {
            if(this.mbUseScale)
            {
               _loc8_.scaleY = _loc7_.d + _loc6_.d * _loc4_;
            }
            else
            {
               _loc8_.height = _loc7_.d + _loc6_.d * _loc4_;
            }
         }
         if(_loc6_.b != 0)
         {
            _loc8_.rotation = _loc7_.b + _loc6_.b * _loc4_;
         }
         if(_loc6_.c != 0)
         {
            _loc8_.alpha = _loc7_.c + _loc6_.c * _loc4_;
         }
         if(_loc6_.tx != 0)
         {
            _loc8_.x = _loc7_.tx + _loc6_.tx * _loc4_;
         }
         if(_loc6_.ty != 0)
         {
            _loc8_.y = _loc7_.ty + _loc6_.ty * _loc4_;
         }
         if(_loc5_)
         {
            if(this.curStep >= this.steps.length - 1)
            {
               if(_loc8_.alpha == 0)
               {
                  _loc8_.visible = false;
               }
               this.paused = true;
               if(this.loop)
               {
                  this.paused = false;
               }
               if(this.mTweenAudio)
               {
                  this.mTweenAudio.DispatchEnd(this.target);
               }
               dispatchEvent(new TweenEvent(TweenEvent.TWEEN_COMPLETE));
            }
            else
            {
               dispatchEvent(new TweenEvent(TweenEvent.TWEEN_STEP_COMPLETE));
               ++this.curStep;
               this.init();
               if(_loc3_ > 0)
               {
                  this.updatePosition(_loc3_);
               }
            }
         }
      }
      
      public function Start(param1:Object = null) : void
      {
         this.curStep = 0;
         this.init(param1);
         if(this.mTweenAudio)
         {
            this.mTweenAudio.DispatchStart(this.target);
         }
         this.paused = false;
      }
      
      public function Stop(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TweenStep = null;
         if(!this.paused)
         {
            if(param1 && !param2)
            {
               if(this.mTweenAudio)
               {
                  this.mTweenAudio.DispatchEnd(this.target);
               }
            }
            this.paused = true;
            if(param2)
            {
               _loc3_ = int(this.steps.length);
               _loc4_ = this.curStep;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this.steps[_loc4_];
                  this.position = _loc5_.duration;
                  _loc4_++;
               }
            }
         }
         this._position = 0;
      }
      
      public function Pause() : void
      {
         this.paused = true;
      }
      
      public function Play() : void
      {
         if(this.mCurStep)
         {
            this.paused = false;
         }
         else
         {
            this.Start();
         }
      }
      
      public function AddStep(param1:Number, param2:Object = null, param3:Number = 0, param4:Function = null) : void
      {
         this.steps.push(new TweenStep(param1,param2,param3,param4));
      }
   }
}

