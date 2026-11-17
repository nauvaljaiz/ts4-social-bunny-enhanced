package olympus.core
{
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import gamedata.BuildBuy.shared.BuildBuyStateData;
   import gamedata.CAS.shared.CASStateData;
   import gamedata.GameContent;
   import gamedata.GameEntry.shared.NeighborhoodStateData;
   import gamedata.Gameplay.Persistence.GameSaveComplete;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.GameClockTime;
   import olympus.constants.ActionCodes;
   import olympus.constants.DialogModality;
   import olympus.constants.DialogTypes;
   import olympus.constants.GameStateFlags;
   import olympus.constants.GameStates;
   import olympus.constants.InputActionPriorities;
   import olympus.constants.Layers;
   import olympus.core.bind3d.element.ObjectBoundElementManager;
   import olympus.core.data.SettingsMap;
   import olympus.core.interfaces.IBase;
   import olympus.core.tooltip.Tooltip;
   import olympus.dialog.DialogManager;
   import olympus.effects.IconClip;
   import olympus.events.GenericEvent;
   import olympus.gamepad.NavManager;
   import olympus.gamepad.NavStartWidgets;
   import olympus.input.InputAction;
   import olympus.input.InputMap;
   import olympus.input.InputTrigger;
   import olympus.input.adapters.InputAdapter;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.io.CommunicationManager;
   import olympus.io.CommunicationMapping;
   import olympus.io.DebugCommands;
   import olympus.io.EventManager;
   import olympus.io.InputActionManager;
   import olympus.io.TelemetryManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysBB;
   import olympus.localization.KeysCAS;
   import olympus.localization.KeysConsole;
   import olympus.localization.KeysEXCH;
   import olympus.localization.KeysGE;
   import olympus.localization.KeysGP;
   import olympus.localization.KeysPhotography;
   import olympus.localization.LocKey;
   import olympus.motion.Tween;
   import olympus.tests.TestsManager;
   import olympus.utils.DebugUtils;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   import scaleform.clik.controls.ButtonGroup;
   import scaleform.clik.managers.DragManager;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.gfx.Extensions;
   import widgets.BuildBuy.gamepad.BuildBuyNavMesh;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterMainAdapter;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyGameStateAdapter;
   import widgets.CAS.gamepad.CASNavMesh;
   import widgets.CAS.gamepad.adapters.CASCenterMainAdapter;
   import widgets.CAS.gamepad.adapters.CASGameStateAdapter;
   import widgets.Dialog.constants.GenericDialogOption;
   import widgets.GameEntry.Launcher.GELauncherMesh;
   import widgets.GameEntry.WorldSelection.WorldSelectionNavMesh;
   import widgets.Gameplay.GameplayNavMesh;
   import widgets.Gameplay.gamepad.adapters.GameplayCenterMainAdapter;
   import widgets.Gameplay.gamepad.adapters.GameplayStateAdapter;
   import widgets.UIContainer.controls.ContextMenu;
   
   public class UIManager extends MovieClip implements IBase
   {
      
      protected static const LOCK_CURSOR_OFFSET:Number = 16;
      
      public var communicationMgr:CommunicationManager;
      
      public var layoutMgr:LayoutManager;
      
      public var tooltipMgr:TooltipManager;
      
      public var boundElementMgr:ObjectBoundElementManager;
      
      public var debugCommandMgr:DebugCommands;
      
      public var mcContextMenu:ContextMenu;
      
      public var inputActionMgr:InputActionManager;
      
      public var connectionMgr:ConnectionManager;
      
      public var storeDataMgr:StoreDataManager;
      
      public var dragMgr:olympus.core.DragManager;
      
      public var liveDragMgr:LiveDragManager;
      
      public var navMgr:NavManager;
      
      public var uiScaleMgr:UIScaleManager;
      
      public var themeMgr:ThemeManager;
      
      protected var mcLockCursor:IconClip;
      
      public var mGameState:uint = 0;
      
      public var mNewGameState:uint = 0;
      
      protected var mBuildBuyMainInputAdapter:BuildBuyCenterMainAdapter;
      
      protected var mGameplayMainInputAdapter:GameplayCenterMainAdapter;
      
      protected var mCASMainInputAdapter:CASCenterMainAdapter;
      
      protected var mNeighborhoodInputAdapter:VirtualCursorInputAdapter;
      
      protected var mMainMenuInputAdapter:VirtualCursorInputAdapter;
      
      protected var mCurrentGameStateAdapter:InputAdapter;
      
      protected var mLastDisconnectedDevice:String = null;
      
      public function UIManager(param1:Boolean = true)
      {
         var _loc2_:Object = null;
         super();
         if(param1)
         {
            Extensions.enabled = true;
            Extensions.noInvisibleAdvance = true;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            TelemetryManager.Init();
            this.debugCommandMgr = new DebugCommands();
            this.communicationMgr = new CommunicationManager(new CommunicationMapping());
            this.inputActionMgr = new InputActionManager();
            InputActionManager.AutoregisterActions(InputMap.AUTO_MAP);
            if(ExternalInterface.available)
            {
               _loc2_ = ExternalInterface.call("CallGameService","IsGameClient",null);
               if(_loc2_)
               {
                  DebugUtils.SetGameClientDriven(true);
                  DebugUtils.SetDebugMode(_loc2_["isDebug"]);
                  SystemUtils.UsingController = _loc2_["usingController"];
                  SystemUtils.UsingMouseKeyboard = _loc2_["usingMouseKeyboard"];
                  SystemUtils.RazerEnabledPC = _loc2_["razerEnabledPC"];
                  SystemUtils.SwapJPControls = _loc2_["swapJPControls"];
                  SystemUtils.UsingGraphicsAPI = _loc2_["graphicsAPI"];
                  SystemUtils.DistributionPlatform = _loc2_["distributionPlatform"];
               }
            }
            this.addEventListener(GenericEvent.COMPLETE,this.OnWidgetListComplete,false,0,true);
            this.layoutMgr = new LayoutManager(this);
         }
      }
      
      public function get BaseName() : String
      {
         return "UIContainer";
      }
      
      protected function OnWidgetListComplete(param1:Event) : void
      {
         this.removeEventListener(GenericEvent.COMPLETE,this.OnWidgetListComplete);
         this.Initialize();
      }
      
      protected function Initialize() : void
      {
         ExternalInterface.call("CallGameService","NotifyUIManagerLoaded",null,true);
         this.layoutMgr.Initialize();
         this.boundElementMgr = new ObjectBoundElementManager(this.layoutMgr.GetLayer(Layers.WORLD_ELEMENTS),this.communicationMgr);
         if(DebugUtils.IsDebug())
         {
            new TestsManager(this,this.communicationMgr);
         }
         this.connectionMgr = new ConnectionManager();
         this.connectionMgr.Initialize(this);
         this.storeDataMgr = new StoreDataManager();
         this.storeDataMgr.Initialize(this);
         this.themeMgr = new ThemeManager();
         this.themeMgr.Initialize(this);
         this.mcContextMenu.Initialize(this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP),this.communicationMgr);
         this.tooltipMgr = new TooltipManager(this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP_TOOLTIP),new Tooltip());
         this.dragMgr = new olympus.core.DragManager(this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP_NO_INPUT));
         this.liveDragMgr = new LiveDragManager(this.communicationMgr,this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP_NO_INPUT));
         this.uiScaleMgr = new UIScaleManager();
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState",null) as uint;
         if(_loc1_ == GameStates.UNKNOWN)
         {
            _loc1_ = GameStates.STARTUP;
         }
         this.SetGameStateHandler(_loc1_);
         scaleform.clik.managers.DragManager.init(stage);
         PopUpManager.Init(this.layoutMgr.GetLayer(Layers.WIDGETS_POPUP),this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP_POPUP));
         stage.addEventListener(Event.RESIZE,this.StageResizeHandler,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.HandleStageMouseDown,false,0,true);
         if(!SystemUtils.UsingController)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.HandleStageMouseMove,false,0,true);
         }
         this.layoutMgr.StageResized(stage.stageWidth,stage.stageHeight);
         InputActionManager.RegisterAction(InputAction.WhenTriggered(InputTrigger.FromKeyBinding(Keyboard.ESCAPE)).CallFunction(this.HandleEscapeKey).SetPriority(InputActionPriorities.ESC_UI_MANAGER).AllowWhileModalOpen(true).ExcludeFromGameStates(GameStates.FIRST_LAUNCH,GameStates.LEGAL_AGREEMENTS));
         DebugCommands.Register("qa.ui.current_game_state",this.DebugCommandQACurrentGameState,"","Traces information about the status of the UI game state to the automation log.");
         DebugCommands.Register("ui.throw_error",this.DebugCommandThrowError,"","Forces an AS3 exception for testing purposes");
         DebugCommands.Register("ui.crashgame",this.DebugCommandCrashGame,"","Crashes the game through AS3");
         DebugUtils.SetIsUIManagerLoaded(true);
         this.communicationMgr.RegisterServiceHandler("SetGameState",this.SetGameStateHandler,"UIContainer");
         this.communicationMgr.AddMessageListener("UpdateGameClock",Time.HandleUpdateGameClock,"UIContainer",GameClockTime);
         this.communicationMgr.AddMessageListener("ShowLockCursor",this.ShowLockCursor,"UIContainer");
         this.communicationMgr.AddMessageListener("HandleEscapeKey",this.HandleEscapeKey,"UIContainer");
         this.communicationMgr.AddMessageListener("GameSaveComplete",this.HandleGameSaveComplete,"UIContainer",GameSaveComplete);
         this.communicationMgr.AddMessageListener("SetSystemUiScale",this.HandleSetSystemUIScale,"UIContainer");
         this.communicationMgr.AddMessageListener("RefreshGameContent",this.HandleRefreshGameContent,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("LowPriorityInput",this.inputActionMgr.HandleLowPriorityInput,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("HighPriorityInput",this.inputActionMgr.HandleHighPriorityInput,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("LowPriorityActionInput",this.inputActionMgr.HandleLowPriorityActionInput,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("HighPriorityActionInput",this.inputActionMgr.HandleHighPriorityActionInput,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("PromptRestartRequired",this.HandlePromptRestartRequired,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("ConfirmRestart",this.HandleConfirmRestart,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("AddUISessionSetting",this.HandleAddUISessionSetting,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("GetUISimSettings",this.HandleGetUISimSettings,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("GetUIAccountSettings",this.HandleGetUIAccountSettings,"UIContainer");
         this.communicationMgr.RegisterServiceHandler("GetUIHouseholdSettings",this.HandleGetUIHouseholdSettings,"UIContainer");
         if(!DebugUtils.IsGameClientDriven())
         {
            this.communicationMgr.CallUIService("SetGameState",GameStates.PLAY);
         }
         GameplayStateData.AddListeners(this.communicationMgr);
         BuildBuyStateData.AddListeners(this.communicationMgr);
         CASStateData.AddListeners(this.communicationMgr);
         NeighborhoodStateData.AddListeners(this.communicationMgr);
         UIScaleManager.AddListeners(this.communicationMgr);
         this.navMgr = new NavManager();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.InitGamepad();
         }
         Time.RefreshGameClockTime();
         this.communicationMgr.AddMessageListener("ToggleInput",this.HandleToggleInput,"UIContainer");
      }
      
      protected function HandleToggleInput(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(SystemUtils.UsingMouseKeyboard)
         {
            _loc2_ = CommunicationManager.CallUIService("IsWidgetVisible","TransitionScreenMolecule") as Boolean;
            if(_loc2_)
            {
               return;
            }
            _loc3_ = param1 as Boolean;
            if(this.mGameState == GameStates.MAIN_MENU || _loc3_ || this.mGameState == GameStates.LEGAL_AGREEMENTS || this.mGameState == GameStates.FIRST_LAUNCH)
            {
               NavManager.Instance.ToggleControllerAndMouseKeyboard();
            }
         }
      }
      
      public function GameStateLoadComplete() : void
      {
         GameStateFlags.IsBetweenStates = false;
         CommunicationManager.SendMessage("GameStateLoadComplete",this.mGameState);
         CommunicationManager.TraceAutomation("UIGameStateLoadComplete; state:" + GameStates.ConvertStateIdToName(this.mGameState));
         if(SystemUtils.IsConsole && !SystemUtils.UsingController)
         {
            CommunicationManager.SendUIMessage("ShowVirtualCursor");
         }
      }
      
      protected function ShowLockCursor(param1:Object) : void
      {
         var _loc2_:IconClip = null;
         if(this.mcLockCursor == null)
         {
            this.mcLockCursor = new IconClip();
            this.mcLockCursor.mouseEnabled = false;
            this.mcLockCursor.mouseChildren = false;
         }
         this.layoutMgr.GetLayer(Layers.ALWAYS_ON_TOP_NO_INPUT).addChild(this.mcLockCursor);
         _loc2_ = this.mcLockCursor;
         var _loc3_:int = param1["applyOffset"] ? int(LOCK_CURSOR_OFFSET) : 0;
         _loc2_.x = param1["lockPosX"] + _loc3_;
         _loc2_.y = param1["lockPosY"] + _loc3_;
         _loc2_.visible = param1["show"];
         _loc2_.SetData({"icon":param1["cursorId"]});
      }
      
      protected function HandleStageMouseDown(param1:MouseEvent) : void
      {
         if(param1.target == stage)
         {
            FocusHandler.getInstance().setFocus(null,0,true);
         }
      }
      
      protected function HandleStageMouseMove(param1:MouseEvent) : void
      {
         InputUtils.sMouseX = param1.stageX;
         InputUtils.sMouseY = param1.stageY;
      }
      
      protected function SetGameStateHandler(param1:uint) : Object
      {
         if(this.mGameState == GameStates.PLAY)
         {
            this.liveDragMgr.HandleGameStateUnload();
         }
         var _loc2_:uint = GameStates.ConvertGameToUIState(param1);
         if(_loc2_ != GameStates.UNKNOWN)
         {
            if(this.mGameState == _loc2_)
            {
               return false;
            }
            GameStateFlags.IsBetweenStates = true;
            ButtonGroup.RemoveGroupsForBaseName("UNKNOWN");
            this.mNewGameState = _loc2_;
            this.inputActionMgr.currentGameState = _loc2_;
            this.layoutMgr.PrepGameStateChange(_loc2_);
            setTimeout(this.HandleEnterFrame,1);
            if(this.mcContextMenu)
            {
               this.mcContextMenu.HideContextMenu(null);
            }
            Tween.KillAllTweensForLabel(this.BaseName);
            Tween.KillAllTweensForLabel("UNKNOWN");
            this.tooltipMgr.Clear();
            PopUpManager.Unload();
            this.dragMgr.Clear();
         }
         return true;
      }
      
      protected function HandleEnterFrame() : void
      {
         var _loc1_:uint = this.mGameState;
         var _loc2_:uint = this.mNewGameState;
         this.mGameState = _loc2_;
         CommunicationManager.SendUIMessage("GameStateChanged",_loc2_);
         this.mNewGameState = GameStates.UNKNOWN;
         EventManager.SwitchToGameState(_loc2_);
         this.layoutMgr.SwitchToGameState(_loc2_);
         if(this.boundElementMgr)
         {
            this.boundElementMgr.SetGameState(_loc2_);
         }
         if(_loc1_ != _loc2_)
         {
            this.HandleGamepadStateChange({
               "oldState":_loc1_,
               "newState":_loc2_,
               "forControllerSimulatedStack":false
            });
         }
      }
      
      public function FocusToGameEntry() : void
      {
         this.navMgr.FocusWidgetForward("GameEntryLauncher");
         CommunicationManager.RemoveMessageListener("LoadedGameEntryLauncher",this.FocusToGameEntry,this);
      }
      
      protected function StageResizeHandler(param1:Event) : void
      {
         var _loc2_:Number = stage.stageWidth;
         var _loc3_:Number = stage.stageHeight;
         this.layoutMgr.StageResized(_loc2_,_loc3_);
         this.mcContextMenu.StageResized(_loc2_,_loc3_);
         PopUpManager.StageResized(_loc2_,_loc3_);
         CommunicationManager.SendUIMessage("StageResized",{
            "width":_loc2_,
            "height":_loc3_
         });
      }
      
      protected function HandleEscapeKey() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = DialogManager.HandleEscapeKey();
         if(!_loc1_)
         {
            _loc1_ = this.layoutMgr.HandleEscapeKey();
         }
         return !_loc1_;
      }
      
      protected function HandleGameSaveComplete(param1:GameSaveComplete) : void
      {
         UISettings.SimSettings.CleanRemovedValues();
         UISettings.HouseholdSettings.CleanRemovedValues();
         UISettings.AccountSettings.CleanRemovedValues();
      }
      
      protected function HandleSetSystemUIScale(param1:Object) : void
      {
         var _loc2_:Number = param1["uiScale"] as Number;
         SystemUtils.SetUIScale(_loc2_);
         _loc2_ = param1["monitorDpi"] as Number;
         SystemUtils.UIMonitorDPIScale = _loc2_;
         _loc2_ = param1["virtualCursorScale"] as Number;
         SystemUtils.VirtualCursorScale = _loc2_;
      }
      
      protected function HandleRefreshGameContent(param1:Object) : void
      {
         GameContent.Refresh();
      }
      
      protected function HandlePromptRestartRequired(param1:Object) : void
      {
         var _loc4_:Function = null;
         var _loc5_:Function = null;
         var _loc2_:Object = Keys.PACKS_CHANGED_PROMPT_RESTART_TITLE;
         var _loc3_:Object = Keys.PACKS_CHANGED_PROMPT_RESTART_DESCRIPTION;
         if(param1)
         {
            _loc2_ = param1["title"] || _loc2_;
            _loc3_ = param1["description"] || _loc3_;
            _loc4_ = param1["cancelCallback"];
            _loc5_ = param1["successCallback"];
         }
         this.communicationMgr.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":_loc2_,
            "description":_loc3_,
            "optionOneText":Keys.GENERIC_YES,
            "optionOneCallback":this.HandleConfirmRestart,
            "optionOneParams":{"successCallback":_loc5_},
            "closeCallback":_loc4_,
            "closeText":Keys.GENERIC_CANCEL,
            "modality":DialogModality.SYSTEM,
            "dialog_id":"PromptRestartRequiredDialog"
         });
      }
      
      protected function HandleConfirmRestart(param1:Object) : void
      {
         var _loc2_:Function = param1 ? param1["successCallback"] : null;
         if(Boolean(_loc2_))
         {
            _loc2_();
         }
         var _loc3_:Boolean = Boolean(CommunicationManager.CallGameService("RequestRestartAfterExit"));
         if(_loc3_)
         {
            CommunicationManager.SendUIMessage("ExitGame");
            CommunicationManager.CallGameService("ExitGame",false);
         }
         else
         {
            this.communicationMgr.SendUIMessage("ShowDialog",{
               "type":DialogTypes.SINGLE_BUTTON,
               "title":Keys.PACKS_CHANGED_RESTART_UNAVAILABLE_TITLE,
               "description":Keys.PACKS_CHANGED_RESTART_UNAVAILABLE_DESCRIPTION,
               "optionOneText":Keys.GENERIC_OK,
               "modality":DialogModality.SYSTEM
            });
         }
      }
      
      protected function HandleGetUISimSettings(param1:Object) : Array
      {
         var _loc2_:SettingsMap = UISettings.SimSettings;
         return _loc2_ ? _loc2_.GetKeyValueArray() : null;
      }
      
      protected function HandleGetUIAccountSettings(param1:Object) : Array
      {
         var _loc2_:SettingsMap = UISettings.AccountSettings;
         return _loc2_ ? _loc2_.GetKeyValueArray() : null;
      }
      
      protected function HandleGetUIHouseholdSettings(param1:Object) : Array
      {
         var _loc2_:SettingsMap = UISettings.HouseholdSettings;
         return _loc2_ ? _loc2_.GetKeyValueArray() : null;
      }
      
      protected function HandleAddUISessionSetting(param1:Object) : void
      {
         UISettings.SessionSettings.SetValue(param1.key,param1.value,param1.id);
      }
      
      protected function DebugCommandQACurrentGameState(param1:Array, param2:Object, param3:String) : void
      {
         CommunicationManager.TraceAutomation("QueryUIGameState; StateName:" + GameStates.ConvertStateIdToName(this.mGameState) + ", StateHash:" + this.mGameState + ", IsLoading:" + (this.layoutMgr.IsLoadingWidgets() + ", IsTransitioning:" + CommunicationManager.CallUIService("IsTransitionScreenVisible")));
      }
      
      protected function DebugCommandThrowError(param1:Array, param2:Object, param3:String) : void
      {
         throw Error("ui.throw_error cheat command has been executed!");
      }
      
      protected function DebugCommandCrashGame(param1:Array, param2:Object, param3:String) : void
      {
         CommunicationManager.CallGameService("CrashGame");
      }
      
      protected function InitGamepad() : void
      {
         var _loc1_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TOGGLE_VIRTUAL_CURSOR_MODE)).CallFunction(this.ToggleVirtualCursorMode).SetValidCheckUIService("IsNotInFreeCam").SetLegendKey(KeysConsole.GENERIC_TOGGLE_VIRTUAL_CURSOR).ExcludeFromWidgetsFocused("SimCamera","TutorialTip","PlayerCheats","CASStories","GuidanceTips").RestrictToGameStates(GameStates.CAS,GameStates.PLAY,GameStates.BUILD,GameStates.MAIN_MENU);
         var _loc2_:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(ActionCodes.TOGGLE_VIRTUAL_CURSOR_MODE)).CallFunction(this.ToggleVirtualCursorMode).SetLegendKey(KeysConsole.GENERIC_TOGGLE_VIRTUAL_CURSOR,0,true).ExcludeFromWidgetsFocused("TutorialTip","PlayerCheats").RestrictToGameStates(GameStates.TRAVEL,GameStates.LOT_SELECT).SetValidCheck(this.WorldSelectVirtualCursorValidCheck);
         InputActionManager.AutoregisterActions([_loc1_,_loc2_]);
         CommunicationManager.AddMessageListener("SetScreenMargins",this.HandleSetScreenMargins,this);
         CommunicationManager.AddMessageListener("SetScreenMarginsEnabled",this.HandleSetScreenMarginsEnabled,this);
         CommunicationManager.AddMessageListener("ControllerModeToggled",this.HandleControllerModeToggled,this);
         CommunicationManager.AddMessageListener("ReinitializeGameState",this.HandleGamepadStateChange,this);
         if(SystemUtils.IsConsole)
         {
            CommunicationManager.AddMessageListener("InputDevicesChanged",this.HandleInputDevicesChanged,this);
         }
         this.communicationMgr.RegisterServiceHandler("ShouldSendMouseLeftClick",NavManager.Instance.ShouldSendMouseLeftClick,"UIContainer");
      }
      
      protected function HandleControllerModeToggled(param1:Object) : void
      {
         SystemUtils.UsingController = param1 as Boolean;
         LocKey.ClearCachedStrings(Keys,KeysBB,KeysCAS,KeysConsole,KeysEXCH,KeysGE,KeysGP,KeysPhotography);
         CommunicationManager.SendUIMessage("UsingControllerToggled");
         this.addEventListener(Event.ENTER_FRAME,this.SendPostControllerToggleMessage,false,0,true);
      }
      
      protected function SendPostControllerToggleMessage() : void
      {
         CommunicationManager.SendUIMessage("PostUsingControllerToggled");
         this.removeEventListener(Event.ENTER_FRAME,this.SendPostControllerToggleMessage);
      }
      
      protected function WorldSelectVirtualCursorValidCheck() : Boolean
      {
         if(NavManager.Instance.CurrentWidgetName == "GameEntryDock" && Boolean(CommunicationManager.CallUIService("IsDockAnimating")))
         {
            return false;
         }
         return NavManager.Instance.IsAtRoot && Boolean(CommunicationManager.CallUIService("IsWorldSelectionGridHidden"));
      }
      
      protected function HandleSetScreenMargins(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         if(Boolean(param1) && Boolean(param1.marginXPct != undefined) && param1.marginYPct != undefined)
         {
            this.layoutMgr.SetScreenMarginPcts(param1.marginXPct,param1.marginYPct);
            _loc2_ = !param1.hasOwnProperty("doNotSave") || param1["doNotSave"] == false;
            if(_loc2_)
            {
               CommunicationManager.CallGameService("SaveScreenMargins",param1);
            }
         }
      }
      
      protected function HandleSetScreenMarginsEnabled(param1:Boolean) : void
      {
         this.layoutMgr.SetScreenMarginsEnabled(param1);
      }
      
      protected function ToggleVirtualCursorMode() : void
      {
         NavManager.Instance.ToggleVirtualCursorMode();
      }
      
      public function IsLockCursorVisible() : Boolean
      {
         return Boolean(this.mcLockCursor) && this.mcLockCursor.visible;
      }
      
      protected function HandleGamepadStateChange(param1:Object) : void
      {
         var _loc7_:Object = null;
         var _loc2_:uint = param1["oldState"] as uint;
         var _loc3_:uint = param1["newState"] as uint;
         var _loc4_:Boolean = param1["forControllerSimulatedStack"] as Boolean;
         if(!SystemUtils.UsingConsoleInputMode)
         {
            return;
         }
         this.navMgr.Reset();
         if(this.mCurrentGameStateAdapter != null)
         {
            this.mCurrentGameStateAdapter.Exit();
            this.mCurrentGameStateAdapter = null;
         }
         var _loc5_:InputAdapter = null;
         var _loc6_:String = NavStartWidgets.GetStartWidgetName(_loc3_);
         switch(_loc3_)
         {
            case GameStates.BUILD:
               if(this.mBuildBuyMainInputAdapter == null)
               {
                  this.mBuildBuyMainInputAdapter = new BuildBuyCenterMainAdapter();
               }
               this.navMgr.SetNavMesh(BuildBuyNavMesh.Instance);
               _loc7_ = UISettings.SessionSettings.GetValue("overrideFilters","holidays");
               if(_loc7_)
               {
                  this.navMgr.InitRootFocusables(this.mBuildBuyMainInputAdapter,_loc6_,false,{"presetFilters":true});
               }
               else
               {
                  this.navMgr.InitRootFocusables(this.mBuildBuyMainInputAdapter,_loc6_,true,null,null,_loc4_);
               }
               _loc5_ = new BuildBuyGameStateAdapter();
               _loc5_.Enter();
               break;
            case GameStates.CAS:
               _loc5_ = new CASGameStateAdapter();
               _loc5_.Enter();
               if(this.mCASMainInputAdapter == null)
               {
                  this.mCASMainInputAdapter = new CASCenterMainAdapter();
                  this.mCASMainInputAdapter.SetFocusBodyOnBack(true);
               }
               this.navMgr.SetNavMesh(CASNavMesh.Instance);
               this.navMgr.InitRootFocusables(this.mCASMainInputAdapter,_loc6_,true,null,null,_loc4_);
               break;
            case GameStates.MAIN_MENU:
               if(this.mMainMenuInputAdapter == null)
               {
                  this.mMainMenuInputAdapter = new VirtualCursorInputAdapter();
               }
               this.navMgr.SetNavMesh(GELauncherMesh.Instance);
               this.navMgr.InitRootFocusables(this.mMainMenuInputAdapter,_loc6_,false,null,null,_loc4_);
               break;
            case GameStates.PLAY:
               if(this.mGameplayMainInputAdapter == null)
               {
                  this.mGameplayMainInputAdapter = new GameplayCenterMainAdapter();
               }
               this.navMgr.SetNavMesh(GameplayNavMesh.Instance);
               this.navMgr.InitRootFocusables(this.mGameplayMainInputAdapter,_loc6_,true,null,null,_loc4_);
               _loc5_ = new GameplayStateAdapter();
               _loc5_.Enter();
               break;
            case GameStates.TRAVEL:
            case GameStates.LOT_SELECT:
               if(this.mNeighborhoodInputAdapter == null)
               {
                  this.mNeighborhoodInputAdapter = new VirtualCursorInputAdapter();
               }
               this.navMgr.SetNavMesh(WorldSelectionNavMesh.Instance);
               this.navMgr.InitRootFocusables(this.mNeighborhoodInputAdapter,_loc6_,false,null,null,_loc4_);
               break;
            case GameStates.FIRST_LAUNCH:
               CommunicationManager.SendUIMessage("ShowScreenMargins");
               break;
            case GameStates.LEGAL_AGREEMENTS:
               if(!CommunicationManager.CallUIService("IsWidgetVisible","LegalAgreements"))
               {
                  CommunicationManager.SendUIMessage("ShowLegalAgreements");
               }
         }
         if(_loc5_)
         {
            this.mCurrentGameStateAdapter = _loc5_;
         }
      }
      
      protected function HandleInputDevicesChanged(param1:Object) : void
      {
         if(!DialogManager.IsInstantiated())
         {
            return;
         }
         var _loc2_:Boolean = Boolean(param1.IsControllerConnected);
         var _loc3_:Boolean = Boolean(param1.IsMouseConnected);
         var _loc4_:Boolean = Boolean(param1.IsKeyboardConnected);
         var _loc5_:Boolean = _loc2_ || _loc3_ && _loc4_;
         if((_loc5_) && !DialogManager.HasRequest("DeviceConnected"))
         {
            return;
         }
         DialogManager.CancelRequest("DeviceConnected");
         var _loc6_:String = param1.ChangedDevice;
         if(!param1.ChangedDeviceIsConnected)
         {
            this.mLastDisconnectedDevice = _loc6_;
         }
         var _loc7_:Object = {
            "type":DialogTypes.SINGLE_BUTTON,
            "optionOneText":Keys.GENERIC_OK,
            "optionOneCallback":"DisconnectDialogDismissed",
            "modality":DialogModality.SYSTEM,
            "dialog_id":"DeviceConnected",
            "options":GenericDialogOption.DISABLE_CLOSE_BUTTON
         };
         if(!_loc5_)
         {
            _loc7_["optionOneEnabled"] = false;
         }
         if(this.mLastDisconnectedDevice == "controller")
         {
            _loc7_["title"] = KeysConsole.CONTROLLER_DISCONNECTED;
            if(_loc3_ && _loc4_)
            {
               if(SystemUtils.IsPS4)
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_CONTROLLER_OR_CONTINUE_WITH_MOUSE_KBM_PS4;
               }
               else
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_CONTROLLER_OR_CONTINUE_WITH_MOUSE;
               }
            }
            else if(SystemUtils.IsPS4)
            {
               _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_CONTROLLER_KBM_PS4;
            }
            else
            {
               _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_CONTROLLER;
            }
         }
         else if(this.mLastDisconnectedDevice == "mouse")
         {
            if(_loc4_)
            {
               _loc7_["title"] = KeysConsole.MOUSE_DISCONNECTED;
               if(SystemUtils.IsPS4)
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSE_OR_CONTROLLER_KBM_PS4;
               }
               else
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSE_OR_CONTROLLER;
               }
            }
            else
            {
               _loc7_["title"] = KeysConsole.MOUSEKEYBOARD_DISCONNECTED;
               if(SystemUtils.IsPS4)
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSEKEYBOARD_OR_CONTROLLER_KBM_PS4;
               }
               else
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSEKEYBOARD_OR_CONTROLLER;
               }
            }
         }
         else if(this.mLastDisconnectedDevice == "keyboard")
         {
            if(_loc3_)
            {
               _loc7_["title"] = KeysConsole.KEYBOARD_DISCONNECTED;
               if(SystemUtils.IsPS4)
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_KEYBOARD_OR_CONTROLLER_KBM_PS4;
               }
               else
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_KEYBOARD_OR_CONTROLLER;
               }
            }
            else
            {
               _loc7_["title"] = KeysConsole.MOUSEKEYBOARD_DISCONNECTED;
               if(SystemUtils.IsPS4)
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSEKEYBOARD_OR_CONTROLLER_KBM_PS4;
               }
               else
               {
                  _loc7_["description"] = KeysConsole.PLEASE_RECONNECT_MOUSEKEYBOARD_OR_CONTROLLER;
               }
            }
         }
         CommunicationManager.SendUIMessage("ShowDialog",_loc7_);
      }
   }
}

