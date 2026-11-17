package olympus.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.core.ExtendableComponent;
   import olympus.interfaces.IAnimation;
   import olympus.motion.Tween;
   import olympus.motion.TweenParams;
   
   public class GUIComponent extends ExtendableComponent implements IAnimation
   {
      
      public static const ENABLE_CHANGED_EVENT:String = "enableChanged";
      
      public var mcHitArea:Sprite;
      
      protected var mbInitialized:Boolean = false;
      
      protected var mbFocusable:Boolean = false;
      
      protected var mbDispatchEnableChanged:Boolean = false;
      
      protected var mIsAnimatingIn:Boolean = false;
      
      protected var mIsAnimatingOut:Boolean = false;
      
      public function GUIComponent()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage,false,0,true);
      }
      
      public function get DispatchEnableChanged() : Boolean
      {
         return this.mbDispatchEnableChanged;
      }
      
      public function set DispatchEnableChanged(param1:Boolean) : void
      {
         this.mbDispatchEnableChanged = param1;
      }
      
      public function get IsAnimatingIn() : Boolean
      {
         return this.mIsAnimatingIn;
      }
      
      public function set IsAnimatingIn(param1:Boolean) : void
      {
         this.mIsAnimatingIn = param1;
      }
      
      public function get IsAnimatingOut() : Boolean
      {
         return this.mIsAnimatingOut;
      }
      
      public function set IsAnimatingOut(param1:Boolean) : void
      {
         this.mIsAnimatingOut = param1;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 == super.enabled)
         {
            return;
         }
         super.enabled = param1;
         tabEnabled = enabled ? this.mbFocusable : false;
         if(this.mbDispatchEnableChanged)
         {
            dispatchEvent(new Event(ENABLE_CHANGED_EVENT));
         }
      }
      
      protected function OnAddedToStage(param1:Event) : void
      {
         if(!this.mbInitialized)
         {
            this.ConfigUI();
            this.mbInitialized = true;
         }
      }
      
      protected function OnRemovedFromStage(param1:Event) : void
      {
      }
      
      protected function ConfigUI() : void
      {
         if(this.mcHitArea)
         {
            hitArea = this.mcHitArea;
            this.mcHitArea.mouseEnabled = false;
            this.mcHitArea.visible = false;
         }
      }
      
      public function GetRect() : Rectangle
      {
         return this.getRect(parent);
      }
      
      public function AnimateIn(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(param1,param2,this,this.GetRect(),param3);
         return param2.totalDuration;
      }
      
      public function AnimateOut(param1:int, param2:TweenParams, param3:Point = null) : int
      {
         Tween.StopAllTweens(this,false,true);
         Tween.AnimateClip(param1,param2,this,this.GetRect(),param3);
         return param2.totalDuration;
      }
   }
}

