package widgets.OptionsMenu.controls
{
   import olympus.localization.LocKey;
   import widgets.OptionsMenu.constants.OptionsCellViewTypes;
   
   public class OptionsData
   {
      
      public var description:LocKey;
      
      public var bIsEnabled:Boolean = true;
      
      public var bLifespanUpdate:Boolean = false;
      
      public var bNPCBlackmailUpdate:Boolean = false;
      
      public var bLunarCycleLockedUpdate:Boolean = false;
      
      public var bRestoreDefault:Boolean = false;
      
      public var bRevertChanges:Boolean = false;
      
      public var bSimCountWarning:Boolean = false;
      
      public var bSpecialCasePreventUpdate:Boolean = false;
      
      public var bIsVisible:Boolean = true;
      
      public var dropdownDataCallback:Function;
      
      public var labelKey:LocKey;
      
      public var name:String;
      
      public var simCount:String = "xx/xx";
      
      public var tooltip:LocKey;
      
      public var type:uint;
      
      public var previousCheckboxValue:Boolean;
      
      public var previousDropdownValue:int;
      
      public var currentCheckboxValue:Boolean;
      
      public var currentDropdownValue:int;
      
      public var linkedOptionsDataOne:OptionsData;
      
      public var linkedOptionsDataTwo:OptionsData;
      
      public function OptionsData(param1:LocKey, param2:uint, param3:String, param4:LocKey = null, param5:LocKey = null, param6:Function = null, param7:Boolean = false)
      {
         super();
         this.description = param5;
         this.dropdownDataCallback = param6;
         this.labelKey = param1;
         this.name = param3;
         this.tooltip = param4;
         this.type = param2;
         this.bSpecialCasePreventUpdate = param7;
      }
      
      protected function IsCheckboxDirty() : Boolean
      {
         return this.previousCheckboxValue != this.currentCheckboxValue;
      }
      
      protected function IsDropdownDirty() : Boolean
      {
         return this.previousDropdownValue != this.currentDropdownValue;
      }
      
      public function IsOptionsDataDirty() : Boolean
      {
         if(this.type as uint == OptionsCellViewTypes.CHECKBOX)
         {
            return this.IsCheckboxDirty();
         }
         if(this.type as uint == OptionsCellViewTypes.DROPDOWN)
         {
            return this.IsDropdownDirty();
         }
         return false;
      }
   }
}

