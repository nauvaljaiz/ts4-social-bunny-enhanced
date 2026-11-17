package gamedata.Gameplay.Business
{
   import gamedata.shared.GameClockTime;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class BusinessData extends OlympusObject
   {
      
      public static const INVALID_TYPE:int = 0;
      
      public static const RETAIL_TYPE:int = 1;
      
      public static const RESTAURANT_TYPE:int = 2;
      
      public static const VET_TYPE:int = 3;
      
      public static const RENTAL_UNIT_TYPE:int = 4;
      
      public static const SMALL_BUSINESS_TYPE:int = 5;
      
      public static const MULTI_BUSINESS:Array = [RENTAL_UNIT_TYPE];
      
      public static const SINGLE_BUSINESS:Array = [RETAIL_TYPE,RESTAURANT_TYPE,VET_TYPE];
      
      public static const SIM_BUSINESS:Array = [SMALL_BUSINESS_TYPE];
      
      public var name:String;
      
      public var zone_id:String;
      
      public var is_open:Boolean;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var funds:int;
      
      public var review_data:ReviewData = new ReviewData();
      
      public var net_profit:int;
      
      public var markup_chosen:Number = 0;
      
      public var daily_items_sold:uint;
      
      public var daily_outgoing_costs:uint;
      
      public var time_opened:uint;
      
      public var daily_customers_served:uint;
      
      public var minimum_employee_requirements_met:Boolean;
      
      public var sim_id:String;
      
      public var total_open_hours:int;
      
      public var total_customers_served:int;
      
      public var timeOpened:GameClockTime = new GameClockTime();
      
      public var restaurant_data:RestaurantBusinessData = new RestaurantBusinessData();
      
      public var retail_data:RetailBusinessData = new RetailBusinessData();
      
      public var vet_clinic_data:VetClinicBusinessData = new VetClinicBusinessData();
      
      public var rental_unit_data:RentalUnitBusinessData = new RentalUnitBusinessData();
      
      public var small_business_data:SmallBusinessData = new SmallBusinessData();
      
      public var allowed_zone_ids:Array = [String];
      
      public function BusinessData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("restaurant_data" in param1))
         {
            this.restaurant_data = null;
         }
         if(!("retail_data" in param1))
         {
            this.retail_data = null;
         }
         if(!("vet_clinic_data" in param1))
         {
            this.vet_clinic_data = null;
         }
         if(!("rental_unit_data" in param1))
         {
            this.rental_unit_data = null;
         }
         if(!("small_business_data" in param1))
         {
            this.small_business_data = null;
         }
         if("allowed_zone_ids" in param1)
         {
            this.allowed_zone_ids = param1.allowed_zone_ids;
         }
         else
         {
            this.allowed_zone_ids = [];
         }
      }
      
      public function GetBusinessType() : int
      {
         if(this.retail_data != null)
         {
            return RETAIL_TYPE;
         }
         if(this.restaurant_data != null)
         {
            return RESTAURANT_TYPE;
         }
         if(this.vet_clinic_data != null)
         {
            return VET_TYPE;
         }
         if(this.rental_unit_data != null)
         {
            return RENTAL_UNIT_TYPE;
         }
         if(this.small_business_data != null)
         {
            return SMALL_BUSINESS_TYPE;
         }
         return INVALID_TYPE;
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_["sim_id"] = this.sim_id;
         _loc1_["name"] = this.name;
         _loc1_["icon"] = this.icon.ToObject();
         _loc1_["markup_chosen"] = this.markup_chosen;
         if(this.small_business_data)
         {
            _loc1_["small_business_data"] = this.small_business_data.ToObject();
            _loc1_["allowed_zone_ids"] = this.allowed_zone_ids;
         }
         return _loc1_;
      }
   }
}

