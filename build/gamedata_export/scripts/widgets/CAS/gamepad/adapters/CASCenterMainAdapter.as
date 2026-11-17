package widgets.CAS.gamepad.adapters
{
   import gamedata.CAS.shared.CASConfiguration;
   import gamedata.CAS.shared.CASStateData;
   import olympus.constants.ActionCodes;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.CAS.gamepad.CASActionCodes;
   
   public class CASCenterMainAdapter extends VirtualCursorInputAdapter
   {
      
      protected var mbFocusBodyOnBack:Boolean = false;
      
      public function CASCenterMainAdapter()
      {
         super();
      }
      
      override protected function InitializeInputs() : void
      {
         var openMenuAction:InputAction = null;
         var holdToModifyAction:InputAction = null;
         var openDesignerAction:InputAction = null;
         var selectPreviousSim:InputAction = null;
         var selectNextSim:InputAction = null;
         var randomizeSim:InputAction = null;
         var dpadUpAction:InputAction = null;
         var dpadDownAction:InputAction = null;
         super.InitializeInputs();
         SetMouseButtonActions(MOUSEACTION_DOWN,MOUSEACTION_UP);
         CenterVirtualCursor();
         EnableTicker();
         SetConfirmActionLegend(null);
         OnBackCall(this.OnBack);
         if(!CASConfiguration.IsTattooOnlyMode)
         {
            openMenuAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.OPEN_CONTEXT_MENU)).DispatchUIMessage("CASOpenContextMenuFromZoomState").SetLegendKey(KeysConsole.CAS_DISPLAY_OPTIONS);
            holdToModifyAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.MODIFY_BODY)).SetLegendKey(KeysConsole.CAS_MODIFY_BODY).SetValidCheck(this.ShouldShowModifyBody);
            openDesignerAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.OPEN_VARIATIONS_FOR_PART)).SetLegendKey(KeysConsole.CAS_DESIGN_OPTIONS);
            selectPreviousSim = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.SELECT_PREVIOUS_SIM)).DispatchUIMessage("CASSelectPreviousSim").SetLinkedInLegend(true).SetValidCheckUIService("CASSimSelectorCanSelectPreviousNextSim").SetQuickLegendKey(KeysConsole.CAS_SELECT_PREVIOUS_NEXT_SIM).SetLegendKey(KeysConsole.CAS_SELECT_PREVIOUS_SIM);
            selectNextSim = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.SELECT_NEXT_SIM)).DispatchUIMessage("CASSelectNextSim").SetLinkedInLegend(true).SetValidCheckUIService("CASSimSelectorCanSelectPreviousNextSim").SetLegendKey(KeysConsole.CAS_SELECT_NEXT_SIM);
            randomizeSim = InputAction.WhenTriggered(InputTrigger.FromActionCode(CASActionCodes.RANDOMIZE)).DispatchUIMessage("CASSelectRandomizeSim").SetValidQuickLegendCheck(function():*
            {
               return false;
            }).SetLegendKey(KeysConsole.CAS_RANDOMIZE_SIM);
            dpadUpAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_UP)).CallFunction(this.OnDPadUp).ExcludeFromWidgetsFocused("TutorialTip","CASStories","GuidanceTips").SetValidQuickLegendCheck(function():*
            {
               return false;
            }).SetLegendKey(KeysConsole.CAS_SNAP_TO_IDENTITY);
            dpadDownAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.NAVIGATE_DOWN)).CallFunction(this.OnDPadDown).ExcludeFromWidgetsFocused("TutorialTip","CASStories","GuidanceTips").SetValidQuickLegendCheck(function():*
            {
               return false;
            }).SetLegendKey(KeysConsole.CAS_SNAP_TO_SIMS);
            AddInputActions([openMenuAction,holdToModifyAction,openDesignerAction,selectPreviousSim,selectNextSim,randomizeSim,dpadUpAction,dpadDownAction]);
         }
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         return super.OnEntered(param1);
      }
      
      override protected function OnExited() : void
      {
         super.OnExited();
         CommunicationManager.SendUIMessage("CASHideCursorAttachment");
      }
      
      protected function OnBack() : void
      {
         if(CASConfiguration.IsTattooOnlyMode)
         {
            CommunicationManager.SendUIMessage("ShowCASCustomizer",{"setZoomState":false});
            CASStateData.TattooMode = true;
         }
         else if(this.mbFocusBodyOnBack)
         {
            CommunicationManager.CallGameService("CasSetCameraModeBody");
         }
      }
      
      protected function OnDPadUp() : void
      {
         NavManager.Instance.SwitchToHUDModeAndResetFocusToWidget("CASNameField");
      }
      
      protected function OnDPadDown() : void
      {
         NavManager.Instance.SwitchToHUDModeAndResetFocusToWidget("CASSimSelector");
      }
      
      public function SetFocusBodyOnBack(param1:Boolean) : void
      {
         this.mbFocusBodyOnBack = param1;
      }
      
      protected function ShouldShowModifyBody() : Boolean
      {
         return !CASConfiguration.IsConfigured(CASConfiguration.SHOW_CAREER_LOOKS_ONLY) && !CASConfiguration.IsConfigured(CASConfiguration.CONFIG_SMALL_BUSINESS_UNIFORM);
      }
   }
}

