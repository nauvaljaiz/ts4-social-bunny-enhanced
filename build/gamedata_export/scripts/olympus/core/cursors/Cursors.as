package olympus.core.cursors
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class Cursors
   {
      
      public static const ARROW:String = "10582293388888934420";
      
      public static const HAND:String = "17392952883237192434";
      
      public static const IBEAM:String = "2152379235043999383";
      
      public static const BUTTON_OVER:String = "7825986384460914974";
      
      public static const BUTTON_DOWN:String = "815675067175920852";
      
      public static const HAND_OPEN:String = "16551226971942950541";
      
      public static const HAND_CLOSED:String = "11687588188357872021";
      
      public static const EXCHANGE_REPORT_CONTENT:String = "1385375670217206769";
      
      public static const ARROW_INTERACTABLE:String = "13125574271591687701";
      
      public static const HAND_OPEN_INTERACTABLE:String = "12935854692928009830";
      
      public static const HAND_CLOSED_INVALID:String = "12933378511900959033";
      
      public static const ARROW_COMPOSITE:String = "6090876493839096152";
      
      public static const CURSOR_COMPOSITE:String = "11934519926313727559";
      
      public static const PENCIL_ICON:String = "9227694614130262078";
      
      public static const IMAGE_ZOOM_IN:String = "6769946558794774472";
      
      protected static var sCurrentCursor:String = null;
      
      protected static var sCurrentLockedCursor:String = null;
      
      protected static var sLockOwner:DisplayObject = null;
      
      public static var sLastVirtualCursor:String = "arrow";
      
      public static function SetCursorFunction(param1:String):void
      {
      }
      public static function SetCursorPositionFunction(param1:Number, param2:Number):void
      {
      }
      public static function CompositeCursorFunction(param1:String, param2:String):void
      {
      }
      public function Cursors()
      {
         super();
      }
      
      public static function get IsCursorLocked() : Boolean
      {
         return sCurrentLockedCursor != null;
      }
      
      public static function IsCursorLockedBy(param1:DisplayObject) : Boolean
      {
         return IsCursorLocked && sLockOwner == param1;
      }
      
      public static function SetCursor(param1:String) : Boolean
      {
         if(IsCursorLocked)
         {
            sCurrentCursor = param1;
            return false;
         }
         if(sCurrentCursor != param1)
         {
            sCurrentCursor = param1;
            SetCursorFunction(sCurrentCursor);
         }
         return true;
      }
      
      public static function SetCursorPosition(param1:Number, param2:Number) : void
      {
         SetCursorPositionFunction(param1,param2);
      }
      
      public static function SetupCompositeCursor(param1:String, param2:String) : void
      {
         CompositeCursorFunction(param1,param2);
      }
      
      public static function LockCursor(param1:DisplayObject, param2:String) : Boolean
      {
         if(Boolean(!IsCursorLocked) && Boolean(param1) && Boolean(param1.stage))
         {
            sCurrentLockedCursor = param2;
            SetCursorFunction(sCurrentLockedCursor);
            sLockOwner = param1;
            param1.addEventListener(Event.REMOVED_FROM_STAGE,OnLockedRemovedFromStage,false,0,true);
            return true;
         }
         return false;
      }
      
      public static function UnlockCursor(param1:DisplayObject) : void
      {
         if(IsCursorLocked && sLockOwner == param1)
         {
            sCurrentLockedCursor = null;
            SetCursorFunction(sCurrentCursor);
            sLockOwner = null;
            param1.removeEventListener(Event.REMOVED_FROM_STAGE,OnLockedRemovedFromStage);
         }
      }
      
      public static function OnLockedRemovedFromStage(param1:Event) : void
      {
         UnlockCursor(param1.target as DisplayObject);
      }
   }
}

