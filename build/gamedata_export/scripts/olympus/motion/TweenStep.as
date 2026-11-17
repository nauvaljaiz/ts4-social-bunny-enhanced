package olympus.motion
{
   public final class TweenStep
   {
      
      public var duration:Number = 0;
      
      public var props:Object;
      
      public var delay:Number = 0;
      
      public var ease:Function;
      
      public function TweenStep(param1:Number, param2:Object, param3:Number = 0, param4:Function = null)
      {
         super();
         this.duration = param1;
         this.props = param2;
         this.delay = param3;
         this.ease = param4;
      }
   }
}

