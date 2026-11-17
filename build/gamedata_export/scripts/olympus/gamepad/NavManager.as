package olympus.gamepad
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import olympus.constants.GameStates;
   import olympus.constants.Layers;
   import olympus.core.ExtendableComponent;
   import olympus.core.PopUpManager;
   import olympus.core.widget.WidgetBase;
   import olympus.dialog.DialogManager;
   import olympus.events.PushButtonEvent;
   import olympus.extensions.HighlightExtension;
   import olympus.extensions.TooltipExtension;
   import olympus.gui.buttons.Button;
   import olympus.gui.sliders.Slider;
   import olympus.input.GamepadAnalogSticks;
   import olympus.input.IInputFocusable;
   import olympus.input.adapters.InputAdapter;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.input.constants.InputAdapterTunables;
   import olympus.io.CommunicationManager;
   import olympus.math.Geometry;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   import olympus.utils.WidgetUtils;
   import scaleform.clik.controls.Button;
   import scaleform.gfx.Extensions;
   
   public class NavManager extends EventDispatcher
   {
      
      protected static var instance:NavManager;
      
      protected static const FOCUS_FROM_ESCAPE_MENU:Vector.<String> = new <String>["SaveLoadConsoleMenu","OptionsMenu","Tutorial","GameCredits","Dialog","ControllerLegend","ScreenMargins","LegalAgreements","PackSelection"];
      
      protected var mCurrentNavMesh:NavMesh;
      
      protected var mCurrentNode:NavMeshNode;
      
      protected var mCurrentElement:DisplayObject;
      
      protected var mVirtualCursorFocusStack:InputFocusStack;
      
      protected var mHUDFocusStack:InputFocusStack;
      
      protected var mbInVirtualCursorMode:Boolean = true;
      
      protected var mVirtualCursorRootFocusable:IInputFocusable;
      
      protected var mHUDRootWidgetName:String = null;
      
      protected var mPendingWidget:WidgetBase;
      
      protected var mFocusWidgetCompleteCallbacks:Dictionary;
      
      protected var mEnterFocusCompleteCallbacks:Array;
      
      protected var mCurrentHUDRootInputAdapters:Vector.<InputAdapter> = new Vector.<InputAdapter>();
      
      protected var mAllowedNonRootInputAdapters:Vector.<InputAdapter> = new Vector.<InputAdapter>();
      
      protected var mDisplayObjectsToIgnoreMouse:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      protected var mClickableDisplayObjectsToIgnoreFocus:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      protected var mVisibleWidgetsStack:Vector.<String> = new Vector.<String>();
      
      protected var mbDraggingSlider:Boolean = false;
      
      protected var mHeldSlider:Slider;
      
      protected var mbForceRotateZoomAllowed:Boolean = false;
      
      protected var mbRotateAllowed:Boolean = true;
      
      protected var mbZoomAllowed:Boolean = true;
      
      protected var mbTravelButtonAllowed:Boolean = true;
      
      protected var mbFocusChanging:* = false;
      
      protected var mbInResetAndFocusVisibleWidgets:Boolean = false;
      
      public function NavManager()
      {
         super();
         this.mCurrentNode = null;
         this.mCurrentElement = null;
         this.mCurrentNavMesh = null;
         this.mVirtualCursorRootFocusable = null;
         this.mVirtualCursorFocusStack = new InputFocusStack();
         this.mHUDFocusStack = new InputFocusStack();
         this.mFocusWidgetCompleteCallbacks = new Dictionary();
         this.mEnterFocusCompleteCallbacks = new Array();
         instance = this;
      }
      
      public static function get Instance() : NavManager
      {
         return instance;
      }
      
      public function get CurrentNode() : NavMeshNode
      {
         return this.mCurrentNode;
      }
      
      public function get CurrentElement() : DisplayObject
      {
         if(this.CurrentWidget)
         {
            return this.mCurrentElement;
         }
         return null;
      }
      
      public function get CurrentFocusable() : IInputFocusable
      {
         if(!this.CurrentInputFocusStack.Peek())
         {
            return null;
         }
         return this.CurrentInputFocusStack.Peek().mFocusable;
      }
      
      public function get CurrentWidgetName() : String
      {
         if(this.CurrentInputFocusStack.Peek() == null)
         {
            return null;
         }
         return this.CurrentInputFocusStack.Peek().mWidgetName;
      }
      
      public function get CurrentWidget() : WidgetBase
      {
         var _loc1_:String = this.CurrentWidgetName;
         if(_loc1_)
         {
            return LayoutAPI.GetLoadedWidgetByName(_loc1_);
         }
         return null;
      }
      
      public function get IsInCursorMode() : Boolean
      {
         return this.mbInVirtualCursorMode;
      }
      
      public function get IsAtRoot() : Boolean
      {
         return this.CurrentInputFocusStack.Root == this.CurrentInputFocusStack.Peek();
      }
      
      protected function get CurrentInputFocusStack() : InputFocusStack
      {
         if(this.mbInVirtualCursorMode)
         {
            return this.mVirtualCursorFocusStack;
         }
         return this.mHUDFocusStack;
      }
      
      public function get VirtualCursorRootFocusable() : IInputFocusable
      {
         return this.mVirtualCursorRootFocusable;
      }
      
      public function get IsInResetAndFocusVisibleWidgets() : Boolean
      {
         return this.mbInResetAndFocusVisibleWidgets;
      }
      
      public function Reset() : void
      {
         this.ClearHighlight();
         if(this.CurrentFocusable)
         {
            this.CurrentFocusable.Exit();
         }
         this.mVirtualCursorFocusStack.Clear();
         this.mHUDFocusStack.Clear();
         this.mCurrentNavMesh = null;
         this.mPendingWidget = null;
         this.mVirtualCursorRootFocusable = null;
         this.mHUDRootWidgetName = null;
         this.mbInVirtualCursorMode = true;
      }
      
      public function InitRootFocusables(param1:IInputFocusable, param2:String, param3:Boolean = true, param4:Object = null, param5:Function = null, param6:Boolean = false) : void
      {
         if(this.mVirtualCursorFocusStack.Peek() == null && this.mHUDFocusStack.Peek() == null)
         {
            this.mVirtualCursorRootFocusable = param1;
            this.mHUDRootWidgetName = param2;
            this.mbInVirtualCursorMode = param3;
            this.TryPushCurrentRoot(param4,param5,param6);
         }
      }
      
      protected function TryPushCurrentRoot(param1:Object = null, param2:Function = null, param3:Boolean = false) : Boolean
      {
         var _loc5_:* = undefined;
         var _loc4_:Boolean = false;
         if(this.mbInVirtualCursorMode)
         {
            if(this.mVirtualCursorFocusStack.Peek() == null && Boolean(this.mVirtualCursorRootFocusable))
            {
               this.SetFocusChanging(true);
               _loc5_ = this.mVirtualCursorRootFocusable.Enter();
               this.mVirtualCursorFocusStack.Push(new WidgetInputFocusable(null,_loc5_));
               this.SetFocusChanging(false);
               _loc4_ = true;
            }
         }
         else if(this.mHUDFocusStack.Peek() == null && this.mHUDRootWidgetName != null)
         {
            this.FocusWidgetForward(this.mHUDRootWidgetName,param1,param2,param3);
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      public function SwitchToHUDModeAndResetFocusToWidget(param1:String = null) : void
      {
         if(!this.mbInVirtualCursorMode)
         {
            return;
         }
         this.mHUDFocusStack.Clear();
         this.ToggleVirtualCursorMode(param1);
      }
      
      public function ToggleVirtualCursorMode(param1:String = null) : void
      {
         var _loc2_:WidgetBase = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         if(this.mbInVirtualCursorMode)
         {
            if(!this.mHUDFocusStack.Peek() && this.mHUDRootWidgetName == null && param1 == null)
            {
               return;
            }
         }
         else if(!this.mVirtualCursorFocusStack.Peek() && !this.mVirtualCursorRootFocusable)
         {
            return;
         }
         CommunicationManager.SendUIMessage("CursorModeToggled",{"isCursorMode":!this.mbInVirtualCursorMode});
         this.mCurrentNode = null;
         this.ClearHighlight();
         this.SetStackToFirst();
         this.mbInVirtualCursorMode = !this.mbInVirtualCursorMode;
         if(!this.mbInVirtualCursorMode)
         {
            if(Boolean(this.mHeldSlider) && this.mHeldSlider.IsDragging)
            {
               this.mHeldSlider.ForceDragEnd();
            }
            this.mHeldSlider = null;
            this.mbDraggingSlider = false;
            CommunicationManager.CallGameService("CameraSetEdgeScrollForGamepad",true,true);
         }
         if(param1)
         {
            this.mHUDRootWidgetName = param1;
         }
         if(!this.TryPushCurrentRoot())
         {
            if(Boolean(this.CurrentWidgetName) && Boolean(this.mCurrentNavMesh))
            {
               _loc2_ = LayoutAPI.GetLoadedWidgetByName(this.CurrentWidgetName);
               if(Boolean(_loc2_) && Boolean(_loc2_.visible) && _loc2_.IsReadyToEnter())
               {
                  this.CurrentFocusable.Enter();
                  this.mCurrentNode = this.mCurrentNavMesh.GetNode(this.CurrentWidgetName);
                  this.CurrentWidget.OnEntered();
               }
               else
               {
                  _loc3_ = CommunicationManager.CallGameService("GetGameState",null) as uint;
                  _loc4_ = NavStartWidgets.GetStartWidgetName(_loc3_);
                  this.ChangeWidgets(_loc4_,NavDirection.LEFT);
               }
            }
            else
            {
               this.CurrentFocusable.Enter();
            }
         }
         this.SendFocusableChangeMessage(null);
      }
      
      public function SetNavMesh(param1:NavMesh) : void
      {
         this.mCurrentNavMesh = param1;
      }
      
      public function GetNavMesh() : NavMesh
      {
         return this.mCurrentNavMesh;
      }
      
      public function ResetFocusToWidget(param1:String, param2:Object = null, param3:* = false) : void
      {
         var _loc4_:WidgetBase = null;
         if(Boolean(this.CurrentInputFocusStack.Root) && !param3)
         {
            this.SetStackToFirst();
         }
         else if(this.CurrentFocusable)
         {
            this.CurrentFocusable.Exit();
            _loc4_ = this.CurrentWidget;
            if(_loc4_)
            {
               _loc4_.OnExited();
            }
            this.CurrentInputFocusStack.Clear();
         }
         this.FocusWidgetForward(param1,param2);
      }
      
      public function FocusWidgetForward(param1:String, param2:Object = null, param3:Function = null, param4:Boolean = false, param5:Boolean = false) : Boolean
      {
         var _loc7_:WidgetInputFocusable = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:WidgetInputFocusable = null;
         if(!SystemUtils.UsingController)
         {
            return false;
         }
         if(Boolean(param1) && !LayoutAPI.GetLoadedWidgetByName(param1))
         {
            this.mFocusWidgetCompleteCallbacks[param1] = {
               "callback":param3,
               "args":param2
            };
            CommunicationManager.AddMessageListenerByName("Loaded" + param1,this.HandleWidgetLoadedForward,param1);
            return false;
         }
         if(!param4 && this.HandleEscapeMenuUp(param1,param2))
         {
            return false;
         }
         if(param1 != "ControllerLegend" && param1 != "Dialog")
         {
            _loc7_ = this.CurrentInputFocusStack.Peek();
            _loc8_ = _loc7_ != null && _loc7_.mWidgetName == "Dialog" && !param5;
            _loc9_ = CommunicationManager.CallUIService("IsWidgetVisible","ControllerLegend");
            if((Boolean(_loc9_)) || Boolean(_loc8_))
            {
               _loc10_ = new WidgetInputFocusable(param1,null);
               this.InsertUnderCurrentFocusable(_loc10_,NavDirection.FORWARD,null,param2);
               return false;
            }
         }
         var _loc6_:Boolean = this.ChangeWidgets(param1,NavDirection.FORWARD,null,param2);
         if(param3 != null)
         {
            param3(_loc6_);
         }
         return _loc6_;
      }
      
      protected function HandleWidgetLoadedForward(param1:Object = null) : void
      {
         var _loc3_:Boolean = false;
         if(!SystemUtils.UsingController)
         {
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("Loaded" + param1.widget,this.HandleWidgetLoadedForward,param1.widget);
         var _loc2_:Object = this.mFocusWidgetCompleteCallbacks[param1.widget];
         if(param1.loaded)
         {
            if(_loc2_)
            {
               if(this.HandleEscapeMenuUp(param1.widget,_loc2_.args))
               {
                  _loc3_ = true;
               }
               else
               {
                  _loc3_ = this.ChangeWidgets(param1.widget,NavDirection.FORWARD,null,_loc2_.args);
               }
               if(_loc2_.callback)
               {
                  _loc2_.callback(_loc3_);
               }
               delete this.mFocusWidgetCompleteCallbacks[param1.widget];
            }
         }
         else if(Boolean(_loc2_) && Boolean(_loc2_.callback))
         {
            _loc2_.callback(false);
         }
      }
      
      protected function HandleEscapeMenuUp(param1:String, param2:Object) : Boolean
      {
         var _loc3_:WidgetInputFocusable = null;
         if(param1 != "EscapeMenu" && FOCUS_FROM_ESCAPE_MENU.indexOf(param1) == -1 && Boolean(CommunicationManager.CallUIService("IsWidgetVisibleAndNotHiding","EscapeMenu")))
         {
            _loc3_ = new WidgetInputFocusable(param1,null);
            this.InsertUnderCurrentFocusable(_loc3_,NavDirection.FORWARD,null,param2);
            return true;
         }
         return false;
      }
      
      public function FocusWidgetPan(param1:uint, param2:Point, param3:Object = null) : Boolean
      {
         var _loc5_:Point = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Object = null;
         var _loc15_:NavMeshNode = null;
         var _loc16_:WidgetBase = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Point = null;
         if(!this.mCurrentNode)
         {
            return false;
         }
         var _loc4_:Array = this.CurrentNode.GetConnections();
         if(!_loc4_)
         {
            return false;
         }
         if(Boolean(param3) && Boolean(param3.AnalogDirection))
         {
            _loc5_ = param3.AnalogDirection as Point;
         }
         if(!_loc5_)
         {
            _loc12_ = GamepadAnalogSticks.GetLeftX();
            _loc13_ = -GamepadAnalogSticks.GetLeftY();
            if(Geometry.GetLengthSquared(_loc12_,_loc13_) > InputAdapterTunables.ANALOG_DEADZONE_SQ)
            {
               _loc5_ = new Point(_loc12_,_loc13_);
            }
            else
            {
               _loc5_ = Geometry.DirectionToVector(param1);
            }
         }
         var _loc6_:* = Math.atan2(_loc5_.y,_loc5_.x);
         var _loc7_:Number = InputAdapterTunables.OMNIDIRECTIONAL_SEARCH_MAX_ARC_LENGTH;
         var _loc8_:NavMeshNode = null;
         var _loc9_:WidgetBase = null;
         var _loc10_:uint = _loc4_.length;
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            _loc14_ = _loc4_[_loc11_];
            if(_loc14_)
            {
               _loc15_ = _loc14_.node;
               if((Boolean(_loc15_)) && _loc15_ != this.CurrentNode)
               {
                  _loc16_ = LayoutAPI.GetLoadedWidgetByName(_loc15_.mName);
                  if((Boolean(_loc16_)) && _loc16_.IsReadyToEnter(new EnterParams(param1,param2,param3)))
                  {
                     _loc17_ = 0;
                     if(_loc14_.isDynamic)
                     {
                        _loc19_ = _loc16_.GetWidgetCenterForGamepadNavMesh();
                        if(param2)
                        {
                           _loc17_ = Math.atan2(_loc19_.y - param2.y,_loc19_.x - param2.x);
                        }
                     }
                     else
                     {
                        _loc17_ = Number(_loc14_.angle);
                     }
                     _loc18_ = Geometry.GetArcLength(_loc6_,_loc17_);
                     if(_loc16_.visible && _loc18_ < _loc7_)
                     {
                        _loc7_ = _loc18_;
                        _loc8_ = _loc15_;
                        _loc9_ = _loc16_;
                     }
                  }
               }
            }
            _loc11_++;
         }
         if(Boolean(_loc8_) && Boolean(_loc9_))
         {
            return this.ChangeWidgets(_loc8_.mName,param1,param2,param3);
         }
         return false;
      }
      
      protected function GetNavMeshDistance(param1:Point, param2:WidgetBase, param3:uint) : int
      {
         var _loc4_:int = -1;
         var _loc5_:Rectangle = DisplayObjectUtils.GetVisibleBounds(param2);
         if(_loc5_)
         {
            if(param3 == NavDirection.LEFT && param1.x > _loc5_.left || param3 == NavDirection.RIGHT && param1.x < _loc5_.right)
            {
               if(_loc5_.top <= param1.y && _loc5_.bottom >= param1.y)
               {
                  _loc4_ = 0;
               }
               else if(_loc5_.top > param1.y)
               {
                  _loc4_ = Math.abs(_loc5_.top - param1.y);
               }
               else if(_loc5_.bottom < param1.y)
               {
                  _loc4_ = Math.abs(_loc5_.bottom - param1.y);
               }
            }
            else if(param3 == NavDirection.UP && param1.y > _loc5_.top || param3 == NavDirection.DOWN && param1.y < _loc5_.bottom)
            {
               if(_loc5_.left <= param1.x && _loc5_.right >= param1.x)
               {
                  _loc4_ = 0;
               }
               else if(_loc5_.left > param1.x)
               {
                  _loc4_ = Math.abs(_loc5_.left - param1.x);
               }
               else if(_loc5_.right < param1.x)
               {
                  _loc4_ = Math.abs(_loc5_.right - param1.x);
               }
            }
         }
         return _loc4_;
      }
      
      public function ChangeWidgets(param1:String, param2:uint, param3:Point = null, param4:Object = null) : Boolean
      {
         var _loc9_:WidgetInputFocusable = null;
         var _loc10_:IInputFocusable = null;
         var _loc11_:WidgetInputFocusable = null;
         var _loc5_:WidgetBase = this.CurrentWidget;
         var _loc6_:WidgetBase = LayoutAPI.GetLoadedWidgetByName(param1);
         if(_loc5_ == _loc6_)
         {
            return false;
         }
         var _loc7_:EnterParams = new EnterParams(param2,param3,param4);
         if(Boolean(_loc6_) && !_loc6_.IsReadyToEnter(_loc7_))
         {
            return false;
         }
         this.mPendingWidget = _loc6_;
         this.ClearHighlight();
         var _loc8_:IInputFocusable = this.CurrentFocusable;
         if(this.CurrentFocusable)
         {
            this.CurrentFocusable.Exit();
         }
         if(_loc5_)
         {
            _loc5_.OnExited();
         }
         if(this.mCurrentNavMesh)
         {
            this.mCurrentNode = this.mCurrentNavMesh.GetNode(param1);
         }
         if(param2 == NavDirection.BACK && Boolean(this.CurrentInputFocusStack.Peek()))
         {
            this.CurrentInputFocusStack.Pop();
         }
         if(_loc6_)
         {
            if(Boolean(this.CurrentFocusable) && _loc6_.WidgetName == this.CurrentWidgetName)
            {
               this.CurrentFocusable.Enter(_loc7_);
            }
            else
            {
               _loc10_ = _loc6_.Enter(_loc7_);
            }
            _loc9_ = new WidgetInputFocusable(param1,_loc10_);
            if(param2 == NavDirection.FORWARD)
            {
               this.CurrentInputFocusStack.Push(_loc9_);
            }
            else if(param2 != NavDirection.BACK && param2 != NavDirection.NONE)
            {
               if(this.CurrentInputFocusStack.Peek())
               {
                  this.CurrentInputFocusStack.Pop();
               }
               this.CurrentInputFocusStack.Push(_loc9_);
            }
            _loc6_.OnEntered(_loc7_);
         }
         else
         {
            if(param1 != null)
            {
               return false;
            }
            _loc11_ = this.CurrentInputFocusStack.Peek();
            if(Boolean(param2 == NavDirection.BACK) && Boolean(_loc11_) && Boolean(_loc11_.mFocusable))
            {
               _loc11_.mFocusable.Enter(_loc7_);
            }
         }
         this.mPendingWidget = null;
         this.SendFocusableChangeMessage(_loc8_);
         return true;
      }
      
      public function FocusForward(param1:IInputFocusable, param2:Object = null) : void
      {
         if(!param1 || Boolean(param2 && param2.WidgetName && this.CurrentWidgetName) && Boolean(param2.WidgetName != this.CurrentWidgetName))
         {
            return;
         }
         if(param1 == this.CurrentFocusable)
         {
            return;
         }
         var _loc3_:String = Boolean(param2) && Boolean(param2.WidgetName) ? param2.WidgetName : this.CurrentWidgetName;
         if(Boolean(CommunicationManager.CallUIService("IsWidgetVisible","EscapeMenu")) && (FOCUS_FROM_ESCAPE_MENU.indexOf(_loc3_) == -1 || param1 is VirtualCursorInputAdapter))
         {
            this.InsertUnderCurrentFocusable(new WidgetInputFocusable(_loc3_,param1),NavDirection.FORWARD,null,param2);
            return;
         }
         this.ClearHighlight();
         var _loc4_:IInputFocusable = this.CurrentFocusable;
         if(this.CurrentFocusable)
         {
            this.CurrentFocusable.Exit();
         }
         this.SetFocusChanging(true);
         var _loc5_:IInputFocusable = param1.Enter(new EnterParams(NavDirection.FORWARD,null,param2));
         this.CurrentInputFocusStack.Push(new WidgetInputFocusable(_loc3_,_loc5_));
         this.SetFocusChanging(false);
         this.SendFocusableChangeMessage(_loc4_);
      }
      
      public function FocusBack(param1:Object = null) : IInputFocusable
      {
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         if(!this.CurrentInputFocusStack.Peek())
         {
            return null;
         }
         if(this.IsAtRoot)
         {
            _loc4_ = CommunicationManager.CallGameService("GetGameState",null) as uint;
            if(this.CurrentInputFocusStack == this.mHUDFocusStack && _loc4_ != GameStates.TRAVEL && _loc4_ != GameStates.LOT_SELECT)
            {
               this.ToggleVirtualCursorMode();
            }
            return this.CurrentInputFocusStack.Root.mFocusable;
         }
         this.ClearHighlight();
         var _loc2_:WidgetInputFocusable = this.CurrentInputFocusStack.Pop();
         if(Boolean(this.CurrentWidgetName) && this.CurrentWidgetName != _loc2_.mWidgetName)
         {
            _loc5_ = this.CurrentWidgetName;
            this.CurrentInputFocusStack.Push(_loc2_);
            this.ChangeWidgets(_loc5_,NavDirection.BACK,null,param1);
            return _loc2_.mFocusable;
         }
         _loc2_.mFocusable.Exit();
         this.ClearHighlight();
         var _loc3_:EnterParams = new EnterParams(NavDirection.BACK,null,param1);
         if(this.CurrentInputFocusStack.Peek())
         {
            this.CurrentInputFocusStack.Peek().mFocusable.Enter(_loc3_);
         }
         this.SendFocusableChangeMessage(_loc2_.mFocusable);
         return _loc2_.mFocusable;
      }
      
      public function FocusBackTo(param1:IInputFocusable) : Boolean
      {
         var _loc3_:WidgetInputFocusable = null;
         var _loc2_:Boolean = this.CurrentInputFocusStack.Contains(param1);
         if(_loc2_)
         {
            this.mCurrentNode = null;
            this.ClearHighlight();
            this.SetStackToFocusable(param1);
            _loc3_ = this.CurrentInputFocusStack.Peek();
            if(Boolean(this.mCurrentNavMesh) && Boolean(_loc3_.mWidgetName))
            {
               this.mCurrentNode = this.mCurrentNavMesh.GetNode(_loc3_.mWidgetName);
            }
            param1.Enter(new EnterParams(NavDirection.BACK));
         }
         return _loc2_;
      }
      
      public function FocusBackToFirstWidget(param1:String) : Boolean
      {
         var _loc2_:IInputFocusable = this.CurrentInputFocusStack.GetFirstFocusableForWidget(param1);
         if(Boolean(_loc2_) && _loc2_ != this.CurrentFocusable)
         {
            return this.FocusBackTo(_loc2_);
         }
         if(_loc2_ == this.CurrentFocusable)
         {
            return true;
         }
         return false;
      }
      
      public function TryFocusBack(param1:IInputFocusable) : Boolean
      {
         if(param1 == this.CurrentFocusable)
         {
            this.FocusBack();
            return true;
         }
         return false;
      }
      
      public function RemoveFromFocusStack(param1:IInputFocusable) : Boolean
      {
         if(this.TryFocusBack(param1))
         {
            return true;
         }
         this.CurrentInputFocusStack.Remove(param1);
         return false;
      }
      
      public function RemoveWidgetFromFocusStack(param1:String) : Boolean
      {
         if(this.CurrentWidgetName == param1)
         {
            this.FocusBack();
            return true;
         }
         this.CurrentInputFocusStack.RemoveWidget(param1);
         return false;
      }
      
      public function FocusPan(param1:IInputFocusable, param2:EnterParams = null) : void
      {
         var _loc6_:IInputFocusable = null;
         if(!param1)
         {
            return;
         }
         if(!this.CurrentInputFocusStack.Peek())
         {
            return;
         }
         var _loc3_:String = Boolean(param2) && Boolean(param2.mArgs) && Boolean(param2.mArgs.WidgetName) ? param2.mArgs.WidgetName : this.CurrentWidgetName;
         this.mPendingWidget = this.CurrentWidget;
         this.ClearHighlight();
         var _loc4_:WidgetInputFocusable = this.CurrentInputFocusStack.Pop();
         _loc4_.mFocusable.Exit();
         var _loc5_:InputAdapter = param1 as InputAdapter;
         if(_loc5_)
         {
            this.CurrentInputFocusStack.Push(new WidgetInputFocusable(_loc3_,_loc5_.GetStackFocusable(param2)));
            _loc5_.Enter(param2);
         }
         else
         {
            this.SetFocusChanging(true);
            _loc6_ = param1.Enter(param2);
            this.CurrentInputFocusStack.Push(new WidgetInputFocusable(_loc3_,_loc6_));
            this.SetFocusChanging(false);
         }
         this.SendFocusableChangeMessage(_loc4_.mFocusable);
         this.mPendingWidget = null;
      }
      
      public function FocusBackToFirst(param1:Object = null) : void
      {
         var _loc2_:WidgetInputFocusable = this.CurrentInputFocusStack.Root;
         if(_loc2_)
         {
            this.FocusBackTo(_loc2_.mFocusable);
         }
         var _loc3_:Boolean = Boolean(param1) && param1.hasOwnProperty("bAutoFocusToDialog") ? Boolean(param1.bAutoFocusToDialog) : true;
         if(_loc3_ && Boolean(DialogManager.GetCurrentRequest()))
         {
            NavManager.Instance.FocusWidgetForward("Dialog");
         }
      }
      
      public function SetStackToFirst() : void
      {
         var _loc1_:WidgetInputFocusable = this.CurrentInputFocusStack.Root;
         if(_loc1_)
         {
            this.SetStackToFocusable(_loc1_.mFocusable);
         }
      }
      
      protected function SetStackToFocusable(param1:IInputFocusable) : Boolean
      {
         var _loc3_:IInputFocusable = null;
         if(!this.CurrentInputFocusStack || !this.CurrentInputFocusStack.Contains(param1))
         {
            return false;
         }
         if(this.CurrentWidget)
         {
            this.CurrentWidget.OnExited();
         }
         var _loc2_:WidgetInputFocusable = this.CurrentInputFocusStack.Pop();
         if(_loc2_)
         {
            _loc3_ = _loc2_.mFocusable;
            if(_loc2_.mFocusable)
            {
               _loc2_.mFocusable.Exit();
            }
            while(this.CurrentInputFocusStack.Peek())
            {
               _loc2_ = this.CurrentInputFocusStack.Pop();
               if(Boolean(_loc2_) && param1 == _loc2_.mFocusable)
               {
                  break;
               }
            }
            this.CurrentInputFocusStack.Push(_loc2_);
            this.SendFocusableChangeMessage(_loc3_);
            return true;
         }
         return false;
      }
      
      protected function SendFocusableChangeMessage(param1:IInputFocusable) : void
      {
         CommunicationManager.SendUIMessage("ChangedCurrentFocusable",{
            "from":param1,
            "to":this.CurrentFocusable
         });
         this.NotifyCameraController();
      }
      
      public function StackContains(param1:IInputFocusable) : Boolean
      {
         return this.CurrentInputFocusStack.Contains(param1);
      }
      
      public function StackContainsWidget(param1:String) : Boolean
      {
         return this.CurrentInputFocusStack.ContainsWidget(param1);
      }
      
      public function IsFocusedWidgetHigher(param1:WidgetBase) : Boolean
      {
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc2_:WidgetBase = this.CurrentWidget;
         if(!_loc2_ || _loc2_ == param1)
         {
            return false;
         }
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = Layers.ALWAYS_ON_TOP_TRANSITION;
         while(_loc4_ <= Layers.WORLD_ELEMENTS)
         {
            _loc3_ = CommunicationManager.CallUIService("GetLayer",{"layer":_loc4_}) as DisplayObjectContainer;
            _loc6_ = _loc3_.contains(_loc2_);
            _loc7_ = _loc3_.contains(param1);
            if(_loc6_ && !_loc7_)
            {
               return true;
            }
            if(!_loc6_ && _loc7_)
            {
               return false;
            }
            if(_loc6_ && _loc7_)
            {
               break;
            }
            _loc4_++;
         }
         var _loc5_:int = _loc3_.numChildren;
         if(_loc5_ != 0)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               _loc9_ = _loc3_.getChildAt(_loc8_);
               if(DisplayObjectUtils.IsParent(_loc9_,param1))
               {
                  return true;
               }
               if(DisplayObjectUtils.IsParent(_loc9_,_loc2_))
               {
                  return false;
               }
               _loc8_++;
            }
         }
         return false;
      }
      
      public function TryAddFocusChangeCompleteCallback(param1:Function) : Boolean
      {
         if(this.mbFocusChanging)
         {
            if(Boolean(param1))
            {
               this.mEnterFocusCompleteCallbacks.push(param1);
            }
            return true;
         }
         return false;
      }
      
      protected function SetFocusChanging(param1:Boolean) : void
      {
         var _loc2_:Function = null;
         this.mbFocusChanging = param1;
         if(!param1)
         {
            for each(_loc2_ in this.mEnterFocusCompleteCallbacks)
            {
               _loc2_();
            }
            this.mEnterFocusCompleteCallbacks.length = 0;
         }
      }
      
      public function RequestHighlight(param1:DisplayObject) : Boolean
      {
         if(!SystemUtils.UsingController)
         {
            return false;
         }
         var _loc2_:WidgetBase = this.mPendingWidget ? this.mPendingWidget : this.CurrentWidget;
         if(Boolean(param1 && _loc2_) && Boolean(!DisplayObjectUtils.IsParent(_loc2_,param1)) && !PopUpManager.Contains(param1))
         {
            return false;
         }
         var _loc3_:DisplayObject = this.mCurrentElement;
         this.mCurrentElement = param1;
         if(_loc3_)
         {
            _loc3_.dispatchEvent(new HighlightRequestEvent(false));
         }
         if(this.mCurrentElement)
         {
            this.mCurrentElement.dispatchEvent(new HighlightRequestEvent(true));
         }
         if(this.mCurrentElement != _loc3_)
         {
            dispatchEvent(new HighlightChangeEvent(this.mCurrentElement,_loc3_));
         }
         return true;
      }
      
      public function ClearHighlight() : void
      {
         var _loc1_:DisplayObject = this.mCurrentElement;
         this.mCurrentElement = null;
         if(_loc1_)
         {
            _loc1_.dispatchEvent(new HighlightRequestEvent(false));
            dispatchEvent(new HighlightChangeEvent(null,_loc1_));
         }
      }
      
      public function ShouldSendMouseLeftClick(param1:Boolean) : Boolean
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:InputAdapter = null;
         var _loc6_:Slider = null;
         var _loc7_:Vector.<DisplayObject> = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:HighlightExtension = null;
         var _loc10_:String = null;
         var _loc11_:WidgetBase = null;
         var _loc12_:WidgetBase = null;
         var _loc13_:Point = null;
         var _loc14_:EnterParams = null;
         if(CommunicationManager.CallUIService("IsTransitionScreenVisible"))
         {
            return false;
         }
         if((!this.IsAtRoot || !(this.CurrentFocusable is VirtualCursorInputAdapter)) && this.mAllowedNonRootInputAdapters.indexOf(this.CurrentFocusable) < 0)
         {
            return true;
         }
         var _loc2_:DisplayObject = Extensions.getTopMostEntity(InputUtils.sMouseX,InputUtils.sMouseY,true);
         if(!_loc2_)
         {
            return true;
         }
         if(this.mbDraggingSlider && !param1)
         {
            if(Boolean(this.mHeldSlider) && this.mHeldSlider.IsDragging)
            {
               this.mHeldSlider.ForceDragEnd();
            }
            this.mbDraggingSlider = false;
            CommunicationManager.CallGameService("CameraSetEdgeScrollForGamepad",true,true);
            this.mHeldSlider = null;
            return false;
         }
         for each(_loc3_ in this.mDisplayObjectsToIgnoreMouse)
         {
            if(_loc2_ == _loc3_ || DisplayObjectUtils.IsParent(_loc3_,_loc2_))
            {
               return false;
            }
         }
         for each(_loc4_ in this.mClickableDisplayObjectsToIgnoreFocus)
         {
            if(_loc2_ == _loc4_ || DisplayObjectUtils.IsParent(_loc4_,_loc2_))
            {
               return true;
            }
         }
         for each(_loc5_ in this.mCurrentHUDRootInputAdapters)
         {
            _loc7_ = _loc5_.GetVisibleObjects();
            if(_loc7_)
            {
               for each(_loc8_ in _loc7_)
               {
                  _loc9_ = (_loc8_ as ExtendableComponent).GetExtension(HighlightExtension,false) as HighlightExtension;
                  if(_loc2_ == _loc8_ || DisplayObjectUtils.IsParent(_loc8_,_loc2_) || Boolean(_loc9_) && Boolean(_loc9_.IsLinked(_loc2_)))
                  {
                     _loc10_ = WidgetUtils.GetBaseName(_loc2_);
                     if(_loc10_ == "UNKNOWN")
                     {
                        return false;
                     }
                     this.ToggleVirtualCursorMode();
                     _loc11_ = this.CurrentWidget;
                     _loc12_ = LayoutAPI.GetLoadedWidgetByName(_loc10_);
                     _loc13_ = new Point(InputUtils.sMouseX,InputUtils.sMouseY);
                     if(_loc11_ == _loc12_)
                     {
                        _loc14_ = new EnterParams(NavDirection.NONE,_loc13_,{"mouseFocusedInputAdapter":_loc5_});
                        this.FocusPan(_loc5_,_loc14_);
                     }
                     else
                     {
                        this.ChangeWidgets(_loc10_,NavDirection.LEFT,_loc13_,{"mouseFocusedInputAdapter":_loc5_});
                     }
                     _loc5_.SetHighlightedObject(_loc8_);
                     _loc5_.HandleConfirm();
                     return false;
                  }
               }
            }
         }
         _loc6_ = DisplayObjectUtils.GetParentClass(_loc2_,Slider) as Slider;
         if((Boolean(_loc6_)) && Boolean(_loc6_.ThumbBelongsToSlider(_loc2_)) && param1)
         {
            this.mHeldSlider = _loc6_;
            this.mHeldSlider[_loc2_.name].dispatchEvent(new PushButtonEvent(PushButtonEvent.PRESS));
            this.mbDraggingSlider = true;
            CommunicationManager.CallGameService("CameraSetEdgeScrollForGamepad",false,true);
            return false;
         }
         return true;
      }
      
      public function RegisterHUDRootInputAdapter(param1:InputAdapter) : void
      {
         this.mCurrentHUDRootInputAdapters.push(param1);
      }
      
      public function RegisterHUDRootInputAdapters(param1:Vector.<InputAdapter>) : void
      {
         this.mCurrentHUDRootInputAdapters = this.mCurrentHUDRootInputAdapters.concat(param1);
      }
      
      public function UnregisterHUDRootInputAdapter(param1:InputAdapter) : void
      {
         var _loc2_:int = this.mCurrentHUDRootInputAdapters.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mCurrentHUDRootInputAdapters.splice(_loc2_,1);
         }
      }
      
      public function UnregisterHUDRootInputAdapters(param1:Vector.<InputAdapter>) : void
      {
         var _loc2_:InputAdapter = null;
         for each(_loc2_ in param1)
         {
            this.UnregisterHUDRootInputAdapter(_loc2_);
         }
      }
      
      public function RegisterToIgnoreMouse(param1:DisplayObject) : void
      {
         this.mDisplayObjectsToIgnoreMouse.push(param1);
      }
      
      public function RegisterAllToIgnoreMouse(param1:Vector.<DisplayObject>) : void
      {
         this.mDisplayObjectsToIgnoreMouse = this.mDisplayObjectsToIgnoreMouse.concat(param1);
      }
      
      public function UnregisterToIgnoreMouse(param1:DisplayObject) : void
      {
         var _loc2_:int = this.mDisplayObjectsToIgnoreMouse.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mDisplayObjectsToIgnoreMouse.splice(_loc2_,1);
         }
      }
      
      public function UnregisterAllToIgnoreMouse(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1)
         {
            this.UnregisterToIgnoreMouse(_loc2_);
         }
      }
      
      public function RegisterClickableToIgnoreFocus(param1:DisplayObject) : void
      {
         this.mClickableDisplayObjectsToIgnoreFocus.push(param1);
      }
      
      public function RegisterClickablesToIgnoreFocus(param1:Vector.<DisplayObject>) : void
      {
         this.mClickableDisplayObjectsToIgnoreFocus = this.mClickableDisplayObjectsToIgnoreFocus.concat(param1);
      }
      
      public function UnregisterClickableToIgnoreFocus(param1:DisplayObject) : void
      {
         var _loc2_:int = this.mClickableDisplayObjectsToIgnoreFocus.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mClickableDisplayObjectsToIgnoreFocus.splice(_loc2_,1);
         }
      }
      
      public function UnregisterClickablesToIgnoreFocus(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1)
         {
            this.UnregisterClickableToIgnoreFocus(_loc2_);
         }
      }
      
      public function RegisterAllowedNonRootInputAdapter(param1:InputAdapter) : void
      {
         this.mAllowedNonRootInputAdapters.push(param1);
      }
      
      public function UnregisterAllowedNonRootInputAdapter(param1:InputAdapter) : void
      {
         var _loc2_:int = this.mAllowedNonRootInputAdapters.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mAllowedNonRootInputAdapters.splice(_loc2_,1);
         }
      }
      
      public function InsertUnderCurrentFocusable(param1:WidgetInputFocusable, param2:uint, param3:Point = null, param4:Object = null) : void
      {
         var _loc9_:IInputFocusable = null;
         this.ClearHighlight();
         var _loc5_:WidgetInputFocusable = this.CurrentInputFocusStack.Pop();
         if(!_loc5_)
         {
            return;
         }
         _loc5_.mFocusable.Exit();
         var _loc6_:WidgetInputFocusable = this.CurrentInputFocusStack.Peek();
         if(_loc6_ != null && _loc6_.mWidgetName == "EscapeMenu" && FOCUS_FROM_ESCAPE_MENU.indexOf(_loc5_.mWidgetName) == 1)
         {
            _loc6_ = this.CurrentInputFocusStack.Pop();
         }
         var _loc7_:WidgetBase = LayoutAPI.GetLoadedWidgetByName(param1.mWidgetName);
         this.mPendingWidget = _loc7_;
         var _loc8_:EnterParams = new EnterParams(param2,param3,param4);
         this.SetFocusChanging(true);
         if(param1.mFocusable)
         {
            _loc9_ = param1.mFocusable.Enter(_loc8_);
            this.CurrentInputFocusStack.Push(new WidgetInputFocusable(param1.mWidgetName,_loc9_));
         }
         else
         {
            _loc9_ = _loc7_.Enter(_loc8_);
            this.CurrentInputFocusStack.Push(new WidgetInputFocusable(param1.mWidgetName,_loc9_));
         }
         this.SetFocusChanging(false);
         _loc9_.Exit();
         if(_loc6_ != null && _loc6_.mWidgetName == "EscapeMenu")
         {
            this.CurrentInputFocusStack.Push(_loc6_);
         }
         var _loc10_:WidgetBase = LayoutAPI.GetLoadedWidgetByName(_loc5_.mWidgetName);
         this.mPendingWidget = _loc10_;
         this.CurrentInputFocusStack.Push(new WidgetInputFocusable(_loc5_.mWidgetName,_loc5_.mFocusable.Enter()));
         this.mPendingWidget = null;
      }
      
      public function AddToControllerSimulatedStack(param1:String) : void
      {
         var _loc2_:int = this.mVisibleWidgetsStack.indexOf(param1);
         if(_loc2_ == -1)
         {
            this.mVisibleWidgetsStack.push(param1);
         }
      }
      
      public function RemoveFromControllerSimulatedStack(param1:String) : void
      {
         var _loc2_:int = this.mVisibleWidgetsStack.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.mVisibleWidgetsStack.splice(_loc2_,1);
         }
      }
      
      public function ResetAndFocusVisibleWidgets() : void
      {
         var _loc2_:String = null;
         this.mbInResetAndFocusVisibleWidgets = true;
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState",null) as uint;
         CommunicationManager.SendUIMessage("ReinitializeGameState",{
            "oldState":GameStates.UNKNOWN,
            "newState":_loc1_,
            "bForControllerSimulatedStack":true
         });
         for each(_loc2_ in this.mVisibleWidgetsStack)
         {
            if(CommunicationManager.CallUIService("IsWidgetVisible",_loc2_))
            {
               this.FocusWidgetForward(_loc2_,null,null,true);
            }
         }
         this.mbInResetAndFocusVisibleWidgets = false;
         CommunicationManager.SendUIMessage("InputStackReset");
      }
      
      public function ToggleControllerAndMouseKeyboard() : void
      {
         if(SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.CallGameService("ToggleControllerAndMouseKeyboard");
            if(SystemUtils.UsingController)
            {
               this.ResetAndFocusVisibleWidgets();
            }
            else
            {
               this.Reset();
               this.SetMouseKeyboardRestraints();
            }
            this.ClearVirtualCursorHighlight();
         }
      }
      
      public function SetMouseKeyboardRestraints() : void
      {
         if(!SystemUtils.IsConsole)
         {
            return;
         }
         var _loc1_:Point = new Point(0,0);
         var _loc2_:Object = CommunicationManager.CallGameService("GetScreenMargins");
         var _loc3_:Point = LayoutAPI.GetStageSize();
         if(_loc2_.hasOwnProperty("marginXPct"))
         {
            _loc1_.x = _loc3_.x * (_loc2_["marginXPct"] as Number);
            _loc1_.y = _loc3_.y * (_loc2_["marginYPct"] as Number);
         }
         var _loc4_:Object = {
            "restraintLeft":_loc1_.x,
            "restraintTop":_loc1_.y,
            "restraintRight":_loc3_.x - _loc1_.x,
            "restraintBottom":_loc3_.y - _loc1_.y
         };
         CommunicationManager.CallGameService("SetEmulatedMouseBounds",_loc4_,true);
      }
      
      public function ClearVirtualCursorHighlight() : void
      {
         var _loc2_:ExtendableComponent = null;
         var _loc3_:TooltipExtension = null;
         var _loc1_:DisplayObject = Extensions.getTopMostEntity(InputUtils.sMouseX,InputUtils.sMouseY,false);
         if(!_loc1_ || !_loc1_.name)
         {
            _loc1_ = Extensions.getTopMostEntity(InputUtils.sMouseX,InputUtils.sMouseY,true);
         }
         while(_loc1_)
         {
            _loc2_ = _loc1_ as ExtendableComponent;
            if(_loc2_)
            {
               _loc3_ = _loc2_.GetExtension(TooltipExtension,false) as TooltipExtension;
               if(_loc2_ is olympus.gui.buttons.Button || _loc2_ is scaleform.clik.controls.Button)
               {
                  _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT,false));
               }
               else if(_loc3_)
               {
                  _loc3_.SendTooltipEvent(new MouseEvent(MouseEvent.ROLL_OUT,false));
               }
            }
            if(!_loc1_.parent)
            {
               return;
            }
            _loc1_ = DisplayObjectUtils.GetParentClass(_loc1_.parent,ExtendableComponent);
         }
      }
      
      public function SetForceRotateZoomAllowed(param1:Boolean) : void
      {
         this.mbForceRotateZoomAllowed = param1;
      }
      
      public function NotifyCameraController() : void
      {
         var _loc1_:InputAdapter = null;
         if(this.CurrentFocusable != null)
         {
            _loc1_ = this.CurrentFocusable as InputAdapter;
         }
         var _loc2_:Boolean = this.mbForceRotateZoomAllowed || (_loc1_ == null ? InputAdapter.IsCameraZoomAllowed() : _loc1_.IsZoomAllowed());
         var _loc3_:Boolean = this.mbForceRotateZoomAllowed || (_loc1_ == null ? InputAdapter.IsCameraRotateAllowed() : _loc1_.IsRotateAllowed());
         var _loc4_:Boolean = _loc1_ == null ? false : _loc1_.IsTravelButtonAllowed();
         var _loc5_:Boolean = false;
         if(this.mbRotateAllowed != _loc3_)
         {
            this.mbRotateAllowed = _loc3_;
            _loc5_ = true;
         }
         if(this.mbZoomAllowed != _loc2_)
         {
            this.mbZoomAllowed = _loc2_;
            _loc5_ = true;
         }
         if(this.mbTravelButtonAllowed != _loc4_)
         {
            this.mbTravelButtonAllowed = _loc4_;
            _loc5_ = true;
         }
         if(_loc5_)
         {
            CommunicationManager.CallGameService("UpdateCameraController",{
               "isRotateAllowed":this.mbRotateAllowed,
               "isZoomAllowed":this.mbZoomAllowed,
               "isTravelButtonAllowed":this.mbTravelButtonAllowed
            });
         }
      }
      
      public function ClearPendingWidget() : void
      {
         this.mPendingWidget = null;
      }
      
      public function IsWidgetPending() : Boolean
      {
         return this.mPendingWidget != null;
      }
   }
}

