package olympus.views
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import olympus.events.ScrollerEvent;
   import olympus.interfaces.IScrollerController;
   import olympus.interfaces.IView;
   
   public class ScrollerView extends CellView
   {
      
      public var mScrollableContent:IView;
      
      public var mcMask:Sprite;
      
      public var mcBackground:MovieClip;
      
      protected var mProxySize:Point = new Point(100,100);
      
      protected var mController:IScrollerController;
      
      public function ScrollerView()
      {
         super();
         if(stage == null && parent == null)
         {
            throw new Error("Attempting to use \'abstract\' class ScrollerView as a non-stage instance.");
         }
      }
      
      override public function get width() : Number
      {
         return this.mProxySize.x;
      }
      
      override public function set width(param1:Number) : void
      {
         this.mProxySize.x = param1;
         if(!mbInitialized)
         {
            return;
         }
         this.mcMask.width = param1;
         this.mcBackground.width = param1;
      }
      
      override public function get height() : Number
      {
         return this.mProxySize.y;
      }
      
      override public function set height(param1:Number) : void
      {
         this.mProxySize.y = param1;
         if(!mbInitialized)
         {
            return;
         }
         this.mcMask.height = param1;
         this.mcBackground.height = param1;
      }
      
      public function Initialize() : void
      {
         if(mbInitialized)
         {
            return;
         }
         var _loc1_:DisplayObject = this.mScrollableContent as DisplayObject;
         this.mcMask.width = _loc1_.width;
         this.mcMask.height = _loc1_.height;
         this.ApplyMask();
         mbInitialized = true;
      }
      
      public function GetScrollingRegion() : Rectangle
      {
         if(this.mcMask)
         {
            return this.mcMask.getBounds(this);
         }
         return new Rectangle(0,0,this.width,this.height);
      }
      
      public function SetController(param1:IScrollerController) : void
      {
         this.mController = param1;
         this.mController.addEventListener(ScrollerEvent.SCROLL,this.OnScroll,false,0,true);
      }
      
      public function ApplyMask(param1:Boolean = true) : void
      {
         if(this.mcMask == null)
         {
            return;
         }
         if(param1)
         {
            this.mcMask.visible = true;
            this.mScrollableContent.mask = this.mcMask;
         }
         else
         {
            this.mcMask.visible = false;
            this.mScrollableContent.mask = null;
         }
      }
      
      override public function UpdateViewport(param1:Rectangle) : void
      {
         if(!mbInitialized)
         {
            this.Initialize();
         }
         param1.x = param1.width - param1.x;
         param1.y = param1.height - param1.y;
         this.mScrollableContent.UpdateViewport(param1);
      }
      
      override protected function OnAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage);
         this.Initialize();
      }
      
      protected function OnScroll(param1:ScrollerEvent) : void
      {
         this.UpdateViewport(param1.mScrollRect);
      }
   }
}

