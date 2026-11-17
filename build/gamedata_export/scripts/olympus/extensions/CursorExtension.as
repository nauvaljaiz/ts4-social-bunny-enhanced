package olympus.extensions
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import olympus.core.cursors.Cursors;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class CursorExtension implements IExtension
   {
      
      protected var mControl:MovieClip;
      
      protected var mCursorOver:String;
      
      protected var mCursorDown:String;
      
      protected var mbCursorSet:Boolean;
      
      public function CursorExtension()
      {
         super();
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(param1 is MovieClip)
         {
            this.mControl = param1 as MovieClip;
            this.mCursorOver = Cursors.BUTTON_OVER;
            this.mCursorDown = Cursors.BUTTON_DOWN;
            this.mControl.addEventListener(MouseEvent.ROLL_OVER,this.OnControlRollOver,false,0,true);
            this.mControl.addEventListener(MouseEvent.ROLL_OUT,this.OnControlRollOut,false,0,true);
            this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnControlRollOut,false,0,true);
            return;
         }
         throw new Error("Cannot apply CursorExtension to non-Movie Clip!");
      }
      
      public function ConfigureCursors(param1:String, param2:String) : void
      {
         var _loc3_:MovieClip = null;
         this.mCursorOver = param1;
         this.mCursorDown = param2;
         _loc3_ = this.mControl;
         var _loc4_:Point = _loc3_.localToGlobal(new Point(_loc3_.mouseX,_loc3_.mouseY));
         if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y,false))
         {
            this.OnControlRollOver();
         }
      }
      
      public function LockCursor() : void
      {
         Cursors.LockCursor(this.mControl,this.mCursorDown);
      }
      
      public function UnlockCursor() : void
      {
         Cursors.UnlockCursor(this.mControl);
      }
      
      protected function OnControlRollOver(param1:Event = null) : void
      {
         if(this.mControl.enabled)
         {
            Cursors.SetCursor(this.mCursorOver);
            this.mbCursorSet = true;
         }
      }
      
      protected function OnControlRollOut(param1:Event) : void
      {
         if(this.mbCursorSet)
         {
            Cursors.SetCursor(null);
            this.mbCursorSet = false;
         }
      }
   }
}

