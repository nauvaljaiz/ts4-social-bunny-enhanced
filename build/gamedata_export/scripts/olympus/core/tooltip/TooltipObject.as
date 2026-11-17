package olympus.core.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import olympus.constants.Alignment;
   import olympus.core.TooltipManager;
   import olympus.core.widget.Margin;
   import olympus.events.GenericEvent;
   import olympus.gamepad.LayoutAPI;
   import olympus.interfaces.ITooltip;
   import olympus.io.CommunicationManager;
   import olympus.io.TelemetryManager;
   import olympus.motion.Tween;
   import olympus.utils.SystemUtils;
   import scaleform.gfx.Extensions;
   
   public class TooltipObject
   {
      
      protected static const SHOW_DELAY:int = 100;
      
      protected static const HIDE_DELAY:int = 200;
      
      protected static const GAMEPAD_SHOW_DELAY:int = 100;
      
      protected static const GAMEPAD_HIDE_DELAY:int = 100;
      
      public static const TOOLTIP_ON_SHOW:String = "TooltipOnShow";
      
      public static const TOOLTIP_ON_HIDE:String = "TooltipOnHide";
      
      protected var mbConstantlyUpdatePosition:Boolean = true;
      
      public var mbInitialized:Boolean = false;
      
      public var mDelay:int = -1;
      
      protected var mHorizontalAlignment:String = Alignment.CENTER;
      
      protected var mVerticalAlignment:String = Alignment.TOP;
      
      protected var mControl:DisplayObject;
      
      protected var mTooltipClass:Class;
      
      protected var mData:Object;
      
      protected var mbIsShown:Boolean;
      
      protected var mMargins:Margin;
      
      protected var mFallbackPosition:String;
      
      protected var mbUseHitAreaBounds:Boolean;
      
      protected var mHitTestPosition:String = Alignment.NONE;
      
      protected var mEnabled:Boolean = true;
      
      protected var mTimeShown:int;
      
      public function TooltipObject(param1:DisplayObject, param2:Class = null)
      {
         super();
         this.mControl = param1;
         this.mTooltipClass = param2;
         this.mData = new Object();
         this.mData["text"] = "";
         this.mData["maxwidth"] = 0;
         this.mbIsShown = false;
      }
      
      public function set HorizontalAlignment(param1:String) : void
      {
         if(param1 != Alignment.LEFT && param1 != Alignment.CENTER && param1 != Alignment.RIGHT)
         {
            param1 = Alignment.CENTER;
         }
         this.mHorizontalAlignment = param1;
      }
      
      public function get HorizontalAlignment() : String
      {
         return this.mHorizontalAlignment;
      }
      
      public function set VerticalAlignment(param1:String) : void
      {
         if(param1 != Alignment.TOP && param1 != Alignment.CENTER && param1 != Alignment.BOTTOM)
         {
            param1 = Alignment.TOP;
         }
         this.mVerticalAlignment = param1;
      }
      
      public function get VerticalAlignment() : String
      {
         return this.mVerticalAlignment;
      }
      
      public function get Margins() : Margin
      {
         return this.mMargins;
      }
      
      public function set Margins(param1:Margin) : void
      {
         this.mMargins = param1;
      }
      
      public function set UseHitAreaBounds(param1:Boolean) : void
      {
         this.mbUseHitAreaBounds = param1;
      }
      
      public function set TooltipClass(param1:Class) : void
      {
         this.mTooltipClass = param1;
      }
      
      public function get TooltipClass() : Class
      {
         return this.mTooltipClass;
      }
      
      public function set FallbackDirection(param1:String) : void
      {
         this.mFallbackPosition = param1;
      }
      
      public function set HitTestPosition(param1:String) : void
      {
         if(param1 != Alignment.NONE && param1 != Alignment.CENTER && param1 != Alignment.ARROW)
         {
            return;
         }
         this.mHitTestPosition = param1;
      }
      
      public function get Data() : Object
      {
         return this.mData;
      }
      
      public function GetText() : Object
      {
         return this.mData["text"];
      }
      
      public function SetText(param1:Object) : void
      {
         this.mData["text"] = param1;
         if(this.mbIsShown)
         {
            this.UpdateTooltip();
         }
      }
      
      public function SetMaxWidth(param1:Number) : void
      {
         this.mData["maxwidth"] = param1;
         if(this.mbIsShown)
         {
            this.UpdateTooltip();
         }
      }
      
      public function GetMaxWidth() : Number
      {
         return this.mData["maxwidth"];
      }
      
      public function Initialize(param1:Object, param2:int = -1, param3:Number = 0) : void
      {
         this.mbInitialized = true;
         this.mData = param1;
         if(param3 != 0 && !("maxwidth" in param1))
         {
            this.mData["maxwidth"] = param3;
         }
         if(SystemUtils.UsingController)
         {
            this.mDelay = GAMEPAD_SHOW_DELAY;
         }
         else
         {
            this.mDelay = param2 < 0 ? SHOW_DELAY : param2;
         }
         if(this.mbIsShown)
         {
            this.ShowTooltip();
         }
         var _loc4_:DisplayObject = this.mControl;
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.HandleEvent,false,0,true);
         _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.HandleEvent,false,0,true);
         _loc4_.addEventListener(Event.ADDED_TO_STAGE,this.HandleEvent,false,0,true);
         _loc4_.addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage,false,0,true);
         if(SystemUtils.UsingMouseKeyboard && Boolean(this.mControl.stage))
         {
            this.ListenForControllerToggle(true);
         }
      }
      
      public function Shutdown() : void
      {
         if(this.mbIsShown)
         {
            this.HideTooltip();
         }
         var _loc1_:DisplayObject = this.mControl;
         _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.HandleEvent);
         _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.HandleEvent);
         _loc1_.removeEventListener(Event.ADDED_TO_STAGE,this.HandleEvent);
         _loc1_.removeEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage);
         if(SystemUtils.UsingMouseKeyboard && Boolean(_loc1_.stage))
         {
            this.ListenForControllerToggle(false);
         }
         this.mData = null;
         this.mbInitialized = false;
      }
      
      public function HandleRollOver(param1:MouseEvent) : void
      {
         this.ShowTooltip();
      }
      
      public function HandleRollOut(param1:MouseEvent) : void
      {
         this.HideTooltip();
      }
      
      public function HandleEvent(param1:Event) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Point = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Point = null;
         var _loc8_:DisplayObject = null;
         if(!this.Enabled)
         {
            return;
         }
         var _loc2_:String = param1.type;
         _loc3_ = this.mControl;
         switch(_loc2_)
         {
            case MouseEvent.ROLL_OUT:
               this.HideTooltip();
               break;
            case MouseEvent.ROLL_OVER:
               _loc4_ = _loc3_;
               if(this.mHitTestPosition == Alignment.ARROW)
               {
                  _loc5_ = this.GetArrowPoint();
                  _loc4_ = Extensions.getTopMostEntity(_loc5_.x,_loc5_.y,true);
               }
               else if(this.mHitTestPosition == Alignment.CENTER)
               {
                  _loc6_ = this.GetControlRect();
                  _loc7_ = new Point(_loc6_.left + 0.5 * _loc6_.width,_loc6_.top + 0.5 * _loc6_.height);
                  _loc4_ = Extensions.getTopMostEntity(_loc7_.x,_loc7_.y,true);
               }
               if(_loc4_ == _loc3_)
               {
                  this.ShowTooltip();
               }
               break;
            case Event.ADDED_TO_STAGE:
               if(!this.mControl.stage)
               {
                  return;
               }
               if(SystemUtils.UsingMouseKeyboard)
               {
                  this.ListenForControllerToggle(true);
               }
               if(Extensions.getMouseTopMostEntity(true) == _loc3_)
               {
                  _loc8_ = _loc3_;
                  while(_loc8_ != _loc3_.stage)
                  {
                     if(!_loc8_.visible)
                     {
                        return;
                     }
                     _loc8_ = _loc8_.parent;
                  }
                  this.ShowTooltip();
               }
         }
      }
      
      public function ShowTooltip(param1:Boolean = false) : void
      {
         if(this.mbIsShown && !param1)
         {
            this.UpdateTooltip();
            return;
         }
         if(!this.mData)
         {
            return;
         }
         var _loc2_:ITooltip = TooltipManager.getInstance().GetTooltip(this.mTooltipClass);
         this.mbIsShown = true;
         if(_loc2_ is MovieClip)
         {
            (_loc2_ as MovieClip).gotoAndPlay(1);
         }
         (_loc2_ as Sprite).addEventListener(GenericEvent.RESIZE,this.OnTooltipResize,false,0,true);
         _loc2_.SetData(this.mData);
         this.mTimeShown = getTimer();
         Tween.StopAllTweens(_loc2_,true);
         this.UpdatePosition();
         _loc2_.Show(this.mDelay);
         this.mControl.dispatchEvent(new GenericEvent(TOOLTIP_ON_SHOW,false,false,this));
         if(SystemUtils.UsingController && this.mbConstantlyUpdatePosition)
         {
            (_loc2_ as IEventDispatcher).addEventListener(Event.ENTER_FRAME,this.OnEnterFrame,false,0,true);
         }
      }
      
      public function HideTooltip(param1:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         if(!this.mbIsShown)
         {
            return;
         }
         if(this.mData)
         {
            _loc3_ = this.mData["telemetry"] as Object;
            if(Boolean(_loc3_) && Boolean(_loc3_["attributes"]) && Boolean(_loc3_["module"]) && Boolean(_loc3_["group"]) && Boolean(_loc3_["strt"]))
            {
               _loc4_ = getTimer() - this.mTimeShown - (this.mDelay < 0 ? 0 : this.mDelay);
               if(_loc4_ >= 0)
               {
                  _loc5_ = TelemetryManager.AttributeObjectToArray(_loc3_.attributes);
                  _loc5_.push({
                     "attr":"time",
                     "value":Number(_loc4_) / 1000
                  });
                  TelemetryManager.DispatchTelemetryEvent(_loc3_.module,_loc3_.group,_loc3_.strt,_loc5_);
               }
            }
         }
         var _loc2_:ITooltip = TooltipManager.getInstance().GetTooltip(this.mTooltipClass);
         (_loc2_ as Sprite).removeEventListener(GenericEvent.RESIZE,this.OnTooltipResize,false);
         this.mbIsShown = false;
         if(SystemUtils.UsingController)
         {
            (_loc2_ as IEventDispatcher).removeEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
            _loc2_.Hide(param1,GAMEPAD_HIDE_DELAY);
         }
         else
         {
            _loc2_.Hide(param1,HIDE_DELAY);
         }
         this.mControl.dispatchEvent(new GenericEvent(TOOLTIP_ON_HIDE,false,false,this));
      }
      
      protected function UpdateTooltip() : void
      {
         var _loc1_:ITooltip = TooltipManager.getInstance().GetTooltip(this.mTooltipClass);
         _loc1_.SetData(this.mData);
         this.UpdatePosition();
      }
      
      protected function OnRemovedFromStage(param1:Event) : void
      {
         this.HideTooltip(true);
         if(SystemUtils.UsingMouseKeyboard)
         {
            this.ListenForControllerToggle(false);
         }
      }
      
      protected function OnTooltipResize(param1:GenericEvent) : void
      {
         this.UpdatePosition();
      }
      
      protected function OnEnterFrame(param1:Event) : void
      {
         this.UpdatePosition();
      }
      
      protected function GetArrowPoint() : Point
      {
         var _loc1_:Rectangle = this.GetControlRect();
         var _loc2_:Margin = this.mMargins || new Margin(0);
         var _loc3_:Point = new Point();
         switch(this.mHorizontalAlignment)
         {
            case Alignment.NONE:
            case Alignment.CENTER:
               _loc3_.x = _loc1_.left + 0.5 * _loc1_.width;
               break;
            case Alignment.RIGHT:
               if(this.mVerticalAlignment == Alignment.CENTER)
               {
                  _loc3_.x = _loc1_.right;
               }
               else
               {
                  _loc3_.x = _loc1_.right - _loc2_.mRight;
               }
               break;
            case Alignment.LEFT:
               if(this.mVerticalAlignment == Alignment.CENTER)
               {
                  _loc3_.x = _loc1_.left;
               }
               else
               {
                  _loc3_.x = _loc1_.left + _loc2_.mLeft;
               }
         }
         switch(this.mVerticalAlignment)
         {
            case Alignment.NONE:
            case Alignment.TOP:
               _loc3_.y = _loc1_.top;
               break;
            case Alignment.CENTER:
               _loc3_.y = _loc1_.top + 0.5 * _loc1_.height;
               break;
            case Alignment.BOTTOM:
               _loc3_.y = _loc1_.bottom + _loc2_.mTop;
         }
         return _loc3_;
      }
      
      protected function GetControlRect() : Rectangle
      {
         var _loc1_:Rectangle = null;
         var _loc2_:DisplayObject = this.mControl;
         if(this.mbUseHitAreaBounds && Boolean(_loc2_["mcHitArea"]))
         {
            _loc1_ = (_loc2_["mcHitArea"] as Sprite).getBounds(_loc2_.stage);
         }
         else
         {
            _loc1_ = _loc2_.getBounds(_loc2_.stage);
         }
         return _loc1_;
      }
      
      protected function UpdatePosition() : void
      {
         var _loc1_:ITooltip = null;
         _loc1_ = TooltipManager.getInstance().GetTooltip(this.mTooltipClass);
         var _loc2_:DisplayObject = _loc1_.GetDisplayObject();
         var _loc3_:DisplayObject = this.mControl;
         if(!_loc2_ || !_loc3_ || !_loc3_.stage)
         {
            return;
         }
         if(!_loc3_.visible)
         {
            this.HideTooltip();
         }
         var _loc4_:Rectangle = _loc1_.GetBounds();
         var _loc5_:Margin = this.mMargins || new Margin(0);
         var _loc6_:Rectangle = this.GetControlRect();
         var _loc7_:Point = this.GetArrowPoint();
         switch(this.mHorizontalAlignment)
         {
            case Alignment.NONE:
            case Alignment.CENTER:
               _loc7_.x = _loc6_.left + 0.5 * (_loc6_.width - _loc4_.width);
               break;
            case Alignment.LEFT:
               if(this.mVerticalAlignment == Alignment.CENTER)
               {
                  _loc7_.x -= _loc4_.width;
               }
         }
         switch(this.mVerticalAlignment)
         {
            case Alignment.NONE:
            case Alignment.TOP:
               _loc7_.y -= _loc4_.height;
               break;
            case Alignment.CENTER:
               _loc7_.y = _loc6_.top + 0.5 * (_loc6_.height - _loc4_.height);
         }
         _loc2_.x = _loc7_.x;
         _loc2_.y = _loc7_.y;
         var _loc8_:Point = _loc2_.localToGlobal(_loc4_.topLeft);
         var _loc9_:Point = _loc2_.localToGlobal(_loc4_.bottomRight);
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         if(_loc8_.x < LayoutAPI.ScreenMargin.x)
         {
            if(this.mVerticalAlignment == Alignment.CENTER && this.mHorizontalAlignment == Alignment.LEFT)
            {
               _loc10_ = _loc4_.width + _loc6_.width;
            }
            else
            {
               _loc10_ = LayoutAPI.ScreenMargin.x - _loc8_.x;
            }
            _loc2_.x += _loc10_;
         }
         else if(_loc9_.x > LayoutAPI.ScreenMargin.x + LayoutAPI.StageWidth)
         {
            if(this.mVerticalAlignment == Alignment.CENTER && this.mHorizontalAlignment == Alignment.RIGHT)
            {
               _loc10_ = -(_loc4_.width + _loc6_.width);
            }
            else
            {
               _loc10_ = LayoutAPI.ScreenMargin.x - (_loc9_.x - LayoutAPI.StageWidth);
            }
            _loc2_.x += _loc10_;
         }
         var _loc12_:Number = _loc6_.y - (_loc2_.height - _loc6_.height) * 0.5;
         if(_loc7_.y < LayoutAPI.ScreenMargin.y)
         {
            if(this.mVerticalAlignment != Alignment.BOTTOM)
            {
               if(this.mHorizontalAlignment == Alignment.CENTER)
               {
                  if(this.mFallbackPosition == Alignment.LEFT)
                  {
                     _loc2_.x = _loc6_.left - _loc4_.width - _loc5_.mRight;
                     _loc2_.y = (_loc6_.height - _loc2_.height) * 0.5 + _loc6_.y;
                  }
                  else if(this.mFallbackPosition == Alignment.RIGHT)
                  {
                     _loc2_.x = _loc6_.right + _loc5_.mLeft;
                     _loc2_.y = (_loc6_.height - _loc2_.height) * 0.5 + _loc6_.y;
                  }
                  else
                  {
                     _loc2_.y = _loc6_.bottom;
                  }
               }
               else if(this.mHorizontalAlignment == Alignment.LEFT)
               {
                  _loc2_.x = _loc6_.left - _loc4_.width - _loc5_.mRight;
                  _loc11_ = LayoutAPI.ScreenMargin.y - _loc7_.y;
                  _loc2_.y += _loc11_;
               }
               else if(this.mHorizontalAlignment == Alignment.RIGHT)
               {
                  _loc2_.x = _loc6_.right + _loc5_.mLeft;
                  _loc11_ = LayoutAPI.ScreenMargin.y - _loc7_.y;
                  _loc2_.y += _loc11_;
               }
               else
               {
                  _loc2_.y = _loc6_.bottom;
               }
            }
            else
            {
               _loc2_.y = _loc6_.bottom;
            }
         }
         _loc9_ = _loc2_.localToGlobal(_loc4_.bottomRight);
         if(_loc9_.y > LayoutAPI.ScreenMargin.y + LayoutAPI.StageHeight)
         {
            if(this.mVerticalAlignment == Alignment.BOTTOM)
            {
               if(this.mFallbackPosition == Alignment.LEFT)
               {
                  _loc2_.y = _loc12_;
                  _loc2_.x = _loc6_.left - _loc4_.width - _loc5_.mRight;
               }
               else if(this.mFallbackPosition == Alignment.RIGHT)
               {
                  _loc2_.y = _loc12_;
                  _loc2_.x = _loc6_.right + _loc5_.mLeft;
               }
               else
               {
                  _loc2_.y = _loc6_.y - _loc4_.height - _loc5_.mTop;
               }
            }
            else
            {
               _loc11_ = LayoutAPI.ScreenMargin.y - (_loc9_.y - LayoutAPI.StageHeight);
               _loc2_.y += _loc11_;
            }
         }
         _loc1_.OnUpdatePosition(_loc6_,_loc10_,_loc11_);
      }
      
      public function set ConstantlyUpdatePosition(param1:Boolean) : void
      {
         this.mbConstantlyUpdatePosition = param1;
      }
      
      public function get ConstantlyUpdatePosition() : Boolean
      {
         return this.mbConstantlyUpdatePosition;
      }
      
      public function SetControllerHints(param1:String) : void
      {
         if(this.mData)
         {
            if(param1)
            {
               this.mData["controllerHints"] = param1;
               if(this.mbIsShown)
               {
                  this.ShowTooltip();
               }
            }
            else
            {
               this.ClearControllerHints();
            }
         }
      }
      
      public function ClearControllerHints() : void
      {
         if(Boolean(this.mData) && Boolean(this.mData["controllerHints"]))
         {
            this.mData["controllerHints"] = "";
            if(this.mbIsShown)
            {
               this.ShowTooltip();
            }
         }
      }
      
      protected function ListenForControllerToggle(param1:Boolean) : void
      {
         if(param1)
         {
            CommunicationManager.AddMessageListener("UsingControllerToggled",this.HandleUsingControllerToggled,this.mControl);
         }
         else
         {
            CommunicationManager.RemoveMessageListener("UsingControllerToggled",this.HandleUsingControllerToggled,this.mControl);
         }
      }
      
      protected function HandleUsingControllerToggled() : void
      {
         var _loc1_:IEventDispatcher = TooltipManager.getInstance().GetTooltip(this.mTooltipClass) as IEventDispatcher;
         if(!SystemUtils.UsingController && Boolean(_loc1_))
         {
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.OnEnterFrame);
         }
      }
      
      public function get Enabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
      }
   }
}

