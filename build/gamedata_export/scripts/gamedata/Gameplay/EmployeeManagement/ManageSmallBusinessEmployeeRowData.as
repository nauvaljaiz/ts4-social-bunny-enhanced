package gamedata.Gameplay.EmployeeManagement
{
   import gamedata.Gameplay.Clubs.ClubConductRule;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.objects.RelationshipInfo;
   
   public class ManageSmallBusinessEmployeeRowData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var pay:uint;
      
      public var skill_data:Array = [ManageEmployeeSkillData];
      
      public var rules:Array = [ClubConductRule];
      
      public var is_fake_payment_enabled:Boolean;
      
      public var salary_icon:ResourceKey = new ResourceKey();
      
      public var has_no_potential_employees:Boolean = false;
      
      public var mbCurrentEmployee:Boolean = false;
      
      public var mRelInfo:RelationshipInfo;
      
      public function ManageSmallBusinessEmployeeRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.skill_data);
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_["sim_id"] = this.sim_id;
         _loc1_["rules"] = this.RulesArrayToObject();
         return _loc1_;
      }
      
      public function RulesArrayToObject() : Array
      {
         var _loc1_:int = int(this.rules.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.rules[_loc3_] as ClubConductRule).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

