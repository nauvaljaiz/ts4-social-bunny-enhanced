package gamedata.OptionsMenu
{
   import gamedata.GameContent;
   import olympus.localization.Keys;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   import widgets.OptionsMenu.controls.OptionsData;
   
   public final class PackSettingValues
   {
      
      public static const OPT_OUT_OF_FAME:String = "FameStartSimsOptedOut";
      
      public static const NPC_CIVIC_VOTING:String = "NPCCivicVoting";
      
      public static const ECO_FOOT_PRINT_GAMEPLAY:String = "EcoFootprintGameplay";
      
      public static const DUST_SYSTEM:String = "DustSystem";
      
      public static const CREATURE_AGING:String = "CreatureAging";
      
      public static const RESTRICT_NPC_WEREWOLVES:String = "RestrictNPCWerewolves";
      
      public static const ACNE:String = "Acne";
      
      public static const SELF_DISCOVERY:String = "SelfDiscovery";
      
      public static const CAREER_LAY_OFF:String = "CareerLayOff";
      
      public static const MULTI_UNIT_EVENTS_ENABLE:String = "MultiUnitEventsEnable";
      
      public static const MULTI_UNIT_HIDDEN_BY_DEFAULT:String = "MultiUnitHiddenByDefault";
      
      public static const MATCHMAKING_GALLERY_SIMS_ENABLE:String = "MatchmakingGallerySimsEnable";
      
      public static const MATCHMAKING_GALLERY_SIMS_FAVORITES_ONLY_ENABLE:String = "MatchmakingGallerySimsFavoritesOnlyEnable";
      
      public static const MATCHMAKING_OCCULT_SIMS_ENABLE:String = "MatchmakingOccultSimsEnable";
      
      public static const HEIRLOOM_OBJECTS_ENABLE:String = "HeirloomObjectsEnable";
      
      public static const SMALL_BUSINESS_EVENTS_ENABLE:String = "SmallBusinessEventsEnable";
      
      public static const RESTRICT_NPC_FAIRIES:String = "RestrictNPCFairies";
      
      public static const BALANCE_SYSTEM_ENABLED:String = "BalanceSystemEnabled";
      
      public static const LUCK_ENABLED:String = "LuckEnabled";
      
      public static const AILMENTS_ENABLED:String = "AilmentsEnabled";
      
      public static const NPC_BLACKMAIL_SYSTEM_NAME:String = "NPCBlackmailSystemEnabled";
      
      public static const SCANDAL_SYSTEM_NAME:String = "ScandalSystemEnabled";
      
      public static const NOBLE_CAREER_AUTO_PROMOTION_ENABLED_NAME:String = "NobleCareerAutoPromotionEnabled";
      
      public static const DYNASTY_PRESTIGE_DECAY_ENABLED_NAME:String = "DynastyPrestigeDecayEnabled";
      
      public static const FAME_CHECKBOX_OPTION_NAME:Array = [OPT_OUT_OF_FAME];
      
      public static const ECO_CHECKBOX_OPTION_NAME:Array = [NPC_CIVIC_VOTING,ECO_FOOT_PRINT_GAMEPLAY];
      
      public static const DUST_CHECKBOX_OPTION_NAME:Array = [DUST_SYSTEM];
      
      public static const CREAUTURE_CHECKBOX_OPTION_NAME:Array = [CREATURE_AGING];
      
      public static const WEREWOLF_CHECKBOX_OPTION_NAME:Array = [RESTRICT_NPC_WEREWOLVES];
      
      public static const HIGHSCHOOL_CHECKBOX_OPTION_NAME:Array = [ACNE];
      
      public static const GROWING_TOGETHER_CHECKBOX_OPTION_NAME:Array = [SELF_DISCOVERY,CAREER_LAY_OFF];
      
      public static const MULTI_UNIT_CHECKBOX_OPTION_NAME:Array = [MULTI_UNIT_EVENTS_ENABLE];
      
      public static const MATCHMAKING_GALLERY_SIMS_CHECKBOX_OPTION_NAME:Array = [MATCHMAKING_GALLERY_SIMS_ENABLE];
      
      public static const MATCHMAKING_OCCULT_SIMS_CHECKBOX_OPTION_NAME:Array = [MATCHMAKING_OCCULT_SIMS_ENABLE];
      
      public static const MATCHMAKING_GALLERY_SIMS_FAVORITES_ONLY_CHECKBOX_OPTION_NAME:Array = [MATCHMAKING_GALLERY_SIMS_FAVORITES_ONLY_ENABLE];
      
      public static const HEIRLOOM_OBJECTS_CHECKBOX_OPTION_NAME:Array = [HEIRLOOM_OBJECTS_ENABLE];
      
      public static const SMALL_BUSINESS_EVENTS_CHECKBOX_OPTION_NAME:Array = [SMALL_BUSINESS_EVENTS_ENABLE];
      
      public static const EP21_CHECKBOX_OPTION_NAME:Array = [NPC_BLACKMAIL_SYSTEM_NAME,SCANDAL_SYSTEM_NAME,NOBLE_CAREER_AUTO_PROMOTION_ENABLED_NAME,DYNASTY_PRESTIGE_DECAY_ENABLED_NAME];
      
      public function PackSettingValues()
      {
         super();
      }
      
      public static function InitFamePanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_FAME_OPT_OUT,OptionsCellViewTypes.CHECKBOX,OPT_OUT_OF_FAME,Keys.OPTIONS_FAME_OPT_OUT_TOOLTIP,Keys.OPTIONS_FAME_OPT_OUT_WARNING));
         return _loc1_;
      }
      
      public static function InitEcoLivingPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_ECOLIVING_WORLDWARNING,OptionsCellViewTypes.SECTION_DESCRIPTION,"EcoLivingSectionDescription"));
         _loc1_.push(new OptionsData(Keys.OPTIONS_ECOLIVING_NPCVOTING,OptionsCellViewTypes.CHECKBOX,NPC_CIVIC_VOTING,null,Keys.OPTIONS_ECOLIVING_NPCVOTING_DESC));
         _loc1_.push(new OptionsData(Keys.OPTIONS_ECOLIVING_ECOFOOTPRINT,OptionsCellViewTypes.CHECKBOX,ECO_FOOT_PRINT_GAMEPLAY,null,Keys.OPTIONS_ECOLIVING_ECOFOOTPRINT_DESC));
         return _loc1_;
      }
      
      public static function InitDustSystemPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_DUST_DUSTSYSTEM,OptionsCellViewTypes.CHECKBOX,DUST_SYSTEM,null,Keys.OPTIONS_DUST_DUSTSYSTEM_DESC));
         return _loc1_;
      }
      
      public static function InitWerewolfPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_WEREWOLVES_OPT_OUT,OptionsCellViewTypes.CHECKBOX,RESTRICT_NPC_WEREWOLVES,Keys.OPTIONS_WEREWOLVES_OPT_OUT_TOOLTIP,Keys.OPTIONS_WEREWOLVES_OPT_OUT_WARNING));
         return _loc1_;
      }
      
      public static function InitGrovePanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_FAIRIES_OPT_OUT,OptionsCellViewTypes.CHECKBOX,RESTRICT_NPC_FAIRIES,Keys.OPTIONS_FAIRIES_OPT_OUT_TOOLTIP,Keys.OPTIONS_FAIRIES_OPT_OUT_WARNING));
         _loc1_.push(new OptionsData(Keys.OPTIONS_AILMENTS_OPT_OUT,OptionsCellViewTypes.CHECKBOX,AILMENTS_ENABLED,Keys.OPTIONS_AILMENTS_OPT_OUT_TOOLTIP,Keys.OPTIONS_AILMENTS_OPT_OUT_WARNING));
         _loc1_.push(new OptionsData(Keys.OPTIONS_BALANCE_SYSTEM_OPT_OUT,OptionsCellViewTypes.CHECKBOX,BALANCE_SYSTEM_ENABLED,Keys.OPTIONS_BALANCE_SYSTEM_OPT_OUT_TOOLTIP,Keys.OPTIONS_BALANCE_SYSTEM_OPT_OUT_WARNING));
         _loc1_.push(new OptionsData(Keys.OPTIONS_LUCK_OPT_OUT,OptionsCellViewTypes.CHECKBOX,LUCK_ENABLED,Keys.OPTIONS_LUCK_OPT_OUT_TOOLTIP,Keys.OPTIONS_LUCK_OPT_OUT_WARNING));
         return _loc1_;
      }
      
      public static function InitHighSchoolPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_HIGHSCHOOL_ACNE,OptionsCellViewTypes.CHECKBOX,ACNE,null,Keys.OPTIONS_HIGHSCHOOL_ACNE_DESC));
         return _loc1_;
      }
      
      public static function InitGrowingTogetherPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_GROWING_TOGETHER_SELF_DISCOVERY,OptionsCellViewTypes.CHECKBOX,SELF_DISCOVERY,Keys.OPTIONS_GROWING_TOGETHER_SELF_DISCOVERY_OPT_OUT_TOOLTIP,Keys.OPTIONS_GROWING_TOGETHER_SELF_DISCOVERY_DESC));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GROWING_TOGETHER_CAREER_LAY_OFF,OptionsCellViewTypes.CHECKBOX,CAREER_LAY_OFF,Keys.OPTIONS_GROWING_TOGETHER_CAREER_LAY_OFF_OPT_OUT_TOOLTIP,Keys.OPTIONS_GROWING_TOGETHER_CAREER_LAY_OFF_DESC));
         return _loc1_;
      }
      
      public static function InitMultiUnitPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_MULTI_UNIT_EVENTS,OptionsCellViewTypes.CHECKBOX,MULTI_UNIT_EVENTS_ENABLE,Keys.OPTIONS_MULTI_UNIT_EVENTS_TOOLTIP,Keys.OPTIONS_MULTI_UNIT_EVENTS_DESC));
         _loc1_.push(new OptionsData(Keys.OPTIONS_MULTI_UNIT_HIDDEN_BY_DEFAULT,OptionsCellViewTypes.CHECKBOX,MULTI_UNIT_HIDDEN_BY_DEFAULT,Keys.OPTIONS_MULTI_UNIT_HIDDEN_BY_DEFAULT_TOOLTIP,Keys.OPTIONS_MULTI_UNIT_HIDDEN_BY_DEFAULT_DESC));
         return _loc1_;
      }
      
      public static function InitRendezvousOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:OptionsData = new OptionsData(Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS,OptionsCellViewTypes.CHECKBOX,MATCHMAKING_GALLERY_SIMS_ENABLE,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS_TOOLTIP,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS_DESC);
         _loc1_.push(_loc2_);
         var _loc3_:OptionsData = new OptionsData(Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS_FAVORITES_ONLY,OptionsCellViewTypes.CHECKBOX,MATCHMAKING_GALLERY_SIMS_FAVORITES_ONLY_ENABLE,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS_FAVORITES_ONLY_TOOLTIP,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_GALLERY_SIMS_FAVORITES_ONLY_DESC);
         _loc3_.linkedOptionsDataOne = _loc2_;
         _loc1_.push(_loc3_);
         if(GameContent.IsOccultPackInstalled())
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_OCCULT_SIMS,OptionsCellViewTypes.CHECKBOX,MATCHMAKING_OCCULT_SIMS_ENABLE,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_OCCULT_SIMS_TOOLTIP,Keys.OPTIONS_RENDEZVOUS_MM_ALLOW_OCCULT_SIMS_DESC));
         }
         return _loc1_;
      }
      
      public static function InitLifeAndDeathData() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:OptionsData = new OptionsData(Keys.OPTIONS_LIFE_AND_DEATH_HEIRLOOM_OBJECTS_ENABLE,OptionsCellViewTypes.CHECKBOX,HEIRLOOM_OBJECTS_ENABLE,null,Keys.OPTIONS_LIFE_AND_DEATH_HEIRLOOM_OBJECTS_ENABLE_DESC);
         _loc1_.push(_loc2_);
         return _loc1_;
      }
      
      public static function InitSmallBusinessOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_SMALL_BUSINESS_EVENTS,OptionsCellViewTypes.CHECKBOX,SMALL_BUSINESS_EVENTS_ENABLE,Keys.OPTIONS_SMALL_BUSINESS_EVENTS_TOOLTIP,Keys.OPTIONS_SMALL_BUSINESS_EVENTS_DESC));
         return _loc1_;
      }
      
      public static function InitScandalsOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_NPC_BLACKMAIL_SYSTEM,OptionsCellViewTypes.CHECKBOX,NPC_BLACKMAIL_SYSTEM_NAME,Keys.OPTIONS_TOOLTIP_NPC_BLACKMAIL_SYSTEM,Keys.OPTIONS_GAMEPLAY_NPC_BLACKMAIL_SYSTEM_DESC);
         var _loc3_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_SCANDAL_SYSTEM,OptionsCellViewTypes.CHECKBOX,SCANDAL_SYSTEM_NAME,Keys.OPTIONS_TOOLTIP_SCANDAL_SYSTEM,Keys.OPTIONS_GAMEPLAY_SCANDAL_SYSTEM_DESC);
         var _loc4_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_NOBLE_CAREER_AUTO_PROMO,OptionsCellViewTypes.CHECKBOX,NOBLE_CAREER_AUTO_PROMOTION_ENABLED_NAME,Keys.OPTIONS_TOOLTIP_NOBLE_CAREER_AUTO_PROMO,Keys.OPTIONS_GAMEPLAY_NOBLE_CAREER_AUTO_PROMO_DESC);
         var _loc5_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_DYNASTY_PRESTIGE_DECAY,OptionsCellViewTypes.CHECKBOX,DYNASTY_PRESTIGE_DECAY_ENABLED_NAME,Keys.OPTIONS_TOOLTIP_DYNASTY_PRESTIGE_DECAY,Keys.OPTIONS_GAMEPLAY_DYNASTY_PRESTIGE_DECAY_DESC);
         _loc2_.linkedOptionsDataOne = _loc3_;
         _loc1_.push(_loc2_);
         _loc1_.push(_loc3_);
         _loc1_.push(_loc4_);
         _loc1_.push(_loc5_);
         return _loc1_;
      }
   }
}

