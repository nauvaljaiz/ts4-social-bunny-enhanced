package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavDirection;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   import widgets.ControllerLegend.ControllerLegendTunables;
   
   public class AbstractBidirectionalInputAdapter extends InputAdapter
   {
      
      protected var mbHorizontal:Boolean;
      
      protected var mHighlightedIndex:int;
      
      protected var mbTabbing:Boolean;
      
      protected var mTabbingPriority:uint = 0;
      
      protected var mbTabbingKillPropagation:Boolean = false;
      
      protected var mbTemporarilyDisableConfirm:Boolean = false;
      
      protected var mbAllowWhileModalOpen:Boolean = true;
      
      protected var mNumElemPerRowOrCol:int = -1;
      
      protected var mLeftTabActionCode:uint = 9;
      
      protected var mRightTabActionCode:uint = 10;
      
      protected var mLeftLegendLocKey:LocKey = KeysConsole.GENERIC_PREVIOUS;
      
      protected var mRightLegendLocKey:LocKey = KeysConsole.GENERIC_NEXT;
      
      public function AbstractBidirectionalInputAdapter()
      {
         super();
         this.mHighlightedIndex = -1;
         this.mTabbingPriority = 0;
         this.mbTabbingKillPropagation = false;
      }
      
      override protected function InitializeInputs() : void
      {
         var _loc1_:InputAction = null;
         var _loc2_:InputAction = null;
         super.InitializeInputs();
         if(this.mbTabbing)
         {
            _loc1_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(this.mLeftTabActionCode)).CallFunction(this.TabLeft).AllowWhileModalOpen(this.mbAllowWhileModalOpen).SetLegendKey(this.mLeftLegendLocKey,ControllerLegendTunables.TEXT_COLOR_NORMAL).SetPriority(this.mTabbingPriority).SetKillPropagation(this.mbTabbingKillPropagation);
            _loc2_ = InputAction.WhenTriggered(InputTrigger.FromActionCode(this.mRightTabActionCode)).CallFunction(this.TabRight).AllowWhileModalOpen(this.mbAllowWhileModalOpen).SetLegendKey(this.mRightLegendLocKey,ControllerLegendTunables.TEXT_COLOR_NORMAL).SetPriority(this.mTabbingPriority).SetKillPropagation(this.mbTabbingKillPropagation);
            AddInputActions([_loc1_,_loc2_]);
         }
         else
         {
            AddDirectionalInputs();
            AddConfirmAction();
         }
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         super.OnEntered(param1);
         this.mbTemporarilyDisableConfirm = Boolean(param1) && Boolean(param1.mArgs) && Boolean(param1.mArgs.skipConfirm);
         this.ApplyDefaultInitialHighlight();
         this.mbTemporarilyDisableConfirm = false;
         if(this.mbTabbing && SystemUtils.UsingMouseKeyboard)
         {
            CommunicationManager.AddMessageListenerByName("PostUsingControllerToggled",this.HandlePostUsingControllerToggled,"AbstractBidirectionalInputAdapter");
         }
         return GetStackFocusable(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         CommunicationManager.RemoveMessageListenerByName("PostUsingControllerToggled",this.HandlePostUsingControllerToggled,"AbstractBidirectionalInputAdapter");
      }
      
      protected function ApplyDefaultInitialHighlight() : void
      {
         var _loc1_:int = this.mHighlightedIndex;
         var _loc2_:DisplayObject = this.GetHighlightedObject();
         if(_loc1_ == -1 || !_loc2_ || !_loc2_.visible || !_loc2_.stage)
         {
            _loc1_ = this.GetFirstVisibleElementIndex();
         }
         this.SetHighlightedIndex(_loc1_,true);
      }
      
      public function SetTabbingSelectionMode(param1:Boolean, param2:uint = 0, param3:Boolean = false, param4:Boolean = true) : AbstractBidirectionalInputAdapter
      {
         if(mbInputsInitialized)
         {
            return this;
         }
         this.mbHorizontal = true;
         this.mbTabbing = param1;
         this.mTabbingPriority = param2;
         this.mbTabbingKillPropagation = param3;
         this.mbAllowWhileModalOpen = param4;
         return this;
      }
      
      public function SetTabActionCodes(param1:uint, param2:uint) : void
      {
         this.mLeftTabActionCode = param1;
         this.mRightTabActionCode = param2;
      }
      
      public function GetCurrentLeftActionCode() : uint
      {
         return this.mLeftTabActionCode;
      }
      
      public function GetCurrentRightActionCode() : uint
      {
         return this.mRightTabActionCode;
      }
      
      public function SetTabLegendLocKeys(param1:LocKey, param2:LocKey) : void
      {
         this.mLeftLegendLocKey = param1;
         this.mRightLegendLocKey = param2;
      }
      
      protected function GetElementAt(param1:int) : DisplayObject
      {
         return null;
      }
      
      protected function GetFirstVisibleElementIndex() : int
      {
         return 0;
      }
      
      public function GetListLength() : int
      {
         return -1;
      }
      
      public function get IsHorizontal() : Boolean
      {
         return this.mbHorizontal;
      }
      
      public function SetHorizontal(param1:Boolean) : void
      {
         this.mbHorizontal = param1;
      }
      
      public function SetNumElementsPerRowOrColumn(param1:int) : void
      {
         this.mNumElemPerRowOrCol = param1;
      }
      
      protected function TabRight() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(this.mbTabbing)
         {
            _loc1_ = this.GetHighlightedObject();
            ApplyDirectionalInput(NavDirection.RIGHT);
            _loc2_ = this.GetHighlightedObject();
            if(_loc1_ != _loc2_)
            {
               this.FireTabEvent();
            }
         }
      }
      
      protected function TabLeft() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(this.mbTabbing)
         {
            _loc1_ = this.GetHighlightedObject();
            ApplyDirectionalInput(NavDirection.LEFT);
            _loc2_ = this.GetHighlightedObject();
            if(_loc1_ != _loc2_)
            {
               this.FireTabEvent();
            }
         }
      }
      
      override public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         if(param1 == InputAdapterEvent.TAB)
         {
            return this.OnTabCall(param2);
         }
         return super.OnInputEventCall(param1,param2);
      }
      
      public function OnTabCall(param1:Function) : IInputAdapter
      {
         this.addEventListener(InputAdapterEvent.TAB,param1);
         return this;
      }
      
      final protected function FireTabEvent() : void
      {
         dispatchEvent(new InputAdapterEvent(InputAdapterEvent.TAB));
      }
      
      protected function MoveInDirection(param1:int) : void
      {
         var _loc4_:DisplayObject = null;
         if(param1 == 0)
         {
            return;
         }
         var _loc2_:int = this.mHighlightedIndex;
         var _loc3_:int = _loc2_;
         loop0:
         while(true)
         {
            _loc3_ += param1;
            if(_loc3_ < 0)
            {
               switch(mEdgeBehavior)
               {
                  case InputAdapter.EDGE_LEAVE:
                     break loop0;
                  case InputAdapter.EDGE_LOOP:
                     _loc3_ = this.GetListLength() - 1;
                     break;
                  case InputAdapter.EDGE_STOP:
                     _loc3_ = 0;
               }
            }
            else if(this.GetElementAt(_loc3_) == null)
            {
               switch(mEdgeBehavior)
               {
                  case InputAdapter.EDGE_LEAVE:
                     FireLeaveEvent(this.mbHorizontal ? NavDirection.RIGHT : NavDirection.DOWN,GetCurrentHighlightPoint());
                     return;
                  case InputAdapter.EDGE_LOOP:
                     _loc3_ = 0;
                     break;
                  case InputAdapter.EDGE_STOP:
                     _loc3_ = this.GetListLength() - 1;
               }
            }
            _loc4_ = this.GetElementAt(_loc3_) as DisplayObject;
            if(!(_loc4_ != null && !(_loc4_.visible && _loc4_.stage) && _loc3_ != _loc2_))
            {
               this.SetHighlightedIndex(_loc3_);
               return;
            }
         }
         FireLeaveEvent(this.mbHorizontal ? NavDirection.LEFT : NavDirection.UP,GetCurrentHighlightPoint());
      }
      
      override public function GetHighlightedObject() : DisplayObject
      {
         return this.GetElementAt(this.mHighlightedIndex);
      }
      
      public function SetHighlightedIndex(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = this.GetHighlightedObject();
         this.mHighlightedIndex = param1;
         var _loc4_:DisplayObject = this.GetHighlightedObject();
         if(this.mbTabbing && SystemUtils.UsingController)
         {
            if(_loc3_ != _loc4_ || param2)
            {
               if(_loc3_)
               {
                  _loc3_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT,false));
               }
               if(!this.mbTemporarilyDisableConfirm)
               {
                  this.Confirm();
               }
            }
         }
         else
         {
            ChangeHighlight(_loc3_,_loc4_,param2);
         }
      }
      
      override protected function HighlightDirection(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.HighlightDirection(param1,param2);
         if(this.mbHorizontal)
         {
            if(param2 == 0)
            {
               this.MoveInDirection(param1);
            }
            else
            {
               _loc3_ = param2 * this.mNumElemPerRowOrCol;
               _loc4_ = _loc3_ + this.mHighlightedIndex;
               if(this.mNumElemPerRowOrCol != -1 && _loc4_ >= 0 && _loc4_ < this.GetListLength())
               {
                  this.MoveInDirection(_loc3_);
               }
               else
               {
                  FireLeaveEvent(param2 < 0 ? NavDirection.UP : NavDirection.DOWN,GetCurrentHighlightPoint());
               }
            }
         }
         else if(param1 == 0)
         {
            this.MoveInDirection(param2);
         }
         else
         {
            _loc3_ = param1 * this.mNumElemPerRowOrCol;
            _loc4_ = _loc3_ + this.mHighlightedIndex;
            if(this.mNumElemPerRowOrCol != -1 && _loc4_ >= 0 && _loc4_ < this.GetListLength())
            {
               this.MoveInDirection(_loc3_);
            }
            else
            {
               FireLeaveEvent(param1 < 0 ? NavDirection.LEFT : NavDirection.RIGHT,GetCurrentHighlightPoint());
            }
         }
      }
      
      override protected function Confirm() : DisplayObject
      {
         return ConfirmSelectedObject(this.GetHighlightedObject());
      }
      
      override public function GetVisibleObjects() : Vector.<DisplayObject>
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc2_:uint = 0;
         while(_loc2_ < this.GetListLength())
         {
            _loc3_ = this.GetElementAt(_loc2_);
            if(Boolean(_loc3_) && Boolean(_loc3_.visible) && Boolean(_loc3_.stage))
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function SetHighlightedObject(param1:DisplayObject, param2:Boolean = false) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.GetListLength())
         {
            _loc4_ = this.GetElementAt(_loc3_);
            if(_loc4_ == param1)
            {
               this.SetHighlightedIndex(_loc3_,param2);
               break;
            }
            _loc3_++;
         }
      }
      
      protected function HandlePostUsingControllerToggled() : void
      {
         if(SystemUtils.UsingController)
         {
            this.SetHighlightedObject(this.GetHighlightedObject(),true);
         }
      }
   }
}

