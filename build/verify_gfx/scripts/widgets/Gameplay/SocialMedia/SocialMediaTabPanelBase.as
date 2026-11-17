package widgets.Gameplay.SocialMedia
{
   import flash.display.MovieClip;
   import olympus.constants.ActionCodes;
   import olympus.controls.GUIComponent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.gui.lists.ScrollList;
   import olympus.input.IInputAdapter;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.GridInputAdapter;
   import olympus.input.adapters.InputAdapterEvent;
   import olympus.input.adapters.InputAdapterLeaveEvent;
   import olympus.layout.GridLayout;
   import olympus.localization.KeysConsole;
   import olympus.utils.SystemUtils;
   
   public class SocialMediaTabPanelBase extends GUIComponent implements IInputAdapter
   {
      
      public var mcBackground:MovieClip;
      
      public var mcList:ScrollList;
      
      protected var mListAdapter:GridInputAdapter;
      
      protected var mScrollTicker:Object = new Object();
      
      protected var mLeaveCallback:Function;
      
      public function SocialMediaTabPanelBase()
      {
         super();
      }
      
      public function Initialize() : void
      {
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitializeGamepadInput();
         }
      }
      
      public function OnShow(param1:Array) : void
      {
      }
      
      public function OnTabShow(param1:Array) : void
      {
      }
      
      public function OnTabHide() : void
      {
      }
      
      public function ResizePanel(param1:Number, param2:Number) : void
      {
         this.mcBackground.width = param1;
         this.mcBackground.height = param2;
         this.mcList.width = param1;
         this.mcList.height = param2;
      }
      
      protected function InitializeGamepadInput() : void
      {
         this.mListAdapter = new GridInputAdapter(this.mcList.mGridLayout as GridLayout);
         this.mListAdapter.AutoscrollSlider(this.mcList.mSlider);
         this.mListAdapter.OnHighlightChangeCall(this.mListAdapter.ConfirmHighlight);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.LEFT_STICK_MOVE_FAKE)).AllowWhileModalOpen(true).SetLegendKey(KeysConsole.GENERIC_SCROLL);
         this.mListAdapter.AddInputAction(_loc1_);
         var _loc2_:* = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.CONFIRM)).AllowWhileModalOpen(true).SetValidCheck(null).CallFunction(this.SendConfirm);
         this.mListAdapter.AddInputAction(_loc2_);
         this.mListAdapter.OnLeaveCall(this.HandleListLeave);
      }
      
      public function IsFocused() : Boolean
      {
         return NavManager.Instance.CurrentFocusable == this.mListAdapter;
      }
      
      protected function HandleListLeave(param1:InputAdapterLeaveEvent) : void
      {
         if(Boolean(this.mLeaveCallback))
         {
            this.mLeaveCallback(param1);
         }
      }
      
      public function OnInputEventCall(param1:String, param2:Function) : IInputAdapter
      {
         if(param1 == InputAdapterEvent.LEAVE)
         {
            this.mLeaveCallback = param2;
         }
         else
         {
            this.mListAdapter.OnInputEventCall(param1,param2);
         }
         return this;
      }
      
      public function GetTargetInputAdapter() : IInputAdapter
      {
         return this.mListAdapter;
      }
      
      protected function SendConfirm() : void
      {
         var _loc1_:ISocialMediaCellView = this.mListAdapter.GetHighlightedObject() as ISocialMediaCellView;
         if(_loc1_)
         {
            _loc1_.SendConfirm();
         }
      }
      
      public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         return this.GetTargetInputAdapter().Enter(param1);
      }
      
      public function Exit() : void
      {
         this.mListAdapter.Exit();
      }
   }
}

