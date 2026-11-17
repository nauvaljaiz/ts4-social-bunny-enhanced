package gamedata.OptionsMenu
{
   import olympus.controls.objects.MenuItem;
   import olympus.localization.Keys;
   import olympus.utils.SystemUtils;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   import widgets.OptionsMenu.controls.OptionsData;
   
   public final class AutoSaveOptionsValues
   {
      
      public static const AUTOSAVE_SIM_TIME_FREQUENCY_NAME:String = "AutoSaveSimTimeFrequency";
      
      public static const SAVE_REMINDER_FREQUENCY_NAME:String = "SaveReminderFrequency";
      
      public static const AUTOSAVE_ON_BUILD_BUY_EXIT_NAME:String = "AutoSaveOnBuildBuyExit";
      
      public static const AUTOSAVE_ON_TRAVEL_NAME:String = "AutoSaveOnTravel";
      
      public static const AUTOSAVE_REAL_TIME_FREQUENCY_NAME:String = "AutoSaveRealTimeFrequency";
      
      public static const AUTOSAVE_SIM_TIME_VALUES:Array = [new MenuItem(Keys.OPTIONS_AUTOSAVE_OFF.toString(),0),new MenuItem(Keys.OPTIONS_AUTOSAVE_DAILY.toString(),1),new MenuItem(Keys.OPTIONS_AUTOSAVE_WEEKLY.toString(),2)];
      
      public static const AUTOSAVE_REAL_TIME_VALUES:Array = [new MenuItem(Keys.OPTIONS_AUTOSAVE_OFF.toString(),0),new MenuItem(Keys.OPTIONS_AUTOSAVE_REAL_TIME_SHORT.toString(),1),new MenuItem(Keys.OPTIONS_AUTOSAVE_REAL_TIME_LONG.toString(),2),new MenuItem(Keys.OPTIONS_AUTOSAVE_REAL_TIME_EXTRA_LONG.toString(),3)];
      
      public static const SAVE_REMINDER_VALUES:Array = [new MenuItem(Keys.OPTIONS_AUTOSAVE_OFF.toString(),0),new MenuItem(Keys.OPTIONS_SAVE_REMINDER_SHORT.toString(),1),new MenuItem(Keys.OPTIONS_SAVE_REMINDER_LONG.toString(),2),new MenuItem(Keys.OPTIONS_SAVE_REMINDER_HOURLY.toString(),3),new MenuItem(Keys.OPTIONS_SAVE_REMINDER_TWO_HOURLY.toString(),4)];
      
      public static const CONTROLS_DROPDOWN_ITEMS:Array = [AUTOSAVE_REAL_TIME_VALUES,AUTOSAVE_SIM_TIME_VALUES,SAVE_REMINDER_VALUES];
      
      public static const CONTROLS_DROPDOWN_OPTION_NAMES:Array = [AUTOSAVE_REAL_TIME_FREQUENCY_NAME,AUTOSAVE_SIM_TIME_FREQUENCY_NAME,SAVE_REMINDER_FREQUENCY_NAME];
      
      public function AutoSaveOptionsValues()
      {
         super();
      }
      
      public static function InitAutosavePanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         if(!SystemUtils.IsConsole)
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_AUTOSAVE_ON_TRAVEL,OptionsCellViewTypes.CHECKBOX,AUTOSAVE_ON_TRAVEL_NAME,Keys.OPTIONS_AUTOSAVE_ON_TRAVEL_TOOLTIP));
         }
         _loc1_.push(new OptionsData(Keys.OPTIONS_AUTOSAVE_ON_BUILD_BUY_EXIT,OptionsCellViewTypes.CHECKBOX,AUTOSAVE_ON_BUILD_BUY_EXIT_NAME,Keys.OPTIONS_AUTOSAVE_ON_BUILD_BUY_EXIT_TOOLTIP));
         _loc1_.push(new OptionsData(Keys.OPTIONS_AUTOSAVE_REAL_TIME_ENABLED,OptionsCellViewTypes.DROPDOWN,AUTOSAVE_REAL_TIME_FREQUENCY_NAME,Keys.OPTIONS_AUTOSAVE_REAL_TIME_ENABLED_TOOLTIP,null,GetDropdownOptionItems));
         _loc1_.push(new OptionsData(Keys.OPTIONS_AUTOSAVE_SIM_TIME_FREQUENCY,OptionsCellViewTypes.DROPDOWN,AUTOSAVE_SIM_TIME_FREQUENCY_NAME,Keys.OPTIONS_AUTOSAVE_SIM_TIME_FREQUENCY_TOOLTIP,null,GetDropdownOptionItems));
         return _loc1_;
      }
      
      public static function InitSaveReminderPanelOptionsData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_SAVE_REMINDER_FREQUENCY,OptionsCellViewTypes.DROPDOWN,SAVE_REMINDER_FREQUENCY_NAME,Keys.OPTIONS_SAVE_REMINDER_FREQUENCY_TOOLTIP,null,GetDropdownOptionItems));
         return _loc1_;
      }
      
      public static function GetDropdownOptionItems(param1:String) : Array
      {
         var _loc2_:int = CONTROLS_DROPDOWN_OPTION_NAMES.indexOf(param1);
         if(_loc2_ != -1)
         {
            return CONTROLS_DROPDOWN_ITEMS[_loc2_];
         }
         return null;
      }
   }
}

