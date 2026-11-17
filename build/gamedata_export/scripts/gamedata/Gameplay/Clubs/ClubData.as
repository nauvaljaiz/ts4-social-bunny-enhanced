package gamedata.Gameplay.Clubs
{
   import gamedata.Gameplay.Rewards.BucksData;
   import gamedata.Gameplay.shared.SetBuckFunds;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class ClubData extends OlympusObject
   {
      
      public static const MAX_NUM_MEMBERS:uint = 8;
      
      public static const STARTING_MEMBER_CAP:uint = 6;
      
      public static const MIN_NUM_GATHERING:int = 2;
      
      public static const MAX_SIM_CLUBS:uint = 3;
      
      public static const MAX_NUM_CONDUCT_RULES:int = 5;
      
      public static const MAX_NUM_MEMBERSHIP_CRITERIA:int = 5;
      
      public static const OUTFIT_SETTING_NONE:int = 0;
      
      public static const OUTFIT_SETTING_STYLE:int = 1;
      
      public static const OUTFIT_SETTING_COLOR:int = 2;
      
      public static const OUTFIT_SETTING_OUTFIT_OVERRIDE:int = 3;
      
      public static const HANGOUT_SETTING_NONE:int = 0;
      
      public static const HANGOUT_SETTING_VENUE:int = 1;
      
      public static const HANGOUT_SETTING_LOT:int = 2;
      
      public static const ICON_DEFAULT:String = "0xf14d4c33637bac5c";
      
      public var club_id:String;
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_small:ResourceKey = new ResourceKey();
      
      public var invite_only:Boolean;
      
      public var venue_type:ResourceKey = new ResourceKey();
      
      public var associated_color:uint;
      
      public var associated_style:uint;
      
      public var outfit_setting:int;
      
      public var hangout_setting:int;
      
      public var hangout_zone_id:String;
      
      public var members:Array = [String];
      
      public var member_cap:uint = 6;
      
      public var leader:String;
      
      public var membership_criteria:Array = [ClubCriteria];
      
      public var club_rules:Array = [ClubConductRule];
      
      public var bucks_data:Array = [BucksData];
      
      public var mbActiveSimInClub:Boolean = false;
      
      public var mbActiveSimEligible:Boolean = true;
      
      public var mBucks:uint;
      
      public var mGeneratedClubId:String;
      
      public function ClubData(param1:Object = null)
      {
         var _loc5_:BucksData = null;
         super(param1);
         FixupArray(this.members);
         FixupArray(this.membership_criteria);
         FixupArray(this.club_rules);
         FixupArray(this.bucks_data);
         if(this.icon.instance == "0")
         {
            this.icon.instance = ICON_DEFAULT;
         }
         var _loc2_:Array = this.members;
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            if(_loc2_[_loc3_] == this.leader)
            {
               _loc2_.splice(0,0,_loc2_.splice(_loc3_,1)[0]);
               break;
            }
            _loc3_++;
         }
         this.mBucks = 0;
         for each(_loc5_ in this.bucks_data)
         {
            if(_loc5_.bucks_type == SetBuckFunds.BUCK_TYPE_CLUB_BUCKS)
            {
               this.mBucks = _loc5_.amount;
               break;
            }
         }
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["club_id"] = this.club_id ? this.club_id : this.mGeneratedClubId;
         _loc1_["name"] = this.name;
         _loc1_["description"] = this.description;
         _loc1_["icon"] = this.icon.ToObject();
         _loc1_["invite_only"] = this.invite_only;
         _loc1_["venue_type"] = this.venue_type.ToObject();
         _loc1_["associated_color"] = this.associated_color;
         _loc1_["associated_style"] = this.associated_style;
         _loc1_["outfit_setting"] = this.outfit_setting;
         _loc1_["leader"] = this.leader;
         _loc1_["members"] = this.members;
         _loc1_["membership_criteria"] = this.CriteriaArrayToObject();
         _loc1_["club_rules"] = this.RulesArrayToObject();
         _loc1_["hangout_setting"] = this.hangout_setting;
         _loc1_["hangout_zone_id"] = this.hangout_zone_id;
         return _loc1_;
      }
      
      public function CriteriaArrayToObject() : Array
      {
         var _loc1_:int = int(this.membership_criteria.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.membership_criteria[_loc3_] as ClubCriteria).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function RulesArrayToObject() : Array
      {
         var _loc1_:int = int(this.club_rules.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.club_rules[_loc3_] as ClubConductRule).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

