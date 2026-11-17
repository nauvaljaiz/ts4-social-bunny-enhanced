package gamedata.CAS.Relationships
{
   import gamedata.CAS.shared.CASConfiguration;
   import gamedata.CAS.shared.CASStateData;
   import gamedata.CAS.shared.SimInfo;
   import gamedata.GameContent;
   import olympus.controls.objects.MenuItem;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysCAS;
   import olympus.localization.LocKey;
   import widgets.shared.constants.SimRelationship;
   
   public class CASSimRelationsData extends OlympusObject
   {
      
      public var simId:String;
      
      public var speciesType:int;
      
      public var age:int;
      
      public var simIndex:int;
      
      public var notifyBroken:Boolean;
      
      public var currentRelation:int;
      
      public var currentTrope:String;
      
      public var currentRomanceTrope:String;
      
      public var canModify:Boolean;
      
      public var canModifyTrope:Boolean;
      
      public var relOptions:Array = [int];
      
      public var breakingOptions:Array = [Boolean];
      
      protected var mSelectedRelationIndex:int;
      
      protected var mRelationDropdownOptions:Array;
      
      public var currentTropeId:String;
      
      protected var mSelectedTropeIndex:int;
      
      protected var mTropeDropdownOptions:Array;
      
      protected var mSelectedRomanceTropeIndex:int;
      
      protected var mRomanceTropeDropdownOptions:Array;
      
      public function CASSimRelationsData(param1:Object = null)
      {
         super(param1);
      }
      
      public function get SelectedIndex() : int
      {
         return this.mSelectedRelationIndex;
      }
      
      public function get DropdownOptions() : Array
      {
         return this.mRelationDropdownOptions;
      }
      
      public function get TropeDropdownOptions() : Array
      {
         return this.mTropeDropdownOptions;
      }
      
      public function get RomanceTropeDropdownOptions() : Array
      {
         return this.mRomanceTropeDropdownOptions;
      }
      
      public function get SelectedTropeIndex() : int
      {
         return this.mSelectedTropeIndex;
      }
      
      public function get SelectedRomanceTropeIndex() : int
      {
         return this.mSelectedRomanceTropeIndex;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.relOptions);
         FixupArray(this.breakingOptions);
      }
      
      public function GenerateRelationshipOptions(param1:SimInfo, param2:CASSimTropesStaticData, param3:CASSimRomanceTropesStaticData) : void
      {
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:LocKey = null;
         var _loc13_:Boolean = false;
         var _loc14_:String = null;
         var _loc4_:int = this.currentRelation;
         var _loc5_:Array = this.relOptions;
         var _loc6_:Array = this.breakingOptions;
         this.mRelationDropdownOptions = new Array();
         this.mTropeDropdownOptions = new Array();
         this.mRomanceTropeDropdownOptions = new Array();
         this.mSelectedRelationIndex = -1;
         this.mSelectedTropeIndex = 0;
         this.mSelectedRomanceTropeIndex = 0;
         var _loc7_:int = 0;
         var _loc8_:int = int(_loc5_.length);
         while(_loc7_ < _loc8_)
         {
            _loc9_ = int(_loc5_[_loc7_]);
            _loc10_ = Boolean(_loc6_[_loc7_]);
            _loc11_ = _loc9_ == _loc4_;
            if(_loc11_)
            {
               this.mSelectedRelationIndex = _loc7_;
            }
            _loc12_ = SimRelationship.GetRelationshipName(_loc9_,param1.speciesType,this.speciesType);
            _loc13_ = this.IsAvailableOption(param1,_loc9_);
            _loc14_ = _loc10_ ? KeysCAS.PERSONALITY_RELATIONSHIP_REMOVE_WARNING.toString() : null;
            this.mRelationDropdownOptions.push(new MenuItem(_loc12_ ? _loc12_.toString({"simId":this.simId}) : "",_loc9_,_loc13_,null,_loc13_ ? _loc14_ : KeysCAS.PERSONALITY_RELATIONSHIP_TOOLTIP_DISABLE_BY_REINCARNATION.toString()));
            if(GameContent.HAS_EP13)
            {
               this.mTropeDropdownOptions[_loc9_.toString()] = this.GetTropeDropdownItems(_loc9_,SimTropeItem.FAMILY_TROPE,param2,KeysCAS.PERSONALITY_FAMILY_TROPES_NONE,this.currentTrope,_loc11_);
            }
            if(GameContent.HAS_EP16)
            {
               this.mRomanceTropeDropdownOptions[_loc9_.toString()] = this.GetTropeDropdownItems(_loc9_,SimTropeItem.ROMANCE_TROPE,param3,KeysCAS.PERSONALITY_ROMANCE_TROPES_NONE,this.currentRomanceTrope,_loc11_);
            }
            _loc7_++;
         }
      }
      
      public function IsAvailableOption(param1:SimInfo, param2:int) : Boolean
      {
         if(!CASConfiguration.IsReincarnationMode)
         {
            return true;
         }
         if(!SimRelationship.IsRomanticRelationship(param2))
         {
            return true;
         }
         return !(param1.isCASReincarnating || CASStateData.SimIdIsReincarnating(this.simId));
      }
      
      public function GetTropeDropdownItems(param1:int, param2:int, param3:CASSimTropesStaticDataBase, param4:LocKey, param5:String, param6:Boolean) : Array
      {
         var _loc11_:String = null;
         var _loc12_:SimTropeItem = null;
         var _loc13_:Boolean = false;
         var _loc7_:Array = new Array();
         var _loc8_:String = param1.toString();
         var _loc9_:Array = param3.GetTropesFromRelationshipType(param1);
         _loc7_.push(new MenuItem(param4.toString(),{
            "trope_id":"0",
            "trope_type":param2,
            "rel_directionality":0,
            "rel_type":SimRelationship.NONE
         },true));
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc11_ = _loc9_[_loc10_];
            _loc12_ = param3.TropeIdToTropeItemMap[_loc11_];
            _loc13_ = _loc11_ == param5;
            if(param6)
            {
               if(param2 == SimTropeItem.FAMILY_TROPE)
               {
                  if(!this.CanHaveFamilyTrope(param1))
                  {
                     this.mSelectedTropeIndex = 0;
                     break;
                  }
                  if(_loc13_)
                  {
                     this.mSelectedTropeIndex = _loc10_ + 1;
                  }
                  param2 = SimTropeItem.FAMILY_TROPE;
               }
               else if(param2 == SimTropeItem.ROMANCE_TROPE)
               {
                  if(!this.CanHaveRomanceTrope(param1))
                  {
                     this.mSelectedRomanceTropeIndex = 0;
                     break;
                  }
                  if(_loc13_)
                  {
                     this.mSelectedRomanceTropeIndex = _loc10_ + 1;
                  }
                  param2 = SimTropeItem.ROMANCE_TROPE;
               }
            }
            _loc7_.push(new MenuItem(_loc12_.display_name.toString(),{
               "trope_id":_loc11_,
               "trope_type":param2,
               "rel_directionality":_loc12_.directionality,
               "rel_type":param1
            },true));
            _loc10_++;
         }
         return _loc7_;
      }
      
      public function CanHaveFamilyTrope(param1:int) : Boolean
      {
         if(param1 != SimRelationship.NONE && param1 != SimRelationship.FIANCE && param1 != SimRelationship.STEADY)
         {
            return true;
         }
         return false;
      }
      
      public function CanHaveRomanceTrope(param1:int) : Boolean
      {
         if(param1 == SimRelationship.STEADY || param1 == SimRelationship.FIANCE || param1 == SimRelationship.SPOUSE)
         {
            return true;
         }
         return false;
      }
   }
}

