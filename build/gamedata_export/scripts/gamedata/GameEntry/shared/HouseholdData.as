package gamedata.GameEntry.shared
{
   import flash.utils.Dictionary;
   import gamedata.GameEntry.Neighborhood.NeighborhoodData;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.Gameplay.shared.StoryProgression;
   import gamedata.shared.HouseholdSimData;
   import gamedata.shared.OccultTypes;
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.Species;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGE;
   
   public class HouseholdData extends OlympusObject
   {
      
      protected static var sStarterFunds:int;
      
      public var familyId:String;
      
      public var familyName:String;
      
      public var familyFunds:int;
      
      public var familyLotId:String;
      
      public var isNPC:Boolean;
      
      public var isPlayerProtected:Boolean;
      
      public var familyBio:String;
      
      public var familySims:Array = new Array();
      
      protected var mFamilyNeighborhoodId:String;
      
      public function HouseholdData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StarterFunds() : Number
      {
         if(!sStarterFunds)
         {
            sStarterFunds = CommunicationManager.CallGameService("GetHouseholdStarterFunds") as int;
         }
         return sStarterFunds;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.familyId = param1.familyId;
         this.familyName = param1.familyName;
         this.familyFunds = param1.familyFunds;
         this.familyLotId = param1.familyLotId;
         this.isPlayerProtected = param1.isPlayerProtected;
         this.isNPC = param1.isNPC;
         this.familyBio = param1.familyBio;
         this.familySims = new Array();
         if("familySims" in param1)
         {
            ConstructArrayFromArray(this.familySims,param1.familySims,HouseholdSimData);
         }
      }
      
      public function Update(param1:HouseholdData) : void
      {
         this.familyName = param1.familyName;
         this.familyFunds = param1.familyFunds;
         this.familyLotId = param1.familyLotId;
         this.familySims = param1.familySims != null ? param1.familySims.concat([]) : new Array();
         this.isNPC = param1.isNPC;
         this.isPlayerProtected = param1.isPlayerProtected;
         this.familyBio = param1.familyBio;
         this.mFamilyNeighborhoodId = null;
      }
      
      public function get IsHomeless() : Boolean
      {
         return !this.familyLotId || this.familyLotId == "0";
      }
      
      public function get IsEmpty() : Boolean
      {
         return this.familySims.length <= 0;
      }
      
      public function GetNeighborhoodName() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(this.IsHomeless)
         {
            _loc1_ = KeysGE.HOUSEHOLD_ITEM_RENDERER_HOMELESS_LABEL.toString();
         }
         else
         {
            _loc2_ = CommunicationManager.CallUIService("GetNeighborhoodName",this.FamilyNeighborhoodId) as String;
            if(_loc2_)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function get MovingFunds() : int
      {
         var _loc2_:Object = null;
         var _loc3_:NeighborhoodLotData = null;
         var _loc1_:int = this.familyFunds;
         if(!this.IsHomeless && this.CanSellLotAndFurniture())
         {
            _loc2_ = CommunicationManager.CallUIService("GetNeighborhoodLotData",this.familyLotId);
            _loc3_ = _loc2_ as NeighborhoodLotData;
            if(_loc3_)
            {
               _loc1_ += _loc3_.LotPrice + _loc3_.HousePrice;
            }
         }
         return _loc1_;
      }
      
      public function CanSellLotAndFurniture() : Boolean
      {
         if(this.IsHomeless)
         {
            return false;
         }
         return !this.LivesAtUniversityHousing();
      }
      
      public function get FamilyNeighborhoodId() : String
      {
         var _loc1_:NeighborhoodData = null;
         if(!this.mFamilyNeighborhoodId)
         {
            _loc1_ = CommunicationManager.CallUIService("GetNeighborhoodByLot",this.familyLotId) as NeighborhoodData;
            if(_loc1_)
            {
               this.mFamilyNeighborhoodId = _loc1_.id;
            }
         }
         return this.mFamilyNeighborhoodId;
      }
      
      public function get FamilySimIds() : Array
      {
         return this.familySims.map(function(param1:HouseholdSimData, param2:int, param3:Array):String
         {
            return param1.id;
         });
      }
      
      public function IsSimInFamily(param1:String) : Boolean
      {
         var _loc2_:Array = this.FamilySimIds;
         return _loc2_.indexOf(param1) >= 0;
      }
      
      public function ContainsAdults() : Boolean
      {
         var _loc2_:HouseholdSimData = null;
         var _loc1_:Array = this.familySims;
         for each(_loc2_ in _loc1_)
         {
            if(!Species.IsPet(_loc2_.species))
            {
               if(SimAgeTypes.IsTeenOrOlder(_loc2_.age))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function GetNumAdults() : uint
      {
         var _loc3_:HouseholdSimData = null;
         var _loc1_:uint = 0;
         var _loc2_:Array = this.familySims;
         for each(_loc3_ in _loc2_)
         {
            if(!Species.IsPet(_loc3_.species))
            {
               if(SimAgeTypes.IsTeenOrOlder(_loc3_.age))
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function GetNumSimsAndPendingBabies() : uint
      {
         var _loc3_:HouseholdSimData = null;
         var _loc1_:Array = this.familySims;
         var _loc2_:uint = 0;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isPregnant)
            {
               _loc2_++;
            }
         }
         return _loc1_.length + _loc2_;
      }
      
      public function LivesAtUniversityHousing() : Boolean
      {
         if(!this.familyLotId || this.familyLotId == "0")
         {
            return false;
         }
         var _loc1_:NeighborhoodLotData = new NeighborhoodLotData(CommunicationManager.CallGameService("GetNeighborhoodLotData",this.familyLotId));
         if(_loc1_ == null || _loc1_.venueData == null || !_loc1_.venueData.IsUniversityHousingLot)
         {
            return false;
         }
         return true;
      }
      
      public function GetParentStoryProgressionDomain() : uint
      {
         return this.isPlayerProtected ? StoryProgression.STORY_PROGRESSION_DOMAIN_MY_HOUSEHOLDS : StoryProgression.STORY_PROGRESSION_DOMAIN_OTHER_HOUSEHOLDS;
      }
      
      public function GetOccultCounts() : Dictionary
      {
         var _loc3_:HouseholdSimData = null;
         var _loc4_:int = 0;
         var _loc1_:Array = this.familySims;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in _loc1_)
         {
            if(Species.IsHuman(_loc3_.species))
            {
               _loc4_ = OccultTypes.GetRealOccultType(_loc3_.allOccultTypes);
               _loc2_[_loc4_] = _loc4_ in _loc2_ ? _loc2_[_loc4_] + 1 : 1;
            }
         }
         return _loc2_;
      }
      
      public function GetNumHorses() : Number
      {
         var _loc3_:HouseholdSimData = null;
         var _loc1_:Array = this.familySims;
         var _loc2_:Number = 0;
         for each(_loc3_ in _loc1_)
         {
            if(Species.IsHorse(_loc3_.species))
            {
               _loc2_ += 1;
            }
         }
         return _loc2_;
      }
      
      public function GetNumUnicorns() : Number
      {
         var _loc3_:HouseholdSimData = null;
         var _loc1_:Array = this.familySims;
         var _loc2_:Number = 0;
         for each(_loc3_ in _loc1_)
         {
            if(Species.IsHorse(_loc3_.species))
            {
               if(_loc3_.isUnicorn)
               {
                  _loc2_ += 1;
               }
            }
         }
         return _loc2_;
      }
   }
}

