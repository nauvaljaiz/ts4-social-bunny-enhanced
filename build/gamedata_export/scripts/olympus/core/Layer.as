package olympus.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import olympus.core.widget.WidgetLoader;
   
   public final class Layer extends Sprite
   {
      
      public var isLayer:Boolean = true;
      
      public function Layer()
      {
         super();
      }
      
      public function Clear() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(numChildren > _loc1_)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is WidgetLoader)
            {
               _loc1_++;
            }
            else
            {
               removeChildAt(_loc1_);
            }
         }
      }
   }
}

