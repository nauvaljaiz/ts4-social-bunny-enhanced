package olympus.utils
{
   import flash.events.MouseEvent;
   import olympus.io.CommunicationManager;
   import scaleform.gfx.MouseEventEx;
   
   public final class InputUtils
   {
      
      public static var sMouseX:Number;
      
      public static var sMouseY:Number;
      
      public static const LEFT_BUTTON:uint = 1 << MouseEventEx.LEFT_BUTTON;
      
      public static const RIGHT_BUTTON:uint = 1 << MouseEventEx.RIGHT_BUTTON;
      
      public static const MIDDLE_BUTTON:uint = 1 << MouseEventEx.MIDDLE_BUTTON;
      
      public function InputUtils()
      {
         super();
      }
      
      public static function IsLeftMouseButton(param1:MouseEvent) : Boolean
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         return Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON;
      }
      
      public static function IsRightMouseButton(param1:MouseEvent) : Boolean
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         return Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON;
      }
      
      public static function IsButtonAllowed(param1:MouseEvent, param2:uint) : Boolean
      {
         var _loc3_:MouseEventEx = param1 as MouseEventEx;
         return Boolean(_loc3_) && Boolean(1 << _loc3_.buttonIdx & param2);
      }
      
      public static function GetButtonIndex(param1:MouseEvent) : uint
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         return _loc2_ ? _loc2_.buttonIdx : 0;
      }
      
      public static function SetVirtualCursorPosition(param1:Number, param2:Number) : void
      {
         InputUtils.sMouseX = param1;
         InputUtils.sMouseY = param2;
         CommunicationManager.SendUIMessage("VirtualCursorMove",[param1,param2]);
      }
   }
}

