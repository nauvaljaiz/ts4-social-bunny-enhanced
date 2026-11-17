package olympus.io
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import olympus.constants.ActionCodes;
   import olympus.core.data.Multimap;
   import olympus.core.data.StrictMultimap;
   import olympus.gamepad.NavManager;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.localization.KeysConsole;
   import olympus.utils.SystemUtils;
   
   public class InputActionManager extends EventDispatcher
   {
      
      protected static var sInstance:InputActionManager;
      
      public static const EVENT_REGISTERED_ACTIONS_CHANGED:String = "inputActionManagerRegisteredActionsChanged";
      
      public static const ACTION_CODE_HINT_ORDER:Array = new Array(ActionCodes.DELETE,ActionCodes.CONTEXT_MENU,ActionCodes.TOGGLE_GRID);
      
      protected var mActionsMap:Multimap = new StrictMultimap(InputAction);
      
      protected var mCurrentGameState:uint;
      
      protected var mIgnoreRequestCount:int;
      
      public function InputActionManager()
      {
         super();
         if(sInstance)
         {
            return;
         }
         sInstance = this;
      }
      
      public static function RegisterAction(param1:InputAction) : Boolean
      {
         var _loc2_:Boolean = sInstance.RegisterAction(param1);
         NotifyRegisteredActionsChanged();
         return _loc2_;
      }
      
      public static function UnregisterAction(param1:InputAction) : void
      {
         sInstance.UnregisterAction(param1);
         NotifyRegisteredActionsChanged();
      }
      
      public static function AutoregisterActions(param1:Array) : Boolean
      {
         var _loc3_:InputAction = null;
         var _loc2_:Boolean = true;
         for each(_loc3_ in param1)
         {
            if(!sInstance.RegisterAction(_loc3_))
            {
               _loc2_ = false;
            }
         }
         NotifyRegisteredActionsChanged();
         return _loc2_;
      }
      
      public static function AutounregisterActions(param1:Array) : void
      {
         var _loc2_:InputAction = null;
         for each(_loc2_ in param1)
         {
            sInstance.UnregisterAction(_loc2_);
         }
         NotifyRegisteredActionsChanged();
      }
      
      public static function NotifyRegisteredActionsChanged() : void
      {
         sInstance.dispatchEvent(new Event(EVENT_REGISTERED_ACTIONS_CHANGED));
         CommunicationManager.SendUIMessage(EVENT_REGISTERED_ACTIONS_CHANGED);
      }
      
      public static function AddRegisteredActionsChangedCallback(param1:Function) : void
      {
         sInstance.addEventListener(EVENT_REGISTERED_ACTIONS_CHANGED,param1,false,0,true);
      }
      
      public static function RemoveRegisteredActionsChangedCallback(param1:Function) : void
      {
         sInstance.removeEventListener(EVENT_REGISTERED_ACTIONS_CHANGED,param1);
      }
      
      public static function set IgnoreAllInputActions(param1:Boolean) : void
      {
         if(param1)
         {
            ++sInstance.mIgnoreRequestCount;
         }
         else
         {
            --sInstance.mIgnoreRequestCount;
            if(sInstance.mIgnoreRequestCount < 0)
            {
               sInstance.mIgnoreRequestCount = 0;
            }
         }
      }
      
      protected static function CompareInputActions(param1:InputAction, param2:InputAction) : Number
      {
         return param2.priority - param1.priority;
      }
      
      public static function GetInputActionsWithLegends() : Array
      {
         return sInstance.GetInputActionsWithLegends();
      }
      
      public static function GetControllerHints(param1:Boolean = false) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:InputAction = null;
         var _loc5_:String = null;
         var _loc2_:String = "";
         for each(_loc3_ in ACTION_CODE_HINT_ORDER)
         {
            _loc4_ = sInstance.GetInputActionWithHint(_loc3_);
            if((Boolean(_loc4_)) && (!_loc4_.bHideTooltipHint || param1))
            {
               _loc5_ = "<br/>";
               switch(_loc3_)
               {
                  case ActionCodes.DELETE:
                     _loc5_ += KeysConsole.BUTTON_ICON_FACE_UP;
                     break;
                  case ActionCodes.CONTEXT_MENU:
                     _loc5_ += KeysConsole.BUTTON_ICON_FACE_LEFT;
                     break;
                  case ActionCodes.TOGGLE_GRID:
                     _loc5_ += KeysConsole.BUTTON_ICON_R_STICK_CLICK;
                     break;
                  default:
                     continue;
               }
               _loc5_ += "&nbsp;" + _loc4_.legendKey.toString();
               _loc2_ += _loc5_;
            }
         }
         return _loc2_;
      }
      
      public static function GetInputActionWithLegend(param1:uint) : InputAction
      {
         return sInstance.GetInputActionWithLegend(param1);
      }
      
      public static function GetInputActionWithQuickLegend(param1:uint) : InputAction
      {
         return sInstance.GetInputActionWithQuickLegend(param1);
      }
      
      public static function CanInputActionTrigger(param1:InputAction, param2:Boolean = false) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc3_:Array = sInstance.mActionsMap.IterateValues(param1.inputTrigger.toString());
         if(_loc3_.length == 0)
         {
            return false;
         }
         _loc3_.sort(CompareInputActions);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ == param1)
            {
               return sInstance.HasValidCriteria(param1,param2);
            }
            if(_loc4_ != param1)
            {
               if(sInstance.HasValidCriteria(_loc4_,param2))
               {
                  if(!SystemUtils.UsingController || Boolean(_loc4_.ShouldKillPropagation()))
                  {
                     return false;
                  }
               }
            }
         }
         return false;
      }
      
      protected function RegisterAction(param1:InputAction) : Boolean
      {
         var _loc3_:InputAction = null;
         var _loc2_:Array = this.mActionsMap.IterateValues(param1.inputTrigger.toString());
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc2_[0] as InputAction;
            if(_loc3_.IsExclusive())
            {
               return false;
            }
            if(param1.IsExclusive())
            {
               return false;
            }
         }
         this.mActionsMap.Insert(param1.inputTrigger.toString(),param1);
         return true;
      }
      
      protected function UnregisterAction(param1:InputAction) : void
      {
         if(Boolean(param1) && Boolean(param1.inputTrigger))
         {
            this.mActionsMap.Remove(param1.inputTrigger.toString(),param1);
         }
      }
      
      public function set currentGameState(param1:uint) : void
      {
         this.mCurrentGameState = param1;
      }
      
      public function HandleLowPriorityInput(param1:Object) : Boolean
      {
         var _loc2_:InputTrigger = InputTrigger.FromKeyBinding(param1.keyCode,param1.modifiers);
         return this.CheckTrigger(_loc2_,true);
      }
      
      public function HandleHighPriorityInput(param1:Object) : Boolean
      {
         var _loc2_:InputTrigger = InputTrigger.FromKeyBinding(param1.keyCode,param1.modifiers);
         return this.CheckTrigger(_loc2_,false);
      }
      
      public function HandleLowPriorityActionInput(param1:Object) : Boolean
      {
         var _loc2_:InputTrigger = InputTrigger.FromActionCode(param1.actionCode,param1.isDown);
         return this.CheckTrigger(_loc2_,true);
      }
      
      public function HandleHighPriorityActionInput(param1:Object) : Boolean
      {
         var _loc2_:InputTrigger = InputTrigger.FromActionCode(param1.actionCode,param1.isDown);
         return this.CheckTrigger(_loc2_,false);
      }
      
      protected function CheckTrigger(param1:InputTrigger, param2:Boolean) : Boolean
      {
         var _loc5_:InputAction = null;
         if(this.mIgnoreRequestCount > 0)
         {
            return false;
         }
         var _loc3_:Array = this.mActionsMap.IterateValues(param1.toString());
         _loc3_.sort(CompareInputActions);
         var _loc4_:Boolean = false;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.IsLowPriority() == param2)
            {
               if(this.HasValidCriteria(_loc5_))
               {
                  if(_loc5_.TriggerActions())
                  {
                     _loc4_ = true;
                     if(!SystemUtils.UsingController || _loc5_.ShouldKillPropagation())
                     {
                        break;
                     }
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public function GetInputActionsWithLegends() : Array
      {
         var _loc3_:InputAction = null;
         var _loc1_:Array = this.mActionsMap.IterateValues();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(Boolean(_loc3_.inputTrigger.InputTriggerType == InputTrigger.TYPE_ACTIONCODE) && Boolean(_loc3_.legendKey) && this.HasValidCriteria(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      protected function GetInputActionWithHint(param1:uint) : InputAction
      {
         var _loc4_:InputAction = null;
         var _loc2_:InputTrigger = InputTrigger.FromActionCode(param1,true);
         var _loc3_:Array = this.mActionsMap.IterateValues(_loc2_.toString());
         _loc2_ = InputTrigger.FromActionCode(param1,false);
         _loc3_ = _loc3_.concat(this.mActionsMap.IterateValues(_loc2_.toString()));
         _loc3_.sort(CompareInputActions);
         for each(_loc4_ in _loc3_)
         {
            if(Boolean(_loc4_.legendKey) && Boolean(_loc4_.ProvideHint) && this.HasValidCriteria(_loc4_))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function GetInputActionWithLegend(param1:uint) : InputAction
      {
         var _loc4_:InputAction = null;
         var _loc2_:InputAction = null;
         var _loc3_:Array = this.mActionsMap.IterateValues();
         for each(_loc4_ in _loc3_)
         {
            if(Boolean(_loc4_.inputTrigger.InputTriggerType == InputTrigger.TYPE_ACTIONCODE && param1 == _loc4_.inputTrigger.Code) && Boolean(_loc4_.legendKey) && this.HasValidCriteria(_loc4_))
            {
               _loc2_ = _loc4_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function GetInputActionWithQuickLegend(param1:uint) : InputAction
      {
         var _loc4_:InputAction = null;
         var _loc2_:InputAction = null;
         var _loc3_:Array = this.mActionsMap.IterateValues();
         for each(_loc4_ in _loc3_)
         {
            if(Boolean(_loc4_.inputTrigger.InputTriggerType == InputTrigger.TYPE_ACTIONCODE && param1 == _loc4_.inputTrigger.Code && _loc4_.legendKey) && Boolean(_loc4_.IsValidForQuickLegend()) && this.HasValidCriteria(_loc4_))
            {
               _loc2_ = _loc4_;
               break;
            }
         }
         return _loc2_;
      }
      
      protected function HasValidCriteria(param1:InputAction, param2:* = false) : Boolean
      {
         if(!param1.IsValid())
         {
            return false;
         }
         if(!param1.InGameState(this.mCurrentGameState))
         {
            return false;
         }
         if(!param2 && !param1.IsAllowedDuringLoadingScreen() && Boolean(CommunicationManager.CallUIService("IsUILoadingScreenVisible")))
         {
            return false;
         }
         if(!param1.IsAllowedWhileModalOpen() && (Boolean(CommunicationManager.CallUIService("IsModalVisible")) || Boolean(CommunicationManager.CallUIService("IsDialogModalVisible"))))
         {
            return false;
         }
         if(SystemUtils.UsingController && param1.InExcludedWidget(NavManager.Instance.CurrentWidgetName))
         {
            return false;
         }
         return true;
      }
   }
}

