package widgets.BuildBuy.VenueConfiguration.controls
{
   public class VenueRequirementsData
   {
      
      protected var mTierObjectList:Array = new Array();
      
      protected var mRequiredObjectList:Array = new Array();
      
      protected var mRestrictionList:Array = new Array();
      
      protected var mOptionalObjectList:Array = new Array();
      
      protected var mForbiddenObjectList:Array = new Array();
      
      protected var mTierList:Object;
      
      protected var mIsFulfilled:Boolean;
      
      protected var mIsLotFulfilled:Boolean;
      
      protected var mIsTiersFulfilled:Boolean;
      
      protected var mCurrentTier:int = -1;
      
      public function VenueRequirementsData()
      {
         super();
      }
      
      public function get TierObjectList() : Array
      {
         return this.mTierObjectList;
      }
      
      public function get RequiredObjectList() : Array
      {
         return this.mRequiredObjectList;
      }
      
      public function get RestrictionList() : Array
      {
         return this.mRestrictionList;
      }
      
      public function get OptionalObjectList() : Array
      {
         return this.mOptionalObjectList;
      }
      
      public function get ForbiddenObjectList() : Array
      {
         return this.mForbiddenObjectList;
      }
      
      public function set TierList(param1:Object) : void
      {
         this.mTierList = param1;
      }
      
      public function get TierList() : Object
      {
         return this.mTierList;
      }
      
      public function set IsFulfilled(param1:Boolean) : void
      {
         this.mIsFulfilled = param1;
      }
      
      public function get IsFulfilled() : Boolean
      {
         return this.mIsFulfilled;
      }
      
      public function set IsLotFulfilled(param1:Boolean) : void
      {
         this.mIsLotFulfilled = param1;
      }
      
      public function get IsLotFulfilled() : Boolean
      {
         return this.mIsLotFulfilled;
      }
      
      public function get IsTiersFulfilled() : Boolean
      {
         return !this.TierList || this.CurrentTier != -1;
      }
      
      public function set CurrentTier(param1:int) : void
      {
         this.mCurrentTier = param1;
      }
      
      public function get CurrentTier() : int
      {
         return this.mCurrentTier;
      }
      
      public function get HasData() : Boolean
      {
         return this.mTierObjectList.length > 0 || this.mRequiredObjectList.length > 0 || this.mRestrictionList.length > 0 || this.mOptionalObjectList.length > 0 || this.mForbiddenObjectList.length > 0;
      }
      
      public function get OnlyHasOptionalData() : Boolean
      {
         return this.mTierObjectList.length == 0 && this.mRequiredObjectList.length == 0 && this.mRestrictionList.length == 0 && this.mForbiddenObjectList.length == 0 && this.mOptionalObjectList.length > 0;
      }
   }
}

