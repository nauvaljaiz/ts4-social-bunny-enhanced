package gamedata.Gameplay.Clubs
{
   import gamedata.Gameplay.Clubs.constants.ClubCriteriaCategory;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class ClubCriteria extends OlympusObject
   {
      
      public static const TOOLTIP_MAX_INFOS:int = 10;
      
      public var category:uint;
      
      public var criteria_infos:Array = [ClubCriteriaInfo];
      
      public var required:Boolean = false;
      
      public var supervised:Boolean = true;
      
      public var multi_select:Boolean = false;
      
      public var criteria_id:uint;
      
      public var mbActiveSimFailed:Boolean = false;
      
      public function ClubCriteria(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.criteria_infos);
      }
      
      public function GetTooltipText(param1:Boolean = false, param2:Boolean = false) : Object
      {
         var _loc3_:String = null;
         var _loc4_:LocKey = null;
         var _loc5_:LocKey = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ClubCriteriaInfo = null;
         if(this.criteria_infos.length > 0)
         {
            _loc3_ = "";
            if(this.multi_select)
            {
               _loc6_ = new Array();
               _loc7_ = int(this.criteria_infos.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_ && _loc8_ < TOOLTIP_MAX_INFOS)
               {
                  _loc9_ = this.criteria_infos[_loc8_] as ClubCriteriaInfo;
                  _loc6_.push(_loc9_.GetTooltipDisplayName(param1));
                  _loc8_++;
               }
               if(param1)
               {
                  return _loc6_;
               }
               _loc3_ += _loc6_.join(", ");
            }
            else
            {
               _loc3_ += (this.criteria_infos[0] as ClubCriteriaInfo).GetTooltipDisplayName(param1);
            }
            _loc4_ = null;
            _loc5_ = null;
            if(param2)
            {
               _loc4_ = this.required ? KeysGP.SMALL_BUSINESS_CONFIGURATOR_TARGET_CUSTOMER_RULE_REQUIRED : KeysGP.SMALL_BUSINESS_CONFIGURATOR_TARGET_CUSTOMER_RULE_OPTIONAL;
               if(this.category == ClubCriteriaCategory.CARE_SIM_TYPE_SUPERVISED && this.supervised)
               {
                  _loc5_ = KeysGP.SMALL_BUSINESS_CONFIGURATOR_TARGET_CUSTOMER_RULE_SUPERVISED;
               }
            }
            else
            {
               _loc4_ = ClubCriteriaCategory.GetCategoryTooltipLocKey(this.category,param1);
            }
            if(_loc4_)
            {
               if(_loc5_)
               {
                  return _loc4_.toString(_loc3_) + _loc5_.toString();
               }
               return _loc4_.toString(_loc3_);
            }
         }
         return "";
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["category"] = this.category;
         _loc1_["criteria_id"] = this.criteria_id;
         _loc1_["multi_select"] = this.multi_select;
         _loc1_["required"] = this.required;
         _loc1_["supervised"] = this.supervised;
         var _loc2_:* = this.criteria_infos.length;
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = (this.criteria_infos[_loc4_] as ClubCriteriaInfo).ToObject();
            _loc4_++;
         }
         _loc1_["criteria_infos"] = _loc3_;
         return _loc1_;
      }
      
      protected function SortFunction(param1:ClubCriteriaInfo, param2:ClubCriteriaInfo) : int
      {
         if(param1.name.hash < param2.name.hash)
         {
            return -1;
         }
         return 1;
      }
      
      public function Equals(param1:ClubCriteria, param2:Boolean = false) : Boolean
      {
         if(this.category != param1.category)
         {
            return false;
         }
         if(this.required != param1.required)
         {
            return false;
         }
         if(param2 && this.category == ClubCriteriaCategory.CARE_SIM_TYPE_SUPERVISED && this.supervised != param1.supervised)
         {
            return false;
         }
         if(this.multi_select != param1.multi_select)
         {
            return false;
         }
         var _loc3_:uint = this.criteria_infos.length;
         if(_loc3_ != param1.criteria_infos.length)
         {
            return false;
         }
         this.criteria_infos.sort(this.SortFunction);
         param1.criteria_infos.sort(this.SortFunction);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            if(!this.criteria_infos[_loc4_].Equals(param1.criteria_infos[_loc4_]))
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
   }
}

