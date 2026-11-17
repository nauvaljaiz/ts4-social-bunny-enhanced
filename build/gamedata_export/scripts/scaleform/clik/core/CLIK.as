package scaleform.clik.core
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.gfx.Extensions;
   
   public dynamic class CLIK
   {
      
      public static var stage:Stage;
      
      public static var initialized:Boolean = false;
      
      public static var rendering:Boolean = false;
      
      public function CLIK()
      {
         super();
      }
      
      public static function initialize(param1:Stage, param2:UIComponent) : void
      {
         if(initialized)
         {
            return;
         }
         CLIK.stage = param1;
         Extensions.enabled = true;
         initialized = true;
         FocusHandler.init(param1,param2);
      }
      
      public static function getTargetPathFor(param1:DisplayObjectContainer) : String
      {
         var _loc2_:String = null;
         if(!param1.parent)
         {
            return param1.name;
         }
         _loc2_ = param1.name;
         return getTargetPathImpl(param1.parent as DisplayObjectContainer,_loc2_);
      }
      
      protected static function getTargetPathImpl(param1:DisplayObjectContainer, param2:String = "") : String
      {
         var _loc3_:String = null;
         if(!param1)
         {
            return param2;
         }
         _loc3_ = param1.name ? param1.name + "." : "";
         param2 = _loc3_ + param2;
         return getTargetPathImpl(param1.parent as DisplayObjectContainer,param2);
      }
   }
}

