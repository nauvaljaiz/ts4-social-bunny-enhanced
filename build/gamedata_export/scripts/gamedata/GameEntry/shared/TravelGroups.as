package gamedata.GameEntry.shared
{
   import gamedata.GameEntry.Neighborhood.HouseholdSimIds;
   import gamedata.GameEntry.Neighborhood.TravelGroupData;
   import olympus.io.CommunicationManager;
   
   public class TravelGroups
   {
      
      protected var mTravelGroupDatas:Object = new Object();
      
      public function TravelGroups()
      {
         super();
      }
      
      public function get TravelGroupDatas() : Object
      {
         return this.mTravelGroupDatas;
      }
      
      public function AddOrReplace(param1:TravelGroupData) : void
      {
         this.mTravelGroupDatas[param1.travel_group_id] = param1;
      }
      
      public function Update(param1:TravelGroupData) : void
      {
         var _loc2_:TravelGroupData = this.mTravelGroupDatas[param1.travel_group_id];
         if(_loc2_)
         {
            _loc2_.Update(param1);
         }
         else
         {
            this.AddOrReplace(param1);
         }
      }
      
      public function Remove(param1:String) : void
      {
         delete this.mTravelGroupDatas[param1];
      }
      
      public function FindTravelGroup(param1:String, param2:String = null) : TravelGroupData
      {
         var _loc4_:TravelGroupData = null;
         var _loc5_:HouseholdSimIds = null;
         var _loc3_:Object = this.mTravelGroupDatas;
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc4_.household_sim_ids)
            {
               if(_loc5_.household_id == param1)
               {
                  if(param2 == null)
                  {
                     return _loc4_;
                  }
                  return _loc5_.sim_ids.indexOf(param2) == -1 ? null : _loc4_;
               }
            }
         }
         return null;
      }
      
      public function get AllSims() : Array
      {
         var _loc2_:TravelGroupData = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.mTravelGroupDatas)
         {
            _loc1_ = _loc1_.concat(_loc2_.AllSims);
         }
         return _loc1_;
      }
      
      public function GetTravelGroupSims(param1:String, param2:int) : Array
      {
         var _loc7_:TravelGroupData = null;
         var _loc8_:HouseholdSimIds = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:HouseholdSimIds = null;
         var _loc12_:String = null;
         var _loc3_:Object = this.mTravelGroupDatas;
         var _loc4_:Boolean = false;
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc7_ in _loc3_)
         {
            if(_loc7_.group_type == param2)
            {
               for each(_loc8_ in _loc7_.household_sim_ids)
               {
                  if(_loc8_.household_id == param1)
                  {
                     for each(_loc9_ in _loc8_.sim_ids)
                     {
                        _loc5_.push(_loc9_);
                     }
                     _loc4_ = true;
                     break;
                  }
               }
               if(_loc4_)
               {
                  _loc10_ = false;
                  for each(_loc11_ in _loc7_.household_sim_ids)
                  {
                     if(_loc11_.household_id != param1)
                     {
                        _loc11_.PopulateSimData();
                        _loc10_ = !_loc11_.bHomeless;
                        if(_loc10_)
                        {
                           break;
                        }
                        for each(_loc12_ in _loc11_.sim_ids)
                        {
                           _loc6_.push(_loc12_);
                        }
                     }
                  }
                  return _loc10_ ? _loc5_ : _loc5_.concat(_loc6_);
               }
            }
         }
         return null;
      }
      
      public function get LastPlayedHousehold() : HouseholdData
      {
         var _loc2_:TravelGroupData = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:HouseholdSimIds = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.mTravelGroupDatas)
         {
            _loc4_ = _loc2_.household_sim_ids;
            for each(_loc5_ in _loc4_)
            {
               _loc1_.push(_loc5_.household_id);
            }
         }
         _loc3_ = CommunicationManager.CallGameService("GetLastPlayedFamilyInfoFromList",_loc1_);
         return new HouseholdData(_loc3_);
      }
      
      public function HasTravelGroupType(param1:int) : Boolean
      {
         var _loc2_:TravelGroupData = null;
         for each(_loc2_ in this.mTravelGroupDatas)
         {
            if(_loc2_.group_type == param1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

