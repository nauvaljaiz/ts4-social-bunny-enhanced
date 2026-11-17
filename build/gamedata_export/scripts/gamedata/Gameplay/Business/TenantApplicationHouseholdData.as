package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.utils.ArrayUtils;
   
   public class TenantApplicationHouseholdData extends OlympusObject
   {
      
      public var household_name:String;
      
      public var household_occupants:Array = [TenantApplicationHouseholdOccupantData];
      
      public var desired_beds:int;
      
      public var desired_rent:Array = [TenantApplicationDesiredRentData];
      
      public var household_id:String;
      
      public var zone_id:String;
      
      public var household_name_key:uint;
      
      public var mNumStars:int;
      
      public var mMaxRent:int;
      
      public var mNumBeds:int;
      
      public var mEditedRentPrice:int;
      
      public function TenantApplicationHouseholdData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.household_occupants);
         FixupArray(this.desired_rent);
         if(this.household_name_key != 0)
         {
            this.household_name = LocKey.FromHash(this.household_name_key).toString();
         }
      }
      
      public function GetDesiredRent() : int
      {
         var _loc1_:int = ArrayUtils.IndexOfByFieldName(this.desired_rent,"star_rating",this.mNumStars);
         if(_loc1_ == -1)
         {
            return this.mMaxRent;
         }
         return Math.ceil(this.mMaxRent * this.desired_rent[_loc1_].rent_multiplier);
      }
   }
}

