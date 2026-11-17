package olympus.core.widget
{
   import flash.display.Loader;
   
   public final class WidgetLoader extends Loader
   {
      
      public var mName:String;
      
      public var mTelemetryName:String;
      
      public var mLayerProps:LayerProps;
      
      public var mVerticalPositionPercent:Number = 0;
      
      public var mHorizontalPositionPercent:Number = 0;
      
      public var mVerticalOriginPercent:Number = 0;
      
      public var mHorizontalOriginPercent:Number = 0;
      
      public var mGameStateMap:Object;
      
      public var mbOnDemandLoad:Boolean;
      
      public var mOnDemandMinTimeBeforeUnload:int = 0;
      
      public var mbDebugging:Boolean;
      
      public var mMargins:Margin;
      
      public var mbUseScreenMarginBackground:Boolean;
      
      public var mbShouldHashName:Boolean;
      
      public var mNameHash:String;
      
      public function WidgetLoader(param1:String, param2:String, param3:LayerProps, param4:Boolean = false)
      {
         super();
         this.mName = param1;
         this.mTelemetryName = param2;
         this.mbOnDemandLoad = param4;
         this.mLayerProps = param3;
         this.mouseEnabled = false;
         this.name = param1 + "Loader";
         this.mMargins = new Margin(0);
      }
      
      public function GetWidget() : WidgetBase
      {
         var _loc1_:WidgetBase = content as WidgetBase;
         if(!_loc1_ && Boolean(content["widget"]))
         {
            _loc1_ = content["widget"] as WidgetBase;
         }
         return _loc1_;
      }
      
      public function GetGameStateSettings(param1:uint) : WidgetGameState
      {
         if(this.mGameStateMap)
         {
            return this.mGameStateMap[param1];
         }
         return null;
      }
      
      public function GetExistanceInGameState(param1:uint) : Boolean
      {
         if(this.mGameStateMap)
         {
            return this.mGameStateMap[param1] != null;
         }
         return false;
      }
      
      public function GetVisibilityInGameState(param1:uint) : Boolean
      {
         if(this.mGameStateMap)
         {
            return this.mGameStateMap[param1].mVisibility;
         }
         return true;
      }
      
      public function GetPriorityInGameState(param1:uint) : int
      {
         if(this.mGameStateMap)
         {
            return this.mGameStateMap[param1].mPriority;
         }
         return 0;
      }
   }
}

