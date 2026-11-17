package widgets.CAS.gamepad.adapters
{
   import flash.geom.Point;
   import gamedata.CAS.shared.CASConfiguration;
   import gamedata.CAS.shared.CASStateData;
   import olympus.constants.ActionCodes;
   import olympus.events.TickerEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.NavManager;
   import olympus.input.GamepadAnalogSticks;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.InputAdapter;
   import olympus.io.CommunicationManager;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import olympus.utils.SystemUtils;
   import widgets.CAS.constants.CASSubStates;
   import widgets.CAS.constants.CASTunables;
   import widgets.ControllerLegend.ControllerLegendTunables;
   
   public class CASGameStateAdapter extends InputAdapter
   {
      
      protected var mLibraryOrDetailOpenCount:int = 0;
      
      protected var mTabOutfitLeftAction:InputAction;
      
      protected var mTabOutfitRightAction:InputAction;
      
      public function CASGameStateAdapter()
      {
         super();
      }
      
      override protected function InitializeInputs() : void
      {
         super.InitializeInputs();
         EnableTicker();
         this.mTabOutfitLeftAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_LEFT)).CallFunction(this.TabOutfitLeft).SetLowPriority(true).SetLinkedInLegend(true).SetLegendKey(KeysConsole.CAS_OUTFITS_CYCLE_OUTFIT_CATEGORY,ControllerLegendTunables.TEXT_COLOR_NORMAL).SetValidCheck(this.ShouldShowTabOutfit);
         this.mTabOutfitRightAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TAB_RIGHT)).CallFunction(this.TabOutfitRight).SetLowPriority(true).SetLinkedInLegend(true).SetLegendKey(KeysConsole.CAS_OUTFITS_CYCLE_OUTFIT_CATEGORY,ControllerLegendTunables.TEXT_COLOR_NORMAL).SetValidCheck(this.ShouldShowTabOutfit);
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.RIGHT_STICK_MOVE_FAKE)).SetLegendKey(KeysConsole.CAS_ROTATE_SIM).SetValidCheck(this.ShouldShowRotateSimLegend);
         AddInputAction(_loc1_);
      }
      
      override protected function OnEntered(param1:EnterParams = null) : IInputFocusable
      {
         super.OnEntered(param1);
         InputActionManager.AutoregisterActions([this.mTabOutfitLeftAction,this.mTabOutfitRightAction]);
         CommunicationManager.AddMessageListenerByName("CASLibraryEntered",this.HandleLibraryOrDetailOpen,"CASGameStateAdapter");
         CommunicationManager.AddMessageListenerByName("CASLibraryDetailEntered",this.HandleLibraryOrDetailOpen,"CASGameStateAdapter");
         return GetStackFocusable(param1);
      }
      
      override public function Exit() : void
      {
         super.Exit();
         InputActionManager.AutounregisterActions([this.mTabOutfitLeftAction,this.mTabOutfitRightAction]);
         CommunicationManager.RemoveMessageListenerByName("CASLibraryEntered",this.HandleLibraryOrDetailOpen,"CASGameStateAdapter");
         CommunicationManager.RemoveMessageListenerByName("CASLibraryDetailEntered",this.HandleLibraryOrDetailOpen,"CASGameStateAdapter");
      }
      
      override protected function Tick(param1:TickerEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.Tick(param1);
         if(!CommunicationManager.CallUIService("IsModalVisible") && this.ShouldShowRotateSimLegend())
         {
            _loc2_ = GamepadAnalogSticks.GetRightStickValuesWithDeadzone();
            if(_loc2_.x != 0)
            {
               _loc3_ = SystemUtils.IsPS4 ? CASTunables.GAMEPAD_SIM_ROTATE_SPEED_PS4 : CASTunables.GAMEPAD_SIM_ROTATE_SPEED_XB1;
               CommunicationManager.CallGameService("UIRotateSim",_loc2_.x * _loc3_,true);
            }
            if(_loc2_.y != 0)
            {
               _loc4_ = SystemUtils.IsPS4 ? CASTunables.GAMEPAD_SIM_ZOOM_SPEED_PS4 : CASTunables.GAMEPAD_SIM_ZOOM_SPEED_XB1;
               CommunicationManager.CallGameService("UIZoomSim",_loc2_.y * _loc4_,true);
            }
         }
      }
      
      protected function TabOutfitLeft() : void
      {
         CommunicationManager.SendUIMessage("TabThroughOutfits",-1);
      }
      
      protected function TabOutfitRight() : void
      {
         CommunicationManager.SendUIMessage("TabThroughOutfits",1);
      }
      
      protected function ShouldShowRotateSimLegend() : Boolean
      {
         var _loc1_:uint = CASStateData.GetCASSubState();
         return !this.mLibraryOrDetailOpenCount && _loc1_ != CASSubStates.STORIES && !CASSubStates.AnyExpeditedSimState(_loc1_);
      }
      
      protected function ShouldShowTabOutfit() : Boolean
      {
         var _loc1_:uint = CASStateData.GetCASSubState();
         return !CASConfiguration.IsConfigured(CASConfiguration.SHOW_CAREER_LOOKS_ONLY) && !CASConfiguration.IsConfigured(CASConfiguration.SHOW_SMALL_BUSINESS_LOOKS_ONLY) && _loc1_ != CASSubStates.PETPAINTING && _loc1_ != CASSubStates.STORIES && !CASSubStates.AnyExpeditedSimState(_loc1_) && NavManager.Instance.IsInCursorMode && !CASConfiguration.IsFashionMode && !CASStateData.TattooMode;
      }
      
      protected function HandleLibraryOrDetailOpen(param1:Boolean) : void
      {
         if(param1)
         {
            this.mLibraryOrDetailOpenCount += 1;
         }
         else
         {
            --this.mLibraryOrDetailOpenCount;
         }
      }
   }
}

