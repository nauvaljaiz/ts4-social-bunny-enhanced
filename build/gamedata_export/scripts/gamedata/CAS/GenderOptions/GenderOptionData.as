package gamedata.CAS.GenderOptions
{
   import gamedata.shared.SimGenderTypes;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class GenderOptionData extends OlympusObject
   {
      
      public var optionNameList:Array = [GenderOptionNameData];
      
      public var optionValueList:Array = [GenderOptionValueData];
      
      public var casSimCustomizationOptionType:int;
      
      public function GenderOptionData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.optionNameList);
         FixupArray(this.optionValueList);
      }
      
      public function GetOptionNameForSimAge(param1:int) : GenderOptionNameData
      {
         var _loc3_:GenderOptionNameData = null;
         var _loc2_:Array = this.optionNameList;
         if(_loc2_.length == 0)
         {
            return null;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.age == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_[0];
      }
      
      public function GetSelectedOptionIndices(param1:Array, param2:int) : Array
      {
         var _loc7_:GenderOptionValueData = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = this.optionValueList;
         var _loc6_:int = 0;
         for(; _loc6_ < _loc5_.length; _loc6_++)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc8_ = 0;
            for each(_loc9_ in _loc7_.traitIdList)
            {
               if(param1.indexOf(_loc9_) != -1)
               {
                  _loc8_++;
               }
            }
            _loc10_ = _loc8_ == _loc7_.traitIdList.length;
            if(_loc10_)
            {
               _loc3_.push(_loc6_);
            }
            else
            {
               _loc11_ = _loc7_.unselectedTraitIdList.length != 0;
               if(_loc11_)
               {
                  _loc12_ = 0;
                  for each(_loc9_ in _loc7_.unselectedTraitIdList)
                  {
                     if(param1.indexOf(_loc9_) != -1)
                     {
                        _loc12_++;
                     }
                  }
                  if(_loc12_ == _loc7_.unselectedTraitIdList.length)
                  {
                     continue;
                  }
               }
               if(param2 == SimGenderTypes.FEMALE && _loc7_.isFemaleDefault || param2 == SimGenderTypes.MALE && _loc7_.isMaleDefault)
               {
                  if(_loc11_)
                  {
                     _loc3_.push(_loc6_);
                  }
                  else
                  {
                     _loc4_.push(_loc6_);
                  }
               }
            }
         }
         return _loc3_.length > 0 || _loc4_.length == 0 ? _loc3_ : _loc4_;
      }
      
      public function ShouldAllowDeselection() : Boolean
      {
         var _loc2_:GenderOptionValueData = null;
         var _loc1_:Array = this.optionValueList;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.unselectedTraitIdList.length != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetTooltipForAge(param1:int) : LocKey
      {
         var _loc2_:GenderOptionNameData = this.GetOptionNameForSimAge(param1);
         if(_loc2_ != null)
         {
            return _loc2_.tooltip;
         }
         return null;
      }
   }
}

