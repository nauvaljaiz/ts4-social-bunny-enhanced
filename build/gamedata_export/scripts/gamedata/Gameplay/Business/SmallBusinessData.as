package gamedata.Gameplay.Business
{
   import gamedata.Gameplay.Clubs.ClubConductRule;
   import gamedata.Gameplay.Clubs.ClubCriteria;
   import olympus.core.OlympusObject;
   
   public class SmallBusinessData extends OlympusObject
   {
      
      public static const ATTENDANCE_SALE_DISABLED:int = 0;
      
      public static const ATTENDANCE_SALE_HOURLY_FEE:int = 1;
      
      public static const ATTENDANCE_SALE_ENTRY_FEE:int = 2;
      
      public static const EMPLOYEE_SALARY_LOW:int = 0;
      
      public static const EMPLOYEE_SALARY_AVERAGE:int = 1;
      
      public static const EMPLOYEE_SALARY_HIGH:int = 2;
      
      public var sim_id:String;
      
      public var description:String;
      
      public var customer_rules:Array = [ClubConductRule];
      
      public var attendance_criteria:Array = [ClubCriteria];
      
      public var attendance_sale_mode:uint = 0;
      
      public function SmallBusinessData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.customer_rules);
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_["sim_id"] = this.sim_id;
         _loc1_["description"] = this.description;
         _loc1_["customer_rules"] = this.RulesArrayToObject();
         _loc1_["attendance_criteria"] = this.CriteriaArrayToObject();
         _loc1_["attendance_sale_mode"] = this.attendance_sale_mode;
         return _loc1_;
      }
      
      public function RulesArrayToObject() : Array
      {
         var _loc1_:int = int(this.customer_rules.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.customer_rules[_loc3_] as ClubConductRule).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function CriteriaArrayToObject() : Array
      {
         var _loc1_:int = int(this.attendance_criteria.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.attendance_criteria[_loc3_] as ClubCriteria).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

