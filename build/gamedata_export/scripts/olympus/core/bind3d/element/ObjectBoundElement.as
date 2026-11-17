package olympus.core.bind3d.element
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import olympus.core.bind3d.io.ElementMessageMap;
   import olympus.core.bind3d.io.IElementCommunication;
   import olympus.core.interfaces.IBase;
   import olympus.io.CommunicationManager;
   import olympus.motion.Tween;
   import olympus.utils.DebugUtils;
   
   public class ObjectBoundElement extends MovieClip implements IBase
   {
      
      public static const INACTIVE_DESTRUCTION_TIMEOUT:int = 5000;
      
      public static const OFFSCREEN_DIRECTION_NONE:int = 0;
      
      public static const OFFSCREEN_DIRECTION_UP:int = 1;
      
      public static const OFFSCREEN_DIRECTION_RIGHT:int = 2;
      
      public static const OFFSCREEN_DIRECTION_DOWN:int = 3;
      
      public static const OFFSCREEN_DIRECTION_LEFT:int = 4;
      
      protected var mElementBinding:ElementBinding;
      
      protected var mObjectID:String;
      
      protected var mMessageHandlers:ElementMessageMap;
      
      protected var mbAwaitingDestruction:Boolean;
      
      protected var mbShown:Boolean;
      
      protected var mDestructionTimer:Timer;
      
      public function ObjectBoundElement()
      {
         super();
         this.mDestructionTimer = new Timer(INACTIVE_DESTRUCTION_TIMEOUT,1);
         this.mDestructionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.OnDestructionTimerComplete,false,0,true);
         this.mMessageHandlers = new ElementMessageMap();
         this.RegisterMessageListeners(this.mMessageHandlers);
         if(!DebugUtils.IsGameClientDriven())
         {
            new CommunicationManager();
            addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
            {
               LocalTest();
            });
         }
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get InactiveTimeout() : int
      {
         return this.mDestructionTimer.delay;
      }
      
      public function set InactiveTimeout(param1:int) : void
      {
         this.mDestructionTimer.delay = param1;
      }
      
      public function SendMessage(param1:String, param2:Object) : Boolean
      {
         var _loc3_:Function = this.mMessageHandlers[param1];
         if(_loc3_ != null)
         {
            return _loc3_(param2);
         }
         return false;
      }
      
      public function Attach(param1:String, param2:ElementBinding) : void
      {
         this.mElementBinding = param2;
         this.mObjectID = param1;
         this.mbAwaitingDestruction = false;
         this.OnObjectAttached();
      }
      
      public function Detach() : void
      {
         this.OnObjectDetached();
         Tween.KillAllTweensForLabel(this.BaseName);
         this.mElementBinding = null;
         this.mObjectID = null;
         this.mDestructionTimer.reset();
      }
      
      public function Destroy() : void
      {
         this.mDestructionTimer.reset();
         this.mbAwaitingDestruction = true;
         CommunicationManager.SendUIMessage("ObjectBoundElementDestroyed",null);
      }
      
      public function get AwaitingDestruction() : Boolean
      {
         return this.mbAwaitingDestruction;
      }
      
      public function get Binding() : ElementBinding
      {
         return this.mElementBinding;
      }
      
      public function get ObjectID() : String
      {
         return this.mObjectID ? this.mObjectID : "0";
      }
      
      public function get Shown() : Boolean
      {
         return this.mbShown;
      }
      
      public function get ElementName() : String
      {
         return this.mElementBinding ? this.mElementBinding.elementName : "";
      }
      
      public function get OffscreenDirection() : int
      {
         return OFFSCREEN_DIRECTION_NONE;
      }
      
      public function set OffscreenDirection(param1:int) : void
      {
      }
      
      public function get BaseName() : String
      {
         return this.ElementName + this.ObjectID;
      }
      
      protected function ObjectHasVisibleElement(param1:Array) : Boolean
      {
         return CommunicationManager.ObjectSendMessage(this.ObjectID,"ObjectHasVisibleElement",param1);
      }
      
      public function RegisterMessageListeners(param1:IElementCommunication) : void
      {
      }
      
      public function Show() : void
      {
         this.mbShown = true;
         CommunicationManager.ObjectSendMessage(this.ObjectID,this.ElementName + "Shown",null);
         this.mDestructionTimer.reset();
      }
      
      public function Hide() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.mbShown = false;
         CommunicationManager.ObjectSendMessage(this.ObjectID,this.ElementName + "Hidden",null);
         this.mDestructionTimer.start();
      }
      
      protected function OnObjectAttached() : void
      {
      }
      
      protected function OnObjectDetached() : void
      {
      }
      
      protected function OnDestructionTimerComplete(param1:TimerEvent) : void
      {
         this.Destroy();
      }
      
      protected function LocalTest() : void
      {
      }
   }
}

