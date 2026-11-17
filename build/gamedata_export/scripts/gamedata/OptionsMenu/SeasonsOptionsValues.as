package gamedata.OptionsMenu
{
   import gamedata.GameContent;
   import olympus.controls.objects.MenuItem;
   import olympus.localization.Keys;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   import widgets.OptionsMenu.controls.OptionsData;
   
   public final class SeasonsOptionsValues
   {
      
      public static const WEATHER_OPTION_WEATHER_ENABLED:int = 0;
      
      public static const WEATHER_OPTION_DISABLE_STORMS:int = 1;
      
      public static const WEATHER_OPTION_WEATHER_DISABLED:int = 2;
      
      public static const SEASON_LENGTH_NORMAL_SEASON:int = 0;
      
      public static const SEASON_LENGTH_LONG_SEASON:int = 1;
      
      public static const SEASON_LENGTH_VERY_LONG_SEASON:int = 2;
      
      public static const RAIN_OPTIONS_NAME:String = "RainOptions";
      
      public static const RAIN_OPTIONS_VALUES:Array = [new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_RAIN_ALL_ENABLED.toString(),WEATHER_OPTION_WEATHER_ENABLED),new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_RAIN_ONLY.toString(),WEATHER_OPTION_DISABLE_STORMS),new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_NONE.toString(),WEATHER_OPTION_WEATHER_DISABLED)];
      
      public static const SNOW_OPTIONS_NAME:String = "SnowOptions";
      
      public static const SNOW_OPTIONS_VALUES:Array = [new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_SNOW_ALL_ENABLED.toString(),WEATHER_OPTION_WEATHER_ENABLED),new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_SNOW_ONLY.toString(),WEATHER_OPTION_DISABLE_STORMS),new MenuItem(Keys.OPTIONS_SEASONS_WEATHER_OPTION_NONE.toString(),WEATHER_OPTION_WEATHER_DISABLED)];
      
      public static const SEASON_LENGTH_NAME:String = "SeasonLength";
      
      public static const SEASON_LENGTH_VALUES:Array = [new MenuItem(Keys.OPTIONS_SEASONS_SEASON_LENGTH_NORMAL.toString(),SEASON_LENGTH_NORMAL_SEASON),new MenuItem(Keys.OPTIONS_SEASONS_SEASON_LENGTH_LONG.toString(),SEASON_LENGTH_LONG_SEASON),new MenuItem(Keys.OPTIONS_SEASONS_SEASON_LENGTH_VERY_LONG.toString(),SEASON_LENGTH_VERY_LONG_SEASON)];
      
      public static const TEMPERATURE_EFFECTS_NAME:String = "TemperatureEffects";
      
      public static const THUNDER_SNOW_STORMS:String = "ThunderSnowStorms";
      
      public static const ICY_CONDITIONS:String = "IcyConditions";
      
      public static const SNOW_ENABLED:String = "SnowEnabled";
      
      public static const SUMMIT_SECTION_WARNING_NAME:String = "SummitNoSnowWarning";
      
      public static const CONTROLS_DROPDOWN_ITEMS:Array = [SEASON_LENGTH_VALUES,RAIN_OPTIONS_VALUES,SNOW_OPTIONS_VALUES];
      
      public static const CONTROLS_DROPDOWN_OPTION_NAMES:Array = [SEASON_LENGTH_NAME,RAIN_OPTIONS_NAME,SNOW_OPTIONS_NAME];
      
      public static const CONTROLS_CHECKBOX_OPTION_NAME:Array = [TEMPERATURE_EFFECTS_NAME];
      
      public static const SUMMIT_CHECKBOX_OPTION_NAME:Array = [THUNDER_SNOW_STORMS,ICY_CONDITIONS];
      
      public static const SUMMIT_CHECKBOX_OPTION_NAME_NO_EP05:Array = [THUNDER_SNOW_STORMS,ICY_CONDITIONS,SNOW_OPTIONS_NAME];
      
      public static const NO_SNOW_DROPDOWN:int = 2;
      
      public static const SNOW_AND_BLIZZARD_DROPDOWN:int = 0;
      
      public function SeasonsOptionsValues()
      {
         super();
      }
      
      public static function InitSeasonsPanelData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_SEASONS_RAIN_OPTIONS,OptionsCellViewTypes.DROPDOWN,RAIN_OPTIONS_NAME,null,null,GetDropdownOptionItems));
         _loc1_.push(new OptionsData(Keys.OPTIONS_SEASONS_SNOW_OPTIONS,OptionsCellViewTypes.DROPDOWN,SNOW_OPTIONS_NAME,null,null,GetDropdownOptionItems));
         _loc1_.push(new OptionsData(Keys.OPTIONS_SEASONS_TEMPERATURE_EFFECTS,OptionsCellViewTypes.CHECKBOX,TEMPERATURE_EFFECTS_NAME,Keys.OPTIONS_SEASONS_TEMPERATURE_EFFECTS_TOOLTIP));
         _loc1_.push(new OptionsData(Keys.OPTIONS_SEASONS_SEASON_LENGTH,OptionsCellViewTypes.DROPDOWN,SEASON_LENGTH_NAME,null,Keys.OPTIONS_SEASONS_SEASON_LENGTH_TOOLTIP,GetDropdownOptionItems));
         return _loc1_;
      }
      
      public static function InitSummitPanelData() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new OptionsData(Keys.OPTIONS_SUMMIT_NO_SNOW_WARNING,OptionsCellViewTypes.SECTION_WARNING,SUMMIT_SECTION_WARNING_NAME));
         _loc1_.push(new OptionsData(Keys.OPTIONS_SUMMIT_THUNDER_SNOW_STORMS,OptionsCellViewTypes.CHECKBOX,THUNDER_SNOW_STORMS,Keys.OPTIONS_SUMMIT_THUNDER_SNOW_STORMS_TOOLTIP));
         _loc1_.push(new OptionsData(Keys.OPTIONS_SUMMIT_ICY_CONDITIONS,OptionsCellViewTypes.CHECKBOX,ICY_CONDITIONS,Keys.OPTIONS_SUMMIT_ICY_CONDITIONS_TOOLTIP));
         if(!GameContent.HAS_EP05)
         {
            _loc1_.push(new OptionsData(Keys.OPTIONS_SUMMIT_ENABLE_SNOW,OptionsCellViewTypes.CHECKBOX,SNOW_OPTIONS_NAME,Keys.OPTIONS_SUMMIT_ENABLE_SNOW_TOOLTIP,null,null,true));
         }
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

