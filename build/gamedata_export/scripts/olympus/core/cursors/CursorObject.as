package olympus.core.cursors
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import scaleform.clik.core.UIComponent;
   
   public class CursorObject
   {
      
      protected var mControl:UIComponent;
      
      protected var mCursorName:String;
      
      protected var mbCursorSet:Boolean = false;
      
      public function CursorObject(param1:UIComponent, param2:String = null)
      {
         super();
         this.mControl = param1;
         this.mCursorName = param2;
         this.mControl.addEventListener(MouseEvent.ROLL_OVER,this.OnControlRollOver,false,0,true);
         this.mControl.addEventListener(MouseEvent.ROLL_OUT,this.OnControlRollOut,false,0,true);
         this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnControlRollOut,false,0,true);
      }
      
      public function get CursorName() : String
      {
         return this.mCursorName;
      }
      
      public function set CursorName(param1:String) : void
      {
         this.mCursorName = param1;
      }
      
      protected function OnControlRollOver(param1:Event) : void
      {
         if(this.mControl.enabled)
         {
            Cursors.SetCursor(this.mCursorName);
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

