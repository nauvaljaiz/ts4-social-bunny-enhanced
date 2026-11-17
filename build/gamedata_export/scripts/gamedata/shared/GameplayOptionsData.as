package gamedata.shared
{
   import gamedata.GameContent;
   import olympus.constants.DialogTypes;
   import olympus.controls.objects.MenuItem;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   import widgets.OptionsMenu.controls.OptionsData;
   
   public class GameplayOptionsData
   {
      
      public static const AUTONOMY_NAME:String = "AutonomyHousehold";
      
      protected static const AUTONOMY_VALUES:Array = [new MenuItem(Keys.OPTIONS_GAMEPLAY_AUTONOMY_SETUP_1.toString(),1),new MenuItem(Keys.OPTIONS_GAMEPLAY_AUTONOMY_SETUP_3.toString(),3)];
      
      public static const ENABLE_AGING_NAME:String = "SimsSetAgingEnabled";
      
      protected static const ENABLE_AGING_VALUES:Array = [new MenuItem(Keys.OPTIONS_GAMEPLAY_AGING_SETUP_1.toString(),1),new MenuItem(Keys.OPTIONS_GAMEPLAY_AGING_SETUP_2.toString(),0),new MenuItem(Keys.OPTIONS_GAMEPLAY_AGING_SETUP_3.toString(),2)];
      
      public static const LIFESPAN_OPTION_NAME:String = "SimsSetAgeSpeed";
      
      protected static const LIFESPAN_VALUES:Array = [new MenuItem(Keys.OPTIONS_GAMEPLAY_LIFESPAN_SETUP_1.toString(),0),new MenuItem(Keys.OPTIONS_GAMEPLAY_LIFESPAN_SETUP_2.toString(),1),new MenuItem(Keys.OPTIONS_GAMEPLAY_LIFESPAN_SETUP_3.toString(),2)];
      
      public static const MAX_SIM_COUNT_NAME:String = "MaxProtectedSims";
      
      protected static var sMaxSimCountValues:Array = null;
      
      public static const CREATURE_AGING:String = "CreatureAging";
      
      protected static const CONTROLS_DROPDOWN_ITEMS:Array = [AUTONOMY_VALUES,ENABLE_AGING_VALUES,LIFESPAN_VALUES,null];
      
      public static const CONTROLS_DROPDOWN_OPTION_NAMES:Array = [AUTONOMY_NAME,ENABLE_AGING_NAME,LIFESPAN_OPTION_NAME,MAX_SIM_COUNT_NAME];
      
      public static const AUTONOMY_DISABLED_NAME:String = "AutonomyDisabledForActiveSim";
      
      public static const AUTO_AGE_UNPLAYED_NAME:String = "AutoAgeUnplayed";
      
      public static const TRADITIONAL_SOCIAL_MENU_NAME:String = "TradSocialMenuEnabled";
      
      public static const SKIP_CURRENT_CHALLENGE_NAME:String = "SkipCurrentChallenge_FAKE";
      
      public static const SHOW_WHIMS_NAME:String = "Whims";
      
      public static const SHOW_ECO_BUILD_EFFECTS_NAME:String = "BuildEcoEffects";
      
      public static const SHOW_LIFESTYLE_EFFECTS_NAME:String = "LifestylesEffects";
      
      public static const STORY_PROGRESSION_EFFECTS_NAME:String = "StoryProgressionEffects";
      
      public static const NPC_AUTONOMY_FRIENDLY_NAME:String = "NPCAutonomyFriendly";
      
      public static const NPC_AUTONOMY_ROMANTIC_NAME:String = "NPCAutonomyRomantic";
      
      public static const NPC_AUTONOMY_BREAKUPS_NAME:String = "NPCAutonomyBreakups";
      
      public static const DEATH_INVENTORY_HANDLING:String = "DeathInventoryHandling";
      
      public static const BURGLAR_ENABLED_NAME:String = "BurglarEnabled";
      
      public static const SHOW_ADOPTED_SIMS:String = "ShowAdoptedSims";
      
      public static const AUTONOMY_INFANTS_CAREGIVER_DISABLED_NAME:String = "AutonomyForInfantsCaregiverDisabled";
      
      public static const WEIGHT_CHANGES_ENABLED_NAME:String = "WeightChangesEnabled";
      
      public static const MUSCLES_CHANGES_ENABLED_NAME:String = "MusclesChangesEnabled";
      
      public static const SIM_DISPLAY_COUNT_NAME:String = "SimCount";
      
      public static const STORY_PROGRESSION_RESET_NAME:String = "StoryProgressionReset";
      
      public function GameplayOptionsData()
      {
         super();
      }
      
      public static function InitLeftGridData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_AUTONOMY,OptionsCellViewTypes.DROPDOWN,AUTONOMY_NAME,Keys.OPTIONS_TOOLTIP_AUTONOMY,null,GetDropdownOptionItems));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_NPC_AUTONOMY_ROMANTIC,OptionsCellViewTypes.CHECKBOX,NPC_AUTONOMY_ROMANTIC_NAME,Keys.OPTIONS_TOOLTIP_NPC_AUTONOMY_ROMANTIC));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_NPC_AUTONOMY_FRIENDLY,OptionsCellViewTypes.CHECKBOX,NPC_AUTONOMY_FRIENDLY_NAME,Keys.OPTIONS_TOOLTIP_NPC_AUTONOMY_FRIENDLY));
         if(GameContent.HAS_EP12 || GameContent.HAS_EP16)
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_NPC_AUTONOMY_BREAKUPS,OptionsCellViewTypes.CHECKBOX,NPC_AUTONOMY_BREAKUPS_NAME,Keys.OPTIONS_TOOLTIP_NPC_AUTONOMY_BREAKUPS));
         }
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_DISABLE_AUTONOMY,OptionsCellViewTypes.CHECKBOX,AUTONOMY_DISABLED_NAME,Keys.OPTIONS_TOOLTIP_DISABLE_AUTONOMY));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_DISABLED_AUTONOMY_INFANTS_CAREGIVER,OptionsCellViewTypes.CHECKBOX,AUTONOMY_INFANTS_CAREGIVER_DISABLED_NAME,Keys.OPTIONS_GAMEPLAY_DISABLED_AUTONOMY_INFANTS_CAREGIVER_TOOLTIP));
         var _loc2_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_ENABLE_AGING,OptionsCellViewTypes.DROPDOWN,ENABLE_AGING_NAME,Keys.OPTIONS_TOOLTIP_ENABLE_AGING,null,GetDropdownOptionItems);
         var _loc3_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_UNPLAYED_SIMS_AGING,OptionsCellViewTypes.CHECKBOX,AUTO_AGE_UNPLAYED_NAME,Keys.OPTIONS_TOOLTIP_AUTO_AGE_UNPLAYED);
         var _loc4_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_SIM_LIFESPAN,OptionsCellViewTypes.DROPDOWN,LIFESPAN_OPTION_NAME,Keys.OPTIONS_TOOLTIP_SIM_LIFESPAN,null,GetDropdownOptionItems);
         _loc4_.linkedOptionsDataOne = _loc3_;
         _loc4_.linkedOptionsDataTwo = _loc2_;
         _loc1_.push(_loc2_);
         _loc1_.push(_loc3_);
         _loc1_.push(_loc4_);
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_SKIP_CURRENT_CHALLENGE,OptionsCellViewTypes.CHECKBOX,SKIP_CURRENT_CHALLENGE_NAME,Keys.OPTIONS_TOOLTIP_SKIP_CURRENT_CHALLENGE,null,null,true));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_DISABLE_BURGLAR,OptionsCellViewTypes.CHECKBOX,BURGLAR_ENABLED_NAME,Keys.OPTIONS_TOOLTIP_DISABLE_BURGLAR));
         var _loc5_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_SIM_COUNT_LABEL,OptionsCellViewTypes.SIM_COUNT,SIM_DISPLAY_COUNT_NAME);
         var _loc6_:OptionsData = new OptionsData(Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT,OptionsCellViewTypes.DROPDOWN,MAX_SIM_COUNT_NAME,Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT_TOOLTIP,null,GetDropdownOptionItems);
         _loc5_.linkedOptionsDataOne = _loc6_;
         _loc1_.push(_loc5_);
         _loc1_.push(_loc6_);
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_SHOW_ADOPTED_SIMS,OptionsCellViewTypes.CHECKBOX,SHOW_ADOPTED_SIMS,Keys.OPTIONS_GAMEPLAY_SHOW_ADOPTED_SIMS_TOOLTIP));
         if(GameContent.HAS_EP11 || GameContent.HAS_EP14)
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_CREATUREAGING,OptionsCellViewTypes.CHECKBOX,CREATURE_AGING,Keys.OPTIONS_CREATUREAGING_DESC));
         }
         return _loc1_;
      }
      
      public static function InitRightGridData() : Array
      {
         var _loc1_:Array = [];
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_SOCIAL_MENU,OptionsCellViewTypes.CHECKBOX,TRADITIONAL_SOCIAL_MENU_NAME,Keys.OPTIONS_TOOLTIP_SOCIAL_MENU));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_SHOW_WHIMS,OptionsCellViewTypes.CHECKBOX,SHOW_WHIMS_NAME,Keys.OPTIONS_TOOLTIP_SHOW_WHIMS));
         _loc1_.push(new OptionsData(Keys.OPTIONS_ECOLIVING_BUILD_ECO_EFFECTS,OptionsCellViewTypes.CHECKBOX,SHOW_ECO_BUILD_EFFECTS_NAME,Keys.OPTIONS_ECOLIVING_BUILD_ECO_EFFECTS_DESC));
         if(GameContent.HAS_EP10)
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_LIFESTYLES_EFFECTS,OptionsCellViewTypes.CHECKBOX,SHOW_LIFESTYLE_EFFECTS_NAME,Keys.OPTIONS_TOOLTIP_LIFESTYLES_EFFECTS));
         }
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_DEATH_INVENTORY_HANDLING,OptionsCellViewTypes.CHECKBOX,DEATH_INVENTORY_HANDLING,Keys.OPTIONS_GAMEPLAY_DEATH_INVENTORY_HANDLING_TOOLTIP));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_WEIGHT_CHANGES,OptionsCellViewTypes.CHECKBOX,WEIGHT_CHANGES_ENABLED_NAME,Keys.OPTIONS_GAMEPLAY_WEIGHT_CHANGES_TOOLTIP));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_MUSCLES_CHANGES,OptionsCellViewTypes.CHECKBOX,MUSCLES_CHANGES_ENABLED_NAME,Keys.OPTIONS_GAMEPLAY_MUSCLES_CHANGES_TOOLTIP));
         return _loc1_;
      }
      
      public static function InitBottomGridData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_STORY_PROGRESSION_RESET,OptionsCellViewTypes.TEXT_BUTTON,STORY_PROGRESSION_RESET_NAME));
         _loc1_.push(new OptionsData(Keys.OPTIONS_GAMEPLAY_STORY_PROGRESSION_EFFECTS,OptionsCellViewTypes.CHECKBOX,STORY_PROGRESSION_EFFECTS_NAME,null,Keys.OPTIONS_GAMEPLAY_STORY_PROGRESSION_DESCRIPTION));
         return _loc1_;
      }
      
      public static function InitFestivalNotificationGridData(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:LocKey = null;
         var _loc5_:LocKey = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return [];
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = LocKey.GetValidatedLocKey(_loc3_["title"]);
            _loc5_ = LocKey.GetValidatedLocKey(_loc3_["description"]);
            _loc6_ = "FestivalNotificationOption:" + String(_loc3_["key"]);
            _loc2_.push(new OptionsData(_loc4_,OptionsCellViewTypes.CHECKBOX,_loc6_,null,_loc5_));
         }
         return _loc2_;
      }
      
      public static function GetDropdownOptionItems(param1:String) : Array
      {
         if(!sMaxSimCountValues)
         {
            LoadMaxSimCountValues();
         }
         var _loc2_:int = CONTROLS_DROPDOWN_OPTION_NAMES.indexOf(param1);
         if(_loc2_ != -1)
         {
            return CONTROLS_DROPDOWN_ITEMS[_loc2_];
         }
         return null;
      }
      
      public static function GetAllDropdownOptionItems() : Array
      {
         if(!sMaxSimCountValues)
         {
            LoadMaxSimCountValues();
         }
         return CONTROLS_DROPDOWN_ITEMS;
      }
      
      public static function GetMaxProtectedSimsValueForIndex(param1:int) : int
      {
         var _loc2_:Array = CommunicationManager.CallGameService("OnOptionsGetMaxProtectedPlayerSimsValues") as Array;
         if(_loc2_.length > param1)
         {
            return _loc2_[param1];
         }
         return 0;
      }
      
      protected static function LoadMaxSimCountValues() : void
      {
         var _loc7_:uint = 0;
         var _loc8_:LocKey = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = CommunicationManager.CallGameService("OnOptionsGetMaxProtectedPlayerSimsValues") as Array;
         var _loc3_:Object = CommunicationManager.CallGameService("OnOptionsGetMaxRecommendedPlayerSims");
         var _loc4_:uint = _loc3_.maxPlayerSimCount as uint;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc7_ = uint(_loc2_[_loc5_]);
            _loc8_ = Keys.GENERIC_NUMBER;
            if(_loc7_ == 0)
            {
               _loc8_ = Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT_UNLIMITED;
            }
            else if(_loc7_ == _loc4_)
            {
               _loc8_ = Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT_RECCOMENDED;
            }
            _loc1_.push(new MenuItem(_loc8_.toString(_loc7_),_loc5_));
            _loc5_++;
         }
         sMaxSimCountValues = _loc1_;
         var _loc6_:int = CONTROLS_DROPDOWN_OPTION_NAMES.indexOf(MAX_SIM_COUNT_NAME);
         CONTROLS_DROPDOWN_ITEMS.splice(_loc6_,1,sMaxSimCountValues);
      }
      
      public static function ShowMaxSimCountOptionDialog(param1:uint, param2:Function = null, param3:Function = null) : Boolean
      {
         if(param1 == 0)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.YES_NO,
               "title":Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT_DIALOG_TITLE.toString(),
               "description":Keys.OPTIONS_GAMEPLAY_MAX_SIM_COUNT_DIALOG_DESCRIPTION.toString(),
               "optionOneCallback":param2,
               "closeCallback":param3,
               "closeText":Keys.GENERIC_CANCEL.toString()
            });
            return true;
         }
         var _loc4_:Object = CommunicationManager.CallGameService("OnOptionsGetMaxRecommendedPlayerSims");
         var _loc5_:uint = _loc4_.maxPlayerSimCount as uint;
         if(param1 > _loc5_)
         {
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.YES_NO,
               "title":Keys.OPTIONS_GAMEPLAY_HIGHER_SIM_COUNT_DIALOG_TITLE.toString(),
               "description":Keys.OPTIONS_GAMEPLAY_HIGHER_SIM_COUNT_DIALOG_DESCRIPTION.toString(),
               "optionOneCallback":param2,
               "closeCallback":param3,
               "closeText":Keys.GENERIC_CANCEL.toString()
            });
            return true;
         }
         return false;
      }
   }
}

