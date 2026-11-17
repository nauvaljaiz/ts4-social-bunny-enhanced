package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class MouseWheelExtension implements IExtension
   {
      
      protected var mScrollWheelCallback:Function;
      
      public function MouseWheelExtension()
      {
         super();
      }
      
      public function Extend(param1:IExtendable) : void
      {
      }
      
      public function SetCaptureZone(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            param1.addEventListener(MouseEvent.ROLL_OVER,this.OnCaptureZoneRollOver,false,0,true);
            param1.addEventListener(MouseEvent.ROLL_OUT,this.OnCaptureZoneRollOut,false,0,true);
         }
      }
      
      public function SetCallback(param1:Function) : void
      {
         this.mScrollWheelCallback = param1;
      }
      
      protected function OnCaptureZoneRollOver(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         _loc2_.addEventListener(MouseEvent.MOUSE_WHEEL,this.OnCaptureZoneMouseWheel,false,0,true);
      }
      
      protected function OnCaptureZoneRollOut(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         _loc2_.removeEventListener(MouseEvent.MOUSE_WHEEL,this.OnCaptureZoneMouseWheel);
      }
      
      protected function OnCaptureZoneMouseWheel(param1:MouseEvent) : void
      {
         this.mScrollWheelCallback(param1);
      }
   }
}

