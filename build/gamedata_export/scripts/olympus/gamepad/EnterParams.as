package olympus.gamepad
{
   import flash.geom.Point;
   
   public class EnterParams
   {
      
      public var mDirection:uint;
      
      public var mFromPos:Point;
      
      public var mArgs:Object;
      
      public function EnterParams(param1:uint = 1, param2:Point = null, param3:Object = null)
      {
         super();
         this.mDirection = param1 == -1 ? NavDirection.FORWARD : param1;
         this.mFromPos = param2;
         this.mArgs = param3;
      }
   }
}

