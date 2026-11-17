package olympus.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import olympus.constants.Layers;
   import olympus.utils.SystemUtils;
   
   public class PopUpManager
   {
      
      protected static var mWidgetPopupCanvas:Layer;
      
      protected static var mAlwaysOnTopPopupCanvas:Layer;
      
      public function PopUpManager()
      {
         super();
      }
      
      public static function Init(param1:Layer, param2:Layer) : void
      {
         mWidgetPopupCanvas = param1;
         mAlwaysOnTopPopupCanvas = param2;
         mWidgetPopupCanvas.mouseEnabled = false;
         mWidgetPopupCanvas.mouseChildren = true;
         mAlwaysOnTopPopupCanvas.mouseEnabled = false;
         mAlwaysOnTopPopupCanvas.mouseChildren = true;
      }
      
      public static function Show(param1:DisplayObject, param2:DisplayObjectContainer = null, param3:Number = 0, param4:Number = 0, param5:int = -1) : void
      {
         var _loc6_:Point = null;
         if(param5 == -1)
         {
            param5 = Layers.WIDGETS_POPUP;
         }
         Add(param1,param5);
         if(param2)
         {
            _loc6_ = new Point(param3,param4);
            _loc6_ = param2.localToGlobal(_loc6_);
            param1.x = _loc6_.x;
            param1.y = _loc6_.y;
         }
      }
      
      public static function MoveToTop(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = MoveToTopOfCanvas(param1,mWidgetPopupCanvas);
         if(!_loc2_)
         {
            MoveToTopOfCanvas(param1,mAlwaysOnTopPopupCanvas);
         }
      }
      
      protected static function MoveToTopOfCanvas(param1:DisplayObject, param2:Sprite) : Boolean
      {
         if(!param2.contains(param1))
         {
            return false;
         }
         param2.setChildIndex(param1,param2.numChildren - 1);
         return true;
      }
      
      protected static function Add(param1:DisplayObject, param2:int) : void
      {
         if(param2 == Layers.WIDGETS_POPUP)
         {
            mWidgetPopupCanvas.addChild(param1);
         }
         else if(param2 == Layers.ALWAYS_ON_TOP_POPUP)
         {
            mAlwaysOnTopPopupCanvas.addChild(param1);
         }
      }
      
      public static function RemoveAllOfClass(param1:Class) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < mWidgetPopupCanvas.numChildren)
         {
            _loc4_ = mWidgetPopupCanvas.getChildAt(_loc3_);
            if(_loc4_ is param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         for each(_loc4_ in _loc2_)
         {
            Remove(_loc4_);
         }
      }
      
      public static function Remove(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = RemoveFromCanvas(param1,mWidgetPopupCanvas);
         if(!_loc2_)
         {
            RemoveFromCanvas(param1,mAlwaysOnTopPopupCanvas);
         }
      }
      
      protected static function RemoveFromCanvas(param1:DisplayObject, param2:Sprite) : Boolean
      {
         if(param2.contains(param1))
         {
            param2.removeChild(param1);
            return true;
         }
         return false;
      }
      
      public static function Contains(param1:DisplayObject) : Boolean
      {
         return mWidgetPopupCanvas.contains(param1) || mAlwaysOnTopPopupCanvas.contains(param1);
      }
      
      public static function Unload() : void
      {
         if(mWidgetPopupCanvas)
         {
            mWidgetPopupCanvas.Clear();
         }
         if(mAlwaysOnTopPopupCanvas)
         {
            mWidgetPopupCanvas.Clear();
         }
      }
      
      public static function StageResized(param1:Number, param2:Number) : void
      {
         if(!SystemUtils.UsingController)
         {
            Unload();
         }
      }
   }
}

