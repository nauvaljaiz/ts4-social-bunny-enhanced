package olympus.gamepad
{
   import flash.display.Stage;
   import flash.geom.Point;
   import olympus.core.LayoutManager;
   import olympus.core.widget.WidgetBase;
   
   public class LayoutAPI
   {
      
      public static var mLayoutMgr:LayoutManager;
      
      public function LayoutAPI()
      {
         super();
      }
      
      public static function SetManager(param1:LayoutManager) : *
      {
         if(mLayoutMgr == null)
         {
            mLayoutMgr = param1;
         }
      }
      
      public static function GetLoadedWidgetByName(param1:String) : WidgetBase
      {
         return mLayoutMgr.GetLoadedWidgetByName(param1);
      }
      
      public static function GetStage() : Stage
      {
         return mLayoutMgr.GetStage();
      }
      
      public static function GetStageSize(param1:Boolean = false) : Point
      {
         return mLayoutMgr.GetStageSize(param1);
      }
      
      public static function get StageWidth() : int
      {
         return mLayoutMgr.StageWidth;
      }
      
      public static function get StageHeight() : int
      {
         return mLayoutMgr.StageHeight;
      }
      
      public static function get ScreenMargin() : Point
      {
         var _loc1_:Point = new Point();
         var _loc2_:Point = mLayoutMgr.GetScreenMarginPcts();
         var _loc3_:Point = GetStageSize(true);
         _loc1_.x = _loc2_.x * _loc3_.x;
         _loc1_.y = _loc2_.y * _loc3_.y;
         return _loc1_;
      }
      
      public static function get ScreenSafeAreaRatio() : Point
      {
         var _loc1_:Point = GetStageSize(true);
         return new Point(StageWidth / _loc1_.x,LayoutAPI.StageHeight / _loc1_.y);
      }
      
      public static function IsLockCursorVisible() : Boolean
      {
         return mLayoutMgr.IsLockCursorVisible();
      }
   }
}

