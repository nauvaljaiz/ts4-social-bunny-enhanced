package gamedata.OptionsMenu
{
   import olympus.controls.objects.MenuItem;
   import olympus.localization.Keys;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   import widgets.OptionsMenu.controls.OptionsData;
   
   public final class LunarCycleOptionsValues
   {
      
      public static const CYCLE_LENGTH_TWO_DAY:int = 0;
      
      public static const CYCLE_LENGTH_FOUR_DAY:int = 1;
      
      public static const CYCLE_LENGTH_FULL_LENGTH:int = 2;
      
      public static const CYCLE_LENGTH_DOUBLE_LENGTH:int = 3;
      
      public static const CYCLE_LENGTH_TRIPLE_LENGTH:int = 4;
      
      public static const PHASE_LOCKED_NEW_MOON:int = 0;
      
      public static const PHASE_LOCKED_WAXING_CRESCENT:int = 1;
      
      public static const PHASE_LOCKED_FIRST_QUARTER:int = 2;
      
      public static const PHASE_LOCKED_WAXING_GIBBOUS:int = 3;
      
      public static const PHASE_LOCKED_FULL_MOON:int = 4;
      
      public static const PHASE_LOCKED_WANING_GIBBOUS:int = 5;
      
      public static const PHASE_LOCKED_THIRD_QUARTER:int = 6;
      
      public static const PHASE_LOCKED_WANING_CRESCENT:int = 7;
      
      public static const PHASE_LOCKED_NO_LOCK:int = 8;
      
      public static const CYCLE_LENGTH_NAME:String = "LunarCycleLength";
      
      public static const CYCLE_LENGTH_VALUES:Array = [new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_TWO_DAYS.toString(),CYCLE_LENGTH_TWO_DAY),new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_FOUR_DAYS.toString(),CYCLE_LENGTH_FOUR_DAY),new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_EIGHT_DAYS.toString(),CYCLE_LENGTH_FULL_LENGTH),new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_SIXTEEN_DAYS.toString(),CYCLE_LENGTH_DOUBLE_LENGTH),new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_TWENTY_FOUR_DAYS.toString(),CYCLE_LENGTH_TRIPLE_LENGTH)];
      
      public static const PHASE_LOCKED_NAME:String = "LunarPhaseLock";
      
      public static const PHASE_LOCKED_VALUES:Array = [new MenuItem(Keys.OPTIONS_LUNAR_CYCLE_LOCKED_PHASE_DISABLED.toString(),PHASE_LOCKED_NO_LOCK),new MenuItem(Keys.LUNAR_CYCLE_PHASE_NEW_MOON.toString(),PHASE_LOCKED_NEW_MOON),new MenuItem(Keys.LUNAR_CYCLE_PHASE_WAXING_CRESCENT.toString(),PHASE_LOCKED_WAXING_CRESCENT),new MenuItem(Keys.LUNAR_CYCLE_PHASE_FIRST_QUARTER.toString(),PHASE_LOCKED_FIRST_QUARTER),new MenuItem(Keys.LUNAR_CYCLE_PHASE_WAXING_GIBBOUS.toString(),PHASE_LOCKED_WAXING_GIBBOUS),new MenuItem(Keys.LUNAR_CYCLE_PHASE_FULL_MOON.toString(),PHASE_LOCKED_FULL_MOON),new MenuItem(Keys.LUNAR_CYCLE_PHASE_WANING_GIBBOUS.toString(),PHASE_LOCKED_WANING_GIBBOUS),new MenuItem(Keys.LUNAR_CYCLE_PHASE_THIRD_QUARTER.toString(),PHASE_LOCKED_THIRD_QUARTER),new MenuItem(Keys.LUNAR_CYCLE_PHASE_WANING_CRESCENT.toString(),PHASE_LOCKED_WANING_CRESCENT)];
      
      public static const LUNAR_EFFECTS_NAME:String = "DisableLunarEffects";
      
      public static const CONTROLS_DROPDOWN_ITEMS:Array = [CYCLE_LENGTH_VALUES,PHASE_LOCKED_VALUES];
      
      public static const CONTROLS_DROPDOWN_OPTION_NAMES:Array = [CYCLE_LENGTH_NAME,PHASE_LOCKED_NAME];
      
      public static const CONTROLS_CHECKBOX_OPTION_NAME:Array = [LUNAR_EFFECTS_NAME];
      
      public function LunarCycleOptionsValues()
      {
         super();
      }
      
      public static function InitLunarCyclePanelData() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:OptionsData = new OptionsData(Keys.OPTIONS_LUNAR_CYCLE_LENGTH_OPTION,OptionsCellViewTypes.DROPDOWN,CYCLE_LENGTH_NAME,Keys.OPTIONS_LUNAR_CYCLE_LENGTH_OPTION_TOOLTIP,null,GetDropdownOptionItems);
         var _loc3_:OptionsData = new OptionsData(Keys.OPTIONS_LUNAR_CYCLE_LOCKED_PHASE_OPTION,OptionsCellViewTypes.DROPDOWN,PHASE_LOCKED_NAME,Keys.OPTIONS_LUNAR_CYCLE_LOCKED_PHASE_OPTION_TOOLTIP,null,GetDropdownOptionItems);
         _loc2_.linkedOptionsDataOne = _loc3_;
         _loc1_.push(_loc2_);
         _loc1_.push(_loc3_);
         _loc1_.push(new OptionsData(Keys.OPTIONS_LUNAR_CYCLE_LUNAR_EFFECTS,OptionsCellViewTypes.CHECKBOX,LUNAR_EFFECTS_NAME,Keys.OPTIONS_LUNAR_CYCLE_LUNAR_EFFECTS_TOOLTIP));
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

