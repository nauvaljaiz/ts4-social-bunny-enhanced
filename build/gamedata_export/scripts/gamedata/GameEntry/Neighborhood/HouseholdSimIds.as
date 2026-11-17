package gamedata.GameEntry.Neighborhood
{
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.shared.HouseholdSimData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class HouseholdSimIds extends OlympusObject
   {
      
      public var household_id:String;
      
      public var sim_ids:Array = [String];
      
      public var mSimData:Array = [HouseholdSimData];
      
      public var bHomeless:Boolean;
      
      public function HouseholdSimIds(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
         FixupArray(this.mSimData);
      }
      
      public function HasSim(param1:String) : Boolean
      {
         return this.sim_ids.indexOf(param1) != -1;
      }
      
      public function FindSimData(param1:String) : HouseholdSimData
      {
         var _loc3_:HouseholdSimData = null;
         var _loc2_:Array = this.mSimData;
         for each(_loc3_ in _loc2_)
         {
            if(param1 == _loc3_.id)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function PopulateSimData(param1:Boolean = false) : void
      {
         var _loc6_:HouseholdSimData = null;
         if(!param1 && this.mSimData.length != 0)
         {
            return;
         }
         var _loc2_:Object = CommunicationManager.CallGameService("GetFamilyInfo",this.household_id);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = this.mSimData;
         _loc3_.length = 0;
         var _loc4_:HouseholdData = new HouseholdData(_loc2_);
         var _loc5_:Array = _loc4_.familySims;
         for each(_loc6_ in _loc5_)
         {
            if(this.HasSim(_loc6_.id))
            {
               _loc3_.push(_loc6_);
            }
         }
         this.bHomeless = _loc4_.IsHomeless;
      }
   }
}

