package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class RentalUnitManagementData extends OlympusObject
   {
      
      public var zone_id:String;
      
      public var is_application_process:Boolean;
      
      public var house_description_id:String;
      
      public var is_tenant_view:Boolean;
      
      public var rental_unit_data:RentalUnitData = new RentalUnitData();
      
      public var potential_tenants:* = new TenantApplicationsPanelData();
      
      public var remaining_lease:int;
      
      public var npc_property_owner_household_id:String;
      
      public function RentalUnitManagementData(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetRentalUnitData() : RentalUnitData
      {
         var _loc1_:Object = null;
         var _loc2_:RentalUnitData = null;
         if(!this.rental_unit_data.zoneId)
         {
            _loc1_ = CommunicationManager.CallGameService("GetUnitInfo",{
               "zoneId":this.zone_id,
               "houseDescriptionId":this.house_description_id
            });
            _loc2_ = null;
            if(_loc1_)
            {
               _loc2_ = new RentalUnitData(_loc1_);
            }
            this.rental_unit_data = _loc2_;
         }
         this.rental_unit_data.SetOccupantVenueOwnerData(this.npc_property_owner_household_id);
         return this.rental_unit_data;
      }
   }
}

