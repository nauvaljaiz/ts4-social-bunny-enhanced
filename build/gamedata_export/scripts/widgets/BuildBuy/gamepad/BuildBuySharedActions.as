package widgets.BuildBuy.gamepad
{
   import olympus.constants.GameStates;
   import olympus.gamepad.NavManager;
   import olympus.input.IInputFocusable;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysConsole;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterObjectSelectedAdapter;
   import widgets.BuildBuy.gamepad.adapters.BuildBuyCenterWallAdapter;
   
   public final class BuildBuySharedActions
   {
      
      public static var jumpToFilter:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.JUMP_TO_FILTER)).RestrictToGameStates(GameStates.BUILD).CallFunction(HandleJumpToFilter).SetValidCheck(FilterSearchValidCheck).SetLegendKey(KeysConsole.BUILDBUY_MENU_FILTER_ITEMS);
      
      public static var jumpToSearch:InputAction = InputAction.WhenTriggered(InputTrigger.FromActionCode(BuildBuyActionCodes.JUMP_TO_SEARCH)).RestrictToGameStates(GameStates.BUILD).CallFunction(HandleJumpToSearch).SetValidCheck(FilterSearchValidCheck).SetLegendKey(KeysConsole.BUILDBUY_MENU_SEARCH_MENU);
      
      public function BuildBuySharedActions()
      {
         super();
      }
      
      protected static function HandleJumpToFilter() : void
      {
         NavManager.Instance.FocusWidgetForward("BuildBuyFilter");
      }
      
      protected static function HandleJumpToSearch() : void
      {
         if(!NavManager.Instance.FocusWidgetForward("BuildBuyNavigation",{
            "focusSearchBar":true,
            "openImmediately":true
         }))
         {
            CommunicationManager.SendUIMessage("BBFocusSearchBar");
         }
      }
      
      protected static function FilterSearchValidCheck() : Boolean
      {
         var _loc1_:IInputFocusable = NavManager.Instance.CurrentFocusable;
         return !(_loc1_ is BuildBuyCenterObjectSelectedAdapter || _loc1_ is BuildBuyCenterWallAdapter);
      }
   }
}

