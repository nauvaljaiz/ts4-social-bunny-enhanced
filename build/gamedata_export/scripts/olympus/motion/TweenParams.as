package olympus.motion
{
   public class TweenParams
   {
      
      protected var mEase:Function;
      
      protected var mDuration:Number = 0;
      
      protected var mDelay:Number = 0;
      
      protected var mStartProps:Object;
      
      protected var mEndProps:Object;
      
      protected var mPrevStep:TweenParams;
      
      protected var mNextStep:TweenParams;
      
      protected var mbGameSpeedDependent:Boolean = false;
      
      protected var mbAllowZeroGameSpeed:Boolean = false;
      
      protected var mTweenAudio:TweenAudio;
      
      public function TweenParams()
      {
         super();
      }
      
      public static function TweenParam() : TweenParams
      {
         return new TweenParams();
      }
      
      public function get ease() : Function
      {
         return this.mEase;
      }
      
      public function get duration() : Number
      {
         return this.mDuration;
      }
      
      public function get totalDuration() : Number
      {
         var _loc1_:Number = this.mDelay + this.mDuration;
         var _loc2_:TweenParams = this.mNextStep;
         while(_loc2_)
         {
            _loc1_ += _loc2_.delay;
            _loc1_ += _loc2_.duration;
            _loc2_ = _loc2_.mNextStep;
         }
         return _loc1_;
      }
      
      public function get delay() : Number
      {
         return this.mDelay;
      }
      
      public function get gameSpeedDependent() : Boolean
      {
         return this.mbGameSpeedDependent;
      }
      
      public function get allowZeroGameSpeed() : Boolean
      {
         return this.mbAllowZeroGameSpeed;
      }
      
      public function get startProps() : Object
      {
         return this.mStartProps;
      }
      
      public function get endProps() : Object
      {
         return this.mEndProps;
      }
      
      public function get prevStep() : TweenParams
      {
         return this.mPrevStep;
      }
      
      public function get nextStep() : TweenParams
      {
         return this.mNextStep;
      }
      
      public function get audio() : TweenAudio
      {
         return this.mTweenAudio;
      }
      
      public function Ease(param1:Function) : TweenParams
      {
         this.mEase = param1;
         return this;
      }
      
      public function Duration(param1:Number) : TweenParams
      {
         this.mDuration = param1;
         return this;
      }
      
      public function Delay(param1:Number) : TweenParams
      {
         this.mDelay = param1;
         return this;
      }
      
      public function GameSpeedDependent(param1:Boolean, param2:Boolean = false) : TweenParams
      {
         this.mbGameSpeedDependent = param1;
         this.mbAllowZeroGameSpeed = param2;
         return this;
      }
      
      public function StartProps(param1:Object) : TweenParams
      {
         this.mStartProps = param1;
         return this;
      }
      
      public function EndProps(param1:Object) : TweenParams
      {
         this.mEndProps = param1;
         return this;
      }
      
      public function AddStep() : TweenParams
      {
         var _loc1_:TweenParams = new TweenParams();
         _loc1_.mPrevStep = this;
         return _loc1_;
      }
      
      public function AudioStyleName(param1:String) : TweenParams
      {
         this.GetTweenAudio().styleName = param1;
         return this;
      }
      
      public function AudioTargetName(param1:String) : TweenParams
      {
         this.GetTweenAudio().targetName = param1;
         return this;
      }
      
      public function Done() : TweenParams
      {
         var _loc1_:TweenParams = this;
         while(_loc1_.mPrevStep)
         {
            _loc1_.mPrevStep.mNextStep = _loc1_;
            _loc1_ = _loc1_.mPrevStep;
         }
         return _loc1_;
      }
      
      protected function GetTweenAudio() : TweenAudio
      {
         if(!this.mTweenAudio)
         {
            this.mTweenAudio = new TweenAudio();
         }
         return this.mTweenAudio;
      }
   }
}

