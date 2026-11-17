package olympus.core.widget
{
   public final class WidgetGameState
   {
      
      public var mGameState:uint;
      
      public var mVisibility:Boolean;
      
      public var mPriority:int;
      
      public var mDefinedPosition:Boolean;
      
      public var mVerticalPositionPercent:Number = 0;
      
      public var mHorizontalPositionPercent:Number = 0;
      
      public var mVerticalOriginPercent:Number = 0;
      
      public var mHorizontalOriginPercent:Number = 0;
      
      public function WidgetGameState(param1:uint = 1, param2:Boolean = true, param3:Number = -1, param4:Number = -1, param5:Number = -1, param6:Number = -1)
      {
         super();
         this.mGameState = param1;
         this.mVisibility = param2;
         if(param3 == -1 && param4 == -1 && param5 == -1 && param6 == -1)
         {
            this.mDefinedPosition = false;
         }
         else
         {
            this.mDefinedPosition = true;
            this.mVerticalPositionPercent = param3 != -1 ? param3 : 0;
            this.mHorizontalPositionPercent = param4 != -1 ? param4 : 0;
            this.mVerticalOriginPercent = param5 != -1 ? param5 : 0;
            this.mHorizontalOriginPercent = param6 != -1 ? param6 : 0;
         }
         this.mPriority = -1;
      }
   }
}

