package widgets.shared.data
{
   import gamedata.Exchange.CGChallengeData;
   import gamedata.Exchange.ExchangeData;
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysEXCH;
   import olympus.utils.SystemUtils;
   import widgets.shared.constants.ExchangeFiltersData;
   import widgets.shared.constants.ExchangeShareMode;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public final class ExchangeFilter extends OlympusObject
   {
      
      public var type:uint = 4;
      
      public var bIncludeLocked:Boolean = true;
      
      public var bIncludeModded:Boolean = false;
      
      public var createdByGroup:uint = 2;
      
      public var cgChallenge:CGChallengeData;
      
      public var packIds:Array = new Array();
      
      public var householdSize:int = 0;
      
      public var species:int = 0;
      
      public var venue:String = "0";
      
      public var lotSize:int = 0;
      
      public var lotPrice:int = 0;
      
      public var roomType:int = ExchangeFiltersData.DEFAULT_ROOM_TYPE_VALUE;
      
      public var roomSize:int = 0;
      
      public var roomPrice:int = 0;
      
      public var bodyType:int = 0;
      
      public var searchType:uint = 1;
      
      public var searchText:String = "";
      
      public var show:int = 4;
      
      public var startIndex:uint;
      
      public var endIndex:uint;
      
      public var pendingIndex:uint;
      
      public var bIsExclusive:Boolean;
      
      public function ExchangeFilter(param1:int = -1, param2:Object = null)
      {
         super(param2);
         if(param1 != -1)
         {
            switch(param1)
            {
               case ExchangeShareMode.COMMUNITY:
                  if(SystemUtils.IsConsole && !SharedExchangeUtils.CheckCrossPlatformPlayPermitted())
                  {
                     this.createdByGroup = ExchangeFiltersData.CREATEDBY_CURRENT_PLATFORM;
                  }
                  else
                  {
                     this.createdByGroup = ExchangeFiltersData.DEFAULT_CREATEDBY_GROUP_COMMUNITY;
                  }
                  break;
               case ExchangeShareMode.LIBRARY:
                  this.createdByGroup = ExchangeFiltersData.DEFAULT_CREATEDBY_GROUP_LIBRARY;
                  break;
               case ExchangeShareMode.CG:
                  this.createdByGroup = ExchangeFiltersData.DEFAULT_CREATEDBY_GROUP_CG;
                  if(this.searchType != ExchangeFiltersData.SEARCH_TYPE_HASHTAG && this.searchText == "")
                  {
                     this.searchType = ExchangeFiltersData.SEARCH_TYPE_HASHTAG;
                     this.searchText = KeysEXCH.CG_ALL_HASHTAG.toString();
                  }
                  break;
               case ExchangeShareMode.MY_PROFILE:
                  this.createdByGroup = ExchangeFiltersData.DEFAULT_CREATEDBY_GROUP_MY_PROFILE;
            }
            this.show = ExchangeFiltersData.GetDefaultSortFilter(param1);
         }
         this.packIds = GameContent.GetAllPackIds().concat(GameContent.GetAllUGCPackIds());
      }
      
      public function Clone() : ExchangeFilter
      {
         var _loc1_:ExchangeFilter = new ExchangeFilter();
         _loc1_.type = this.type;
         _loc1_.bIncludeLocked = this.bIncludeLocked;
         _loc1_.bIncludeModded = this.bIncludeModded;
         _loc1_.createdByGroup = this.createdByGroup;
         _loc1_.cgChallenge = this.cgChallenge;
         _loc1_.householdSize = this.householdSize;
         _loc1_.venue = this.venue;
         _loc1_.lotSize = this.lotSize;
         _loc1_.lotPrice = this.lotPrice;
         _loc1_.roomType = this.roomType;
         _loc1_.roomSize = this.roomSize;
         _loc1_.roomPrice = this.roomPrice;
         _loc1_.searchType = this.searchType;
         _loc1_.searchText = this.searchText;
         _loc1_.show = this.show;
         _loc1_.startIndex = this.startIndex;
         _loc1_.endIndex = this.endIndex;
         _loc1_.pendingIndex = this.pendingIndex;
         _loc1_.species = this.species;
         _loc1_.bodyType = this.bodyType;
         _loc1_.bIsExclusive = this.bIsExclusive;
         return _loc1_;
      }
      
      public function GetSizeFilter() : int
      {
         switch(this.type)
         {
            case ExchangeData.TYPE_HOUSEHOLD:
               return this.householdSize;
            case ExchangeData.TYPE_BLUEPRINT:
               return this.lotSize;
            case ExchangeData.TYPE_ROOM:
               return this.roomSize;
            case ExchangeData.TYPE_BODY_PART:
               return this.bodyType;
            default:
               return 0;
         }
      }
      
      public function GetVenueType() : String
      {
         return this.type == ExchangeData.TYPE_BLUEPRINT ? this.venue : ExchangeFiltersData.DEFAULT_LOT_TYPE_VALUE;
      }
      
      public function SetSizeFilter(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case ExchangeData.TYPE_HOUSEHOLD:
               this.householdSize = param2;
               break;
            case ExchangeData.TYPE_BLUEPRINT:
               this.lotSize = param2;
               break;
            case ExchangeData.TYPE_ROOM:
               this.roomSize = param2;
         }
      }
      
      public function GetPriceFilter() : int
      {
         switch(this.type)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               return this.lotPrice;
            case ExchangeData.TYPE_ROOM:
               return this.roomPrice;
            default:
               return 0;
         }
      }
      
      public function GetBodyType() : int
      {
         switch(this.type)
         {
            case ExchangeData.TYPE_BODY_PART:
               return this.bodyType;
            default:
               return 0;
         }
      }
      
      public function SetPriceFilter(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BLUEPRINT:
               this.lotPrice = param2;
               break;
            case ExchangeData.TYPE_ROOM:
               this.roomPrice = param2;
         }
      }
      
      public function SetVenue(param1:int, param2:String) : void
      {
         this.venue = param1 == ExchangeData.TYPE_BLUEPRINT ? param2 : ExchangeFiltersData.DEFAULT_LOT_TYPE_VALUE;
      }
      
      public function SetBodyType(param1:int, param2:int) : void
      {
         switch(param1)
         {
            case ExchangeData.TYPE_BODY_PART:
               this.bodyType = param2;
         }
      }
      
      public function ToObjectCommon() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["type"] = this.type;
         _loc1_["show"] = this.show;
         _loc1_["size"] = this.GetSizeFilter();
         _loc1_["venue"] = this.GetVenueType();
         _loc1_["price"] = this.GetPriceFilter();
         _loc1_["bodyType"] = this.GetBodyType();
         _loc1_["createdByType"] = this.createdByGroup;
         _loc1_["cgChallenge"] = this.cgChallenge;
         _loc1_["searchType"] = this.searchType;
         _loc1_["searchText"] = this.searchText;
         _loc1_["bIncludeLocked"] = this.bIncludeLocked;
         _loc1_["bIncludeModded"] = this.bIncludeModded;
         _loc1_["bIsExclusive"] = this.bIsExclusive;
         _loc1_["roomType"] = this.roomType;
         _loc1_["species"] = this.species;
         var _loc2_:int = this.packIds.indexOf(GameContent.PACKID_UGC_GROUP);
         if(_loc2_ != -1)
         {
            this.packIds.splice(this.packIds.indexOf(GameContent.PACKID_UGC_GROUP),1);
         }
         var _loc3_:Array = GameContent.GetAllPackIds().concat(GameContent.GetAllUGCPackIds());
         _loc1_["packIds"] = this.packIds.length == _loc3_.length ? new Array() : this.packIds;
         return _loc1_;
      }
      
      public function ToObjectMySaves() : Object
      {
         return this.ToObjectCommon();
      }
      
      public function ToObjectGallery(param1:String, param2:Boolean = false) : Object
      {
         var _loc3_:Object = this.ToObjectCommon();
         _loc3_["startIndex"] = this.startIndex;
         _loc3_["endIndex"] = this.endIndex;
         _loc3_["pendingIndex"] = this.pendingIndex;
         _loc3_["transactionId"] = param1;
         _loc3_["bClearCache"] = param2;
         return _loc3_;
      }
      
      public function ToObjectPlayerProfile(param1:String) : Object
      {
         return this.ToObjectGallery(param1);
      }
   }
}

