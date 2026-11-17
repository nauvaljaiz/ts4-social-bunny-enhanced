package olympus.input
{
   import olympus.constants.ActionCodes;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class InputAction
   {
      
      public var priority:uint = 0;
      
      public var inputTrigger:InputTrigger;
      
      public var legendKey:LocKey;
      
      public var quickLegendKey:LocKey;
      
      public var textColor:uint = 0;
      
      public var bHideTooltipHint:Boolean = false;
      
      protected var mCallbacks:Vector.<Function> = new Vector.<Function>();
      
      protected var mGameStateBlackList:Array = new Array();
      
      protected var mGameStateWhiteList:Array = new Array();
      
      protected var mWidgetBlackList:Array = new Array();
      
      protected var mbAllowedDuringLoadingScreen:Boolean = false;
      
      protected var mbIsLowPriority:Boolean = false;
      
      protected var mbAllowedWhileModalOpen:Boolean = false;
      
      protected var mbKillPropagation:* = false;
      
      protected var mValidQuickLegendCheck:Function = null;
      
      protected var mValidCheck:Function = null;
      
      protected var mbIsLinkedInLegend:Boolean = false;
      
      protected var mbProvideHint:Boolean = false;
      
      public function InputAction(param1:InputTrigger)
      {
         super();
         this.inputTrigger = param1;
         if(this.inputTrigger.InputTriggerType == InputTrigger.TYPE_ACTIONCODE)
         {
            this.mbProvideHint = this.inputTrigger.Code == ActionCodes.DELETE || this.inputTrigger.Code == ActionCodes.CONTEXT_MENU;
         }
      }
      
      public static function WhenTriggered(param1:InputTrigger) : InputAction
      {
         return new InputAction(param1);
      }
      
      public function SetProvideHint(param1:Boolean) : InputAction
      {
         this.mbProvideHint = param1;
         return this;
      }
      
      public function get ProvideHint() : Boolean
      {
         return this.mbProvideHint;
      }
      
      public function get IsLinkedInLegend() : Boolean
      {
         return this.mbIsLinkedInLegend;
      }
      
      public function SetLinkedInLegend(param1:Boolean) : InputAction
      {
         this.mbIsLinkedInLegend = param1;
         return this;
      }
      
      public function SetQuickLegendKey(param1:LocKey) : InputAction
      {
         this.quickLegendKey = param1;
         return this;
      }
      
      public function QuickLegendKey() : LocKey
      {
         if(Boolean(this.quickLegendKey) && this.mbIsLinkedInLegend)
         {
            return this.quickLegendKey;
         }
         return this.legendKey;
      }
      
      public function SetLegendKey(param1:LocKey, param2:uint = 0, param3:Boolean = false) : InputAction
      {
         this.legendKey = param1;
         this.textColor = param2;
         this.bHideTooltipHint = param3;
         return this;
      }
      
      public function SetValidCheck(param1:Function) : InputAction
      {
         this.mValidCheck = param1;
         return this;
      }
      
      public function IsValid() : Boolean
      {
         return this.mValidCheck == null || Boolean(this.mValidCheck());
      }
      
      public function SetValidQuickLegendCheck(param1:Function) : InputAction
      {
         this.mValidQuickLegendCheck = param1;
         return this;
      }
      
      public function IsValidForQuickLegend() : Boolean
      {
         return Boolean(this.mValidQuickLegendCheck) ? Boolean(this.mValidQuickLegendCheck()) : this.IsValid();
      }
      
      public function SetValidCheckUIService(param1:String, param2:Object = null, param3:Boolean = true) : InputAction
      {
         var messageName:String = param1;
         var args:Object = param2;
         var bCheckIfTrue:Boolean = param3;
         this.mValidCheck = function():Boolean
         {
            return CommunicationManager.CallUIService(messageName,args) == bCheckIfTrue;
         };
         return this;
      }
      
      public function SetValidCheckGameService(param1:String, param2:Object = null, param3:Boolean = true) : InputAction
      {
         var messageName:String = param1;
         var args:Object = param2;
         var bCheckIfTrue:Boolean = param3;
         this.mValidCheck = function():Boolean
         {
            return CommunicationManager.CallGameService(messageName,args) == bCheckIfTrue;
         };
         return this;
      }
      
      public function SetPriority(param1:uint) : InputAction
      {
         this.priority = param1;
         return this;
      }
      
      public function SetKillPropagation(param1:Boolean) : InputAction
      {
         this.mbKillPropagation = param1;
         return this;
      }
      
      public function ShouldKillPropagation() : Boolean
      {
         return this.mbKillPropagation;
      }
      
      public function DispatchUIMessage(param1:String, param2:Object = null) : InputAction
      {
         var messageName:String = param1;
         var args:Object = param2;
         var func:Function = function():void
         {
            CommunicationManager.SendUIMessage(messageName,args);
         };
         this.mCallbacks.push(func);
         return this;
      }
      
      public function CallGameService(param1:String, param2:Object = null, param3:Boolean = false) : InputAction
      {
         var messageName:String = param1;
         var args:Object = param2;
         var allowUnavailable:Boolean = param3;
         var func:Function = function():void
         {
            CommunicationManager.CallGameService(messageName,args,allowUnavailable);
         };
         this.mCallbacks.push(func);
         return this;
      }
      
      public function CallFunction(param1:Function) : InputAction
      {
         this.mCallbacks.push(param1);
         return this;
      }
      
      public function RestrictToGameStates(... rest) : InputAction
      {
         this.mGameStateWhiteList = this.mGameStateWhiteList.concat(rest);
         return this;
      }
      
      public function ExcludeFromGameStates(... rest) : InputAction
      {
         this.mGameStateBlackList = this.mGameStateBlackList.concat(rest);
         return this;
      }
      
      public function ExcludeFromWidgetsFocused(... rest) : InputAction
      {
         this.mWidgetBlackList = this.mWidgetBlackList.concat(rest);
         return this;
      }
      
      public function AllowDuringLoadingScreen(param1:Boolean) : InputAction
      {
         this.mbAllowedDuringLoadingScreen = param1;
         return this;
      }
      
      public function IsAllowedDuringLoadingScreen() : Boolean
      {
         return this.mbAllowedDuringLoadingScreen;
      }
      
      public function AllowWhileModalOpen(param1:Boolean = true) : InputAction
      {
         this.mbAllowedWhileModalOpen = param1;
         return this;
      }
      
      public function IsAllowedWhileModalOpen() : Boolean
      {
         return this.mbAllowedWhileModalOpen;
      }
      
      public function SetLowPriority(param1:Boolean) : InputAction
      {
         this.mbIsLowPriority = param1;
         return this;
      }
      
      public function IsLowPriority() : Boolean
      {
         return this.mbIsLowPriority;
      }
      
      public function InGameState(param1:uint) : Boolean
      {
         if(this.mGameStateBlackList.length > 0 && this.mGameStateBlackList.indexOf(param1) != -1)
         {
            return false;
         }
         if(this.mGameStateWhiteList.length > 0 && this.mGameStateWhiteList.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function InExcludedWidget(param1:String) : Boolean
      {
         return this.mWidgetBlackList.indexOf(param1) >= 0;
      }
      
      public function IsExclusive() : Boolean
      {
         return this.priority == uint.MAX_VALUE;
      }
      
      public function TriggerActions() : Boolean
      {
         var _loc2_:Function = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.mCallbacks)
         {
            if(_loc2_())
            {
               _loc1_ = true;
            }
         }
         return !_loc1_;
      }
   }
}

