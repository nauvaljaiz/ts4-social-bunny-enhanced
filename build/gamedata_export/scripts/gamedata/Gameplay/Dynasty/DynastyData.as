package gamedata.Gameplay.Dynasty
{
   import gamedata.Gameplay.Rewards.BucksData;
   import gamedata.Gameplay.shared.SetBuckFunds;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class DynastyData extends OlympusObject
   {
      
      protected static const SKILL:int = 0;
      
      protected static const IDEAL:int = 1;
      
      public var dynasty_id:String;
      
      public var name:String;
      
      public var description:String;
      
      public var icon:IconInfo = new IconInfo();
      
      public var icon_background:IconInfo = new IconInfo();
      
      public var head_sim_id:String;
      
      public var spouse_id:String;
      
      public var heir_sim_id:String;
      
      public var members:Array = [DynastyMemberData];
      
      public var skill_values:Array = [DynastyValueData];
      
      public var ideal_values:Array = [DynastyValueData];
      
      public var bucks_data:Array = [BucksData];
      
      public var alliances:Array = [DynastyAlliesRivalsData];
      
      public var rivalries:Array = [DynastyAlliesRivalsData];
      
      protected var mBucks:uint;
      
      public function DynastyData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:BucksData = null;
         super.ParseObject(param1);
         FixupArray(this.members);
         FixupArray(this.skill_values);
         FixupArray(this.ideal_values);
         FixupArray(this.bucks_data);
         this.mBucks = 0;
         for each(_loc2_ in this.bucks_data)
         {
            if(_loc2_.bucks_type == SetBuckFunds.BUCK_TYPE_DYNASTY_BUCKS)
            {
               this.mBucks = _loc2_.amount;
               break;
            }
         }
         if(Boolean(param1) && param1.hasOwnProperty("values"))
         {
            this.SetupValues(param1.values);
         }
      }
      
      public function get BucksAmount() : uint
      {
         return this.mBucks;
      }
      
      public function set BucksAmount(param1:uint) : void
      {
         this.mBucks = param1;
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["dynasty_id"] = this.dynasty_id ? this.dynasty_id : "0";
         _loc1_["name"] = this.name;
         _loc1_["description"] = this.description;
         _loc1_["icon"] = this.icon.icon;
         _loc1_["icon_background"] = this.icon_background.icon;
         _loc1_["members"] = this.MembersArrayToObject();
         _loc1_["spouse_id"] = this.spouse_id;
         _loc1_["values"] = this.ValuesArrayToObject();
         _loc1_["head_sim_id"] = this.head_sim_id;
         _loc1_["heir_sim_id"] = this.heir_sim_id ? this.heir_sim_id : "0";
         return _loc1_;
      }
      
      public function ValuesArrayToObject() : Array
      {
         var list:Array = this.skill_values.concat(this.ideal_values).map(function(param1:*):String
         {
            return String(param1.value_id);
         });
         return list;
      }
      
      public function MembersArrayToObject() : Array
      {
         var list:Array = this.members.map(function(param1:*):String
         {
            return String(param1.member_id);
         });
         return list;
      }
      
      public function MemberIndexById(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.members.length)
         {
            if(this.members[_loc2_].member_id == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function GetMemberStatusName(param1:String) : LocKey
      {
         var _loc2_:int = this.MemberIndexById(param1);
         if(_loc2_ <= -1)
         {
            return null;
         }
         if(param1 == this.head_sim_id)
         {
            return KeysGP.DYNASTY_HEAD_MEMBER;
         }
         if(param1 == this.heir_sim_id)
         {
            return KeysGP.DYNASTY_HEIR_MEMBER;
         }
         if(this.members[_loc2_].is_black_sheep)
         {
            return KeysGP.DYNASTY_BLACK_SHEEP_MEMBER;
         }
         return KeysGP.DYNASTY_MEMBER;
      }
      
      public function IsBlackSheep(param1:String) : Boolean
      {
         var _loc2_:int = this.MemberIndexById(param1);
         if(_loc2_ <= -1)
         {
            return false;
         }
         return this.members[_loc2_].is_black_sheep;
      }
      
      public function GetMemberRoleIconFrame(param1:String) : String
      {
         var _loc2_:int = this.MemberIndexById(param1);
         if(_loc2_ <= -1)
         {
            return null;
         }
         if(param1 == this.head_sim_id)
         {
            return DynastyTunableData.STATE_HEAD_MEMBER;
         }
         if(param1 == this.heir_sim_id)
         {
            return DynastyTunableData.STATE_HEIR_MEMBER;
         }
         if(this.members[_loc2_].is_black_sheep)
         {
            return DynastyTunableData.STATE_BLACK_SHEEP_MEMBER;
         }
         return DynastyTunableData.STATE_REGULAR_MEMBER;
      }
      
      public function GetMemberRank(param1:String) : int
      {
         var _loc2_:int = this.MemberIndexById(param1);
         if(_loc2_ <= -1)
         {
            return 0;
         }
         return this.members[_loc2_].member_rank;
      }
      
      protected function SetupValues(param1:Array) : void
      {
         var _loc2_:DynastyValueData = null;
         var _loc5_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in param1)
         {
            if(_loc5_ != null)
            {
               _loc2_ = new DynastyValueData(_loc5_);
               if(_loc5_.value_type == SKILL)
               {
                  _loc2_.CellViewIndex = _loc3_;
                  this.skill_values.push(_loc2_);
                  _loc3_++;
               }
               else
               {
                  _loc2_.CellViewIndex = _loc4_;
                  this.ideal_values.push(_loc2_);
                  _loc4_++;
               }
            }
         }
      }
   }
}

