package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class UiDialogChoiceMessage extends OlympusObject
   {
      
      public static const CHOICE_SOCIAL_BUNNY:int = -1;
      
      public static const CHOICE_CUPIDS_CORNER:int = -2;
      
      public static const CHOICE_NO_REQUEST:int = 0;
      
      public static const CHOICE_SHOW_LESSONS:int = 1;
      
      public static const CHOICE_SHOW_ACHIEVEMENTS:int = 2;
      
      public static const CHOICE_SHOW_GALLERY_ITEM:int = 3;
      
      public static const CHOICE_SHOW_FAMILY_INVENTORY:int = 4;
      
      public static const CHOICE_SHOW_SKILL_PANEL:int = 5;
      
      public static const CHOICE_SHOW_SUMMARY_PANEL:int = 6;
      
      public static const CHOICE_SHOW_ASPIRATION_PANEL:int = 7;
      
      public static const CHOICE_SHOW_ASPIRATION_UI:int = 8;
      
      public static const CHOICE_SHOW_EVENT_UI:int = 9;
      
      public static const CHOICE_SHOW_CAREER_PANEL:int = 10;
      
      public static const CHOICE_SHOW_RELATIONSHIP_PANEL:int = 11;
      
      public static const CHOICE_SHOW_SIM_INVENTORY:int = 12;
      
      public static const CHOICE_SHOW_REWARD_STORE:int = 13;
      
      public static const CHOICE_SHOW_MOTIVE_PANEL:int = 14;
      
      public static const CHOICE_SHOW_STATS:int = 15;
      
      public static const CHOICE_SHOW_COLLECTIBLES:int = 16;
      
      public static const CHOICE_SHOW_CAREER_UI:int = 17;
      
      public static const CHOICE_TRANSITION_TO_NEIGHBORHOOD_SAVE:int = 18;
      
      public static const CHOICE_TRANSITION_TO_MAIN_MENU_NO_SAVE:int = 19;
      
      public static const CHOICE_SHOW_SHARE_PLAYER_PROFILE:int = 20;
      
      public static const CHOICE_SHOW_ASPIRATION_SELECTOR:int = 21;
      
      public static const CHOICE_SHOW_SHARE_MY_LIBRARY:int = 22;
      
      public static const CHOICE_SHOW_NOTEBOOK:int = 23;
      
      public static const CHOICE_SEND_COMMAND:int = 24;
      
      public static const CAREER_GO_TO_WORK:int = 25;
      
      public static const CAREER_WORK_FROM_HOME:int = 26;
      
      public static const CAREER_TAKE_PTO:int = 27;
      
      public static const CAREER_CALL_IN_SICK:int = 28;
      
      public static const CHOICE_SHOW_OCCULT_POWERS_PANEL:int = 29;
      
      public static const CHOICE_SHOW_FAME_PERKS_PANEL:int = 30;
      
      public static const CHOICE_SHOW_FACTION_REP_PANEL:int = 31;
      
      public static const CHOICE_SEND_UI_MESSAGE:int = 32;
      
      public static const CHOICE_PIVOTAL_MOMENT_ASK_LATER:int = 33;
      
      public static const CHOICE_SHOW_GHOST_POWERS_PERKS_PANEL:int = 34;
      
      public static const CHOICE_SHOW_SMALL_BUSINESS_PERKS_PANEL:int = 35;
      
      public static const CHOICE_SHOW_SMALL_BUSINESS_PANEL:int = 36;
      
      public static const CHOICE_SHOW_BUILD_BUY_WITH_FILTER:int = 37;
      
      public static const SHOW_SMALL_BUSINESS_CONFIGURATOR:int = 38;
      
      public static const SHOW_NOBILITY_PERKS_PANEL:int = 39;
      
      public static const CHOICE_SHOW_DYNASTY_PANEL:int = 40;
      
      public static const CHOICE_SHOW_DYNASTY_PERKS_PANEL:int = 41;
      
      public var choice_id:uint;
      
      public var text:LocKey = new LocKey();
      
      public var ui_request:int = 0;
      
      public var exchange_args:UiExchangeArgs = new UiExchangeArgs();
      
      public var tutorial_args:UiTutorialArgs = new UiTutorialArgs();
      
      public var command_with_args:UiCommandArgs = new UiCommandArgs();
      
      public var subtext:LocKey = new LocKey();
      
      public var disabled_text:LocKey = new LocKey();
      
      public var audio_event_name:String;
      
      public var tooltip_text:LocKey = new LocKey();
      
      public var button_icon:IconInfo = new IconInfo();
      
      public var ui_message_args:UiSendMessageArgs = new UiSendMessageArgs();
      
      public var show_build_buy_args:UiShowBuildBuyArgs = new UiShowBuildBuyArgs();
      
      public function UiDialogChoiceMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("exchange_args" in param1))
         {
            this.exchange_args = null;
         }
         if(!param1 || !("tutorial_args" in param1))
         {
            this.tutorial_args = null;
         }
         if(!param1 || !("command_with_args" in param1))
         {
            this.command_with_args = null;
         }
         if(!param1 || !("ui_message_args" in param1))
         {
            this.ui_message_args = null;
         }
         if(!param1 || !("button_icon" in param1))
         {
            this.button_icon = null;
         }
         if(!this.subtext.IsValid())
         {
            this.subtext = null;
         }
         if(!this.disabled_text.IsValid())
         {
            this.disabled_text = null;
         }
         if(!this.tooltip_text.IsValid())
         {
            this.tooltip_text = null;
         }
      }
   }
}

