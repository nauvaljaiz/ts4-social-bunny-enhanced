package gamedata.GameEntry.Neighborhood
{
   import gamedata.GameEntry.shared.HouseholdData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class TravelGroupData extends OlympusObject
   {
      
      public static const GROUPTYPE_VACATION:int = 0;
      
      public static const GROUPTYPE_STAYOVER:int = 1;
      
      public static const GROUPTYPE_GETAWAY:int = 2;
      
      public var travel_group_id:String;
      
      public var household_sim_ids:Array = [HouseholdSimIds];
      
      public var zone_id:String;
      
      public var played:Boolean;
      
      public var create_time:String;
      
      public var end_time:String;
      
      public var group_type:int;
      
      public var isPlayerProtected:Boolean;
      
      public function TravelGroupData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.household_sim_ids);
      }
      
      public function Update(param1:TravelGroupData) : void
      {
         var _loc3_:HouseholdSimIds = null;
         this.played = param1.played;
         this.household_sim_ids = param1.household_sim_ids;
         this.isPlayerProtected = param1.isPlayerProtected;
         var _loc2_:Array = this.household_sim_ids;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.PopulateSimData(true);
         }
      }
      
      public function get NumHouseholds() : uint
      {
         return this.household_sim_ids.length;
      }
      
      public function get LastPlayedHousehold() : HouseholdData
      {
         var _loc1_:Array = null;
         _loc1_ = this.household_sim_ids;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = _loc1_[_loc4_].household_id;
            _loc4_++;
         }
         var _loc5_:Object = CommunicationManager.CallGameService("GetLastPlayedFamilyInfoFromList",_loc3_);
         return new HouseholdData(_loc5_);
      }
      
      public function get AllSims() : Array
      {
         var _loc3_:HouseholdSimIds = null;
         var _loc1_:Array = this.household_sim_ids;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            _loc3_.PopulateSimData();
            _loc2_ = _loc2_.concat(_loc3_.mSimData);
         }
         return _loc2_;
      }
   }
}

