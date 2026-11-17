package olympus.dialog
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import olympus.constants.DialogModality;
   import olympus.constants.GameStates;
   import olympus.constants.WindowAnimation;
   import olympus.core.widget.WidgetBase;
   import olympus.events.GenericEvent;
   import olympus.gamepad.LayoutAPI;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.interfaces.IAnimation;
   import olympus.io.CommunicationManager;
   import olympus.motion.Tween;
   import olympus.motion.TweenParams;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.SystemUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.managers.FocusHandler;
   import widgets.Dialog.constants.DialogTunables;
   import widgets.Dialog.constants.GenericDialogOption;
   
   public class DialogManager
   {
      
      protected static var mInstance:DialogManager;
      
      public static const DIALOG_MAIN_OK_CONFIRM_EVENT:String = "DialogMainOKConfirm";
      
      protected static const CLOCK_PAUSE_HANDLE_NAME:String = "Dialog Manager Set Dialog Visible";
      
      protected var mDialogMain:DisplayObjectContainer;
      
      protected var mModalityMask:Sprite;
      
      protected var mCurrentDialogRequest:DialogRequest;
      
      protected var mTimeoutTimer:Timer;
      
      protected var mDialogMultiQueue:Vector.<Vector.<DialogRequest>>;
      
      protected var mbInWorldSelectedTransition:Boolean;
      
      protected var mbPauseRequested:Boolean = false;
      
      protected var mLastDialogId:uint = 0;
      
      protected var mAnimatedOutDialogId:String;
      
      public function DialogManager(param1:DisplayObjectContainer)
      {
         super();
         mInstance = this;
         this.mDialogMain = param1;
         this.mDialogMultiQueue = new Vector.<Vector.<DialogRequest>>(DialogModality.SYSTEM + 1,true);
         this.mDialogMultiQueue[DialogModality.NONE] = new Vector.<DialogRequest>();
         this.mDialogMultiQueue[DialogModality.LOCAL] = new Vector.<DialogRequest>();
         this.mDialogMultiQueue[DialogModality.GAMEPLAY] = new Vector.<DialogRequest>();
         this.mDialogMultiQueue[DialogModality.SYSTEM] = new Vector.<DialogRequest>();
         CommunicationManager.RegisterServiceHandler("IsDialogModalVisible",this.HandleIsDialogModalVisible,param1);
         CommunicationManager.AddMessageListener("GameStateChanged",this.HandleGameStateChanged,param1);
         if(SystemUtils.UsingController)
         {
            CommunicationManager.AddMessageListener("WorldSelectionTransitionStarted",this.HandleWorldSelectionTransitionStarted,param1);
         }
      }
      
      public static function IsInstantiated() : Boolean
      {
         return mInstance != null;
      }
      
      public static function RequestDialog(param1:DialogRequest) : String
      {
         CommunicationManager.CallGameService("UIExitVideoMode",{},true);
         return mInstance.ProcessDialogRequest(param1);
      }
      
      public static function CancelRequest(param1:String, param2:Boolean = true) : Boolean
      {
         return mInstance.CancelRequest(param1,param2);
      }
      
      public static function CancelAllRequests() : void
      {
         var _loc3_:Vector.<DialogRequest> = null;
         CancelCurrentRequest(false);
         var _loc1_:int = int(mInstance.mDialogMultiQueue.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = mInstance.mDialogMultiQueue[_loc2_];
            if(_loc3_.length > 0)
            {
               _loc3_.splice(0,_loc3_.length);
            }
            _loc2_++;
         }
      }
      
      public static function HasRequest(param1:String) : Boolean
      {
         return mInstance.HasRequest(param1);
      }
      
      public static function CancelCurrentRequest(param1:Boolean = true) : void
      {
         if(!mInstance.mCurrentDialogRequest)
         {
            return;
         }
         mInstance.CancelRequest(mInstance.mCurrentDialogRequest.data.dialog_id,param1);
      }
      
      public static function GetCurrentRequest() : DialogRequest
      {
         return mInstance.mCurrentDialogRequest;
      }
      
      public static function RequestPause() : void
      {
         if(mInstance.mbPauseRequested)
         {
            return;
         }
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"clock.request_pause",
            "commandArgs":[CLOCK_PAUSE_HANDLE_NAME]
         });
         mInstance.mbPauseRequested = true;
      }
      
      public static function RequestUnpause() : void
      {
         if(!mInstance.mbPauseRequested)
         {
            return;
         }
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"clock.unrequest_pause",
            "commandArgs":[CLOCK_PAUSE_HANDLE_NAME]
         });
         mInstance.mbPauseRequested = false;
      }
      
      public static function HandleEscapeKey() : Boolean
      {
         return mInstance.HandleEscapeKey();
      }
      
      public static function HandleOKConfirm() : Boolean
      {
         return mInstance.HandleOKConfirm();
      }
      
      public function StageResized(param1:Number, param2:Number) : void
      {
         if(this.mCurrentDialogRequest)
         {
            this.mCurrentDialogRequest.dialog.Resize(param1,param2);
            this.PositionDialog(this.mCurrentDialogRequest.dialog as DisplayObject,param1,param2);
         }
      }
      
      public function HandleEscapeKey() : Boolean
      {
         if(!this.mCurrentDialogRequest)
         {
            return false;
         }
         var _loc1_:Boolean = !GenericDialogOption.HasOption(this.mCurrentDialogRequest.data.options,GenericDialogOption.DISABLE_CLOSE_BUTTON) || SystemUtils.UsingConsoleInputMode && Boolean(this.mCurrentDialogRequest.data.cancellationAction);
         if(_loc1_)
         {
            this.CancelRequest(this.mCurrentDialogRequest.data.dialog_id,true);
         }
         return true;
      }
      
      public function HandleOKConfirm() : Boolean
      {
         if(!this.mCurrentDialogRequest)
         {
            return false;
         }
         this.mCurrentDialogRequest.dialog.dispatchEvent(new GenericEvent(DIALOG_MAIN_OK_CONFIRM_EVENT));
         return true;
      }
      
      protected function ProcessDialogRequest(param1:DialogRequest) : String
      {
         var _loc7_:DialogRequest = null;
         var _loc8_:IDialogAction = null;
         var _loc9_:Vector.<DialogRequest> = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:UIComponent = null;
         var _loc14_:TweenParams = null;
         var _loc15_:int = 0;
         var _loc2_:Boolean = Boolean(CommunicationManager.CallUIService("IsTransitionScreenVisible"));
         if(_loc2_ || this.mbInWorldSelectedTransition)
         {
            if(_loc2_)
            {
               CommunicationManager.AddMessageListener("TransitionScreenHidden",this.HandleTransitionScreenHideComplete,this.mDialogMain);
            }
            this.mDialogMultiQueue[param1.modality].push(param1);
            if(SystemUtils.UsingController)
            {
               NavManager.Instance.FocusWidgetForward((this.mDialogMain as WidgetBase).WidgetName);
            }
            return param1.data.dialog_id;
         }
         if(this.mCurrentDialogRequest)
         {
            if(param1.data.dialog_id)
            {
               _loc7_ = this.mCurrentDialogRequest;
               _loc8_ = param1.data.cancellationAction;
               if(param1.data.dialog_id == _loc7_.data.dialog_id)
               {
                  if(_loc8_)
                  {
                     _loc8_.Execute(param1.data);
                  }
                  return null;
               }
               _loc9_ = this.mDialogMultiQueue[param1.modality];
               _loc10_ = int(_loc9_.length);
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  _loc7_ = _loc9_[_loc11_];
                  if(param1.data.dialog_id == _loc7_.data.dialog_id)
                  {
                     if(_loc8_)
                     {
                        _loc8_.Execute(param1.data);
                     }
                     return null;
                  }
                  _loc11_++;
               }
            }
            else
            {
               param1.data.dialog_id = this.GenerateDialogId();
            }
            if(!(!this.mAnimatedOutDialogId && param1.modality > this.mCurrentDialogRequest.modality))
            {
               this.mDialogMultiQueue[param1.modality].push(param1);
               if(SystemUtils.UsingController)
               {
                  NavManager.Instance.FocusWidgetForward((this.mDialogMain as WidgetBase).WidgetName);
               }
               return param1.data.dialog_id;
            }
            _loc12_ = this.mCurrentDialogRequest.modality;
            this.mDialogMultiQueue[_loc12_].unshift(this.mCurrentDialogRequest);
            this.RemoveCurrentDialog(false);
         }
         if(!param1.data.dialog_id)
         {
            param1.data.dialog_id = this.GenerateDialogId();
         }
         this.mCurrentDialogRequest = param1;
         var _loc3_:IDialog = param1.dialog;
         _loc3_.data = param1.data;
         _loc3_.addEventListener(Event.CLOSE,this.OnDialogClosed,false,0,true);
         if(param1.data.timeout > 0)
         {
            this.mTimeoutTimer = new Timer(param1.data.timeout,1);
            this.mTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.OnDialogTimeout,false,0,true);
            this.mTimeoutTimer.start();
         }
         var _loc4_:DisplayObject = _loc3_ as DisplayObject;
         this.PositionDialog(_loc4_,LayoutAPI.StageWidth,LayoutAPI.StageHeight);
         this.mDialogMain.addChild(_loc4_);
         FocusHandler.getInstance().setFocus(_loc4_);
         CommunicationManager.SendUIMessage("ShowDialog",null);
         var _loc5_:IAnimation = _loc3_ as IAnimation;
         var _loc6_:DisplayObjectContainer = _loc3_ as DisplayObjectContainer;
         if(Boolean(_loc5_) && Boolean(_loc6_))
         {
            _loc13_ = _loc3_ as UIComponent;
            if(_loc13_)
            {
               _loc13_.validateNow();
            }
            _loc14_ = param1.tweenInParams ? param1.tweenInParams : WindowAnimation.PANEL_LARGE_HORIZ_IN;
            _loc15_ = _loc5_.AnimateIn(0,_loc14_,DialogTunables.IN_ANIMATION_REG_POINT);
            DisplayObjectUtils.CreateInputBlocker(_loc6_,_loc15_);
         }
         if(SystemUtils.UsingController)
         {
            NavManager.Instance.FocusWidgetForward((this.mDialogMain as WidgetBase).WidgetName);
            if(param1.dialog is IInputAdapter && NavManager.Instance.CurrentFocusable != param1.dialog && Boolean(this.mDialogMain))
            {
               NavManager.Instance.FocusPan(this.mDialogMain as IInputFocusable);
            }
         }
         if(SystemUtils.UsingConsoleInputMode)
         {
            CommunicationManager.SendUIMessage("HideCurrentNarrationSubtitle");
         }
         return param1.data.dialog_id;
      }
      
      protected function OnDialogClosed(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:IAnimation = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:UIComponent = null;
         var _loc6_:TweenParams = null;
         var _loc7_:int = 0;
         if(!this.mCurrentDialogRequest)
         {
            return;
         }
         if(this.mCurrentDialogRequest.bAnimateOut)
         {
            _loc2_ = this.mCurrentDialogRequest.dialog as DisplayObject;
            _loc3_ = this.mCurrentDialogRequest.dialog as IAnimation;
            _loc4_ = this.mCurrentDialogRequest.dialog as DisplayObjectContainer;
            if(Boolean(_loc3_) && Boolean(_loc4_))
            {
               _loc5_ = _loc2_ as UIComponent;
               if(_loc5_)
               {
                  _loc5_.validateNow();
               }
               _loc6_ = WindowAnimation.PANEL_OUT;
               _loc7_ = _loc3_.AnimateOut(0,_loc6_,DialogTunables.IN_ANIMATION_REG_POINT);
               DisplayObjectUtils.CreateInputBlocker(_loc4_,_loc7_,null,this.OnDialogAnimatedOut);
               this.mAnimatedOutDialogId = this.mCurrentDialogRequest.data.dialog_id;
               return;
            }
         }
         this.mAnimatedOutDialogId = null;
         this.CancelRequest(this.mCurrentDialogRequest.data.dialog_id,false);
      }
      
      protected function OnDialogAnimatedOut() : void
      {
         var _loc1_:String = null;
         if(this.mAnimatedOutDialogId)
         {
            _loc1_ = this.mAnimatedOutDialogId;
            this.mAnimatedOutDialogId = null;
            this.CancelRequest(_loc1_,false);
         }
      }
      
      protected function OnDialogTimeout(param1:TimerEvent) : void
      {
      }
      
      protected function CloseCurrentDialog(param1:Boolean) : void
      {
         this.RemoveCurrentDialog(param1);
         if(this.ProcessNextDialog())
         {
            return;
         }
         CommunicationManager.SendUIMessage("HideDialog",null);
         RequestUnpause();
      }
      
      protected function ProcessNextDialog() : Boolean
      {
         var _loc3_:Vector.<DialogRequest> = null;
         var _loc4_:DialogRequest = null;
         var _loc1_:int = int(this.mDialogMultiQueue.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.mDialogMultiQueue[_loc2_];
            if(_loc3_.length > 0)
            {
               _loc4_ = _loc3_[0];
               _loc3_.shift();
               this.ProcessDialogRequest(_loc4_);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      protected function RemoveCurrentDialog(param1:Boolean) : void
      {
         var _loc2_:DialogRequest = this.mCurrentDialogRequest;
         if(!_loc2_)
         {
            return;
         }
         FocusHandler.getInstance().setFocus(null);
         var _loc3_:DisplayObject = _loc2_.dialog as DisplayObject;
         this.mDialogMain.removeChild(_loc3_);
         if(this.mTimeoutTimer)
         {
            this.mTimeoutTimer.stop();
            this.mTimeoutTimer = null;
         }
         if(param1 && Boolean(_loc2_.data.cancellationAction))
         {
            _loc2_.data.cancellationAction.Execute(_loc2_.data);
         }
         this.mCurrentDialogRequest = null;
         CommunicationManager.SendUIMessage("HideDialog",null);
      }
      
      protected function CancelRequest(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc6_:Vector.<DialogRequest> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(Boolean(this.mCurrentDialogRequest) && this.mCurrentDialogRequest.data.dialog_id == param1)
         {
            this.CloseCurrentDialog(param2);
            return true;
         }
         var _loc3_:int = int(this.mDialogMultiQueue.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this.mDialogMultiQueue[_loc5_];
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               if(_loc6_[_loc8_].data.dialog_id == param1)
               {
                  _loc6_.splice(_loc8_,1);
                  _loc4_ = true;
                  break;
               }
               _loc8_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      protected function CheckQueuedModality() : void
      {
         var _loc2_:Vector.<DialogRequest> = null;
         var _loc3_:int = 0;
         if(this.mCurrentDialogRequest)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < length)
         {
            _loc2_ = this.mDialogMultiQueue[_loc1_];
            _loc3_ = int(_loc2_.length);
            if(_loc3_ != 0)
            {
               return;
            }
            _loc1_++;
         }
         CommunicationManager.SendUIMessage("HideDialog",null);
      }
      
      protected function HasRequest(param1:String) : Boolean
      {
         var _loc4_:Vector.<DialogRequest> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(Boolean(this.mCurrentDialogRequest) && this.mCurrentDialogRequest.data.dialog_id == param1)
         {
            return true;
         }
         var _loc2_:int = int(this.mDialogMultiQueue.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.mDialogMultiQueue[_loc3_];
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(_loc4_[_loc6_].data.dialog_id == param1)
               {
                  return true;
               }
               _loc6_++;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function PositionDialog(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         Tween.StopAllTweens(param1,false,true);
         param1.x = 0.5 * (param2 - param1.width);
         param1.y = 0.5 * (param3 - param1.height);
      }
      
      protected function GenerateDialogId() : String
      {
         return "AutoDialogID" + ++this.mLastDialogId;
      }
      
      protected function HandleIsDialogModalVisible(param1:Object) : Boolean
      {
         if(!this.mCurrentDialogRequest)
         {
            return false;
         }
         if(Boolean(param1) && Boolean(this.mCurrentDialogRequest.data) && param1.dialog_id != this.mCurrentDialogRequest.data.dialog_id)
         {
            return false;
         }
         return true;
      }
      
      protected function HandleGameStateChanged(param1:Object) : void
      {
         var _loc3_:DialogRequest = null;
         var _loc4_:Vector.<DialogRequest> = null;
         var _loc5_:DialogRequest = null;
         var _loc2_:uint = param1 as uint;
         if(_loc2_ == GameStates.PLAY)
         {
            if(this.mCurrentDialogRequest)
            {
               RequestPause();
            }
         }
         if(_loc2_ == GameStates.LEAVEPLAYAREA || _loc2_ == GameStates.PHOTOGRAPHY || _loc2_ == GameStates.TRAVEL)
         {
            _loc3_ = this.mCurrentDialogRequest;
            if(_loc3_)
            {
               this.RemoveCurrentDialog(true);
               if(SystemUtils.UsingController && _loc3_.modality != DialogModality.GAMEPLAY)
               {
                  this.mDialogMultiQueue[_loc3_.modality].push(_loc3_);
                  CommunicationManager.AddMessageListener("TransitionScreenHidden",this.HandleTransitionScreenHideComplete,this.mDialogMain);
               }
            }
            _loc4_ = this.mDialogMultiQueue[DialogModality.GAMEPLAY];
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.data.cancellationAction)
               {
                  _loc5_.data.cancellationAction.Execute(_loc5_.data);
               }
            }
            _loc4_.length = 0;
         }
      }
      
      protected function HandleTransitionScreenHideComplete(param1:Object) : void
      {
         CommunicationManager.RemoveMessageListener("TransitionScreenHidden",this.HandleTransitionScreenHideComplete,this.mDialogMain);
         this.ProcessNextDialog();
         if(SystemUtils.UsingController)
         {
            CommunicationManager.SendUIMessage("TransitionCompleteDialogProcessed");
         }
      }
      
      protected function HandleWorldSelectionTransitionStarted() : void
      {
         CommunicationManager.AddMessageListener("NhdMapLoadedAndFocused",this.HandleNhdMapLoadedAndFocused,this.mDialogMain);
         this.mbInWorldSelectedTransition = true;
      }
      
      protected function HandleNhdMapLoadedAndFocused(param1:Object = null) : void
      {
         CommunicationManager.RemoveMessageListener("NhdMapLoadedAndFocused",this.HandleNhdMapLoadedAndFocused,this.mDialogMain);
         this.mbInWorldSelectedTransition = false;
         this.ProcessNextDialog();
      }
   }
}

